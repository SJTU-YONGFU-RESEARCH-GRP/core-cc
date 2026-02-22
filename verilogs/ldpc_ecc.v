// LDPC ECC Module - Wrapper for Fixed-Width Real Implementations
// Supports 4, 8, 16, 32, 64, 128 bit widths using pre-generated hardware.

// Include generated files
// Include generated files - REMOVED for Yosys (handled by build script)
// `include "generated/ldpc_ecc_w4.v"
// `include "generated/ldpc_ecc_w8.v"
// `include "generated/ldpc_ecc_w16.v"
// `include "generated/ldpc_ecc_w32.v"
// `include "generated/ldpc_ecc_w64.v"
// `include "generated/ldpc_ecc_w128.v"

/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module ldpc_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [2*DATA_WIDTH-1:0] codeword_in, // Rate 1/2
    output wire [2*DATA_WIDTH-1:0] codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    generate
        if (DATA_WIDTH == 4) begin : w4
            ldpc_ecc_w4 inst (
                .clk(clk), .rst_n(rst_n), 
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in), .codeword_in(codeword_in),
                .codeword_out(codeword_out), .data_out(data_out),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 8) begin : w8
            ldpc_ecc_w8 inst (
                .clk(clk), .rst_n(rst_n), 
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in), .codeword_in(codeword_in),
                .codeword_out(codeword_out), .data_out(data_out),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 16) begin : w16
            ldpc_ecc_w16 inst (
                .clk(clk), .rst_n(rst_n), 
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in), .codeword_in(codeword_in),
                .codeword_out(codeword_out), .data_out(data_out),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 32) begin : w32
            ldpc_ecc_w32 inst (
                .clk(clk), .rst_n(rst_n), 
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in), .codeword_in(codeword_in),
                .codeword_out(codeword_out), .data_out(data_out),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 64) begin : w64
            ldpc_ecc_w64 inst (
                .clk(clk), .rst_n(rst_n), 
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in), .codeword_in(codeword_in),
                .codeword_out(codeword_out), .data_out(data_out),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 128) begin : w128
            ldpc_ecc_w128 inst (
                .clk(clk), .rst_n(rst_n), 
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in), .codeword_in(codeword_in),
                .codeword_out(codeword_out), .data_out(data_out),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else begin : fallback
             // Fallback to avoid syntax errors if width is unexpected in a generic scan?
             // But for this project we support these widths.
             // Empty assignments to prevent Verilator warnings about undriven nets
             assign codeword_out = 0;
             assign data_out = 0;
             assign error_detected = 0;
             assign error_corrected = 0;
             assign valid_out = 0;
        end
    endgenerate

endmodule