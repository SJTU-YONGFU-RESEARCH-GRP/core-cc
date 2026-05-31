module reed_muller_ecc_w64 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [63:0] data_in,
    input  wire [127:0] codeword_in,
    output reg  [127:0] codeword_out,
    output reg  [63:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    // Encoder Logic
    reg [127:0] encoded_data;
    always @(*) begin
        encoded_data[63:0] = data_in;
        encoded_data[64] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[65] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[66] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[67] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[68] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[69] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[70] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[71] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[72] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[73] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[74] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[75] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[76] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[77] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[78] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[79] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[80] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[81] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[82] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[83] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[84] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[85] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[86] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[87] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[88] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[89] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[90] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[91] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[92] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[93] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[94] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[95] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[96] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[97] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[98] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[99] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[100] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[101] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[102] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[103] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[104] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[105] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[106] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[107] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[108] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[109] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[110] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[111] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[112] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[113] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[114] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[115] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[116] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[117] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[118] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[119] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[120] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[121] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[122] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[123] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[124] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[125] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
        encoded_data[126] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
        encoded_data[127] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[29] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[63];
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
    wire [63:0] syndrome;
    assign syndrome[0] = codeword_in[64] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[1] = codeword_in[65] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[2] = codeword_in[66] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[3] = codeword_in[67] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[4] = codeword_in[68] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[5] = codeword_in[69] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[6] = codeword_in[70] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[7] = codeword_in[71] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[8] = codeword_in[72] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[9] = codeword_in[73] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[10] = codeword_in[74] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[11] = codeword_in[75] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[12] = codeword_in[76] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[13] = codeword_in[77] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[14] = codeword_in[78] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[15] = codeword_in[79] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[16] = codeword_in[80] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[17] = codeword_in[81] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[18] = codeword_in[82] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[19] = codeword_in[83] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[20] = codeword_in[84] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[21] = codeword_in[85] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[22] = codeword_in[86] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[23] = codeword_in[87] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[24] = codeword_in[88] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[25] = codeword_in[89] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[26] = codeword_in[90] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[27] = codeword_in[91] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[28] = codeword_in[92] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[29] = codeword_in[93] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[30] = codeword_in[94] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[31] = codeword_in[95] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[32] = codeword_in[96] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[33] = codeword_in[97] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[34] = codeword_in[98] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[35] = codeword_in[99] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[36] = codeword_in[100] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[37] = codeword_in[101] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[38] = codeword_in[102] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[39] = codeword_in[103] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[40] = codeword_in[104] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[41] = codeword_in[105] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[42] = codeword_in[106] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[43] = codeword_in[107] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[44] = codeword_in[108] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[45] = codeword_in[109] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[46] = codeword_in[110] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[47] = codeword_in[111] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[48] = codeword_in[112] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[49] = codeword_in[113] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[50] = codeword_in[114] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[51] = codeword_in[115] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[52] = codeword_in[116] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[53] = codeword_in[117] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[54] = codeword_in[118] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[55] = codeword_in[119] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[56] = codeword_in[120] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[57] = codeword_in[121] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[58] = codeword_in[122] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[59] = codeword_in[123] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[60] = codeword_in[124] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[61] = codeword_in[125] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);
    assign syndrome[62] = codeword_in[126] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30] ^ codeword_in[32] ^ codeword_in[34] ^ codeword_in[36] ^ codeword_in[38] ^ codeword_in[40] ^ codeword_in[42] ^ codeword_in[44] ^ codeword_in[46] ^ codeword_in[48] ^ codeword_in[50] ^ codeword_in[52] ^ codeword_in[54] ^ codeword_in[56] ^ codeword_in[58] ^ codeword_in[60] ^ codeword_in[62]);
    assign syndrome[63] = codeword_in[127] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37] ^ codeword_in[39] ^ codeword_in[41] ^ codeword_in[43] ^ codeword_in[45] ^ codeword_in[47] ^ codeword_in[49] ^ codeword_in[51] ^ codeword_in[53] ^ codeword_in[55] ^ codeword_in[57] ^ codeword_in[59] ^ codeword_in[61] ^ codeword_in[63]);

    reg [63:0] corrected_data;
    reg err_det, err_corr;
    always @(*) begin
        corrected_data = codeword_in[63:0];
        err_det = (|syndrome);
        err_corr = 0;

        if (err_det) begin
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[0] = ~codeword_in[0];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[1] = ~codeword_in[1];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[2] = ~codeword_in[2];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[3] = ~codeword_in[3];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[4] = ~codeword_in[4];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[5] = ~codeword_in[5];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[6] = ~codeword_in[6];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[7] = ~codeword_in[7];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[8] = ~codeword_in[8];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[9] = ~codeword_in[9];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[10] = ~codeword_in[10];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[11] = ~codeword_in[11];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[12] = ~codeword_in[12];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[13] = ~codeword_in[13];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[14] = ~codeword_in[14];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[15] = ~codeword_in[15];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[16] = ~codeword_in[16];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[17] = ~codeword_in[17];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[18] = ~codeword_in[18];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[19] = ~codeword_in[19];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[20] = ~codeword_in[20];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[21] = ~codeword_in[21];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[22] = ~codeword_in[22];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[23] = ~codeword_in[23];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[24] = ~codeword_in[24];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[25] = ~codeword_in[25];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[26] = ~codeword_in[26];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[27] = ~codeword_in[27];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[28] = ~codeword_in[28];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[29] = ~codeword_in[29];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[30] = ~codeword_in[30];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[31] = ~codeword_in[31];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[32] = ~codeword_in[32];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[33] = ~codeword_in[33];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[34] = ~codeword_in[34];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[35] = ~codeword_in[35];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[36] = ~codeword_in[36];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[37] = ~codeword_in[37];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[38] = ~codeword_in[38];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[39] = ~codeword_in[39];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[40] = ~codeword_in[40];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[41] = ~codeword_in[41];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[42] = ~codeword_in[42];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[43] = ~codeword_in[43];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[44] = ~codeword_in[44];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[45] = ~codeword_in[45];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[46] = ~codeword_in[46];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[47] = ~codeword_in[47];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[48] = ~codeword_in[48];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[49] = ~codeword_in[49];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[50] = ~codeword_in[50];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[51] = ~codeword_in[51];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[52] = ~codeword_in[52];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[53] = ~codeword_in[53];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[54] = ~codeword_in[54];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[55] = ~codeword_in[55];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[56] = ~codeword_in[56];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[57] = ~codeword_in[57];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[58] = ~codeword_in[58];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[59] = ~codeword_in[59];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[60] = ~codeword_in[60];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[61] = ~codeword_in[61];
                err_corr = 1;
            end
            if (syndrome == 64'd6148914691236517205) begin
                corrected_data[62] = ~codeword_in[62];
                err_corr = 1;
            end
            if (syndrome == 64'd12297829382473034410) begin
                corrected_data[63] = ~codeword_in[63];
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