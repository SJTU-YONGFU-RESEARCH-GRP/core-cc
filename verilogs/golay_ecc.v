/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module golay_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    // Codeword width is 23 * ceil(WIDTH/8)
    // For parameterized width, we can use a calculation function or explicit mapping
    // But input ports must be fixed width.
    // We assume the testbench provides enough width.
    // For W=4 -> 23
    // W=8 -> 23
    // W=16 -> 46
    // W=32 -> 92
    // W=64 -> 184
    // W=128 -> 368
    // We can define localparam
    // Or assume the input 'codeword_in' is large enough and slice it.
    // However, the port declaration must involve a constant expression.
    input  wire [((DATA_WIDTH + 7) / 8) * 23 - 1 : 0] codeword_in,
    output wire [((DATA_WIDTH + 7) / 8) * 23 - 1 : 0] codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    generate
        if (DATA_WIDTH == 4) begin : gen_w4
            golay_ecc_w4 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[3:0]), .codeword_in(codeword_in[22:0]),
                .codeword_out(codeword_out[22:0]), .data_out(data_out[3:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 8) begin : gen_w8
            golay_ecc_w8 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[7:0]), .codeword_in(codeword_in[22:0]),
                .codeword_out(codeword_out[22:0]), .data_out(data_out[7:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 16) begin : gen_w16
            golay_ecc_w16 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[15:0]), .codeword_in(codeword_in[45:0]),
                .codeword_out(codeword_out[45:0]), .data_out(data_out[15:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 32) begin : gen_w32
            golay_ecc_w32 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[31:0]), .codeword_in(codeword_in[91:0]),
                .codeword_out(codeword_out[91:0]), .data_out(data_out[31:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 64) begin : gen_w64
            golay_ecc_w64 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[63:0]), .codeword_in(codeword_in[183:0]),
                .codeword_out(codeword_out[183:0]), .data_out(data_out[63:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 128) begin : gen_w128
            golay_ecc_w128 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[127:0]), .codeword_in(codeword_in[367:0]),
                .codeword_out(codeword_out[367:0]), .data_out(data_out[127:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end
    endgenerate

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */