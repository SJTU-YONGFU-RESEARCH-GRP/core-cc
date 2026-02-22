module reed_muller_ecc_w32 (
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

    // Encoder Logic
    reg [63:0] encoded_data;
    always @(*) begin
        encoded_data[31:0] = data_in;
        encoded_data[32] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[33] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[34] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[35] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[36] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[37] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[38] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[39] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[40] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[41] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[42] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[43] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[44] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[45] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[46] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[47] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[48] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[49] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[50] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[51] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[52] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[53] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[54] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[55] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[56] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[57] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[58] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[59] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[60] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[61] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
        encoded_data[62] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30];
        encoded_data[63] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0;
            valid_out <= 0;
        end else if (encode_en) begin
            codeword_out <= encoded_data;
            valid_out <= 1;
        end else if (decode_en) begin
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end

    // Decoder Logic
    wire [31:0] syndrome;
    assign syndrome[0] = codeword_in[32] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[1] = codeword_in[33] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[2] = codeword_in[34] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[3] = codeword_in[35] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[4] = codeword_in[36] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[5] = codeword_in[37] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[6] = codeword_in[38] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[7] = codeword_in[39] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[8] = codeword_in[40] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[9] = codeword_in[41] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[10] = codeword_in[42] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[11] = codeword_in[43] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[12] = codeword_in[44] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[13] = codeword_in[45] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[14] = codeword_in[46] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[15] = codeword_in[47] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[16] = codeword_in[48] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[17] = codeword_in[49] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[18] = codeword_in[50] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[19] = codeword_in[51] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[20] = codeword_in[52] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[21] = codeword_in[53] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[22] = codeword_in[54] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[23] = codeword_in[55] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[24] = codeword_in[56] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[25] = codeword_in[57] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[26] = codeword_in[58] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[27] = codeword_in[59] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[28] = codeword_in[60] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[29] = codeword_in[61] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);
    assign syndrome[30] = codeword_in[62] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30]);
    assign syndrome[31] = codeword_in[63] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31]);

    reg [31:0] corrected_data;
    reg err_det, err_corr;
    always @(*) begin
        corrected_data = codeword_in[31:0];
        err_det = (|syndrome);
        err_corr = 0;

        if (err_det) begin
            if (syndrome == 32'd1431655765) begin
                corrected_data[0] = ~codeword_in[0];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[1] = ~codeword_in[1];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[2] = ~codeword_in[2];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[3] = ~codeword_in[3];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[4] = ~codeword_in[4];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[5] = ~codeword_in[5];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[6] = ~codeword_in[6];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[7] = ~codeword_in[7];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[8] = ~codeword_in[8];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[9] = ~codeword_in[9];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[10] = ~codeword_in[10];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[11] = ~codeword_in[11];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[12] = ~codeword_in[12];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[13] = ~codeword_in[13];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[14] = ~codeword_in[14];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[15] = ~codeword_in[15];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[16] = ~codeword_in[16];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[17] = ~codeword_in[17];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[18] = ~codeword_in[18];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[19] = ~codeword_in[19];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[20] = ~codeword_in[20];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[21] = ~codeword_in[21];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[22] = ~codeword_in[22];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[23] = ~codeword_in[23];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[24] = ~codeword_in[24];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[25] = ~codeword_in[25];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[26] = ~codeword_in[26];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[27] = ~codeword_in[27];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[28] = ~codeword_in[28];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[29] = ~codeword_in[29];
                err_corr = 1;
            end
            if (syndrome == 32'd1431655765) begin
                corrected_data[30] = ~codeword_in[30];
                err_corr = 1;
            end
            if (syndrome == 32'd2863311530) begin
                corrected_data[31] = ~codeword_in[31];
                err_corr = 1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (decode_en) begin
            data_out <= corrected_data;
            error_detected <= err_det;
            error_corrected <= err_corr;
        end
    end
endmodule