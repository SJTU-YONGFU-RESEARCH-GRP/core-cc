import os
import sys

class ReedMullerGenerator:
    def __init__(self, width):
        self.width = width
        self.k = width
        self.n = 2 * width
        self.lines = []

    def add_line(self, line):
        self.lines.append(line)

    def generate_verilog(self, module_name):
        self.add_line(f"module {module_name} (")
        self.add_line(f"    input  wire clk,")
        self.add_line(f"    input  wire rst_n,")
        self.add_line(f"    input  wire encode_en,")
        self.add_line(f"    input  wire decode_en,")
        self.add_line(f"    input  wire [{self.k-1}:0] data_in,")
        self.add_line(f"    input  wire [{self.n-1}:0] codeword_in,")
        self.add_line(f"    output reg  [{self.n-1}:0] codeword_out,")
        self.add_line(f"    output reg  [{self.k-1}:0] data_out,")
        self.add_line(f"    output reg  error_detected,")
        self.add_line(f"    output reg  error_corrected,")
        self.add_line(f"    output reg  valid_out")
        self.add_line(f");")
        self.add_line(f"")

        # --------------------------------------------------------
        # ENCODER
        # --------------------------------------------------------
        self.add_line(f"    // Encoder Logic")
        self.add_line(f"    reg [{self.n-1}:0] encoded_data;")
        self.add_line(f"    always @(*) begin")
        
        # Data part (0 to k-1)
        self.add_line(f"        encoded_data[{self.k-1}:0] = data_in;")
        
        # Parity part (k to n-1)
        for i in range(self.k):
            parity_bit_idx = self.k + i
            terms = []
            for j in range(self.k):
                if (j + parity_bit_idx) % 2 == 0:
                    terms.append(f"data_in[{j}]")
            
            if terms:
                equation = " ^ ".join(terms)
                self.add_line(f"        encoded_data[{parity_bit_idx}] = {equation};")
            else:
                self.add_line(f"        encoded_data[{parity_bit_idx}] = 1'b0;")
        
        self.add_line(f"    end")
        
        self.add_line(f"")
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            codeword_out <= 0;")
        self.add_line(f"            valid_out <= 0;")
        self.add_line(f"        end else if (encode_en) begin")
        self.add_line(f"            codeword_out <= encoded_data;")
        self.add_line(f"            valid_out <= 1;")
        self.add_line(f"        end else if (decode_en) begin")
        self.add_line(f"            valid_out <= 1;")
        self.add_line(f"        end else begin")
        self.add_line(f"            valid_out <= 0;")
        self.add_line(f"        end")
        self.add_line(f"    end")

        # --------------------------------------------------------
        # DECODER
        # --------------------------------------------------------
        self.add_line(f"")
        self.add_line(f"    // Decoder Logic")
        
        self.add_line(f"    wire [{self.k-1}:0] syndrome;")
        for i in range(self.k):
            parity_bit_idx = self.k + i
            terms = []
            for j in range(self.k):
                if (j + parity_bit_idx) % 2 == 0:
                    terms.append(f"codeword_in[{j}]")
            
            if terms:
                equation = " ^ ".join(terms)
                self.add_line(f"    assign syndrome[{i}] = codeword_in[{parity_bit_idx}] ^ ({equation});")
            else:
                 self.add_line(f"    assign syndrome[{i}] = codeword_in[{parity_bit_idx}];")

        self.add_line(f"")
        self.add_line(f"    reg [{self.k-1}:0] corrected_data;")
        self.add_line(f"    reg err_det, err_corr;")
        
        self.add_line(f"    always @(*) begin")
        self.add_line(f"        corrected_data = codeword_in[{self.k-1}:0];")
        self.add_line(f"        err_det = (|syndrome);")
        self.add_line(f"        err_corr = 0;")
        self.add_line(f"")
        self.add_line(f"        if (err_det) begin")
        # Error Correction Logic
        for j in range(self.k):
            # Calculate the unique syndrome pattern for error in bit j
            pattern_val = 0
            for i in range(self.k):
                parity_bit_idx = self.k + i
                if (j + parity_bit_idx) % 2 == 0:
                    pattern_val |= (1 << i)
            
            if pattern_val != 0:
                self.add_line(f"            if (syndrome == {self.k}'d{pattern_val}) begin")
                self.add_line(f"                corrected_data[{j}] = ~codeword_in[{j}];")
                self.add_line(f"                err_corr = 1;")
                self.add_line(f"            end")
        
        self.add_line(f"        end")
        self.add_line(f"    end")

        self.add_line(f"")
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            data_out <= 0;")
        self.add_line(f"            error_detected <= 0;")
        self.add_line(f"            error_corrected <= 0;")
        self.add_line(f"        end else if (decode_en) begin")
        self.add_line(f"            data_out <= corrected_data;")
        self.add_line(f"            error_detected <= err_det;")
        self.add_line(f"            error_corrected <= err_corr;")
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

    gen = ReedMullerGenerator(args.width)
    verilog = gen.generate_verilog(f"reed_muller_ecc_w{args.width}")
    
    with open(args.output, "w") as f:
        f.write(verilog)
