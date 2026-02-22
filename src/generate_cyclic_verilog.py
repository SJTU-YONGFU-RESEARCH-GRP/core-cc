import os
import sys

class CyclicGenerator:
    def __init__(self, width):
        self.width = width
        # Use CRC-32 Polynomial: 0x04C11DB7 for robust detection/correction capability
        # x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
        self.poly_degree = 32
        self.poly = 0x04C11DB7
        
        # Adjust for small widths: if width <= 16, maybe use CRC-16 (0x1021) or CRC-8?
        # To make it "Real", we should use appropriate overhead.
        # W=4: CRC-4? (x^4+x+1) -> 0x3
        # W=8: CRC-8? (0x07)
        # W=16: CRC-16-CCITT (0x1021)
        # W>=32: CRC-32 (0x04C11DB7)
        
        if width <= 4:
            self.poly_degree = 4
            self.poly = 0x3 # x^4+x+1
        elif width <= 8:
            self.poly_degree = 8
            self.poly = 0x07 # ATM-8
        elif width <= 16:
            self.poly_degree = 16
            self.poly = 0x1021 # CCITT
        else:
            self.poly_degree = 32
            self.poly = 0x04C11DB7
            
        self.n = width + self.poly_degree
        self.lines = []

    def add_line(self, line):
        self.lines.append(line)

    def calc_crc_matrix(self, num_bits):
        # Calculate the matrix M such that CRC(data) = data * M
        # Only relevant for parallel LFSR limits.
        # But we can simulate the LFSR state transition.
        pass

    def generate_lfsr_logic(self, input_name, output_name, input_width):
        # Generates parallel LFSR logic (Combinational)
        # We simulate the shift register steps for 'input_width' cycles.
        
        # State: poly_degree bits.
        # Logic:
        # state = 0
        # for bit in data:
        #   feedback = state[high] ^ bit
        #   state = (state << 1) ^ (feedback ? poly : 0)
        
        # In hardware parallel:
        # We express final state bits as XOR sum of input bits.
        
        # Precompute the dependency matrix:
        # Matrix[r][c] = 1 if output_bit_r depends on input_bit_c
        # Initialization
        # We also need to account for 'initial state' if we were chaining, but here it's block code -> 0.
        
        # Let's use a symbolic simulation.
        # state_exprs = [set() for _ in range(self.poly_degree)] # Set of input bit indices
        # Actually, linear combination.
        
        # Input bits: D[0]..D[width-1]. (D[width-1] is first in?)
        # Let's assume D[width-1] enters first (Big Endian) or D[0]?
        # Standard: MSB first.
        
        # State bits: S[0]..S[degree-1]
        
        # Symbolic state: list of sets. state[i] contains indices of data inputs that are XORed.
        state = [set() for _ in range(self.poly_degree)]
        
        for i in range(input_width):
            # Process bit D[input_width - 1 - i]
            input_bit_idx = input_width - 1 - i
            
            # Pop MSB
            feedback = state[self.poly_degree - 1].copy()
            # XOR with input bit
            if input_bit_idx in feedback:
                feedback.remove(input_bit_idx)
            else:
                feedback.add(input_bit_idx)
            
            # Shift
            for j in range(self.poly_degree - 1, 0, -1):
                state[j] = state[j-1].copy()
                if (self.poly >> j) & 1:
                    # XOR with feedback
                    state[j].symmetric_difference_update(feedback)

            state[0] = set() # Shift in 0
            if (self.poly >> 0) & 1:
                 state[0].symmetric_difference_update(feedback)
            # Actually, standard LFSR feed input at S[0]? 
            # Or Feed input into feedback?
            # Standard CRC: Input XOR MSB -> Feedback.
            # Then Feedback XORs into taps.
            # Shift: S[i] = S[i-1] ^ (dup ? feedback : 0).
            # S[0] = feedback. (If poly has +1).
            
            # Correct logic:
            # S_next[0] = feedback
            # S_next[i] = S[i-1] ^ (poly[i] ? feedback : 0)
            
            new_state = [set() for _ in range(self.poly_degree)]
            new_state[0] = feedback
            for j in range(1, self.poly_degree):
                new_state[j] = state[j-1].copy()
                if (self.poly >> j) & 1:
                    new_state[j].symmetric_difference_update(feedback)
            state = new_state

        # Generate Verilog assignments
        for r in range(self.poly_degree):
            if not state[r]:
                self.add_line(f"    assign {output_name}[{r}] = 1'b0;")
            else:
                terms = [f"{input_name}[{idx}]" for idx in sorted(list(state[r]))]
                self.add_line(f"    assign {output_name}[{r}] = {' ^ '.join(terms)};")

    def calc_syndrome_map(self):
        # Calculate expected syndrome for each single bit error
        # Error at position i (0..N-1)
        # E(x) = x^i.
        # Syndrome = E(x) mod P(x).
        
        syndrome_map = {}
        
        # For data bits (shifted by degree): x^(i+degree)
        # For check bits (at bottom): x^i
        
        # Error in Check Bit k (0..degree-1): Syndrome is just x^k mod P(x) = x^k.
        # So Syndrome = 1 << k.
        
        for k in range(self.poly_degree):
            err_pos_in_codeword = k
            syn = 1 << k
            syndrome_map[syn] = err_pos_in_codeword
            
        # Error in Data Bit k (0..width-1):
        # Position in codeword is k + degree.
        # We need remainder of x^(k + degree) / P(x).
        for k in range(self.width):
            err_pos_in_codeword = k + self.poly_degree
            
            # Simulate LFSR for single 1 at input bit k
            # Input vector has 1 at k, 0 elsewhere.
            # We can reuse the symbolic logic or just do numeric div
            
            rem = 0
            # Dividend: 1 << (k + poly_degree)
            # We want (1 << (k + poly_degree)) % poly
            # Better: use modular exponentiation or simple LFSR step
            
            # Remainder of x^(degree + k)
            # Start with 0. Shift in 1 at step (total_len - 1 - pos)?
            # No, Remainder of x^m.
            # R_0 = 1.
            # R_{i+1} = (R_i << 1) ^ (MSB ? poly : 0).
            
            # Calculate x^(k+degree) mod poly
            # We can just run the LFSR for (k+degree) steps with input 0, starting state 1? No.
            # Logic:
            # rem = 1 (represents x^0).
            # Shift (k+degree) times?
            # Wait, x^0 mod P is 1.
            # x^1 mod P is x.
            # ...
            # x^degree mod P is P without MSB? No. x^degree = P + rem? 
            # P = x^degree + ... + 1.
            # x^degree = P - (...) = (...) mod P.
            
            d_val = 1
            for _ in range(k + self.poly_degree):
                msb = (d_val >> (self.poly_degree - 1)) & 1
                d_val = (d_val << 1) & ((1 << self.poly_degree) - 1)
                if msb:
                    d_val ^= self.poly  # Using low part of poly
                    # Wait, self.poly usually implies the coefficients.
                    # Standard representation: 0x04C11DB7 doesn't include the x^32 bit.
                    # It includes x^0 to x^31.
                    # Correct.
            
            syndrome_map[d_val] = err_pos_in_codeword
            
        return syndrome_map

    def generate_verilog(self, module_name):
        self.add_line(f"module {module_name} (")
        self.add_line(f"    input  wire clk,")
        self.add_line(f"    input  wire rst_n,")
        self.add_line(f"    input  wire encode_en,")
        self.add_line(f"    input  wire decode_en,")
        self.add_line(f"    input  wire [{self.width-1}:0] data_in,")
        self.add_line(f"    input  wire [{self.n-1}:0] codeword_in,")
        self.add_line(f"    output reg  [{self.n-1}:0] codeword_out,")
        self.add_line(f"    output reg  [{self.width-1}:0] data_out,")
        self.add_line(f"    output reg  error_detected,")
        self.add_line(f"    output reg  error_corrected,")
        self.add_line(f"    output reg  valid_out")
        self.add_line(f");")
        self.add_line(f"")
        
        # -----------------------------------------------------
        # ENCODER: Parallel CRC
        # -----------------------------------------------------
        self.add_line(f"    wire [{self.poly_degree-1}:0] crc_out;")
        self.generate_lfsr_logic("data_in", "crc_out", self.width)
        
        self.add_line(f"")
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            codeword_out <= 0;")
        self.add_line(f"            valid_out <= 0;")
        self.add_line(f"        end else if (encode_en) begin")
        self.add_line(f"            // Systematic: Data | CRC")
        self.add_line(f"            codeword_out <= {{data_in, crc_out}};")
        self.add_line(f"            valid_out <= 1;")
        self.add_line(f"        end else if (decode_en) begin")
        self.add_line(f"            valid_out <= 1;")
        self.add_line(f"        end else begin")
        self.add_line(f"            valid_out <= 0;")
        self.add_line(f"        end")
        self.add_line(f"    end")
        
        # -----------------------------------------------------
        # DECODER: Syndrome + Correction
        # -----------------------------------------------------
        # Syndrome S = Remainder(Received)
        # Received = Data_Rx * x^Deg + CRC_Rx
        # We can re-calculate CRC from Data_Rx: CRC_calc
        # Syndrome = CRC_calc ^ CRC_Rx.
        # Why?
        # Rem(D*x^N) = CRC_tx.
        # Rx = D*x^N + CRC_tx + E.
        # Rem(Rx) = Rem(D*x^N) + Rem(CRC_tx) + Rem(E).
        # = CRC_tx + 0 + Rem(E) ? No. CRC_tx is degree < N. So Rem(CRC_tx) = CRC_tx.
        # So Rem(Rx) = CRC_tx + CRC_tx + Rem(E) = Rem(E).
        # Wait, if we use Recalculate approach:
        # S = CRC_calc(Data_Rx) ^ CRC_Rx.
        # S = Rem(Data_Rx * x^N) ^ CRC_Rx.
        # = (CRC_tx ^ Rem(E_data)) ^ (CRC_tx ^ E_crc).
        # = Rem(E_data) ^ E_crc.
        # This matches Rem(E).
        
        self.add_line(f"")
        self.add_line(f"    wire [{self.poly_degree-1}:0] crc_recalc;")
        self.add_line(f"    wire [{self.width-1}:0] data_rx = codeword_in[{self.n-1}:{self.poly_degree}];")
        self.add_line(f"    wire [{self.poly_degree-1}:0] crc_rx = codeword_in[{self.poly_degree-1}:0];")
        
        self.generate_lfsr_logic("data_rx", "crc_recalc", self.width)
        
        self.add_line(f"    wire [{self.poly_degree-1}:0] syndrome = crc_recalc ^ crc_rx;")
        
        # Error Correction LUT
        self.add_line(f"    reg [{self.n-1}:0] error_pattern;")
        self.add_line(f"    always @(*) begin")
        self.add_line(f"        case(syndrome)")
        self.add_line(f"            {self.poly_degree}'h0: error_pattern = 0;")
        
        syndrome_map = self.calc_syndrome_map()
        for syn, pos in syndrome_map.items():
            # pos is bit index in codeword.
            # pos<degree -> check bits. pos>=degree -> data bits.
            self.add_line(f"            {self.poly_degree}'h{syn:x}: error_pattern = {self.n}'d1 << {pos};")
            
        self.add_line(f"            default: error_pattern = 0; // Uncorrectable (Multi-bit)")
        self.add_line(f"        endcase")
        self.add_line(f"    end")
        
        self.add_line(f"")
        self.add_line(f"    wire [{self.n-1}:0] corrected_cw = codeword_in ^ error_pattern;")
        
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            data_out <= 0;")
        self.add_line(f"            error_detected <= 0;")
        self.add_line(f"            error_corrected <= 0;")
        self.add_line(f"        end else if (decode_en) begin")
        self.add_line(f"            data_out <= corrected_cw[{self.n-1}:{self.poly_degree}];")
        self.add_line(f"            error_detected <= (syndrome != 0);")
        self.add_line(f"            error_corrected <= (syndrome != 0) && (error_pattern != 0);")
        self.add_line(f"        end")
        self.add_line(f"    end")
        
        self.add_line(f"endmodule")
        return "\n".join(self.lines)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--width", type=int, required=True, help="Data Width")
    parser.add_argument("--output", type=str, required=True, help="Output File")
    args = parser.parse_args()

    gen = CyclicGenerator(args.width)
    verilog = gen.generate_verilog(f"cyclic_ecc_w{args.width}")
    
    with open(args.output, "w") as f:
        f.write(verilog)
