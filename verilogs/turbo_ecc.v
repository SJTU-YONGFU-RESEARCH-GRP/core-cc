
// Turbo ECC Wrapper - Instantiates Generated Real Hardware Modules
// Supports DATA_WIDTH 4, 8, 16, 32, 64, 128
// Rate 1/3 (Systematic + Parity1 + Parity2)

module turbo_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [3*DATA_WIDTH-1:0] codeword_in,
    output wire [3*DATA_WIDTH-1:0] codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    generate
        if (DATA_WIDTH == 4) begin : w4
            turbo_ecc_w4 u_turbo (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(codeword_in),
                .codeword_out(codeword_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 8) begin : w8
            turbo_ecc_w8 u_turbo (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(codeword_in),
                .codeword_out(codeword_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 16) begin : w16
            turbo_ecc_w16 u_turbo (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(codeword_in),
                .codeword_out(codeword_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 32) begin : w32
            turbo_ecc_w32 u_turbo (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(codeword_in),
                .codeword_out(codeword_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 64) begin : w64
            turbo_ecc_w64 u_turbo (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(codeword_in),
                .codeword_out(codeword_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 128) begin : w128
            turbo_ecc_w128 u_turbo (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(codeword_in),
                .codeword_out(codeword_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
        end else begin : fallback
            assign codeword_out = 0;
            assign data_out = 0;
            assign error_detected = 0;
            assign error_corrected = 0;
            assign valid_out = 0;
        end
    endgenerate

endmodule