module cyclic_ecc_w32 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [31:0] data_in,
    input  wire [63:0] codeword_in,
    output reg  [63:0] codeword_out,
    output reg  [31:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    wire [31:0] crc_out;
    assign crc_out[0] = data_in[0] ^ data_in[3] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[14] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[31];
    assign crc_out[1] = 1'b0;
    assign crc_out[2] = data_in[1] ^ data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[15] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[28];
    assign crc_out[3] = data_in[0] ^ data_in[3] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[14] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[31];
    assign crc_out[4] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[31];
    assign crc_out[5] = data_in[1] ^ data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[15] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[28];
    assign crc_out[6] = data_in[0] ^ data_in[1] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign crc_out[7] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[31];
    assign crc_out[8] = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[30] ^ data_in[31];
    assign crc_out[9] = data_in[0] ^ data_in[1] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign crc_out[10] = data_in[0] ^ data_in[2] ^ data_in[8] ^ data_in[11] ^ data_in[13] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28];
    assign crc_out[11] = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[30] ^ data_in[31];
    assign crc_out[12] = data_in[1] ^ data_in[3] ^ data_in[9] ^ data_in[12] ^ data_in[14] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29];
    assign crc_out[13] = data_in[0] ^ data_in[2] ^ data_in[8] ^ data_in[11] ^ data_in[13] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28];
    assign crc_out[14] = data_in[2] ^ data_in[4] ^ data_in[10] ^ data_in[13] ^ data_in[15] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[30];
    assign crc_out[15] = data_in[1] ^ data_in[3] ^ data_in[9] ^ data_in[12] ^ data_in[14] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29];
    assign crc_out[16] = data_in[0] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[16] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[28] ^ data_in[30];
    assign crc_out[17] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[14] ^ data_in[15] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign crc_out[18] = data_in[1] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[17] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[29] ^ data_in[31];
    assign crc_out[19] = data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[15] ^ data_in[16] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[30] ^ data_in[31];
    assign crc_out[20] = data_in[2] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[18] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[30];
    assign crc_out[21] = data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[16] ^ data_in[17] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[31];
    assign crc_out[22] = data_in[0] ^ data_in[6] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[16] ^ data_in[19] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[27];
    assign crc_out[23] = data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[17] ^ data_in[18] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27];
    assign crc_out[24] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[17] ^ data_in[20] ^ data_in[22] ^ data_in[27] ^ data_in[28] ^ data_in[31];
    assign crc_out[25] = data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[18] ^ data_in[19] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28];
    assign crc_out[26] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[18] ^ data_in[21] ^ data_in[22] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[31];
    assign crc_out[27] = data_in[0] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[11] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[28] ^ data_in[29] ^ data_in[31];
    assign crc_out[28] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[19] ^ data_in[22] ^ data_in[23] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30];
    assign crc_out[29] = data_in[1] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[11] ^ data_in[12] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[30];
    assign crc_out[30] = data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[23] ^ data_in[24] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign crc_out[31] = data_in[2] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[13] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[31];

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

    wire [31:0] crc_recalc;
    wire [31:0] data_rx = codeword_in[63:32];
    wire [31:0] crc_rx = codeword_in[31:0];
    assign crc_recalc[0] = data_rx[0] ^ data_rx[3] ^ data_rx[6] ^ data_rx[8] ^ data_rx[9] ^ data_rx[10] ^ data_rx[13] ^ data_rx[14] ^ data_rx[22] ^ data_rx[23] ^ data_rx[25] ^ data_rx[26] ^ data_rx[27] ^ data_rx[31];
    assign crc_recalc[1] = 1'b0;
    assign crc_recalc[2] = data_rx[1] ^ data_rx[4] ^ data_rx[7] ^ data_rx[9] ^ data_rx[10] ^ data_rx[11] ^ data_rx[14] ^ data_rx[15] ^ data_rx[23] ^ data_rx[24] ^ data_rx[26] ^ data_rx[27] ^ data_rx[28];
    assign crc_recalc[3] = data_rx[0] ^ data_rx[3] ^ data_rx[6] ^ data_rx[8] ^ data_rx[9] ^ data_rx[10] ^ data_rx[13] ^ data_rx[14] ^ data_rx[22] ^ data_rx[23] ^ data_rx[25] ^ data_rx[26] ^ data_rx[27] ^ data_rx[31];
    assign crc_recalc[4] = data_rx[0] ^ data_rx[2] ^ data_rx[3] ^ data_rx[5] ^ data_rx[6] ^ data_rx[9] ^ data_rx[11] ^ data_rx[12] ^ data_rx[13] ^ data_rx[14] ^ data_rx[15] ^ data_rx[16] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[26] ^ data_rx[28] ^ data_rx[29] ^ data_rx[31];
    assign crc_recalc[5] = data_rx[1] ^ data_rx[4] ^ data_rx[7] ^ data_rx[9] ^ data_rx[10] ^ data_rx[11] ^ data_rx[14] ^ data_rx[15] ^ data_rx[23] ^ data_rx[24] ^ data_rx[26] ^ data_rx[27] ^ data_rx[28];
    assign crc_recalc[6] = data_rx[0] ^ data_rx[1] ^ data_rx[4] ^ data_rx[7] ^ data_rx[8] ^ data_rx[9] ^ data_rx[12] ^ data_rx[15] ^ data_rx[16] ^ data_rx[17] ^ data_rx[22] ^ data_rx[24] ^ data_rx[26] ^ data_rx[29] ^ data_rx[30] ^ data_rx[31];
    assign crc_recalc[7] = data_rx[0] ^ data_rx[2] ^ data_rx[3] ^ data_rx[5] ^ data_rx[6] ^ data_rx[9] ^ data_rx[11] ^ data_rx[12] ^ data_rx[13] ^ data_rx[14] ^ data_rx[15] ^ data_rx[16] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[26] ^ data_rx[28] ^ data_rx[29] ^ data_rx[31];
    assign crc_recalc[8] = data_rx[1] ^ data_rx[2] ^ data_rx[5] ^ data_rx[8] ^ data_rx[9] ^ data_rx[10] ^ data_rx[13] ^ data_rx[16] ^ data_rx[17] ^ data_rx[18] ^ data_rx[23] ^ data_rx[25] ^ data_rx[27] ^ data_rx[30] ^ data_rx[31];
    assign crc_recalc[9] = data_rx[0] ^ data_rx[1] ^ data_rx[4] ^ data_rx[7] ^ data_rx[8] ^ data_rx[9] ^ data_rx[12] ^ data_rx[15] ^ data_rx[16] ^ data_rx[17] ^ data_rx[22] ^ data_rx[24] ^ data_rx[26] ^ data_rx[29] ^ data_rx[30] ^ data_rx[31];
    assign crc_recalc[10] = data_rx[0] ^ data_rx[2] ^ data_rx[8] ^ data_rx[11] ^ data_rx[13] ^ data_rx[17] ^ data_rx[18] ^ data_rx[19] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[27] ^ data_rx[28];
    assign crc_recalc[11] = data_rx[1] ^ data_rx[2] ^ data_rx[5] ^ data_rx[8] ^ data_rx[9] ^ data_rx[10] ^ data_rx[13] ^ data_rx[16] ^ data_rx[17] ^ data_rx[18] ^ data_rx[23] ^ data_rx[25] ^ data_rx[27] ^ data_rx[30] ^ data_rx[31];
    assign crc_recalc[12] = data_rx[1] ^ data_rx[3] ^ data_rx[9] ^ data_rx[12] ^ data_rx[14] ^ data_rx[18] ^ data_rx[19] ^ data_rx[20] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[26] ^ data_rx[28] ^ data_rx[29];
    assign crc_recalc[13] = data_rx[0] ^ data_rx[2] ^ data_rx[8] ^ data_rx[11] ^ data_rx[13] ^ data_rx[17] ^ data_rx[18] ^ data_rx[19] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[27] ^ data_rx[28];
    assign crc_recalc[14] = data_rx[2] ^ data_rx[4] ^ data_rx[10] ^ data_rx[13] ^ data_rx[15] ^ data_rx[19] ^ data_rx[20] ^ data_rx[21] ^ data_rx[24] ^ data_rx[25] ^ data_rx[26] ^ data_rx[27] ^ data_rx[29] ^ data_rx[30];
    assign crc_recalc[15] = data_rx[1] ^ data_rx[3] ^ data_rx[9] ^ data_rx[12] ^ data_rx[14] ^ data_rx[18] ^ data_rx[19] ^ data_rx[20] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[26] ^ data_rx[28] ^ data_rx[29];
    assign crc_recalc[16] = data_rx[0] ^ data_rx[5] ^ data_rx[6] ^ data_rx[8] ^ data_rx[9] ^ data_rx[10] ^ data_rx[11] ^ data_rx[13] ^ data_rx[16] ^ data_rx[20] ^ data_rx[21] ^ data_rx[23] ^ data_rx[28] ^ data_rx[30];
    assign crc_recalc[17] = data_rx[0] ^ data_rx[2] ^ data_rx[3] ^ data_rx[4] ^ data_rx[6] ^ data_rx[8] ^ data_rx[9] ^ data_rx[14] ^ data_rx[15] ^ data_rx[19] ^ data_rx[20] ^ data_rx[21] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[29] ^ data_rx[30] ^ data_rx[31];
    assign crc_recalc[18] = data_rx[1] ^ data_rx[6] ^ data_rx[7] ^ data_rx[9] ^ data_rx[10] ^ data_rx[11] ^ data_rx[12] ^ data_rx[14] ^ data_rx[17] ^ data_rx[21] ^ data_rx[22] ^ data_rx[24] ^ data_rx[29] ^ data_rx[31];
    assign crc_recalc[19] = data_rx[1] ^ data_rx[3] ^ data_rx[4] ^ data_rx[5] ^ data_rx[7] ^ data_rx[9] ^ data_rx[10] ^ data_rx[15] ^ data_rx[16] ^ data_rx[20] ^ data_rx[21] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[30] ^ data_rx[31];
    assign crc_recalc[20] = data_rx[2] ^ data_rx[7] ^ data_rx[8] ^ data_rx[10] ^ data_rx[11] ^ data_rx[12] ^ data_rx[13] ^ data_rx[15] ^ data_rx[18] ^ data_rx[22] ^ data_rx[23] ^ data_rx[25] ^ data_rx[30];
    assign crc_recalc[21] = data_rx[2] ^ data_rx[4] ^ data_rx[5] ^ data_rx[6] ^ data_rx[8] ^ data_rx[10] ^ data_rx[11] ^ data_rx[16] ^ data_rx[17] ^ data_rx[21] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[26] ^ data_rx[31];
    assign crc_recalc[22] = data_rx[0] ^ data_rx[6] ^ data_rx[10] ^ data_rx[11] ^ data_rx[12] ^ data_rx[16] ^ data_rx[19] ^ data_rx[22] ^ data_rx[24] ^ data_rx[25] ^ data_rx[27];
    assign crc_recalc[23] = data_rx[3] ^ data_rx[5] ^ data_rx[6] ^ data_rx[7] ^ data_rx[9] ^ data_rx[11] ^ data_rx[12] ^ data_rx[17] ^ data_rx[18] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[26] ^ data_rx[27];
    assign crc_recalc[24] = data_rx[0] ^ data_rx[1] ^ data_rx[3] ^ data_rx[6] ^ data_rx[7] ^ data_rx[8] ^ data_rx[9] ^ data_rx[10] ^ data_rx[11] ^ data_rx[12] ^ data_rx[14] ^ data_rx[17] ^ data_rx[20] ^ data_rx[22] ^ data_rx[27] ^ data_rx[28] ^ data_rx[31];
    assign crc_recalc[25] = data_rx[4] ^ data_rx[6] ^ data_rx[7] ^ data_rx[8] ^ data_rx[10] ^ data_rx[12] ^ data_rx[13] ^ data_rx[18] ^ data_rx[19] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[26] ^ data_rx[27] ^ data_rx[28];
    assign crc_recalc[26] = data_rx[0] ^ data_rx[1] ^ data_rx[2] ^ data_rx[3] ^ data_rx[4] ^ data_rx[6] ^ data_rx[7] ^ data_rx[11] ^ data_rx[12] ^ data_rx[14] ^ data_rx[15] ^ data_rx[18] ^ data_rx[21] ^ data_rx[22] ^ data_rx[25] ^ data_rx[26] ^ data_rx[27] ^ data_rx[28] ^ data_rx[29] ^ data_rx[31];
    assign crc_recalc[27] = data_rx[0] ^ data_rx[3] ^ data_rx[5] ^ data_rx[6] ^ data_rx[7] ^ data_rx[10] ^ data_rx[11] ^ data_rx[19] ^ data_rx[20] ^ data_rx[22] ^ data_rx[23] ^ data_rx[24] ^ data_rx[28] ^ data_rx[29] ^ data_rx[31];
    assign crc_recalc[28] = data_rx[1] ^ data_rx[2] ^ data_rx[3] ^ data_rx[4] ^ data_rx[5] ^ data_rx[7] ^ data_rx[8] ^ data_rx[12] ^ data_rx[13] ^ data_rx[15] ^ data_rx[16] ^ data_rx[19] ^ data_rx[22] ^ data_rx[23] ^ data_rx[26] ^ data_rx[27] ^ data_rx[28] ^ data_rx[29] ^ data_rx[30];
    assign crc_recalc[29] = data_rx[1] ^ data_rx[4] ^ data_rx[6] ^ data_rx[7] ^ data_rx[8] ^ data_rx[11] ^ data_rx[12] ^ data_rx[20] ^ data_rx[21] ^ data_rx[23] ^ data_rx[24] ^ data_rx[25] ^ data_rx[29] ^ data_rx[30];
    assign crc_recalc[30] = data_rx[2] ^ data_rx[3] ^ data_rx[4] ^ data_rx[5] ^ data_rx[6] ^ data_rx[8] ^ data_rx[9] ^ data_rx[13] ^ data_rx[14] ^ data_rx[16] ^ data_rx[17] ^ data_rx[20] ^ data_rx[23] ^ data_rx[24] ^ data_rx[27] ^ data_rx[28] ^ data_rx[29] ^ data_rx[30] ^ data_rx[31];
    assign crc_recalc[31] = data_rx[2] ^ data_rx[5] ^ data_rx[7] ^ data_rx[8] ^ data_rx[9] ^ data_rx[12] ^ data_rx[13] ^ data_rx[21] ^ data_rx[22] ^ data_rx[24] ^ data_rx[25] ^ data_rx[26] ^ data_rx[30] ^ data_rx[31];
    wire [31:0] syndrome = crc_recalc ^ crc_rx;
    reg [63:0] error_pattern;
    always @(*) begin
        case(syndrome)
            32'h0: error_pattern = 0;
            32'h1: error_pattern = 64'd1 << 0;
            32'h2: error_pattern = 64'd1 << 1;
            32'h4: error_pattern = 64'd1 << 2;
            32'h8: error_pattern = 64'd1 << 3;
            32'h10: error_pattern = 64'd1 << 4;
            32'h20: error_pattern = 64'd1 << 5;
            32'h40: error_pattern = 64'd1 << 6;
            32'h80: error_pattern = 64'd1 << 7;
            32'h100: error_pattern = 64'd1 << 8;
            32'h200: error_pattern = 64'd1 << 9;
            32'h400: error_pattern = 64'd1 << 10;
            32'h800: error_pattern = 64'd1 << 11;
            32'h1000: error_pattern = 64'd1 << 12;
            32'h2000: error_pattern = 64'd1 << 13;
            32'h4000: error_pattern = 64'd1 << 14;
            32'h8000: error_pattern = 64'd1 << 15;
            32'h10000: error_pattern = 64'd1 << 16;
            32'h20000: error_pattern = 64'd1 << 17;
            32'h40000: error_pattern = 64'd1 << 18;
            32'h80000: error_pattern = 64'd1 << 19;
            32'h100000: error_pattern = 64'd1 << 20;
            32'h200000: error_pattern = 64'd1 << 21;
            32'h400000: error_pattern = 64'd1 << 22;
            32'h800000: error_pattern = 64'd1 << 23;
            32'h1000000: error_pattern = 64'd1 << 24;
            32'h2000000: error_pattern = 64'd1 << 25;
            32'h4000000: error_pattern = 64'd1 << 26;
            32'h8000000: error_pattern = 64'd1 << 27;
            32'h10000000: error_pattern = 64'd1 << 28;
            32'h20000000: error_pattern = 64'd1 << 29;
            32'h40000000: error_pattern = 64'd1 << 30;
            32'h80000000: error_pattern = 64'd1 << 31;
            32'h4c11db7: error_pattern = 64'd1 << 32;
            32'h9823b6e: error_pattern = 64'd1 << 33;
            32'h130476dc: error_pattern = 64'd1 << 34;
            32'h2608edb8: error_pattern = 64'd1 << 35;
            32'h4c11db70: error_pattern = 64'd1 << 36;
            32'h9823b6e0: error_pattern = 64'd1 << 37;
            32'h34867077: error_pattern = 64'd1 << 38;
            32'h690ce0ee: error_pattern = 64'd1 << 39;
            32'hd219c1dc: error_pattern = 64'd1 << 40;
            32'ha0f29e0f: error_pattern = 64'd1 << 41;
            32'h452421a9: error_pattern = 64'd1 << 42;
            32'h8a484352: error_pattern = 64'd1 << 43;
            32'h10519b13: error_pattern = 64'd1 << 44;
            32'h20a33626: error_pattern = 64'd1 << 45;
            32'h41466c4c: error_pattern = 64'd1 << 46;
            32'h828cd898: error_pattern = 64'd1 << 47;
            32'h1d8ac87: error_pattern = 64'd1 << 48;
            32'h3b1590e: error_pattern = 64'd1 << 49;
            32'h762b21c: error_pattern = 64'd1 << 50;
            32'hec56438: error_pattern = 64'd1 << 51;
            32'h1d8ac870: error_pattern = 64'd1 << 52;
            32'h3b1590e0: error_pattern = 64'd1 << 53;
            32'h762b21c0: error_pattern = 64'd1 << 54;
            32'hec564380: error_pattern = 64'd1 << 55;
            32'hdc6d9ab7: error_pattern = 64'd1 << 56;
            32'hbc1a28d9: error_pattern = 64'd1 << 57;
            32'h7cf54c05: error_pattern = 64'd1 << 58;
            32'hf9ea980a: error_pattern = 64'd1 << 59;
            32'hf7142da3: error_pattern = 64'd1 << 60;
            32'heae946f1: error_pattern = 64'd1 << 61;
            32'hd1139055: error_pattern = 64'd1 << 62;
            32'ha6e63d1d: error_pattern = 64'd1 << 63;
            default: error_pattern = 0; // Uncorrectable (Multi-bit)
        endcase
    end

    wire [63:0] corrected_cw = codeword_in ^ error_pattern;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (decode_en) begin
            data_out <= corrected_cw[63:32];
            error_detected <= (syndrome != 0);
            error_corrected <= (syndrome != 0) && (error_pattern != 0);
        end
    end
endmodule