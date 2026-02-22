/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module reed_muller_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [2*DATA_WIDTH-1:0] codeword_in,
    output wire [2*DATA_WIDTH-1:0] codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    generate
        if (DATA_WIDTH == 4) begin : gen_w4
            reed_muller_ecc_w4 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[3:0]), .codeword_in(codeword_in[7:0]),
                .codeword_out(codeword_out[7:0]), .data_out(data_out[3:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 8) begin : gen_w8
            reed_muller_ecc_w8 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[7:0]), .codeword_in(codeword_in[15:0]),
                .codeword_out(codeword_out[15:0]), .data_out(data_out[7:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 16) begin : gen_w16
            reed_muller_ecc_w16 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[15:0]), .codeword_in(codeword_in[31:0]),
                .codeword_out(codeword_out[31:0]), .data_out(data_out[15:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 32) begin : gen_w32
            reed_muller_ecc_w32 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[31:0]), .codeword_in(codeword_in[63:0]),
                .codeword_out(codeword_out[63:0]), .data_out(data_out[31:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 64) begin : gen_w64
            reed_muller_ecc_w64 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[63:0]), .codeword_in(codeword_in[127:0]),
                .codeword_out(codeword_out[127:0]), .data_out(data_out[63:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 128) begin : gen_w128
            reed_muller_ecc_w128 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[127:0]), .codeword_in(codeword_in[255:0]),
                .codeword_out(codeword_out[255:0]), .data_out(data_out[127:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end
    endgenerate

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
