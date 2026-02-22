module cyclic_ecc_w8 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [7:0] data_in,
    input  wire [15:0] codeword_in,
    output reg  [15:0] codeword_out,
    output reg  [7:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    wire [7:0] crc_out;
    assign crc_out[0] = data_in[0] ^ data_in[3] ^ data_in[6];
    assign crc_out[1] = 1'b0;
    assign crc_out[2] = data_in[1] ^ data_in[4] ^ data_in[7];
    assign crc_out[3] = data_in[0] ^ data_in[3] ^ data_in[6];
    assign crc_out[4] = data_in[2] ^ data_in[5];
    assign crc_out[5] = data_in[1] ^ data_in[4] ^ data_in[7];
    assign crc_out[6] = data_in[3] ^ data_in[6];
    assign crc_out[7] = data_in[2] ^ data_in[5];

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

    wire [7:0] crc_recalc;
    wire [7:0] data_rx = codeword_in[15:8];
    wire [7:0] crc_rx = codeword_in[7:0];
    assign crc_recalc[0] = data_rx[0] ^ data_rx[3] ^ data_rx[6];
    assign crc_recalc[1] = 1'b0;
    assign crc_recalc[2] = data_rx[1] ^ data_rx[4] ^ data_rx[7];
    assign crc_recalc[3] = data_rx[0] ^ data_rx[3] ^ data_rx[6];
    assign crc_recalc[4] = data_rx[2] ^ data_rx[5];
    assign crc_recalc[5] = data_rx[1] ^ data_rx[4] ^ data_rx[7];
    assign crc_recalc[6] = data_rx[3] ^ data_rx[6];
    assign crc_recalc[7] = data_rx[2] ^ data_rx[5];
    wire [7:0] syndrome = crc_recalc ^ crc_rx;
    reg [15:0] error_pattern;
    always @(*) begin
        case(syndrome)
            8'h0: error_pattern = 0;
            8'h1: error_pattern = 16'd1 << 0;
            8'h2: error_pattern = 16'd1 << 1;
            8'h4: error_pattern = 16'd1 << 2;
            8'h8: error_pattern = 16'd1 << 3;
            8'h10: error_pattern = 16'd1 << 4;
            8'h20: error_pattern = 16'd1 << 5;
            8'h40: error_pattern = 16'd1 << 6;
            8'h80: error_pattern = 16'd1 << 7;
            8'h7: error_pattern = 16'd1 << 8;
            8'he: error_pattern = 16'd1 << 9;
            8'h1c: error_pattern = 16'd1 << 10;
            8'h38: error_pattern = 16'd1 << 11;
            8'h70: error_pattern = 16'd1 << 12;
            8'he0: error_pattern = 16'd1 << 13;
            8'hc7: error_pattern = 16'd1 << 14;
            8'h89: error_pattern = 16'd1 << 15;
            default: error_pattern = 0; // Uncorrectable (Multi-bit)
        endcase
    end

    wire [15:0] corrected_cw = codeword_in ^ error_pattern;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (decode_en) begin
            data_out <= corrected_cw[15:8];
            error_detected <= (syndrome != 0);
            error_corrected <= (syndrome != 0) && (error_pattern != 0);
        end
    end
endmodule