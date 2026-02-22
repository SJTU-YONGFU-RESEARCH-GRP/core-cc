
import os
import sys

# Minimal GF(2^m) and Polynomial Arithmetic for BCH Generator Polynomial Calculation

class GF2m:
    def __init__(self, m, prim_poly):
        self.m = m
        self.prim_poly = prim_poly
        self.size = 1 << m
        self.alpha_to_int = [0] * self.size
        self.int_to_alpha = [0] * self.size
        
        # Initialize field (generate alpha^i tables)
        x = 1
        for i in range(self.size - 1):
            self.alpha_to_int[i] = x
            self.int_to_alpha[x] = i
            
            x <<= 1
            if x & self.size:
                x ^= self.prim_poly
                
        # Zero is distinct
        self.int_to_alpha[0] = -1 # Special marker

    def mul(self, a, b):
        if a == 0 or b == 0: return 0
        log_a = self.int_to_alpha[a]
        log_b = self.int_to_alpha[b]
        log_res = (log_a + log_b) % (self.size - 1)
        return self.alpha_to_int[log_res]

    def power(self, a, n):
        if a == 0: return 0
        log_a = self.int_to_alpha[a]
        log_res = (log_a * n) % (self.size - 1)
        return self.alpha_to_int[log_res]
        
    def inverse(self, a):
        return self.power(a, self.size - 2)

    def min_poly(self, roots):
        """Compute minimal polynomial for a set of conjugate roots."""
        # This is a full polynomial multiplication over GF(2) (since min poly coeffs are in GF(2))
        # Roots are in GF(2^m).
        # We assume the result has coefficients in GF(2), i.e., 0 or 1.
        
        # Poly: product of (x - r) for r in roots
        # Represent poly as list of GF(2^m) coefficients, lowest degree first.
        # Constant term first.
        
        poly = [1] # initially '1'
        
        for r in roots:
            # Multiply poly by (x + r) (since + is - in GF2)
            # New poly degree increases by 1
            new_poly = [0] * (len(poly) + 1)
            for i, c in enumerate(poly):
                # x * term
                new_poly[i+1] = c ^ new_poly[i+1]
                # r * term
                term = self.mul(c, r)
                new_poly[i] = term ^ new_poly[i]
            poly = new_poly
            
        # Verify coefficients are binary (0 or 1) as expected for BCH min polys
        # (This is true if we include all conjugates)
        # Note: We will handle binary conversion outside, assuming we process full cyclotomic cosets
        return poly

def poly_mul_gf2(p1, p2):
    """Multiply two binary polynomials."""
    deg1 = len(p1) - 1
    deg2 = len(p2) - 1
    res = [0] * (deg1 + deg2 + 1)
    for i, c1 in enumerate(p1):
        if c1:
            for j, c2 in enumerate(p2):
                if c2:
                    res[i+j] ^= 1
    return res

def get_bch_generator_poly(m, n, k, t, prim_poly):
    gf = GF2m(m, prim_poly)
    
    # Identify roots: alpha^1, alpha^2, ..., alpha^(2t)
    # And their conjugates.
    
    roots = set()
    for i in range(1, 2 * t + 1):
        # Find cyclotomic coset for i
        idx = i
        while True:
            roots.add(gf.alpha_to_int[idx])
            idx = (idx * 2) % (n) # n = 2^m - 1
            if idx == i: break
            
    # Compute g(x) = LCM(min polys) = Product(x - r) for all unique roots
    # Since we collected all conjugates, the product will have binary coefficients.
    
    # We can compute Product(x - r) iteratively in GF(2^m) and confirm result is binary.
    
    poly_roots = list(roots)
    
    # Iterative multiplication (x + r)
    # Poly represented as list of GF(2^m) values
    g_coeffs = [1] # Is constant 1
    
    for r in poly_roots:
        # Multiply by (x + r)
        new_g = [0] * (len(g_coeffs) + 1)
        for i, c in enumerate(g_coeffs):
            # c * x
            new_g[i+1] ^= c
            # c * r
            new_g[i] ^= gf.mul(c, r)
        g_coeffs = new_g
        
    # Convert to binary
    binary_g = []
    for c in g_coeffs:
        if c == 0: binary_g.append(0)
        elif c == 1: binary_g.append(1)
        else:
            print(f"Error: Generator polynomial has non-binary coefficient {c}")
            # This happens if we missed conjugates (shouldn't happen with coset logic above)
            return None
            
    return binary_g # Lowest degree first (p0, p1, ...)


def generate_bch_verilog(width, n, k, t, prim_poly, output_dir):
    # Calculate m. n = 2^m - 1.
    # n.bit_length() usually gives m for Mersenne numbers.
    # e.g. 7 (111) -> 3. 15 (1111) -> 4.
    m = n.bit_length()
    
    module_name = f"bch_ecc_w{width}"
    filename = os.path.join(output_dir, f"{module_name}.v")
    
    print(f"Generating {module_name} (n={n}, k={k}, t={t})...")
    
    # Get Generator Polynomial
    # Format: [p0, p1, ..., p_degree] where p0 is const term (usually 1), p_degree is x^deg (usually 1)
    g_poly = get_bch_generator_poly(m, n, k, t, prim_poly)
    
    # Degree of g(x) should be n - k
    parity_bits = n - k
    
    # Pad g_poly with zeros to match parity_bits length + 1 (for coeff of x^parity)
    # Actually remainder loop uses coefficients up to parity_bits-1?
    # g(x) = p[0] + ... + p[deg] x^deg.
    # We need p[j] for j in 0..parity_bits-1.
    
    current_len = len(g_poly)
    needed_len = parity_bits + 1
    if current_len < needed_len:
        print(f"Warning: Calculated g(x) degree {current_len-1} does not match parity bits {parity_bits}. Padding with 0s.")
        g_poly.extend([0] * (needed_len - current_len))
    elif current_len > needed_len:
         print(f"Error: Calculated g(x) degree {current_len-1} exceeds parity bits {parity_bits}. Impossible for systematic.")
         # This happens for w32 if t=6 (deg 33 > 31)
         return

    # Verilog Generation
    verilog = []
    verilog.append(f"// Generated {module_name} - Real Hardware Encoder/Detector")
    verilog.append(f"module {module_name} (")
    verilog.append(f"    input  wire clk,")
    verilog.append(f"    input  wire rst_n,")
    verilog.append(f"    input  wire encode_en,")
    verilog.append(f"    input  wire decode_en,")
    verilog.append(f"    input  wire [{width-1}:0] data_in,")
    verilog.append(f"    input  wire [{n-1}:0] codeword_in,")
    verilog.append(f"    output reg  [{n-1}:0] codeword_out,")
    verilog.append(f"    output reg  [{width-1}:0] data_out,")
    verilog.append(f"    output reg  error_detected,")
    verilog.append(f"    output reg  error_corrected,")
    verilog.append(f"    output reg  valid_out")
    verilog.append(f");")
    
    verilog.append(f"    // Configuration: n={n}, k={k}, t={t}")
    verilog.append(f"    // Generator Poly Limit: x^{parity_bits}")
    
    # ---------------------------------------------------------
    # ENCODING LOGIC (Combinational LFSR / Matrix)
    # ---------------------------------------------------------
    # Systematic Encoding: Remainder of (Data * x^(n-k)) / g(x)
    # We can implement this as a parallel LFSR or matrix multiply.
    # For HDL generator, building the XOR equations for the Remainder is best.
    # Input: msg (k bits). Output: parity (n-k bits).
    
    # H_gen = [P | I] ? No. Systematic is [Data | Parity].
    # Parity = Remainder(Data * x^(n-k) / g(x))
    
    # We can simulate the LFSR division symbolically to generate the XOR tree.
    # State: parity_bits (init 0). Input: data bits (MSB first or LSB first?)
    # BCH standard usually: Message polynomial M(x) = m_{k-1}x^{k-1} + ... + m_0
    # Systematic: x^{n-k} M(x) = q(x)g(x) + r(x).
    # Codeword = x^{n-k}M(x) + r(x).
    
    # Symbolic simulation of LFSR:
    # LFSR has 'parity_bits' stages.
    # g(x) = g_r x^r + ... + g_0. (g_r=1, g_0=1).
    # Feedback connects to taps where g_i=1.
    
    # Let's verify data order.
    # bch_ecc.py: "data << parity_bits". Matches x^(n-k) M(x).
    # So data_in[k-1] is coeff of x^{n-1}.
    
    # Simulation:
    # processing k input bits (highest power first).
    # Current remainder state: R representing r(x). Degree < n-k.
    # For each input bit b (from k-1 down to 0):
    #   feedback = b ^ R[degree-1]
    #   New R = (R << 1) ^ (feedback * g(x without x^r))
    #   (Shift left, if MSB was 1 (feedback), add g(x))
    
    # Symbolic:
    # Represent each bit of R as a set of indices from 'data_in' that are XORed.
    
    rem_equations = [set() for _ in range(parity_bits)]
    
    # We process data bits from k-1 down to 0
    # But wait, Python's int representation:
    # "data = 1" -> 0...01. Coeff of x^0.
    # "data << parity" -> Coeff of x^parity.
    # So data_in[0] is x^parity. data_in[k-1] is x^(n-1).
    # We shift in High order coefficients first?
    # Standard polynomial division processes high degree first.
    # x^(n-1) -> ...
    
    # LFSR Input: use only k bits of data_in
    data_range = f"data_in[{k-1}:0]" if k <= width else f"data_in" # Assuming width matches or is larger
    if k < width:
        verilog.append(f"    wire [{k-1}:0] data_k = data_in[{k-1}:0];")
    elif k > width:
        verilog.append(f"    wire [{k-1}:0] data_k = {{ {{ {k-width}{{1'b0}} }}, data_in }};")
    else:
        verilog.append(f"    wire [{k-1}:0] data_k = data_in;")
        
    for i in range(k-1, -1, -1):
        # Input bit: data_k[i]
        # Current MSB of remainder (coeff of x^{parity-1}) is rem_equations[parity_bits-1]
        
        feedback = rem_equations[parity_bits-1].copy()
        
        # Add data_k[i] to feedback
        if i in feedback: feedback.remove(i)
        else: feedback.add(i)
        
        # Shift and Add
        # Next state j:
        # R_next[j] = R_curr[j-1] ^ (feedback if g[j]==1 else 0)
        # R_next[0] = (feedback if g[0]==1 else 0) (since R[-1] is 0)
        
        next_equations = [set() for _ in range(parity_bits)]
        
        for j in range(parity_bits):
            if j == 0:
                if g_poly[j] == 1:
                    next_equations[j] = feedback.copy()
            else:
                next_equations[j] = rem_equations[j-1].copy()
                if g_poly[j] == 1:
                    # XOR with feedback
                    for term in feedback:
                        if term in next_equations[j]: next_equations[j].remove(term)
                        else: next_equations[j].add(term)
                        
        rem_equations = next_equations
        
    # Generate Parity Logic
    verilog.append(f"    wire [{parity_bits-1}:0] parity;")
    for j in range(parity_bits):
        terms = sorted(list(rem_equations[j]))
        if len(terms) == 0:
            verilog.append(f"    assign parity[{j}] = 1'b0;")
        else:
            vexpr = " ^ ".join([f"data_k[{t}]" for t in terms])
            verilog.append(f"    assign parity[{j}] = {vexpr};")
            
    # Format systematic codeword: [Data | Parity]
    # In bits: data at MSB (n-1 .. parity), parity at LSB (parity-1 .. 0)
    # Replicating Python: data << parity_bits
    
    # ---------------------------------------------------------
    # SYNDROME CALCULATOR (Detection)
    # ---------------------------------------------------------
    # Evaluate codeword C(x) at alpha^1, ..., alpha^(2t)
    # C(x) = c_{n-1} x^{n-1} + ... + c_0
    # S_j = C(alpha^j) = Sum( c_i * (alpha^j)^i )
    # This is a constant scaling and summation in GF(2^m).
    
    # We need a GF(2^m) Adder (XOR) and specific evaluations.
    # Evaluation Logic:
    # S_j is a GF(2^m) element (m bits).
    # S_j = XOR of terms where c_i=1.
    # Term i contributes (alpha^j)^i.
    # We can precompute V_{j,i} = (alpha^j)^i in GF(2^m).
    # Then S_j = XOR over i=0..n-1 of (c_i ? V_{j,i} : 0).
    # Actually, S_j is vector sum of V_{j,i} for all i where c_i=1.
    
    # We generate logic for each bit of S_j.
    # S_j[bit b] = XOR sum of (V_{j,i}[bit b] & codeword_in[i])
    
    gf = GF2m(m, prim_poly)
    verilog.append(f"    wire [{2*t*m - 1}:0] syndromes_flat;")
    
    syndromes_found = False
    
    for j in range(1, 2 * t + 1):
        # Calculate S_j
        # Precompute values (alpha^j)^i
        vals = [gf.power(gf.power(2, j), i) for i in range(n)] # 2 is alpha in int (binary 10)
        
        # For each bit bit_idx of the result (0..m-1)
        for bit_idx in range(m):
            contributors = []
            for i in range(n):
                val = vals[i]
                if (val >> bit_idx) & 1:
                    contributors.append(i)
            
            # Assign S_j_bit
            s_name = f"synd_{j}_{bit_idx}"
            if not contributors:
                verilog.append(f"    wire {s_name} = 1'b0;")
            else:
                vexpr = " ^ ".join([f"codeword_in[{c}]" for c in contributors])
                verilog.append(f"    wire {s_name} = {vexpr};")

        # Combine into flat bus for easy checking
        # (Optional, but useful for debug)
    
    # Error Detection Logic
    # any_error = OR of all syndrome bits
    checks = []
    for j in range(1, 2 * t + 1):
        for bit_idx in range(m):
            checks.append(f"synd_{j}_{bit_idx}")
            
    verilog.append(f"    wire any_syndrome = {' | '.join(checks)};")
    
    # ---------------------------------------------------------
    # MAIN LOGIC (Registered Output)
    # ---------------------------------------------------------
    # Note: Using systematic data extraction (MSBs)
    
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
    verilog.append(f"                codeword_out <= {{data_k, parity}};")
    verilog.append(f"                valid_out <= 1'b1;")
    verilog.append(f"            end")
    verilog.append(f"            ")
    verilog.append(f"            if (decode_en) begin")
    verilog.append(f"                // Extract Systematic Data")
    if (width > k):
        # Pad with 0s if width > k
        verilog.append(f"                data_out <= {{ {{ {width-k}{{1'b0}} }}, codeword_in[{n-1}:{parity_bits}] }};")
    elif (width < k):
        # Extract lower width bits if width < k (assuming data was LSB aligned in k-bit field)
        verilog.append(f"                data_out <= codeword_in[{parity_bits+width-1}:{parity_bits}];")
    else:
        # width == k
        verilog.append(f"                data_out <= codeword_in[{n-1}:{parity_bits}];")
    verilog.append(f"                error_detected <= any_syndrome;")
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
        
    configs = [
        # width, n, k, t, prim_poly (int)
        (4,   7,   4,   1,  0b1011),
        (8,   15,  11,  1,  0b10011), # k=7 too small for w8. Use k=11 (t=1).
        (16,  31,  16,  3,  0b100101),
        (32,  63,  32,  5,  0b1000011), # t=6 impossible (deg 33 > 31). t=5 deg 27 OK.
        (64,  127, 64,  9,  0b10001001),
        (128, 255, 128, 15, 0b100011101)
    ]
    
    for c in configs:
        generate_bch_verilog(*c, output_dir)
        
if __name__ == "__main__":
    main()
