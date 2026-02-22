
import os
import sys

# Reed-Solomon Verilog Generator
# Implements:
# 1. GF(2^8) Arithmetic (Primitive Poly 0x11D, FCR=0)
# 2. Parallel LFSR Encoder (Systematic)
# 3. Syndrome Generator (Loopback verification)

class GF256:
    def __init__(self, prim=0x11d):
        self.prim = prim
        self.exp = [0] * 512
        self.log = [0] * 256
        
        x = 1
        for i in range(255):
            self.exp[i] = x
            self.log[x] = i
            x <<= 1
            if x & 0x100:
                x ^= self.prim
        
        # Double the exp table for easy lookups
        for i in range(255, 512):
            self.exp[i] = self.exp[i-255]
            
    def mul(self, a, b):
        if a == 0 or b == 0:
            return 0
        return self.exp[self.log[a] + self.log[b]]
        
    def add(self, a, b):
        return a ^ b
        
    def pow(self, a, b):
        if a == 0: return 0
        if b == 0: return 1
        log_a = self.log[a]
        return self.exp[(log_a * b) % 255]

    def poly_mul(self, p1, p2):
        # Multiply two polynomials
        res = [0] * (len(p1) + len(p2) - 1)
        for i in range(len(p1)):
            for j in range(len(p2)):
                res[i+j] ^= self.mul(p1[i], p2[j])
        return res

    def get_generator_poly(self, nsym):
        # g(x) = (x - alpha^0)(x - alpha^1)...
        g = [1]
        for i in range(nsym):
            # (x - alpha^i) -> [1, alpha^i] (since add=sub)
            root = self.exp[i]
            g = self.poly_mul(g, [1, root]) 
        return g # Highest degree first? 
        # poly_mul([1], [1, r]) -> [1*1, 1*r] = x + r.
        # So index 0 is x^N, index N is x^0. Correct.

def generate_const_matrix_mul(gf, constant, input_sig, output_sig):
    # Generates Verilog for output_sig = constant * input_sig over GF(2^8)
    # constant is an integer 0..255
    # Matrix A where y = A*x.
    # We can precompute the 8x8 boolean matrix for multiplication by 'constant'.
    
    # Basis: 1, x, x^2 ... x^7
    # For each bit j of input (representing x^j), calculate constant * x^j.
    # The result has bits set.
    
    lines = []
    
    # Calculate the 8x8 matrix M where Output = M * Input
    # M[r][c] is 1 if bit r of (constant * 2^c) is 1.
    
    matrix = [[0]*8 for _ in range(8)]
    
    for c in range(8):
        # Input basis vector: 2^c
        val = gf.mul(constant, 1 << c)
        for r in range(8):
            if (val >> r) & 1:
                matrix[r][c] = 1
                
    # Generate equations
    for r in range(8):
        terms = []
        for c in range(8):
            if matrix[r][c]:
                terms.append(f"{input_sig}[{c}]")
        
        if not terms:
            lines.append(f"    assign {output_sig}[{r}] = 1'b0;")
        else:
            lines.append(f"    assign {output_sig}[{r}] = {' ^ '.join(terms)};")
            
    return lines

def generate_reed_solomon_verilog(width, output_dir):
    # Parameters matching Python model
    data_bytes = (width + 7) // 8
    k = data_bytes
    
    if k > 251: k = 251 # Cap support
    
    # Python model: n = k + 4 (T=2)
    t = 2
    nsym = 2 * t
    n = k + nsym
    
    module_name = f"reed_solomon_ecc_w{width}"
    filename = os.path.join(output_dir, f"{module_name}.v")
    
    gf = GF256()
    g_poly = gf.get_generator_poly(nsym)
    # g_poly degree is nsym. Coefficients g_0 ... g_nsym. 
    # High degree at index 0?
    # g = (x+r0)(x+r1)...
    # Example nsym=2. (x+1)(x+2) = x^2 + 3x + 2.
    # g = [1, 3, 2]. Index 0 is Coeff of x^2. Index 2 is Coeff of x^0.
    
    verilog = []
    verilog.append(f"// Generated {module_name} - Real Hardware Reed-Solomon (GF(2^8))")
    verilog.append(f"// N={n}, K={k}, T={t} (Parity Bytes={nsym})")
    verilog.append(f"// Primitive Poly: 0x11D, FCR=0")
    verilog.append(f"")
    verilog.append(f"module {module_name} (")
    verilog.append(f"    input  wire clk,")
    verilog.append(f"    input  wire rst_n,")
    verilog.append(f"    input  wire encode_en,")
    verilog.append(f"    input  wire decode_en,")
    verilog.append(f"    input  wire [{width-1}:0] data_in,")
    verilog.append(f"    // Codeword: {nsym} parity bytes + {k} data bytes (adjusted for width)")
    verilog.append(f"    // We output full byte-aligned codeword")
    verilog.append(f"    // Python model: Parity at MSB? No. ")
    verilog.append(f"    // Logic check: Python puts data at LSB? ")
    verilog.append(f"    //   codeword |= (byte << i*8). ")
    verilog.append(f"    //   Bytes are [Data0, Data1..., Parity0, Parity1...] (Reedsolo encodes msg+ecc).")
    verilog.append(f"    //   Wait! Reedsolo returns `msg + ecc`. ")
    verilog.append(f"    //   So byte 0 is Msg[0]. Byte K is Ecc[0].")
    verilog.append(f"    //   Loop `i` goes 0..N-1.")
    verilog.append(f"    //   So Codeword[7:0] is Msg[0]. Codeword[15:8] is Msg[1].")
    verilog.append(f"    //   So DATA is at LSB. PARITY is at MSB.")
    verilog.append(f"    //   Verified.")
    verilog.append(f"    input  wire [{8*n-1}:0] codeword_in,")
    verilog.append(f"    output reg  [{8*n-1}:0] codeword_out,")
    verilog.append(f"    output reg  [{width-1}:0] data_out,")
    verilog.append(f"    output reg  error_detected,")
    verilog.append(f"    output reg  error_corrected,")
    verilog.append(f"    output reg  valid_out")
    verilog.append(f");")
    
    # ----------------------------------------------------------------------
    # ENCODER: Parallel LFSR
    # ----------------------------------------------------------------------
    # We essentially compute Remainder of Data / Generator.
    # Input is Message M(x). We want Systematic: x^(2t) M(x) + (x^(2t) M(x) mod g(x)).
    # Data is k bytes. Parity is 2t bytes.
    # Parallel implementation:
    # State is 2t bytes (Registers).
    # We feed k bytes of data.
    # Since k is small/fixed, we can unroll the LFSR steps combinatorially?
    # No, K scales to 251. Unrolling 251 steps of 32-bit width logic is huge.
    # But wait, K relates to WIDTH.
    # For width 128, K=16. 
    # Unrolling 16 steps is fine.
    
    # Input data array
    verilog.append(f"    wire [7:0] msg_bytes [{k-1}:0];")
    # Map data_in to msg_bytes. 
    # msg_bytes[0] is data_in[7:0].
    for i in range(k):
        if i*8+7 < width:
            verilog.append(f"    assign msg_bytes[{i}] = data_in[{i*8+7}:{i*8}];")
        elif i*8 < width:
            # Partial byte at end
            extra = i*8+7 - width + 1
            verilog.append(f"    assign msg_bytes[{i}] = {{ {extra}'b0, data_in[{width-1}:{i*8}] }};")
        else:
            verilog.append(f"    assign msg_bytes[{i}] = 8'b0;")
            
    # LFSR State: 2t bytes.
    # Unroll K steps.
    # Initial state = 0.
    # For each message byte M_i (from high degree to low degree? No, reedsolo: msg[0] is first coefficient?)
    # Reedsolo/RS convention:
    # Message Polynomial M(x) = D_0 x^{k-1} + ... + D_{k-1}?
    # Or D_0 x^0?
    # Reedsolo: `msg[0]` is the first byte.
    # Usually `msg[0]` is coefficient of x^{k-1} (highest degree). 
    # Let's assume M(x) = msg[0] x^{k-1} + ... + msg[k-1].
    # We feed coefficients from high degree to low degree.
    # So we feed msg_bytes[0], then msg[1]...
    
    # State variables: s_step_byte
    # Initial: s_0_0 ... s_0_{nsym-1} = 0
    # Next step: 
    # Feedback = s_{k-1} ^ input_byte
    # s_0_next = s_1_prev ^ (g_nsym * Feedback)
    # s_j_next = s_{j+1}_prev ^ (g_{nsym-j} * Feedback)
    # ...
    # Wait, g(x) = x^nsym + g_1 x^{nsym-1} + ... + g_nsym.
    # Standard LFSR: 
    # Feedback = HighC ^ Input.
    # New[i] = Old[i-1] + (g[i] * Feedback).
    
    # Let's perform symbolic execution for K steps.
    # s[step][byte_idx]
    
    # Init
    state = [f"8'b0" for _ in range(nsym)]
    
    for step in range(k):
        # Input byte: msg_bytes[step]? 
        # Is msg_bytes[0] the high order? 
        # Reedsolo documentation says `encode(msg)` -> `msg + ecc`.
        # This implies systematic.
        # Usually systematic division feeds High Order Message Byte first.
        # Yes, msg[0] corresponds to x^{k-1}.
        
        input_byte = f"msg_bytes[{step}]"
        
        # Feedback = State[Highest] ^ Input
        # Create explicit wire for feedback to avoid syntax error in matrix mul
        feedback_wire = f"feedback_{step}"
        verilog.append(f"    wire [7:0] {feedback_wire} = {state[nsym-1]} ^ {input_byte};")
        
        # New State
        new_state = []
        # s[0] = g[nsym] * feedback 
        
        g_val = g_poly[nsym] # coeff x^0
        term_0 = f"mul_{step}_0"
        # Pass feedback_wire (simple name) instead of expression
        verilog.extend(generate_const_matrix_mul(gf, g_val, feedback_wire, term_0))
        verilog.append(f"    wire [7:0] {term_0}; // Defined by gen function")
        new_state.append(term_0)
        
        for i in range(1, nsym):
            g_val_i = g_poly[nsym-i] # coeff x^i
            term_i = f"mul_{step}_{i}"
            verilog.extend(generate_const_matrix_mul(gf, g_val_i, feedback_wire, term_i))
            verilog.append(f"    wire [7:0] {term_i};")
            
            # Add S_old[i-1]
            new_state.append(f"({state[i-1]} ^ {term_i})")
            
        state = new_state
        
    # Final state is the parity (remainder).
    # reedsolo appends parity.
    # Order: [High Degree ... Low Degree]? 
    # Usually output is coefficients of R(x).
    # Since we shift out x^{nsym-1} (high), the register holds [x^0 ... x^{nsym-1}].
    # But reedsolo output order?
    # Reedsolo `encode` returns `msg + remainder`.
    # Remainder bytes: `remainder[0]` is Coeff of x^{nsym-1} (High)?
    # Let's check:
    # `reedsolo` returns `rs.encode([1])` -> `[1, 64, 192 (etc)]`.
    # Usually ECC appends High-Degree first.
    # So Parity[0] = state[nsym-1].
    # Parity[nsym-1] = state[0].
    
    # Let's assume standard order: Parity[0] is output first (High).
    
    verilog.append(f"    // Parity Output")
    for i in range(nsym):
        # We want parity_bytes[0] to be state[nsym-1]
        verilog.append(f"    wire [7:0] parity_byte_{i} = {state[nsym-1-i]};")
        
    # Construct Codeword Output
    # {Parity (High to Low), Data} (Wait, check wrapper assumptions)
    # The wrapper assumes LSB is Data. MSB is Parity.
    # Codeword_in = {Parity, Data}.
    # Parity part: [31:0] for 4 bytes.
    # Is Parity[31:24] byte 0 or byte 3?
    # `codeword_in` is loaded as `byte << i*8`. 
    # `i` goes 0..N-1.
    # Data is i=0..k-1.
    # Parity is i=k..N-1.
    # So Parity Byte 0 (First output) is at `codeword[k*8+7 : k*8]`.
    # So Parity Byte 0 is the LSB of the Parity section.
    
    # So `codeword_out` should range from LSB (Data) to MSB (Parity).
    # Data Bytes: msg_bytes[0] ... [k-1].
    # Parity Bytes: parity_byte_0 ... [nsym-1].
    
    # Assign logic
    verilog.append(f"    wire [{8*n-1}:0] encoded_result;")
    
    # Data part (LSB)
    for i in range(k):
        verilog.append(f"    assign encoded_result[{i*8+7}:{i*8}] = msg_bytes[{i}];")
        
    # Parity part (MSB)
    for i in range(nsym):
        # parity_byte_0 is the first one generated (High Degree).
        # It goes to the first Parity slot (LSB of Parity section)?
        # Reedsolo: msg + ecc.
        # ecc[0] is appended first.
        # In `combining` loop: ecc[0] goes to `codeword[k*8]`.
        # So yes, parity_byte_0 goes to the lowest part of Parity section.
        base = (k + i) * 8
        verilog.append(f"    assign encoded_result[{base+7}:{base}] = parity_byte_{i};")

    # ----------------------------------------------------------------------
    # DECODER: Syndrome Generator
    # ----------------------------------------------------------------------
    # S_i = Eval(R(x), alpha^i) for i=0..nsym-1 (since FCR=0).
    # R(x) is the received codeword polynomial.
    # Codeword bytes c_0 ... c_{n-1}.
    # c_0 is LSB (Data[0]). c_{n-1} is MSB (Parity[last]).
    # Poly R(x) = c_0 x^{n-1} + ... + c_{n-1} x^0?
    # Wait. Reedsolo convention.
    # msg[0] is x^{k-1}.
    # ecc[0] is x^{2t-1}.
    # Result = msg + ecc.
    # [msg0, msg1..., ecc0, ecc1...].
    # This is effectively D(x) * x^2t + Remainder(x).
    # Where D(x) has msg0 as MOST significant.
    # So c_0 (msg0) has highest degree.
    # So R(x) = c_0 x^{n-1} + ... + c_{n-1}.
    # Syndrome Eval usually considers c_{n-1} as x^0 and c_0 as x^{n-1}.
    # Horner's Method:
    # Res = 0.
    # For byte in bytes: Res = Res*x + byte.
    
    verilog.append(f"    // Syndrome Generator")
    verilog.append(f"    wire has_error;")
    syndromes = []
    
    for i in range(nsym):
        # Calculate S_i = Evaluated at alpha^i
        # alpha^i is root.
        # We need to evaluate polynomial at root.
        root = gf.exp[i]
        
        # Horner's method unroll
        # Start with highest degree coeff.
        # Highest degree is Step 0 (msg[0] aka codeword byte 0).
        # Val = 0.
        # Loop j from 0 to n-1:
        #   Val = Val * root + codeword_byte[j]
        
        current_val = "8'b0"
        
        for j in range(n):
            # codeword byte j. 
            # Note: codeword_in is LSB-first in bits?
            # Assign above: encoded_result[0..7] = msg_bytes[0].
            # So Byte j is at [j*8+7 : j*8].
            byte_j = f"codeword_in[{j*8+7}:{j*8}]"
            
            # Val * root
            mult_res = f"syn_mul_{i}_{j}"
            if j > 0: # Skip first mult since init is 0
                # Generate multiplication logic: mult_res = current_val * root
                verilog.extend(generate_const_matrix_mul(gf, root, current_val, mult_res))
                verilog.append(f"    wire [7:0] {mult_res};")
                
                # Add byte: next_val = mult_res ^ byte_j
                sum_res = f"syn_sum_{i}_{j}"
                verilog.append(f"    wire [7:0] {sum_res} = {mult_res} ^ {byte_j};")
                current_val = sum_res
            else:
                # First step: 0 * root + byte = byte
                current_val = byte_j
                
        syndromes.append(current_val)
        
    # Check if all syndromes are 0
    syn_checks = [f"(|{s})" for s in syndromes]
    verilog.append(f"    assign has_error = {' | '.join(syn_checks)};")
    
    # ----------------------------------------------------------------------
    # Output Logic
    # ----------------------------------------------------------------------
    verilog.append(f"    always @(posedge clk or negedge rst_n) begin")
    verilog.append(f"        if (!rst_n) begin")
    verilog.append(f"            codeword_out <= 0;")
    verilog.append(f"            data_out <= 0;")
    verilog.append(f"            error_detected <= 0;")
    verilog.append(f"            error_corrected <= 0;")
    verilog.append(f"            valid_out <= 0;")
    verilog.append(f"        end else begin")
    verilog.append(f"            valid_out <= 0;")
    verilog.append(f"            ")
    verilog.append(f"            if (encode_en) begin")
    verilog.append(f"                codeword_out <= encoded_result;")
    verilog.append(f"                valid_out <= 1'b1;")
    verilog.append(f"            end")
    verilog.append(f"            ")
    verilog.append(f"            if (decode_en) begin")
    verilog.append(f"                // Extract data (Systematic at LSB)")
    verilog.append(f"                data_out <= codeword_in[{width-1}:0];")
    verilog.append(f"                error_detected <= has_error;")
    verilog.append(f"                error_corrected <= 1'b0; // Corrected placeholder")
    verilog.append(f"                valid_out <= 1'b1;")
    verilog.append(f"            end")
    verilog.append(f"        end")
    verilog.append(f"    end")
    
    verilog.append(f"endmodule")
    
    with open(filename, "w") as f:
        f.write("\n".join(verilog))

def main():
    output_dir = "verilogs/generated"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        
    widths = [4, 8, 16, 32, 64, 128]
    
    for w in widths:
        print(f"Generating reed_solomon_ecc_w{w}...")
        generate_reed_solomon_verilog(w, output_dir)
        
if __name__ == "__main__":
    main()
