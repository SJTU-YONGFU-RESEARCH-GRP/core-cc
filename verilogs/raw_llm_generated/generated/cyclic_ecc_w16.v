module cyclic_ecc_w16 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [15:0] data_in,
    input  wire [31:0] codeword_in,
    output reg  [31:0] codeword_out,
    output reg  [15:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    wire [15:0] crc_out;
    assign crc_out[0] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[12] ^ data_in[14];
    assign crc_out[1] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[12] ^ data_in[14];
    assign crc_out[2] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[13] ^ data_in[15];
    assign crc_out[3] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[13] ^ data_in[15];
    assign crc_out[4] = data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[14];
    assign crc_out[5] = data_in[0] ^ data_in[6] ^ data_in[12];
    assign crc_out[6] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[12] ^ data_in[14] ^ data_in[15];
    assign crc_out[7] = data_in[1] ^ data_in[7] ^ data_in[13];
    assign crc_out[8] = data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[13] ^ data_in[15];
    assign crc_out[9] = data_in[2] ^ data_in[8] ^ data_in[14];
    assign crc_out[10] = data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[14];
    assign crc_out[11] = data_in[3] ^ data_in[9] ^ data_in[15];
    assign crc_out[12] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[15];
    assign crc_out[13] = data_in[0] ^ data_in[2] ^ data_in[10] ^ data_in[12] ^ data_in[14];
    assign crc_out[14] = data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
    assign crc_out[15] = data_in[1] ^ data_in[3] ^ data_in[11] ^ data_in[13] ^ data_in[15];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0;
            valid_out <= 0;
        end else if (encode_en) begin
            // Systematic: Data | CRC
            codeword_out <= {data_in, crc_out};
            valid_out <= 1;
        end else if (decode_en) begin
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end

    wire [15:0] crc_recalc;
    wire [15:0] data_rx = codeword_in[31:16];
    wire [15:0] crc_rx = codeword_in[15:0];
    assign crc_recalc[0] = data_rx[0] ^ data_rx[2] ^ data_rx[4] ^ data_rx[12] ^ data_rx[14];
    assign crc_recalc[1] = data_rx[0] ^ data_rx[2] ^ data_rx[4] ^ data_rx[12] ^ data_rx[14];
    assign crc_recalc[2] = data_rx[1] ^ data_rx[3] ^ data_rx[5] ^ data_rx[13] ^ data_rx[15];
    assign crc_recalc[3] = data_rx[1] ^ data_rx[3] ^ data_rx[5] ^ data_rx[13] ^ data_rx[15];
    assign crc_recalc[4] = data_rx[2] ^ data_rx[4] ^ data_rx[6] ^ data_rx[14];
    assign crc_recalc[5] = data_rx[0] ^ data_rx[6] ^ data_rx[12];
    assign crc_recalc[6] = data_rx[0] ^ data_rx[2] ^ data_rx[3] ^ data_rx[4] ^ data_rx[5] ^ data_rx[7] ^ data_rx[12] ^ data_rx[14] ^ data_rx[15];
    assign crc_recalc[7] = data_rx[1] ^ data_rx[7] ^ data_rx[13];
    assign crc_recalc[8] = data_rx[1] ^ data_rx[3] ^ data_rx[4] ^ data_rx[5] ^ data_rx[6] ^ data_rx[8] ^ data_rx[13] ^ data_rx[15];
    assign crc_recalc[9] = data_rx[2] ^ data_rx[8] ^ data_rx[14];
    assign crc_recalc[10] = data_rx[2] ^ data_rx[4] ^ data_rx[5] ^ data_rx[6] ^ data_rx[7] ^ data_rx[9] ^ data_rx[14];
    assign crc_recalc[11] = data_rx[3] ^ data_rx[9] ^ data_rx[15];
    assign crc_recalc[12] = data_rx[0] ^ data_rx[2] ^ data_rx[3] ^ data_rx[4] ^ data_rx[5] ^ data_rx[6] ^ data_rx[7] ^ data_rx[8] ^ data_rx[10] ^ data_rx[12] ^ data_rx[14] ^ data_rx[15];
    assign crc_recalc[13] = data_rx[0] ^ data_rx[2] ^ data_rx[10] ^ data_rx[12] ^ data_rx[14];
    assign crc_recalc[14] = data_rx[1] ^ data_rx[3] ^ data_rx[4] ^ data_rx[5] ^ data_rx[6] ^ data_rx[7] ^ data_rx[8] ^ data_rx[9] ^ data_rx[11] ^ data_rx[13] ^ data_rx[15];
    assign crc_recalc[15] = data_rx[1] ^ data_rx[3] ^ data_rx[11] ^ data_rx[13] ^ data_rx[15];
    wire [15:0] syndrome = crc_recalc ^ crc_rx;
    reg [31:0] error_pattern;
    always @(*) begin
        case(syndrome)
            16'h0: error_pattern = 0;
            16'h1: error_pattern = 32'd1 << 0;
            16'h2: error_pattern = 32'd1 << 1;
            16'h4: error_pattern = 32'd1 << 2;
            16'h8: error_pattern = 32'd1 << 3;
            16'h10: error_pattern = 32'd1 << 4;
            16'h20: error_pattern = 32'd1 << 5;
            16'h40: error_pattern = 32'd1 << 6;
            16'h80: error_pattern = 32'd1 << 7;
            16'h100: error_pattern = 32'd1 << 8;
            16'h200: error_pattern = 32'd1 << 9;
            16'h400: error_pattern = 32'd1 << 10;
            16'h800: error_pattern = 32'd1 << 11;
            16'h1000: error_pattern = 32'd1 << 12;
            16'h2000: error_pattern = 32'd1 << 13;
            16'h4000: error_pattern = 32'd1 << 14;
            16'h8000: error_pattern = 32'd1 << 15;
            16'h1021: error_pattern = 32'd1 << 16;
            16'h2042: error_pattern = 32'd1 << 17;
            16'h4084: error_pattern = 32'd1 << 18;
            16'h8108: error_pattern = 32'd1 << 19;
            16'h1231: error_pattern = 32'd1 << 20;
            16'h2462: error_pattern = 32'd1 << 21;
            16'h48c4: error_pattern = 32'd1 << 22;
            16'h9188: error_pattern = 32'd1 << 23;
            16'h3331: error_pattern = 32'd1 << 24;
            16'h6662: error_pattern = 32'd1 << 25;
            16'hccc4: error_pattern = 32'd1 << 26;
            16'h89a9: error_pattern = 32'd1 << 27;
            16'h373: error_pattern = 32'd1 << 28;
            16'h6e6: error_pattern = 32'd1 << 29;
            16'hdcc: error_pattern = 32'd1 << 30;
            16'h1b98: error_pattern = 32'd1 << 31;
            default: error_pattern = 0; // Uncorrectable (Multi-bit)
        endcase
    end

    wire [31:0] corrected_cw = codeword_in ^ error_pattern;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (decode_en) begin
            data_out <= corrected_cw[31:16];
            error_detected <= (syndrome != 0);
            error_corrected <= (syndrome != 0) && (error_pattern != 0);
        end
    end
endmodule