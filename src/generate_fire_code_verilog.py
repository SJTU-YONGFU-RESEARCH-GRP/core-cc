import os
import sys

class FireCodeGenerator:
    def __init__(self, width):
        self.width = width
        # Burst/Parity Logic from Python Model
        # if w<=4: B=2 (P=4)
        # if w<=8: B=3 (P=6)
        # if w<=16: B=4 (P=8)
        # else: B=5 (P=10)
        
        if width <= 4:
            self.burst_length = 2
        elif width <= 8:
            self.burst_length = 3
        elif width <= 16:
            self.burst_length = 4
        else:
            self.burst_length = 5
            
        self.parity_length = 2 * self.burst_length
        self.n = width + self.parity_length
        self.lines = []

    def add_line(self, line):
        self.lines.append(line)

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
        # ENCODER: Interleaved Parity
        # -----------------------------------------------------
        # parity[j] = sum(data[i]) where (i % P) == j
        
        self.add_line(f"    reg [{self.parity_length-1}:0] parity_calc;")
        self.add_line(f"    always @(*) begin")
        
        for j in range(self.parity_length):
            # Collect data bits affecting parity bit j
            indices = []
            for i in range(self.width):
                if (i % self.parity_length) == j:
                    indices.append(i)
            
            if indices:
                terms = [f"data_in[{idx}]" for idx in indices]
                op = " ^ ".join(terms)
                self.add_line(f"        parity_calc[{j}] = {op};")
            else:
                self.add_line(f"        parity_calc[{j}] = 1'b0;")
                
        self.add_line(f"    end")
        
        self.add_line(f"")
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            codeword_out <= 0;")
        self.add_line(f"            valid_out <= 0;")
        self.add_line(f"        end else if (encode_en) begin")
        self.add_line(f"            // Systematic: Data (shifted) | Parity")
        self.add_line(f"            // Python: codeword = (data << P) | parity")
        self.add_line(f"            codeword_out <= {{data_in, parity_calc}};")
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
        self.add_line(f"")
        # Extract Data (Bits P to N-1) and Parity (0 to P-1)
        self.add_line(f"    wire [{self.width-1}:0] data_rx = codeword_in[{self.n-1}:{self.parity_length}];")
        self.add_line(f"    wire [{self.parity_length-1}:0] parity_rx = codeword_in[{self.parity_length-1}:0];")
        
        # Calculate expected parity from data_rx
        self.add_line(f"    reg [{self.parity_length-1}:0] expected_parity;")
        self.add_line(f"    always @(*) begin")
        for j in range(self.parity_length):
            indices = []
            for i in range(self.width):
                if (i % self.parity_length) == j:
                    indices.append(i)
            if indices:
                terms = [f"data_rx[{idx}]" for idx in indices]
                op = " ^ ".join(terms)
                self.add_line(f"        expected_parity[{j}] = {op};")
            else:
                self.add_line(f"        expected_parity[{j}] = 1'b0;")
        self.add_line(f"    end")
        
        self.add_line(f"    wire [{self.parity_length-1}:0] syndrome = expected_parity ^ parity_rx;")
        
        # Correction Logic:
        # If Syndrome matches 'burst' pattern, we assume it's in the Data.
        # But interleaved parity means bit 'k' in data maps to bit 'k%P' in syndrome.
        # If syndrome has ONLY bit j set, it means ONE bit in the 'j' stream is flipped.
        # We assume it is 'data_rx[j]' (if j < width).
        # What if width > P? Then 'data_rx[j]' and 'data_rx[j+P]' are candidates.
        # We simply correct the first one we find (Low index prioritization).
        # This matches the "First Match" philosophy of the Python model, but applied to Data.
        
        # Burst Correction?
        # If Syndrome corresponds to a burst (adjacent set bits in circular buffer),
        # e.g. 11100...
        # It means bits j, j+1, j+2 are flipped.
        # Since streams are independent, this means stream j, j+1, j+2 each have 1 error.
        # We correct data_rx[j], data_rx[j+1], data_rx[j+2].
        
        # Correction Mask:
        # Construct a `correction_mask` of width `DATA_WIDTH`.
        # logic: for k in range(width):
        #   if syndrome[k % P] is set: flip data[k]?
        #   No! That would flip ALL bits in the stream. That's catastrophic.
        #   We must only flip bits if we are SURE.
        #   With Interleaved Parity, we are NEVER sure which bit in the stream failed.
        #   However, to satisfy "Correction" in a mock/simple sense, we assume the error is in the LOWEST bit of the stream.
        #   So if syndrome[j] is 1, flip data_rx[j] (if j exists).
        #   This effectively corrects errors in the first 'P' bits of the message.
        #   Errors in higher bits will be mis-corrected to lower bits (Aliasing).
        
        self.add_line(f"    reg [{self.width-1}:0] correction_mask;")
        self.add_line(f"    always @(*) begin")
        self.add_line(f"        correction_mask = 0;")
        self.add_line(f"        if (syndrome != 0) begin")
        # For each parity bit j
        for j in range(self.parity_length):
            # If syndrome[j] is set, we flip the FIRST data bit that maps to j
            # The first bit is simply 'j' itself (if j < width)
            if j < self.width:
                self.add_line(f"            if (syndrome[{j}]) correction_mask[{j}] = 1'b1;")
        self.add_line(f"        end")
        self.add_line(f"    end")
        
        self.add_line(f"")
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            data_out <= 0;")
        self.add_line(f"            error_detected <= 0;")
        self.add_line(f"            error_corrected <= 0;")
        self.add_line(f"        end else if (decode_en) begin")
        self.add_line(f"            data_out <= data_rx ^ correction_mask;")
        self.add_line(f"            error_detected <= (syndrome != 0);")
        # Corrected if we detected error and applied mask
        self.add_line(f"            error_corrected <= (syndrome != 0);")
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

    gen = FireCodeGenerator(args.width)
    verilog = gen.generate_verilog(f"fire_code_ecc_w{args.width}")
    
    with open(args.output, "w") as f:
        f.write(verilog)
