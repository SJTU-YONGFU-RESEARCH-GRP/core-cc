
// BCH ECC Wrapper - Instantiates Generated Real Hardware Modules
// Supports DATA_WIDTH 4, 8, 16, 32, 64, 128

module bch_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [254:0]            codeword_in, // Standardized interface width
    output wire [254:0]            codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    generate
        if (DATA_WIDTH == 4) begin : w4
            // n=7, k=4
            wire [6:0] sub_cw_out;
            wire [6:0] sub_cw_in = codeword_in[6:0];
            
            bch_ecc_w4 u_bch (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(sub_cw_in),
                .codeword_out(sub_cw_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
            assign codeword_out = {{(255-7){1'b0}}, sub_cw_out};
            
        end else if (DATA_WIDTH == 8) begin : w8
            // n=15, k=7 (Truncated from 8 data bits? No, 8 bits -> K=7? )
            // Wait, Python logic for w8 is BCH(15,7,2).
            // This means we LOSE 1 bit of data?
            // "data = data & ((1 << k) - 1)" in Python.
            // My hardware generates k=7.
            // But data_in is 8 bits.
            // The generated module expects data_in [7:0].
            // But k=7 means it only uses 7 bits?
            // Let's check generated module bch_ecc_w8.
            // It has `input wire [7:0] data_in` (width=8).
            // Logic uses data_in[k-1]..data_in[0]?
            // Code uses `data_in[i]` for i in range(k-1, -1, -1).
            // i goes 6..0.
            // So data_in[7] is ignored.
            // This matches Python behavior (truncation).
            // So strict wiring is fine.
            
            wire [14:0] sub_cw_out;
            wire [14:0] sub_cw_in = codeword_in[14:0];
            
            bch_ecc_w8 u_bch (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(sub_cw_in),
                .codeword_out(sub_cw_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
            assign codeword_out = {{(255-15){1'b0}}, sub_cw_out};

        end else if (DATA_WIDTH == 16) begin : w16
            // n=31, k=16
            wire [30:0] sub_cw_out;
            wire [30:0] sub_cw_in = codeword_in[30:0];
            
            bch_ecc_w16 u_bch (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(sub_cw_in),
                .codeword_out(sub_cw_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
            assign codeword_out = {{(255-31){1'b0}}, sub_cw_out};
            
        end else if (DATA_WIDTH == 32) begin : w32
            // n=63, k=32
            wire [62:0] sub_cw_out;
            wire [62:0] sub_cw_in = codeword_in[62:0];
            
            bch_ecc_w32 u_bch (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(sub_cw_in),
                .codeword_out(sub_cw_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
            assign codeword_out = {{(255-63){1'b0}}, sub_cw_out};

        end else if (DATA_WIDTH == 64) begin : w64
            // n=127, k=64
            wire [126:0] sub_cw_out;
            wire [126:0] sub_cw_in = codeword_in[126:0];
            
            bch_ecc_w64 u_bch (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(sub_cw_in),
                .codeword_out(sub_cw_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
            assign codeword_out = {{(255-127){1'b0}}, sub_cw_out};
            
        end else if (DATA_WIDTH == 128) begin : w128
            // n=255, k=128
            wire [254:0] sub_cw_out;
            wire [254:0] sub_cw_in = codeword_in[254:0];
            
            bch_ecc_w128 u_bch (
                .clk(clk), .rst_n(rst_n),
                .encode_en(encode_en), .decode_en(decode_en),
                .data_in(data_in),
                .codeword_in(sub_cw_in),
                .codeword_out(sub_cw_out),
                .data_out(data_out),
                .error_detected(error_detected),
                .error_corrected(error_corrected),
                .valid_out(valid_out)
            );
            assign codeword_out = sub_cw_out;

        end else begin : fallback
            // Should not happen
            assign codeword_out = 0;
            assign data_out = 0;
            assign error_detected = 0;
            assign error_corrected = 0;
            assign valid_out = 0;
        end
    endgenerate

endmodule