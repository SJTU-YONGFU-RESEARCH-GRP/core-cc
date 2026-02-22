/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module cyclic_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    // Codeword Width depends on polynomial degree
    // W=4 -> 4+4 = 8
    // W=8 -> 8+8 = 16
    // W=16 -> 16+16 = 32
    // W>=32 -> W+32
    input  wire [DATA_WIDTH+32-1:0] codeword_in, // Over-provisioned port
    output wire [DATA_WIDTH+32-1:0] codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    generate
        if (DATA_WIDTH == 4) begin : gen_w4
            cyclic_ecc_w4 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[3:0]), 
                .codeword_in(codeword_in[7:0]), // 4+4
                .codeword_out(codeword_out[7:0]), 
                .data_out(data_out[3:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
            assign codeword_out[DATA_WIDTH+32-1:8] = 0;
        end else if (DATA_WIDTH == 8) begin : gen_w8
            cyclic_ecc_w8 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[7:0]), 
                .codeword_in(codeword_in[15:0]), // 8+8
                .codeword_out(codeword_out[15:0]), 
                .data_out(data_out[7:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
             assign codeword_out[DATA_WIDTH+32-1:16] = 0;
        end else if (DATA_WIDTH == 16) begin : gen_w16
            cyclic_ecc_w16 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[15:0]), 
                .codeword_in(codeword_in[31:0]), // 16+16
                .codeword_out(codeword_out[31:0]), 
                .data_out(data_out[15:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
             assign codeword_out[DATA_WIDTH+32-1:32] = 0;
        end else if (DATA_WIDTH == 32) begin : gen_w32
            cyclic_ecc_w32 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[31:0]), 
                .codeword_in(codeword_in[63:0]), // 32+32
                .codeword_out(codeword_out[63:0]), 
                .data_out(data_out[31:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 64) begin : gen_w64
            cyclic_ecc_w64 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[63:0]), 
                .codeword_in(codeword_in[95:0]), // 64+32
                .codeword_out(codeword_out[95:0]), 
                .data_out(data_out[63:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end else if (DATA_WIDTH == 128) begin : gen_w128
            cyclic_ecc_w128 u_core (
                .clk(clk), .rst_n(rst_n), .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in[127:0]), 
                .codeword_in(codeword_in[159:0]), // 128+32
                .codeword_out(codeword_out[159:0]), 
                .data_out(data_out[127:0]),
                .error_detected(error_detected), .error_corrected(error_corrected), .valid_out(valid_out)
            );
        end
    endgenerate

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
