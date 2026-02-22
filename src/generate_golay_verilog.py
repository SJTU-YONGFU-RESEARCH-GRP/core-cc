import os
import sys

class GolayGenerator:
    def __init__(self, width):
        self.width = width
        # Block size for Golay (23,12) is 12 data bits, but Python model uses 8 data bits per block (padding upper 4)
        self.data_per_block = 8
        self.codeword_per_block = 23
        self.num_blocks = (width + 7) // 8
        self.total_codeword_width = self.num_blocks * 23
        self.lines = []
        
        # Generator Polynomial: 0xC75 = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1
        # 110001110101
        self.poly = 0xC75 

    def add_line(self, line):
        self.lines.append(line)

    def generate_submodule(self):
        # Generate the single block (23,12) module
        self.add_line(f"`ifndef GOLAY_23_12_BLOCK_DEF")
        self.add_line(f"`define GOLAY_23_12_BLOCK_DEF")
        self.add_line(f"module golay_23_12_block (")
        self.add_line(f"    input  wire [7:0] data_in,")
        self.add_line(f"    input  wire [22:0] codeword_in,")
        self.add_line(f"    output wire [22:0] codeword_out,")
        self.add_line(f"    output wire [7:0] data_out,")
        self.add_line(f"    output wire error_detected,")
        self.add_line(f"    output wire error_corrected")
        self.add_line(f");")
        self.add_line(f"")
        
        self.add_line(f"    function [10:0] calc_remainder;")
        self.add_line(f"        input [22:0] message;")
        self.add_line(f"        integer i;")
        self.add_line(f"        reg [22:0] d;")
        self.add_line(f"        begin")
        self.add_line(f"            d = message;")
        self.add_line(f"            for (i = 22; i >= 11; i = i - 1) begin")
        self.add_line(f"                if (d[i]) begin")
        self.add_line(f"                    d[i -: 12] = d[i -: 12] ^ 12'hC75;")
        self.add_line(f"                end")
        self.add_line(f"            end")
        self.add_line(f"            calc_remainder = d[10:0];")
        self.add_line(f"        end")
        self.add_line(f"    endfunction")
        
        self.add_line(f"    wire [22:0] padded_msg = {{4'b0, data_in, 11'b0}};")
        self.add_line(f"    wire [10:0] check_bits = calc_remainder(padded_msg);")
        self.add_line(f"    assign codeword_out = padded_msg | {{12'b0, check_bits}};")
        
        # Decoder Logic
        self.add_line(f"    wire [10:0] syndrome = calc_remainder(codeword_in);")
        self.add_line(f"    reg [22:0] error_pattern;")
        self.add_line(f"    ")
        self.add_line(f"    // Syndrome LUT (Partial - implementing critical parts or behavioral)")
        self.add_line(f"    // For full realism, we'd dump the table. But 2048 entries is huge for this script.")
        self.add_line(f"    // We will use a function that 'searches' for error pattern with weight <= 3.")
        self.add_line(f"    // Since this loops in simulation (slow) or unrolls in synthesis.")
        self.add_line(f"    // Wait, synthesis requires fixed logic. A function with a loop 2^23 is impossible.")
        self.add_line(f"    // We MUST use a LUT.")
        
        # Generating standard LUT for 23,12 is 2k entries.
        # We can construct it in Python and print the case statement.
        
        self.add_line(f"    always @(*) begin")
        self.add_line(f"        case (syndrome)")
        self.add_line(f"            11'h000: error_pattern = 23'h0;")
        
        # Generate LUT entries
        # 1 error
        syndrome_map = {}
        for i in range(23):
            err = 1 << i
            syn = self.calc_syndrome_py(err)
            if syn not in syndrome_map:
                syndrome_map[syn] = err
                self.add_line(f"            11'h{syn:03X}: error_pattern = 23'h{err:06X}; // 1 bit error")
        
        # 2 errors (Partial/Common cases to save script size? No, full for correctness)
        # 23C2 = 253.
        for i in range(23):
            for j in range(i+1, 23):
                err = (1 << i) | (1 << j)
                syn = self.calc_syndrome_py(err)
                if syn not in syndrome_map:
                    syndrome_map[syn] = err
                    self.add_line(f"            11'h{syn:03X}: error_pattern = 23'h{err:06X}; // 2 bit error")
        
        # 3 errors - 23C3 = 1771. This makes the file large (~2000 lines). Acceptable.
        for i in range(23):
            for j in range(i+1, 23):
                for k in range(j+1, 23):
                    err = (1 << i) | (1 << j) | (1 << k)
                    syn = self.calc_syndrome_py(err)
                    if syn not in syndrome_map:
                        syndrome_map[syn] = err
                        self.add_line(f"            11'h{syn:03X}: error_pattern = 23'h{err:06X}; // 3 bit error")

        self.add_line(f"            default: error_pattern = 23'h0; // Uncorrectable")
        self.add_line(f"        endcase")
        self.add_line(f"    end")
        
        self.add_line(f"    wire [22:0] corrected_cw = codeword_in ^ error_pattern;")
        self.add_line(f"    assign data_out = corrected_cw[18:11]; // Extract data bits (originally at 11..18 inside 12 bits)")
        self.add_line(f"    // Wait, padded_msg was: 0000 d7..d0 00..00")
        self.add_line(f"    // Bits 22..19 are 0.")
        self.add_line(f"    // Bits 18..11 are data.")
        self.add_line(f"    // Bits 10..0 are check.")
        
        self.add_line(f"    assign error_corrected = (error_pattern != 0);")
        self.add_line(f"endmodule")
        self.add_line(f"`endif")
        self.add_line(f"")

    def calc_syndrome_py(self, val):
        # Python equivalent of syndrome calculation for generation
        d = val
        for i in range(22, 10, -1):
            if (d >> i) & 1:
                d ^= (self.poly << (i - 11))
        return d & 0x7FF

    def generate_verilog(self, module_name):
        # Generate Submodule FIRST (Outside)
        self.generate_submodule()
        
        self.add_line(f"module {module_name} (")
        self.add_line(f"    input  wire clk,")
        self.add_line(f"    input  wire rst_n,")
        self.add_line(f"    input  wire encode_en,")
        self.add_line(f"    input  wire decode_en,")
        self.add_line(f"    input  wire [{self.width-1}:0] data_in,")
        self.add_line(f"    input  wire [{self.total_codeword_width-1}:0] codeword_in,")
        self.add_line(f"    output reg  [{self.total_codeword_width-1}:0] codeword_out,")
        self.add_line(f"    output reg  [{self.width-1}:0] data_out,")
        self.add_line(f"    output reg  error_detected,")
        self.add_line(f"    output reg  error_corrected,")
        self.add_line(f"    output reg  valid_out")
        self.add_line(f");")
        self.add_line(f"")
        
        self.add_line(f"    // Instantiate Blocks")
        for i in range(self.num_blocks):
            # Handle partial last block? Python model pads input to 8-bit boundary per block.
            # But the full width might not be divisible by 8?
            # Project widths: 4, 8, 16, 32... 4 is special.
            # If Width=4: num_blocks = 1. data_in is 4 bits.
            # We connect data_in[3:0] to low 4 bits, rest 0?
            
            # Submodule expects [7:0]
            low_idx = i * 8
            high_idx = min((i + 1) * 8 - 1, self.width - 1)
            mapped_bits = (high_idx - low_idx) + 1
            
            # Construct input connection
            # If strict subset: e.g. w=4.
            # .data_in({4'b0, data_in[3:0]})
            pad_bits = 8 - mapped_bits
            
            input_conn = f"data_in[{high_idx}:{low_idx}]"
            if pad_bits > 0:
                input_conn = f"{{{pad_bits}'b0, {input_conn}}}"
            
            # Outputs
            # We need wires for outputs
            self.add_line(f"    wire [22:0] cw_out_{i};")
            self.add_line(f"    wire [7:0] d_out_{i};")
            self.add_line(f"    wire err_det_{i}, err_corr_{i};")
            
            self.add_line(f"    golay_23_12_block u_blk_{i} (")
            self.add_line(f"        .data_in({input_conn}),")
            self.add_line(f"        .codeword_in(codeword_in[{23*(i+1)-1}:{23*i}]),")
            self.add_line(f"        .codeword_out(cw_out_{i}),")
            self.add_line(f"        .data_out(d_out_{i}),")
            self.add_line(f"        .error_detected(err_det_{i}),")
            self.add_line(f"        .error_corrected(err_corr_{i})")
            self.add_line(f"    );")

        self.add_line(f"")
        self.add_line(f"    // Aggregation")
        self.add_line(f"    assign error_detected = " + " | ".join([f"err_det_{i}" for i in range(self.num_blocks)]) + ";")
        self.add_line(f"    assign error_corrected = " + " | ".join([f"err_corr_{i}" for i in range(self.num_blocks)]) + ";")
        
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            codeword_out <= 0;")
        self.add_line(f"            data_out <= 0;")
        self.add_line(f"            valid_out <= 0;")
        self.add_line(f"        end else if (encode_en) begin")
        for i in range(self.num_blocks):
            self.add_line(f"            codeword_out[{23*(i+1)-1}:{23*i}] <= cw_out_{i};")
        self.add_line(f"            valid_out <= 1;")
        
        self.add_line(f"        end else if (decode_en) begin")
        for i in range(self.num_blocks):
            # Extract valid bits (un-pad)
            low = i * 8
            high = min((i + 1) * 8 - 1, self.width - 1)
            mapped = (high - low) + 1
            self.add_line(f"            data_out[{high}:{low}] <= d_out_{i}[{mapped-1}:0];")
            
        self.add_line(f"            valid_out <= 1;")
        self.add_line(f"        end else begin")
        self.add_line(f"            valid_out <= 0;")
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

    gen = GolayGenerator(args.width)
    verilog = gen.generate_verilog(f"golay_ecc_w{args.width}")
    
    with open(args.output, "w") as f:
        f.write(verilog)
