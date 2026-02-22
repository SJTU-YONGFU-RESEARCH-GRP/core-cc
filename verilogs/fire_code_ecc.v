/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module fire_code_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    // Codeword Width Logic from Generator:
    // W<=4: +4 (8)
    // W<=8: +6 (14)
    // W<=16: +8 (24)
    // W>16: +10 (W+10)
    input  wire [DATA_WIDTH+10-1:0] codeword_in,
    output wire [DATA_WIDTH+10-1:0] codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    generate
        if (DATA_WIDTH == 4) begin : gen_w4
            fire_code_ecc_w4 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[3:0]), 
                .codeword_in(codeword_in[7:0]), // 4+4
                .codeword_out(codeword_out[7:0]), 
                .data_out(data_out[3:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
            assign codeword_out[DATA_WIDTH+10-1:8] = 0;
        end else if (DATA_WIDTH == 8) begin : gen_w8
            fire_code_ecc_w8 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[7:0]), 
                .codeword_in(codeword_in[13:0]), // 8+6
                .codeword_out(codeword_out[13:0]), 
                .data_out(data_out[7:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
             assign codeword_out[DATA_WIDTH+10-1:14] = 0;
        end else if (DATA_WIDTH == 16) begin : gen_w16
            fire_code_ecc_w16 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[15:0]), 
                .codeword_in(codeword_in[23:0]), // 16+8
                .codeword_out(codeword_out[23:0]), 
                .data_out(data_out[15:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
             assign codeword_out[DATA_WIDTH+10-1:24] = 0;
        end else if (DATA_WIDTH == 32) begin : gen_w32
            fire_code_ecc_w32 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[31:0]), 
                .codeword_in(codeword_in[41:0]), // 32+10
                .codeword_out(codeword_out[41:0]), 
                .data_out(data_out[31:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 64) begin : gen_w64
            fire_code_ecc_w64 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[63:0]), 
                .codeword_in(codeword_in[73:0]), // 64+10
                .codeword_out(codeword_out[73:0]), 
                .data_out(data_out[63:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 128) begin : gen_w128
            fire_code_ecc_w128 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[127:0]), 
                .codeword_in(codeword_in[137:0]), // 128+10
                .codeword_out(codeword_out[137:0]), 
                .data_out(data_out[127:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end
    endgenerate

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
