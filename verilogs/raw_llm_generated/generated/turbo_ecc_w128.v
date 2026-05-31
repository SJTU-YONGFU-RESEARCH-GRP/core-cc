// Generated turbo_ecc_w128 - Real Hardware Turbo (PCCC)
// Encoder: 2x (1 + D + D^2) Non-Systematic Convolutional Encoders (Matching Python)
// Interleaver: Fixed Random Permutation (Seed 42)
// Decoder: Hard-Decision Viterbi for Constituent Code 1

module turbo_ecc_w128 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [127:0] data_in,
    input  wire [383:0] codeword_in,
    output reg  [383:0] codeword_out,
    output reg  [127:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // Interleaver map
    wire [127:0] interleaved_data;
    assign interleaved_data[9] = data_in[0];
    assign interleaved_data[92] = data_in[1];
    assign interleaved_data[102] = data_in[2];
    assign interleaved_data[76] = data_in[3];
    assign interleaved_data[49] = data_in[4];
    assign interleaved_data[16] = data_in[5];
    assign interleaved_data[62] = data_in[6];
    assign interleaved_data[103] = data_in[7];
    assign interleaved_data[104] = data_in[8];
    assign interleaved_data[82] = data_in[9];
    assign interleaved_data[47] = data_in[10];
    assign interleaved_data[21] = data_in[11];
    assign interleaved_data[30] = data_in[12];
    assign interleaved_data[118] = data_in[13];
    assign interleaved_data[32] = data_in[14];
    assign interleaved_data[50] = data_in[15];
    assign interleaved_data[63] = data_in[16];
    assign interleaved_data[123] = data_in[17];
    assign interleaved_data[96] = data_in[18];
    assign interleaved_data[18] = data_in[19];
    assign interleaved_data[74] = data_in[20];
    assign interleaved_data[2] = data_in[21];
    assign interleaved_data[66] = data_in[22];
    assign interleaved_data[80] = data_in[23];
    assign interleaved_data[36] = data_in[24];
    assign interleaved_data[85] = data_in[25];
    assign interleaved_data[7] = data_in[26];
    assign interleaved_data[1] = data_in[27];
    assign interleaved_data[87] = data_in[28];
    assign interleaved_data[79] = data_in[29];
    assign interleaved_data[26] = data_in[30];
    assign interleaved_data[101] = data_in[31];
    assign interleaved_data[60] = data_in[32];
    assign interleaved_data[73] = data_in[33];
    assign interleaved_data[95] = data_in[34];
    assign interleaved_data[59] = data_in[35];
    assign interleaved_data[39] = data_in[36];
    assign interleaved_data[72] = data_in[37];
    assign interleaved_data[34] = data_in[38];
    assign interleaved_data[51] = data_in[39];
    assign interleaved_data[61] = data_in[40];
    assign interleaved_data[38] = data_in[41];
    assign interleaved_data[111] = data_in[42];
    assign interleaved_data[41] = data_in[43];
    assign interleaved_data[84] = data_in[44];
    assign interleaved_data[78] = data_in[45];
    assign interleaved_data[56] = data_in[46];
    assign interleaved_data[42] = data_in[47];
    assign interleaved_data[100] = data_in[48];
    assign interleaved_data[22] = data_in[49];
    assign interleaved_data[52] = data_in[50];
    assign interleaved_data[70] = data_in[51];
    assign interleaved_data[23] = data_in[52];
    assign interleaved_data[97] = data_in[53];
    assign interleaved_data[40] = data_in[54];
    assign interleaved_data[106] = data_in[55];
    assign interleaved_data[121] = data_in[56];
    assign interleaved_data[67] = data_in[57];
    assign interleaved_data[6] = data_in[58];
    assign interleaved_data[55] = data_in[59];
    assign interleaved_data[14] = data_in[60];
    assign interleaved_data[90] = data_in[61];
    assign interleaved_data[65] = data_in[62];
    assign interleaved_data[98] = data_in[63];
    assign interleaved_data[107] = data_in[64];
    assign interleaved_data[117] = data_in[65];
    assign interleaved_data[8] = data_in[66];
    assign interleaved_data[24] = data_in[67];
    assign interleaved_data[46] = data_in[68];
    assign interleaved_data[37] = data_in[69];
    assign interleaved_data[10] = data_in[70];
    assign interleaved_data[81] = data_in[71];
    assign interleaved_data[15] = data_in[72];
    assign interleaved_data[68] = data_in[73];
    assign interleaved_data[58] = data_in[74];
    assign interleaved_data[5] = data_in[75];
    assign interleaved_data[33] = data_in[76];
    assign interleaved_data[105] = data_in[77];
    assign interleaved_data[44] = data_in[78];
    assign interleaved_data[45] = data_in[79];
    assign interleaved_data[12] = data_in[80];
    assign interleaved_data[48] = data_in[81];
    assign interleaved_data[109] = data_in[82];
    assign interleaved_data[119] = data_in[83];
    assign interleaved_data[88] = data_in[84];
    assign interleaved_data[108] = data_in[85];
    assign interleaved_data[19] = data_in[86];
    assign interleaved_data[93] = data_in[87];
    assign interleaved_data[43] = data_in[88];
    assign interleaved_data[112] = data_in[89];
    assign interleaved_data[99] = data_in[90];
    assign interleaved_data[20] = data_in[91];
    assign interleaved_data[0] = data_in[92];
    assign interleaved_data[124] = data_in[93];
    assign interleaved_data[113] = data_in[94];
    assign interleaved_data[57] = data_in[95];
    assign interleaved_data[122] = data_in[96];
    assign interleaved_data[53] = data_in[97];
    assign interleaved_data[115] = data_in[98];
    assign interleaved_data[89] = data_in[99];
    assign interleaved_data[83] = data_in[100];
    assign interleaved_data[91] = data_in[101];
    assign interleaved_data[25] = data_in[102];
    assign interleaved_data[71] = data_in[103];
    assign interleaved_data[110] = data_in[104];
    assign interleaved_data[77] = data_in[105];
    assign interleaved_data[64] = data_in[106];
    assign interleaved_data[29] = data_in[107];
    assign interleaved_data[27] = data_in[108];
    assign interleaved_data[116] = data_in[109];
    assign interleaved_data[126] = data_in[110];
    assign interleaved_data[4] = data_in[111];
    assign interleaved_data[54] = data_in[112];
    assign interleaved_data[75] = data_in[113];
    assign interleaved_data[11] = data_in[114];
    assign interleaved_data[69] = data_in[115];
    assign interleaved_data[114] = data_in[116];
    assign interleaved_data[120] = data_in[117];
    assign interleaved_data[86] = data_in[118];
    assign interleaved_data[13] = data_in[119];
    assign interleaved_data[125] = data_in[120];
    assign interleaved_data[17] = data_in[121];
    assign interleaved_data[127] = data_in[122];
    assign interleaved_data[31] = data_in[123];
    assign interleaved_data[35] = data_in[124];
    assign interleaved_data[94] = data_in[125];
    assign interleaved_data[3] = data_in[126];
    assign interleaved_data[28] = data_in[127];
    wire [127:0] parity1;
    wire [127:0] parity2;
    assign parity1[0] = data_in[0] ^ 1'b0 ^ 1'b0;
    assign parity1[1] = data_in[1] ^ data_in[0] ^ 1'b0;
    assign parity1[2] = data_in[2] ^ data_in[1] ^ data_in[0];
    assign parity1[3] = data_in[3] ^ data_in[2] ^ data_in[1];
    assign parity1[4] = data_in[4] ^ data_in[3] ^ data_in[2];
    assign parity1[5] = data_in[5] ^ data_in[4] ^ data_in[3];
    assign parity1[6] = data_in[6] ^ data_in[5] ^ data_in[4];
    assign parity1[7] = data_in[7] ^ data_in[6] ^ data_in[5];
    assign parity1[8] = data_in[8] ^ data_in[7] ^ data_in[6];
    assign parity1[9] = data_in[9] ^ data_in[8] ^ data_in[7];
    assign parity1[10] = data_in[10] ^ data_in[9] ^ data_in[8];
    assign parity1[11] = data_in[11] ^ data_in[10] ^ data_in[9];
    assign parity1[12] = data_in[12] ^ data_in[11] ^ data_in[10];
    assign parity1[13] = data_in[13] ^ data_in[12] ^ data_in[11];
    assign parity1[14] = data_in[14] ^ data_in[13] ^ data_in[12];
    assign parity1[15] = data_in[15] ^ data_in[14] ^ data_in[13];
    assign parity1[16] = data_in[16] ^ data_in[15] ^ data_in[14];
    assign parity1[17] = data_in[17] ^ data_in[16] ^ data_in[15];
    assign parity1[18] = data_in[18] ^ data_in[17] ^ data_in[16];
    assign parity1[19] = data_in[19] ^ data_in[18] ^ data_in[17];
    assign parity1[20] = data_in[20] ^ data_in[19] ^ data_in[18];
    assign parity1[21] = data_in[21] ^ data_in[20] ^ data_in[19];
    assign parity1[22] = data_in[22] ^ data_in[21] ^ data_in[20];
    assign parity1[23] = data_in[23] ^ data_in[22] ^ data_in[21];
    assign parity1[24] = data_in[24] ^ data_in[23] ^ data_in[22];
    assign parity1[25] = data_in[25] ^ data_in[24] ^ data_in[23];
    assign parity1[26] = data_in[26] ^ data_in[25] ^ data_in[24];
    assign parity1[27] = data_in[27] ^ data_in[26] ^ data_in[25];
    assign parity1[28] = data_in[28] ^ data_in[27] ^ data_in[26];
    assign parity1[29] = data_in[29] ^ data_in[28] ^ data_in[27];
    assign parity1[30] = data_in[30] ^ data_in[29] ^ data_in[28];
    assign parity1[31] = data_in[31] ^ data_in[30] ^ data_in[29];
    assign parity1[32] = data_in[32] ^ data_in[31] ^ data_in[30];
    assign parity1[33] = data_in[33] ^ data_in[32] ^ data_in[31];
    assign parity1[34] = data_in[34] ^ data_in[33] ^ data_in[32];
    assign parity1[35] = data_in[35] ^ data_in[34] ^ data_in[33];
    assign parity1[36] = data_in[36] ^ data_in[35] ^ data_in[34];
    assign parity1[37] = data_in[37] ^ data_in[36] ^ data_in[35];
    assign parity1[38] = data_in[38] ^ data_in[37] ^ data_in[36];
    assign parity1[39] = data_in[39] ^ data_in[38] ^ data_in[37];
    assign parity1[40] = data_in[40] ^ data_in[39] ^ data_in[38];
    assign parity1[41] = data_in[41] ^ data_in[40] ^ data_in[39];
    assign parity1[42] = data_in[42] ^ data_in[41] ^ data_in[40];
    assign parity1[43] = data_in[43] ^ data_in[42] ^ data_in[41];
    assign parity1[44] = data_in[44] ^ data_in[43] ^ data_in[42];
    assign parity1[45] = data_in[45] ^ data_in[44] ^ data_in[43];
    assign parity1[46] = data_in[46] ^ data_in[45] ^ data_in[44];
    assign parity1[47] = data_in[47] ^ data_in[46] ^ data_in[45];
    assign parity1[48] = data_in[48] ^ data_in[47] ^ data_in[46];
    assign parity1[49] = data_in[49] ^ data_in[48] ^ data_in[47];
    assign parity1[50] = data_in[50] ^ data_in[49] ^ data_in[48];
    assign parity1[51] = data_in[51] ^ data_in[50] ^ data_in[49];
    assign parity1[52] = data_in[52] ^ data_in[51] ^ data_in[50];
    assign parity1[53] = data_in[53] ^ data_in[52] ^ data_in[51];
    assign parity1[54] = data_in[54] ^ data_in[53] ^ data_in[52];
    assign parity1[55] = data_in[55] ^ data_in[54] ^ data_in[53];
    assign parity1[56] = data_in[56] ^ data_in[55] ^ data_in[54];
    assign parity1[57] = data_in[57] ^ data_in[56] ^ data_in[55];
    assign parity1[58] = data_in[58] ^ data_in[57] ^ data_in[56];
    assign parity1[59] = data_in[59] ^ data_in[58] ^ data_in[57];
    assign parity1[60] = data_in[60] ^ data_in[59] ^ data_in[58];
    assign parity1[61] = data_in[61] ^ data_in[60] ^ data_in[59];
    assign parity1[62] = data_in[62] ^ data_in[61] ^ data_in[60];
    assign parity1[63] = data_in[63] ^ data_in[62] ^ data_in[61];
    assign parity1[64] = data_in[64] ^ data_in[63] ^ data_in[62];
    assign parity1[65] = data_in[65] ^ data_in[64] ^ data_in[63];
    assign parity1[66] = data_in[66] ^ data_in[65] ^ data_in[64];
    assign parity1[67] = data_in[67] ^ data_in[66] ^ data_in[65];
    assign parity1[68] = data_in[68] ^ data_in[67] ^ data_in[66];
    assign parity1[69] = data_in[69] ^ data_in[68] ^ data_in[67];
    assign parity1[70] = data_in[70] ^ data_in[69] ^ data_in[68];
    assign parity1[71] = data_in[71] ^ data_in[70] ^ data_in[69];
    assign parity1[72] = data_in[72] ^ data_in[71] ^ data_in[70];
    assign parity1[73] = data_in[73] ^ data_in[72] ^ data_in[71];
    assign parity1[74] = data_in[74] ^ data_in[73] ^ data_in[72];
    assign parity1[75] = data_in[75] ^ data_in[74] ^ data_in[73];
    assign parity1[76] = data_in[76] ^ data_in[75] ^ data_in[74];
    assign parity1[77] = data_in[77] ^ data_in[76] ^ data_in[75];
    assign parity1[78] = data_in[78] ^ data_in[77] ^ data_in[76];
    assign parity1[79] = data_in[79] ^ data_in[78] ^ data_in[77];
    assign parity1[80] = data_in[80] ^ data_in[79] ^ data_in[78];
    assign parity1[81] = data_in[81] ^ data_in[80] ^ data_in[79];
    assign parity1[82] = data_in[82] ^ data_in[81] ^ data_in[80];
    assign parity1[83] = data_in[83] ^ data_in[82] ^ data_in[81];
    assign parity1[84] = data_in[84] ^ data_in[83] ^ data_in[82];
    assign parity1[85] = data_in[85] ^ data_in[84] ^ data_in[83];
    assign parity1[86] = data_in[86] ^ data_in[85] ^ data_in[84];
    assign parity1[87] = data_in[87] ^ data_in[86] ^ data_in[85];
    assign parity1[88] = data_in[88] ^ data_in[87] ^ data_in[86];
    assign parity1[89] = data_in[89] ^ data_in[88] ^ data_in[87];
    assign parity1[90] = data_in[90] ^ data_in[89] ^ data_in[88];
    assign parity1[91] = data_in[91] ^ data_in[90] ^ data_in[89];
    assign parity1[92] = data_in[92] ^ data_in[91] ^ data_in[90];
    assign parity1[93] = data_in[93] ^ data_in[92] ^ data_in[91];
    assign parity1[94] = data_in[94] ^ data_in[93] ^ data_in[92];
    assign parity1[95] = data_in[95] ^ data_in[94] ^ data_in[93];
    assign parity1[96] = data_in[96] ^ data_in[95] ^ data_in[94];
    assign parity1[97] = data_in[97] ^ data_in[96] ^ data_in[95];
    assign parity1[98] = data_in[98] ^ data_in[97] ^ data_in[96];
    assign parity1[99] = data_in[99] ^ data_in[98] ^ data_in[97];
    assign parity1[100] = data_in[100] ^ data_in[99] ^ data_in[98];
    assign parity1[101] = data_in[101] ^ data_in[100] ^ data_in[99];
    assign parity1[102] = data_in[102] ^ data_in[101] ^ data_in[100];
    assign parity1[103] = data_in[103] ^ data_in[102] ^ data_in[101];
    assign parity1[104] = data_in[104] ^ data_in[103] ^ data_in[102];
    assign parity1[105] = data_in[105] ^ data_in[104] ^ data_in[103];
    assign parity1[106] = data_in[106] ^ data_in[105] ^ data_in[104];
    assign parity1[107] = data_in[107] ^ data_in[106] ^ data_in[105];
    assign parity1[108] = data_in[108] ^ data_in[107] ^ data_in[106];
    assign parity1[109] = data_in[109] ^ data_in[108] ^ data_in[107];
    assign parity1[110] = data_in[110] ^ data_in[109] ^ data_in[108];
    assign parity1[111] = data_in[111] ^ data_in[110] ^ data_in[109];
    assign parity1[112] = data_in[112] ^ data_in[111] ^ data_in[110];
    assign parity1[113] = data_in[113] ^ data_in[112] ^ data_in[111];
    assign parity1[114] = data_in[114] ^ data_in[113] ^ data_in[112];
    assign parity1[115] = data_in[115] ^ data_in[114] ^ data_in[113];
    assign parity1[116] = data_in[116] ^ data_in[115] ^ data_in[114];
    assign parity1[117] = data_in[117] ^ data_in[116] ^ data_in[115];
    assign parity1[118] = data_in[118] ^ data_in[117] ^ data_in[116];
    assign parity1[119] = data_in[119] ^ data_in[118] ^ data_in[117];
    assign parity1[120] = data_in[120] ^ data_in[119] ^ data_in[118];
    assign parity1[121] = data_in[121] ^ data_in[120] ^ data_in[119];
    assign parity1[122] = data_in[122] ^ data_in[121] ^ data_in[120];
    assign parity1[123] = data_in[123] ^ data_in[122] ^ data_in[121];
    assign parity1[124] = data_in[124] ^ data_in[123] ^ data_in[122];
    assign parity1[125] = data_in[125] ^ data_in[124] ^ data_in[123];
    assign parity1[126] = data_in[126] ^ data_in[125] ^ data_in[124];
    assign parity1[127] = data_in[127] ^ data_in[126] ^ data_in[125];
    assign parity2[0] = interleaved_data[0] ^ 1'b0 ^ 1'b0;
    assign parity2[1] = interleaved_data[1] ^ interleaved_data[0] ^ 1'b0;
    assign parity2[2] = interleaved_data[2] ^ interleaved_data[1] ^ interleaved_data[0];
    assign parity2[3] = interleaved_data[3] ^ interleaved_data[2] ^ interleaved_data[1];
    assign parity2[4] = interleaved_data[4] ^ interleaved_data[3] ^ interleaved_data[2];
    assign parity2[5] = interleaved_data[5] ^ interleaved_data[4] ^ interleaved_data[3];
    assign parity2[6] = interleaved_data[6] ^ interleaved_data[5] ^ interleaved_data[4];
    assign parity2[7] = interleaved_data[7] ^ interleaved_data[6] ^ interleaved_data[5];
    assign parity2[8] = interleaved_data[8] ^ interleaved_data[7] ^ interleaved_data[6];
    assign parity2[9] = interleaved_data[9] ^ interleaved_data[8] ^ interleaved_data[7];
    assign parity2[10] = interleaved_data[10] ^ interleaved_data[9] ^ interleaved_data[8];
    assign parity2[11] = interleaved_data[11] ^ interleaved_data[10] ^ interleaved_data[9];
    assign parity2[12] = interleaved_data[12] ^ interleaved_data[11] ^ interleaved_data[10];
    assign parity2[13] = interleaved_data[13] ^ interleaved_data[12] ^ interleaved_data[11];
    assign parity2[14] = interleaved_data[14] ^ interleaved_data[13] ^ interleaved_data[12];
    assign parity2[15] = interleaved_data[15] ^ interleaved_data[14] ^ interleaved_data[13];
    assign parity2[16] = interleaved_data[16] ^ interleaved_data[15] ^ interleaved_data[14];
    assign parity2[17] = interleaved_data[17] ^ interleaved_data[16] ^ interleaved_data[15];
    assign parity2[18] = interleaved_data[18] ^ interleaved_data[17] ^ interleaved_data[16];
    assign parity2[19] = interleaved_data[19] ^ interleaved_data[18] ^ interleaved_data[17];
    assign parity2[20] = interleaved_data[20] ^ interleaved_data[19] ^ interleaved_data[18];
    assign parity2[21] = interleaved_data[21] ^ interleaved_data[20] ^ interleaved_data[19];
    assign parity2[22] = interleaved_data[22] ^ interleaved_data[21] ^ interleaved_data[20];
    assign parity2[23] = interleaved_data[23] ^ interleaved_data[22] ^ interleaved_data[21];
    assign parity2[24] = interleaved_data[24] ^ interleaved_data[23] ^ interleaved_data[22];
    assign parity2[25] = interleaved_data[25] ^ interleaved_data[24] ^ interleaved_data[23];
    assign parity2[26] = interleaved_data[26] ^ interleaved_data[25] ^ interleaved_data[24];
    assign parity2[27] = interleaved_data[27] ^ interleaved_data[26] ^ interleaved_data[25];
    assign parity2[28] = interleaved_data[28] ^ interleaved_data[27] ^ interleaved_data[26];
    assign parity2[29] = interleaved_data[29] ^ interleaved_data[28] ^ interleaved_data[27];
    assign parity2[30] = interleaved_data[30] ^ interleaved_data[29] ^ interleaved_data[28];
    assign parity2[31] = interleaved_data[31] ^ interleaved_data[30] ^ interleaved_data[29];
    assign parity2[32] = interleaved_data[32] ^ interleaved_data[31] ^ interleaved_data[30];
    assign parity2[33] = interleaved_data[33] ^ interleaved_data[32] ^ interleaved_data[31];
    assign parity2[34] = interleaved_data[34] ^ interleaved_data[33] ^ interleaved_data[32];
    assign parity2[35] = interleaved_data[35] ^ interleaved_data[34] ^ interleaved_data[33];
    assign parity2[36] = interleaved_data[36] ^ interleaved_data[35] ^ interleaved_data[34];
    assign parity2[37] = interleaved_data[37] ^ interleaved_data[36] ^ interleaved_data[35];
    assign parity2[38] = interleaved_data[38] ^ interleaved_data[37] ^ interleaved_data[36];
    assign parity2[39] = interleaved_data[39] ^ interleaved_data[38] ^ interleaved_data[37];
    assign parity2[40] = interleaved_data[40] ^ interleaved_data[39] ^ interleaved_data[38];
    assign parity2[41] = interleaved_data[41] ^ interleaved_data[40] ^ interleaved_data[39];
    assign parity2[42] = interleaved_data[42] ^ interleaved_data[41] ^ interleaved_data[40];
    assign parity2[43] = interleaved_data[43] ^ interleaved_data[42] ^ interleaved_data[41];
    assign parity2[44] = interleaved_data[44] ^ interleaved_data[43] ^ interleaved_data[42];
    assign parity2[45] = interleaved_data[45] ^ interleaved_data[44] ^ interleaved_data[43];
    assign parity2[46] = interleaved_data[46] ^ interleaved_data[45] ^ interleaved_data[44];
    assign parity2[47] = interleaved_data[47] ^ interleaved_data[46] ^ interleaved_data[45];
    assign parity2[48] = interleaved_data[48] ^ interleaved_data[47] ^ interleaved_data[46];
    assign parity2[49] = interleaved_data[49] ^ interleaved_data[48] ^ interleaved_data[47];
    assign parity2[50] = interleaved_data[50] ^ interleaved_data[49] ^ interleaved_data[48];
    assign parity2[51] = interleaved_data[51] ^ interleaved_data[50] ^ interleaved_data[49];
    assign parity2[52] = interleaved_data[52] ^ interleaved_data[51] ^ interleaved_data[50];
    assign parity2[53] = interleaved_data[53] ^ interleaved_data[52] ^ interleaved_data[51];
    assign parity2[54] = interleaved_data[54] ^ interleaved_data[53] ^ interleaved_data[52];
    assign parity2[55] = interleaved_data[55] ^ interleaved_data[54] ^ interleaved_data[53];
    assign parity2[56] = interleaved_data[56] ^ interleaved_data[55] ^ interleaved_data[54];
    assign parity2[57] = interleaved_data[57] ^ interleaved_data[56] ^ interleaved_data[55];
    assign parity2[58] = interleaved_data[58] ^ interleaved_data[57] ^ interleaved_data[56];
    assign parity2[59] = interleaved_data[59] ^ interleaved_data[58] ^ interleaved_data[57];
    assign parity2[60] = interleaved_data[60] ^ interleaved_data[59] ^ interleaved_data[58];
    assign parity2[61] = interleaved_data[61] ^ interleaved_data[60] ^ interleaved_data[59];
    assign parity2[62] = interleaved_data[62] ^ interleaved_data[61] ^ interleaved_data[60];
    assign parity2[63] = interleaved_data[63] ^ interleaved_data[62] ^ interleaved_data[61];
    assign parity2[64] = interleaved_data[64] ^ interleaved_data[63] ^ interleaved_data[62];
    assign parity2[65] = interleaved_data[65] ^ interleaved_data[64] ^ interleaved_data[63];
    assign parity2[66] = interleaved_data[66] ^ interleaved_data[65] ^ interleaved_data[64];
    assign parity2[67] = interleaved_data[67] ^ interleaved_data[66] ^ interleaved_data[65];
    assign parity2[68] = interleaved_data[68] ^ interleaved_data[67] ^ interleaved_data[66];
    assign parity2[69] = interleaved_data[69] ^ interleaved_data[68] ^ interleaved_data[67];
    assign parity2[70] = interleaved_data[70] ^ interleaved_data[69] ^ interleaved_data[68];
    assign parity2[71] = interleaved_data[71] ^ interleaved_data[70] ^ interleaved_data[69];
    assign parity2[72] = interleaved_data[72] ^ interleaved_data[71] ^ interleaved_data[70];
    assign parity2[73] = interleaved_data[73] ^ interleaved_data[72] ^ interleaved_data[71];
    assign parity2[74] = interleaved_data[74] ^ interleaved_data[73] ^ interleaved_data[72];
    assign parity2[75] = interleaved_data[75] ^ interleaved_data[74] ^ interleaved_data[73];
    assign parity2[76] = interleaved_data[76] ^ interleaved_data[75] ^ interleaved_data[74];
    assign parity2[77] = interleaved_data[77] ^ interleaved_data[76] ^ interleaved_data[75];
    assign parity2[78] = interleaved_data[78] ^ interleaved_data[77] ^ interleaved_data[76];
    assign parity2[79] = interleaved_data[79] ^ interleaved_data[78] ^ interleaved_data[77];
    assign parity2[80] = interleaved_data[80] ^ interleaved_data[79] ^ interleaved_data[78];
    assign parity2[81] = interleaved_data[81] ^ interleaved_data[80] ^ interleaved_data[79];
    assign parity2[82] = interleaved_data[82] ^ interleaved_data[81] ^ interleaved_data[80];
    assign parity2[83] = interleaved_data[83] ^ interleaved_data[82] ^ interleaved_data[81];
    assign parity2[84] = interleaved_data[84] ^ interleaved_data[83] ^ interleaved_data[82];
    assign parity2[85] = interleaved_data[85] ^ interleaved_data[84] ^ interleaved_data[83];
    assign parity2[86] = interleaved_data[86] ^ interleaved_data[85] ^ interleaved_data[84];
    assign parity2[87] = interleaved_data[87] ^ interleaved_data[86] ^ interleaved_data[85];
    assign parity2[88] = interleaved_data[88] ^ interleaved_data[87] ^ interleaved_data[86];
    assign parity2[89] = interleaved_data[89] ^ interleaved_data[88] ^ interleaved_data[87];
    assign parity2[90] = interleaved_data[90] ^ interleaved_data[89] ^ interleaved_data[88];
    assign parity2[91] = interleaved_data[91] ^ interleaved_data[90] ^ interleaved_data[89];
    assign parity2[92] = interleaved_data[92] ^ interleaved_data[91] ^ interleaved_data[90];
    assign parity2[93] = interleaved_data[93] ^ interleaved_data[92] ^ interleaved_data[91];
    assign parity2[94] = interleaved_data[94] ^ interleaved_data[93] ^ interleaved_data[92];
    assign parity2[95] = interleaved_data[95] ^ interleaved_data[94] ^ interleaved_data[93];
    assign parity2[96] = interleaved_data[96] ^ interleaved_data[95] ^ interleaved_data[94];
    assign parity2[97] = interleaved_data[97] ^ interleaved_data[96] ^ interleaved_data[95];
    assign parity2[98] = interleaved_data[98] ^ interleaved_data[97] ^ interleaved_data[96];
    assign parity2[99] = interleaved_data[99] ^ interleaved_data[98] ^ interleaved_data[97];
    assign parity2[100] = interleaved_data[100] ^ interleaved_data[99] ^ interleaved_data[98];
    assign parity2[101] = interleaved_data[101] ^ interleaved_data[100] ^ interleaved_data[99];
    assign parity2[102] = interleaved_data[102] ^ interleaved_data[101] ^ interleaved_data[100];
    assign parity2[103] = interleaved_data[103] ^ interleaved_data[102] ^ interleaved_data[101];
    assign parity2[104] = interleaved_data[104] ^ interleaved_data[103] ^ interleaved_data[102];
    assign parity2[105] = interleaved_data[105] ^ interleaved_data[104] ^ interleaved_data[103];
    assign parity2[106] = interleaved_data[106] ^ interleaved_data[105] ^ interleaved_data[104];
    assign parity2[107] = interleaved_data[107] ^ interleaved_data[106] ^ interleaved_data[105];
    assign parity2[108] = interleaved_data[108] ^ interleaved_data[107] ^ interleaved_data[106];
    assign parity2[109] = interleaved_data[109] ^ interleaved_data[108] ^ interleaved_data[107];
    assign parity2[110] = interleaved_data[110] ^ interleaved_data[109] ^ interleaved_data[108];
    assign parity2[111] = interleaved_data[111] ^ interleaved_data[110] ^ interleaved_data[109];
    assign parity2[112] = interleaved_data[112] ^ interleaved_data[111] ^ interleaved_data[110];
    assign parity2[113] = interleaved_data[113] ^ interleaved_data[112] ^ interleaved_data[111];
    assign parity2[114] = interleaved_data[114] ^ interleaved_data[113] ^ interleaved_data[112];
    assign parity2[115] = interleaved_data[115] ^ interleaved_data[114] ^ interleaved_data[113];
    assign parity2[116] = interleaved_data[116] ^ interleaved_data[115] ^ interleaved_data[114];
    assign parity2[117] = interleaved_data[117] ^ interleaved_data[116] ^ interleaved_data[115];
    assign parity2[118] = interleaved_data[118] ^ interleaved_data[117] ^ interleaved_data[116];
    assign parity2[119] = interleaved_data[119] ^ interleaved_data[118] ^ interleaved_data[117];
    assign parity2[120] = interleaved_data[120] ^ interleaved_data[119] ^ interleaved_data[118];
    assign parity2[121] = interleaved_data[121] ^ interleaved_data[120] ^ interleaved_data[119];
    assign parity2[122] = interleaved_data[122] ^ interleaved_data[121] ^ interleaved_data[120];
    assign parity2[123] = interleaved_data[123] ^ interleaved_data[122] ^ interleaved_data[121];
    assign parity2[124] = interleaved_data[124] ^ interleaved_data[123] ^ interleaved_data[122];
    assign parity2[125] = interleaved_data[125] ^ interleaved_data[124] ^ interleaved_data[123];
    assign parity2[126] = interleaved_data[126] ^ interleaved_data[125] ^ interleaved_data[124];
    assign parity2[127] = interleaved_data[127] ^ interleaved_data[126] ^ interleaved_data[125];
    // Decoder: Viterbi Unrolled
    // Inputs
    wire [127:0] r_sys = codeword_in[127:0];
    wire [127:0] r_par1 = codeword_in[255:128];
    wire [8:0] pm_init_0 = 0;
    wire [8:0] pm_init_1 = 9'd255;
    wire [8:0] pm_init_2 = 9'd255;
    wire [8:0] pm_init_3 = 9'd255;
    // Stage 0
    wire [1:0] bm_0_0_from_0 = {1'b0, (r_sys[0] ^ 1'b0)} + {1'b0, (r_par1[0] ^ 1'b0)};
    wire [1:0] bm_0_0_from_2 = {1'b0, (r_sys[0] ^ 1'b0)} + {1'b0, (r_par1[0] ^ 1'b1)};
    wire [8:0] cand_0_0_1 = pm_init_0 + {7'b0, bm_0_0_from_0};
    wire [8:0] cand_0_0_2 = pm_init_2 + {7'b0, bm_0_0_from_2};
    wire sel_0_0 = (cand_0_0_1 > cand_0_0_2); // 1 if cand2 better
    wire [8:0] pm_0_0 = sel_0_0 ? cand_0_0_2 : cand_0_0_1;
    wire surv_0_0 = sel_0_0;
    wire [1:0] bm_0_1_from_0 = {1'b0, (r_sys[0] ^ 1'b1)} + {1'b0, (r_par1[0] ^ 1'b1)};
    wire [1:0] bm_0_1_from_2 = {1'b0, (r_sys[0] ^ 1'b1)} + {1'b0, (r_par1[0] ^ 1'b0)};
    wire [8:0] cand_0_1_1 = pm_init_0 + {7'b0, bm_0_1_from_0};
    wire [8:0] cand_0_1_2 = pm_init_2 + {7'b0, bm_0_1_from_2};
    wire sel_0_1 = (cand_0_1_1 > cand_0_1_2); // 1 if cand2 better
    wire [8:0] pm_0_1 = sel_0_1 ? cand_0_1_2 : cand_0_1_1;
    wire surv_0_1 = sel_0_1;
    wire [1:0] bm_0_2_from_1 = {1'b0, (r_sys[0] ^ 1'b0)} + {1'b0, (r_par1[0] ^ 1'b1)};
    wire [1:0] bm_0_2_from_3 = {1'b0, (r_sys[0] ^ 1'b0)} + {1'b0, (r_par1[0] ^ 1'b0)};
    wire [8:0] cand_0_2_1 = pm_init_1 + {7'b0, bm_0_2_from_1};
    wire [8:0] cand_0_2_2 = pm_init_3 + {7'b0, bm_0_2_from_3};
    wire sel_0_2 = (cand_0_2_1 > cand_0_2_2); // 1 if cand2 better
    wire [8:0] pm_0_2 = sel_0_2 ? cand_0_2_2 : cand_0_2_1;
    wire surv_0_2 = sel_0_2;
    wire [1:0] bm_0_3_from_1 = {1'b0, (r_sys[0] ^ 1'b1)} + {1'b0, (r_par1[0] ^ 1'b0)};
    wire [1:0] bm_0_3_from_3 = {1'b0, (r_sys[0] ^ 1'b1)} + {1'b0, (r_par1[0] ^ 1'b1)};
    wire [8:0] cand_0_3_1 = pm_init_1 + {7'b0, bm_0_3_from_1};
    wire [8:0] cand_0_3_2 = pm_init_3 + {7'b0, bm_0_3_from_3};
    wire sel_0_3 = (cand_0_3_1 > cand_0_3_2); // 1 if cand2 better
    wire [8:0] pm_0_3 = sel_0_3 ? cand_0_3_2 : cand_0_3_1;
    wire surv_0_3 = sel_0_3;
    // Stage 1
    wire [1:0] bm_1_0_from_0 = {1'b0, (r_sys[1] ^ 1'b0)} + {1'b0, (r_par1[1] ^ 1'b0)};
    wire [1:0] bm_1_0_from_2 = {1'b0, (r_sys[1] ^ 1'b0)} + {1'b0, (r_par1[1] ^ 1'b1)};
    wire [8:0] cand_1_0_1 = pm_0_0 + {7'b0, bm_1_0_from_0};
    wire [8:0] cand_1_0_2 = pm_0_2 + {7'b0, bm_1_0_from_2};
    wire sel_1_0 = (cand_1_0_1 > cand_1_0_2); // 1 if cand2 better
    wire [8:0] pm_1_0 = sel_1_0 ? cand_1_0_2 : cand_1_0_1;
    wire surv_1_0 = sel_1_0;
    wire [1:0] bm_1_1_from_0 = {1'b0, (r_sys[1] ^ 1'b1)} + {1'b0, (r_par1[1] ^ 1'b1)};
    wire [1:0] bm_1_1_from_2 = {1'b0, (r_sys[1] ^ 1'b1)} + {1'b0, (r_par1[1] ^ 1'b0)};
    wire [8:0] cand_1_1_1 = pm_0_0 + {7'b0, bm_1_1_from_0};
    wire [8:0] cand_1_1_2 = pm_0_2 + {7'b0, bm_1_1_from_2};
    wire sel_1_1 = (cand_1_1_1 > cand_1_1_2); // 1 if cand2 better
    wire [8:0] pm_1_1 = sel_1_1 ? cand_1_1_2 : cand_1_1_1;
    wire surv_1_1 = sel_1_1;
    wire [1:0] bm_1_2_from_1 = {1'b0, (r_sys[1] ^ 1'b0)} + {1'b0, (r_par1[1] ^ 1'b1)};
    wire [1:0] bm_1_2_from_3 = {1'b0, (r_sys[1] ^ 1'b0)} + {1'b0, (r_par1[1] ^ 1'b0)};
    wire [8:0] cand_1_2_1 = pm_0_1 + {7'b0, bm_1_2_from_1};
    wire [8:0] cand_1_2_2 = pm_0_3 + {7'b0, bm_1_2_from_3};
    wire sel_1_2 = (cand_1_2_1 > cand_1_2_2); // 1 if cand2 better
    wire [8:0] pm_1_2 = sel_1_2 ? cand_1_2_2 : cand_1_2_1;
    wire surv_1_2 = sel_1_2;
    wire [1:0] bm_1_3_from_1 = {1'b0, (r_sys[1] ^ 1'b1)} + {1'b0, (r_par1[1] ^ 1'b0)};
    wire [1:0] bm_1_3_from_3 = {1'b0, (r_sys[1] ^ 1'b1)} + {1'b0, (r_par1[1] ^ 1'b1)};
    wire [8:0] cand_1_3_1 = pm_0_1 + {7'b0, bm_1_3_from_1};
    wire [8:0] cand_1_3_2 = pm_0_3 + {7'b0, bm_1_3_from_3};
    wire sel_1_3 = (cand_1_3_1 > cand_1_3_2); // 1 if cand2 better
    wire [8:0] pm_1_3 = sel_1_3 ? cand_1_3_2 : cand_1_3_1;
    wire surv_1_3 = sel_1_3;
    // Stage 2
    wire [1:0] bm_2_0_from_0 = {1'b0, (r_sys[2] ^ 1'b0)} + {1'b0, (r_par1[2] ^ 1'b0)};
    wire [1:0] bm_2_0_from_2 = {1'b0, (r_sys[2] ^ 1'b0)} + {1'b0, (r_par1[2] ^ 1'b1)};
    wire [8:0] cand_2_0_1 = pm_1_0 + {7'b0, bm_2_0_from_0};
    wire [8:0] cand_2_0_2 = pm_1_2 + {7'b0, bm_2_0_from_2};
    wire sel_2_0 = (cand_2_0_1 > cand_2_0_2); // 1 if cand2 better
    wire [8:0] pm_2_0 = sel_2_0 ? cand_2_0_2 : cand_2_0_1;
    wire surv_2_0 = sel_2_0;
    wire [1:0] bm_2_1_from_0 = {1'b0, (r_sys[2] ^ 1'b1)} + {1'b0, (r_par1[2] ^ 1'b1)};
    wire [1:0] bm_2_1_from_2 = {1'b0, (r_sys[2] ^ 1'b1)} + {1'b0, (r_par1[2] ^ 1'b0)};
    wire [8:0] cand_2_1_1 = pm_1_0 + {7'b0, bm_2_1_from_0};
    wire [8:0] cand_2_1_2 = pm_1_2 + {7'b0, bm_2_1_from_2};
    wire sel_2_1 = (cand_2_1_1 > cand_2_1_2); // 1 if cand2 better
    wire [8:0] pm_2_1 = sel_2_1 ? cand_2_1_2 : cand_2_1_1;
    wire surv_2_1 = sel_2_1;
    wire [1:0] bm_2_2_from_1 = {1'b0, (r_sys[2] ^ 1'b0)} + {1'b0, (r_par1[2] ^ 1'b1)};
    wire [1:0] bm_2_2_from_3 = {1'b0, (r_sys[2] ^ 1'b0)} + {1'b0, (r_par1[2] ^ 1'b0)};
    wire [8:0] cand_2_2_1 = pm_1_1 + {7'b0, bm_2_2_from_1};
    wire [8:0] cand_2_2_2 = pm_1_3 + {7'b0, bm_2_2_from_3};
    wire sel_2_2 = (cand_2_2_1 > cand_2_2_2); // 1 if cand2 better
    wire [8:0] pm_2_2 = sel_2_2 ? cand_2_2_2 : cand_2_2_1;
    wire surv_2_2 = sel_2_2;
    wire [1:0] bm_2_3_from_1 = {1'b0, (r_sys[2] ^ 1'b1)} + {1'b0, (r_par1[2] ^ 1'b0)};
    wire [1:0] bm_2_3_from_3 = {1'b0, (r_sys[2] ^ 1'b1)} + {1'b0, (r_par1[2] ^ 1'b1)};
    wire [8:0] cand_2_3_1 = pm_1_1 + {7'b0, bm_2_3_from_1};
    wire [8:0] cand_2_3_2 = pm_1_3 + {7'b0, bm_2_3_from_3};
    wire sel_2_3 = (cand_2_3_1 > cand_2_3_2); // 1 if cand2 better
    wire [8:0] pm_2_3 = sel_2_3 ? cand_2_3_2 : cand_2_3_1;
    wire surv_2_3 = sel_2_3;
    // Stage 3
    wire [1:0] bm_3_0_from_0 = {1'b0, (r_sys[3] ^ 1'b0)} + {1'b0, (r_par1[3] ^ 1'b0)};
    wire [1:0] bm_3_0_from_2 = {1'b0, (r_sys[3] ^ 1'b0)} + {1'b0, (r_par1[3] ^ 1'b1)};
    wire [8:0] cand_3_0_1 = pm_2_0 + {7'b0, bm_3_0_from_0};
    wire [8:0] cand_3_0_2 = pm_2_2 + {7'b0, bm_3_0_from_2};
    wire sel_3_0 = (cand_3_0_1 > cand_3_0_2); // 1 if cand2 better
    wire [8:0] pm_3_0 = sel_3_0 ? cand_3_0_2 : cand_3_0_1;
    wire surv_3_0 = sel_3_0;
    wire [1:0] bm_3_1_from_0 = {1'b0, (r_sys[3] ^ 1'b1)} + {1'b0, (r_par1[3] ^ 1'b1)};
    wire [1:0] bm_3_1_from_2 = {1'b0, (r_sys[3] ^ 1'b1)} + {1'b0, (r_par1[3] ^ 1'b0)};
    wire [8:0] cand_3_1_1 = pm_2_0 + {7'b0, bm_3_1_from_0};
    wire [8:0] cand_3_1_2 = pm_2_2 + {7'b0, bm_3_1_from_2};
    wire sel_3_1 = (cand_3_1_1 > cand_3_1_2); // 1 if cand2 better
    wire [8:0] pm_3_1 = sel_3_1 ? cand_3_1_2 : cand_3_1_1;
    wire surv_3_1 = sel_3_1;
    wire [1:0] bm_3_2_from_1 = {1'b0, (r_sys[3] ^ 1'b0)} + {1'b0, (r_par1[3] ^ 1'b1)};
    wire [1:0] bm_3_2_from_3 = {1'b0, (r_sys[3] ^ 1'b0)} + {1'b0, (r_par1[3] ^ 1'b0)};
    wire [8:0] cand_3_2_1 = pm_2_1 + {7'b0, bm_3_2_from_1};
    wire [8:0] cand_3_2_2 = pm_2_3 + {7'b0, bm_3_2_from_3};
    wire sel_3_2 = (cand_3_2_1 > cand_3_2_2); // 1 if cand2 better
    wire [8:0] pm_3_2 = sel_3_2 ? cand_3_2_2 : cand_3_2_1;
    wire surv_3_2 = sel_3_2;
    wire [1:0] bm_3_3_from_1 = {1'b0, (r_sys[3] ^ 1'b1)} + {1'b0, (r_par1[3] ^ 1'b0)};
    wire [1:0] bm_3_3_from_3 = {1'b0, (r_sys[3] ^ 1'b1)} + {1'b0, (r_par1[3] ^ 1'b1)};
    wire [8:0] cand_3_3_1 = pm_2_1 + {7'b0, bm_3_3_from_1};
    wire [8:0] cand_3_3_2 = pm_2_3 + {7'b0, bm_3_3_from_3};
    wire sel_3_3 = (cand_3_3_1 > cand_3_3_2); // 1 if cand2 better
    wire [8:0] pm_3_3 = sel_3_3 ? cand_3_3_2 : cand_3_3_1;
    wire surv_3_3 = sel_3_3;
    // Stage 4
    wire [1:0] bm_4_0_from_0 = {1'b0, (r_sys[4] ^ 1'b0)} + {1'b0, (r_par1[4] ^ 1'b0)};
    wire [1:0] bm_4_0_from_2 = {1'b0, (r_sys[4] ^ 1'b0)} + {1'b0, (r_par1[4] ^ 1'b1)};
    wire [8:0] cand_4_0_1 = pm_3_0 + {7'b0, bm_4_0_from_0};
    wire [8:0] cand_4_0_2 = pm_3_2 + {7'b0, bm_4_0_from_2};
    wire sel_4_0 = (cand_4_0_1 > cand_4_0_2); // 1 if cand2 better
    wire [8:0] pm_4_0 = sel_4_0 ? cand_4_0_2 : cand_4_0_1;
    wire surv_4_0 = sel_4_0;
    wire [1:0] bm_4_1_from_0 = {1'b0, (r_sys[4] ^ 1'b1)} + {1'b0, (r_par1[4] ^ 1'b1)};
    wire [1:0] bm_4_1_from_2 = {1'b0, (r_sys[4] ^ 1'b1)} + {1'b0, (r_par1[4] ^ 1'b0)};
    wire [8:0] cand_4_1_1 = pm_3_0 + {7'b0, bm_4_1_from_0};
    wire [8:0] cand_4_1_2 = pm_3_2 + {7'b0, bm_4_1_from_2};
    wire sel_4_1 = (cand_4_1_1 > cand_4_1_2); // 1 if cand2 better
    wire [8:0] pm_4_1 = sel_4_1 ? cand_4_1_2 : cand_4_1_1;
    wire surv_4_1 = sel_4_1;
    wire [1:0] bm_4_2_from_1 = {1'b0, (r_sys[4] ^ 1'b0)} + {1'b0, (r_par1[4] ^ 1'b1)};
    wire [1:0] bm_4_2_from_3 = {1'b0, (r_sys[4] ^ 1'b0)} + {1'b0, (r_par1[4] ^ 1'b0)};
    wire [8:0] cand_4_2_1 = pm_3_1 + {7'b0, bm_4_2_from_1};
    wire [8:0] cand_4_2_2 = pm_3_3 + {7'b0, bm_4_2_from_3};
    wire sel_4_2 = (cand_4_2_1 > cand_4_2_2); // 1 if cand2 better
    wire [8:0] pm_4_2 = sel_4_2 ? cand_4_2_2 : cand_4_2_1;
    wire surv_4_2 = sel_4_2;
    wire [1:0] bm_4_3_from_1 = {1'b0, (r_sys[4] ^ 1'b1)} + {1'b0, (r_par1[4] ^ 1'b0)};
    wire [1:0] bm_4_3_from_3 = {1'b0, (r_sys[4] ^ 1'b1)} + {1'b0, (r_par1[4] ^ 1'b1)};
    wire [8:0] cand_4_3_1 = pm_3_1 + {7'b0, bm_4_3_from_1};
    wire [8:0] cand_4_3_2 = pm_3_3 + {7'b0, bm_4_3_from_3};
    wire sel_4_3 = (cand_4_3_1 > cand_4_3_2); // 1 if cand2 better
    wire [8:0] pm_4_3 = sel_4_3 ? cand_4_3_2 : cand_4_3_1;
    wire surv_4_3 = sel_4_3;
    // Stage 5
    wire [1:0] bm_5_0_from_0 = {1'b0, (r_sys[5] ^ 1'b0)} + {1'b0, (r_par1[5] ^ 1'b0)};
    wire [1:0] bm_5_0_from_2 = {1'b0, (r_sys[5] ^ 1'b0)} + {1'b0, (r_par1[5] ^ 1'b1)};
    wire [8:0] cand_5_0_1 = pm_4_0 + {7'b0, bm_5_0_from_0};
    wire [8:0] cand_5_0_2 = pm_4_2 + {7'b0, bm_5_0_from_2};
    wire sel_5_0 = (cand_5_0_1 > cand_5_0_2); // 1 if cand2 better
    wire [8:0] pm_5_0 = sel_5_0 ? cand_5_0_2 : cand_5_0_1;
    wire surv_5_0 = sel_5_0;
    wire [1:0] bm_5_1_from_0 = {1'b0, (r_sys[5] ^ 1'b1)} + {1'b0, (r_par1[5] ^ 1'b1)};
    wire [1:0] bm_5_1_from_2 = {1'b0, (r_sys[5] ^ 1'b1)} + {1'b0, (r_par1[5] ^ 1'b0)};
    wire [8:0] cand_5_1_1 = pm_4_0 + {7'b0, bm_5_1_from_0};
    wire [8:0] cand_5_1_2 = pm_4_2 + {7'b0, bm_5_1_from_2};
    wire sel_5_1 = (cand_5_1_1 > cand_5_1_2); // 1 if cand2 better
    wire [8:0] pm_5_1 = sel_5_1 ? cand_5_1_2 : cand_5_1_1;
    wire surv_5_1 = sel_5_1;
    wire [1:0] bm_5_2_from_1 = {1'b0, (r_sys[5] ^ 1'b0)} + {1'b0, (r_par1[5] ^ 1'b1)};
    wire [1:0] bm_5_2_from_3 = {1'b0, (r_sys[5] ^ 1'b0)} + {1'b0, (r_par1[5] ^ 1'b0)};
    wire [8:0] cand_5_2_1 = pm_4_1 + {7'b0, bm_5_2_from_1};
    wire [8:0] cand_5_2_2 = pm_4_3 + {7'b0, bm_5_2_from_3};
    wire sel_5_2 = (cand_5_2_1 > cand_5_2_2); // 1 if cand2 better
    wire [8:0] pm_5_2 = sel_5_2 ? cand_5_2_2 : cand_5_2_1;
    wire surv_5_2 = sel_5_2;
    wire [1:0] bm_5_3_from_1 = {1'b0, (r_sys[5] ^ 1'b1)} + {1'b0, (r_par1[5] ^ 1'b0)};
    wire [1:0] bm_5_3_from_3 = {1'b0, (r_sys[5] ^ 1'b1)} + {1'b0, (r_par1[5] ^ 1'b1)};
    wire [8:0] cand_5_3_1 = pm_4_1 + {7'b0, bm_5_3_from_1};
    wire [8:0] cand_5_3_2 = pm_4_3 + {7'b0, bm_5_3_from_3};
    wire sel_5_3 = (cand_5_3_1 > cand_5_3_2); // 1 if cand2 better
    wire [8:0] pm_5_3 = sel_5_3 ? cand_5_3_2 : cand_5_3_1;
    wire surv_5_3 = sel_5_3;
    // Stage 6
    wire [1:0] bm_6_0_from_0 = {1'b0, (r_sys[6] ^ 1'b0)} + {1'b0, (r_par1[6] ^ 1'b0)};
    wire [1:0] bm_6_0_from_2 = {1'b0, (r_sys[6] ^ 1'b0)} + {1'b0, (r_par1[6] ^ 1'b1)};
    wire [8:0] cand_6_0_1 = pm_5_0 + {7'b0, bm_6_0_from_0};
    wire [8:0] cand_6_0_2 = pm_5_2 + {7'b0, bm_6_0_from_2};
    wire sel_6_0 = (cand_6_0_1 > cand_6_0_2); // 1 if cand2 better
    wire [8:0] pm_6_0 = sel_6_0 ? cand_6_0_2 : cand_6_0_1;
    wire surv_6_0 = sel_6_0;
    wire [1:0] bm_6_1_from_0 = {1'b0, (r_sys[6] ^ 1'b1)} + {1'b0, (r_par1[6] ^ 1'b1)};
    wire [1:0] bm_6_1_from_2 = {1'b0, (r_sys[6] ^ 1'b1)} + {1'b0, (r_par1[6] ^ 1'b0)};
    wire [8:0] cand_6_1_1 = pm_5_0 + {7'b0, bm_6_1_from_0};
    wire [8:0] cand_6_1_2 = pm_5_2 + {7'b0, bm_6_1_from_2};
    wire sel_6_1 = (cand_6_1_1 > cand_6_1_2); // 1 if cand2 better
    wire [8:0] pm_6_1 = sel_6_1 ? cand_6_1_2 : cand_6_1_1;
    wire surv_6_1 = sel_6_1;
    wire [1:0] bm_6_2_from_1 = {1'b0, (r_sys[6] ^ 1'b0)} + {1'b0, (r_par1[6] ^ 1'b1)};
    wire [1:0] bm_6_2_from_3 = {1'b0, (r_sys[6] ^ 1'b0)} + {1'b0, (r_par1[6] ^ 1'b0)};
    wire [8:0] cand_6_2_1 = pm_5_1 + {7'b0, bm_6_2_from_1};
    wire [8:0] cand_6_2_2 = pm_5_3 + {7'b0, bm_6_2_from_3};
    wire sel_6_2 = (cand_6_2_1 > cand_6_2_2); // 1 if cand2 better
    wire [8:0] pm_6_2 = sel_6_2 ? cand_6_2_2 : cand_6_2_1;
    wire surv_6_2 = sel_6_2;
    wire [1:0] bm_6_3_from_1 = {1'b0, (r_sys[6] ^ 1'b1)} + {1'b0, (r_par1[6] ^ 1'b0)};
    wire [1:0] bm_6_3_from_3 = {1'b0, (r_sys[6] ^ 1'b1)} + {1'b0, (r_par1[6] ^ 1'b1)};
    wire [8:0] cand_6_3_1 = pm_5_1 + {7'b0, bm_6_3_from_1};
    wire [8:0] cand_6_3_2 = pm_5_3 + {7'b0, bm_6_3_from_3};
    wire sel_6_3 = (cand_6_3_1 > cand_6_3_2); // 1 if cand2 better
    wire [8:0] pm_6_3 = sel_6_3 ? cand_6_3_2 : cand_6_3_1;
    wire surv_6_3 = sel_6_3;
    // Stage 7
    wire [1:0] bm_7_0_from_0 = {1'b0, (r_sys[7] ^ 1'b0)} + {1'b0, (r_par1[7] ^ 1'b0)};
    wire [1:0] bm_7_0_from_2 = {1'b0, (r_sys[7] ^ 1'b0)} + {1'b0, (r_par1[7] ^ 1'b1)};
    wire [8:0] cand_7_0_1 = pm_6_0 + {7'b0, bm_7_0_from_0};
    wire [8:0] cand_7_0_2 = pm_6_2 + {7'b0, bm_7_0_from_2};
    wire sel_7_0 = (cand_7_0_1 > cand_7_0_2); // 1 if cand2 better
    wire [8:0] pm_7_0 = sel_7_0 ? cand_7_0_2 : cand_7_0_1;
    wire surv_7_0 = sel_7_0;
    wire [1:0] bm_7_1_from_0 = {1'b0, (r_sys[7] ^ 1'b1)} + {1'b0, (r_par1[7] ^ 1'b1)};
    wire [1:0] bm_7_1_from_2 = {1'b0, (r_sys[7] ^ 1'b1)} + {1'b0, (r_par1[7] ^ 1'b0)};
    wire [8:0] cand_7_1_1 = pm_6_0 + {7'b0, bm_7_1_from_0};
    wire [8:0] cand_7_1_2 = pm_6_2 + {7'b0, bm_7_1_from_2};
    wire sel_7_1 = (cand_7_1_1 > cand_7_1_2); // 1 if cand2 better
    wire [8:0] pm_7_1 = sel_7_1 ? cand_7_1_2 : cand_7_1_1;
    wire surv_7_1 = sel_7_1;
    wire [1:0] bm_7_2_from_1 = {1'b0, (r_sys[7] ^ 1'b0)} + {1'b0, (r_par1[7] ^ 1'b1)};
    wire [1:0] bm_7_2_from_3 = {1'b0, (r_sys[7] ^ 1'b0)} + {1'b0, (r_par1[7] ^ 1'b0)};
    wire [8:0] cand_7_2_1 = pm_6_1 + {7'b0, bm_7_2_from_1};
    wire [8:0] cand_7_2_2 = pm_6_3 + {7'b0, bm_7_2_from_3};
    wire sel_7_2 = (cand_7_2_1 > cand_7_2_2); // 1 if cand2 better
    wire [8:0] pm_7_2 = sel_7_2 ? cand_7_2_2 : cand_7_2_1;
    wire surv_7_2 = sel_7_2;
    wire [1:0] bm_7_3_from_1 = {1'b0, (r_sys[7] ^ 1'b1)} + {1'b0, (r_par1[7] ^ 1'b0)};
    wire [1:0] bm_7_3_from_3 = {1'b0, (r_sys[7] ^ 1'b1)} + {1'b0, (r_par1[7] ^ 1'b1)};
    wire [8:0] cand_7_3_1 = pm_6_1 + {7'b0, bm_7_3_from_1};
    wire [8:0] cand_7_3_2 = pm_6_3 + {7'b0, bm_7_3_from_3};
    wire sel_7_3 = (cand_7_3_1 > cand_7_3_2); // 1 if cand2 better
    wire [8:0] pm_7_3 = sel_7_3 ? cand_7_3_2 : cand_7_3_1;
    wire surv_7_3 = sel_7_3;
    // Stage 8
    wire [1:0] bm_8_0_from_0 = {1'b0, (r_sys[8] ^ 1'b0)} + {1'b0, (r_par1[8] ^ 1'b0)};
    wire [1:0] bm_8_0_from_2 = {1'b0, (r_sys[8] ^ 1'b0)} + {1'b0, (r_par1[8] ^ 1'b1)};
    wire [8:0] cand_8_0_1 = pm_7_0 + {7'b0, bm_8_0_from_0};
    wire [8:0] cand_8_0_2 = pm_7_2 + {7'b0, bm_8_0_from_2};
    wire sel_8_0 = (cand_8_0_1 > cand_8_0_2); // 1 if cand2 better
    wire [8:0] pm_8_0 = sel_8_0 ? cand_8_0_2 : cand_8_0_1;
    wire surv_8_0 = sel_8_0;
    wire [1:0] bm_8_1_from_0 = {1'b0, (r_sys[8] ^ 1'b1)} + {1'b0, (r_par1[8] ^ 1'b1)};
    wire [1:0] bm_8_1_from_2 = {1'b0, (r_sys[8] ^ 1'b1)} + {1'b0, (r_par1[8] ^ 1'b0)};
    wire [8:0] cand_8_1_1 = pm_7_0 + {7'b0, bm_8_1_from_0};
    wire [8:0] cand_8_1_2 = pm_7_2 + {7'b0, bm_8_1_from_2};
    wire sel_8_1 = (cand_8_1_1 > cand_8_1_2); // 1 if cand2 better
    wire [8:0] pm_8_1 = sel_8_1 ? cand_8_1_2 : cand_8_1_1;
    wire surv_8_1 = sel_8_1;
    wire [1:0] bm_8_2_from_1 = {1'b0, (r_sys[8] ^ 1'b0)} + {1'b0, (r_par1[8] ^ 1'b1)};
    wire [1:0] bm_8_2_from_3 = {1'b0, (r_sys[8] ^ 1'b0)} + {1'b0, (r_par1[8] ^ 1'b0)};
    wire [8:0] cand_8_2_1 = pm_7_1 + {7'b0, bm_8_2_from_1};
    wire [8:0] cand_8_2_2 = pm_7_3 + {7'b0, bm_8_2_from_3};
    wire sel_8_2 = (cand_8_2_1 > cand_8_2_2); // 1 if cand2 better
    wire [8:0] pm_8_2 = sel_8_2 ? cand_8_2_2 : cand_8_2_1;
    wire surv_8_2 = sel_8_2;
    wire [1:0] bm_8_3_from_1 = {1'b0, (r_sys[8] ^ 1'b1)} + {1'b0, (r_par1[8] ^ 1'b0)};
    wire [1:0] bm_8_3_from_3 = {1'b0, (r_sys[8] ^ 1'b1)} + {1'b0, (r_par1[8] ^ 1'b1)};
    wire [8:0] cand_8_3_1 = pm_7_1 + {7'b0, bm_8_3_from_1};
    wire [8:0] cand_8_3_2 = pm_7_3 + {7'b0, bm_8_3_from_3};
    wire sel_8_3 = (cand_8_3_1 > cand_8_3_2); // 1 if cand2 better
    wire [8:0] pm_8_3 = sel_8_3 ? cand_8_3_2 : cand_8_3_1;
    wire surv_8_3 = sel_8_3;
    // Stage 9
    wire [1:0] bm_9_0_from_0 = {1'b0, (r_sys[9] ^ 1'b0)} + {1'b0, (r_par1[9] ^ 1'b0)};
    wire [1:0] bm_9_0_from_2 = {1'b0, (r_sys[9] ^ 1'b0)} + {1'b0, (r_par1[9] ^ 1'b1)};
    wire [8:0] cand_9_0_1 = pm_8_0 + {7'b0, bm_9_0_from_0};
    wire [8:0] cand_9_0_2 = pm_8_2 + {7'b0, bm_9_0_from_2};
    wire sel_9_0 = (cand_9_0_1 > cand_9_0_2); // 1 if cand2 better
    wire [8:0] pm_9_0 = sel_9_0 ? cand_9_0_2 : cand_9_0_1;
    wire surv_9_0 = sel_9_0;
    wire [1:0] bm_9_1_from_0 = {1'b0, (r_sys[9] ^ 1'b1)} + {1'b0, (r_par1[9] ^ 1'b1)};
    wire [1:0] bm_9_1_from_2 = {1'b0, (r_sys[9] ^ 1'b1)} + {1'b0, (r_par1[9] ^ 1'b0)};
    wire [8:0] cand_9_1_1 = pm_8_0 + {7'b0, bm_9_1_from_0};
    wire [8:0] cand_9_1_2 = pm_8_2 + {7'b0, bm_9_1_from_2};
    wire sel_9_1 = (cand_9_1_1 > cand_9_1_2); // 1 if cand2 better
    wire [8:0] pm_9_1 = sel_9_1 ? cand_9_1_2 : cand_9_1_1;
    wire surv_9_1 = sel_9_1;
    wire [1:0] bm_9_2_from_1 = {1'b0, (r_sys[9] ^ 1'b0)} + {1'b0, (r_par1[9] ^ 1'b1)};
    wire [1:0] bm_9_2_from_3 = {1'b0, (r_sys[9] ^ 1'b0)} + {1'b0, (r_par1[9] ^ 1'b0)};
    wire [8:0] cand_9_2_1 = pm_8_1 + {7'b0, bm_9_2_from_1};
    wire [8:0] cand_9_2_2 = pm_8_3 + {7'b0, bm_9_2_from_3};
    wire sel_9_2 = (cand_9_2_1 > cand_9_2_2); // 1 if cand2 better
    wire [8:0] pm_9_2 = sel_9_2 ? cand_9_2_2 : cand_9_2_1;
    wire surv_9_2 = sel_9_2;
    wire [1:0] bm_9_3_from_1 = {1'b0, (r_sys[9] ^ 1'b1)} + {1'b0, (r_par1[9] ^ 1'b0)};
    wire [1:0] bm_9_3_from_3 = {1'b0, (r_sys[9] ^ 1'b1)} + {1'b0, (r_par1[9] ^ 1'b1)};
    wire [8:0] cand_9_3_1 = pm_8_1 + {7'b0, bm_9_3_from_1};
    wire [8:0] cand_9_3_2 = pm_8_3 + {7'b0, bm_9_3_from_3};
    wire sel_9_3 = (cand_9_3_1 > cand_9_3_2); // 1 if cand2 better
    wire [8:0] pm_9_3 = sel_9_3 ? cand_9_3_2 : cand_9_3_1;
    wire surv_9_3 = sel_9_3;
    // Stage 10
    wire [1:0] bm_10_0_from_0 = {1'b0, (r_sys[10] ^ 1'b0)} + {1'b0, (r_par1[10] ^ 1'b0)};
    wire [1:0] bm_10_0_from_2 = {1'b0, (r_sys[10] ^ 1'b0)} + {1'b0, (r_par1[10] ^ 1'b1)};
    wire [8:0] cand_10_0_1 = pm_9_0 + {7'b0, bm_10_0_from_0};
    wire [8:0] cand_10_0_2 = pm_9_2 + {7'b0, bm_10_0_from_2};
    wire sel_10_0 = (cand_10_0_1 > cand_10_0_2); // 1 if cand2 better
    wire [8:0] pm_10_0 = sel_10_0 ? cand_10_0_2 : cand_10_0_1;
    wire surv_10_0 = sel_10_0;
    wire [1:0] bm_10_1_from_0 = {1'b0, (r_sys[10] ^ 1'b1)} + {1'b0, (r_par1[10] ^ 1'b1)};
    wire [1:0] bm_10_1_from_2 = {1'b0, (r_sys[10] ^ 1'b1)} + {1'b0, (r_par1[10] ^ 1'b0)};
    wire [8:0] cand_10_1_1 = pm_9_0 + {7'b0, bm_10_1_from_0};
    wire [8:0] cand_10_1_2 = pm_9_2 + {7'b0, bm_10_1_from_2};
    wire sel_10_1 = (cand_10_1_1 > cand_10_1_2); // 1 if cand2 better
    wire [8:0] pm_10_1 = sel_10_1 ? cand_10_1_2 : cand_10_1_1;
    wire surv_10_1 = sel_10_1;
    wire [1:0] bm_10_2_from_1 = {1'b0, (r_sys[10] ^ 1'b0)} + {1'b0, (r_par1[10] ^ 1'b1)};
    wire [1:0] bm_10_2_from_3 = {1'b0, (r_sys[10] ^ 1'b0)} + {1'b0, (r_par1[10] ^ 1'b0)};
    wire [8:0] cand_10_2_1 = pm_9_1 + {7'b0, bm_10_2_from_1};
    wire [8:0] cand_10_2_2 = pm_9_3 + {7'b0, bm_10_2_from_3};
    wire sel_10_2 = (cand_10_2_1 > cand_10_2_2); // 1 if cand2 better
    wire [8:0] pm_10_2 = sel_10_2 ? cand_10_2_2 : cand_10_2_1;
    wire surv_10_2 = sel_10_2;
    wire [1:0] bm_10_3_from_1 = {1'b0, (r_sys[10] ^ 1'b1)} + {1'b0, (r_par1[10] ^ 1'b0)};
    wire [1:0] bm_10_3_from_3 = {1'b0, (r_sys[10] ^ 1'b1)} + {1'b0, (r_par1[10] ^ 1'b1)};
    wire [8:0] cand_10_3_1 = pm_9_1 + {7'b0, bm_10_3_from_1};
    wire [8:0] cand_10_3_2 = pm_9_3 + {7'b0, bm_10_3_from_3};
    wire sel_10_3 = (cand_10_3_1 > cand_10_3_2); // 1 if cand2 better
    wire [8:0] pm_10_3 = sel_10_3 ? cand_10_3_2 : cand_10_3_1;
    wire surv_10_3 = sel_10_3;
    // Stage 11
    wire [1:0] bm_11_0_from_0 = {1'b0, (r_sys[11] ^ 1'b0)} + {1'b0, (r_par1[11] ^ 1'b0)};
    wire [1:0] bm_11_0_from_2 = {1'b0, (r_sys[11] ^ 1'b0)} + {1'b0, (r_par1[11] ^ 1'b1)};
    wire [8:0] cand_11_0_1 = pm_10_0 + {7'b0, bm_11_0_from_0};
    wire [8:0] cand_11_0_2 = pm_10_2 + {7'b0, bm_11_0_from_2};
    wire sel_11_0 = (cand_11_0_1 > cand_11_0_2); // 1 if cand2 better
    wire [8:0] pm_11_0 = sel_11_0 ? cand_11_0_2 : cand_11_0_1;
    wire surv_11_0 = sel_11_0;
    wire [1:0] bm_11_1_from_0 = {1'b0, (r_sys[11] ^ 1'b1)} + {1'b0, (r_par1[11] ^ 1'b1)};
    wire [1:0] bm_11_1_from_2 = {1'b0, (r_sys[11] ^ 1'b1)} + {1'b0, (r_par1[11] ^ 1'b0)};
    wire [8:0] cand_11_1_1 = pm_10_0 + {7'b0, bm_11_1_from_0};
    wire [8:0] cand_11_1_2 = pm_10_2 + {7'b0, bm_11_1_from_2};
    wire sel_11_1 = (cand_11_1_1 > cand_11_1_2); // 1 if cand2 better
    wire [8:0] pm_11_1 = sel_11_1 ? cand_11_1_2 : cand_11_1_1;
    wire surv_11_1 = sel_11_1;
    wire [1:0] bm_11_2_from_1 = {1'b0, (r_sys[11] ^ 1'b0)} + {1'b0, (r_par1[11] ^ 1'b1)};
    wire [1:0] bm_11_2_from_3 = {1'b0, (r_sys[11] ^ 1'b0)} + {1'b0, (r_par1[11] ^ 1'b0)};
    wire [8:0] cand_11_2_1 = pm_10_1 + {7'b0, bm_11_2_from_1};
    wire [8:0] cand_11_2_2 = pm_10_3 + {7'b0, bm_11_2_from_3};
    wire sel_11_2 = (cand_11_2_1 > cand_11_2_2); // 1 if cand2 better
    wire [8:0] pm_11_2 = sel_11_2 ? cand_11_2_2 : cand_11_2_1;
    wire surv_11_2 = sel_11_2;
    wire [1:0] bm_11_3_from_1 = {1'b0, (r_sys[11] ^ 1'b1)} + {1'b0, (r_par1[11] ^ 1'b0)};
    wire [1:0] bm_11_3_from_3 = {1'b0, (r_sys[11] ^ 1'b1)} + {1'b0, (r_par1[11] ^ 1'b1)};
    wire [8:0] cand_11_3_1 = pm_10_1 + {7'b0, bm_11_3_from_1};
    wire [8:0] cand_11_3_2 = pm_10_3 + {7'b0, bm_11_3_from_3};
    wire sel_11_3 = (cand_11_3_1 > cand_11_3_2); // 1 if cand2 better
    wire [8:0] pm_11_3 = sel_11_3 ? cand_11_3_2 : cand_11_3_1;
    wire surv_11_3 = sel_11_3;
    // Stage 12
    wire [1:0] bm_12_0_from_0 = {1'b0, (r_sys[12] ^ 1'b0)} + {1'b0, (r_par1[12] ^ 1'b0)};
    wire [1:0] bm_12_0_from_2 = {1'b0, (r_sys[12] ^ 1'b0)} + {1'b0, (r_par1[12] ^ 1'b1)};
    wire [8:0] cand_12_0_1 = pm_11_0 + {7'b0, bm_12_0_from_0};
    wire [8:0] cand_12_0_2 = pm_11_2 + {7'b0, bm_12_0_from_2};
    wire sel_12_0 = (cand_12_0_1 > cand_12_0_2); // 1 if cand2 better
    wire [8:0] pm_12_0 = sel_12_0 ? cand_12_0_2 : cand_12_0_1;
    wire surv_12_0 = sel_12_0;
    wire [1:0] bm_12_1_from_0 = {1'b0, (r_sys[12] ^ 1'b1)} + {1'b0, (r_par1[12] ^ 1'b1)};
    wire [1:0] bm_12_1_from_2 = {1'b0, (r_sys[12] ^ 1'b1)} + {1'b0, (r_par1[12] ^ 1'b0)};
    wire [8:0] cand_12_1_1 = pm_11_0 + {7'b0, bm_12_1_from_0};
    wire [8:0] cand_12_1_2 = pm_11_2 + {7'b0, bm_12_1_from_2};
    wire sel_12_1 = (cand_12_1_1 > cand_12_1_2); // 1 if cand2 better
    wire [8:0] pm_12_1 = sel_12_1 ? cand_12_1_2 : cand_12_1_1;
    wire surv_12_1 = sel_12_1;
    wire [1:0] bm_12_2_from_1 = {1'b0, (r_sys[12] ^ 1'b0)} + {1'b0, (r_par1[12] ^ 1'b1)};
    wire [1:0] bm_12_2_from_3 = {1'b0, (r_sys[12] ^ 1'b0)} + {1'b0, (r_par1[12] ^ 1'b0)};
    wire [8:0] cand_12_2_1 = pm_11_1 + {7'b0, bm_12_2_from_1};
    wire [8:0] cand_12_2_2 = pm_11_3 + {7'b0, bm_12_2_from_3};
    wire sel_12_2 = (cand_12_2_1 > cand_12_2_2); // 1 if cand2 better
    wire [8:0] pm_12_2 = sel_12_2 ? cand_12_2_2 : cand_12_2_1;
    wire surv_12_2 = sel_12_2;
    wire [1:0] bm_12_3_from_1 = {1'b0, (r_sys[12] ^ 1'b1)} + {1'b0, (r_par1[12] ^ 1'b0)};
    wire [1:0] bm_12_3_from_3 = {1'b0, (r_sys[12] ^ 1'b1)} + {1'b0, (r_par1[12] ^ 1'b1)};
    wire [8:0] cand_12_3_1 = pm_11_1 + {7'b0, bm_12_3_from_1};
    wire [8:0] cand_12_3_2 = pm_11_3 + {7'b0, bm_12_3_from_3};
    wire sel_12_3 = (cand_12_3_1 > cand_12_3_2); // 1 if cand2 better
    wire [8:0] pm_12_3 = sel_12_3 ? cand_12_3_2 : cand_12_3_1;
    wire surv_12_3 = sel_12_3;
    // Stage 13
    wire [1:0] bm_13_0_from_0 = {1'b0, (r_sys[13] ^ 1'b0)} + {1'b0, (r_par1[13] ^ 1'b0)};
    wire [1:0] bm_13_0_from_2 = {1'b0, (r_sys[13] ^ 1'b0)} + {1'b0, (r_par1[13] ^ 1'b1)};
    wire [8:0] cand_13_0_1 = pm_12_0 + {7'b0, bm_13_0_from_0};
    wire [8:0] cand_13_0_2 = pm_12_2 + {7'b0, bm_13_0_from_2};
    wire sel_13_0 = (cand_13_0_1 > cand_13_0_2); // 1 if cand2 better
    wire [8:0] pm_13_0 = sel_13_0 ? cand_13_0_2 : cand_13_0_1;
    wire surv_13_0 = sel_13_0;
    wire [1:0] bm_13_1_from_0 = {1'b0, (r_sys[13] ^ 1'b1)} + {1'b0, (r_par1[13] ^ 1'b1)};
    wire [1:0] bm_13_1_from_2 = {1'b0, (r_sys[13] ^ 1'b1)} + {1'b0, (r_par1[13] ^ 1'b0)};
    wire [8:0] cand_13_1_1 = pm_12_0 + {7'b0, bm_13_1_from_0};
    wire [8:0] cand_13_1_2 = pm_12_2 + {7'b0, bm_13_1_from_2};
    wire sel_13_1 = (cand_13_1_1 > cand_13_1_2); // 1 if cand2 better
    wire [8:0] pm_13_1 = sel_13_1 ? cand_13_1_2 : cand_13_1_1;
    wire surv_13_1 = sel_13_1;
    wire [1:0] bm_13_2_from_1 = {1'b0, (r_sys[13] ^ 1'b0)} + {1'b0, (r_par1[13] ^ 1'b1)};
    wire [1:0] bm_13_2_from_3 = {1'b0, (r_sys[13] ^ 1'b0)} + {1'b0, (r_par1[13] ^ 1'b0)};
    wire [8:0] cand_13_2_1 = pm_12_1 + {7'b0, bm_13_2_from_1};
    wire [8:0] cand_13_2_2 = pm_12_3 + {7'b0, bm_13_2_from_3};
    wire sel_13_2 = (cand_13_2_1 > cand_13_2_2); // 1 if cand2 better
    wire [8:0] pm_13_2 = sel_13_2 ? cand_13_2_2 : cand_13_2_1;
    wire surv_13_2 = sel_13_2;
    wire [1:0] bm_13_3_from_1 = {1'b0, (r_sys[13] ^ 1'b1)} + {1'b0, (r_par1[13] ^ 1'b0)};
    wire [1:0] bm_13_3_from_3 = {1'b0, (r_sys[13] ^ 1'b1)} + {1'b0, (r_par1[13] ^ 1'b1)};
    wire [8:0] cand_13_3_1 = pm_12_1 + {7'b0, bm_13_3_from_1};
    wire [8:0] cand_13_3_2 = pm_12_3 + {7'b0, bm_13_3_from_3};
    wire sel_13_3 = (cand_13_3_1 > cand_13_3_2); // 1 if cand2 better
    wire [8:0] pm_13_3 = sel_13_3 ? cand_13_3_2 : cand_13_3_1;
    wire surv_13_3 = sel_13_3;
    // Stage 14
    wire [1:0] bm_14_0_from_0 = {1'b0, (r_sys[14] ^ 1'b0)} + {1'b0, (r_par1[14] ^ 1'b0)};
    wire [1:0] bm_14_0_from_2 = {1'b0, (r_sys[14] ^ 1'b0)} + {1'b0, (r_par1[14] ^ 1'b1)};
    wire [8:0] cand_14_0_1 = pm_13_0 + {7'b0, bm_14_0_from_0};
    wire [8:0] cand_14_0_2 = pm_13_2 + {7'b0, bm_14_0_from_2};
    wire sel_14_0 = (cand_14_0_1 > cand_14_0_2); // 1 if cand2 better
    wire [8:0] pm_14_0 = sel_14_0 ? cand_14_0_2 : cand_14_0_1;
    wire surv_14_0 = sel_14_0;
    wire [1:0] bm_14_1_from_0 = {1'b0, (r_sys[14] ^ 1'b1)} + {1'b0, (r_par1[14] ^ 1'b1)};
    wire [1:0] bm_14_1_from_2 = {1'b0, (r_sys[14] ^ 1'b1)} + {1'b0, (r_par1[14] ^ 1'b0)};
    wire [8:0] cand_14_1_1 = pm_13_0 + {7'b0, bm_14_1_from_0};
    wire [8:0] cand_14_1_2 = pm_13_2 + {7'b0, bm_14_1_from_2};
    wire sel_14_1 = (cand_14_1_1 > cand_14_1_2); // 1 if cand2 better
    wire [8:0] pm_14_1 = sel_14_1 ? cand_14_1_2 : cand_14_1_1;
    wire surv_14_1 = sel_14_1;
    wire [1:0] bm_14_2_from_1 = {1'b0, (r_sys[14] ^ 1'b0)} + {1'b0, (r_par1[14] ^ 1'b1)};
    wire [1:0] bm_14_2_from_3 = {1'b0, (r_sys[14] ^ 1'b0)} + {1'b0, (r_par1[14] ^ 1'b0)};
    wire [8:0] cand_14_2_1 = pm_13_1 + {7'b0, bm_14_2_from_1};
    wire [8:0] cand_14_2_2 = pm_13_3 + {7'b0, bm_14_2_from_3};
    wire sel_14_2 = (cand_14_2_1 > cand_14_2_2); // 1 if cand2 better
    wire [8:0] pm_14_2 = sel_14_2 ? cand_14_2_2 : cand_14_2_1;
    wire surv_14_2 = sel_14_2;
    wire [1:0] bm_14_3_from_1 = {1'b0, (r_sys[14] ^ 1'b1)} + {1'b0, (r_par1[14] ^ 1'b0)};
    wire [1:0] bm_14_3_from_3 = {1'b0, (r_sys[14] ^ 1'b1)} + {1'b0, (r_par1[14] ^ 1'b1)};
    wire [8:0] cand_14_3_1 = pm_13_1 + {7'b0, bm_14_3_from_1};
    wire [8:0] cand_14_3_2 = pm_13_3 + {7'b0, bm_14_3_from_3};
    wire sel_14_3 = (cand_14_3_1 > cand_14_3_2); // 1 if cand2 better
    wire [8:0] pm_14_3 = sel_14_3 ? cand_14_3_2 : cand_14_3_1;
    wire surv_14_3 = sel_14_3;
    // Stage 15
    wire [1:0] bm_15_0_from_0 = {1'b0, (r_sys[15] ^ 1'b0)} + {1'b0, (r_par1[15] ^ 1'b0)};
    wire [1:0] bm_15_0_from_2 = {1'b0, (r_sys[15] ^ 1'b0)} + {1'b0, (r_par1[15] ^ 1'b1)};
    wire [8:0] cand_15_0_1 = pm_14_0 + {7'b0, bm_15_0_from_0};
    wire [8:0] cand_15_0_2 = pm_14_2 + {7'b0, bm_15_0_from_2};
    wire sel_15_0 = (cand_15_0_1 > cand_15_0_2); // 1 if cand2 better
    wire [8:0] pm_15_0 = sel_15_0 ? cand_15_0_2 : cand_15_0_1;
    wire surv_15_0 = sel_15_0;
    wire [1:0] bm_15_1_from_0 = {1'b0, (r_sys[15] ^ 1'b1)} + {1'b0, (r_par1[15] ^ 1'b1)};
    wire [1:0] bm_15_1_from_2 = {1'b0, (r_sys[15] ^ 1'b1)} + {1'b0, (r_par1[15] ^ 1'b0)};
    wire [8:0] cand_15_1_1 = pm_14_0 + {7'b0, bm_15_1_from_0};
    wire [8:0] cand_15_1_2 = pm_14_2 + {7'b0, bm_15_1_from_2};
    wire sel_15_1 = (cand_15_1_1 > cand_15_1_2); // 1 if cand2 better
    wire [8:0] pm_15_1 = sel_15_1 ? cand_15_1_2 : cand_15_1_1;
    wire surv_15_1 = sel_15_1;
    wire [1:0] bm_15_2_from_1 = {1'b0, (r_sys[15] ^ 1'b0)} + {1'b0, (r_par1[15] ^ 1'b1)};
    wire [1:0] bm_15_2_from_3 = {1'b0, (r_sys[15] ^ 1'b0)} + {1'b0, (r_par1[15] ^ 1'b0)};
    wire [8:0] cand_15_2_1 = pm_14_1 + {7'b0, bm_15_2_from_1};
    wire [8:0] cand_15_2_2 = pm_14_3 + {7'b0, bm_15_2_from_3};
    wire sel_15_2 = (cand_15_2_1 > cand_15_2_2); // 1 if cand2 better
    wire [8:0] pm_15_2 = sel_15_2 ? cand_15_2_2 : cand_15_2_1;
    wire surv_15_2 = sel_15_2;
    wire [1:0] bm_15_3_from_1 = {1'b0, (r_sys[15] ^ 1'b1)} + {1'b0, (r_par1[15] ^ 1'b0)};
    wire [1:0] bm_15_3_from_3 = {1'b0, (r_sys[15] ^ 1'b1)} + {1'b0, (r_par1[15] ^ 1'b1)};
    wire [8:0] cand_15_3_1 = pm_14_1 + {7'b0, bm_15_3_from_1};
    wire [8:0] cand_15_3_2 = pm_14_3 + {7'b0, bm_15_3_from_3};
    wire sel_15_3 = (cand_15_3_1 > cand_15_3_2); // 1 if cand2 better
    wire [8:0] pm_15_3 = sel_15_3 ? cand_15_3_2 : cand_15_3_1;
    wire surv_15_3 = sel_15_3;
    // Stage 16
    wire [1:0] bm_16_0_from_0 = {1'b0, (r_sys[16] ^ 1'b0)} + {1'b0, (r_par1[16] ^ 1'b0)};
    wire [1:0] bm_16_0_from_2 = {1'b0, (r_sys[16] ^ 1'b0)} + {1'b0, (r_par1[16] ^ 1'b1)};
    wire [8:0] cand_16_0_1 = pm_15_0 + {7'b0, bm_16_0_from_0};
    wire [8:0] cand_16_0_2 = pm_15_2 + {7'b0, bm_16_0_from_2};
    wire sel_16_0 = (cand_16_0_1 > cand_16_0_2); // 1 if cand2 better
    wire [8:0] pm_16_0 = sel_16_0 ? cand_16_0_2 : cand_16_0_1;
    wire surv_16_0 = sel_16_0;
    wire [1:0] bm_16_1_from_0 = {1'b0, (r_sys[16] ^ 1'b1)} + {1'b0, (r_par1[16] ^ 1'b1)};
    wire [1:0] bm_16_1_from_2 = {1'b0, (r_sys[16] ^ 1'b1)} + {1'b0, (r_par1[16] ^ 1'b0)};
    wire [8:0] cand_16_1_1 = pm_15_0 + {7'b0, bm_16_1_from_0};
    wire [8:0] cand_16_1_2 = pm_15_2 + {7'b0, bm_16_1_from_2};
    wire sel_16_1 = (cand_16_1_1 > cand_16_1_2); // 1 if cand2 better
    wire [8:0] pm_16_1 = sel_16_1 ? cand_16_1_2 : cand_16_1_1;
    wire surv_16_1 = sel_16_1;
    wire [1:0] bm_16_2_from_1 = {1'b0, (r_sys[16] ^ 1'b0)} + {1'b0, (r_par1[16] ^ 1'b1)};
    wire [1:0] bm_16_2_from_3 = {1'b0, (r_sys[16] ^ 1'b0)} + {1'b0, (r_par1[16] ^ 1'b0)};
    wire [8:0] cand_16_2_1 = pm_15_1 + {7'b0, bm_16_2_from_1};
    wire [8:0] cand_16_2_2 = pm_15_3 + {7'b0, bm_16_2_from_3};
    wire sel_16_2 = (cand_16_2_1 > cand_16_2_2); // 1 if cand2 better
    wire [8:0] pm_16_2 = sel_16_2 ? cand_16_2_2 : cand_16_2_1;
    wire surv_16_2 = sel_16_2;
    wire [1:0] bm_16_3_from_1 = {1'b0, (r_sys[16] ^ 1'b1)} + {1'b0, (r_par1[16] ^ 1'b0)};
    wire [1:0] bm_16_3_from_3 = {1'b0, (r_sys[16] ^ 1'b1)} + {1'b0, (r_par1[16] ^ 1'b1)};
    wire [8:0] cand_16_3_1 = pm_15_1 + {7'b0, bm_16_3_from_1};
    wire [8:0] cand_16_3_2 = pm_15_3 + {7'b0, bm_16_3_from_3};
    wire sel_16_3 = (cand_16_3_1 > cand_16_3_2); // 1 if cand2 better
    wire [8:0] pm_16_3 = sel_16_3 ? cand_16_3_2 : cand_16_3_1;
    wire surv_16_3 = sel_16_3;
    // Stage 17
    wire [1:0] bm_17_0_from_0 = {1'b0, (r_sys[17] ^ 1'b0)} + {1'b0, (r_par1[17] ^ 1'b0)};
    wire [1:0] bm_17_0_from_2 = {1'b0, (r_sys[17] ^ 1'b0)} + {1'b0, (r_par1[17] ^ 1'b1)};
    wire [8:0] cand_17_0_1 = pm_16_0 + {7'b0, bm_17_0_from_0};
    wire [8:0] cand_17_0_2 = pm_16_2 + {7'b0, bm_17_0_from_2};
    wire sel_17_0 = (cand_17_0_1 > cand_17_0_2); // 1 if cand2 better
    wire [8:0] pm_17_0 = sel_17_0 ? cand_17_0_2 : cand_17_0_1;
    wire surv_17_0 = sel_17_0;
    wire [1:0] bm_17_1_from_0 = {1'b0, (r_sys[17] ^ 1'b1)} + {1'b0, (r_par1[17] ^ 1'b1)};
    wire [1:0] bm_17_1_from_2 = {1'b0, (r_sys[17] ^ 1'b1)} + {1'b0, (r_par1[17] ^ 1'b0)};
    wire [8:0] cand_17_1_1 = pm_16_0 + {7'b0, bm_17_1_from_0};
    wire [8:0] cand_17_1_2 = pm_16_2 + {7'b0, bm_17_1_from_2};
    wire sel_17_1 = (cand_17_1_1 > cand_17_1_2); // 1 if cand2 better
    wire [8:0] pm_17_1 = sel_17_1 ? cand_17_1_2 : cand_17_1_1;
    wire surv_17_1 = sel_17_1;
    wire [1:0] bm_17_2_from_1 = {1'b0, (r_sys[17] ^ 1'b0)} + {1'b0, (r_par1[17] ^ 1'b1)};
    wire [1:0] bm_17_2_from_3 = {1'b0, (r_sys[17] ^ 1'b0)} + {1'b0, (r_par1[17] ^ 1'b0)};
    wire [8:0] cand_17_2_1 = pm_16_1 + {7'b0, bm_17_2_from_1};
    wire [8:0] cand_17_2_2 = pm_16_3 + {7'b0, bm_17_2_from_3};
    wire sel_17_2 = (cand_17_2_1 > cand_17_2_2); // 1 if cand2 better
    wire [8:0] pm_17_2 = sel_17_2 ? cand_17_2_2 : cand_17_2_1;
    wire surv_17_2 = sel_17_2;
    wire [1:0] bm_17_3_from_1 = {1'b0, (r_sys[17] ^ 1'b1)} + {1'b0, (r_par1[17] ^ 1'b0)};
    wire [1:0] bm_17_3_from_3 = {1'b0, (r_sys[17] ^ 1'b1)} + {1'b0, (r_par1[17] ^ 1'b1)};
    wire [8:0] cand_17_3_1 = pm_16_1 + {7'b0, bm_17_3_from_1};
    wire [8:0] cand_17_3_2 = pm_16_3 + {7'b0, bm_17_3_from_3};
    wire sel_17_3 = (cand_17_3_1 > cand_17_3_2); // 1 if cand2 better
    wire [8:0] pm_17_3 = sel_17_3 ? cand_17_3_2 : cand_17_3_1;
    wire surv_17_3 = sel_17_3;
    // Stage 18
    wire [1:0] bm_18_0_from_0 = {1'b0, (r_sys[18] ^ 1'b0)} + {1'b0, (r_par1[18] ^ 1'b0)};
    wire [1:0] bm_18_0_from_2 = {1'b0, (r_sys[18] ^ 1'b0)} + {1'b0, (r_par1[18] ^ 1'b1)};
    wire [8:0] cand_18_0_1 = pm_17_0 + {7'b0, bm_18_0_from_0};
    wire [8:0] cand_18_0_2 = pm_17_2 + {7'b0, bm_18_0_from_2};
    wire sel_18_0 = (cand_18_0_1 > cand_18_0_2); // 1 if cand2 better
    wire [8:0] pm_18_0 = sel_18_0 ? cand_18_0_2 : cand_18_0_1;
    wire surv_18_0 = sel_18_0;
    wire [1:0] bm_18_1_from_0 = {1'b0, (r_sys[18] ^ 1'b1)} + {1'b0, (r_par1[18] ^ 1'b1)};
    wire [1:0] bm_18_1_from_2 = {1'b0, (r_sys[18] ^ 1'b1)} + {1'b0, (r_par1[18] ^ 1'b0)};
    wire [8:0] cand_18_1_1 = pm_17_0 + {7'b0, bm_18_1_from_0};
    wire [8:0] cand_18_1_2 = pm_17_2 + {7'b0, bm_18_1_from_2};
    wire sel_18_1 = (cand_18_1_1 > cand_18_1_2); // 1 if cand2 better
    wire [8:0] pm_18_1 = sel_18_1 ? cand_18_1_2 : cand_18_1_1;
    wire surv_18_1 = sel_18_1;
    wire [1:0] bm_18_2_from_1 = {1'b0, (r_sys[18] ^ 1'b0)} + {1'b0, (r_par1[18] ^ 1'b1)};
    wire [1:0] bm_18_2_from_3 = {1'b0, (r_sys[18] ^ 1'b0)} + {1'b0, (r_par1[18] ^ 1'b0)};
    wire [8:0] cand_18_2_1 = pm_17_1 + {7'b0, bm_18_2_from_1};
    wire [8:0] cand_18_2_2 = pm_17_3 + {7'b0, bm_18_2_from_3};
    wire sel_18_2 = (cand_18_2_1 > cand_18_2_2); // 1 if cand2 better
    wire [8:0] pm_18_2 = sel_18_2 ? cand_18_2_2 : cand_18_2_1;
    wire surv_18_2 = sel_18_2;
    wire [1:0] bm_18_3_from_1 = {1'b0, (r_sys[18] ^ 1'b1)} + {1'b0, (r_par1[18] ^ 1'b0)};
    wire [1:0] bm_18_3_from_3 = {1'b0, (r_sys[18] ^ 1'b1)} + {1'b0, (r_par1[18] ^ 1'b1)};
    wire [8:0] cand_18_3_1 = pm_17_1 + {7'b0, bm_18_3_from_1};
    wire [8:0] cand_18_3_2 = pm_17_3 + {7'b0, bm_18_3_from_3};
    wire sel_18_3 = (cand_18_3_1 > cand_18_3_2); // 1 if cand2 better
    wire [8:0] pm_18_3 = sel_18_3 ? cand_18_3_2 : cand_18_3_1;
    wire surv_18_3 = sel_18_3;
    // Stage 19
    wire [1:0] bm_19_0_from_0 = {1'b0, (r_sys[19] ^ 1'b0)} + {1'b0, (r_par1[19] ^ 1'b0)};
    wire [1:0] bm_19_0_from_2 = {1'b0, (r_sys[19] ^ 1'b0)} + {1'b0, (r_par1[19] ^ 1'b1)};
    wire [8:0] cand_19_0_1 = pm_18_0 + {7'b0, bm_19_0_from_0};
    wire [8:0] cand_19_0_2 = pm_18_2 + {7'b0, bm_19_0_from_2};
    wire sel_19_0 = (cand_19_0_1 > cand_19_0_2); // 1 if cand2 better
    wire [8:0] pm_19_0 = sel_19_0 ? cand_19_0_2 : cand_19_0_1;
    wire surv_19_0 = sel_19_0;
    wire [1:0] bm_19_1_from_0 = {1'b0, (r_sys[19] ^ 1'b1)} + {1'b0, (r_par1[19] ^ 1'b1)};
    wire [1:0] bm_19_1_from_2 = {1'b0, (r_sys[19] ^ 1'b1)} + {1'b0, (r_par1[19] ^ 1'b0)};
    wire [8:0] cand_19_1_1 = pm_18_0 + {7'b0, bm_19_1_from_0};
    wire [8:0] cand_19_1_2 = pm_18_2 + {7'b0, bm_19_1_from_2};
    wire sel_19_1 = (cand_19_1_1 > cand_19_1_2); // 1 if cand2 better
    wire [8:0] pm_19_1 = sel_19_1 ? cand_19_1_2 : cand_19_1_1;
    wire surv_19_1 = sel_19_1;
    wire [1:0] bm_19_2_from_1 = {1'b0, (r_sys[19] ^ 1'b0)} + {1'b0, (r_par1[19] ^ 1'b1)};
    wire [1:0] bm_19_2_from_3 = {1'b0, (r_sys[19] ^ 1'b0)} + {1'b0, (r_par1[19] ^ 1'b0)};
    wire [8:0] cand_19_2_1 = pm_18_1 + {7'b0, bm_19_2_from_1};
    wire [8:0] cand_19_2_2 = pm_18_3 + {7'b0, bm_19_2_from_3};
    wire sel_19_2 = (cand_19_2_1 > cand_19_2_2); // 1 if cand2 better
    wire [8:0] pm_19_2 = sel_19_2 ? cand_19_2_2 : cand_19_2_1;
    wire surv_19_2 = sel_19_2;
    wire [1:0] bm_19_3_from_1 = {1'b0, (r_sys[19] ^ 1'b1)} + {1'b0, (r_par1[19] ^ 1'b0)};
    wire [1:0] bm_19_3_from_3 = {1'b0, (r_sys[19] ^ 1'b1)} + {1'b0, (r_par1[19] ^ 1'b1)};
    wire [8:0] cand_19_3_1 = pm_18_1 + {7'b0, bm_19_3_from_1};
    wire [8:0] cand_19_3_2 = pm_18_3 + {7'b0, bm_19_3_from_3};
    wire sel_19_3 = (cand_19_3_1 > cand_19_3_2); // 1 if cand2 better
    wire [8:0] pm_19_3 = sel_19_3 ? cand_19_3_2 : cand_19_3_1;
    wire surv_19_3 = sel_19_3;
    // Stage 20
    wire [1:0] bm_20_0_from_0 = {1'b0, (r_sys[20] ^ 1'b0)} + {1'b0, (r_par1[20] ^ 1'b0)};
    wire [1:0] bm_20_0_from_2 = {1'b0, (r_sys[20] ^ 1'b0)} + {1'b0, (r_par1[20] ^ 1'b1)};
    wire [8:0] cand_20_0_1 = pm_19_0 + {7'b0, bm_20_0_from_0};
    wire [8:0] cand_20_0_2 = pm_19_2 + {7'b0, bm_20_0_from_2};
    wire sel_20_0 = (cand_20_0_1 > cand_20_0_2); // 1 if cand2 better
    wire [8:0] pm_20_0 = sel_20_0 ? cand_20_0_2 : cand_20_0_1;
    wire surv_20_0 = sel_20_0;
    wire [1:0] bm_20_1_from_0 = {1'b0, (r_sys[20] ^ 1'b1)} + {1'b0, (r_par1[20] ^ 1'b1)};
    wire [1:0] bm_20_1_from_2 = {1'b0, (r_sys[20] ^ 1'b1)} + {1'b0, (r_par1[20] ^ 1'b0)};
    wire [8:0] cand_20_1_1 = pm_19_0 + {7'b0, bm_20_1_from_0};
    wire [8:0] cand_20_1_2 = pm_19_2 + {7'b0, bm_20_1_from_2};
    wire sel_20_1 = (cand_20_1_1 > cand_20_1_2); // 1 if cand2 better
    wire [8:0] pm_20_1 = sel_20_1 ? cand_20_1_2 : cand_20_1_1;
    wire surv_20_1 = sel_20_1;
    wire [1:0] bm_20_2_from_1 = {1'b0, (r_sys[20] ^ 1'b0)} + {1'b0, (r_par1[20] ^ 1'b1)};
    wire [1:0] bm_20_2_from_3 = {1'b0, (r_sys[20] ^ 1'b0)} + {1'b0, (r_par1[20] ^ 1'b0)};
    wire [8:0] cand_20_2_1 = pm_19_1 + {7'b0, bm_20_2_from_1};
    wire [8:0] cand_20_2_2 = pm_19_3 + {7'b0, bm_20_2_from_3};
    wire sel_20_2 = (cand_20_2_1 > cand_20_2_2); // 1 if cand2 better
    wire [8:0] pm_20_2 = sel_20_2 ? cand_20_2_2 : cand_20_2_1;
    wire surv_20_2 = sel_20_2;
    wire [1:0] bm_20_3_from_1 = {1'b0, (r_sys[20] ^ 1'b1)} + {1'b0, (r_par1[20] ^ 1'b0)};
    wire [1:0] bm_20_3_from_3 = {1'b0, (r_sys[20] ^ 1'b1)} + {1'b0, (r_par1[20] ^ 1'b1)};
    wire [8:0] cand_20_3_1 = pm_19_1 + {7'b0, bm_20_3_from_1};
    wire [8:0] cand_20_3_2 = pm_19_3 + {7'b0, bm_20_3_from_3};
    wire sel_20_3 = (cand_20_3_1 > cand_20_3_2); // 1 if cand2 better
    wire [8:0] pm_20_3 = sel_20_3 ? cand_20_3_2 : cand_20_3_1;
    wire surv_20_3 = sel_20_3;
    // Stage 21
    wire [1:0] bm_21_0_from_0 = {1'b0, (r_sys[21] ^ 1'b0)} + {1'b0, (r_par1[21] ^ 1'b0)};
    wire [1:0] bm_21_0_from_2 = {1'b0, (r_sys[21] ^ 1'b0)} + {1'b0, (r_par1[21] ^ 1'b1)};
    wire [8:0] cand_21_0_1 = pm_20_0 + {7'b0, bm_21_0_from_0};
    wire [8:0] cand_21_0_2 = pm_20_2 + {7'b0, bm_21_0_from_2};
    wire sel_21_0 = (cand_21_0_1 > cand_21_0_2); // 1 if cand2 better
    wire [8:0] pm_21_0 = sel_21_0 ? cand_21_0_2 : cand_21_0_1;
    wire surv_21_0 = sel_21_0;
    wire [1:0] bm_21_1_from_0 = {1'b0, (r_sys[21] ^ 1'b1)} + {1'b0, (r_par1[21] ^ 1'b1)};
    wire [1:0] bm_21_1_from_2 = {1'b0, (r_sys[21] ^ 1'b1)} + {1'b0, (r_par1[21] ^ 1'b0)};
    wire [8:0] cand_21_1_1 = pm_20_0 + {7'b0, bm_21_1_from_0};
    wire [8:0] cand_21_1_2 = pm_20_2 + {7'b0, bm_21_1_from_2};
    wire sel_21_1 = (cand_21_1_1 > cand_21_1_2); // 1 if cand2 better
    wire [8:0] pm_21_1 = sel_21_1 ? cand_21_1_2 : cand_21_1_1;
    wire surv_21_1 = sel_21_1;
    wire [1:0] bm_21_2_from_1 = {1'b0, (r_sys[21] ^ 1'b0)} + {1'b0, (r_par1[21] ^ 1'b1)};
    wire [1:0] bm_21_2_from_3 = {1'b0, (r_sys[21] ^ 1'b0)} + {1'b0, (r_par1[21] ^ 1'b0)};
    wire [8:0] cand_21_2_1 = pm_20_1 + {7'b0, bm_21_2_from_1};
    wire [8:0] cand_21_2_2 = pm_20_3 + {7'b0, bm_21_2_from_3};
    wire sel_21_2 = (cand_21_2_1 > cand_21_2_2); // 1 if cand2 better
    wire [8:0] pm_21_2 = sel_21_2 ? cand_21_2_2 : cand_21_2_1;
    wire surv_21_2 = sel_21_2;
    wire [1:0] bm_21_3_from_1 = {1'b0, (r_sys[21] ^ 1'b1)} + {1'b0, (r_par1[21] ^ 1'b0)};
    wire [1:0] bm_21_3_from_3 = {1'b0, (r_sys[21] ^ 1'b1)} + {1'b0, (r_par1[21] ^ 1'b1)};
    wire [8:0] cand_21_3_1 = pm_20_1 + {7'b0, bm_21_3_from_1};
    wire [8:0] cand_21_3_2 = pm_20_3 + {7'b0, bm_21_3_from_3};
    wire sel_21_3 = (cand_21_3_1 > cand_21_3_2); // 1 if cand2 better
    wire [8:0] pm_21_3 = sel_21_3 ? cand_21_3_2 : cand_21_3_1;
    wire surv_21_3 = sel_21_3;
    // Stage 22
    wire [1:0] bm_22_0_from_0 = {1'b0, (r_sys[22] ^ 1'b0)} + {1'b0, (r_par1[22] ^ 1'b0)};
    wire [1:0] bm_22_0_from_2 = {1'b0, (r_sys[22] ^ 1'b0)} + {1'b0, (r_par1[22] ^ 1'b1)};
    wire [8:0] cand_22_0_1 = pm_21_0 + {7'b0, bm_22_0_from_0};
    wire [8:0] cand_22_0_2 = pm_21_2 + {7'b0, bm_22_0_from_2};
    wire sel_22_0 = (cand_22_0_1 > cand_22_0_2); // 1 if cand2 better
    wire [8:0] pm_22_0 = sel_22_0 ? cand_22_0_2 : cand_22_0_1;
    wire surv_22_0 = sel_22_0;
    wire [1:0] bm_22_1_from_0 = {1'b0, (r_sys[22] ^ 1'b1)} + {1'b0, (r_par1[22] ^ 1'b1)};
    wire [1:0] bm_22_1_from_2 = {1'b0, (r_sys[22] ^ 1'b1)} + {1'b0, (r_par1[22] ^ 1'b0)};
    wire [8:0] cand_22_1_1 = pm_21_0 + {7'b0, bm_22_1_from_0};
    wire [8:0] cand_22_1_2 = pm_21_2 + {7'b0, bm_22_1_from_2};
    wire sel_22_1 = (cand_22_1_1 > cand_22_1_2); // 1 if cand2 better
    wire [8:0] pm_22_1 = sel_22_1 ? cand_22_1_2 : cand_22_1_1;
    wire surv_22_1 = sel_22_1;
    wire [1:0] bm_22_2_from_1 = {1'b0, (r_sys[22] ^ 1'b0)} + {1'b0, (r_par1[22] ^ 1'b1)};
    wire [1:0] bm_22_2_from_3 = {1'b0, (r_sys[22] ^ 1'b0)} + {1'b0, (r_par1[22] ^ 1'b0)};
    wire [8:0] cand_22_2_1 = pm_21_1 + {7'b0, bm_22_2_from_1};
    wire [8:0] cand_22_2_2 = pm_21_3 + {7'b0, bm_22_2_from_3};
    wire sel_22_2 = (cand_22_2_1 > cand_22_2_2); // 1 if cand2 better
    wire [8:0] pm_22_2 = sel_22_2 ? cand_22_2_2 : cand_22_2_1;
    wire surv_22_2 = sel_22_2;
    wire [1:0] bm_22_3_from_1 = {1'b0, (r_sys[22] ^ 1'b1)} + {1'b0, (r_par1[22] ^ 1'b0)};
    wire [1:0] bm_22_3_from_3 = {1'b0, (r_sys[22] ^ 1'b1)} + {1'b0, (r_par1[22] ^ 1'b1)};
    wire [8:0] cand_22_3_1 = pm_21_1 + {7'b0, bm_22_3_from_1};
    wire [8:0] cand_22_3_2 = pm_21_3 + {7'b0, bm_22_3_from_3};
    wire sel_22_3 = (cand_22_3_1 > cand_22_3_2); // 1 if cand2 better
    wire [8:0] pm_22_3 = sel_22_3 ? cand_22_3_2 : cand_22_3_1;
    wire surv_22_3 = sel_22_3;
    // Stage 23
    wire [1:0] bm_23_0_from_0 = {1'b0, (r_sys[23] ^ 1'b0)} + {1'b0, (r_par1[23] ^ 1'b0)};
    wire [1:0] bm_23_0_from_2 = {1'b0, (r_sys[23] ^ 1'b0)} + {1'b0, (r_par1[23] ^ 1'b1)};
    wire [8:0] cand_23_0_1 = pm_22_0 + {7'b0, bm_23_0_from_0};
    wire [8:0] cand_23_0_2 = pm_22_2 + {7'b0, bm_23_0_from_2};
    wire sel_23_0 = (cand_23_0_1 > cand_23_0_2); // 1 if cand2 better
    wire [8:0] pm_23_0 = sel_23_0 ? cand_23_0_2 : cand_23_0_1;
    wire surv_23_0 = sel_23_0;
    wire [1:0] bm_23_1_from_0 = {1'b0, (r_sys[23] ^ 1'b1)} + {1'b0, (r_par1[23] ^ 1'b1)};
    wire [1:0] bm_23_1_from_2 = {1'b0, (r_sys[23] ^ 1'b1)} + {1'b0, (r_par1[23] ^ 1'b0)};
    wire [8:0] cand_23_1_1 = pm_22_0 + {7'b0, bm_23_1_from_0};
    wire [8:0] cand_23_1_2 = pm_22_2 + {7'b0, bm_23_1_from_2};
    wire sel_23_1 = (cand_23_1_1 > cand_23_1_2); // 1 if cand2 better
    wire [8:0] pm_23_1 = sel_23_1 ? cand_23_1_2 : cand_23_1_1;
    wire surv_23_1 = sel_23_1;
    wire [1:0] bm_23_2_from_1 = {1'b0, (r_sys[23] ^ 1'b0)} + {1'b0, (r_par1[23] ^ 1'b1)};
    wire [1:0] bm_23_2_from_3 = {1'b0, (r_sys[23] ^ 1'b0)} + {1'b0, (r_par1[23] ^ 1'b0)};
    wire [8:0] cand_23_2_1 = pm_22_1 + {7'b0, bm_23_2_from_1};
    wire [8:0] cand_23_2_2 = pm_22_3 + {7'b0, bm_23_2_from_3};
    wire sel_23_2 = (cand_23_2_1 > cand_23_2_2); // 1 if cand2 better
    wire [8:0] pm_23_2 = sel_23_2 ? cand_23_2_2 : cand_23_2_1;
    wire surv_23_2 = sel_23_2;
    wire [1:0] bm_23_3_from_1 = {1'b0, (r_sys[23] ^ 1'b1)} + {1'b0, (r_par1[23] ^ 1'b0)};
    wire [1:0] bm_23_3_from_3 = {1'b0, (r_sys[23] ^ 1'b1)} + {1'b0, (r_par1[23] ^ 1'b1)};
    wire [8:0] cand_23_3_1 = pm_22_1 + {7'b0, bm_23_3_from_1};
    wire [8:0] cand_23_3_2 = pm_22_3 + {7'b0, bm_23_3_from_3};
    wire sel_23_3 = (cand_23_3_1 > cand_23_3_2); // 1 if cand2 better
    wire [8:0] pm_23_3 = sel_23_3 ? cand_23_3_2 : cand_23_3_1;
    wire surv_23_3 = sel_23_3;
    // Stage 24
    wire [1:0] bm_24_0_from_0 = {1'b0, (r_sys[24] ^ 1'b0)} + {1'b0, (r_par1[24] ^ 1'b0)};
    wire [1:0] bm_24_0_from_2 = {1'b0, (r_sys[24] ^ 1'b0)} + {1'b0, (r_par1[24] ^ 1'b1)};
    wire [8:0] cand_24_0_1 = pm_23_0 + {7'b0, bm_24_0_from_0};
    wire [8:0] cand_24_0_2 = pm_23_2 + {7'b0, bm_24_0_from_2};
    wire sel_24_0 = (cand_24_0_1 > cand_24_0_2); // 1 if cand2 better
    wire [8:0] pm_24_0 = sel_24_0 ? cand_24_0_2 : cand_24_0_1;
    wire surv_24_0 = sel_24_0;
    wire [1:0] bm_24_1_from_0 = {1'b0, (r_sys[24] ^ 1'b1)} + {1'b0, (r_par1[24] ^ 1'b1)};
    wire [1:0] bm_24_1_from_2 = {1'b0, (r_sys[24] ^ 1'b1)} + {1'b0, (r_par1[24] ^ 1'b0)};
    wire [8:0] cand_24_1_1 = pm_23_0 + {7'b0, bm_24_1_from_0};
    wire [8:0] cand_24_1_2 = pm_23_2 + {7'b0, bm_24_1_from_2};
    wire sel_24_1 = (cand_24_1_1 > cand_24_1_2); // 1 if cand2 better
    wire [8:0] pm_24_1 = sel_24_1 ? cand_24_1_2 : cand_24_1_1;
    wire surv_24_1 = sel_24_1;
    wire [1:0] bm_24_2_from_1 = {1'b0, (r_sys[24] ^ 1'b0)} + {1'b0, (r_par1[24] ^ 1'b1)};
    wire [1:0] bm_24_2_from_3 = {1'b0, (r_sys[24] ^ 1'b0)} + {1'b0, (r_par1[24] ^ 1'b0)};
    wire [8:0] cand_24_2_1 = pm_23_1 + {7'b0, bm_24_2_from_1};
    wire [8:0] cand_24_2_2 = pm_23_3 + {7'b0, bm_24_2_from_3};
    wire sel_24_2 = (cand_24_2_1 > cand_24_2_2); // 1 if cand2 better
    wire [8:0] pm_24_2 = sel_24_2 ? cand_24_2_2 : cand_24_2_1;
    wire surv_24_2 = sel_24_2;
    wire [1:0] bm_24_3_from_1 = {1'b0, (r_sys[24] ^ 1'b1)} + {1'b0, (r_par1[24] ^ 1'b0)};
    wire [1:0] bm_24_3_from_3 = {1'b0, (r_sys[24] ^ 1'b1)} + {1'b0, (r_par1[24] ^ 1'b1)};
    wire [8:0] cand_24_3_1 = pm_23_1 + {7'b0, bm_24_3_from_1};
    wire [8:0] cand_24_3_2 = pm_23_3 + {7'b0, bm_24_3_from_3};
    wire sel_24_3 = (cand_24_3_1 > cand_24_3_2); // 1 if cand2 better
    wire [8:0] pm_24_3 = sel_24_3 ? cand_24_3_2 : cand_24_3_1;
    wire surv_24_3 = sel_24_3;
    // Stage 25
    wire [1:0] bm_25_0_from_0 = {1'b0, (r_sys[25] ^ 1'b0)} + {1'b0, (r_par1[25] ^ 1'b0)};
    wire [1:0] bm_25_0_from_2 = {1'b0, (r_sys[25] ^ 1'b0)} + {1'b0, (r_par1[25] ^ 1'b1)};
    wire [8:0] cand_25_0_1 = pm_24_0 + {7'b0, bm_25_0_from_0};
    wire [8:0] cand_25_0_2 = pm_24_2 + {7'b0, bm_25_0_from_2};
    wire sel_25_0 = (cand_25_0_1 > cand_25_0_2); // 1 if cand2 better
    wire [8:0] pm_25_0 = sel_25_0 ? cand_25_0_2 : cand_25_0_1;
    wire surv_25_0 = sel_25_0;
    wire [1:0] bm_25_1_from_0 = {1'b0, (r_sys[25] ^ 1'b1)} + {1'b0, (r_par1[25] ^ 1'b1)};
    wire [1:0] bm_25_1_from_2 = {1'b0, (r_sys[25] ^ 1'b1)} + {1'b0, (r_par1[25] ^ 1'b0)};
    wire [8:0] cand_25_1_1 = pm_24_0 + {7'b0, bm_25_1_from_0};
    wire [8:0] cand_25_1_2 = pm_24_2 + {7'b0, bm_25_1_from_2};
    wire sel_25_1 = (cand_25_1_1 > cand_25_1_2); // 1 if cand2 better
    wire [8:0] pm_25_1 = sel_25_1 ? cand_25_1_2 : cand_25_1_1;
    wire surv_25_1 = sel_25_1;
    wire [1:0] bm_25_2_from_1 = {1'b0, (r_sys[25] ^ 1'b0)} + {1'b0, (r_par1[25] ^ 1'b1)};
    wire [1:0] bm_25_2_from_3 = {1'b0, (r_sys[25] ^ 1'b0)} + {1'b0, (r_par1[25] ^ 1'b0)};
    wire [8:0] cand_25_2_1 = pm_24_1 + {7'b0, bm_25_2_from_1};
    wire [8:0] cand_25_2_2 = pm_24_3 + {7'b0, bm_25_2_from_3};
    wire sel_25_2 = (cand_25_2_1 > cand_25_2_2); // 1 if cand2 better
    wire [8:0] pm_25_2 = sel_25_2 ? cand_25_2_2 : cand_25_2_1;
    wire surv_25_2 = sel_25_2;
    wire [1:0] bm_25_3_from_1 = {1'b0, (r_sys[25] ^ 1'b1)} + {1'b0, (r_par1[25] ^ 1'b0)};
    wire [1:0] bm_25_3_from_3 = {1'b0, (r_sys[25] ^ 1'b1)} + {1'b0, (r_par1[25] ^ 1'b1)};
    wire [8:0] cand_25_3_1 = pm_24_1 + {7'b0, bm_25_3_from_1};
    wire [8:0] cand_25_3_2 = pm_24_3 + {7'b0, bm_25_3_from_3};
    wire sel_25_3 = (cand_25_3_1 > cand_25_3_2); // 1 if cand2 better
    wire [8:0] pm_25_3 = sel_25_3 ? cand_25_3_2 : cand_25_3_1;
    wire surv_25_3 = sel_25_3;
    // Stage 26
    wire [1:0] bm_26_0_from_0 = {1'b0, (r_sys[26] ^ 1'b0)} + {1'b0, (r_par1[26] ^ 1'b0)};
    wire [1:0] bm_26_0_from_2 = {1'b0, (r_sys[26] ^ 1'b0)} + {1'b0, (r_par1[26] ^ 1'b1)};
    wire [8:0] cand_26_0_1 = pm_25_0 + {7'b0, bm_26_0_from_0};
    wire [8:0] cand_26_0_2 = pm_25_2 + {7'b0, bm_26_0_from_2};
    wire sel_26_0 = (cand_26_0_1 > cand_26_0_2); // 1 if cand2 better
    wire [8:0] pm_26_0 = sel_26_0 ? cand_26_0_2 : cand_26_0_1;
    wire surv_26_0 = sel_26_0;
    wire [1:0] bm_26_1_from_0 = {1'b0, (r_sys[26] ^ 1'b1)} + {1'b0, (r_par1[26] ^ 1'b1)};
    wire [1:0] bm_26_1_from_2 = {1'b0, (r_sys[26] ^ 1'b1)} + {1'b0, (r_par1[26] ^ 1'b0)};
    wire [8:0] cand_26_1_1 = pm_25_0 + {7'b0, bm_26_1_from_0};
    wire [8:0] cand_26_1_2 = pm_25_2 + {7'b0, bm_26_1_from_2};
    wire sel_26_1 = (cand_26_1_1 > cand_26_1_2); // 1 if cand2 better
    wire [8:0] pm_26_1 = sel_26_1 ? cand_26_1_2 : cand_26_1_1;
    wire surv_26_1 = sel_26_1;
    wire [1:0] bm_26_2_from_1 = {1'b0, (r_sys[26] ^ 1'b0)} + {1'b0, (r_par1[26] ^ 1'b1)};
    wire [1:0] bm_26_2_from_3 = {1'b0, (r_sys[26] ^ 1'b0)} + {1'b0, (r_par1[26] ^ 1'b0)};
    wire [8:0] cand_26_2_1 = pm_25_1 + {7'b0, bm_26_2_from_1};
    wire [8:0] cand_26_2_2 = pm_25_3 + {7'b0, bm_26_2_from_3};
    wire sel_26_2 = (cand_26_2_1 > cand_26_2_2); // 1 if cand2 better
    wire [8:0] pm_26_2 = sel_26_2 ? cand_26_2_2 : cand_26_2_1;
    wire surv_26_2 = sel_26_2;
    wire [1:0] bm_26_3_from_1 = {1'b0, (r_sys[26] ^ 1'b1)} + {1'b0, (r_par1[26] ^ 1'b0)};
    wire [1:0] bm_26_3_from_3 = {1'b0, (r_sys[26] ^ 1'b1)} + {1'b0, (r_par1[26] ^ 1'b1)};
    wire [8:0] cand_26_3_1 = pm_25_1 + {7'b0, bm_26_3_from_1};
    wire [8:0] cand_26_3_2 = pm_25_3 + {7'b0, bm_26_3_from_3};
    wire sel_26_3 = (cand_26_3_1 > cand_26_3_2); // 1 if cand2 better
    wire [8:0] pm_26_3 = sel_26_3 ? cand_26_3_2 : cand_26_3_1;
    wire surv_26_3 = sel_26_3;
    // Stage 27
    wire [1:0] bm_27_0_from_0 = {1'b0, (r_sys[27] ^ 1'b0)} + {1'b0, (r_par1[27] ^ 1'b0)};
    wire [1:0] bm_27_0_from_2 = {1'b0, (r_sys[27] ^ 1'b0)} + {1'b0, (r_par1[27] ^ 1'b1)};
    wire [8:0] cand_27_0_1 = pm_26_0 + {7'b0, bm_27_0_from_0};
    wire [8:0] cand_27_0_2 = pm_26_2 + {7'b0, bm_27_0_from_2};
    wire sel_27_0 = (cand_27_0_1 > cand_27_0_2); // 1 if cand2 better
    wire [8:0] pm_27_0 = sel_27_0 ? cand_27_0_2 : cand_27_0_1;
    wire surv_27_0 = sel_27_0;
    wire [1:0] bm_27_1_from_0 = {1'b0, (r_sys[27] ^ 1'b1)} + {1'b0, (r_par1[27] ^ 1'b1)};
    wire [1:0] bm_27_1_from_2 = {1'b0, (r_sys[27] ^ 1'b1)} + {1'b0, (r_par1[27] ^ 1'b0)};
    wire [8:0] cand_27_1_1 = pm_26_0 + {7'b0, bm_27_1_from_0};
    wire [8:0] cand_27_1_2 = pm_26_2 + {7'b0, bm_27_1_from_2};
    wire sel_27_1 = (cand_27_1_1 > cand_27_1_2); // 1 if cand2 better
    wire [8:0] pm_27_1 = sel_27_1 ? cand_27_1_2 : cand_27_1_1;
    wire surv_27_1 = sel_27_1;
    wire [1:0] bm_27_2_from_1 = {1'b0, (r_sys[27] ^ 1'b0)} + {1'b0, (r_par1[27] ^ 1'b1)};
    wire [1:0] bm_27_2_from_3 = {1'b0, (r_sys[27] ^ 1'b0)} + {1'b0, (r_par1[27] ^ 1'b0)};
    wire [8:0] cand_27_2_1 = pm_26_1 + {7'b0, bm_27_2_from_1};
    wire [8:0] cand_27_2_2 = pm_26_3 + {7'b0, bm_27_2_from_3};
    wire sel_27_2 = (cand_27_2_1 > cand_27_2_2); // 1 if cand2 better
    wire [8:0] pm_27_2 = sel_27_2 ? cand_27_2_2 : cand_27_2_1;
    wire surv_27_2 = sel_27_2;
    wire [1:0] bm_27_3_from_1 = {1'b0, (r_sys[27] ^ 1'b1)} + {1'b0, (r_par1[27] ^ 1'b0)};
    wire [1:0] bm_27_3_from_3 = {1'b0, (r_sys[27] ^ 1'b1)} + {1'b0, (r_par1[27] ^ 1'b1)};
    wire [8:0] cand_27_3_1 = pm_26_1 + {7'b0, bm_27_3_from_1};
    wire [8:0] cand_27_3_2 = pm_26_3 + {7'b0, bm_27_3_from_3};
    wire sel_27_3 = (cand_27_3_1 > cand_27_3_2); // 1 if cand2 better
    wire [8:0] pm_27_3 = sel_27_3 ? cand_27_3_2 : cand_27_3_1;
    wire surv_27_3 = sel_27_3;
    // Stage 28
    wire [1:0] bm_28_0_from_0 = {1'b0, (r_sys[28] ^ 1'b0)} + {1'b0, (r_par1[28] ^ 1'b0)};
    wire [1:0] bm_28_0_from_2 = {1'b0, (r_sys[28] ^ 1'b0)} + {1'b0, (r_par1[28] ^ 1'b1)};
    wire [8:0] cand_28_0_1 = pm_27_0 + {7'b0, bm_28_0_from_0};
    wire [8:0] cand_28_0_2 = pm_27_2 + {7'b0, bm_28_0_from_2};
    wire sel_28_0 = (cand_28_0_1 > cand_28_0_2); // 1 if cand2 better
    wire [8:0] pm_28_0 = sel_28_0 ? cand_28_0_2 : cand_28_0_1;
    wire surv_28_0 = sel_28_0;
    wire [1:0] bm_28_1_from_0 = {1'b0, (r_sys[28] ^ 1'b1)} + {1'b0, (r_par1[28] ^ 1'b1)};
    wire [1:0] bm_28_1_from_2 = {1'b0, (r_sys[28] ^ 1'b1)} + {1'b0, (r_par1[28] ^ 1'b0)};
    wire [8:0] cand_28_1_1 = pm_27_0 + {7'b0, bm_28_1_from_0};
    wire [8:0] cand_28_1_2 = pm_27_2 + {7'b0, bm_28_1_from_2};
    wire sel_28_1 = (cand_28_1_1 > cand_28_1_2); // 1 if cand2 better
    wire [8:0] pm_28_1 = sel_28_1 ? cand_28_1_2 : cand_28_1_1;
    wire surv_28_1 = sel_28_1;
    wire [1:0] bm_28_2_from_1 = {1'b0, (r_sys[28] ^ 1'b0)} + {1'b0, (r_par1[28] ^ 1'b1)};
    wire [1:0] bm_28_2_from_3 = {1'b0, (r_sys[28] ^ 1'b0)} + {1'b0, (r_par1[28] ^ 1'b0)};
    wire [8:0] cand_28_2_1 = pm_27_1 + {7'b0, bm_28_2_from_1};
    wire [8:0] cand_28_2_2 = pm_27_3 + {7'b0, bm_28_2_from_3};
    wire sel_28_2 = (cand_28_2_1 > cand_28_2_2); // 1 if cand2 better
    wire [8:0] pm_28_2 = sel_28_2 ? cand_28_2_2 : cand_28_2_1;
    wire surv_28_2 = sel_28_2;
    wire [1:0] bm_28_3_from_1 = {1'b0, (r_sys[28] ^ 1'b1)} + {1'b0, (r_par1[28] ^ 1'b0)};
    wire [1:0] bm_28_3_from_3 = {1'b0, (r_sys[28] ^ 1'b1)} + {1'b0, (r_par1[28] ^ 1'b1)};
    wire [8:0] cand_28_3_1 = pm_27_1 + {7'b0, bm_28_3_from_1};
    wire [8:0] cand_28_3_2 = pm_27_3 + {7'b0, bm_28_3_from_3};
    wire sel_28_3 = (cand_28_3_1 > cand_28_3_2); // 1 if cand2 better
    wire [8:0] pm_28_3 = sel_28_3 ? cand_28_3_2 : cand_28_3_1;
    wire surv_28_3 = sel_28_3;
    // Stage 29
    wire [1:0] bm_29_0_from_0 = {1'b0, (r_sys[29] ^ 1'b0)} + {1'b0, (r_par1[29] ^ 1'b0)};
    wire [1:0] bm_29_0_from_2 = {1'b0, (r_sys[29] ^ 1'b0)} + {1'b0, (r_par1[29] ^ 1'b1)};
    wire [8:0] cand_29_0_1 = pm_28_0 + {7'b0, bm_29_0_from_0};
    wire [8:0] cand_29_0_2 = pm_28_2 + {7'b0, bm_29_0_from_2};
    wire sel_29_0 = (cand_29_0_1 > cand_29_0_2); // 1 if cand2 better
    wire [8:0] pm_29_0 = sel_29_0 ? cand_29_0_2 : cand_29_0_1;
    wire surv_29_0 = sel_29_0;
    wire [1:0] bm_29_1_from_0 = {1'b0, (r_sys[29] ^ 1'b1)} + {1'b0, (r_par1[29] ^ 1'b1)};
    wire [1:0] bm_29_1_from_2 = {1'b0, (r_sys[29] ^ 1'b1)} + {1'b0, (r_par1[29] ^ 1'b0)};
    wire [8:0] cand_29_1_1 = pm_28_0 + {7'b0, bm_29_1_from_0};
    wire [8:0] cand_29_1_2 = pm_28_2 + {7'b0, bm_29_1_from_2};
    wire sel_29_1 = (cand_29_1_1 > cand_29_1_2); // 1 if cand2 better
    wire [8:0] pm_29_1 = sel_29_1 ? cand_29_1_2 : cand_29_1_1;
    wire surv_29_1 = sel_29_1;
    wire [1:0] bm_29_2_from_1 = {1'b0, (r_sys[29] ^ 1'b0)} + {1'b0, (r_par1[29] ^ 1'b1)};
    wire [1:0] bm_29_2_from_3 = {1'b0, (r_sys[29] ^ 1'b0)} + {1'b0, (r_par1[29] ^ 1'b0)};
    wire [8:0] cand_29_2_1 = pm_28_1 + {7'b0, bm_29_2_from_1};
    wire [8:0] cand_29_2_2 = pm_28_3 + {7'b0, bm_29_2_from_3};
    wire sel_29_2 = (cand_29_2_1 > cand_29_2_2); // 1 if cand2 better
    wire [8:0] pm_29_2 = sel_29_2 ? cand_29_2_2 : cand_29_2_1;
    wire surv_29_2 = sel_29_2;
    wire [1:0] bm_29_3_from_1 = {1'b0, (r_sys[29] ^ 1'b1)} + {1'b0, (r_par1[29] ^ 1'b0)};
    wire [1:0] bm_29_3_from_3 = {1'b0, (r_sys[29] ^ 1'b1)} + {1'b0, (r_par1[29] ^ 1'b1)};
    wire [8:0] cand_29_3_1 = pm_28_1 + {7'b0, bm_29_3_from_1};
    wire [8:0] cand_29_3_2 = pm_28_3 + {7'b0, bm_29_3_from_3};
    wire sel_29_3 = (cand_29_3_1 > cand_29_3_2); // 1 if cand2 better
    wire [8:0] pm_29_3 = sel_29_3 ? cand_29_3_2 : cand_29_3_1;
    wire surv_29_3 = sel_29_3;
    // Stage 30
    wire [1:0] bm_30_0_from_0 = {1'b0, (r_sys[30] ^ 1'b0)} + {1'b0, (r_par1[30] ^ 1'b0)};
    wire [1:0] bm_30_0_from_2 = {1'b0, (r_sys[30] ^ 1'b0)} + {1'b0, (r_par1[30] ^ 1'b1)};
    wire [8:0] cand_30_0_1 = pm_29_0 + {7'b0, bm_30_0_from_0};
    wire [8:0] cand_30_0_2 = pm_29_2 + {7'b0, bm_30_0_from_2};
    wire sel_30_0 = (cand_30_0_1 > cand_30_0_2); // 1 if cand2 better
    wire [8:0] pm_30_0 = sel_30_0 ? cand_30_0_2 : cand_30_0_1;
    wire surv_30_0 = sel_30_0;
    wire [1:0] bm_30_1_from_0 = {1'b0, (r_sys[30] ^ 1'b1)} + {1'b0, (r_par1[30] ^ 1'b1)};
    wire [1:0] bm_30_1_from_2 = {1'b0, (r_sys[30] ^ 1'b1)} + {1'b0, (r_par1[30] ^ 1'b0)};
    wire [8:0] cand_30_1_1 = pm_29_0 + {7'b0, bm_30_1_from_0};
    wire [8:0] cand_30_1_2 = pm_29_2 + {7'b0, bm_30_1_from_2};
    wire sel_30_1 = (cand_30_1_1 > cand_30_1_2); // 1 if cand2 better
    wire [8:0] pm_30_1 = sel_30_1 ? cand_30_1_2 : cand_30_1_1;
    wire surv_30_1 = sel_30_1;
    wire [1:0] bm_30_2_from_1 = {1'b0, (r_sys[30] ^ 1'b0)} + {1'b0, (r_par1[30] ^ 1'b1)};
    wire [1:0] bm_30_2_from_3 = {1'b0, (r_sys[30] ^ 1'b0)} + {1'b0, (r_par1[30] ^ 1'b0)};
    wire [8:0] cand_30_2_1 = pm_29_1 + {7'b0, bm_30_2_from_1};
    wire [8:0] cand_30_2_2 = pm_29_3 + {7'b0, bm_30_2_from_3};
    wire sel_30_2 = (cand_30_2_1 > cand_30_2_2); // 1 if cand2 better
    wire [8:0] pm_30_2 = sel_30_2 ? cand_30_2_2 : cand_30_2_1;
    wire surv_30_2 = sel_30_2;
    wire [1:0] bm_30_3_from_1 = {1'b0, (r_sys[30] ^ 1'b1)} + {1'b0, (r_par1[30] ^ 1'b0)};
    wire [1:0] bm_30_3_from_3 = {1'b0, (r_sys[30] ^ 1'b1)} + {1'b0, (r_par1[30] ^ 1'b1)};
    wire [8:0] cand_30_3_1 = pm_29_1 + {7'b0, bm_30_3_from_1};
    wire [8:0] cand_30_3_2 = pm_29_3 + {7'b0, bm_30_3_from_3};
    wire sel_30_3 = (cand_30_3_1 > cand_30_3_2); // 1 if cand2 better
    wire [8:0] pm_30_3 = sel_30_3 ? cand_30_3_2 : cand_30_3_1;
    wire surv_30_3 = sel_30_3;
    // Stage 31
    wire [1:0] bm_31_0_from_0 = {1'b0, (r_sys[31] ^ 1'b0)} + {1'b0, (r_par1[31] ^ 1'b0)};
    wire [1:0] bm_31_0_from_2 = {1'b0, (r_sys[31] ^ 1'b0)} + {1'b0, (r_par1[31] ^ 1'b1)};
    wire [8:0] cand_31_0_1 = pm_30_0 + {7'b0, bm_31_0_from_0};
    wire [8:0] cand_31_0_2 = pm_30_2 + {7'b0, bm_31_0_from_2};
    wire sel_31_0 = (cand_31_0_1 > cand_31_0_2); // 1 if cand2 better
    wire [8:0] pm_31_0 = sel_31_0 ? cand_31_0_2 : cand_31_0_1;
    wire surv_31_0 = sel_31_0;
    wire [1:0] bm_31_1_from_0 = {1'b0, (r_sys[31] ^ 1'b1)} + {1'b0, (r_par1[31] ^ 1'b1)};
    wire [1:0] bm_31_1_from_2 = {1'b0, (r_sys[31] ^ 1'b1)} + {1'b0, (r_par1[31] ^ 1'b0)};
    wire [8:0] cand_31_1_1 = pm_30_0 + {7'b0, bm_31_1_from_0};
    wire [8:0] cand_31_1_2 = pm_30_2 + {7'b0, bm_31_1_from_2};
    wire sel_31_1 = (cand_31_1_1 > cand_31_1_2); // 1 if cand2 better
    wire [8:0] pm_31_1 = sel_31_1 ? cand_31_1_2 : cand_31_1_1;
    wire surv_31_1 = sel_31_1;
    wire [1:0] bm_31_2_from_1 = {1'b0, (r_sys[31] ^ 1'b0)} + {1'b0, (r_par1[31] ^ 1'b1)};
    wire [1:0] bm_31_2_from_3 = {1'b0, (r_sys[31] ^ 1'b0)} + {1'b0, (r_par1[31] ^ 1'b0)};
    wire [8:0] cand_31_2_1 = pm_30_1 + {7'b0, bm_31_2_from_1};
    wire [8:0] cand_31_2_2 = pm_30_3 + {7'b0, bm_31_2_from_3};
    wire sel_31_2 = (cand_31_2_1 > cand_31_2_2); // 1 if cand2 better
    wire [8:0] pm_31_2 = sel_31_2 ? cand_31_2_2 : cand_31_2_1;
    wire surv_31_2 = sel_31_2;
    wire [1:0] bm_31_3_from_1 = {1'b0, (r_sys[31] ^ 1'b1)} + {1'b0, (r_par1[31] ^ 1'b0)};
    wire [1:0] bm_31_3_from_3 = {1'b0, (r_sys[31] ^ 1'b1)} + {1'b0, (r_par1[31] ^ 1'b1)};
    wire [8:0] cand_31_3_1 = pm_30_1 + {7'b0, bm_31_3_from_1};
    wire [8:0] cand_31_3_2 = pm_30_3 + {7'b0, bm_31_3_from_3};
    wire sel_31_3 = (cand_31_3_1 > cand_31_3_2); // 1 if cand2 better
    wire [8:0] pm_31_3 = sel_31_3 ? cand_31_3_2 : cand_31_3_1;
    wire surv_31_3 = sel_31_3;
    // Stage 32
    wire [1:0] bm_32_0_from_0 = {1'b0, (r_sys[32] ^ 1'b0)} + {1'b0, (r_par1[32] ^ 1'b0)};
    wire [1:0] bm_32_0_from_2 = {1'b0, (r_sys[32] ^ 1'b0)} + {1'b0, (r_par1[32] ^ 1'b1)};
    wire [8:0] cand_32_0_1 = pm_31_0 + {7'b0, bm_32_0_from_0};
    wire [8:0] cand_32_0_2 = pm_31_2 + {7'b0, bm_32_0_from_2};
    wire sel_32_0 = (cand_32_0_1 > cand_32_0_2); // 1 if cand2 better
    wire [8:0] pm_32_0 = sel_32_0 ? cand_32_0_2 : cand_32_0_1;
    wire surv_32_0 = sel_32_0;
    wire [1:0] bm_32_1_from_0 = {1'b0, (r_sys[32] ^ 1'b1)} + {1'b0, (r_par1[32] ^ 1'b1)};
    wire [1:0] bm_32_1_from_2 = {1'b0, (r_sys[32] ^ 1'b1)} + {1'b0, (r_par1[32] ^ 1'b0)};
    wire [8:0] cand_32_1_1 = pm_31_0 + {7'b0, bm_32_1_from_0};
    wire [8:0] cand_32_1_2 = pm_31_2 + {7'b0, bm_32_1_from_2};
    wire sel_32_1 = (cand_32_1_1 > cand_32_1_2); // 1 if cand2 better
    wire [8:0] pm_32_1 = sel_32_1 ? cand_32_1_2 : cand_32_1_1;
    wire surv_32_1 = sel_32_1;
    wire [1:0] bm_32_2_from_1 = {1'b0, (r_sys[32] ^ 1'b0)} + {1'b0, (r_par1[32] ^ 1'b1)};
    wire [1:0] bm_32_2_from_3 = {1'b0, (r_sys[32] ^ 1'b0)} + {1'b0, (r_par1[32] ^ 1'b0)};
    wire [8:0] cand_32_2_1 = pm_31_1 + {7'b0, bm_32_2_from_1};
    wire [8:0] cand_32_2_2 = pm_31_3 + {7'b0, bm_32_2_from_3};
    wire sel_32_2 = (cand_32_2_1 > cand_32_2_2); // 1 if cand2 better
    wire [8:0] pm_32_2 = sel_32_2 ? cand_32_2_2 : cand_32_2_1;
    wire surv_32_2 = sel_32_2;
    wire [1:0] bm_32_3_from_1 = {1'b0, (r_sys[32] ^ 1'b1)} + {1'b0, (r_par1[32] ^ 1'b0)};
    wire [1:0] bm_32_3_from_3 = {1'b0, (r_sys[32] ^ 1'b1)} + {1'b0, (r_par1[32] ^ 1'b1)};
    wire [8:0] cand_32_3_1 = pm_31_1 + {7'b0, bm_32_3_from_1};
    wire [8:0] cand_32_3_2 = pm_31_3 + {7'b0, bm_32_3_from_3};
    wire sel_32_3 = (cand_32_3_1 > cand_32_3_2); // 1 if cand2 better
    wire [8:0] pm_32_3 = sel_32_3 ? cand_32_3_2 : cand_32_3_1;
    wire surv_32_3 = sel_32_3;
    // Stage 33
    wire [1:0] bm_33_0_from_0 = {1'b0, (r_sys[33] ^ 1'b0)} + {1'b0, (r_par1[33] ^ 1'b0)};
    wire [1:0] bm_33_0_from_2 = {1'b0, (r_sys[33] ^ 1'b0)} + {1'b0, (r_par1[33] ^ 1'b1)};
    wire [8:0] cand_33_0_1 = pm_32_0 + {7'b0, bm_33_0_from_0};
    wire [8:0] cand_33_0_2 = pm_32_2 + {7'b0, bm_33_0_from_2};
    wire sel_33_0 = (cand_33_0_1 > cand_33_0_2); // 1 if cand2 better
    wire [8:0] pm_33_0 = sel_33_0 ? cand_33_0_2 : cand_33_0_1;
    wire surv_33_0 = sel_33_0;
    wire [1:0] bm_33_1_from_0 = {1'b0, (r_sys[33] ^ 1'b1)} + {1'b0, (r_par1[33] ^ 1'b1)};
    wire [1:0] bm_33_1_from_2 = {1'b0, (r_sys[33] ^ 1'b1)} + {1'b0, (r_par1[33] ^ 1'b0)};
    wire [8:0] cand_33_1_1 = pm_32_0 + {7'b0, bm_33_1_from_0};
    wire [8:0] cand_33_1_2 = pm_32_2 + {7'b0, bm_33_1_from_2};
    wire sel_33_1 = (cand_33_1_1 > cand_33_1_2); // 1 if cand2 better
    wire [8:0] pm_33_1 = sel_33_1 ? cand_33_1_2 : cand_33_1_1;
    wire surv_33_1 = sel_33_1;
    wire [1:0] bm_33_2_from_1 = {1'b0, (r_sys[33] ^ 1'b0)} + {1'b0, (r_par1[33] ^ 1'b1)};
    wire [1:0] bm_33_2_from_3 = {1'b0, (r_sys[33] ^ 1'b0)} + {1'b0, (r_par1[33] ^ 1'b0)};
    wire [8:0] cand_33_2_1 = pm_32_1 + {7'b0, bm_33_2_from_1};
    wire [8:0] cand_33_2_2 = pm_32_3 + {7'b0, bm_33_2_from_3};
    wire sel_33_2 = (cand_33_2_1 > cand_33_2_2); // 1 if cand2 better
    wire [8:0] pm_33_2 = sel_33_2 ? cand_33_2_2 : cand_33_2_1;
    wire surv_33_2 = sel_33_2;
    wire [1:0] bm_33_3_from_1 = {1'b0, (r_sys[33] ^ 1'b1)} + {1'b0, (r_par1[33] ^ 1'b0)};
    wire [1:0] bm_33_3_from_3 = {1'b0, (r_sys[33] ^ 1'b1)} + {1'b0, (r_par1[33] ^ 1'b1)};
    wire [8:0] cand_33_3_1 = pm_32_1 + {7'b0, bm_33_3_from_1};
    wire [8:0] cand_33_3_2 = pm_32_3 + {7'b0, bm_33_3_from_3};
    wire sel_33_3 = (cand_33_3_1 > cand_33_3_2); // 1 if cand2 better
    wire [8:0] pm_33_3 = sel_33_3 ? cand_33_3_2 : cand_33_3_1;
    wire surv_33_3 = sel_33_3;
    // Stage 34
    wire [1:0] bm_34_0_from_0 = {1'b0, (r_sys[34] ^ 1'b0)} + {1'b0, (r_par1[34] ^ 1'b0)};
    wire [1:0] bm_34_0_from_2 = {1'b0, (r_sys[34] ^ 1'b0)} + {1'b0, (r_par1[34] ^ 1'b1)};
    wire [8:0] cand_34_0_1 = pm_33_0 + {7'b0, bm_34_0_from_0};
    wire [8:0] cand_34_0_2 = pm_33_2 + {7'b0, bm_34_0_from_2};
    wire sel_34_0 = (cand_34_0_1 > cand_34_0_2); // 1 if cand2 better
    wire [8:0] pm_34_0 = sel_34_0 ? cand_34_0_2 : cand_34_0_1;
    wire surv_34_0 = sel_34_0;
    wire [1:0] bm_34_1_from_0 = {1'b0, (r_sys[34] ^ 1'b1)} + {1'b0, (r_par1[34] ^ 1'b1)};
    wire [1:0] bm_34_1_from_2 = {1'b0, (r_sys[34] ^ 1'b1)} + {1'b0, (r_par1[34] ^ 1'b0)};
    wire [8:0] cand_34_1_1 = pm_33_0 + {7'b0, bm_34_1_from_0};
    wire [8:0] cand_34_1_2 = pm_33_2 + {7'b0, bm_34_1_from_2};
    wire sel_34_1 = (cand_34_1_1 > cand_34_1_2); // 1 if cand2 better
    wire [8:0] pm_34_1 = sel_34_1 ? cand_34_1_2 : cand_34_1_1;
    wire surv_34_1 = sel_34_1;
    wire [1:0] bm_34_2_from_1 = {1'b0, (r_sys[34] ^ 1'b0)} + {1'b0, (r_par1[34] ^ 1'b1)};
    wire [1:0] bm_34_2_from_3 = {1'b0, (r_sys[34] ^ 1'b0)} + {1'b0, (r_par1[34] ^ 1'b0)};
    wire [8:0] cand_34_2_1 = pm_33_1 + {7'b0, bm_34_2_from_1};
    wire [8:0] cand_34_2_2 = pm_33_3 + {7'b0, bm_34_2_from_3};
    wire sel_34_2 = (cand_34_2_1 > cand_34_2_2); // 1 if cand2 better
    wire [8:0] pm_34_2 = sel_34_2 ? cand_34_2_2 : cand_34_2_1;
    wire surv_34_2 = sel_34_2;
    wire [1:0] bm_34_3_from_1 = {1'b0, (r_sys[34] ^ 1'b1)} + {1'b0, (r_par1[34] ^ 1'b0)};
    wire [1:0] bm_34_3_from_3 = {1'b0, (r_sys[34] ^ 1'b1)} + {1'b0, (r_par1[34] ^ 1'b1)};
    wire [8:0] cand_34_3_1 = pm_33_1 + {7'b0, bm_34_3_from_1};
    wire [8:0] cand_34_3_2 = pm_33_3 + {7'b0, bm_34_3_from_3};
    wire sel_34_3 = (cand_34_3_1 > cand_34_3_2); // 1 if cand2 better
    wire [8:0] pm_34_3 = sel_34_3 ? cand_34_3_2 : cand_34_3_1;
    wire surv_34_3 = sel_34_3;
    // Stage 35
    wire [1:0] bm_35_0_from_0 = {1'b0, (r_sys[35] ^ 1'b0)} + {1'b0, (r_par1[35] ^ 1'b0)};
    wire [1:0] bm_35_0_from_2 = {1'b0, (r_sys[35] ^ 1'b0)} + {1'b0, (r_par1[35] ^ 1'b1)};
    wire [8:0] cand_35_0_1 = pm_34_0 + {7'b0, bm_35_0_from_0};
    wire [8:0] cand_35_0_2 = pm_34_2 + {7'b0, bm_35_0_from_2};
    wire sel_35_0 = (cand_35_0_1 > cand_35_0_2); // 1 if cand2 better
    wire [8:0] pm_35_0 = sel_35_0 ? cand_35_0_2 : cand_35_0_1;
    wire surv_35_0 = sel_35_0;
    wire [1:0] bm_35_1_from_0 = {1'b0, (r_sys[35] ^ 1'b1)} + {1'b0, (r_par1[35] ^ 1'b1)};
    wire [1:0] bm_35_1_from_2 = {1'b0, (r_sys[35] ^ 1'b1)} + {1'b0, (r_par1[35] ^ 1'b0)};
    wire [8:0] cand_35_1_1 = pm_34_0 + {7'b0, bm_35_1_from_0};
    wire [8:0] cand_35_1_2 = pm_34_2 + {7'b0, bm_35_1_from_2};
    wire sel_35_1 = (cand_35_1_1 > cand_35_1_2); // 1 if cand2 better
    wire [8:0] pm_35_1 = sel_35_1 ? cand_35_1_2 : cand_35_1_1;
    wire surv_35_1 = sel_35_1;
    wire [1:0] bm_35_2_from_1 = {1'b0, (r_sys[35] ^ 1'b0)} + {1'b0, (r_par1[35] ^ 1'b1)};
    wire [1:0] bm_35_2_from_3 = {1'b0, (r_sys[35] ^ 1'b0)} + {1'b0, (r_par1[35] ^ 1'b0)};
    wire [8:0] cand_35_2_1 = pm_34_1 + {7'b0, bm_35_2_from_1};
    wire [8:0] cand_35_2_2 = pm_34_3 + {7'b0, bm_35_2_from_3};
    wire sel_35_2 = (cand_35_2_1 > cand_35_2_2); // 1 if cand2 better
    wire [8:0] pm_35_2 = sel_35_2 ? cand_35_2_2 : cand_35_2_1;
    wire surv_35_2 = sel_35_2;
    wire [1:0] bm_35_3_from_1 = {1'b0, (r_sys[35] ^ 1'b1)} + {1'b0, (r_par1[35] ^ 1'b0)};
    wire [1:0] bm_35_3_from_3 = {1'b0, (r_sys[35] ^ 1'b1)} + {1'b0, (r_par1[35] ^ 1'b1)};
    wire [8:0] cand_35_3_1 = pm_34_1 + {7'b0, bm_35_3_from_1};
    wire [8:0] cand_35_3_2 = pm_34_3 + {7'b0, bm_35_3_from_3};
    wire sel_35_3 = (cand_35_3_1 > cand_35_3_2); // 1 if cand2 better
    wire [8:0] pm_35_3 = sel_35_3 ? cand_35_3_2 : cand_35_3_1;
    wire surv_35_3 = sel_35_3;
    // Stage 36
    wire [1:0] bm_36_0_from_0 = {1'b0, (r_sys[36] ^ 1'b0)} + {1'b0, (r_par1[36] ^ 1'b0)};
    wire [1:0] bm_36_0_from_2 = {1'b0, (r_sys[36] ^ 1'b0)} + {1'b0, (r_par1[36] ^ 1'b1)};
    wire [8:0] cand_36_0_1 = pm_35_0 + {7'b0, bm_36_0_from_0};
    wire [8:0] cand_36_0_2 = pm_35_2 + {7'b0, bm_36_0_from_2};
    wire sel_36_0 = (cand_36_0_1 > cand_36_0_2); // 1 if cand2 better
    wire [8:0] pm_36_0 = sel_36_0 ? cand_36_0_2 : cand_36_0_1;
    wire surv_36_0 = sel_36_0;
    wire [1:0] bm_36_1_from_0 = {1'b0, (r_sys[36] ^ 1'b1)} + {1'b0, (r_par1[36] ^ 1'b1)};
    wire [1:0] bm_36_1_from_2 = {1'b0, (r_sys[36] ^ 1'b1)} + {1'b0, (r_par1[36] ^ 1'b0)};
    wire [8:0] cand_36_1_1 = pm_35_0 + {7'b0, bm_36_1_from_0};
    wire [8:0] cand_36_1_2 = pm_35_2 + {7'b0, bm_36_1_from_2};
    wire sel_36_1 = (cand_36_1_1 > cand_36_1_2); // 1 if cand2 better
    wire [8:0] pm_36_1 = sel_36_1 ? cand_36_1_2 : cand_36_1_1;
    wire surv_36_1 = sel_36_1;
    wire [1:0] bm_36_2_from_1 = {1'b0, (r_sys[36] ^ 1'b0)} + {1'b0, (r_par1[36] ^ 1'b1)};
    wire [1:0] bm_36_2_from_3 = {1'b0, (r_sys[36] ^ 1'b0)} + {1'b0, (r_par1[36] ^ 1'b0)};
    wire [8:0] cand_36_2_1 = pm_35_1 + {7'b0, bm_36_2_from_1};
    wire [8:0] cand_36_2_2 = pm_35_3 + {7'b0, bm_36_2_from_3};
    wire sel_36_2 = (cand_36_2_1 > cand_36_2_2); // 1 if cand2 better
    wire [8:0] pm_36_2 = sel_36_2 ? cand_36_2_2 : cand_36_2_1;
    wire surv_36_2 = sel_36_2;
    wire [1:0] bm_36_3_from_1 = {1'b0, (r_sys[36] ^ 1'b1)} + {1'b0, (r_par1[36] ^ 1'b0)};
    wire [1:0] bm_36_3_from_3 = {1'b0, (r_sys[36] ^ 1'b1)} + {1'b0, (r_par1[36] ^ 1'b1)};
    wire [8:0] cand_36_3_1 = pm_35_1 + {7'b0, bm_36_3_from_1};
    wire [8:0] cand_36_3_2 = pm_35_3 + {7'b0, bm_36_3_from_3};
    wire sel_36_3 = (cand_36_3_1 > cand_36_3_2); // 1 if cand2 better
    wire [8:0] pm_36_3 = sel_36_3 ? cand_36_3_2 : cand_36_3_1;
    wire surv_36_3 = sel_36_3;
    // Stage 37
    wire [1:0] bm_37_0_from_0 = {1'b0, (r_sys[37] ^ 1'b0)} + {1'b0, (r_par1[37] ^ 1'b0)};
    wire [1:0] bm_37_0_from_2 = {1'b0, (r_sys[37] ^ 1'b0)} + {1'b0, (r_par1[37] ^ 1'b1)};
    wire [8:0] cand_37_0_1 = pm_36_0 + {7'b0, bm_37_0_from_0};
    wire [8:0] cand_37_0_2 = pm_36_2 + {7'b0, bm_37_0_from_2};
    wire sel_37_0 = (cand_37_0_1 > cand_37_0_2); // 1 if cand2 better
    wire [8:0] pm_37_0 = sel_37_0 ? cand_37_0_2 : cand_37_0_1;
    wire surv_37_0 = sel_37_0;
    wire [1:0] bm_37_1_from_0 = {1'b0, (r_sys[37] ^ 1'b1)} + {1'b0, (r_par1[37] ^ 1'b1)};
    wire [1:0] bm_37_1_from_2 = {1'b0, (r_sys[37] ^ 1'b1)} + {1'b0, (r_par1[37] ^ 1'b0)};
    wire [8:0] cand_37_1_1 = pm_36_0 + {7'b0, bm_37_1_from_0};
    wire [8:0] cand_37_1_2 = pm_36_2 + {7'b0, bm_37_1_from_2};
    wire sel_37_1 = (cand_37_1_1 > cand_37_1_2); // 1 if cand2 better
    wire [8:0] pm_37_1 = sel_37_1 ? cand_37_1_2 : cand_37_1_1;
    wire surv_37_1 = sel_37_1;
    wire [1:0] bm_37_2_from_1 = {1'b0, (r_sys[37] ^ 1'b0)} + {1'b0, (r_par1[37] ^ 1'b1)};
    wire [1:0] bm_37_2_from_3 = {1'b0, (r_sys[37] ^ 1'b0)} + {1'b0, (r_par1[37] ^ 1'b0)};
    wire [8:0] cand_37_2_1 = pm_36_1 + {7'b0, bm_37_2_from_1};
    wire [8:0] cand_37_2_2 = pm_36_3 + {7'b0, bm_37_2_from_3};
    wire sel_37_2 = (cand_37_2_1 > cand_37_2_2); // 1 if cand2 better
    wire [8:0] pm_37_2 = sel_37_2 ? cand_37_2_2 : cand_37_2_1;
    wire surv_37_2 = sel_37_2;
    wire [1:0] bm_37_3_from_1 = {1'b0, (r_sys[37] ^ 1'b1)} + {1'b0, (r_par1[37] ^ 1'b0)};
    wire [1:0] bm_37_3_from_3 = {1'b0, (r_sys[37] ^ 1'b1)} + {1'b0, (r_par1[37] ^ 1'b1)};
    wire [8:0] cand_37_3_1 = pm_36_1 + {7'b0, bm_37_3_from_1};
    wire [8:0] cand_37_3_2 = pm_36_3 + {7'b0, bm_37_3_from_3};
    wire sel_37_3 = (cand_37_3_1 > cand_37_3_2); // 1 if cand2 better
    wire [8:0] pm_37_3 = sel_37_3 ? cand_37_3_2 : cand_37_3_1;
    wire surv_37_3 = sel_37_3;
    // Stage 38
    wire [1:0] bm_38_0_from_0 = {1'b0, (r_sys[38] ^ 1'b0)} + {1'b0, (r_par1[38] ^ 1'b0)};
    wire [1:0] bm_38_0_from_2 = {1'b0, (r_sys[38] ^ 1'b0)} + {1'b0, (r_par1[38] ^ 1'b1)};
    wire [8:0] cand_38_0_1 = pm_37_0 + {7'b0, bm_38_0_from_0};
    wire [8:0] cand_38_0_2 = pm_37_2 + {7'b0, bm_38_0_from_2};
    wire sel_38_0 = (cand_38_0_1 > cand_38_0_2); // 1 if cand2 better
    wire [8:0] pm_38_0 = sel_38_0 ? cand_38_0_2 : cand_38_0_1;
    wire surv_38_0 = sel_38_0;
    wire [1:0] bm_38_1_from_0 = {1'b0, (r_sys[38] ^ 1'b1)} + {1'b0, (r_par1[38] ^ 1'b1)};
    wire [1:0] bm_38_1_from_2 = {1'b0, (r_sys[38] ^ 1'b1)} + {1'b0, (r_par1[38] ^ 1'b0)};
    wire [8:0] cand_38_1_1 = pm_37_0 + {7'b0, bm_38_1_from_0};
    wire [8:0] cand_38_1_2 = pm_37_2 + {7'b0, bm_38_1_from_2};
    wire sel_38_1 = (cand_38_1_1 > cand_38_1_2); // 1 if cand2 better
    wire [8:0] pm_38_1 = sel_38_1 ? cand_38_1_2 : cand_38_1_1;
    wire surv_38_1 = sel_38_1;
    wire [1:0] bm_38_2_from_1 = {1'b0, (r_sys[38] ^ 1'b0)} + {1'b0, (r_par1[38] ^ 1'b1)};
    wire [1:0] bm_38_2_from_3 = {1'b0, (r_sys[38] ^ 1'b0)} + {1'b0, (r_par1[38] ^ 1'b0)};
    wire [8:0] cand_38_2_1 = pm_37_1 + {7'b0, bm_38_2_from_1};
    wire [8:0] cand_38_2_2 = pm_37_3 + {7'b0, bm_38_2_from_3};
    wire sel_38_2 = (cand_38_2_1 > cand_38_2_2); // 1 if cand2 better
    wire [8:0] pm_38_2 = sel_38_2 ? cand_38_2_2 : cand_38_2_1;
    wire surv_38_2 = sel_38_2;
    wire [1:0] bm_38_3_from_1 = {1'b0, (r_sys[38] ^ 1'b1)} + {1'b0, (r_par1[38] ^ 1'b0)};
    wire [1:0] bm_38_3_from_3 = {1'b0, (r_sys[38] ^ 1'b1)} + {1'b0, (r_par1[38] ^ 1'b1)};
    wire [8:0] cand_38_3_1 = pm_37_1 + {7'b0, bm_38_3_from_1};
    wire [8:0] cand_38_3_2 = pm_37_3 + {7'b0, bm_38_3_from_3};
    wire sel_38_3 = (cand_38_3_1 > cand_38_3_2); // 1 if cand2 better
    wire [8:0] pm_38_3 = sel_38_3 ? cand_38_3_2 : cand_38_3_1;
    wire surv_38_3 = sel_38_3;
    // Stage 39
    wire [1:0] bm_39_0_from_0 = {1'b0, (r_sys[39] ^ 1'b0)} + {1'b0, (r_par1[39] ^ 1'b0)};
    wire [1:0] bm_39_0_from_2 = {1'b0, (r_sys[39] ^ 1'b0)} + {1'b0, (r_par1[39] ^ 1'b1)};
    wire [8:0] cand_39_0_1 = pm_38_0 + {7'b0, bm_39_0_from_0};
    wire [8:0] cand_39_0_2 = pm_38_2 + {7'b0, bm_39_0_from_2};
    wire sel_39_0 = (cand_39_0_1 > cand_39_0_2); // 1 if cand2 better
    wire [8:0] pm_39_0 = sel_39_0 ? cand_39_0_2 : cand_39_0_1;
    wire surv_39_0 = sel_39_0;
    wire [1:0] bm_39_1_from_0 = {1'b0, (r_sys[39] ^ 1'b1)} + {1'b0, (r_par1[39] ^ 1'b1)};
    wire [1:0] bm_39_1_from_2 = {1'b0, (r_sys[39] ^ 1'b1)} + {1'b0, (r_par1[39] ^ 1'b0)};
    wire [8:0] cand_39_1_1 = pm_38_0 + {7'b0, bm_39_1_from_0};
    wire [8:0] cand_39_1_2 = pm_38_2 + {7'b0, bm_39_1_from_2};
    wire sel_39_1 = (cand_39_1_1 > cand_39_1_2); // 1 if cand2 better
    wire [8:0] pm_39_1 = sel_39_1 ? cand_39_1_2 : cand_39_1_1;
    wire surv_39_1 = sel_39_1;
    wire [1:0] bm_39_2_from_1 = {1'b0, (r_sys[39] ^ 1'b0)} + {1'b0, (r_par1[39] ^ 1'b1)};
    wire [1:0] bm_39_2_from_3 = {1'b0, (r_sys[39] ^ 1'b0)} + {1'b0, (r_par1[39] ^ 1'b0)};
    wire [8:0] cand_39_2_1 = pm_38_1 + {7'b0, bm_39_2_from_1};
    wire [8:0] cand_39_2_2 = pm_38_3 + {7'b0, bm_39_2_from_3};
    wire sel_39_2 = (cand_39_2_1 > cand_39_2_2); // 1 if cand2 better
    wire [8:0] pm_39_2 = sel_39_2 ? cand_39_2_2 : cand_39_2_1;
    wire surv_39_2 = sel_39_2;
    wire [1:0] bm_39_3_from_1 = {1'b0, (r_sys[39] ^ 1'b1)} + {1'b0, (r_par1[39] ^ 1'b0)};
    wire [1:0] bm_39_3_from_3 = {1'b0, (r_sys[39] ^ 1'b1)} + {1'b0, (r_par1[39] ^ 1'b1)};
    wire [8:0] cand_39_3_1 = pm_38_1 + {7'b0, bm_39_3_from_1};
    wire [8:0] cand_39_3_2 = pm_38_3 + {7'b0, bm_39_3_from_3};
    wire sel_39_3 = (cand_39_3_1 > cand_39_3_2); // 1 if cand2 better
    wire [8:0] pm_39_3 = sel_39_3 ? cand_39_3_2 : cand_39_3_1;
    wire surv_39_3 = sel_39_3;
    // Stage 40
    wire [1:0] bm_40_0_from_0 = {1'b0, (r_sys[40] ^ 1'b0)} + {1'b0, (r_par1[40] ^ 1'b0)};
    wire [1:0] bm_40_0_from_2 = {1'b0, (r_sys[40] ^ 1'b0)} + {1'b0, (r_par1[40] ^ 1'b1)};
    wire [8:0] cand_40_0_1 = pm_39_0 + {7'b0, bm_40_0_from_0};
    wire [8:0] cand_40_0_2 = pm_39_2 + {7'b0, bm_40_0_from_2};
    wire sel_40_0 = (cand_40_0_1 > cand_40_0_2); // 1 if cand2 better
    wire [8:0] pm_40_0 = sel_40_0 ? cand_40_0_2 : cand_40_0_1;
    wire surv_40_0 = sel_40_0;
    wire [1:0] bm_40_1_from_0 = {1'b0, (r_sys[40] ^ 1'b1)} + {1'b0, (r_par1[40] ^ 1'b1)};
    wire [1:0] bm_40_1_from_2 = {1'b0, (r_sys[40] ^ 1'b1)} + {1'b0, (r_par1[40] ^ 1'b0)};
    wire [8:0] cand_40_1_1 = pm_39_0 + {7'b0, bm_40_1_from_0};
    wire [8:0] cand_40_1_2 = pm_39_2 + {7'b0, bm_40_1_from_2};
    wire sel_40_1 = (cand_40_1_1 > cand_40_1_2); // 1 if cand2 better
    wire [8:0] pm_40_1 = sel_40_1 ? cand_40_1_2 : cand_40_1_1;
    wire surv_40_1 = sel_40_1;
    wire [1:0] bm_40_2_from_1 = {1'b0, (r_sys[40] ^ 1'b0)} + {1'b0, (r_par1[40] ^ 1'b1)};
    wire [1:0] bm_40_2_from_3 = {1'b0, (r_sys[40] ^ 1'b0)} + {1'b0, (r_par1[40] ^ 1'b0)};
    wire [8:0] cand_40_2_1 = pm_39_1 + {7'b0, bm_40_2_from_1};
    wire [8:0] cand_40_2_2 = pm_39_3 + {7'b0, bm_40_2_from_3};
    wire sel_40_2 = (cand_40_2_1 > cand_40_2_2); // 1 if cand2 better
    wire [8:0] pm_40_2 = sel_40_2 ? cand_40_2_2 : cand_40_2_1;
    wire surv_40_2 = sel_40_2;
    wire [1:0] bm_40_3_from_1 = {1'b0, (r_sys[40] ^ 1'b1)} + {1'b0, (r_par1[40] ^ 1'b0)};
    wire [1:0] bm_40_3_from_3 = {1'b0, (r_sys[40] ^ 1'b1)} + {1'b0, (r_par1[40] ^ 1'b1)};
    wire [8:0] cand_40_3_1 = pm_39_1 + {7'b0, bm_40_3_from_1};
    wire [8:0] cand_40_3_2 = pm_39_3 + {7'b0, bm_40_3_from_3};
    wire sel_40_3 = (cand_40_3_1 > cand_40_3_2); // 1 if cand2 better
    wire [8:0] pm_40_3 = sel_40_3 ? cand_40_3_2 : cand_40_3_1;
    wire surv_40_3 = sel_40_3;
    // Stage 41
    wire [1:0] bm_41_0_from_0 = {1'b0, (r_sys[41] ^ 1'b0)} + {1'b0, (r_par1[41] ^ 1'b0)};
    wire [1:0] bm_41_0_from_2 = {1'b0, (r_sys[41] ^ 1'b0)} + {1'b0, (r_par1[41] ^ 1'b1)};
    wire [8:0] cand_41_0_1 = pm_40_0 + {7'b0, bm_41_0_from_0};
    wire [8:0] cand_41_0_2 = pm_40_2 + {7'b0, bm_41_0_from_2};
    wire sel_41_0 = (cand_41_0_1 > cand_41_0_2); // 1 if cand2 better
    wire [8:0] pm_41_0 = sel_41_0 ? cand_41_0_2 : cand_41_0_1;
    wire surv_41_0 = sel_41_0;
    wire [1:0] bm_41_1_from_0 = {1'b0, (r_sys[41] ^ 1'b1)} + {1'b0, (r_par1[41] ^ 1'b1)};
    wire [1:0] bm_41_1_from_2 = {1'b0, (r_sys[41] ^ 1'b1)} + {1'b0, (r_par1[41] ^ 1'b0)};
    wire [8:0] cand_41_1_1 = pm_40_0 + {7'b0, bm_41_1_from_0};
    wire [8:0] cand_41_1_2 = pm_40_2 + {7'b0, bm_41_1_from_2};
    wire sel_41_1 = (cand_41_1_1 > cand_41_1_2); // 1 if cand2 better
    wire [8:0] pm_41_1 = sel_41_1 ? cand_41_1_2 : cand_41_1_1;
    wire surv_41_1 = sel_41_1;
    wire [1:0] bm_41_2_from_1 = {1'b0, (r_sys[41] ^ 1'b0)} + {1'b0, (r_par1[41] ^ 1'b1)};
    wire [1:0] bm_41_2_from_3 = {1'b0, (r_sys[41] ^ 1'b0)} + {1'b0, (r_par1[41] ^ 1'b0)};
    wire [8:0] cand_41_2_1 = pm_40_1 + {7'b0, bm_41_2_from_1};
    wire [8:0] cand_41_2_2 = pm_40_3 + {7'b0, bm_41_2_from_3};
    wire sel_41_2 = (cand_41_2_1 > cand_41_2_2); // 1 if cand2 better
    wire [8:0] pm_41_2 = sel_41_2 ? cand_41_2_2 : cand_41_2_1;
    wire surv_41_2 = sel_41_2;
    wire [1:0] bm_41_3_from_1 = {1'b0, (r_sys[41] ^ 1'b1)} + {1'b0, (r_par1[41] ^ 1'b0)};
    wire [1:0] bm_41_3_from_3 = {1'b0, (r_sys[41] ^ 1'b1)} + {1'b0, (r_par1[41] ^ 1'b1)};
    wire [8:0] cand_41_3_1 = pm_40_1 + {7'b0, bm_41_3_from_1};
    wire [8:0] cand_41_3_2 = pm_40_3 + {7'b0, bm_41_3_from_3};
    wire sel_41_3 = (cand_41_3_1 > cand_41_3_2); // 1 if cand2 better
    wire [8:0] pm_41_3 = sel_41_3 ? cand_41_3_2 : cand_41_3_1;
    wire surv_41_3 = sel_41_3;
    // Stage 42
    wire [1:0] bm_42_0_from_0 = {1'b0, (r_sys[42] ^ 1'b0)} + {1'b0, (r_par1[42] ^ 1'b0)};
    wire [1:0] bm_42_0_from_2 = {1'b0, (r_sys[42] ^ 1'b0)} + {1'b0, (r_par1[42] ^ 1'b1)};
    wire [8:0] cand_42_0_1 = pm_41_0 + {7'b0, bm_42_0_from_0};
    wire [8:0] cand_42_0_2 = pm_41_2 + {7'b0, bm_42_0_from_2};
    wire sel_42_0 = (cand_42_0_1 > cand_42_0_2); // 1 if cand2 better
    wire [8:0] pm_42_0 = sel_42_0 ? cand_42_0_2 : cand_42_0_1;
    wire surv_42_0 = sel_42_0;
    wire [1:0] bm_42_1_from_0 = {1'b0, (r_sys[42] ^ 1'b1)} + {1'b0, (r_par1[42] ^ 1'b1)};
    wire [1:0] bm_42_1_from_2 = {1'b0, (r_sys[42] ^ 1'b1)} + {1'b0, (r_par1[42] ^ 1'b0)};
    wire [8:0] cand_42_1_1 = pm_41_0 + {7'b0, bm_42_1_from_0};
    wire [8:0] cand_42_1_2 = pm_41_2 + {7'b0, bm_42_1_from_2};
    wire sel_42_1 = (cand_42_1_1 > cand_42_1_2); // 1 if cand2 better
    wire [8:0] pm_42_1 = sel_42_1 ? cand_42_1_2 : cand_42_1_1;
    wire surv_42_1 = sel_42_1;
    wire [1:0] bm_42_2_from_1 = {1'b0, (r_sys[42] ^ 1'b0)} + {1'b0, (r_par1[42] ^ 1'b1)};
    wire [1:0] bm_42_2_from_3 = {1'b0, (r_sys[42] ^ 1'b0)} + {1'b0, (r_par1[42] ^ 1'b0)};
    wire [8:0] cand_42_2_1 = pm_41_1 + {7'b0, bm_42_2_from_1};
    wire [8:0] cand_42_2_2 = pm_41_3 + {7'b0, bm_42_2_from_3};
    wire sel_42_2 = (cand_42_2_1 > cand_42_2_2); // 1 if cand2 better
    wire [8:0] pm_42_2 = sel_42_2 ? cand_42_2_2 : cand_42_2_1;
    wire surv_42_2 = sel_42_2;
    wire [1:0] bm_42_3_from_1 = {1'b0, (r_sys[42] ^ 1'b1)} + {1'b0, (r_par1[42] ^ 1'b0)};
    wire [1:0] bm_42_3_from_3 = {1'b0, (r_sys[42] ^ 1'b1)} + {1'b0, (r_par1[42] ^ 1'b1)};
    wire [8:0] cand_42_3_1 = pm_41_1 + {7'b0, bm_42_3_from_1};
    wire [8:0] cand_42_3_2 = pm_41_3 + {7'b0, bm_42_3_from_3};
    wire sel_42_3 = (cand_42_3_1 > cand_42_3_2); // 1 if cand2 better
    wire [8:0] pm_42_3 = sel_42_3 ? cand_42_3_2 : cand_42_3_1;
    wire surv_42_3 = sel_42_3;
    // Stage 43
    wire [1:0] bm_43_0_from_0 = {1'b0, (r_sys[43] ^ 1'b0)} + {1'b0, (r_par1[43] ^ 1'b0)};
    wire [1:0] bm_43_0_from_2 = {1'b0, (r_sys[43] ^ 1'b0)} + {1'b0, (r_par1[43] ^ 1'b1)};
    wire [8:0] cand_43_0_1 = pm_42_0 + {7'b0, bm_43_0_from_0};
    wire [8:0] cand_43_0_2 = pm_42_2 + {7'b0, bm_43_0_from_2};
    wire sel_43_0 = (cand_43_0_1 > cand_43_0_2); // 1 if cand2 better
    wire [8:0] pm_43_0 = sel_43_0 ? cand_43_0_2 : cand_43_0_1;
    wire surv_43_0 = sel_43_0;
    wire [1:0] bm_43_1_from_0 = {1'b0, (r_sys[43] ^ 1'b1)} + {1'b0, (r_par1[43] ^ 1'b1)};
    wire [1:0] bm_43_1_from_2 = {1'b0, (r_sys[43] ^ 1'b1)} + {1'b0, (r_par1[43] ^ 1'b0)};
    wire [8:0] cand_43_1_1 = pm_42_0 + {7'b0, bm_43_1_from_0};
    wire [8:0] cand_43_1_2 = pm_42_2 + {7'b0, bm_43_1_from_2};
    wire sel_43_1 = (cand_43_1_1 > cand_43_1_2); // 1 if cand2 better
    wire [8:0] pm_43_1 = sel_43_1 ? cand_43_1_2 : cand_43_1_1;
    wire surv_43_1 = sel_43_1;
    wire [1:0] bm_43_2_from_1 = {1'b0, (r_sys[43] ^ 1'b0)} + {1'b0, (r_par1[43] ^ 1'b1)};
    wire [1:0] bm_43_2_from_3 = {1'b0, (r_sys[43] ^ 1'b0)} + {1'b0, (r_par1[43] ^ 1'b0)};
    wire [8:0] cand_43_2_1 = pm_42_1 + {7'b0, bm_43_2_from_1};
    wire [8:0] cand_43_2_2 = pm_42_3 + {7'b0, bm_43_2_from_3};
    wire sel_43_2 = (cand_43_2_1 > cand_43_2_2); // 1 if cand2 better
    wire [8:0] pm_43_2 = sel_43_2 ? cand_43_2_2 : cand_43_2_1;
    wire surv_43_2 = sel_43_2;
    wire [1:0] bm_43_3_from_1 = {1'b0, (r_sys[43] ^ 1'b1)} + {1'b0, (r_par1[43] ^ 1'b0)};
    wire [1:0] bm_43_3_from_3 = {1'b0, (r_sys[43] ^ 1'b1)} + {1'b0, (r_par1[43] ^ 1'b1)};
    wire [8:0] cand_43_3_1 = pm_42_1 + {7'b0, bm_43_3_from_1};
    wire [8:0] cand_43_3_2 = pm_42_3 + {7'b0, bm_43_3_from_3};
    wire sel_43_3 = (cand_43_3_1 > cand_43_3_2); // 1 if cand2 better
    wire [8:0] pm_43_3 = sel_43_3 ? cand_43_3_2 : cand_43_3_1;
    wire surv_43_3 = sel_43_3;
    // Stage 44
    wire [1:0] bm_44_0_from_0 = {1'b0, (r_sys[44] ^ 1'b0)} + {1'b0, (r_par1[44] ^ 1'b0)};
    wire [1:0] bm_44_0_from_2 = {1'b0, (r_sys[44] ^ 1'b0)} + {1'b0, (r_par1[44] ^ 1'b1)};
    wire [8:0] cand_44_0_1 = pm_43_0 + {7'b0, bm_44_0_from_0};
    wire [8:0] cand_44_0_2 = pm_43_2 + {7'b0, bm_44_0_from_2};
    wire sel_44_0 = (cand_44_0_1 > cand_44_0_2); // 1 if cand2 better
    wire [8:0] pm_44_0 = sel_44_0 ? cand_44_0_2 : cand_44_0_1;
    wire surv_44_0 = sel_44_0;
    wire [1:0] bm_44_1_from_0 = {1'b0, (r_sys[44] ^ 1'b1)} + {1'b0, (r_par1[44] ^ 1'b1)};
    wire [1:0] bm_44_1_from_2 = {1'b0, (r_sys[44] ^ 1'b1)} + {1'b0, (r_par1[44] ^ 1'b0)};
    wire [8:0] cand_44_1_1 = pm_43_0 + {7'b0, bm_44_1_from_0};
    wire [8:0] cand_44_1_2 = pm_43_2 + {7'b0, bm_44_1_from_2};
    wire sel_44_1 = (cand_44_1_1 > cand_44_1_2); // 1 if cand2 better
    wire [8:0] pm_44_1 = sel_44_1 ? cand_44_1_2 : cand_44_1_1;
    wire surv_44_1 = sel_44_1;
    wire [1:0] bm_44_2_from_1 = {1'b0, (r_sys[44] ^ 1'b0)} + {1'b0, (r_par1[44] ^ 1'b1)};
    wire [1:0] bm_44_2_from_3 = {1'b0, (r_sys[44] ^ 1'b0)} + {1'b0, (r_par1[44] ^ 1'b0)};
    wire [8:0] cand_44_2_1 = pm_43_1 + {7'b0, bm_44_2_from_1};
    wire [8:0] cand_44_2_2 = pm_43_3 + {7'b0, bm_44_2_from_3};
    wire sel_44_2 = (cand_44_2_1 > cand_44_2_2); // 1 if cand2 better
    wire [8:0] pm_44_2 = sel_44_2 ? cand_44_2_2 : cand_44_2_1;
    wire surv_44_2 = sel_44_2;
    wire [1:0] bm_44_3_from_1 = {1'b0, (r_sys[44] ^ 1'b1)} + {1'b0, (r_par1[44] ^ 1'b0)};
    wire [1:0] bm_44_3_from_3 = {1'b0, (r_sys[44] ^ 1'b1)} + {1'b0, (r_par1[44] ^ 1'b1)};
    wire [8:0] cand_44_3_1 = pm_43_1 + {7'b0, bm_44_3_from_1};
    wire [8:0] cand_44_3_2 = pm_43_3 + {7'b0, bm_44_3_from_3};
    wire sel_44_3 = (cand_44_3_1 > cand_44_3_2); // 1 if cand2 better
    wire [8:0] pm_44_3 = sel_44_3 ? cand_44_3_2 : cand_44_3_1;
    wire surv_44_3 = sel_44_3;
    // Stage 45
    wire [1:0] bm_45_0_from_0 = {1'b0, (r_sys[45] ^ 1'b0)} + {1'b0, (r_par1[45] ^ 1'b0)};
    wire [1:0] bm_45_0_from_2 = {1'b0, (r_sys[45] ^ 1'b0)} + {1'b0, (r_par1[45] ^ 1'b1)};
    wire [8:0] cand_45_0_1 = pm_44_0 + {7'b0, bm_45_0_from_0};
    wire [8:0] cand_45_0_2 = pm_44_2 + {7'b0, bm_45_0_from_2};
    wire sel_45_0 = (cand_45_0_1 > cand_45_0_2); // 1 if cand2 better
    wire [8:0] pm_45_0 = sel_45_0 ? cand_45_0_2 : cand_45_0_1;
    wire surv_45_0 = sel_45_0;
    wire [1:0] bm_45_1_from_0 = {1'b0, (r_sys[45] ^ 1'b1)} + {1'b0, (r_par1[45] ^ 1'b1)};
    wire [1:0] bm_45_1_from_2 = {1'b0, (r_sys[45] ^ 1'b1)} + {1'b0, (r_par1[45] ^ 1'b0)};
    wire [8:0] cand_45_1_1 = pm_44_0 + {7'b0, bm_45_1_from_0};
    wire [8:0] cand_45_1_2 = pm_44_2 + {7'b0, bm_45_1_from_2};
    wire sel_45_1 = (cand_45_1_1 > cand_45_1_2); // 1 if cand2 better
    wire [8:0] pm_45_1 = sel_45_1 ? cand_45_1_2 : cand_45_1_1;
    wire surv_45_1 = sel_45_1;
    wire [1:0] bm_45_2_from_1 = {1'b0, (r_sys[45] ^ 1'b0)} + {1'b0, (r_par1[45] ^ 1'b1)};
    wire [1:0] bm_45_2_from_3 = {1'b0, (r_sys[45] ^ 1'b0)} + {1'b0, (r_par1[45] ^ 1'b0)};
    wire [8:0] cand_45_2_1 = pm_44_1 + {7'b0, bm_45_2_from_1};
    wire [8:0] cand_45_2_2 = pm_44_3 + {7'b0, bm_45_2_from_3};
    wire sel_45_2 = (cand_45_2_1 > cand_45_2_2); // 1 if cand2 better
    wire [8:0] pm_45_2 = sel_45_2 ? cand_45_2_2 : cand_45_2_1;
    wire surv_45_2 = sel_45_2;
    wire [1:0] bm_45_3_from_1 = {1'b0, (r_sys[45] ^ 1'b1)} + {1'b0, (r_par1[45] ^ 1'b0)};
    wire [1:0] bm_45_3_from_3 = {1'b0, (r_sys[45] ^ 1'b1)} + {1'b0, (r_par1[45] ^ 1'b1)};
    wire [8:0] cand_45_3_1 = pm_44_1 + {7'b0, bm_45_3_from_1};
    wire [8:0] cand_45_3_2 = pm_44_3 + {7'b0, bm_45_3_from_3};
    wire sel_45_3 = (cand_45_3_1 > cand_45_3_2); // 1 if cand2 better
    wire [8:0] pm_45_3 = sel_45_3 ? cand_45_3_2 : cand_45_3_1;
    wire surv_45_3 = sel_45_3;
    // Stage 46
    wire [1:0] bm_46_0_from_0 = {1'b0, (r_sys[46] ^ 1'b0)} + {1'b0, (r_par1[46] ^ 1'b0)};
    wire [1:0] bm_46_0_from_2 = {1'b0, (r_sys[46] ^ 1'b0)} + {1'b0, (r_par1[46] ^ 1'b1)};
    wire [8:0] cand_46_0_1 = pm_45_0 + {7'b0, bm_46_0_from_0};
    wire [8:0] cand_46_0_2 = pm_45_2 + {7'b0, bm_46_0_from_2};
    wire sel_46_0 = (cand_46_0_1 > cand_46_0_2); // 1 if cand2 better
    wire [8:0] pm_46_0 = sel_46_0 ? cand_46_0_2 : cand_46_0_1;
    wire surv_46_0 = sel_46_0;
    wire [1:0] bm_46_1_from_0 = {1'b0, (r_sys[46] ^ 1'b1)} + {1'b0, (r_par1[46] ^ 1'b1)};
    wire [1:0] bm_46_1_from_2 = {1'b0, (r_sys[46] ^ 1'b1)} + {1'b0, (r_par1[46] ^ 1'b0)};
    wire [8:0] cand_46_1_1 = pm_45_0 + {7'b0, bm_46_1_from_0};
    wire [8:0] cand_46_1_2 = pm_45_2 + {7'b0, bm_46_1_from_2};
    wire sel_46_1 = (cand_46_1_1 > cand_46_1_2); // 1 if cand2 better
    wire [8:0] pm_46_1 = sel_46_1 ? cand_46_1_2 : cand_46_1_1;
    wire surv_46_1 = sel_46_1;
    wire [1:0] bm_46_2_from_1 = {1'b0, (r_sys[46] ^ 1'b0)} + {1'b0, (r_par1[46] ^ 1'b1)};
    wire [1:0] bm_46_2_from_3 = {1'b0, (r_sys[46] ^ 1'b0)} + {1'b0, (r_par1[46] ^ 1'b0)};
    wire [8:0] cand_46_2_1 = pm_45_1 + {7'b0, bm_46_2_from_1};
    wire [8:0] cand_46_2_2 = pm_45_3 + {7'b0, bm_46_2_from_3};
    wire sel_46_2 = (cand_46_2_1 > cand_46_2_2); // 1 if cand2 better
    wire [8:0] pm_46_2 = sel_46_2 ? cand_46_2_2 : cand_46_2_1;
    wire surv_46_2 = sel_46_2;
    wire [1:0] bm_46_3_from_1 = {1'b0, (r_sys[46] ^ 1'b1)} + {1'b0, (r_par1[46] ^ 1'b0)};
    wire [1:0] bm_46_3_from_3 = {1'b0, (r_sys[46] ^ 1'b1)} + {1'b0, (r_par1[46] ^ 1'b1)};
    wire [8:0] cand_46_3_1 = pm_45_1 + {7'b0, bm_46_3_from_1};
    wire [8:0] cand_46_3_2 = pm_45_3 + {7'b0, bm_46_3_from_3};
    wire sel_46_3 = (cand_46_3_1 > cand_46_3_2); // 1 if cand2 better
    wire [8:0] pm_46_3 = sel_46_3 ? cand_46_3_2 : cand_46_3_1;
    wire surv_46_3 = sel_46_3;
    // Stage 47
    wire [1:0] bm_47_0_from_0 = {1'b0, (r_sys[47] ^ 1'b0)} + {1'b0, (r_par1[47] ^ 1'b0)};
    wire [1:0] bm_47_0_from_2 = {1'b0, (r_sys[47] ^ 1'b0)} + {1'b0, (r_par1[47] ^ 1'b1)};
    wire [8:0] cand_47_0_1 = pm_46_0 + {7'b0, bm_47_0_from_0};
    wire [8:0] cand_47_0_2 = pm_46_2 + {7'b0, bm_47_0_from_2};
    wire sel_47_0 = (cand_47_0_1 > cand_47_0_2); // 1 if cand2 better
    wire [8:0] pm_47_0 = sel_47_0 ? cand_47_0_2 : cand_47_0_1;
    wire surv_47_0 = sel_47_0;
    wire [1:0] bm_47_1_from_0 = {1'b0, (r_sys[47] ^ 1'b1)} + {1'b0, (r_par1[47] ^ 1'b1)};
    wire [1:0] bm_47_1_from_2 = {1'b0, (r_sys[47] ^ 1'b1)} + {1'b0, (r_par1[47] ^ 1'b0)};
    wire [8:0] cand_47_1_1 = pm_46_0 + {7'b0, bm_47_1_from_0};
    wire [8:0] cand_47_1_2 = pm_46_2 + {7'b0, bm_47_1_from_2};
    wire sel_47_1 = (cand_47_1_1 > cand_47_1_2); // 1 if cand2 better
    wire [8:0] pm_47_1 = sel_47_1 ? cand_47_1_2 : cand_47_1_1;
    wire surv_47_1 = sel_47_1;
    wire [1:0] bm_47_2_from_1 = {1'b0, (r_sys[47] ^ 1'b0)} + {1'b0, (r_par1[47] ^ 1'b1)};
    wire [1:0] bm_47_2_from_3 = {1'b0, (r_sys[47] ^ 1'b0)} + {1'b0, (r_par1[47] ^ 1'b0)};
    wire [8:0] cand_47_2_1 = pm_46_1 + {7'b0, bm_47_2_from_1};
    wire [8:0] cand_47_2_2 = pm_46_3 + {7'b0, bm_47_2_from_3};
    wire sel_47_2 = (cand_47_2_1 > cand_47_2_2); // 1 if cand2 better
    wire [8:0] pm_47_2 = sel_47_2 ? cand_47_2_2 : cand_47_2_1;
    wire surv_47_2 = sel_47_2;
    wire [1:0] bm_47_3_from_1 = {1'b0, (r_sys[47] ^ 1'b1)} + {1'b0, (r_par1[47] ^ 1'b0)};
    wire [1:0] bm_47_3_from_3 = {1'b0, (r_sys[47] ^ 1'b1)} + {1'b0, (r_par1[47] ^ 1'b1)};
    wire [8:0] cand_47_3_1 = pm_46_1 + {7'b0, bm_47_3_from_1};
    wire [8:0] cand_47_3_2 = pm_46_3 + {7'b0, bm_47_3_from_3};
    wire sel_47_3 = (cand_47_3_1 > cand_47_3_2); // 1 if cand2 better
    wire [8:0] pm_47_3 = sel_47_3 ? cand_47_3_2 : cand_47_3_1;
    wire surv_47_3 = sel_47_3;
    // Stage 48
    wire [1:0] bm_48_0_from_0 = {1'b0, (r_sys[48] ^ 1'b0)} + {1'b0, (r_par1[48] ^ 1'b0)};
    wire [1:0] bm_48_0_from_2 = {1'b0, (r_sys[48] ^ 1'b0)} + {1'b0, (r_par1[48] ^ 1'b1)};
    wire [8:0] cand_48_0_1 = pm_47_0 + {7'b0, bm_48_0_from_0};
    wire [8:0] cand_48_0_2 = pm_47_2 + {7'b0, bm_48_0_from_2};
    wire sel_48_0 = (cand_48_0_1 > cand_48_0_2); // 1 if cand2 better
    wire [8:0] pm_48_0 = sel_48_0 ? cand_48_0_2 : cand_48_0_1;
    wire surv_48_0 = sel_48_0;
    wire [1:0] bm_48_1_from_0 = {1'b0, (r_sys[48] ^ 1'b1)} + {1'b0, (r_par1[48] ^ 1'b1)};
    wire [1:0] bm_48_1_from_2 = {1'b0, (r_sys[48] ^ 1'b1)} + {1'b0, (r_par1[48] ^ 1'b0)};
    wire [8:0] cand_48_1_1 = pm_47_0 + {7'b0, bm_48_1_from_0};
    wire [8:0] cand_48_1_2 = pm_47_2 + {7'b0, bm_48_1_from_2};
    wire sel_48_1 = (cand_48_1_1 > cand_48_1_2); // 1 if cand2 better
    wire [8:0] pm_48_1 = sel_48_1 ? cand_48_1_2 : cand_48_1_1;
    wire surv_48_1 = sel_48_1;
    wire [1:0] bm_48_2_from_1 = {1'b0, (r_sys[48] ^ 1'b0)} + {1'b0, (r_par1[48] ^ 1'b1)};
    wire [1:0] bm_48_2_from_3 = {1'b0, (r_sys[48] ^ 1'b0)} + {1'b0, (r_par1[48] ^ 1'b0)};
    wire [8:0] cand_48_2_1 = pm_47_1 + {7'b0, bm_48_2_from_1};
    wire [8:0] cand_48_2_2 = pm_47_3 + {7'b0, bm_48_2_from_3};
    wire sel_48_2 = (cand_48_2_1 > cand_48_2_2); // 1 if cand2 better
    wire [8:0] pm_48_2 = sel_48_2 ? cand_48_2_2 : cand_48_2_1;
    wire surv_48_2 = sel_48_2;
    wire [1:0] bm_48_3_from_1 = {1'b0, (r_sys[48] ^ 1'b1)} + {1'b0, (r_par1[48] ^ 1'b0)};
    wire [1:0] bm_48_3_from_3 = {1'b0, (r_sys[48] ^ 1'b1)} + {1'b0, (r_par1[48] ^ 1'b1)};
    wire [8:0] cand_48_3_1 = pm_47_1 + {7'b0, bm_48_3_from_1};
    wire [8:0] cand_48_3_2 = pm_47_3 + {7'b0, bm_48_3_from_3};
    wire sel_48_3 = (cand_48_3_1 > cand_48_3_2); // 1 if cand2 better
    wire [8:0] pm_48_3 = sel_48_3 ? cand_48_3_2 : cand_48_3_1;
    wire surv_48_3 = sel_48_3;
    // Stage 49
    wire [1:0] bm_49_0_from_0 = {1'b0, (r_sys[49] ^ 1'b0)} + {1'b0, (r_par1[49] ^ 1'b0)};
    wire [1:0] bm_49_0_from_2 = {1'b0, (r_sys[49] ^ 1'b0)} + {1'b0, (r_par1[49] ^ 1'b1)};
    wire [8:0] cand_49_0_1 = pm_48_0 + {7'b0, bm_49_0_from_0};
    wire [8:0] cand_49_0_2 = pm_48_2 + {7'b0, bm_49_0_from_2};
    wire sel_49_0 = (cand_49_0_1 > cand_49_0_2); // 1 if cand2 better
    wire [8:0] pm_49_0 = sel_49_0 ? cand_49_0_2 : cand_49_0_1;
    wire surv_49_0 = sel_49_0;
    wire [1:0] bm_49_1_from_0 = {1'b0, (r_sys[49] ^ 1'b1)} + {1'b0, (r_par1[49] ^ 1'b1)};
    wire [1:0] bm_49_1_from_2 = {1'b0, (r_sys[49] ^ 1'b1)} + {1'b0, (r_par1[49] ^ 1'b0)};
    wire [8:0] cand_49_1_1 = pm_48_0 + {7'b0, bm_49_1_from_0};
    wire [8:0] cand_49_1_2 = pm_48_2 + {7'b0, bm_49_1_from_2};
    wire sel_49_1 = (cand_49_1_1 > cand_49_1_2); // 1 if cand2 better
    wire [8:0] pm_49_1 = sel_49_1 ? cand_49_1_2 : cand_49_1_1;
    wire surv_49_1 = sel_49_1;
    wire [1:0] bm_49_2_from_1 = {1'b0, (r_sys[49] ^ 1'b0)} + {1'b0, (r_par1[49] ^ 1'b1)};
    wire [1:0] bm_49_2_from_3 = {1'b0, (r_sys[49] ^ 1'b0)} + {1'b0, (r_par1[49] ^ 1'b0)};
    wire [8:0] cand_49_2_1 = pm_48_1 + {7'b0, bm_49_2_from_1};
    wire [8:0] cand_49_2_2 = pm_48_3 + {7'b0, bm_49_2_from_3};
    wire sel_49_2 = (cand_49_2_1 > cand_49_2_2); // 1 if cand2 better
    wire [8:0] pm_49_2 = sel_49_2 ? cand_49_2_2 : cand_49_2_1;
    wire surv_49_2 = sel_49_2;
    wire [1:0] bm_49_3_from_1 = {1'b0, (r_sys[49] ^ 1'b1)} + {1'b0, (r_par1[49] ^ 1'b0)};
    wire [1:0] bm_49_3_from_3 = {1'b0, (r_sys[49] ^ 1'b1)} + {1'b0, (r_par1[49] ^ 1'b1)};
    wire [8:0] cand_49_3_1 = pm_48_1 + {7'b0, bm_49_3_from_1};
    wire [8:0] cand_49_3_2 = pm_48_3 + {7'b0, bm_49_3_from_3};
    wire sel_49_3 = (cand_49_3_1 > cand_49_3_2); // 1 if cand2 better
    wire [8:0] pm_49_3 = sel_49_3 ? cand_49_3_2 : cand_49_3_1;
    wire surv_49_3 = sel_49_3;
    // Stage 50
    wire [1:0] bm_50_0_from_0 = {1'b0, (r_sys[50] ^ 1'b0)} + {1'b0, (r_par1[50] ^ 1'b0)};
    wire [1:0] bm_50_0_from_2 = {1'b0, (r_sys[50] ^ 1'b0)} + {1'b0, (r_par1[50] ^ 1'b1)};
    wire [8:0] cand_50_0_1 = pm_49_0 + {7'b0, bm_50_0_from_0};
    wire [8:0] cand_50_0_2 = pm_49_2 + {7'b0, bm_50_0_from_2};
    wire sel_50_0 = (cand_50_0_1 > cand_50_0_2); // 1 if cand2 better
    wire [8:0] pm_50_0 = sel_50_0 ? cand_50_0_2 : cand_50_0_1;
    wire surv_50_0 = sel_50_0;
    wire [1:0] bm_50_1_from_0 = {1'b0, (r_sys[50] ^ 1'b1)} + {1'b0, (r_par1[50] ^ 1'b1)};
    wire [1:0] bm_50_1_from_2 = {1'b0, (r_sys[50] ^ 1'b1)} + {1'b0, (r_par1[50] ^ 1'b0)};
    wire [8:0] cand_50_1_1 = pm_49_0 + {7'b0, bm_50_1_from_0};
    wire [8:0] cand_50_1_2 = pm_49_2 + {7'b0, bm_50_1_from_2};
    wire sel_50_1 = (cand_50_1_1 > cand_50_1_2); // 1 if cand2 better
    wire [8:0] pm_50_1 = sel_50_1 ? cand_50_1_2 : cand_50_1_1;
    wire surv_50_1 = sel_50_1;
    wire [1:0] bm_50_2_from_1 = {1'b0, (r_sys[50] ^ 1'b0)} + {1'b0, (r_par1[50] ^ 1'b1)};
    wire [1:0] bm_50_2_from_3 = {1'b0, (r_sys[50] ^ 1'b0)} + {1'b0, (r_par1[50] ^ 1'b0)};
    wire [8:0] cand_50_2_1 = pm_49_1 + {7'b0, bm_50_2_from_1};
    wire [8:0] cand_50_2_2 = pm_49_3 + {7'b0, bm_50_2_from_3};
    wire sel_50_2 = (cand_50_2_1 > cand_50_2_2); // 1 if cand2 better
    wire [8:0] pm_50_2 = sel_50_2 ? cand_50_2_2 : cand_50_2_1;
    wire surv_50_2 = sel_50_2;
    wire [1:0] bm_50_3_from_1 = {1'b0, (r_sys[50] ^ 1'b1)} + {1'b0, (r_par1[50] ^ 1'b0)};
    wire [1:0] bm_50_3_from_3 = {1'b0, (r_sys[50] ^ 1'b1)} + {1'b0, (r_par1[50] ^ 1'b1)};
    wire [8:0] cand_50_3_1 = pm_49_1 + {7'b0, bm_50_3_from_1};
    wire [8:0] cand_50_3_2 = pm_49_3 + {7'b0, bm_50_3_from_3};
    wire sel_50_3 = (cand_50_3_1 > cand_50_3_2); // 1 if cand2 better
    wire [8:0] pm_50_3 = sel_50_3 ? cand_50_3_2 : cand_50_3_1;
    wire surv_50_3 = sel_50_3;
    // Stage 51
    wire [1:0] bm_51_0_from_0 = {1'b0, (r_sys[51] ^ 1'b0)} + {1'b0, (r_par1[51] ^ 1'b0)};
    wire [1:0] bm_51_0_from_2 = {1'b0, (r_sys[51] ^ 1'b0)} + {1'b0, (r_par1[51] ^ 1'b1)};
    wire [8:0] cand_51_0_1 = pm_50_0 + {7'b0, bm_51_0_from_0};
    wire [8:0] cand_51_0_2 = pm_50_2 + {7'b0, bm_51_0_from_2};
    wire sel_51_0 = (cand_51_0_1 > cand_51_0_2); // 1 if cand2 better
    wire [8:0] pm_51_0 = sel_51_0 ? cand_51_0_2 : cand_51_0_1;
    wire surv_51_0 = sel_51_0;
    wire [1:0] bm_51_1_from_0 = {1'b0, (r_sys[51] ^ 1'b1)} + {1'b0, (r_par1[51] ^ 1'b1)};
    wire [1:0] bm_51_1_from_2 = {1'b0, (r_sys[51] ^ 1'b1)} + {1'b0, (r_par1[51] ^ 1'b0)};
    wire [8:0] cand_51_1_1 = pm_50_0 + {7'b0, bm_51_1_from_0};
    wire [8:0] cand_51_1_2 = pm_50_2 + {7'b0, bm_51_1_from_2};
    wire sel_51_1 = (cand_51_1_1 > cand_51_1_2); // 1 if cand2 better
    wire [8:0] pm_51_1 = sel_51_1 ? cand_51_1_2 : cand_51_1_1;
    wire surv_51_1 = sel_51_1;
    wire [1:0] bm_51_2_from_1 = {1'b0, (r_sys[51] ^ 1'b0)} + {1'b0, (r_par1[51] ^ 1'b1)};
    wire [1:0] bm_51_2_from_3 = {1'b0, (r_sys[51] ^ 1'b0)} + {1'b0, (r_par1[51] ^ 1'b0)};
    wire [8:0] cand_51_2_1 = pm_50_1 + {7'b0, bm_51_2_from_1};
    wire [8:0] cand_51_2_2 = pm_50_3 + {7'b0, bm_51_2_from_3};
    wire sel_51_2 = (cand_51_2_1 > cand_51_2_2); // 1 if cand2 better
    wire [8:0] pm_51_2 = sel_51_2 ? cand_51_2_2 : cand_51_2_1;
    wire surv_51_2 = sel_51_2;
    wire [1:0] bm_51_3_from_1 = {1'b0, (r_sys[51] ^ 1'b1)} + {1'b0, (r_par1[51] ^ 1'b0)};
    wire [1:0] bm_51_3_from_3 = {1'b0, (r_sys[51] ^ 1'b1)} + {1'b0, (r_par1[51] ^ 1'b1)};
    wire [8:0] cand_51_3_1 = pm_50_1 + {7'b0, bm_51_3_from_1};
    wire [8:0] cand_51_3_2 = pm_50_3 + {7'b0, bm_51_3_from_3};
    wire sel_51_3 = (cand_51_3_1 > cand_51_3_2); // 1 if cand2 better
    wire [8:0] pm_51_3 = sel_51_3 ? cand_51_3_2 : cand_51_3_1;
    wire surv_51_3 = sel_51_3;
    // Stage 52
    wire [1:0] bm_52_0_from_0 = {1'b0, (r_sys[52] ^ 1'b0)} + {1'b0, (r_par1[52] ^ 1'b0)};
    wire [1:0] bm_52_0_from_2 = {1'b0, (r_sys[52] ^ 1'b0)} + {1'b0, (r_par1[52] ^ 1'b1)};
    wire [8:0] cand_52_0_1 = pm_51_0 + {7'b0, bm_52_0_from_0};
    wire [8:0] cand_52_0_2 = pm_51_2 + {7'b0, bm_52_0_from_2};
    wire sel_52_0 = (cand_52_0_1 > cand_52_0_2); // 1 if cand2 better
    wire [8:0] pm_52_0 = sel_52_0 ? cand_52_0_2 : cand_52_0_1;
    wire surv_52_0 = sel_52_0;
    wire [1:0] bm_52_1_from_0 = {1'b0, (r_sys[52] ^ 1'b1)} + {1'b0, (r_par1[52] ^ 1'b1)};
    wire [1:0] bm_52_1_from_2 = {1'b0, (r_sys[52] ^ 1'b1)} + {1'b0, (r_par1[52] ^ 1'b0)};
    wire [8:0] cand_52_1_1 = pm_51_0 + {7'b0, bm_52_1_from_0};
    wire [8:0] cand_52_1_2 = pm_51_2 + {7'b0, bm_52_1_from_2};
    wire sel_52_1 = (cand_52_1_1 > cand_52_1_2); // 1 if cand2 better
    wire [8:0] pm_52_1 = sel_52_1 ? cand_52_1_2 : cand_52_1_1;
    wire surv_52_1 = sel_52_1;
    wire [1:0] bm_52_2_from_1 = {1'b0, (r_sys[52] ^ 1'b0)} + {1'b0, (r_par1[52] ^ 1'b1)};
    wire [1:0] bm_52_2_from_3 = {1'b0, (r_sys[52] ^ 1'b0)} + {1'b0, (r_par1[52] ^ 1'b0)};
    wire [8:0] cand_52_2_1 = pm_51_1 + {7'b0, bm_52_2_from_1};
    wire [8:0] cand_52_2_2 = pm_51_3 + {7'b0, bm_52_2_from_3};
    wire sel_52_2 = (cand_52_2_1 > cand_52_2_2); // 1 if cand2 better
    wire [8:0] pm_52_2 = sel_52_2 ? cand_52_2_2 : cand_52_2_1;
    wire surv_52_2 = sel_52_2;
    wire [1:0] bm_52_3_from_1 = {1'b0, (r_sys[52] ^ 1'b1)} + {1'b0, (r_par1[52] ^ 1'b0)};
    wire [1:0] bm_52_3_from_3 = {1'b0, (r_sys[52] ^ 1'b1)} + {1'b0, (r_par1[52] ^ 1'b1)};
    wire [8:0] cand_52_3_1 = pm_51_1 + {7'b0, bm_52_3_from_1};
    wire [8:0] cand_52_3_2 = pm_51_3 + {7'b0, bm_52_3_from_3};
    wire sel_52_3 = (cand_52_3_1 > cand_52_3_2); // 1 if cand2 better
    wire [8:0] pm_52_3 = sel_52_3 ? cand_52_3_2 : cand_52_3_1;
    wire surv_52_3 = sel_52_3;
    // Stage 53
    wire [1:0] bm_53_0_from_0 = {1'b0, (r_sys[53] ^ 1'b0)} + {1'b0, (r_par1[53] ^ 1'b0)};
    wire [1:0] bm_53_0_from_2 = {1'b0, (r_sys[53] ^ 1'b0)} + {1'b0, (r_par1[53] ^ 1'b1)};
    wire [8:0] cand_53_0_1 = pm_52_0 + {7'b0, bm_53_0_from_0};
    wire [8:0] cand_53_0_2 = pm_52_2 + {7'b0, bm_53_0_from_2};
    wire sel_53_0 = (cand_53_0_1 > cand_53_0_2); // 1 if cand2 better
    wire [8:0] pm_53_0 = sel_53_0 ? cand_53_0_2 : cand_53_0_1;
    wire surv_53_0 = sel_53_0;
    wire [1:0] bm_53_1_from_0 = {1'b0, (r_sys[53] ^ 1'b1)} + {1'b0, (r_par1[53] ^ 1'b1)};
    wire [1:0] bm_53_1_from_2 = {1'b0, (r_sys[53] ^ 1'b1)} + {1'b0, (r_par1[53] ^ 1'b0)};
    wire [8:0] cand_53_1_1 = pm_52_0 + {7'b0, bm_53_1_from_0};
    wire [8:0] cand_53_1_2 = pm_52_2 + {7'b0, bm_53_1_from_2};
    wire sel_53_1 = (cand_53_1_1 > cand_53_1_2); // 1 if cand2 better
    wire [8:0] pm_53_1 = sel_53_1 ? cand_53_1_2 : cand_53_1_1;
    wire surv_53_1 = sel_53_1;
    wire [1:0] bm_53_2_from_1 = {1'b0, (r_sys[53] ^ 1'b0)} + {1'b0, (r_par1[53] ^ 1'b1)};
    wire [1:0] bm_53_2_from_3 = {1'b0, (r_sys[53] ^ 1'b0)} + {1'b0, (r_par1[53] ^ 1'b0)};
    wire [8:0] cand_53_2_1 = pm_52_1 + {7'b0, bm_53_2_from_1};
    wire [8:0] cand_53_2_2 = pm_52_3 + {7'b0, bm_53_2_from_3};
    wire sel_53_2 = (cand_53_2_1 > cand_53_2_2); // 1 if cand2 better
    wire [8:0] pm_53_2 = sel_53_2 ? cand_53_2_2 : cand_53_2_1;
    wire surv_53_2 = sel_53_2;
    wire [1:0] bm_53_3_from_1 = {1'b0, (r_sys[53] ^ 1'b1)} + {1'b0, (r_par1[53] ^ 1'b0)};
    wire [1:0] bm_53_3_from_3 = {1'b0, (r_sys[53] ^ 1'b1)} + {1'b0, (r_par1[53] ^ 1'b1)};
    wire [8:0] cand_53_3_1 = pm_52_1 + {7'b0, bm_53_3_from_1};
    wire [8:0] cand_53_3_2 = pm_52_3 + {7'b0, bm_53_3_from_3};
    wire sel_53_3 = (cand_53_3_1 > cand_53_3_2); // 1 if cand2 better
    wire [8:0] pm_53_3 = sel_53_3 ? cand_53_3_2 : cand_53_3_1;
    wire surv_53_3 = sel_53_3;
    // Stage 54
    wire [1:0] bm_54_0_from_0 = {1'b0, (r_sys[54] ^ 1'b0)} + {1'b0, (r_par1[54] ^ 1'b0)};
    wire [1:0] bm_54_0_from_2 = {1'b0, (r_sys[54] ^ 1'b0)} + {1'b0, (r_par1[54] ^ 1'b1)};
    wire [8:0] cand_54_0_1 = pm_53_0 + {7'b0, bm_54_0_from_0};
    wire [8:0] cand_54_0_2 = pm_53_2 + {7'b0, bm_54_0_from_2};
    wire sel_54_0 = (cand_54_0_1 > cand_54_0_2); // 1 if cand2 better
    wire [8:0] pm_54_0 = sel_54_0 ? cand_54_0_2 : cand_54_0_1;
    wire surv_54_0 = sel_54_0;
    wire [1:0] bm_54_1_from_0 = {1'b0, (r_sys[54] ^ 1'b1)} + {1'b0, (r_par1[54] ^ 1'b1)};
    wire [1:0] bm_54_1_from_2 = {1'b0, (r_sys[54] ^ 1'b1)} + {1'b0, (r_par1[54] ^ 1'b0)};
    wire [8:0] cand_54_1_1 = pm_53_0 + {7'b0, bm_54_1_from_0};
    wire [8:0] cand_54_1_2 = pm_53_2 + {7'b0, bm_54_1_from_2};
    wire sel_54_1 = (cand_54_1_1 > cand_54_1_2); // 1 if cand2 better
    wire [8:0] pm_54_1 = sel_54_1 ? cand_54_1_2 : cand_54_1_1;
    wire surv_54_1 = sel_54_1;
    wire [1:0] bm_54_2_from_1 = {1'b0, (r_sys[54] ^ 1'b0)} + {1'b0, (r_par1[54] ^ 1'b1)};
    wire [1:0] bm_54_2_from_3 = {1'b0, (r_sys[54] ^ 1'b0)} + {1'b0, (r_par1[54] ^ 1'b0)};
    wire [8:0] cand_54_2_1 = pm_53_1 + {7'b0, bm_54_2_from_1};
    wire [8:0] cand_54_2_2 = pm_53_3 + {7'b0, bm_54_2_from_3};
    wire sel_54_2 = (cand_54_2_1 > cand_54_2_2); // 1 if cand2 better
    wire [8:0] pm_54_2 = sel_54_2 ? cand_54_2_2 : cand_54_2_1;
    wire surv_54_2 = sel_54_2;
    wire [1:0] bm_54_3_from_1 = {1'b0, (r_sys[54] ^ 1'b1)} + {1'b0, (r_par1[54] ^ 1'b0)};
    wire [1:0] bm_54_3_from_3 = {1'b0, (r_sys[54] ^ 1'b1)} + {1'b0, (r_par1[54] ^ 1'b1)};
    wire [8:0] cand_54_3_1 = pm_53_1 + {7'b0, bm_54_3_from_1};
    wire [8:0] cand_54_3_2 = pm_53_3 + {7'b0, bm_54_3_from_3};
    wire sel_54_3 = (cand_54_3_1 > cand_54_3_2); // 1 if cand2 better
    wire [8:0] pm_54_3 = sel_54_3 ? cand_54_3_2 : cand_54_3_1;
    wire surv_54_3 = sel_54_3;
    // Stage 55
    wire [1:0] bm_55_0_from_0 = {1'b0, (r_sys[55] ^ 1'b0)} + {1'b0, (r_par1[55] ^ 1'b0)};
    wire [1:0] bm_55_0_from_2 = {1'b0, (r_sys[55] ^ 1'b0)} + {1'b0, (r_par1[55] ^ 1'b1)};
    wire [8:0] cand_55_0_1 = pm_54_0 + {7'b0, bm_55_0_from_0};
    wire [8:0] cand_55_0_2 = pm_54_2 + {7'b0, bm_55_0_from_2};
    wire sel_55_0 = (cand_55_0_1 > cand_55_0_2); // 1 if cand2 better
    wire [8:0] pm_55_0 = sel_55_0 ? cand_55_0_2 : cand_55_0_1;
    wire surv_55_0 = sel_55_0;
    wire [1:0] bm_55_1_from_0 = {1'b0, (r_sys[55] ^ 1'b1)} + {1'b0, (r_par1[55] ^ 1'b1)};
    wire [1:0] bm_55_1_from_2 = {1'b0, (r_sys[55] ^ 1'b1)} + {1'b0, (r_par1[55] ^ 1'b0)};
    wire [8:0] cand_55_1_1 = pm_54_0 + {7'b0, bm_55_1_from_0};
    wire [8:0] cand_55_1_2 = pm_54_2 + {7'b0, bm_55_1_from_2};
    wire sel_55_1 = (cand_55_1_1 > cand_55_1_2); // 1 if cand2 better
    wire [8:0] pm_55_1 = sel_55_1 ? cand_55_1_2 : cand_55_1_1;
    wire surv_55_1 = sel_55_1;
    wire [1:0] bm_55_2_from_1 = {1'b0, (r_sys[55] ^ 1'b0)} + {1'b0, (r_par1[55] ^ 1'b1)};
    wire [1:0] bm_55_2_from_3 = {1'b0, (r_sys[55] ^ 1'b0)} + {1'b0, (r_par1[55] ^ 1'b0)};
    wire [8:0] cand_55_2_1 = pm_54_1 + {7'b0, bm_55_2_from_1};
    wire [8:0] cand_55_2_2 = pm_54_3 + {7'b0, bm_55_2_from_3};
    wire sel_55_2 = (cand_55_2_1 > cand_55_2_2); // 1 if cand2 better
    wire [8:0] pm_55_2 = sel_55_2 ? cand_55_2_2 : cand_55_2_1;
    wire surv_55_2 = sel_55_2;
    wire [1:0] bm_55_3_from_1 = {1'b0, (r_sys[55] ^ 1'b1)} + {1'b0, (r_par1[55] ^ 1'b0)};
    wire [1:0] bm_55_3_from_3 = {1'b0, (r_sys[55] ^ 1'b1)} + {1'b0, (r_par1[55] ^ 1'b1)};
    wire [8:0] cand_55_3_1 = pm_54_1 + {7'b0, bm_55_3_from_1};
    wire [8:0] cand_55_3_2 = pm_54_3 + {7'b0, bm_55_3_from_3};
    wire sel_55_3 = (cand_55_3_1 > cand_55_3_2); // 1 if cand2 better
    wire [8:0] pm_55_3 = sel_55_3 ? cand_55_3_2 : cand_55_3_1;
    wire surv_55_3 = sel_55_3;
    // Stage 56
    wire [1:0] bm_56_0_from_0 = {1'b0, (r_sys[56] ^ 1'b0)} + {1'b0, (r_par1[56] ^ 1'b0)};
    wire [1:0] bm_56_0_from_2 = {1'b0, (r_sys[56] ^ 1'b0)} + {1'b0, (r_par1[56] ^ 1'b1)};
    wire [8:0] cand_56_0_1 = pm_55_0 + {7'b0, bm_56_0_from_0};
    wire [8:0] cand_56_0_2 = pm_55_2 + {7'b0, bm_56_0_from_2};
    wire sel_56_0 = (cand_56_0_1 > cand_56_0_2); // 1 if cand2 better
    wire [8:0] pm_56_0 = sel_56_0 ? cand_56_0_2 : cand_56_0_1;
    wire surv_56_0 = sel_56_0;
    wire [1:0] bm_56_1_from_0 = {1'b0, (r_sys[56] ^ 1'b1)} + {1'b0, (r_par1[56] ^ 1'b1)};
    wire [1:0] bm_56_1_from_2 = {1'b0, (r_sys[56] ^ 1'b1)} + {1'b0, (r_par1[56] ^ 1'b0)};
    wire [8:0] cand_56_1_1 = pm_55_0 + {7'b0, bm_56_1_from_0};
    wire [8:0] cand_56_1_2 = pm_55_2 + {7'b0, bm_56_1_from_2};
    wire sel_56_1 = (cand_56_1_1 > cand_56_1_2); // 1 if cand2 better
    wire [8:0] pm_56_1 = sel_56_1 ? cand_56_1_2 : cand_56_1_1;
    wire surv_56_1 = sel_56_1;
    wire [1:0] bm_56_2_from_1 = {1'b0, (r_sys[56] ^ 1'b0)} + {1'b0, (r_par1[56] ^ 1'b1)};
    wire [1:0] bm_56_2_from_3 = {1'b0, (r_sys[56] ^ 1'b0)} + {1'b0, (r_par1[56] ^ 1'b0)};
    wire [8:0] cand_56_2_1 = pm_55_1 + {7'b0, bm_56_2_from_1};
    wire [8:0] cand_56_2_2 = pm_55_3 + {7'b0, bm_56_2_from_3};
    wire sel_56_2 = (cand_56_2_1 > cand_56_2_2); // 1 if cand2 better
    wire [8:0] pm_56_2 = sel_56_2 ? cand_56_2_2 : cand_56_2_1;
    wire surv_56_2 = sel_56_2;
    wire [1:0] bm_56_3_from_1 = {1'b0, (r_sys[56] ^ 1'b1)} + {1'b0, (r_par1[56] ^ 1'b0)};
    wire [1:0] bm_56_3_from_3 = {1'b0, (r_sys[56] ^ 1'b1)} + {1'b0, (r_par1[56] ^ 1'b1)};
    wire [8:0] cand_56_3_1 = pm_55_1 + {7'b0, bm_56_3_from_1};
    wire [8:0] cand_56_3_2 = pm_55_3 + {7'b0, bm_56_3_from_3};
    wire sel_56_3 = (cand_56_3_1 > cand_56_3_2); // 1 if cand2 better
    wire [8:0] pm_56_3 = sel_56_3 ? cand_56_3_2 : cand_56_3_1;
    wire surv_56_3 = sel_56_3;
    // Stage 57
    wire [1:0] bm_57_0_from_0 = {1'b0, (r_sys[57] ^ 1'b0)} + {1'b0, (r_par1[57] ^ 1'b0)};
    wire [1:0] bm_57_0_from_2 = {1'b0, (r_sys[57] ^ 1'b0)} + {1'b0, (r_par1[57] ^ 1'b1)};
    wire [8:0] cand_57_0_1 = pm_56_0 + {7'b0, bm_57_0_from_0};
    wire [8:0] cand_57_0_2 = pm_56_2 + {7'b0, bm_57_0_from_2};
    wire sel_57_0 = (cand_57_0_1 > cand_57_0_2); // 1 if cand2 better
    wire [8:0] pm_57_0 = sel_57_0 ? cand_57_0_2 : cand_57_0_1;
    wire surv_57_0 = sel_57_0;
    wire [1:0] bm_57_1_from_0 = {1'b0, (r_sys[57] ^ 1'b1)} + {1'b0, (r_par1[57] ^ 1'b1)};
    wire [1:0] bm_57_1_from_2 = {1'b0, (r_sys[57] ^ 1'b1)} + {1'b0, (r_par1[57] ^ 1'b0)};
    wire [8:0] cand_57_1_1 = pm_56_0 + {7'b0, bm_57_1_from_0};
    wire [8:0] cand_57_1_2 = pm_56_2 + {7'b0, bm_57_1_from_2};
    wire sel_57_1 = (cand_57_1_1 > cand_57_1_2); // 1 if cand2 better
    wire [8:0] pm_57_1 = sel_57_1 ? cand_57_1_2 : cand_57_1_1;
    wire surv_57_1 = sel_57_1;
    wire [1:0] bm_57_2_from_1 = {1'b0, (r_sys[57] ^ 1'b0)} + {1'b0, (r_par1[57] ^ 1'b1)};
    wire [1:0] bm_57_2_from_3 = {1'b0, (r_sys[57] ^ 1'b0)} + {1'b0, (r_par1[57] ^ 1'b0)};
    wire [8:0] cand_57_2_1 = pm_56_1 + {7'b0, bm_57_2_from_1};
    wire [8:0] cand_57_2_2 = pm_56_3 + {7'b0, bm_57_2_from_3};
    wire sel_57_2 = (cand_57_2_1 > cand_57_2_2); // 1 if cand2 better
    wire [8:0] pm_57_2 = sel_57_2 ? cand_57_2_2 : cand_57_2_1;
    wire surv_57_2 = sel_57_2;
    wire [1:0] bm_57_3_from_1 = {1'b0, (r_sys[57] ^ 1'b1)} + {1'b0, (r_par1[57] ^ 1'b0)};
    wire [1:0] bm_57_3_from_3 = {1'b0, (r_sys[57] ^ 1'b1)} + {1'b0, (r_par1[57] ^ 1'b1)};
    wire [8:0] cand_57_3_1 = pm_56_1 + {7'b0, bm_57_3_from_1};
    wire [8:0] cand_57_3_2 = pm_56_3 + {7'b0, bm_57_3_from_3};
    wire sel_57_3 = (cand_57_3_1 > cand_57_3_2); // 1 if cand2 better
    wire [8:0] pm_57_3 = sel_57_3 ? cand_57_3_2 : cand_57_3_1;
    wire surv_57_3 = sel_57_3;
    // Stage 58
    wire [1:0] bm_58_0_from_0 = {1'b0, (r_sys[58] ^ 1'b0)} + {1'b0, (r_par1[58] ^ 1'b0)};
    wire [1:0] bm_58_0_from_2 = {1'b0, (r_sys[58] ^ 1'b0)} + {1'b0, (r_par1[58] ^ 1'b1)};
    wire [8:0] cand_58_0_1 = pm_57_0 + {7'b0, bm_58_0_from_0};
    wire [8:0] cand_58_0_2 = pm_57_2 + {7'b0, bm_58_0_from_2};
    wire sel_58_0 = (cand_58_0_1 > cand_58_0_2); // 1 if cand2 better
    wire [8:0] pm_58_0 = sel_58_0 ? cand_58_0_2 : cand_58_0_1;
    wire surv_58_0 = sel_58_0;
    wire [1:0] bm_58_1_from_0 = {1'b0, (r_sys[58] ^ 1'b1)} + {1'b0, (r_par1[58] ^ 1'b1)};
    wire [1:0] bm_58_1_from_2 = {1'b0, (r_sys[58] ^ 1'b1)} + {1'b0, (r_par1[58] ^ 1'b0)};
    wire [8:0] cand_58_1_1 = pm_57_0 + {7'b0, bm_58_1_from_0};
    wire [8:0] cand_58_1_2 = pm_57_2 + {7'b0, bm_58_1_from_2};
    wire sel_58_1 = (cand_58_1_1 > cand_58_1_2); // 1 if cand2 better
    wire [8:0] pm_58_1 = sel_58_1 ? cand_58_1_2 : cand_58_1_1;
    wire surv_58_1 = sel_58_1;
    wire [1:0] bm_58_2_from_1 = {1'b0, (r_sys[58] ^ 1'b0)} + {1'b0, (r_par1[58] ^ 1'b1)};
    wire [1:0] bm_58_2_from_3 = {1'b0, (r_sys[58] ^ 1'b0)} + {1'b0, (r_par1[58] ^ 1'b0)};
    wire [8:0] cand_58_2_1 = pm_57_1 + {7'b0, bm_58_2_from_1};
    wire [8:0] cand_58_2_2 = pm_57_3 + {7'b0, bm_58_2_from_3};
    wire sel_58_2 = (cand_58_2_1 > cand_58_2_2); // 1 if cand2 better
    wire [8:0] pm_58_2 = sel_58_2 ? cand_58_2_2 : cand_58_2_1;
    wire surv_58_2 = sel_58_2;
    wire [1:0] bm_58_3_from_1 = {1'b0, (r_sys[58] ^ 1'b1)} + {1'b0, (r_par1[58] ^ 1'b0)};
    wire [1:0] bm_58_3_from_3 = {1'b0, (r_sys[58] ^ 1'b1)} + {1'b0, (r_par1[58] ^ 1'b1)};
    wire [8:0] cand_58_3_1 = pm_57_1 + {7'b0, bm_58_3_from_1};
    wire [8:0] cand_58_3_2 = pm_57_3 + {7'b0, bm_58_3_from_3};
    wire sel_58_3 = (cand_58_3_1 > cand_58_3_2); // 1 if cand2 better
    wire [8:0] pm_58_3 = sel_58_3 ? cand_58_3_2 : cand_58_3_1;
    wire surv_58_3 = sel_58_3;
    // Stage 59
    wire [1:0] bm_59_0_from_0 = {1'b0, (r_sys[59] ^ 1'b0)} + {1'b0, (r_par1[59] ^ 1'b0)};
    wire [1:0] bm_59_0_from_2 = {1'b0, (r_sys[59] ^ 1'b0)} + {1'b0, (r_par1[59] ^ 1'b1)};
    wire [8:0] cand_59_0_1 = pm_58_0 + {7'b0, bm_59_0_from_0};
    wire [8:0] cand_59_0_2 = pm_58_2 + {7'b0, bm_59_0_from_2};
    wire sel_59_0 = (cand_59_0_1 > cand_59_0_2); // 1 if cand2 better
    wire [8:0] pm_59_0 = sel_59_0 ? cand_59_0_2 : cand_59_0_1;
    wire surv_59_0 = sel_59_0;
    wire [1:0] bm_59_1_from_0 = {1'b0, (r_sys[59] ^ 1'b1)} + {1'b0, (r_par1[59] ^ 1'b1)};
    wire [1:0] bm_59_1_from_2 = {1'b0, (r_sys[59] ^ 1'b1)} + {1'b0, (r_par1[59] ^ 1'b0)};
    wire [8:0] cand_59_1_1 = pm_58_0 + {7'b0, bm_59_1_from_0};
    wire [8:0] cand_59_1_2 = pm_58_2 + {7'b0, bm_59_1_from_2};
    wire sel_59_1 = (cand_59_1_1 > cand_59_1_2); // 1 if cand2 better
    wire [8:0] pm_59_1 = sel_59_1 ? cand_59_1_2 : cand_59_1_1;
    wire surv_59_1 = sel_59_1;
    wire [1:0] bm_59_2_from_1 = {1'b0, (r_sys[59] ^ 1'b0)} + {1'b0, (r_par1[59] ^ 1'b1)};
    wire [1:0] bm_59_2_from_3 = {1'b0, (r_sys[59] ^ 1'b0)} + {1'b0, (r_par1[59] ^ 1'b0)};
    wire [8:0] cand_59_2_1 = pm_58_1 + {7'b0, bm_59_2_from_1};
    wire [8:0] cand_59_2_2 = pm_58_3 + {7'b0, bm_59_2_from_3};
    wire sel_59_2 = (cand_59_2_1 > cand_59_2_2); // 1 if cand2 better
    wire [8:0] pm_59_2 = sel_59_2 ? cand_59_2_2 : cand_59_2_1;
    wire surv_59_2 = sel_59_2;
    wire [1:0] bm_59_3_from_1 = {1'b0, (r_sys[59] ^ 1'b1)} + {1'b0, (r_par1[59] ^ 1'b0)};
    wire [1:0] bm_59_3_from_3 = {1'b0, (r_sys[59] ^ 1'b1)} + {1'b0, (r_par1[59] ^ 1'b1)};
    wire [8:0] cand_59_3_1 = pm_58_1 + {7'b0, bm_59_3_from_1};
    wire [8:0] cand_59_3_2 = pm_58_3 + {7'b0, bm_59_3_from_3};
    wire sel_59_3 = (cand_59_3_1 > cand_59_3_2); // 1 if cand2 better
    wire [8:0] pm_59_3 = sel_59_3 ? cand_59_3_2 : cand_59_3_1;
    wire surv_59_3 = sel_59_3;
    // Stage 60
    wire [1:0] bm_60_0_from_0 = {1'b0, (r_sys[60] ^ 1'b0)} + {1'b0, (r_par1[60] ^ 1'b0)};
    wire [1:0] bm_60_0_from_2 = {1'b0, (r_sys[60] ^ 1'b0)} + {1'b0, (r_par1[60] ^ 1'b1)};
    wire [8:0] cand_60_0_1 = pm_59_0 + {7'b0, bm_60_0_from_0};
    wire [8:0] cand_60_0_2 = pm_59_2 + {7'b0, bm_60_0_from_2};
    wire sel_60_0 = (cand_60_0_1 > cand_60_0_2); // 1 if cand2 better
    wire [8:0] pm_60_0 = sel_60_0 ? cand_60_0_2 : cand_60_0_1;
    wire surv_60_0 = sel_60_0;
    wire [1:0] bm_60_1_from_0 = {1'b0, (r_sys[60] ^ 1'b1)} + {1'b0, (r_par1[60] ^ 1'b1)};
    wire [1:0] bm_60_1_from_2 = {1'b0, (r_sys[60] ^ 1'b1)} + {1'b0, (r_par1[60] ^ 1'b0)};
    wire [8:0] cand_60_1_1 = pm_59_0 + {7'b0, bm_60_1_from_0};
    wire [8:0] cand_60_1_2 = pm_59_2 + {7'b0, bm_60_1_from_2};
    wire sel_60_1 = (cand_60_1_1 > cand_60_1_2); // 1 if cand2 better
    wire [8:0] pm_60_1 = sel_60_1 ? cand_60_1_2 : cand_60_1_1;
    wire surv_60_1 = sel_60_1;
    wire [1:0] bm_60_2_from_1 = {1'b0, (r_sys[60] ^ 1'b0)} + {1'b0, (r_par1[60] ^ 1'b1)};
    wire [1:0] bm_60_2_from_3 = {1'b0, (r_sys[60] ^ 1'b0)} + {1'b0, (r_par1[60] ^ 1'b0)};
    wire [8:0] cand_60_2_1 = pm_59_1 + {7'b0, bm_60_2_from_1};
    wire [8:0] cand_60_2_2 = pm_59_3 + {7'b0, bm_60_2_from_3};
    wire sel_60_2 = (cand_60_2_1 > cand_60_2_2); // 1 if cand2 better
    wire [8:0] pm_60_2 = sel_60_2 ? cand_60_2_2 : cand_60_2_1;
    wire surv_60_2 = sel_60_2;
    wire [1:0] bm_60_3_from_1 = {1'b0, (r_sys[60] ^ 1'b1)} + {1'b0, (r_par1[60] ^ 1'b0)};
    wire [1:0] bm_60_3_from_3 = {1'b0, (r_sys[60] ^ 1'b1)} + {1'b0, (r_par1[60] ^ 1'b1)};
    wire [8:0] cand_60_3_1 = pm_59_1 + {7'b0, bm_60_3_from_1};
    wire [8:0] cand_60_3_2 = pm_59_3 + {7'b0, bm_60_3_from_3};
    wire sel_60_3 = (cand_60_3_1 > cand_60_3_2); // 1 if cand2 better
    wire [8:0] pm_60_3 = sel_60_3 ? cand_60_3_2 : cand_60_3_1;
    wire surv_60_3 = sel_60_3;
    // Stage 61
    wire [1:0] bm_61_0_from_0 = {1'b0, (r_sys[61] ^ 1'b0)} + {1'b0, (r_par1[61] ^ 1'b0)};
    wire [1:0] bm_61_0_from_2 = {1'b0, (r_sys[61] ^ 1'b0)} + {1'b0, (r_par1[61] ^ 1'b1)};
    wire [8:0] cand_61_0_1 = pm_60_0 + {7'b0, bm_61_0_from_0};
    wire [8:0] cand_61_0_2 = pm_60_2 + {7'b0, bm_61_0_from_2};
    wire sel_61_0 = (cand_61_0_1 > cand_61_0_2); // 1 if cand2 better
    wire [8:0] pm_61_0 = sel_61_0 ? cand_61_0_2 : cand_61_0_1;
    wire surv_61_0 = sel_61_0;
    wire [1:0] bm_61_1_from_0 = {1'b0, (r_sys[61] ^ 1'b1)} + {1'b0, (r_par1[61] ^ 1'b1)};
    wire [1:0] bm_61_1_from_2 = {1'b0, (r_sys[61] ^ 1'b1)} + {1'b0, (r_par1[61] ^ 1'b0)};
    wire [8:0] cand_61_1_1 = pm_60_0 + {7'b0, bm_61_1_from_0};
    wire [8:0] cand_61_1_2 = pm_60_2 + {7'b0, bm_61_1_from_2};
    wire sel_61_1 = (cand_61_1_1 > cand_61_1_2); // 1 if cand2 better
    wire [8:0] pm_61_1 = sel_61_1 ? cand_61_1_2 : cand_61_1_1;
    wire surv_61_1 = sel_61_1;
    wire [1:0] bm_61_2_from_1 = {1'b0, (r_sys[61] ^ 1'b0)} + {1'b0, (r_par1[61] ^ 1'b1)};
    wire [1:0] bm_61_2_from_3 = {1'b0, (r_sys[61] ^ 1'b0)} + {1'b0, (r_par1[61] ^ 1'b0)};
    wire [8:0] cand_61_2_1 = pm_60_1 + {7'b0, bm_61_2_from_1};
    wire [8:0] cand_61_2_2 = pm_60_3 + {7'b0, bm_61_2_from_3};
    wire sel_61_2 = (cand_61_2_1 > cand_61_2_2); // 1 if cand2 better
    wire [8:0] pm_61_2 = sel_61_2 ? cand_61_2_2 : cand_61_2_1;
    wire surv_61_2 = sel_61_2;
    wire [1:0] bm_61_3_from_1 = {1'b0, (r_sys[61] ^ 1'b1)} + {1'b0, (r_par1[61] ^ 1'b0)};
    wire [1:0] bm_61_3_from_3 = {1'b0, (r_sys[61] ^ 1'b1)} + {1'b0, (r_par1[61] ^ 1'b1)};
    wire [8:0] cand_61_3_1 = pm_60_1 + {7'b0, bm_61_3_from_1};
    wire [8:0] cand_61_3_2 = pm_60_3 + {7'b0, bm_61_3_from_3};
    wire sel_61_3 = (cand_61_3_1 > cand_61_3_2); // 1 if cand2 better
    wire [8:0] pm_61_3 = sel_61_3 ? cand_61_3_2 : cand_61_3_1;
    wire surv_61_3 = sel_61_3;
    // Stage 62
    wire [1:0] bm_62_0_from_0 = {1'b0, (r_sys[62] ^ 1'b0)} + {1'b0, (r_par1[62] ^ 1'b0)};
    wire [1:0] bm_62_0_from_2 = {1'b0, (r_sys[62] ^ 1'b0)} + {1'b0, (r_par1[62] ^ 1'b1)};
    wire [8:0] cand_62_0_1 = pm_61_0 + {7'b0, bm_62_0_from_0};
    wire [8:0] cand_62_0_2 = pm_61_2 + {7'b0, bm_62_0_from_2};
    wire sel_62_0 = (cand_62_0_1 > cand_62_0_2); // 1 if cand2 better
    wire [8:0] pm_62_0 = sel_62_0 ? cand_62_0_2 : cand_62_0_1;
    wire surv_62_0 = sel_62_0;
    wire [1:0] bm_62_1_from_0 = {1'b0, (r_sys[62] ^ 1'b1)} + {1'b0, (r_par1[62] ^ 1'b1)};
    wire [1:0] bm_62_1_from_2 = {1'b0, (r_sys[62] ^ 1'b1)} + {1'b0, (r_par1[62] ^ 1'b0)};
    wire [8:0] cand_62_1_1 = pm_61_0 + {7'b0, bm_62_1_from_0};
    wire [8:0] cand_62_1_2 = pm_61_2 + {7'b0, bm_62_1_from_2};
    wire sel_62_1 = (cand_62_1_1 > cand_62_1_2); // 1 if cand2 better
    wire [8:0] pm_62_1 = sel_62_1 ? cand_62_1_2 : cand_62_1_1;
    wire surv_62_1 = sel_62_1;
    wire [1:0] bm_62_2_from_1 = {1'b0, (r_sys[62] ^ 1'b0)} + {1'b0, (r_par1[62] ^ 1'b1)};
    wire [1:0] bm_62_2_from_3 = {1'b0, (r_sys[62] ^ 1'b0)} + {1'b0, (r_par1[62] ^ 1'b0)};
    wire [8:0] cand_62_2_1 = pm_61_1 + {7'b0, bm_62_2_from_1};
    wire [8:0] cand_62_2_2 = pm_61_3 + {7'b0, bm_62_2_from_3};
    wire sel_62_2 = (cand_62_2_1 > cand_62_2_2); // 1 if cand2 better
    wire [8:0] pm_62_2 = sel_62_2 ? cand_62_2_2 : cand_62_2_1;
    wire surv_62_2 = sel_62_2;
    wire [1:0] bm_62_3_from_1 = {1'b0, (r_sys[62] ^ 1'b1)} + {1'b0, (r_par1[62] ^ 1'b0)};
    wire [1:0] bm_62_3_from_3 = {1'b0, (r_sys[62] ^ 1'b1)} + {1'b0, (r_par1[62] ^ 1'b1)};
    wire [8:0] cand_62_3_1 = pm_61_1 + {7'b0, bm_62_3_from_1};
    wire [8:0] cand_62_3_2 = pm_61_3 + {7'b0, bm_62_3_from_3};
    wire sel_62_3 = (cand_62_3_1 > cand_62_3_2); // 1 if cand2 better
    wire [8:0] pm_62_3 = sel_62_3 ? cand_62_3_2 : cand_62_3_1;
    wire surv_62_3 = sel_62_3;
    // Stage 63
    wire [1:0] bm_63_0_from_0 = {1'b0, (r_sys[63] ^ 1'b0)} + {1'b0, (r_par1[63] ^ 1'b0)};
    wire [1:0] bm_63_0_from_2 = {1'b0, (r_sys[63] ^ 1'b0)} + {1'b0, (r_par1[63] ^ 1'b1)};
    wire [8:0] cand_63_0_1 = pm_62_0 + {7'b0, bm_63_0_from_0};
    wire [8:0] cand_63_0_2 = pm_62_2 + {7'b0, bm_63_0_from_2};
    wire sel_63_0 = (cand_63_0_1 > cand_63_0_2); // 1 if cand2 better
    wire [8:0] pm_63_0 = sel_63_0 ? cand_63_0_2 : cand_63_0_1;
    wire surv_63_0 = sel_63_0;
    wire [1:0] bm_63_1_from_0 = {1'b0, (r_sys[63] ^ 1'b1)} + {1'b0, (r_par1[63] ^ 1'b1)};
    wire [1:0] bm_63_1_from_2 = {1'b0, (r_sys[63] ^ 1'b1)} + {1'b0, (r_par1[63] ^ 1'b0)};
    wire [8:0] cand_63_1_1 = pm_62_0 + {7'b0, bm_63_1_from_0};
    wire [8:0] cand_63_1_2 = pm_62_2 + {7'b0, bm_63_1_from_2};
    wire sel_63_1 = (cand_63_1_1 > cand_63_1_2); // 1 if cand2 better
    wire [8:0] pm_63_1 = sel_63_1 ? cand_63_1_2 : cand_63_1_1;
    wire surv_63_1 = sel_63_1;
    wire [1:0] bm_63_2_from_1 = {1'b0, (r_sys[63] ^ 1'b0)} + {1'b0, (r_par1[63] ^ 1'b1)};
    wire [1:0] bm_63_2_from_3 = {1'b0, (r_sys[63] ^ 1'b0)} + {1'b0, (r_par1[63] ^ 1'b0)};
    wire [8:0] cand_63_2_1 = pm_62_1 + {7'b0, bm_63_2_from_1};
    wire [8:0] cand_63_2_2 = pm_62_3 + {7'b0, bm_63_2_from_3};
    wire sel_63_2 = (cand_63_2_1 > cand_63_2_2); // 1 if cand2 better
    wire [8:0] pm_63_2 = sel_63_2 ? cand_63_2_2 : cand_63_2_1;
    wire surv_63_2 = sel_63_2;
    wire [1:0] bm_63_3_from_1 = {1'b0, (r_sys[63] ^ 1'b1)} + {1'b0, (r_par1[63] ^ 1'b0)};
    wire [1:0] bm_63_3_from_3 = {1'b0, (r_sys[63] ^ 1'b1)} + {1'b0, (r_par1[63] ^ 1'b1)};
    wire [8:0] cand_63_3_1 = pm_62_1 + {7'b0, bm_63_3_from_1};
    wire [8:0] cand_63_3_2 = pm_62_3 + {7'b0, bm_63_3_from_3};
    wire sel_63_3 = (cand_63_3_1 > cand_63_3_2); // 1 if cand2 better
    wire [8:0] pm_63_3 = sel_63_3 ? cand_63_3_2 : cand_63_3_1;
    wire surv_63_3 = sel_63_3;
    // Stage 64
    wire [1:0] bm_64_0_from_0 = {1'b0, (r_sys[64] ^ 1'b0)} + {1'b0, (r_par1[64] ^ 1'b0)};
    wire [1:0] bm_64_0_from_2 = {1'b0, (r_sys[64] ^ 1'b0)} + {1'b0, (r_par1[64] ^ 1'b1)};
    wire [8:0] cand_64_0_1 = pm_63_0 + {7'b0, bm_64_0_from_0};
    wire [8:0] cand_64_0_2 = pm_63_2 + {7'b0, bm_64_0_from_2};
    wire sel_64_0 = (cand_64_0_1 > cand_64_0_2); // 1 if cand2 better
    wire [8:0] pm_64_0 = sel_64_0 ? cand_64_0_2 : cand_64_0_1;
    wire surv_64_0 = sel_64_0;
    wire [1:0] bm_64_1_from_0 = {1'b0, (r_sys[64] ^ 1'b1)} + {1'b0, (r_par1[64] ^ 1'b1)};
    wire [1:0] bm_64_1_from_2 = {1'b0, (r_sys[64] ^ 1'b1)} + {1'b0, (r_par1[64] ^ 1'b0)};
    wire [8:0] cand_64_1_1 = pm_63_0 + {7'b0, bm_64_1_from_0};
    wire [8:0] cand_64_1_2 = pm_63_2 + {7'b0, bm_64_1_from_2};
    wire sel_64_1 = (cand_64_1_1 > cand_64_1_2); // 1 if cand2 better
    wire [8:0] pm_64_1 = sel_64_1 ? cand_64_1_2 : cand_64_1_1;
    wire surv_64_1 = sel_64_1;
    wire [1:0] bm_64_2_from_1 = {1'b0, (r_sys[64] ^ 1'b0)} + {1'b0, (r_par1[64] ^ 1'b1)};
    wire [1:0] bm_64_2_from_3 = {1'b0, (r_sys[64] ^ 1'b0)} + {1'b0, (r_par1[64] ^ 1'b0)};
    wire [8:0] cand_64_2_1 = pm_63_1 + {7'b0, bm_64_2_from_1};
    wire [8:0] cand_64_2_2 = pm_63_3 + {7'b0, bm_64_2_from_3};
    wire sel_64_2 = (cand_64_2_1 > cand_64_2_2); // 1 if cand2 better
    wire [8:0] pm_64_2 = sel_64_2 ? cand_64_2_2 : cand_64_2_1;
    wire surv_64_2 = sel_64_2;
    wire [1:0] bm_64_3_from_1 = {1'b0, (r_sys[64] ^ 1'b1)} + {1'b0, (r_par1[64] ^ 1'b0)};
    wire [1:0] bm_64_3_from_3 = {1'b0, (r_sys[64] ^ 1'b1)} + {1'b0, (r_par1[64] ^ 1'b1)};
    wire [8:0] cand_64_3_1 = pm_63_1 + {7'b0, bm_64_3_from_1};
    wire [8:0] cand_64_3_2 = pm_63_3 + {7'b0, bm_64_3_from_3};
    wire sel_64_3 = (cand_64_3_1 > cand_64_3_2); // 1 if cand2 better
    wire [8:0] pm_64_3 = sel_64_3 ? cand_64_3_2 : cand_64_3_1;
    wire surv_64_3 = sel_64_3;
    // Stage 65
    wire [1:0] bm_65_0_from_0 = {1'b0, (r_sys[65] ^ 1'b0)} + {1'b0, (r_par1[65] ^ 1'b0)};
    wire [1:0] bm_65_0_from_2 = {1'b0, (r_sys[65] ^ 1'b0)} + {1'b0, (r_par1[65] ^ 1'b1)};
    wire [8:0] cand_65_0_1 = pm_64_0 + {7'b0, bm_65_0_from_0};
    wire [8:0] cand_65_0_2 = pm_64_2 + {7'b0, bm_65_0_from_2};
    wire sel_65_0 = (cand_65_0_1 > cand_65_0_2); // 1 if cand2 better
    wire [8:0] pm_65_0 = sel_65_0 ? cand_65_0_2 : cand_65_0_1;
    wire surv_65_0 = sel_65_0;
    wire [1:0] bm_65_1_from_0 = {1'b0, (r_sys[65] ^ 1'b1)} + {1'b0, (r_par1[65] ^ 1'b1)};
    wire [1:0] bm_65_1_from_2 = {1'b0, (r_sys[65] ^ 1'b1)} + {1'b0, (r_par1[65] ^ 1'b0)};
    wire [8:0] cand_65_1_1 = pm_64_0 + {7'b0, bm_65_1_from_0};
    wire [8:0] cand_65_1_2 = pm_64_2 + {7'b0, bm_65_1_from_2};
    wire sel_65_1 = (cand_65_1_1 > cand_65_1_2); // 1 if cand2 better
    wire [8:0] pm_65_1 = sel_65_1 ? cand_65_1_2 : cand_65_1_1;
    wire surv_65_1 = sel_65_1;
    wire [1:0] bm_65_2_from_1 = {1'b0, (r_sys[65] ^ 1'b0)} + {1'b0, (r_par1[65] ^ 1'b1)};
    wire [1:0] bm_65_2_from_3 = {1'b0, (r_sys[65] ^ 1'b0)} + {1'b0, (r_par1[65] ^ 1'b0)};
    wire [8:0] cand_65_2_1 = pm_64_1 + {7'b0, bm_65_2_from_1};
    wire [8:0] cand_65_2_2 = pm_64_3 + {7'b0, bm_65_2_from_3};
    wire sel_65_2 = (cand_65_2_1 > cand_65_2_2); // 1 if cand2 better
    wire [8:0] pm_65_2 = sel_65_2 ? cand_65_2_2 : cand_65_2_1;
    wire surv_65_2 = sel_65_2;
    wire [1:0] bm_65_3_from_1 = {1'b0, (r_sys[65] ^ 1'b1)} + {1'b0, (r_par1[65] ^ 1'b0)};
    wire [1:0] bm_65_3_from_3 = {1'b0, (r_sys[65] ^ 1'b1)} + {1'b0, (r_par1[65] ^ 1'b1)};
    wire [8:0] cand_65_3_1 = pm_64_1 + {7'b0, bm_65_3_from_1};
    wire [8:0] cand_65_3_2 = pm_64_3 + {7'b0, bm_65_3_from_3};
    wire sel_65_3 = (cand_65_3_1 > cand_65_3_2); // 1 if cand2 better
    wire [8:0] pm_65_3 = sel_65_3 ? cand_65_3_2 : cand_65_3_1;
    wire surv_65_3 = sel_65_3;
    // Stage 66
    wire [1:0] bm_66_0_from_0 = {1'b0, (r_sys[66] ^ 1'b0)} + {1'b0, (r_par1[66] ^ 1'b0)};
    wire [1:0] bm_66_0_from_2 = {1'b0, (r_sys[66] ^ 1'b0)} + {1'b0, (r_par1[66] ^ 1'b1)};
    wire [8:0] cand_66_0_1 = pm_65_0 + {7'b0, bm_66_0_from_0};
    wire [8:0] cand_66_0_2 = pm_65_2 + {7'b0, bm_66_0_from_2};
    wire sel_66_0 = (cand_66_0_1 > cand_66_0_2); // 1 if cand2 better
    wire [8:0] pm_66_0 = sel_66_0 ? cand_66_0_2 : cand_66_0_1;
    wire surv_66_0 = sel_66_0;
    wire [1:0] bm_66_1_from_0 = {1'b0, (r_sys[66] ^ 1'b1)} + {1'b0, (r_par1[66] ^ 1'b1)};
    wire [1:0] bm_66_1_from_2 = {1'b0, (r_sys[66] ^ 1'b1)} + {1'b0, (r_par1[66] ^ 1'b0)};
    wire [8:0] cand_66_1_1 = pm_65_0 + {7'b0, bm_66_1_from_0};
    wire [8:0] cand_66_1_2 = pm_65_2 + {7'b0, bm_66_1_from_2};
    wire sel_66_1 = (cand_66_1_1 > cand_66_1_2); // 1 if cand2 better
    wire [8:0] pm_66_1 = sel_66_1 ? cand_66_1_2 : cand_66_1_1;
    wire surv_66_1 = sel_66_1;
    wire [1:0] bm_66_2_from_1 = {1'b0, (r_sys[66] ^ 1'b0)} + {1'b0, (r_par1[66] ^ 1'b1)};
    wire [1:0] bm_66_2_from_3 = {1'b0, (r_sys[66] ^ 1'b0)} + {1'b0, (r_par1[66] ^ 1'b0)};
    wire [8:0] cand_66_2_1 = pm_65_1 + {7'b0, bm_66_2_from_1};
    wire [8:0] cand_66_2_2 = pm_65_3 + {7'b0, bm_66_2_from_3};
    wire sel_66_2 = (cand_66_2_1 > cand_66_2_2); // 1 if cand2 better
    wire [8:0] pm_66_2 = sel_66_2 ? cand_66_2_2 : cand_66_2_1;
    wire surv_66_2 = sel_66_2;
    wire [1:0] bm_66_3_from_1 = {1'b0, (r_sys[66] ^ 1'b1)} + {1'b0, (r_par1[66] ^ 1'b0)};
    wire [1:0] bm_66_3_from_3 = {1'b0, (r_sys[66] ^ 1'b1)} + {1'b0, (r_par1[66] ^ 1'b1)};
    wire [8:0] cand_66_3_1 = pm_65_1 + {7'b0, bm_66_3_from_1};
    wire [8:0] cand_66_3_2 = pm_65_3 + {7'b0, bm_66_3_from_3};
    wire sel_66_3 = (cand_66_3_1 > cand_66_3_2); // 1 if cand2 better
    wire [8:0] pm_66_3 = sel_66_3 ? cand_66_3_2 : cand_66_3_1;
    wire surv_66_3 = sel_66_3;
    // Stage 67
    wire [1:0] bm_67_0_from_0 = {1'b0, (r_sys[67] ^ 1'b0)} + {1'b0, (r_par1[67] ^ 1'b0)};
    wire [1:0] bm_67_0_from_2 = {1'b0, (r_sys[67] ^ 1'b0)} + {1'b0, (r_par1[67] ^ 1'b1)};
    wire [8:0] cand_67_0_1 = pm_66_0 + {7'b0, bm_67_0_from_0};
    wire [8:0] cand_67_0_2 = pm_66_2 + {7'b0, bm_67_0_from_2};
    wire sel_67_0 = (cand_67_0_1 > cand_67_0_2); // 1 if cand2 better
    wire [8:0] pm_67_0 = sel_67_0 ? cand_67_0_2 : cand_67_0_1;
    wire surv_67_0 = sel_67_0;
    wire [1:0] bm_67_1_from_0 = {1'b0, (r_sys[67] ^ 1'b1)} + {1'b0, (r_par1[67] ^ 1'b1)};
    wire [1:0] bm_67_1_from_2 = {1'b0, (r_sys[67] ^ 1'b1)} + {1'b0, (r_par1[67] ^ 1'b0)};
    wire [8:0] cand_67_1_1 = pm_66_0 + {7'b0, bm_67_1_from_0};
    wire [8:0] cand_67_1_2 = pm_66_2 + {7'b0, bm_67_1_from_2};
    wire sel_67_1 = (cand_67_1_1 > cand_67_1_2); // 1 if cand2 better
    wire [8:0] pm_67_1 = sel_67_1 ? cand_67_1_2 : cand_67_1_1;
    wire surv_67_1 = sel_67_1;
    wire [1:0] bm_67_2_from_1 = {1'b0, (r_sys[67] ^ 1'b0)} + {1'b0, (r_par1[67] ^ 1'b1)};
    wire [1:0] bm_67_2_from_3 = {1'b0, (r_sys[67] ^ 1'b0)} + {1'b0, (r_par1[67] ^ 1'b0)};
    wire [8:0] cand_67_2_1 = pm_66_1 + {7'b0, bm_67_2_from_1};
    wire [8:0] cand_67_2_2 = pm_66_3 + {7'b0, bm_67_2_from_3};
    wire sel_67_2 = (cand_67_2_1 > cand_67_2_2); // 1 if cand2 better
    wire [8:0] pm_67_2 = sel_67_2 ? cand_67_2_2 : cand_67_2_1;
    wire surv_67_2 = sel_67_2;
    wire [1:0] bm_67_3_from_1 = {1'b0, (r_sys[67] ^ 1'b1)} + {1'b0, (r_par1[67] ^ 1'b0)};
    wire [1:0] bm_67_3_from_3 = {1'b0, (r_sys[67] ^ 1'b1)} + {1'b0, (r_par1[67] ^ 1'b1)};
    wire [8:0] cand_67_3_1 = pm_66_1 + {7'b0, bm_67_3_from_1};
    wire [8:0] cand_67_3_2 = pm_66_3 + {7'b0, bm_67_3_from_3};
    wire sel_67_3 = (cand_67_3_1 > cand_67_3_2); // 1 if cand2 better
    wire [8:0] pm_67_3 = sel_67_3 ? cand_67_3_2 : cand_67_3_1;
    wire surv_67_3 = sel_67_3;
    // Stage 68
    wire [1:0] bm_68_0_from_0 = {1'b0, (r_sys[68] ^ 1'b0)} + {1'b0, (r_par1[68] ^ 1'b0)};
    wire [1:0] bm_68_0_from_2 = {1'b0, (r_sys[68] ^ 1'b0)} + {1'b0, (r_par1[68] ^ 1'b1)};
    wire [8:0] cand_68_0_1 = pm_67_0 + {7'b0, bm_68_0_from_0};
    wire [8:0] cand_68_0_2 = pm_67_2 + {7'b0, bm_68_0_from_2};
    wire sel_68_0 = (cand_68_0_1 > cand_68_0_2); // 1 if cand2 better
    wire [8:0] pm_68_0 = sel_68_0 ? cand_68_0_2 : cand_68_0_1;
    wire surv_68_0 = sel_68_0;
    wire [1:0] bm_68_1_from_0 = {1'b0, (r_sys[68] ^ 1'b1)} + {1'b0, (r_par1[68] ^ 1'b1)};
    wire [1:0] bm_68_1_from_2 = {1'b0, (r_sys[68] ^ 1'b1)} + {1'b0, (r_par1[68] ^ 1'b0)};
    wire [8:0] cand_68_1_1 = pm_67_0 + {7'b0, bm_68_1_from_0};
    wire [8:0] cand_68_1_2 = pm_67_2 + {7'b0, bm_68_1_from_2};
    wire sel_68_1 = (cand_68_1_1 > cand_68_1_2); // 1 if cand2 better
    wire [8:0] pm_68_1 = sel_68_1 ? cand_68_1_2 : cand_68_1_1;
    wire surv_68_1 = sel_68_1;
    wire [1:0] bm_68_2_from_1 = {1'b0, (r_sys[68] ^ 1'b0)} + {1'b0, (r_par1[68] ^ 1'b1)};
    wire [1:0] bm_68_2_from_3 = {1'b0, (r_sys[68] ^ 1'b0)} + {1'b0, (r_par1[68] ^ 1'b0)};
    wire [8:0] cand_68_2_1 = pm_67_1 + {7'b0, bm_68_2_from_1};
    wire [8:0] cand_68_2_2 = pm_67_3 + {7'b0, bm_68_2_from_3};
    wire sel_68_2 = (cand_68_2_1 > cand_68_2_2); // 1 if cand2 better
    wire [8:0] pm_68_2 = sel_68_2 ? cand_68_2_2 : cand_68_2_1;
    wire surv_68_2 = sel_68_2;
    wire [1:0] bm_68_3_from_1 = {1'b0, (r_sys[68] ^ 1'b1)} + {1'b0, (r_par1[68] ^ 1'b0)};
    wire [1:0] bm_68_3_from_3 = {1'b0, (r_sys[68] ^ 1'b1)} + {1'b0, (r_par1[68] ^ 1'b1)};
    wire [8:0] cand_68_3_1 = pm_67_1 + {7'b0, bm_68_3_from_1};
    wire [8:0] cand_68_3_2 = pm_67_3 + {7'b0, bm_68_3_from_3};
    wire sel_68_3 = (cand_68_3_1 > cand_68_3_2); // 1 if cand2 better
    wire [8:0] pm_68_3 = sel_68_3 ? cand_68_3_2 : cand_68_3_1;
    wire surv_68_3 = sel_68_3;
    // Stage 69
    wire [1:0] bm_69_0_from_0 = {1'b0, (r_sys[69] ^ 1'b0)} + {1'b0, (r_par1[69] ^ 1'b0)};
    wire [1:0] bm_69_0_from_2 = {1'b0, (r_sys[69] ^ 1'b0)} + {1'b0, (r_par1[69] ^ 1'b1)};
    wire [8:0] cand_69_0_1 = pm_68_0 + {7'b0, bm_69_0_from_0};
    wire [8:0] cand_69_0_2 = pm_68_2 + {7'b0, bm_69_0_from_2};
    wire sel_69_0 = (cand_69_0_1 > cand_69_0_2); // 1 if cand2 better
    wire [8:0] pm_69_0 = sel_69_0 ? cand_69_0_2 : cand_69_0_1;
    wire surv_69_0 = sel_69_0;
    wire [1:0] bm_69_1_from_0 = {1'b0, (r_sys[69] ^ 1'b1)} + {1'b0, (r_par1[69] ^ 1'b1)};
    wire [1:0] bm_69_1_from_2 = {1'b0, (r_sys[69] ^ 1'b1)} + {1'b0, (r_par1[69] ^ 1'b0)};
    wire [8:0] cand_69_1_1 = pm_68_0 + {7'b0, bm_69_1_from_0};
    wire [8:0] cand_69_1_2 = pm_68_2 + {7'b0, bm_69_1_from_2};
    wire sel_69_1 = (cand_69_1_1 > cand_69_1_2); // 1 if cand2 better
    wire [8:0] pm_69_1 = sel_69_1 ? cand_69_1_2 : cand_69_1_1;
    wire surv_69_1 = sel_69_1;
    wire [1:0] bm_69_2_from_1 = {1'b0, (r_sys[69] ^ 1'b0)} + {1'b0, (r_par1[69] ^ 1'b1)};
    wire [1:0] bm_69_2_from_3 = {1'b0, (r_sys[69] ^ 1'b0)} + {1'b0, (r_par1[69] ^ 1'b0)};
    wire [8:0] cand_69_2_1 = pm_68_1 + {7'b0, bm_69_2_from_1};
    wire [8:0] cand_69_2_2 = pm_68_3 + {7'b0, bm_69_2_from_3};
    wire sel_69_2 = (cand_69_2_1 > cand_69_2_2); // 1 if cand2 better
    wire [8:0] pm_69_2 = sel_69_2 ? cand_69_2_2 : cand_69_2_1;
    wire surv_69_2 = sel_69_2;
    wire [1:0] bm_69_3_from_1 = {1'b0, (r_sys[69] ^ 1'b1)} + {1'b0, (r_par1[69] ^ 1'b0)};
    wire [1:0] bm_69_3_from_3 = {1'b0, (r_sys[69] ^ 1'b1)} + {1'b0, (r_par1[69] ^ 1'b1)};
    wire [8:0] cand_69_3_1 = pm_68_1 + {7'b0, bm_69_3_from_1};
    wire [8:0] cand_69_3_2 = pm_68_3 + {7'b0, bm_69_3_from_3};
    wire sel_69_3 = (cand_69_3_1 > cand_69_3_2); // 1 if cand2 better
    wire [8:0] pm_69_3 = sel_69_3 ? cand_69_3_2 : cand_69_3_1;
    wire surv_69_3 = sel_69_3;
    // Stage 70
    wire [1:0] bm_70_0_from_0 = {1'b0, (r_sys[70] ^ 1'b0)} + {1'b0, (r_par1[70] ^ 1'b0)};
    wire [1:0] bm_70_0_from_2 = {1'b0, (r_sys[70] ^ 1'b0)} + {1'b0, (r_par1[70] ^ 1'b1)};
    wire [8:0] cand_70_0_1 = pm_69_0 + {7'b0, bm_70_0_from_0};
    wire [8:0] cand_70_0_2 = pm_69_2 + {7'b0, bm_70_0_from_2};
    wire sel_70_0 = (cand_70_0_1 > cand_70_0_2); // 1 if cand2 better
    wire [8:0] pm_70_0 = sel_70_0 ? cand_70_0_2 : cand_70_0_1;
    wire surv_70_0 = sel_70_0;
    wire [1:0] bm_70_1_from_0 = {1'b0, (r_sys[70] ^ 1'b1)} + {1'b0, (r_par1[70] ^ 1'b1)};
    wire [1:0] bm_70_1_from_2 = {1'b0, (r_sys[70] ^ 1'b1)} + {1'b0, (r_par1[70] ^ 1'b0)};
    wire [8:0] cand_70_1_1 = pm_69_0 + {7'b0, bm_70_1_from_0};
    wire [8:0] cand_70_1_2 = pm_69_2 + {7'b0, bm_70_1_from_2};
    wire sel_70_1 = (cand_70_1_1 > cand_70_1_2); // 1 if cand2 better
    wire [8:0] pm_70_1 = sel_70_1 ? cand_70_1_2 : cand_70_1_1;
    wire surv_70_1 = sel_70_1;
    wire [1:0] bm_70_2_from_1 = {1'b0, (r_sys[70] ^ 1'b0)} + {1'b0, (r_par1[70] ^ 1'b1)};
    wire [1:0] bm_70_2_from_3 = {1'b0, (r_sys[70] ^ 1'b0)} + {1'b0, (r_par1[70] ^ 1'b0)};
    wire [8:0] cand_70_2_1 = pm_69_1 + {7'b0, bm_70_2_from_1};
    wire [8:0] cand_70_2_2 = pm_69_3 + {7'b0, bm_70_2_from_3};
    wire sel_70_2 = (cand_70_2_1 > cand_70_2_2); // 1 if cand2 better
    wire [8:0] pm_70_2 = sel_70_2 ? cand_70_2_2 : cand_70_2_1;
    wire surv_70_2 = sel_70_2;
    wire [1:0] bm_70_3_from_1 = {1'b0, (r_sys[70] ^ 1'b1)} + {1'b0, (r_par1[70] ^ 1'b0)};
    wire [1:0] bm_70_3_from_3 = {1'b0, (r_sys[70] ^ 1'b1)} + {1'b0, (r_par1[70] ^ 1'b1)};
    wire [8:0] cand_70_3_1 = pm_69_1 + {7'b0, bm_70_3_from_1};
    wire [8:0] cand_70_3_2 = pm_69_3 + {7'b0, bm_70_3_from_3};
    wire sel_70_3 = (cand_70_3_1 > cand_70_3_2); // 1 if cand2 better
    wire [8:0] pm_70_3 = sel_70_3 ? cand_70_3_2 : cand_70_3_1;
    wire surv_70_3 = sel_70_3;
    // Stage 71
    wire [1:0] bm_71_0_from_0 = {1'b0, (r_sys[71] ^ 1'b0)} + {1'b0, (r_par1[71] ^ 1'b0)};
    wire [1:0] bm_71_0_from_2 = {1'b0, (r_sys[71] ^ 1'b0)} + {1'b0, (r_par1[71] ^ 1'b1)};
    wire [8:0] cand_71_0_1 = pm_70_0 + {7'b0, bm_71_0_from_0};
    wire [8:0] cand_71_0_2 = pm_70_2 + {7'b0, bm_71_0_from_2};
    wire sel_71_0 = (cand_71_0_1 > cand_71_0_2); // 1 if cand2 better
    wire [8:0] pm_71_0 = sel_71_0 ? cand_71_0_2 : cand_71_0_1;
    wire surv_71_0 = sel_71_0;
    wire [1:0] bm_71_1_from_0 = {1'b0, (r_sys[71] ^ 1'b1)} + {1'b0, (r_par1[71] ^ 1'b1)};
    wire [1:0] bm_71_1_from_2 = {1'b0, (r_sys[71] ^ 1'b1)} + {1'b0, (r_par1[71] ^ 1'b0)};
    wire [8:0] cand_71_1_1 = pm_70_0 + {7'b0, bm_71_1_from_0};
    wire [8:0] cand_71_1_2 = pm_70_2 + {7'b0, bm_71_1_from_2};
    wire sel_71_1 = (cand_71_1_1 > cand_71_1_2); // 1 if cand2 better
    wire [8:0] pm_71_1 = sel_71_1 ? cand_71_1_2 : cand_71_1_1;
    wire surv_71_1 = sel_71_1;
    wire [1:0] bm_71_2_from_1 = {1'b0, (r_sys[71] ^ 1'b0)} + {1'b0, (r_par1[71] ^ 1'b1)};
    wire [1:0] bm_71_2_from_3 = {1'b0, (r_sys[71] ^ 1'b0)} + {1'b0, (r_par1[71] ^ 1'b0)};
    wire [8:0] cand_71_2_1 = pm_70_1 + {7'b0, bm_71_2_from_1};
    wire [8:0] cand_71_2_2 = pm_70_3 + {7'b0, bm_71_2_from_3};
    wire sel_71_2 = (cand_71_2_1 > cand_71_2_2); // 1 if cand2 better
    wire [8:0] pm_71_2 = sel_71_2 ? cand_71_2_2 : cand_71_2_1;
    wire surv_71_2 = sel_71_2;
    wire [1:0] bm_71_3_from_1 = {1'b0, (r_sys[71] ^ 1'b1)} + {1'b0, (r_par1[71] ^ 1'b0)};
    wire [1:0] bm_71_3_from_3 = {1'b0, (r_sys[71] ^ 1'b1)} + {1'b0, (r_par1[71] ^ 1'b1)};
    wire [8:0] cand_71_3_1 = pm_70_1 + {7'b0, bm_71_3_from_1};
    wire [8:0] cand_71_3_2 = pm_70_3 + {7'b0, bm_71_3_from_3};
    wire sel_71_3 = (cand_71_3_1 > cand_71_3_2); // 1 if cand2 better
    wire [8:0] pm_71_3 = sel_71_3 ? cand_71_3_2 : cand_71_3_1;
    wire surv_71_3 = sel_71_3;
    // Stage 72
    wire [1:0] bm_72_0_from_0 = {1'b0, (r_sys[72] ^ 1'b0)} + {1'b0, (r_par1[72] ^ 1'b0)};
    wire [1:0] bm_72_0_from_2 = {1'b0, (r_sys[72] ^ 1'b0)} + {1'b0, (r_par1[72] ^ 1'b1)};
    wire [8:0] cand_72_0_1 = pm_71_0 + {7'b0, bm_72_0_from_0};
    wire [8:0] cand_72_0_2 = pm_71_2 + {7'b0, bm_72_0_from_2};
    wire sel_72_0 = (cand_72_0_1 > cand_72_0_2); // 1 if cand2 better
    wire [8:0] pm_72_0 = sel_72_0 ? cand_72_0_2 : cand_72_0_1;
    wire surv_72_0 = sel_72_0;
    wire [1:0] bm_72_1_from_0 = {1'b0, (r_sys[72] ^ 1'b1)} + {1'b0, (r_par1[72] ^ 1'b1)};
    wire [1:0] bm_72_1_from_2 = {1'b0, (r_sys[72] ^ 1'b1)} + {1'b0, (r_par1[72] ^ 1'b0)};
    wire [8:0] cand_72_1_1 = pm_71_0 + {7'b0, bm_72_1_from_0};
    wire [8:0] cand_72_1_2 = pm_71_2 + {7'b0, bm_72_1_from_2};
    wire sel_72_1 = (cand_72_1_1 > cand_72_1_2); // 1 if cand2 better
    wire [8:0] pm_72_1 = sel_72_1 ? cand_72_1_2 : cand_72_1_1;
    wire surv_72_1 = sel_72_1;
    wire [1:0] bm_72_2_from_1 = {1'b0, (r_sys[72] ^ 1'b0)} + {1'b0, (r_par1[72] ^ 1'b1)};
    wire [1:0] bm_72_2_from_3 = {1'b0, (r_sys[72] ^ 1'b0)} + {1'b0, (r_par1[72] ^ 1'b0)};
    wire [8:0] cand_72_2_1 = pm_71_1 + {7'b0, bm_72_2_from_1};
    wire [8:0] cand_72_2_2 = pm_71_3 + {7'b0, bm_72_2_from_3};
    wire sel_72_2 = (cand_72_2_1 > cand_72_2_2); // 1 if cand2 better
    wire [8:0] pm_72_2 = sel_72_2 ? cand_72_2_2 : cand_72_2_1;
    wire surv_72_2 = sel_72_2;
    wire [1:0] bm_72_3_from_1 = {1'b0, (r_sys[72] ^ 1'b1)} + {1'b0, (r_par1[72] ^ 1'b0)};
    wire [1:0] bm_72_3_from_3 = {1'b0, (r_sys[72] ^ 1'b1)} + {1'b0, (r_par1[72] ^ 1'b1)};
    wire [8:0] cand_72_3_1 = pm_71_1 + {7'b0, bm_72_3_from_1};
    wire [8:0] cand_72_3_2 = pm_71_3 + {7'b0, bm_72_3_from_3};
    wire sel_72_3 = (cand_72_3_1 > cand_72_3_2); // 1 if cand2 better
    wire [8:0] pm_72_3 = sel_72_3 ? cand_72_3_2 : cand_72_3_1;
    wire surv_72_3 = sel_72_3;
    // Stage 73
    wire [1:0] bm_73_0_from_0 = {1'b0, (r_sys[73] ^ 1'b0)} + {1'b0, (r_par1[73] ^ 1'b0)};
    wire [1:0] bm_73_0_from_2 = {1'b0, (r_sys[73] ^ 1'b0)} + {1'b0, (r_par1[73] ^ 1'b1)};
    wire [8:0] cand_73_0_1 = pm_72_0 + {7'b0, bm_73_0_from_0};
    wire [8:0] cand_73_0_2 = pm_72_2 + {7'b0, bm_73_0_from_2};
    wire sel_73_0 = (cand_73_0_1 > cand_73_0_2); // 1 if cand2 better
    wire [8:0] pm_73_0 = sel_73_0 ? cand_73_0_2 : cand_73_0_1;
    wire surv_73_0 = sel_73_0;
    wire [1:0] bm_73_1_from_0 = {1'b0, (r_sys[73] ^ 1'b1)} + {1'b0, (r_par1[73] ^ 1'b1)};
    wire [1:0] bm_73_1_from_2 = {1'b0, (r_sys[73] ^ 1'b1)} + {1'b0, (r_par1[73] ^ 1'b0)};
    wire [8:0] cand_73_1_1 = pm_72_0 + {7'b0, bm_73_1_from_0};
    wire [8:0] cand_73_1_2 = pm_72_2 + {7'b0, bm_73_1_from_2};
    wire sel_73_1 = (cand_73_1_1 > cand_73_1_2); // 1 if cand2 better
    wire [8:0] pm_73_1 = sel_73_1 ? cand_73_1_2 : cand_73_1_1;
    wire surv_73_1 = sel_73_1;
    wire [1:0] bm_73_2_from_1 = {1'b0, (r_sys[73] ^ 1'b0)} + {1'b0, (r_par1[73] ^ 1'b1)};
    wire [1:0] bm_73_2_from_3 = {1'b0, (r_sys[73] ^ 1'b0)} + {1'b0, (r_par1[73] ^ 1'b0)};
    wire [8:0] cand_73_2_1 = pm_72_1 + {7'b0, bm_73_2_from_1};
    wire [8:0] cand_73_2_2 = pm_72_3 + {7'b0, bm_73_2_from_3};
    wire sel_73_2 = (cand_73_2_1 > cand_73_2_2); // 1 if cand2 better
    wire [8:0] pm_73_2 = sel_73_2 ? cand_73_2_2 : cand_73_2_1;
    wire surv_73_2 = sel_73_2;
    wire [1:0] bm_73_3_from_1 = {1'b0, (r_sys[73] ^ 1'b1)} + {1'b0, (r_par1[73] ^ 1'b0)};
    wire [1:0] bm_73_3_from_3 = {1'b0, (r_sys[73] ^ 1'b1)} + {1'b0, (r_par1[73] ^ 1'b1)};
    wire [8:0] cand_73_3_1 = pm_72_1 + {7'b0, bm_73_3_from_1};
    wire [8:0] cand_73_3_2 = pm_72_3 + {7'b0, bm_73_3_from_3};
    wire sel_73_3 = (cand_73_3_1 > cand_73_3_2); // 1 if cand2 better
    wire [8:0] pm_73_3 = sel_73_3 ? cand_73_3_2 : cand_73_3_1;
    wire surv_73_3 = sel_73_3;
    // Stage 74
    wire [1:0] bm_74_0_from_0 = {1'b0, (r_sys[74] ^ 1'b0)} + {1'b0, (r_par1[74] ^ 1'b0)};
    wire [1:0] bm_74_0_from_2 = {1'b0, (r_sys[74] ^ 1'b0)} + {1'b0, (r_par1[74] ^ 1'b1)};
    wire [8:0] cand_74_0_1 = pm_73_0 + {7'b0, bm_74_0_from_0};
    wire [8:0] cand_74_0_2 = pm_73_2 + {7'b0, bm_74_0_from_2};
    wire sel_74_0 = (cand_74_0_1 > cand_74_0_2); // 1 if cand2 better
    wire [8:0] pm_74_0 = sel_74_0 ? cand_74_0_2 : cand_74_0_1;
    wire surv_74_0 = sel_74_0;
    wire [1:0] bm_74_1_from_0 = {1'b0, (r_sys[74] ^ 1'b1)} + {1'b0, (r_par1[74] ^ 1'b1)};
    wire [1:0] bm_74_1_from_2 = {1'b0, (r_sys[74] ^ 1'b1)} + {1'b0, (r_par1[74] ^ 1'b0)};
    wire [8:0] cand_74_1_1 = pm_73_0 + {7'b0, bm_74_1_from_0};
    wire [8:0] cand_74_1_2 = pm_73_2 + {7'b0, bm_74_1_from_2};
    wire sel_74_1 = (cand_74_1_1 > cand_74_1_2); // 1 if cand2 better
    wire [8:0] pm_74_1 = sel_74_1 ? cand_74_1_2 : cand_74_1_1;
    wire surv_74_1 = sel_74_1;
    wire [1:0] bm_74_2_from_1 = {1'b0, (r_sys[74] ^ 1'b0)} + {1'b0, (r_par1[74] ^ 1'b1)};
    wire [1:0] bm_74_2_from_3 = {1'b0, (r_sys[74] ^ 1'b0)} + {1'b0, (r_par1[74] ^ 1'b0)};
    wire [8:0] cand_74_2_1 = pm_73_1 + {7'b0, bm_74_2_from_1};
    wire [8:0] cand_74_2_2 = pm_73_3 + {7'b0, bm_74_2_from_3};
    wire sel_74_2 = (cand_74_2_1 > cand_74_2_2); // 1 if cand2 better
    wire [8:0] pm_74_2 = sel_74_2 ? cand_74_2_2 : cand_74_2_1;
    wire surv_74_2 = sel_74_2;
    wire [1:0] bm_74_3_from_1 = {1'b0, (r_sys[74] ^ 1'b1)} + {1'b0, (r_par1[74] ^ 1'b0)};
    wire [1:0] bm_74_3_from_3 = {1'b0, (r_sys[74] ^ 1'b1)} + {1'b0, (r_par1[74] ^ 1'b1)};
    wire [8:0] cand_74_3_1 = pm_73_1 + {7'b0, bm_74_3_from_1};
    wire [8:0] cand_74_3_2 = pm_73_3 + {7'b0, bm_74_3_from_3};
    wire sel_74_3 = (cand_74_3_1 > cand_74_3_2); // 1 if cand2 better
    wire [8:0] pm_74_3 = sel_74_3 ? cand_74_3_2 : cand_74_3_1;
    wire surv_74_3 = sel_74_3;
    // Stage 75
    wire [1:0] bm_75_0_from_0 = {1'b0, (r_sys[75] ^ 1'b0)} + {1'b0, (r_par1[75] ^ 1'b0)};
    wire [1:0] bm_75_0_from_2 = {1'b0, (r_sys[75] ^ 1'b0)} + {1'b0, (r_par1[75] ^ 1'b1)};
    wire [8:0] cand_75_0_1 = pm_74_0 + {7'b0, bm_75_0_from_0};
    wire [8:0] cand_75_0_2 = pm_74_2 + {7'b0, bm_75_0_from_2};
    wire sel_75_0 = (cand_75_0_1 > cand_75_0_2); // 1 if cand2 better
    wire [8:0] pm_75_0 = sel_75_0 ? cand_75_0_2 : cand_75_0_1;
    wire surv_75_0 = sel_75_0;
    wire [1:0] bm_75_1_from_0 = {1'b0, (r_sys[75] ^ 1'b1)} + {1'b0, (r_par1[75] ^ 1'b1)};
    wire [1:0] bm_75_1_from_2 = {1'b0, (r_sys[75] ^ 1'b1)} + {1'b0, (r_par1[75] ^ 1'b0)};
    wire [8:0] cand_75_1_1 = pm_74_0 + {7'b0, bm_75_1_from_0};
    wire [8:0] cand_75_1_2 = pm_74_2 + {7'b0, bm_75_1_from_2};
    wire sel_75_1 = (cand_75_1_1 > cand_75_1_2); // 1 if cand2 better
    wire [8:0] pm_75_1 = sel_75_1 ? cand_75_1_2 : cand_75_1_1;
    wire surv_75_1 = sel_75_1;
    wire [1:0] bm_75_2_from_1 = {1'b0, (r_sys[75] ^ 1'b0)} + {1'b0, (r_par1[75] ^ 1'b1)};
    wire [1:0] bm_75_2_from_3 = {1'b0, (r_sys[75] ^ 1'b0)} + {1'b0, (r_par1[75] ^ 1'b0)};
    wire [8:0] cand_75_2_1 = pm_74_1 + {7'b0, bm_75_2_from_1};
    wire [8:0] cand_75_2_2 = pm_74_3 + {7'b0, bm_75_2_from_3};
    wire sel_75_2 = (cand_75_2_1 > cand_75_2_2); // 1 if cand2 better
    wire [8:0] pm_75_2 = sel_75_2 ? cand_75_2_2 : cand_75_2_1;
    wire surv_75_2 = sel_75_2;
    wire [1:0] bm_75_3_from_1 = {1'b0, (r_sys[75] ^ 1'b1)} + {1'b0, (r_par1[75] ^ 1'b0)};
    wire [1:0] bm_75_3_from_3 = {1'b0, (r_sys[75] ^ 1'b1)} + {1'b0, (r_par1[75] ^ 1'b1)};
    wire [8:0] cand_75_3_1 = pm_74_1 + {7'b0, bm_75_3_from_1};
    wire [8:0] cand_75_3_2 = pm_74_3 + {7'b0, bm_75_3_from_3};
    wire sel_75_3 = (cand_75_3_1 > cand_75_3_2); // 1 if cand2 better
    wire [8:0] pm_75_3 = sel_75_3 ? cand_75_3_2 : cand_75_3_1;
    wire surv_75_3 = sel_75_3;
    // Stage 76
    wire [1:0] bm_76_0_from_0 = {1'b0, (r_sys[76] ^ 1'b0)} + {1'b0, (r_par1[76] ^ 1'b0)};
    wire [1:0] bm_76_0_from_2 = {1'b0, (r_sys[76] ^ 1'b0)} + {1'b0, (r_par1[76] ^ 1'b1)};
    wire [8:0] cand_76_0_1 = pm_75_0 + {7'b0, bm_76_0_from_0};
    wire [8:0] cand_76_0_2 = pm_75_2 + {7'b0, bm_76_0_from_2};
    wire sel_76_0 = (cand_76_0_1 > cand_76_0_2); // 1 if cand2 better
    wire [8:0] pm_76_0 = sel_76_0 ? cand_76_0_2 : cand_76_0_1;
    wire surv_76_0 = sel_76_0;
    wire [1:0] bm_76_1_from_0 = {1'b0, (r_sys[76] ^ 1'b1)} + {1'b0, (r_par1[76] ^ 1'b1)};
    wire [1:0] bm_76_1_from_2 = {1'b0, (r_sys[76] ^ 1'b1)} + {1'b0, (r_par1[76] ^ 1'b0)};
    wire [8:0] cand_76_1_1 = pm_75_0 + {7'b0, bm_76_1_from_0};
    wire [8:0] cand_76_1_2 = pm_75_2 + {7'b0, bm_76_1_from_2};
    wire sel_76_1 = (cand_76_1_1 > cand_76_1_2); // 1 if cand2 better
    wire [8:0] pm_76_1 = sel_76_1 ? cand_76_1_2 : cand_76_1_1;
    wire surv_76_1 = sel_76_1;
    wire [1:0] bm_76_2_from_1 = {1'b0, (r_sys[76] ^ 1'b0)} + {1'b0, (r_par1[76] ^ 1'b1)};
    wire [1:0] bm_76_2_from_3 = {1'b0, (r_sys[76] ^ 1'b0)} + {1'b0, (r_par1[76] ^ 1'b0)};
    wire [8:0] cand_76_2_1 = pm_75_1 + {7'b0, bm_76_2_from_1};
    wire [8:0] cand_76_2_2 = pm_75_3 + {7'b0, bm_76_2_from_3};
    wire sel_76_2 = (cand_76_2_1 > cand_76_2_2); // 1 if cand2 better
    wire [8:0] pm_76_2 = sel_76_2 ? cand_76_2_2 : cand_76_2_1;
    wire surv_76_2 = sel_76_2;
    wire [1:0] bm_76_3_from_1 = {1'b0, (r_sys[76] ^ 1'b1)} + {1'b0, (r_par1[76] ^ 1'b0)};
    wire [1:0] bm_76_3_from_3 = {1'b0, (r_sys[76] ^ 1'b1)} + {1'b0, (r_par1[76] ^ 1'b1)};
    wire [8:0] cand_76_3_1 = pm_75_1 + {7'b0, bm_76_3_from_1};
    wire [8:0] cand_76_3_2 = pm_75_3 + {7'b0, bm_76_3_from_3};
    wire sel_76_3 = (cand_76_3_1 > cand_76_3_2); // 1 if cand2 better
    wire [8:0] pm_76_3 = sel_76_3 ? cand_76_3_2 : cand_76_3_1;
    wire surv_76_3 = sel_76_3;
    // Stage 77
    wire [1:0] bm_77_0_from_0 = {1'b0, (r_sys[77] ^ 1'b0)} + {1'b0, (r_par1[77] ^ 1'b0)};
    wire [1:0] bm_77_0_from_2 = {1'b0, (r_sys[77] ^ 1'b0)} + {1'b0, (r_par1[77] ^ 1'b1)};
    wire [8:0] cand_77_0_1 = pm_76_0 + {7'b0, bm_77_0_from_0};
    wire [8:0] cand_77_0_2 = pm_76_2 + {7'b0, bm_77_0_from_2};
    wire sel_77_0 = (cand_77_0_1 > cand_77_0_2); // 1 if cand2 better
    wire [8:0] pm_77_0 = sel_77_0 ? cand_77_0_2 : cand_77_0_1;
    wire surv_77_0 = sel_77_0;
    wire [1:0] bm_77_1_from_0 = {1'b0, (r_sys[77] ^ 1'b1)} + {1'b0, (r_par1[77] ^ 1'b1)};
    wire [1:0] bm_77_1_from_2 = {1'b0, (r_sys[77] ^ 1'b1)} + {1'b0, (r_par1[77] ^ 1'b0)};
    wire [8:0] cand_77_1_1 = pm_76_0 + {7'b0, bm_77_1_from_0};
    wire [8:0] cand_77_1_2 = pm_76_2 + {7'b0, bm_77_1_from_2};
    wire sel_77_1 = (cand_77_1_1 > cand_77_1_2); // 1 if cand2 better
    wire [8:0] pm_77_1 = sel_77_1 ? cand_77_1_2 : cand_77_1_1;
    wire surv_77_1 = sel_77_1;
    wire [1:0] bm_77_2_from_1 = {1'b0, (r_sys[77] ^ 1'b0)} + {1'b0, (r_par1[77] ^ 1'b1)};
    wire [1:0] bm_77_2_from_3 = {1'b0, (r_sys[77] ^ 1'b0)} + {1'b0, (r_par1[77] ^ 1'b0)};
    wire [8:0] cand_77_2_1 = pm_76_1 + {7'b0, bm_77_2_from_1};
    wire [8:0] cand_77_2_2 = pm_76_3 + {7'b0, bm_77_2_from_3};
    wire sel_77_2 = (cand_77_2_1 > cand_77_2_2); // 1 if cand2 better
    wire [8:0] pm_77_2 = sel_77_2 ? cand_77_2_2 : cand_77_2_1;
    wire surv_77_2 = sel_77_2;
    wire [1:0] bm_77_3_from_1 = {1'b0, (r_sys[77] ^ 1'b1)} + {1'b0, (r_par1[77] ^ 1'b0)};
    wire [1:0] bm_77_3_from_3 = {1'b0, (r_sys[77] ^ 1'b1)} + {1'b0, (r_par1[77] ^ 1'b1)};
    wire [8:0] cand_77_3_1 = pm_76_1 + {7'b0, bm_77_3_from_1};
    wire [8:0] cand_77_3_2 = pm_76_3 + {7'b0, bm_77_3_from_3};
    wire sel_77_3 = (cand_77_3_1 > cand_77_3_2); // 1 if cand2 better
    wire [8:0] pm_77_3 = sel_77_3 ? cand_77_3_2 : cand_77_3_1;
    wire surv_77_3 = sel_77_3;
    // Stage 78
    wire [1:0] bm_78_0_from_0 = {1'b0, (r_sys[78] ^ 1'b0)} + {1'b0, (r_par1[78] ^ 1'b0)};
    wire [1:0] bm_78_0_from_2 = {1'b0, (r_sys[78] ^ 1'b0)} + {1'b0, (r_par1[78] ^ 1'b1)};
    wire [8:0] cand_78_0_1 = pm_77_0 + {7'b0, bm_78_0_from_0};
    wire [8:0] cand_78_0_2 = pm_77_2 + {7'b0, bm_78_0_from_2};
    wire sel_78_0 = (cand_78_0_1 > cand_78_0_2); // 1 if cand2 better
    wire [8:0] pm_78_0 = sel_78_0 ? cand_78_0_2 : cand_78_0_1;
    wire surv_78_0 = sel_78_0;
    wire [1:0] bm_78_1_from_0 = {1'b0, (r_sys[78] ^ 1'b1)} + {1'b0, (r_par1[78] ^ 1'b1)};
    wire [1:0] bm_78_1_from_2 = {1'b0, (r_sys[78] ^ 1'b1)} + {1'b0, (r_par1[78] ^ 1'b0)};
    wire [8:0] cand_78_1_1 = pm_77_0 + {7'b0, bm_78_1_from_0};
    wire [8:0] cand_78_1_2 = pm_77_2 + {7'b0, bm_78_1_from_2};
    wire sel_78_1 = (cand_78_1_1 > cand_78_1_2); // 1 if cand2 better
    wire [8:0] pm_78_1 = sel_78_1 ? cand_78_1_2 : cand_78_1_1;
    wire surv_78_1 = sel_78_1;
    wire [1:0] bm_78_2_from_1 = {1'b0, (r_sys[78] ^ 1'b0)} + {1'b0, (r_par1[78] ^ 1'b1)};
    wire [1:0] bm_78_2_from_3 = {1'b0, (r_sys[78] ^ 1'b0)} + {1'b0, (r_par1[78] ^ 1'b0)};
    wire [8:0] cand_78_2_1 = pm_77_1 + {7'b0, bm_78_2_from_1};
    wire [8:0] cand_78_2_2 = pm_77_3 + {7'b0, bm_78_2_from_3};
    wire sel_78_2 = (cand_78_2_1 > cand_78_2_2); // 1 if cand2 better
    wire [8:0] pm_78_2 = sel_78_2 ? cand_78_2_2 : cand_78_2_1;
    wire surv_78_2 = sel_78_2;
    wire [1:0] bm_78_3_from_1 = {1'b0, (r_sys[78] ^ 1'b1)} + {1'b0, (r_par1[78] ^ 1'b0)};
    wire [1:0] bm_78_3_from_3 = {1'b0, (r_sys[78] ^ 1'b1)} + {1'b0, (r_par1[78] ^ 1'b1)};
    wire [8:0] cand_78_3_1 = pm_77_1 + {7'b0, bm_78_3_from_1};
    wire [8:0] cand_78_3_2 = pm_77_3 + {7'b0, bm_78_3_from_3};
    wire sel_78_3 = (cand_78_3_1 > cand_78_3_2); // 1 if cand2 better
    wire [8:0] pm_78_3 = sel_78_3 ? cand_78_3_2 : cand_78_3_1;
    wire surv_78_3 = sel_78_3;
    // Stage 79
    wire [1:0] bm_79_0_from_0 = {1'b0, (r_sys[79] ^ 1'b0)} + {1'b0, (r_par1[79] ^ 1'b0)};
    wire [1:0] bm_79_0_from_2 = {1'b0, (r_sys[79] ^ 1'b0)} + {1'b0, (r_par1[79] ^ 1'b1)};
    wire [8:0] cand_79_0_1 = pm_78_0 + {7'b0, bm_79_0_from_0};
    wire [8:0] cand_79_0_2 = pm_78_2 + {7'b0, bm_79_0_from_2};
    wire sel_79_0 = (cand_79_0_1 > cand_79_0_2); // 1 if cand2 better
    wire [8:0] pm_79_0 = sel_79_0 ? cand_79_0_2 : cand_79_0_1;
    wire surv_79_0 = sel_79_0;
    wire [1:0] bm_79_1_from_0 = {1'b0, (r_sys[79] ^ 1'b1)} + {1'b0, (r_par1[79] ^ 1'b1)};
    wire [1:0] bm_79_1_from_2 = {1'b0, (r_sys[79] ^ 1'b1)} + {1'b0, (r_par1[79] ^ 1'b0)};
    wire [8:0] cand_79_1_1 = pm_78_0 + {7'b0, bm_79_1_from_0};
    wire [8:0] cand_79_1_2 = pm_78_2 + {7'b0, bm_79_1_from_2};
    wire sel_79_1 = (cand_79_1_1 > cand_79_1_2); // 1 if cand2 better
    wire [8:0] pm_79_1 = sel_79_1 ? cand_79_1_2 : cand_79_1_1;
    wire surv_79_1 = sel_79_1;
    wire [1:0] bm_79_2_from_1 = {1'b0, (r_sys[79] ^ 1'b0)} + {1'b0, (r_par1[79] ^ 1'b1)};
    wire [1:0] bm_79_2_from_3 = {1'b0, (r_sys[79] ^ 1'b0)} + {1'b0, (r_par1[79] ^ 1'b0)};
    wire [8:0] cand_79_2_1 = pm_78_1 + {7'b0, bm_79_2_from_1};
    wire [8:0] cand_79_2_2 = pm_78_3 + {7'b0, bm_79_2_from_3};
    wire sel_79_2 = (cand_79_2_1 > cand_79_2_2); // 1 if cand2 better
    wire [8:0] pm_79_2 = sel_79_2 ? cand_79_2_2 : cand_79_2_1;
    wire surv_79_2 = sel_79_2;
    wire [1:0] bm_79_3_from_1 = {1'b0, (r_sys[79] ^ 1'b1)} + {1'b0, (r_par1[79] ^ 1'b0)};
    wire [1:0] bm_79_3_from_3 = {1'b0, (r_sys[79] ^ 1'b1)} + {1'b0, (r_par1[79] ^ 1'b1)};
    wire [8:0] cand_79_3_1 = pm_78_1 + {7'b0, bm_79_3_from_1};
    wire [8:0] cand_79_3_2 = pm_78_3 + {7'b0, bm_79_3_from_3};
    wire sel_79_3 = (cand_79_3_1 > cand_79_3_2); // 1 if cand2 better
    wire [8:0] pm_79_3 = sel_79_3 ? cand_79_3_2 : cand_79_3_1;
    wire surv_79_3 = sel_79_3;
    // Stage 80
    wire [1:0] bm_80_0_from_0 = {1'b0, (r_sys[80] ^ 1'b0)} + {1'b0, (r_par1[80] ^ 1'b0)};
    wire [1:0] bm_80_0_from_2 = {1'b0, (r_sys[80] ^ 1'b0)} + {1'b0, (r_par1[80] ^ 1'b1)};
    wire [8:0] cand_80_0_1 = pm_79_0 + {7'b0, bm_80_0_from_0};
    wire [8:0] cand_80_0_2 = pm_79_2 + {7'b0, bm_80_0_from_2};
    wire sel_80_0 = (cand_80_0_1 > cand_80_0_2); // 1 if cand2 better
    wire [8:0] pm_80_0 = sel_80_0 ? cand_80_0_2 : cand_80_0_1;
    wire surv_80_0 = sel_80_0;
    wire [1:0] bm_80_1_from_0 = {1'b0, (r_sys[80] ^ 1'b1)} + {1'b0, (r_par1[80] ^ 1'b1)};
    wire [1:0] bm_80_1_from_2 = {1'b0, (r_sys[80] ^ 1'b1)} + {1'b0, (r_par1[80] ^ 1'b0)};
    wire [8:0] cand_80_1_1 = pm_79_0 + {7'b0, bm_80_1_from_0};
    wire [8:0] cand_80_1_2 = pm_79_2 + {7'b0, bm_80_1_from_2};
    wire sel_80_1 = (cand_80_1_1 > cand_80_1_2); // 1 if cand2 better
    wire [8:0] pm_80_1 = sel_80_1 ? cand_80_1_2 : cand_80_1_1;
    wire surv_80_1 = sel_80_1;
    wire [1:0] bm_80_2_from_1 = {1'b0, (r_sys[80] ^ 1'b0)} + {1'b0, (r_par1[80] ^ 1'b1)};
    wire [1:0] bm_80_2_from_3 = {1'b0, (r_sys[80] ^ 1'b0)} + {1'b0, (r_par1[80] ^ 1'b0)};
    wire [8:0] cand_80_2_1 = pm_79_1 + {7'b0, bm_80_2_from_1};
    wire [8:0] cand_80_2_2 = pm_79_3 + {7'b0, bm_80_2_from_3};
    wire sel_80_2 = (cand_80_2_1 > cand_80_2_2); // 1 if cand2 better
    wire [8:0] pm_80_2 = sel_80_2 ? cand_80_2_2 : cand_80_2_1;
    wire surv_80_2 = sel_80_2;
    wire [1:0] bm_80_3_from_1 = {1'b0, (r_sys[80] ^ 1'b1)} + {1'b0, (r_par1[80] ^ 1'b0)};
    wire [1:0] bm_80_3_from_3 = {1'b0, (r_sys[80] ^ 1'b1)} + {1'b0, (r_par1[80] ^ 1'b1)};
    wire [8:0] cand_80_3_1 = pm_79_1 + {7'b0, bm_80_3_from_1};
    wire [8:0] cand_80_3_2 = pm_79_3 + {7'b0, bm_80_3_from_3};
    wire sel_80_3 = (cand_80_3_1 > cand_80_3_2); // 1 if cand2 better
    wire [8:0] pm_80_3 = sel_80_3 ? cand_80_3_2 : cand_80_3_1;
    wire surv_80_3 = sel_80_3;
    // Stage 81
    wire [1:0] bm_81_0_from_0 = {1'b0, (r_sys[81] ^ 1'b0)} + {1'b0, (r_par1[81] ^ 1'b0)};
    wire [1:0] bm_81_0_from_2 = {1'b0, (r_sys[81] ^ 1'b0)} + {1'b0, (r_par1[81] ^ 1'b1)};
    wire [8:0] cand_81_0_1 = pm_80_0 + {7'b0, bm_81_0_from_0};
    wire [8:0] cand_81_0_2 = pm_80_2 + {7'b0, bm_81_0_from_2};
    wire sel_81_0 = (cand_81_0_1 > cand_81_0_2); // 1 if cand2 better
    wire [8:0] pm_81_0 = sel_81_0 ? cand_81_0_2 : cand_81_0_1;
    wire surv_81_0 = sel_81_0;
    wire [1:0] bm_81_1_from_0 = {1'b0, (r_sys[81] ^ 1'b1)} + {1'b0, (r_par1[81] ^ 1'b1)};
    wire [1:0] bm_81_1_from_2 = {1'b0, (r_sys[81] ^ 1'b1)} + {1'b0, (r_par1[81] ^ 1'b0)};
    wire [8:0] cand_81_1_1 = pm_80_0 + {7'b0, bm_81_1_from_0};
    wire [8:0] cand_81_1_2 = pm_80_2 + {7'b0, bm_81_1_from_2};
    wire sel_81_1 = (cand_81_1_1 > cand_81_1_2); // 1 if cand2 better
    wire [8:0] pm_81_1 = sel_81_1 ? cand_81_1_2 : cand_81_1_1;
    wire surv_81_1 = sel_81_1;
    wire [1:0] bm_81_2_from_1 = {1'b0, (r_sys[81] ^ 1'b0)} + {1'b0, (r_par1[81] ^ 1'b1)};
    wire [1:0] bm_81_2_from_3 = {1'b0, (r_sys[81] ^ 1'b0)} + {1'b0, (r_par1[81] ^ 1'b0)};
    wire [8:0] cand_81_2_1 = pm_80_1 + {7'b0, bm_81_2_from_1};
    wire [8:0] cand_81_2_2 = pm_80_3 + {7'b0, bm_81_2_from_3};
    wire sel_81_2 = (cand_81_2_1 > cand_81_2_2); // 1 if cand2 better
    wire [8:0] pm_81_2 = sel_81_2 ? cand_81_2_2 : cand_81_2_1;
    wire surv_81_2 = sel_81_2;
    wire [1:0] bm_81_3_from_1 = {1'b0, (r_sys[81] ^ 1'b1)} + {1'b0, (r_par1[81] ^ 1'b0)};
    wire [1:0] bm_81_3_from_3 = {1'b0, (r_sys[81] ^ 1'b1)} + {1'b0, (r_par1[81] ^ 1'b1)};
    wire [8:0] cand_81_3_1 = pm_80_1 + {7'b0, bm_81_3_from_1};
    wire [8:0] cand_81_3_2 = pm_80_3 + {7'b0, bm_81_3_from_3};
    wire sel_81_3 = (cand_81_3_1 > cand_81_3_2); // 1 if cand2 better
    wire [8:0] pm_81_3 = sel_81_3 ? cand_81_3_2 : cand_81_3_1;
    wire surv_81_3 = sel_81_3;
    // Stage 82
    wire [1:0] bm_82_0_from_0 = {1'b0, (r_sys[82] ^ 1'b0)} + {1'b0, (r_par1[82] ^ 1'b0)};
    wire [1:0] bm_82_0_from_2 = {1'b0, (r_sys[82] ^ 1'b0)} + {1'b0, (r_par1[82] ^ 1'b1)};
    wire [8:0] cand_82_0_1 = pm_81_0 + {7'b0, bm_82_0_from_0};
    wire [8:0] cand_82_0_2 = pm_81_2 + {7'b0, bm_82_0_from_2};
    wire sel_82_0 = (cand_82_0_1 > cand_82_0_2); // 1 if cand2 better
    wire [8:0] pm_82_0 = sel_82_0 ? cand_82_0_2 : cand_82_0_1;
    wire surv_82_0 = sel_82_0;
    wire [1:0] bm_82_1_from_0 = {1'b0, (r_sys[82] ^ 1'b1)} + {1'b0, (r_par1[82] ^ 1'b1)};
    wire [1:0] bm_82_1_from_2 = {1'b0, (r_sys[82] ^ 1'b1)} + {1'b0, (r_par1[82] ^ 1'b0)};
    wire [8:0] cand_82_1_1 = pm_81_0 + {7'b0, bm_82_1_from_0};
    wire [8:0] cand_82_1_2 = pm_81_2 + {7'b0, bm_82_1_from_2};
    wire sel_82_1 = (cand_82_1_1 > cand_82_1_2); // 1 if cand2 better
    wire [8:0] pm_82_1 = sel_82_1 ? cand_82_1_2 : cand_82_1_1;
    wire surv_82_1 = sel_82_1;
    wire [1:0] bm_82_2_from_1 = {1'b0, (r_sys[82] ^ 1'b0)} + {1'b0, (r_par1[82] ^ 1'b1)};
    wire [1:0] bm_82_2_from_3 = {1'b0, (r_sys[82] ^ 1'b0)} + {1'b0, (r_par1[82] ^ 1'b0)};
    wire [8:0] cand_82_2_1 = pm_81_1 + {7'b0, bm_82_2_from_1};
    wire [8:0] cand_82_2_2 = pm_81_3 + {7'b0, bm_82_2_from_3};
    wire sel_82_2 = (cand_82_2_1 > cand_82_2_2); // 1 if cand2 better
    wire [8:0] pm_82_2 = sel_82_2 ? cand_82_2_2 : cand_82_2_1;
    wire surv_82_2 = sel_82_2;
    wire [1:0] bm_82_3_from_1 = {1'b0, (r_sys[82] ^ 1'b1)} + {1'b0, (r_par1[82] ^ 1'b0)};
    wire [1:0] bm_82_3_from_3 = {1'b0, (r_sys[82] ^ 1'b1)} + {1'b0, (r_par1[82] ^ 1'b1)};
    wire [8:0] cand_82_3_1 = pm_81_1 + {7'b0, bm_82_3_from_1};
    wire [8:0] cand_82_3_2 = pm_81_3 + {7'b0, bm_82_3_from_3};
    wire sel_82_3 = (cand_82_3_1 > cand_82_3_2); // 1 if cand2 better
    wire [8:0] pm_82_3 = sel_82_3 ? cand_82_3_2 : cand_82_3_1;
    wire surv_82_3 = sel_82_3;
    // Stage 83
    wire [1:0] bm_83_0_from_0 = {1'b0, (r_sys[83] ^ 1'b0)} + {1'b0, (r_par1[83] ^ 1'b0)};
    wire [1:0] bm_83_0_from_2 = {1'b0, (r_sys[83] ^ 1'b0)} + {1'b0, (r_par1[83] ^ 1'b1)};
    wire [8:0] cand_83_0_1 = pm_82_0 + {7'b0, bm_83_0_from_0};
    wire [8:0] cand_83_0_2 = pm_82_2 + {7'b0, bm_83_0_from_2};
    wire sel_83_0 = (cand_83_0_1 > cand_83_0_2); // 1 if cand2 better
    wire [8:0] pm_83_0 = sel_83_0 ? cand_83_0_2 : cand_83_0_1;
    wire surv_83_0 = sel_83_0;
    wire [1:0] bm_83_1_from_0 = {1'b0, (r_sys[83] ^ 1'b1)} + {1'b0, (r_par1[83] ^ 1'b1)};
    wire [1:0] bm_83_1_from_2 = {1'b0, (r_sys[83] ^ 1'b1)} + {1'b0, (r_par1[83] ^ 1'b0)};
    wire [8:0] cand_83_1_1 = pm_82_0 + {7'b0, bm_83_1_from_0};
    wire [8:0] cand_83_1_2 = pm_82_2 + {7'b0, bm_83_1_from_2};
    wire sel_83_1 = (cand_83_1_1 > cand_83_1_2); // 1 if cand2 better
    wire [8:0] pm_83_1 = sel_83_1 ? cand_83_1_2 : cand_83_1_1;
    wire surv_83_1 = sel_83_1;
    wire [1:0] bm_83_2_from_1 = {1'b0, (r_sys[83] ^ 1'b0)} + {1'b0, (r_par1[83] ^ 1'b1)};
    wire [1:0] bm_83_2_from_3 = {1'b0, (r_sys[83] ^ 1'b0)} + {1'b0, (r_par1[83] ^ 1'b0)};
    wire [8:0] cand_83_2_1 = pm_82_1 + {7'b0, bm_83_2_from_1};
    wire [8:0] cand_83_2_2 = pm_82_3 + {7'b0, bm_83_2_from_3};
    wire sel_83_2 = (cand_83_2_1 > cand_83_2_2); // 1 if cand2 better
    wire [8:0] pm_83_2 = sel_83_2 ? cand_83_2_2 : cand_83_2_1;
    wire surv_83_2 = sel_83_2;
    wire [1:0] bm_83_3_from_1 = {1'b0, (r_sys[83] ^ 1'b1)} + {1'b0, (r_par1[83] ^ 1'b0)};
    wire [1:0] bm_83_3_from_3 = {1'b0, (r_sys[83] ^ 1'b1)} + {1'b0, (r_par1[83] ^ 1'b1)};
    wire [8:0] cand_83_3_1 = pm_82_1 + {7'b0, bm_83_3_from_1};
    wire [8:0] cand_83_3_2 = pm_82_3 + {7'b0, bm_83_3_from_3};
    wire sel_83_3 = (cand_83_3_1 > cand_83_3_2); // 1 if cand2 better
    wire [8:0] pm_83_3 = sel_83_3 ? cand_83_3_2 : cand_83_3_1;
    wire surv_83_3 = sel_83_3;
    // Stage 84
    wire [1:0] bm_84_0_from_0 = {1'b0, (r_sys[84] ^ 1'b0)} + {1'b0, (r_par1[84] ^ 1'b0)};
    wire [1:0] bm_84_0_from_2 = {1'b0, (r_sys[84] ^ 1'b0)} + {1'b0, (r_par1[84] ^ 1'b1)};
    wire [8:0] cand_84_0_1 = pm_83_0 + {7'b0, bm_84_0_from_0};
    wire [8:0] cand_84_0_2 = pm_83_2 + {7'b0, bm_84_0_from_2};
    wire sel_84_0 = (cand_84_0_1 > cand_84_0_2); // 1 if cand2 better
    wire [8:0] pm_84_0 = sel_84_0 ? cand_84_0_2 : cand_84_0_1;
    wire surv_84_0 = sel_84_0;
    wire [1:0] bm_84_1_from_0 = {1'b0, (r_sys[84] ^ 1'b1)} + {1'b0, (r_par1[84] ^ 1'b1)};
    wire [1:0] bm_84_1_from_2 = {1'b0, (r_sys[84] ^ 1'b1)} + {1'b0, (r_par1[84] ^ 1'b0)};
    wire [8:0] cand_84_1_1 = pm_83_0 + {7'b0, bm_84_1_from_0};
    wire [8:0] cand_84_1_2 = pm_83_2 + {7'b0, bm_84_1_from_2};
    wire sel_84_1 = (cand_84_1_1 > cand_84_1_2); // 1 if cand2 better
    wire [8:0] pm_84_1 = sel_84_1 ? cand_84_1_2 : cand_84_1_1;
    wire surv_84_1 = sel_84_1;
    wire [1:0] bm_84_2_from_1 = {1'b0, (r_sys[84] ^ 1'b0)} + {1'b0, (r_par1[84] ^ 1'b1)};
    wire [1:0] bm_84_2_from_3 = {1'b0, (r_sys[84] ^ 1'b0)} + {1'b0, (r_par1[84] ^ 1'b0)};
    wire [8:0] cand_84_2_1 = pm_83_1 + {7'b0, bm_84_2_from_1};
    wire [8:0] cand_84_2_2 = pm_83_3 + {7'b0, bm_84_2_from_3};
    wire sel_84_2 = (cand_84_2_1 > cand_84_2_2); // 1 if cand2 better
    wire [8:0] pm_84_2 = sel_84_2 ? cand_84_2_2 : cand_84_2_1;
    wire surv_84_2 = sel_84_2;
    wire [1:0] bm_84_3_from_1 = {1'b0, (r_sys[84] ^ 1'b1)} + {1'b0, (r_par1[84] ^ 1'b0)};
    wire [1:0] bm_84_3_from_3 = {1'b0, (r_sys[84] ^ 1'b1)} + {1'b0, (r_par1[84] ^ 1'b1)};
    wire [8:0] cand_84_3_1 = pm_83_1 + {7'b0, bm_84_3_from_1};
    wire [8:0] cand_84_3_2 = pm_83_3 + {7'b0, bm_84_3_from_3};
    wire sel_84_3 = (cand_84_3_1 > cand_84_3_2); // 1 if cand2 better
    wire [8:0] pm_84_3 = sel_84_3 ? cand_84_3_2 : cand_84_3_1;
    wire surv_84_3 = sel_84_3;
    // Stage 85
    wire [1:0] bm_85_0_from_0 = {1'b0, (r_sys[85] ^ 1'b0)} + {1'b0, (r_par1[85] ^ 1'b0)};
    wire [1:0] bm_85_0_from_2 = {1'b0, (r_sys[85] ^ 1'b0)} + {1'b0, (r_par1[85] ^ 1'b1)};
    wire [8:0] cand_85_0_1 = pm_84_0 + {7'b0, bm_85_0_from_0};
    wire [8:0] cand_85_0_2 = pm_84_2 + {7'b0, bm_85_0_from_2};
    wire sel_85_0 = (cand_85_0_1 > cand_85_0_2); // 1 if cand2 better
    wire [8:0] pm_85_0 = sel_85_0 ? cand_85_0_2 : cand_85_0_1;
    wire surv_85_0 = sel_85_0;
    wire [1:0] bm_85_1_from_0 = {1'b0, (r_sys[85] ^ 1'b1)} + {1'b0, (r_par1[85] ^ 1'b1)};
    wire [1:0] bm_85_1_from_2 = {1'b0, (r_sys[85] ^ 1'b1)} + {1'b0, (r_par1[85] ^ 1'b0)};
    wire [8:0] cand_85_1_1 = pm_84_0 + {7'b0, bm_85_1_from_0};
    wire [8:0] cand_85_1_2 = pm_84_2 + {7'b0, bm_85_1_from_2};
    wire sel_85_1 = (cand_85_1_1 > cand_85_1_2); // 1 if cand2 better
    wire [8:0] pm_85_1 = sel_85_1 ? cand_85_1_2 : cand_85_1_1;
    wire surv_85_1 = sel_85_1;
    wire [1:0] bm_85_2_from_1 = {1'b0, (r_sys[85] ^ 1'b0)} + {1'b0, (r_par1[85] ^ 1'b1)};
    wire [1:0] bm_85_2_from_3 = {1'b0, (r_sys[85] ^ 1'b0)} + {1'b0, (r_par1[85] ^ 1'b0)};
    wire [8:0] cand_85_2_1 = pm_84_1 + {7'b0, bm_85_2_from_1};
    wire [8:0] cand_85_2_2 = pm_84_3 + {7'b0, bm_85_2_from_3};
    wire sel_85_2 = (cand_85_2_1 > cand_85_2_2); // 1 if cand2 better
    wire [8:0] pm_85_2 = sel_85_2 ? cand_85_2_2 : cand_85_2_1;
    wire surv_85_2 = sel_85_2;
    wire [1:0] bm_85_3_from_1 = {1'b0, (r_sys[85] ^ 1'b1)} + {1'b0, (r_par1[85] ^ 1'b0)};
    wire [1:0] bm_85_3_from_3 = {1'b0, (r_sys[85] ^ 1'b1)} + {1'b0, (r_par1[85] ^ 1'b1)};
    wire [8:0] cand_85_3_1 = pm_84_1 + {7'b0, bm_85_3_from_1};
    wire [8:0] cand_85_3_2 = pm_84_3 + {7'b0, bm_85_3_from_3};
    wire sel_85_3 = (cand_85_3_1 > cand_85_3_2); // 1 if cand2 better
    wire [8:0] pm_85_3 = sel_85_3 ? cand_85_3_2 : cand_85_3_1;
    wire surv_85_3 = sel_85_3;
    // Stage 86
    wire [1:0] bm_86_0_from_0 = {1'b0, (r_sys[86] ^ 1'b0)} + {1'b0, (r_par1[86] ^ 1'b0)};
    wire [1:0] bm_86_0_from_2 = {1'b0, (r_sys[86] ^ 1'b0)} + {1'b0, (r_par1[86] ^ 1'b1)};
    wire [8:0] cand_86_0_1 = pm_85_0 + {7'b0, bm_86_0_from_0};
    wire [8:0] cand_86_0_2 = pm_85_2 + {7'b0, bm_86_0_from_2};
    wire sel_86_0 = (cand_86_0_1 > cand_86_0_2); // 1 if cand2 better
    wire [8:0] pm_86_0 = sel_86_0 ? cand_86_0_2 : cand_86_0_1;
    wire surv_86_0 = sel_86_0;
    wire [1:0] bm_86_1_from_0 = {1'b0, (r_sys[86] ^ 1'b1)} + {1'b0, (r_par1[86] ^ 1'b1)};
    wire [1:0] bm_86_1_from_2 = {1'b0, (r_sys[86] ^ 1'b1)} + {1'b0, (r_par1[86] ^ 1'b0)};
    wire [8:0] cand_86_1_1 = pm_85_0 + {7'b0, bm_86_1_from_0};
    wire [8:0] cand_86_1_2 = pm_85_2 + {7'b0, bm_86_1_from_2};
    wire sel_86_1 = (cand_86_1_1 > cand_86_1_2); // 1 if cand2 better
    wire [8:0] pm_86_1 = sel_86_1 ? cand_86_1_2 : cand_86_1_1;
    wire surv_86_1 = sel_86_1;
    wire [1:0] bm_86_2_from_1 = {1'b0, (r_sys[86] ^ 1'b0)} + {1'b0, (r_par1[86] ^ 1'b1)};
    wire [1:0] bm_86_2_from_3 = {1'b0, (r_sys[86] ^ 1'b0)} + {1'b0, (r_par1[86] ^ 1'b0)};
    wire [8:0] cand_86_2_1 = pm_85_1 + {7'b0, bm_86_2_from_1};
    wire [8:0] cand_86_2_2 = pm_85_3 + {7'b0, bm_86_2_from_3};
    wire sel_86_2 = (cand_86_2_1 > cand_86_2_2); // 1 if cand2 better
    wire [8:0] pm_86_2 = sel_86_2 ? cand_86_2_2 : cand_86_2_1;
    wire surv_86_2 = sel_86_2;
    wire [1:0] bm_86_3_from_1 = {1'b0, (r_sys[86] ^ 1'b1)} + {1'b0, (r_par1[86] ^ 1'b0)};
    wire [1:0] bm_86_3_from_3 = {1'b0, (r_sys[86] ^ 1'b1)} + {1'b0, (r_par1[86] ^ 1'b1)};
    wire [8:0] cand_86_3_1 = pm_85_1 + {7'b0, bm_86_3_from_1};
    wire [8:0] cand_86_3_2 = pm_85_3 + {7'b0, bm_86_3_from_3};
    wire sel_86_3 = (cand_86_3_1 > cand_86_3_2); // 1 if cand2 better
    wire [8:0] pm_86_3 = sel_86_3 ? cand_86_3_2 : cand_86_3_1;
    wire surv_86_3 = sel_86_3;
    // Stage 87
    wire [1:0] bm_87_0_from_0 = {1'b0, (r_sys[87] ^ 1'b0)} + {1'b0, (r_par1[87] ^ 1'b0)};
    wire [1:0] bm_87_0_from_2 = {1'b0, (r_sys[87] ^ 1'b0)} + {1'b0, (r_par1[87] ^ 1'b1)};
    wire [8:0] cand_87_0_1 = pm_86_0 + {7'b0, bm_87_0_from_0};
    wire [8:0] cand_87_0_2 = pm_86_2 + {7'b0, bm_87_0_from_2};
    wire sel_87_0 = (cand_87_0_1 > cand_87_0_2); // 1 if cand2 better
    wire [8:0] pm_87_0 = sel_87_0 ? cand_87_0_2 : cand_87_0_1;
    wire surv_87_0 = sel_87_0;
    wire [1:0] bm_87_1_from_0 = {1'b0, (r_sys[87] ^ 1'b1)} + {1'b0, (r_par1[87] ^ 1'b1)};
    wire [1:0] bm_87_1_from_2 = {1'b0, (r_sys[87] ^ 1'b1)} + {1'b0, (r_par1[87] ^ 1'b0)};
    wire [8:0] cand_87_1_1 = pm_86_0 + {7'b0, bm_87_1_from_0};
    wire [8:0] cand_87_1_2 = pm_86_2 + {7'b0, bm_87_1_from_2};
    wire sel_87_1 = (cand_87_1_1 > cand_87_1_2); // 1 if cand2 better
    wire [8:0] pm_87_1 = sel_87_1 ? cand_87_1_2 : cand_87_1_1;
    wire surv_87_1 = sel_87_1;
    wire [1:0] bm_87_2_from_1 = {1'b0, (r_sys[87] ^ 1'b0)} + {1'b0, (r_par1[87] ^ 1'b1)};
    wire [1:0] bm_87_2_from_3 = {1'b0, (r_sys[87] ^ 1'b0)} + {1'b0, (r_par1[87] ^ 1'b0)};
    wire [8:0] cand_87_2_1 = pm_86_1 + {7'b0, bm_87_2_from_1};
    wire [8:0] cand_87_2_2 = pm_86_3 + {7'b0, bm_87_2_from_3};
    wire sel_87_2 = (cand_87_2_1 > cand_87_2_2); // 1 if cand2 better
    wire [8:0] pm_87_2 = sel_87_2 ? cand_87_2_2 : cand_87_2_1;
    wire surv_87_2 = sel_87_2;
    wire [1:0] bm_87_3_from_1 = {1'b0, (r_sys[87] ^ 1'b1)} + {1'b0, (r_par1[87] ^ 1'b0)};
    wire [1:0] bm_87_3_from_3 = {1'b0, (r_sys[87] ^ 1'b1)} + {1'b0, (r_par1[87] ^ 1'b1)};
    wire [8:0] cand_87_3_1 = pm_86_1 + {7'b0, bm_87_3_from_1};
    wire [8:0] cand_87_3_2 = pm_86_3 + {7'b0, bm_87_3_from_3};
    wire sel_87_3 = (cand_87_3_1 > cand_87_3_2); // 1 if cand2 better
    wire [8:0] pm_87_3 = sel_87_3 ? cand_87_3_2 : cand_87_3_1;
    wire surv_87_3 = sel_87_3;
    // Stage 88
    wire [1:0] bm_88_0_from_0 = {1'b0, (r_sys[88] ^ 1'b0)} + {1'b0, (r_par1[88] ^ 1'b0)};
    wire [1:0] bm_88_0_from_2 = {1'b0, (r_sys[88] ^ 1'b0)} + {1'b0, (r_par1[88] ^ 1'b1)};
    wire [8:0] cand_88_0_1 = pm_87_0 + {7'b0, bm_88_0_from_0};
    wire [8:0] cand_88_0_2 = pm_87_2 + {7'b0, bm_88_0_from_2};
    wire sel_88_0 = (cand_88_0_1 > cand_88_0_2); // 1 if cand2 better
    wire [8:0] pm_88_0 = sel_88_0 ? cand_88_0_2 : cand_88_0_1;
    wire surv_88_0 = sel_88_0;
    wire [1:0] bm_88_1_from_0 = {1'b0, (r_sys[88] ^ 1'b1)} + {1'b0, (r_par1[88] ^ 1'b1)};
    wire [1:0] bm_88_1_from_2 = {1'b0, (r_sys[88] ^ 1'b1)} + {1'b0, (r_par1[88] ^ 1'b0)};
    wire [8:0] cand_88_1_1 = pm_87_0 + {7'b0, bm_88_1_from_0};
    wire [8:0] cand_88_1_2 = pm_87_2 + {7'b0, bm_88_1_from_2};
    wire sel_88_1 = (cand_88_1_1 > cand_88_1_2); // 1 if cand2 better
    wire [8:0] pm_88_1 = sel_88_1 ? cand_88_1_2 : cand_88_1_1;
    wire surv_88_1 = sel_88_1;
    wire [1:0] bm_88_2_from_1 = {1'b0, (r_sys[88] ^ 1'b0)} + {1'b0, (r_par1[88] ^ 1'b1)};
    wire [1:0] bm_88_2_from_3 = {1'b0, (r_sys[88] ^ 1'b0)} + {1'b0, (r_par1[88] ^ 1'b0)};
    wire [8:0] cand_88_2_1 = pm_87_1 + {7'b0, bm_88_2_from_1};
    wire [8:0] cand_88_2_2 = pm_87_3 + {7'b0, bm_88_2_from_3};
    wire sel_88_2 = (cand_88_2_1 > cand_88_2_2); // 1 if cand2 better
    wire [8:0] pm_88_2 = sel_88_2 ? cand_88_2_2 : cand_88_2_1;
    wire surv_88_2 = sel_88_2;
    wire [1:0] bm_88_3_from_1 = {1'b0, (r_sys[88] ^ 1'b1)} + {1'b0, (r_par1[88] ^ 1'b0)};
    wire [1:0] bm_88_3_from_3 = {1'b0, (r_sys[88] ^ 1'b1)} + {1'b0, (r_par1[88] ^ 1'b1)};
    wire [8:0] cand_88_3_1 = pm_87_1 + {7'b0, bm_88_3_from_1};
    wire [8:0] cand_88_3_2 = pm_87_3 + {7'b0, bm_88_3_from_3};
    wire sel_88_3 = (cand_88_3_1 > cand_88_3_2); // 1 if cand2 better
    wire [8:0] pm_88_3 = sel_88_3 ? cand_88_3_2 : cand_88_3_1;
    wire surv_88_3 = sel_88_3;
    // Stage 89
    wire [1:0] bm_89_0_from_0 = {1'b0, (r_sys[89] ^ 1'b0)} + {1'b0, (r_par1[89] ^ 1'b0)};
    wire [1:0] bm_89_0_from_2 = {1'b0, (r_sys[89] ^ 1'b0)} + {1'b0, (r_par1[89] ^ 1'b1)};
    wire [8:0] cand_89_0_1 = pm_88_0 + {7'b0, bm_89_0_from_0};
    wire [8:0] cand_89_0_2 = pm_88_2 + {7'b0, bm_89_0_from_2};
    wire sel_89_0 = (cand_89_0_1 > cand_89_0_2); // 1 if cand2 better
    wire [8:0] pm_89_0 = sel_89_0 ? cand_89_0_2 : cand_89_0_1;
    wire surv_89_0 = sel_89_0;
    wire [1:0] bm_89_1_from_0 = {1'b0, (r_sys[89] ^ 1'b1)} + {1'b0, (r_par1[89] ^ 1'b1)};
    wire [1:0] bm_89_1_from_2 = {1'b0, (r_sys[89] ^ 1'b1)} + {1'b0, (r_par1[89] ^ 1'b0)};
    wire [8:0] cand_89_1_1 = pm_88_0 + {7'b0, bm_89_1_from_0};
    wire [8:0] cand_89_1_2 = pm_88_2 + {7'b0, bm_89_1_from_2};
    wire sel_89_1 = (cand_89_1_1 > cand_89_1_2); // 1 if cand2 better
    wire [8:0] pm_89_1 = sel_89_1 ? cand_89_1_2 : cand_89_1_1;
    wire surv_89_1 = sel_89_1;
    wire [1:0] bm_89_2_from_1 = {1'b0, (r_sys[89] ^ 1'b0)} + {1'b0, (r_par1[89] ^ 1'b1)};
    wire [1:0] bm_89_2_from_3 = {1'b0, (r_sys[89] ^ 1'b0)} + {1'b0, (r_par1[89] ^ 1'b0)};
    wire [8:0] cand_89_2_1 = pm_88_1 + {7'b0, bm_89_2_from_1};
    wire [8:0] cand_89_2_2 = pm_88_3 + {7'b0, bm_89_2_from_3};
    wire sel_89_2 = (cand_89_2_1 > cand_89_2_2); // 1 if cand2 better
    wire [8:0] pm_89_2 = sel_89_2 ? cand_89_2_2 : cand_89_2_1;
    wire surv_89_2 = sel_89_2;
    wire [1:0] bm_89_3_from_1 = {1'b0, (r_sys[89] ^ 1'b1)} + {1'b0, (r_par1[89] ^ 1'b0)};
    wire [1:0] bm_89_3_from_3 = {1'b0, (r_sys[89] ^ 1'b1)} + {1'b0, (r_par1[89] ^ 1'b1)};
    wire [8:0] cand_89_3_1 = pm_88_1 + {7'b0, bm_89_3_from_1};
    wire [8:0] cand_89_3_2 = pm_88_3 + {7'b0, bm_89_3_from_3};
    wire sel_89_3 = (cand_89_3_1 > cand_89_3_2); // 1 if cand2 better
    wire [8:0] pm_89_3 = sel_89_3 ? cand_89_3_2 : cand_89_3_1;
    wire surv_89_3 = sel_89_3;
    // Stage 90
    wire [1:0] bm_90_0_from_0 = {1'b0, (r_sys[90] ^ 1'b0)} + {1'b0, (r_par1[90] ^ 1'b0)};
    wire [1:0] bm_90_0_from_2 = {1'b0, (r_sys[90] ^ 1'b0)} + {1'b0, (r_par1[90] ^ 1'b1)};
    wire [8:0] cand_90_0_1 = pm_89_0 + {7'b0, bm_90_0_from_0};
    wire [8:0] cand_90_0_2 = pm_89_2 + {7'b0, bm_90_0_from_2};
    wire sel_90_0 = (cand_90_0_1 > cand_90_0_2); // 1 if cand2 better
    wire [8:0] pm_90_0 = sel_90_0 ? cand_90_0_2 : cand_90_0_1;
    wire surv_90_0 = sel_90_0;
    wire [1:0] bm_90_1_from_0 = {1'b0, (r_sys[90] ^ 1'b1)} + {1'b0, (r_par1[90] ^ 1'b1)};
    wire [1:0] bm_90_1_from_2 = {1'b0, (r_sys[90] ^ 1'b1)} + {1'b0, (r_par1[90] ^ 1'b0)};
    wire [8:0] cand_90_1_1 = pm_89_0 + {7'b0, bm_90_1_from_0};
    wire [8:0] cand_90_1_2 = pm_89_2 + {7'b0, bm_90_1_from_2};
    wire sel_90_1 = (cand_90_1_1 > cand_90_1_2); // 1 if cand2 better
    wire [8:0] pm_90_1 = sel_90_1 ? cand_90_1_2 : cand_90_1_1;
    wire surv_90_1 = sel_90_1;
    wire [1:0] bm_90_2_from_1 = {1'b0, (r_sys[90] ^ 1'b0)} + {1'b0, (r_par1[90] ^ 1'b1)};
    wire [1:0] bm_90_2_from_3 = {1'b0, (r_sys[90] ^ 1'b0)} + {1'b0, (r_par1[90] ^ 1'b0)};
    wire [8:0] cand_90_2_1 = pm_89_1 + {7'b0, bm_90_2_from_1};
    wire [8:0] cand_90_2_2 = pm_89_3 + {7'b0, bm_90_2_from_3};
    wire sel_90_2 = (cand_90_2_1 > cand_90_2_2); // 1 if cand2 better
    wire [8:0] pm_90_2 = sel_90_2 ? cand_90_2_2 : cand_90_2_1;
    wire surv_90_2 = sel_90_2;
    wire [1:0] bm_90_3_from_1 = {1'b0, (r_sys[90] ^ 1'b1)} + {1'b0, (r_par1[90] ^ 1'b0)};
    wire [1:0] bm_90_3_from_3 = {1'b0, (r_sys[90] ^ 1'b1)} + {1'b0, (r_par1[90] ^ 1'b1)};
    wire [8:0] cand_90_3_1 = pm_89_1 + {7'b0, bm_90_3_from_1};
    wire [8:0] cand_90_3_2 = pm_89_3 + {7'b0, bm_90_3_from_3};
    wire sel_90_3 = (cand_90_3_1 > cand_90_3_2); // 1 if cand2 better
    wire [8:0] pm_90_3 = sel_90_3 ? cand_90_3_2 : cand_90_3_1;
    wire surv_90_3 = sel_90_3;
    // Stage 91
    wire [1:0] bm_91_0_from_0 = {1'b0, (r_sys[91] ^ 1'b0)} + {1'b0, (r_par1[91] ^ 1'b0)};
    wire [1:0] bm_91_0_from_2 = {1'b0, (r_sys[91] ^ 1'b0)} + {1'b0, (r_par1[91] ^ 1'b1)};
    wire [8:0] cand_91_0_1 = pm_90_0 + {7'b0, bm_91_0_from_0};
    wire [8:0] cand_91_0_2 = pm_90_2 + {7'b0, bm_91_0_from_2};
    wire sel_91_0 = (cand_91_0_1 > cand_91_0_2); // 1 if cand2 better
    wire [8:0] pm_91_0 = sel_91_0 ? cand_91_0_2 : cand_91_0_1;
    wire surv_91_0 = sel_91_0;
    wire [1:0] bm_91_1_from_0 = {1'b0, (r_sys[91] ^ 1'b1)} + {1'b0, (r_par1[91] ^ 1'b1)};
    wire [1:0] bm_91_1_from_2 = {1'b0, (r_sys[91] ^ 1'b1)} + {1'b0, (r_par1[91] ^ 1'b0)};
    wire [8:0] cand_91_1_1 = pm_90_0 + {7'b0, bm_91_1_from_0};
    wire [8:0] cand_91_1_2 = pm_90_2 + {7'b0, bm_91_1_from_2};
    wire sel_91_1 = (cand_91_1_1 > cand_91_1_2); // 1 if cand2 better
    wire [8:0] pm_91_1 = sel_91_1 ? cand_91_1_2 : cand_91_1_1;
    wire surv_91_1 = sel_91_1;
    wire [1:0] bm_91_2_from_1 = {1'b0, (r_sys[91] ^ 1'b0)} + {1'b0, (r_par1[91] ^ 1'b1)};
    wire [1:0] bm_91_2_from_3 = {1'b0, (r_sys[91] ^ 1'b0)} + {1'b0, (r_par1[91] ^ 1'b0)};
    wire [8:0] cand_91_2_1 = pm_90_1 + {7'b0, bm_91_2_from_1};
    wire [8:0] cand_91_2_2 = pm_90_3 + {7'b0, bm_91_2_from_3};
    wire sel_91_2 = (cand_91_2_1 > cand_91_2_2); // 1 if cand2 better
    wire [8:0] pm_91_2 = sel_91_2 ? cand_91_2_2 : cand_91_2_1;
    wire surv_91_2 = sel_91_2;
    wire [1:0] bm_91_3_from_1 = {1'b0, (r_sys[91] ^ 1'b1)} + {1'b0, (r_par1[91] ^ 1'b0)};
    wire [1:0] bm_91_3_from_3 = {1'b0, (r_sys[91] ^ 1'b1)} + {1'b0, (r_par1[91] ^ 1'b1)};
    wire [8:0] cand_91_3_1 = pm_90_1 + {7'b0, bm_91_3_from_1};
    wire [8:0] cand_91_3_2 = pm_90_3 + {7'b0, bm_91_3_from_3};
    wire sel_91_3 = (cand_91_3_1 > cand_91_3_2); // 1 if cand2 better
    wire [8:0] pm_91_3 = sel_91_3 ? cand_91_3_2 : cand_91_3_1;
    wire surv_91_3 = sel_91_3;
    // Stage 92
    wire [1:0] bm_92_0_from_0 = {1'b0, (r_sys[92] ^ 1'b0)} + {1'b0, (r_par1[92] ^ 1'b0)};
    wire [1:0] bm_92_0_from_2 = {1'b0, (r_sys[92] ^ 1'b0)} + {1'b0, (r_par1[92] ^ 1'b1)};
    wire [8:0] cand_92_0_1 = pm_91_0 + {7'b0, bm_92_0_from_0};
    wire [8:0] cand_92_0_2 = pm_91_2 + {7'b0, bm_92_0_from_2};
    wire sel_92_0 = (cand_92_0_1 > cand_92_0_2); // 1 if cand2 better
    wire [8:0] pm_92_0 = sel_92_0 ? cand_92_0_2 : cand_92_0_1;
    wire surv_92_0 = sel_92_0;
    wire [1:0] bm_92_1_from_0 = {1'b0, (r_sys[92] ^ 1'b1)} + {1'b0, (r_par1[92] ^ 1'b1)};
    wire [1:0] bm_92_1_from_2 = {1'b0, (r_sys[92] ^ 1'b1)} + {1'b0, (r_par1[92] ^ 1'b0)};
    wire [8:0] cand_92_1_1 = pm_91_0 + {7'b0, bm_92_1_from_0};
    wire [8:0] cand_92_1_2 = pm_91_2 + {7'b0, bm_92_1_from_2};
    wire sel_92_1 = (cand_92_1_1 > cand_92_1_2); // 1 if cand2 better
    wire [8:0] pm_92_1 = sel_92_1 ? cand_92_1_2 : cand_92_1_1;
    wire surv_92_1 = sel_92_1;
    wire [1:0] bm_92_2_from_1 = {1'b0, (r_sys[92] ^ 1'b0)} + {1'b0, (r_par1[92] ^ 1'b1)};
    wire [1:0] bm_92_2_from_3 = {1'b0, (r_sys[92] ^ 1'b0)} + {1'b0, (r_par1[92] ^ 1'b0)};
    wire [8:0] cand_92_2_1 = pm_91_1 + {7'b0, bm_92_2_from_1};
    wire [8:0] cand_92_2_2 = pm_91_3 + {7'b0, bm_92_2_from_3};
    wire sel_92_2 = (cand_92_2_1 > cand_92_2_2); // 1 if cand2 better
    wire [8:0] pm_92_2 = sel_92_2 ? cand_92_2_2 : cand_92_2_1;
    wire surv_92_2 = sel_92_2;
    wire [1:0] bm_92_3_from_1 = {1'b0, (r_sys[92] ^ 1'b1)} + {1'b0, (r_par1[92] ^ 1'b0)};
    wire [1:0] bm_92_3_from_3 = {1'b0, (r_sys[92] ^ 1'b1)} + {1'b0, (r_par1[92] ^ 1'b1)};
    wire [8:0] cand_92_3_1 = pm_91_1 + {7'b0, bm_92_3_from_1};
    wire [8:0] cand_92_3_2 = pm_91_3 + {7'b0, bm_92_3_from_3};
    wire sel_92_3 = (cand_92_3_1 > cand_92_3_2); // 1 if cand2 better
    wire [8:0] pm_92_3 = sel_92_3 ? cand_92_3_2 : cand_92_3_1;
    wire surv_92_3 = sel_92_3;
    // Stage 93
    wire [1:0] bm_93_0_from_0 = {1'b0, (r_sys[93] ^ 1'b0)} + {1'b0, (r_par1[93] ^ 1'b0)};
    wire [1:0] bm_93_0_from_2 = {1'b0, (r_sys[93] ^ 1'b0)} + {1'b0, (r_par1[93] ^ 1'b1)};
    wire [8:0] cand_93_0_1 = pm_92_0 + {7'b0, bm_93_0_from_0};
    wire [8:0] cand_93_0_2 = pm_92_2 + {7'b0, bm_93_0_from_2};
    wire sel_93_0 = (cand_93_0_1 > cand_93_0_2); // 1 if cand2 better
    wire [8:0] pm_93_0 = sel_93_0 ? cand_93_0_2 : cand_93_0_1;
    wire surv_93_0 = sel_93_0;
    wire [1:0] bm_93_1_from_0 = {1'b0, (r_sys[93] ^ 1'b1)} + {1'b0, (r_par1[93] ^ 1'b1)};
    wire [1:0] bm_93_1_from_2 = {1'b0, (r_sys[93] ^ 1'b1)} + {1'b0, (r_par1[93] ^ 1'b0)};
    wire [8:0] cand_93_1_1 = pm_92_0 + {7'b0, bm_93_1_from_0};
    wire [8:0] cand_93_1_2 = pm_92_2 + {7'b0, bm_93_1_from_2};
    wire sel_93_1 = (cand_93_1_1 > cand_93_1_2); // 1 if cand2 better
    wire [8:0] pm_93_1 = sel_93_1 ? cand_93_1_2 : cand_93_1_1;
    wire surv_93_1 = sel_93_1;
    wire [1:0] bm_93_2_from_1 = {1'b0, (r_sys[93] ^ 1'b0)} + {1'b0, (r_par1[93] ^ 1'b1)};
    wire [1:0] bm_93_2_from_3 = {1'b0, (r_sys[93] ^ 1'b0)} + {1'b0, (r_par1[93] ^ 1'b0)};
    wire [8:0] cand_93_2_1 = pm_92_1 + {7'b0, bm_93_2_from_1};
    wire [8:0] cand_93_2_2 = pm_92_3 + {7'b0, bm_93_2_from_3};
    wire sel_93_2 = (cand_93_2_1 > cand_93_2_2); // 1 if cand2 better
    wire [8:0] pm_93_2 = sel_93_2 ? cand_93_2_2 : cand_93_2_1;
    wire surv_93_2 = sel_93_2;
    wire [1:0] bm_93_3_from_1 = {1'b0, (r_sys[93] ^ 1'b1)} + {1'b0, (r_par1[93] ^ 1'b0)};
    wire [1:0] bm_93_3_from_3 = {1'b0, (r_sys[93] ^ 1'b1)} + {1'b0, (r_par1[93] ^ 1'b1)};
    wire [8:0] cand_93_3_1 = pm_92_1 + {7'b0, bm_93_3_from_1};
    wire [8:0] cand_93_3_2 = pm_92_3 + {7'b0, bm_93_3_from_3};
    wire sel_93_3 = (cand_93_3_1 > cand_93_3_2); // 1 if cand2 better
    wire [8:0] pm_93_3 = sel_93_3 ? cand_93_3_2 : cand_93_3_1;
    wire surv_93_3 = sel_93_3;
    // Stage 94
    wire [1:0] bm_94_0_from_0 = {1'b0, (r_sys[94] ^ 1'b0)} + {1'b0, (r_par1[94] ^ 1'b0)};
    wire [1:0] bm_94_0_from_2 = {1'b0, (r_sys[94] ^ 1'b0)} + {1'b0, (r_par1[94] ^ 1'b1)};
    wire [8:0] cand_94_0_1 = pm_93_0 + {7'b0, bm_94_0_from_0};
    wire [8:0] cand_94_0_2 = pm_93_2 + {7'b0, bm_94_0_from_2};
    wire sel_94_0 = (cand_94_0_1 > cand_94_0_2); // 1 if cand2 better
    wire [8:0] pm_94_0 = sel_94_0 ? cand_94_0_2 : cand_94_0_1;
    wire surv_94_0 = sel_94_0;
    wire [1:0] bm_94_1_from_0 = {1'b0, (r_sys[94] ^ 1'b1)} + {1'b0, (r_par1[94] ^ 1'b1)};
    wire [1:0] bm_94_1_from_2 = {1'b0, (r_sys[94] ^ 1'b1)} + {1'b0, (r_par1[94] ^ 1'b0)};
    wire [8:0] cand_94_1_1 = pm_93_0 + {7'b0, bm_94_1_from_0};
    wire [8:0] cand_94_1_2 = pm_93_2 + {7'b0, bm_94_1_from_2};
    wire sel_94_1 = (cand_94_1_1 > cand_94_1_2); // 1 if cand2 better
    wire [8:0] pm_94_1 = sel_94_1 ? cand_94_1_2 : cand_94_1_1;
    wire surv_94_1 = sel_94_1;
    wire [1:0] bm_94_2_from_1 = {1'b0, (r_sys[94] ^ 1'b0)} + {1'b0, (r_par1[94] ^ 1'b1)};
    wire [1:0] bm_94_2_from_3 = {1'b0, (r_sys[94] ^ 1'b0)} + {1'b0, (r_par1[94] ^ 1'b0)};
    wire [8:0] cand_94_2_1 = pm_93_1 + {7'b0, bm_94_2_from_1};
    wire [8:0] cand_94_2_2 = pm_93_3 + {7'b0, bm_94_2_from_3};
    wire sel_94_2 = (cand_94_2_1 > cand_94_2_2); // 1 if cand2 better
    wire [8:0] pm_94_2 = sel_94_2 ? cand_94_2_2 : cand_94_2_1;
    wire surv_94_2 = sel_94_2;
    wire [1:0] bm_94_3_from_1 = {1'b0, (r_sys[94] ^ 1'b1)} + {1'b0, (r_par1[94] ^ 1'b0)};
    wire [1:0] bm_94_3_from_3 = {1'b0, (r_sys[94] ^ 1'b1)} + {1'b0, (r_par1[94] ^ 1'b1)};
    wire [8:0] cand_94_3_1 = pm_93_1 + {7'b0, bm_94_3_from_1};
    wire [8:0] cand_94_3_2 = pm_93_3 + {7'b0, bm_94_3_from_3};
    wire sel_94_3 = (cand_94_3_1 > cand_94_3_2); // 1 if cand2 better
    wire [8:0] pm_94_3 = sel_94_3 ? cand_94_3_2 : cand_94_3_1;
    wire surv_94_3 = sel_94_3;
    // Stage 95
    wire [1:0] bm_95_0_from_0 = {1'b0, (r_sys[95] ^ 1'b0)} + {1'b0, (r_par1[95] ^ 1'b0)};
    wire [1:0] bm_95_0_from_2 = {1'b0, (r_sys[95] ^ 1'b0)} + {1'b0, (r_par1[95] ^ 1'b1)};
    wire [8:0] cand_95_0_1 = pm_94_0 + {7'b0, bm_95_0_from_0};
    wire [8:0] cand_95_0_2 = pm_94_2 + {7'b0, bm_95_0_from_2};
    wire sel_95_0 = (cand_95_0_1 > cand_95_0_2); // 1 if cand2 better
    wire [8:0] pm_95_0 = sel_95_0 ? cand_95_0_2 : cand_95_0_1;
    wire surv_95_0 = sel_95_0;
    wire [1:0] bm_95_1_from_0 = {1'b0, (r_sys[95] ^ 1'b1)} + {1'b0, (r_par1[95] ^ 1'b1)};
    wire [1:0] bm_95_1_from_2 = {1'b0, (r_sys[95] ^ 1'b1)} + {1'b0, (r_par1[95] ^ 1'b0)};
    wire [8:0] cand_95_1_1 = pm_94_0 + {7'b0, bm_95_1_from_0};
    wire [8:0] cand_95_1_2 = pm_94_2 + {7'b0, bm_95_1_from_2};
    wire sel_95_1 = (cand_95_1_1 > cand_95_1_2); // 1 if cand2 better
    wire [8:0] pm_95_1 = sel_95_1 ? cand_95_1_2 : cand_95_1_1;
    wire surv_95_1 = sel_95_1;
    wire [1:0] bm_95_2_from_1 = {1'b0, (r_sys[95] ^ 1'b0)} + {1'b0, (r_par1[95] ^ 1'b1)};
    wire [1:0] bm_95_2_from_3 = {1'b0, (r_sys[95] ^ 1'b0)} + {1'b0, (r_par1[95] ^ 1'b0)};
    wire [8:0] cand_95_2_1 = pm_94_1 + {7'b0, bm_95_2_from_1};
    wire [8:0] cand_95_2_2 = pm_94_3 + {7'b0, bm_95_2_from_3};
    wire sel_95_2 = (cand_95_2_1 > cand_95_2_2); // 1 if cand2 better
    wire [8:0] pm_95_2 = sel_95_2 ? cand_95_2_2 : cand_95_2_1;
    wire surv_95_2 = sel_95_2;
    wire [1:0] bm_95_3_from_1 = {1'b0, (r_sys[95] ^ 1'b1)} + {1'b0, (r_par1[95] ^ 1'b0)};
    wire [1:0] bm_95_3_from_3 = {1'b0, (r_sys[95] ^ 1'b1)} + {1'b0, (r_par1[95] ^ 1'b1)};
    wire [8:0] cand_95_3_1 = pm_94_1 + {7'b0, bm_95_3_from_1};
    wire [8:0] cand_95_3_2 = pm_94_3 + {7'b0, bm_95_3_from_3};
    wire sel_95_3 = (cand_95_3_1 > cand_95_3_2); // 1 if cand2 better
    wire [8:0] pm_95_3 = sel_95_3 ? cand_95_3_2 : cand_95_3_1;
    wire surv_95_3 = sel_95_3;
    // Stage 96
    wire [1:0] bm_96_0_from_0 = {1'b0, (r_sys[96] ^ 1'b0)} + {1'b0, (r_par1[96] ^ 1'b0)};
    wire [1:0] bm_96_0_from_2 = {1'b0, (r_sys[96] ^ 1'b0)} + {1'b0, (r_par1[96] ^ 1'b1)};
    wire [8:0] cand_96_0_1 = pm_95_0 + {7'b0, bm_96_0_from_0};
    wire [8:0] cand_96_0_2 = pm_95_2 + {7'b0, bm_96_0_from_2};
    wire sel_96_0 = (cand_96_0_1 > cand_96_0_2); // 1 if cand2 better
    wire [8:0] pm_96_0 = sel_96_0 ? cand_96_0_2 : cand_96_0_1;
    wire surv_96_0 = sel_96_0;
    wire [1:0] bm_96_1_from_0 = {1'b0, (r_sys[96] ^ 1'b1)} + {1'b0, (r_par1[96] ^ 1'b1)};
    wire [1:0] bm_96_1_from_2 = {1'b0, (r_sys[96] ^ 1'b1)} + {1'b0, (r_par1[96] ^ 1'b0)};
    wire [8:0] cand_96_1_1 = pm_95_0 + {7'b0, bm_96_1_from_0};
    wire [8:0] cand_96_1_2 = pm_95_2 + {7'b0, bm_96_1_from_2};
    wire sel_96_1 = (cand_96_1_1 > cand_96_1_2); // 1 if cand2 better
    wire [8:0] pm_96_1 = sel_96_1 ? cand_96_1_2 : cand_96_1_1;
    wire surv_96_1 = sel_96_1;
    wire [1:0] bm_96_2_from_1 = {1'b0, (r_sys[96] ^ 1'b0)} + {1'b0, (r_par1[96] ^ 1'b1)};
    wire [1:0] bm_96_2_from_3 = {1'b0, (r_sys[96] ^ 1'b0)} + {1'b0, (r_par1[96] ^ 1'b0)};
    wire [8:0] cand_96_2_1 = pm_95_1 + {7'b0, bm_96_2_from_1};
    wire [8:0] cand_96_2_2 = pm_95_3 + {7'b0, bm_96_2_from_3};
    wire sel_96_2 = (cand_96_2_1 > cand_96_2_2); // 1 if cand2 better
    wire [8:0] pm_96_2 = sel_96_2 ? cand_96_2_2 : cand_96_2_1;
    wire surv_96_2 = sel_96_2;
    wire [1:0] bm_96_3_from_1 = {1'b0, (r_sys[96] ^ 1'b1)} + {1'b0, (r_par1[96] ^ 1'b0)};
    wire [1:0] bm_96_3_from_3 = {1'b0, (r_sys[96] ^ 1'b1)} + {1'b0, (r_par1[96] ^ 1'b1)};
    wire [8:0] cand_96_3_1 = pm_95_1 + {7'b0, bm_96_3_from_1};
    wire [8:0] cand_96_3_2 = pm_95_3 + {7'b0, bm_96_3_from_3};
    wire sel_96_3 = (cand_96_3_1 > cand_96_3_2); // 1 if cand2 better
    wire [8:0] pm_96_3 = sel_96_3 ? cand_96_3_2 : cand_96_3_1;
    wire surv_96_3 = sel_96_3;
    // Stage 97
    wire [1:0] bm_97_0_from_0 = {1'b0, (r_sys[97] ^ 1'b0)} + {1'b0, (r_par1[97] ^ 1'b0)};
    wire [1:0] bm_97_0_from_2 = {1'b0, (r_sys[97] ^ 1'b0)} + {1'b0, (r_par1[97] ^ 1'b1)};
    wire [8:0] cand_97_0_1 = pm_96_0 + {7'b0, bm_97_0_from_0};
    wire [8:0] cand_97_0_2 = pm_96_2 + {7'b0, bm_97_0_from_2};
    wire sel_97_0 = (cand_97_0_1 > cand_97_0_2); // 1 if cand2 better
    wire [8:0] pm_97_0 = sel_97_0 ? cand_97_0_2 : cand_97_0_1;
    wire surv_97_0 = sel_97_0;
    wire [1:0] bm_97_1_from_0 = {1'b0, (r_sys[97] ^ 1'b1)} + {1'b0, (r_par1[97] ^ 1'b1)};
    wire [1:0] bm_97_1_from_2 = {1'b0, (r_sys[97] ^ 1'b1)} + {1'b0, (r_par1[97] ^ 1'b0)};
    wire [8:0] cand_97_1_1 = pm_96_0 + {7'b0, bm_97_1_from_0};
    wire [8:0] cand_97_1_2 = pm_96_2 + {7'b0, bm_97_1_from_2};
    wire sel_97_1 = (cand_97_1_1 > cand_97_1_2); // 1 if cand2 better
    wire [8:0] pm_97_1 = sel_97_1 ? cand_97_1_2 : cand_97_1_1;
    wire surv_97_1 = sel_97_1;
    wire [1:0] bm_97_2_from_1 = {1'b0, (r_sys[97] ^ 1'b0)} + {1'b0, (r_par1[97] ^ 1'b1)};
    wire [1:0] bm_97_2_from_3 = {1'b0, (r_sys[97] ^ 1'b0)} + {1'b0, (r_par1[97] ^ 1'b0)};
    wire [8:0] cand_97_2_1 = pm_96_1 + {7'b0, bm_97_2_from_1};
    wire [8:0] cand_97_2_2 = pm_96_3 + {7'b0, bm_97_2_from_3};
    wire sel_97_2 = (cand_97_2_1 > cand_97_2_2); // 1 if cand2 better
    wire [8:0] pm_97_2 = sel_97_2 ? cand_97_2_2 : cand_97_2_1;
    wire surv_97_2 = sel_97_2;
    wire [1:0] bm_97_3_from_1 = {1'b0, (r_sys[97] ^ 1'b1)} + {1'b0, (r_par1[97] ^ 1'b0)};
    wire [1:0] bm_97_3_from_3 = {1'b0, (r_sys[97] ^ 1'b1)} + {1'b0, (r_par1[97] ^ 1'b1)};
    wire [8:0] cand_97_3_1 = pm_96_1 + {7'b0, bm_97_3_from_1};
    wire [8:0] cand_97_3_2 = pm_96_3 + {7'b0, bm_97_3_from_3};
    wire sel_97_3 = (cand_97_3_1 > cand_97_3_2); // 1 if cand2 better
    wire [8:0] pm_97_3 = sel_97_3 ? cand_97_3_2 : cand_97_3_1;
    wire surv_97_3 = sel_97_3;
    // Stage 98
    wire [1:0] bm_98_0_from_0 = {1'b0, (r_sys[98] ^ 1'b0)} + {1'b0, (r_par1[98] ^ 1'b0)};
    wire [1:0] bm_98_0_from_2 = {1'b0, (r_sys[98] ^ 1'b0)} + {1'b0, (r_par1[98] ^ 1'b1)};
    wire [8:0] cand_98_0_1 = pm_97_0 + {7'b0, bm_98_0_from_0};
    wire [8:0] cand_98_0_2 = pm_97_2 + {7'b0, bm_98_0_from_2};
    wire sel_98_0 = (cand_98_0_1 > cand_98_0_2); // 1 if cand2 better
    wire [8:0] pm_98_0 = sel_98_0 ? cand_98_0_2 : cand_98_0_1;
    wire surv_98_0 = sel_98_0;
    wire [1:0] bm_98_1_from_0 = {1'b0, (r_sys[98] ^ 1'b1)} + {1'b0, (r_par1[98] ^ 1'b1)};
    wire [1:0] bm_98_1_from_2 = {1'b0, (r_sys[98] ^ 1'b1)} + {1'b0, (r_par1[98] ^ 1'b0)};
    wire [8:0] cand_98_1_1 = pm_97_0 + {7'b0, bm_98_1_from_0};
    wire [8:0] cand_98_1_2 = pm_97_2 + {7'b0, bm_98_1_from_2};
    wire sel_98_1 = (cand_98_1_1 > cand_98_1_2); // 1 if cand2 better
    wire [8:0] pm_98_1 = sel_98_1 ? cand_98_1_2 : cand_98_1_1;
    wire surv_98_1 = sel_98_1;
    wire [1:0] bm_98_2_from_1 = {1'b0, (r_sys[98] ^ 1'b0)} + {1'b0, (r_par1[98] ^ 1'b1)};
    wire [1:0] bm_98_2_from_3 = {1'b0, (r_sys[98] ^ 1'b0)} + {1'b0, (r_par1[98] ^ 1'b0)};
    wire [8:0] cand_98_2_1 = pm_97_1 + {7'b0, bm_98_2_from_1};
    wire [8:0] cand_98_2_2 = pm_97_3 + {7'b0, bm_98_2_from_3};
    wire sel_98_2 = (cand_98_2_1 > cand_98_2_2); // 1 if cand2 better
    wire [8:0] pm_98_2 = sel_98_2 ? cand_98_2_2 : cand_98_2_1;
    wire surv_98_2 = sel_98_2;
    wire [1:0] bm_98_3_from_1 = {1'b0, (r_sys[98] ^ 1'b1)} + {1'b0, (r_par1[98] ^ 1'b0)};
    wire [1:0] bm_98_3_from_3 = {1'b0, (r_sys[98] ^ 1'b1)} + {1'b0, (r_par1[98] ^ 1'b1)};
    wire [8:0] cand_98_3_1 = pm_97_1 + {7'b0, bm_98_3_from_1};
    wire [8:0] cand_98_3_2 = pm_97_3 + {7'b0, bm_98_3_from_3};
    wire sel_98_3 = (cand_98_3_1 > cand_98_3_2); // 1 if cand2 better
    wire [8:0] pm_98_3 = sel_98_3 ? cand_98_3_2 : cand_98_3_1;
    wire surv_98_3 = sel_98_3;
    // Stage 99
    wire [1:0] bm_99_0_from_0 = {1'b0, (r_sys[99] ^ 1'b0)} + {1'b0, (r_par1[99] ^ 1'b0)};
    wire [1:0] bm_99_0_from_2 = {1'b0, (r_sys[99] ^ 1'b0)} + {1'b0, (r_par1[99] ^ 1'b1)};
    wire [8:0] cand_99_0_1 = pm_98_0 + {7'b0, bm_99_0_from_0};
    wire [8:0] cand_99_0_2 = pm_98_2 + {7'b0, bm_99_0_from_2};
    wire sel_99_0 = (cand_99_0_1 > cand_99_0_2); // 1 if cand2 better
    wire [8:0] pm_99_0 = sel_99_0 ? cand_99_0_2 : cand_99_0_1;
    wire surv_99_0 = sel_99_0;
    wire [1:0] bm_99_1_from_0 = {1'b0, (r_sys[99] ^ 1'b1)} + {1'b0, (r_par1[99] ^ 1'b1)};
    wire [1:0] bm_99_1_from_2 = {1'b0, (r_sys[99] ^ 1'b1)} + {1'b0, (r_par1[99] ^ 1'b0)};
    wire [8:0] cand_99_1_1 = pm_98_0 + {7'b0, bm_99_1_from_0};
    wire [8:0] cand_99_1_2 = pm_98_2 + {7'b0, bm_99_1_from_2};
    wire sel_99_1 = (cand_99_1_1 > cand_99_1_2); // 1 if cand2 better
    wire [8:0] pm_99_1 = sel_99_1 ? cand_99_1_2 : cand_99_1_1;
    wire surv_99_1 = sel_99_1;
    wire [1:0] bm_99_2_from_1 = {1'b0, (r_sys[99] ^ 1'b0)} + {1'b0, (r_par1[99] ^ 1'b1)};
    wire [1:0] bm_99_2_from_3 = {1'b0, (r_sys[99] ^ 1'b0)} + {1'b0, (r_par1[99] ^ 1'b0)};
    wire [8:0] cand_99_2_1 = pm_98_1 + {7'b0, bm_99_2_from_1};
    wire [8:0] cand_99_2_2 = pm_98_3 + {7'b0, bm_99_2_from_3};
    wire sel_99_2 = (cand_99_2_1 > cand_99_2_2); // 1 if cand2 better
    wire [8:0] pm_99_2 = sel_99_2 ? cand_99_2_2 : cand_99_2_1;
    wire surv_99_2 = sel_99_2;
    wire [1:0] bm_99_3_from_1 = {1'b0, (r_sys[99] ^ 1'b1)} + {1'b0, (r_par1[99] ^ 1'b0)};
    wire [1:0] bm_99_3_from_3 = {1'b0, (r_sys[99] ^ 1'b1)} + {1'b0, (r_par1[99] ^ 1'b1)};
    wire [8:0] cand_99_3_1 = pm_98_1 + {7'b0, bm_99_3_from_1};
    wire [8:0] cand_99_3_2 = pm_98_3 + {7'b0, bm_99_3_from_3};
    wire sel_99_3 = (cand_99_3_1 > cand_99_3_2); // 1 if cand2 better
    wire [8:0] pm_99_3 = sel_99_3 ? cand_99_3_2 : cand_99_3_1;
    wire surv_99_3 = sel_99_3;
    // Stage 100
    wire [1:0] bm_100_0_from_0 = {1'b0, (r_sys[100] ^ 1'b0)} + {1'b0, (r_par1[100] ^ 1'b0)};
    wire [1:0] bm_100_0_from_2 = {1'b0, (r_sys[100] ^ 1'b0)} + {1'b0, (r_par1[100] ^ 1'b1)};
    wire [8:0] cand_100_0_1 = pm_99_0 + {7'b0, bm_100_0_from_0};
    wire [8:0] cand_100_0_2 = pm_99_2 + {7'b0, bm_100_0_from_2};
    wire sel_100_0 = (cand_100_0_1 > cand_100_0_2); // 1 if cand2 better
    wire [8:0] pm_100_0 = sel_100_0 ? cand_100_0_2 : cand_100_0_1;
    wire surv_100_0 = sel_100_0;
    wire [1:0] bm_100_1_from_0 = {1'b0, (r_sys[100] ^ 1'b1)} + {1'b0, (r_par1[100] ^ 1'b1)};
    wire [1:0] bm_100_1_from_2 = {1'b0, (r_sys[100] ^ 1'b1)} + {1'b0, (r_par1[100] ^ 1'b0)};
    wire [8:0] cand_100_1_1 = pm_99_0 + {7'b0, bm_100_1_from_0};
    wire [8:0] cand_100_1_2 = pm_99_2 + {7'b0, bm_100_1_from_2};
    wire sel_100_1 = (cand_100_1_1 > cand_100_1_2); // 1 if cand2 better
    wire [8:0] pm_100_1 = sel_100_1 ? cand_100_1_2 : cand_100_1_1;
    wire surv_100_1 = sel_100_1;
    wire [1:0] bm_100_2_from_1 = {1'b0, (r_sys[100] ^ 1'b0)} + {1'b0, (r_par1[100] ^ 1'b1)};
    wire [1:0] bm_100_2_from_3 = {1'b0, (r_sys[100] ^ 1'b0)} + {1'b0, (r_par1[100] ^ 1'b0)};
    wire [8:0] cand_100_2_1 = pm_99_1 + {7'b0, bm_100_2_from_1};
    wire [8:0] cand_100_2_2 = pm_99_3 + {7'b0, bm_100_2_from_3};
    wire sel_100_2 = (cand_100_2_1 > cand_100_2_2); // 1 if cand2 better
    wire [8:0] pm_100_2 = sel_100_2 ? cand_100_2_2 : cand_100_2_1;
    wire surv_100_2 = sel_100_2;
    wire [1:0] bm_100_3_from_1 = {1'b0, (r_sys[100] ^ 1'b1)} + {1'b0, (r_par1[100] ^ 1'b0)};
    wire [1:0] bm_100_3_from_3 = {1'b0, (r_sys[100] ^ 1'b1)} + {1'b0, (r_par1[100] ^ 1'b1)};
    wire [8:0] cand_100_3_1 = pm_99_1 + {7'b0, bm_100_3_from_1};
    wire [8:0] cand_100_3_2 = pm_99_3 + {7'b0, bm_100_3_from_3};
    wire sel_100_3 = (cand_100_3_1 > cand_100_3_2); // 1 if cand2 better
    wire [8:0] pm_100_3 = sel_100_3 ? cand_100_3_2 : cand_100_3_1;
    wire surv_100_3 = sel_100_3;
    // Stage 101
    wire [1:0] bm_101_0_from_0 = {1'b0, (r_sys[101] ^ 1'b0)} + {1'b0, (r_par1[101] ^ 1'b0)};
    wire [1:0] bm_101_0_from_2 = {1'b0, (r_sys[101] ^ 1'b0)} + {1'b0, (r_par1[101] ^ 1'b1)};
    wire [8:0] cand_101_0_1 = pm_100_0 + {7'b0, bm_101_0_from_0};
    wire [8:0] cand_101_0_2 = pm_100_2 + {7'b0, bm_101_0_from_2};
    wire sel_101_0 = (cand_101_0_1 > cand_101_0_2); // 1 if cand2 better
    wire [8:0] pm_101_0 = sel_101_0 ? cand_101_0_2 : cand_101_0_1;
    wire surv_101_0 = sel_101_0;
    wire [1:0] bm_101_1_from_0 = {1'b0, (r_sys[101] ^ 1'b1)} + {1'b0, (r_par1[101] ^ 1'b1)};
    wire [1:0] bm_101_1_from_2 = {1'b0, (r_sys[101] ^ 1'b1)} + {1'b0, (r_par1[101] ^ 1'b0)};
    wire [8:0] cand_101_1_1 = pm_100_0 + {7'b0, bm_101_1_from_0};
    wire [8:0] cand_101_1_2 = pm_100_2 + {7'b0, bm_101_1_from_2};
    wire sel_101_1 = (cand_101_1_1 > cand_101_1_2); // 1 if cand2 better
    wire [8:0] pm_101_1 = sel_101_1 ? cand_101_1_2 : cand_101_1_1;
    wire surv_101_1 = sel_101_1;
    wire [1:0] bm_101_2_from_1 = {1'b0, (r_sys[101] ^ 1'b0)} + {1'b0, (r_par1[101] ^ 1'b1)};
    wire [1:0] bm_101_2_from_3 = {1'b0, (r_sys[101] ^ 1'b0)} + {1'b0, (r_par1[101] ^ 1'b0)};
    wire [8:0] cand_101_2_1 = pm_100_1 + {7'b0, bm_101_2_from_1};
    wire [8:0] cand_101_2_2 = pm_100_3 + {7'b0, bm_101_2_from_3};
    wire sel_101_2 = (cand_101_2_1 > cand_101_2_2); // 1 if cand2 better
    wire [8:0] pm_101_2 = sel_101_2 ? cand_101_2_2 : cand_101_2_1;
    wire surv_101_2 = sel_101_2;
    wire [1:0] bm_101_3_from_1 = {1'b0, (r_sys[101] ^ 1'b1)} + {1'b0, (r_par1[101] ^ 1'b0)};
    wire [1:0] bm_101_3_from_3 = {1'b0, (r_sys[101] ^ 1'b1)} + {1'b0, (r_par1[101] ^ 1'b1)};
    wire [8:0] cand_101_3_1 = pm_100_1 + {7'b0, bm_101_3_from_1};
    wire [8:0] cand_101_3_2 = pm_100_3 + {7'b0, bm_101_3_from_3};
    wire sel_101_3 = (cand_101_3_1 > cand_101_3_2); // 1 if cand2 better
    wire [8:0] pm_101_3 = sel_101_3 ? cand_101_3_2 : cand_101_3_1;
    wire surv_101_3 = sel_101_3;
    // Stage 102
    wire [1:0] bm_102_0_from_0 = {1'b0, (r_sys[102] ^ 1'b0)} + {1'b0, (r_par1[102] ^ 1'b0)};
    wire [1:0] bm_102_0_from_2 = {1'b0, (r_sys[102] ^ 1'b0)} + {1'b0, (r_par1[102] ^ 1'b1)};
    wire [8:0] cand_102_0_1 = pm_101_0 + {7'b0, bm_102_0_from_0};
    wire [8:0] cand_102_0_2 = pm_101_2 + {7'b0, bm_102_0_from_2};
    wire sel_102_0 = (cand_102_0_1 > cand_102_0_2); // 1 if cand2 better
    wire [8:0] pm_102_0 = sel_102_0 ? cand_102_0_2 : cand_102_0_1;
    wire surv_102_0 = sel_102_0;
    wire [1:0] bm_102_1_from_0 = {1'b0, (r_sys[102] ^ 1'b1)} + {1'b0, (r_par1[102] ^ 1'b1)};
    wire [1:0] bm_102_1_from_2 = {1'b0, (r_sys[102] ^ 1'b1)} + {1'b0, (r_par1[102] ^ 1'b0)};
    wire [8:0] cand_102_1_1 = pm_101_0 + {7'b0, bm_102_1_from_0};
    wire [8:0] cand_102_1_2 = pm_101_2 + {7'b0, bm_102_1_from_2};
    wire sel_102_1 = (cand_102_1_1 > cand_102_1_2); // 1 if cand2 better
    wire [8:0] pm_102_1 = sel_102_1 ? cand_102_1_2 : cand_102_1_1;
    wire surv_102_1 = sel_102_1;
    wire [1:0] bm_102_2_from_1 = {1'b0, (r_sys[102] ^ 1'b0)} + {1'b0, (r_par1[102] ^ 1'b1)};
    wire [1:0] bm_102_2_from_3 = {1'b0, (r_sys[102] ^ 1'b0)} + {1'b0, (r_par1[102] ^ 1'b0)};
    wire [8:0] cand_102_2_1 = pm_101_1 + {7'b0, bm_102_2_from_1};
    wire [8:0] cand_102_2_2 = pm_101_3 + {7'b0, bm_102_2_from_3};
    wire sel_102_2 = (cand_102_2_1 > cand_102_2_2); // 1 if cand2 better
    wire [8:0] pm_102_2 = sel_102_2 ? cand_102_2_2 : cand_102_2_1;
    wire surv_102_2 = sel_102_2;
    wire [1:0] bm_102_3_from_1 = {1'b0, (r_sys[102] ^ 1'b1)} + {1'b0, (r_par1[102] ^ 1'b0)};
    wire [1:0] bm_102_3_from_3 = {1'b0, (r_sys[102] ^ 1'b1)} + {1'b0, (r_par1[102] ^ 1'b1)};
    wire [8:0] cand_102_3_1 = pm_101_1 + {7'b0, bm_102_3_from_1};
    wire [8:0] cand_102_3_2 = pm_101_3 + {7'b0, bm_102_3_from_3};
    wire sel_102_3 = (cand_102_3_1 > cand_102_3_2); // 1 if cand2 better
    wire [8:0] pm_102_3 = sel_102_3 ? cand_102_3_2 : cand_102_3_1;
    wire surv_102_3 = sel_102_3;
    // Stage 103
    wire [1:0] bm_103_0_from_0 = {1'b0, (r_sys[103] ^ 1'b0)} + {1'b0, (r_par1[103] ^ 1'b0)};
    wire [1:0] bm_103_0_from_2 = {1'b0, (r_sys[103] ^ 1'b0)} + {1'b0, (r_par1[103] ^ 1'b1)};
    wire [8:0] cand_103_0_1 = pm_102_0 + {7'b0, bm_103_0_from_0};
    wire [8:0] cand_103_0_2 = pm_102_2 + {7'b0, bm_103_0_from_2};
    wire sel_103_0 = (cand_103_0_1 > cand_103_0_2); // 1 if cand2 better
    wire [8:0] pm_103_0 = sel_103_0 ? cand_103_0_2 : cand_103_0_1;
    wire surv_103_0 = sel_103_0;
    wire [1:0] bm_103_1_from_0 = {1'b0, (r_sys[103] ^ 1'b1)} + {1'b0, (r_par1[103] ^ 1'b1)};
    wire [1:0] bm_103_1_from_2 = {1'b0, (r_sys[103] ^ 1'b1)} + {1'b0, (r_par1[103] ^ 1'b0)};
    wire [8:0] cand_103_1_1 = pm_102_0 + {7'b0, bm_103_1_from_0};
    wire [8:0] cand_103_1_2 = pm_102_2 + {7'b0, bm_103_1_from_2};
    wire sel_103_1 = (cand_103_1_1 > cand_103_1_2); // 1 if cand2 better
    wire [8:0] pm_103_1 = sel_103_1 ? cand_103_1_2 : cand_103_1_1;
    wire surv_103_1 = sel_103_1;
    wire [1:0] bm_103_2_from_1 = {1'b0, (r_sys[103] ^ 1'b0)} + {1'b0, (r_par1[103] ^ 1'b1)};
    wire [1:0] bm_103_2_from_3 = {1'b0, (r_sys[103] ^ 1'b0)} + {1'b0, (r_par1[103] ^ 1'b0)};
    wire [8:0] cand_103_2_1 = pm_102_1 + {7'b0, bm_103_2_from_1};
    wire [8:0] cand_103_2_2 = pm_102_3 + {7'b0, bm_103_2_from_3};
    wire sel_103_2 = (cand_103_2_1 > cand_103_2_2); // 1 if cand2 better
    wire [8:0] pm_103_2 = sel_103_2 ? cand_103_2_2 : cand_103_2_1;
    wire surv_103_2 = sel_103_2;
    wire [1:0] bm_103_3_from_1 = {1'b0, (r_sys[103] ^ 1'b1)} + {1'b0, (r_par1[103] ^ 1'b0)};
    wire [1:0] bm_103_3_from_3 = {1'b0, (r_sys[103] ^ 1'b1)} + {1'b0, (r_par1[103] ^ 1'b1)};
    wire [8:0] cand_103_3_1 = pm_102_1 + {7'b0, bm_103_3_from_1};
    wire [8:0] cand_103_3_2 = pm_102_3 + {7'b0, bm_103_3_from_3};
    wire sel_103_3 = (cand_103_3_1 > cand_103_3_2); // 1 if cand2 better
    wire [8:0] pm_103_3 = sel_103_3 ? cand_103_3_2 : cand_103_3_1;
    wire surv_103_3 = sel_103_3;
    // Stage 104
    wire [1:0] bm_104_0_from_0 = {1'b0, (r_sys[104] ^ 1'b0)} + {1'b0, (r_par1[104] ^ 1'b0)};
    wire [1:0] bm_104_0_from_2 = {1'b0, (r_sys[104] ^ 1'b0)} + {1'b0, (r_par1[104] ^ 1'b1)};
    wire [8:0] cand_104_0_1 = pm_103_0 + {7'b0, bm_104_0_from_0};
    wire [8:0] cand_104_0_2 = pm_103_2 + {7'b0, bm_104_0_from_2};
    wire sel_104_0 = (cand_104_0_1 > cand_104_0_2); // 1 if cand2 better
    wire [8:0] pm_104_0 = sel_104_0 ? cand_104_0_2 : cand_104_0_1;
    wire surv_104_0 = sel_104_0;
    wire [1:0] bm_104_1_from_0 = {1'b0, (r_sys[104] ^ 1'b1)} + {1'b0, (r_par1[104] ^ 1'b1)};
    wire [1:0] bm_104_1_from_2 = {1'b0, (r_sys[104] ^ 1'b1)} + {1'b0, (r_par1[104] ^ 1'b0)};
    wire [8:0] cand_104_1_1 = pm_103_0 + {7'b0, bm_104_1_from_0};
    wire [8:0] cand_104_1_2 = pm_103_2 + {7'b0, bm_104_1_from_2};
    wire sel_104_1 = (cand_104_1_1 > cand_104_1_2); // 1 if cand2 better
    wire [8:0] pm_104_1 = sel_104_1 ? cand_104_1_2 : cand_104_1_1;
    wire surv_104_1 = sel_104_1;
    wire [1:0] bm_104_2_from_1 = {1'b0, (r_sys[104] ^ 1'b0)} + {1'b0, (r_par1[104] ^ 1'b1)};
    wire [1:0] bm_104_2_from_3 = {1'b0, (r_sys[104] ^ 1'b0)} + {1'b0, (r_par1[104] ^ 1'b0)};
    wire [8:0] cand_104_2_1 = pm_103_1 + {7'b0, bm_104_2_from_1};
    wire [8:0] cand_104_2_2 = pm_103_3 + {7'b0, bm_104_2_from_3};
    wire sel_104_2 = (cand_104_2_1 > cand_104_2_2); // 1 if cand2 better
    wire [8:0] pm_104_2 = sel_104_2 ? cand_104_2_2 : cand_104_2_1;
    wire surv_104_2 = sel_104_2;
    wire [1:0] bm_104_3_from_1 = {1'b0, (r_sys[104] ^ 1'b1)} + {1'b0, (r_par1[104] ^ 1'b0)};
    wire [1:0] bm_104_3_from_3 = {1'b0, (r_sys[104] ^ 1'b1)} + {1'b0, (r_par1[104] ^ 1'b1)};
    wire [8:0] cand_104_3_1 = pm_103_1 + {7'b0, bm_104_3_from_1};
    wire [8:0] cand_104_3_2 = pm_103_3 + {7'b0, bm_104_3_from_3};
    wire sel_104_3 = (cand_104_3_1 > cand_104_3_2); // 1 if cand2 better
    wire [8:0] pm_104_3 = sel_104_3 ? cand_104_3_2 : cand_104_3_1;
    wire surv_104_3 = sel_104_3;
    // Stage 105
    wire [1:0] bm_105_0_from_0 = {1'b0, (r_sys[105] ^ 1'b0)} + {1'b0, (r_par1[105] ^ 1'b0)};
    wire [1:0] bm_105_0_from_2 = {1'b0, (r_sys[105] ^ 1'b0)} + {1'b0, (r_par1[105] ^ 1'b1)};
    wire [8:0] cand_105_0_1 = pm_104_0 + {7'b0, bm_105_0_from_0};
    wire [8:0] cand_105_0_2 = pm_104_2 + {7'b0, bm_105_0_from_2};
    wire sel_105_0 = (cand_105_0_1 > cand_105_0_2); // 1 if cand2 better
    wire [8:0] pm_105_0 = sel_105_0 ? cand_105_0_2 : cand_105_0_1;
    wire surv_105_0 = sel_105_0;
    wire [1:0] bm_105_1_from_0 = {1'b0, (r_sys[105] ^ 1'b1)} + {1'b0, (r_par1[105] ^ 1'b1)};
    wire [1:0] bm_105_1_from_2 = {1'b0, (r_sys[105] ^ 1'b1)} + {1'b0, (r_par1[105] ^ 1'b0)};
    wire [8:0] cand_105_1_1 = pm_104_0 + {7'b0, bm_105_1_from_0};
    wire [8:0] cand_105_1_2 = pm_104_2 + {7'b0, bm_105_1_from_2};
    wire sel_105_1 = (cand_105_1_1 > cand_105_1_2); // 1 if cand2 better
    wire [8:0] pm_105_1 = sel_105_1 ? cand_105_1_2 : cand_105_1_1;
    wire surv_105_1 = sel_105_1;
    wire [1:0] bm_105_2_from_1 = {1'b0, (r_sys[105] ^ 1'b0)} + {1'b0, (r_par1[105] ^ 1'b1)};
    wire [1:0] bm_105_2_from_3 = {1'b0, (r_sys[105] ^ 1'b0)} + {1'b0, (r_par1[105] ^ 1'b0)};
    wire [8:0] cand_105_2_1 = pm_104_1 + {7'b0, bm_105_2_from_1};
    wire [8:0] cand_105_2_2 = pm_104_3 + {7'b0, bm_105_2_from_3};
    wire sel_105_2 = (cand_105_2_1 > cand_105_2_2); // 1 if cand2 better
    wire [8:0] pm_105_2 = sel_105_2 ? cand_105_2_2 : cand_105_2_1;
    wire surv_105_2 = sel_105_2;
    wire [1:0] bm_105_3_from_1 = {1'b0, (r_sys[105] ^ 1'b1)} + {1'b0, (r_par1[105] ^ 1'b0)};
    wire [1:0] bm_105_3_from_3 = {1'b0, (r_sys[105] ^ 1'b1)} + {1'b0, (r_par1[105] ^ 1'b1)};
    wire [8:0] cand_105_3_1 = pm_104_1 + {7'b0, bm_105_3_from_1};
    wire [8:0] cand_105_3_2 = pm_104_3 + {7'b0, bm_105_3_from_3};
    wire sel_105_3 = (cand_105_3_1 > cand_105_3_2); // 1 if cand2 better
    wire [8:0] pm_105_3 = sel_105_3 ? cand_105_3_2 : cand_105_3_1;
    wire surv_105_3 = sel_105_3;
    // Stage 106
    wire [1:0] bm_106_0_from_0 = {1'b0, (r_sys[106] ^ 1'b0)} + {1'b0, (r_par1[106] ^ 1'b0)};
    wire [1:0] bm_106_0_from_2 = {1'b0, (r_sys[106] ^ 1'b0)} + {1'b0, (r_par1[106] ^ 1'b1)};
    wire [8:0] cand_106_0_1 = pm_105_0 + {7'b0, bm_106_0_from_0};
    wire [8:0] cand_106_0_2 = pm_105_2 + {7'b0, bm_106_0_from_2};
    wire sel_106_0 = (cand_106_0_1 > cand_106_0_2); // 1 if cand2 better
    wire [8:0] pm_106_0 = sel_106_0 ? cand_106_0_2 : cand_106_0_1;
    wire surv_106_0 = sel_106_0;
    wire [1:0] bm_106_1_from_0 = {1'b0, (r_sys[106] ^ 1'b1)} + {1'b0, (r_par1[106] ^ 1'b1)};
    wire [1:0] bm_106_1_from_2 = {1'b0, (r_sys[106] ^ 1'b1)} + {1'b0, (r_par1[106] ^ 1'b0)};
    wire [8:0] cand_106_1_1 = pm_105_0 + {7'b0, bm_106_1_from_0};
    wire [8:0] cand_106_1_2 = pm_105_2 + {7'b0, bm_106_1_from_2};
    wire sel_106_1 = (cand_106_1_1 > cand_106_1_2); // 1 if cand2 better
    wire [8:0] pm_106_1 = sel_106_1 ? cand_106_1_2 : cand_106_1_1;
    wire surv_106_1 = sel_106_1;
    wire [1:0] bm_106_2_from_1 = {1'b0, (r_sys[106] ^ 1'b0)} + {1'b0, (r_par1[106] ^ 1'b1)};
    wire [1:0] bm_106_2_from_3 = {1'b0, (r_sys[106] ^ 1'b0)} + {1'b0, (r_par1[106] ^ 1'b0)};
    wire [8:0] cand_106_2_1 = pm_105_1 + {7'b0, bm_106_2_from_1};
    wire [8:0] cand_106_2_2 = pm_105_3 + {7'b0, bm_106_2_from_3};
    wire sel_106_2 = (cand_106_2_1 > cand_106_2_2); // 1 if cand2 better
    wire [8:0] pm_106_2 = sel_106_2 ? cand_106_2_2 : cand_106_2_1;
    wire surv_106_2 = sel_106_2;
    wire [1:0] bm_106_3_from_1 = {1'b0, (r_sys[106] ^ 1'b1)} + {1'b0, (r_par1[106] ^ 1'b0)};
    wire [1:0] bm_106_3_from_3 = {1'b0, (r_sys[106] ^ 1'b1)} + {1'b0, (r_par1[106] ^ 1'b1)};
    wire [8:0] cand_106_3_1 = pm_105_1 + {7'b0, bm_106_3_from_1};
    wire [8:0] cand_106_3_2 = pm_105_3 + {7'b0, bm_106_3_from_3};
    wire sel_106_3 = (cand_106_3_1 > cand_106_3_2); // 1 if cand2 better
    wire [8:0] pm_106_3 = sel_106_3 ? cand_106_3_2 : cand_106_3_1;
    wire surv_106_3 = sel_106_3;
    // Stage 107
    wire [1:0] bm_107_0_from_0 = {1'b0, (r_sys[107] ^ 1'b0)} + {1'b0, (r_par1[107] ^ 1'b0)};
    wire [1:0] bm_107_0_from_2 = {1'b0, (r_sys[107] ^ 1'b0)} + {1'b0, (r_par1[107] ^ 1'b1)};
    wire [8:0] cand_107_0_1 = pm_106_0 + {7'b0, bm_107_0_from_0};
    wire [8:0] cand_107_0_2 = pm_106_2 + {7'b0, bm_107_0_from_2};
    wire sel_107_0 = (cand_107_0_1 > cand_107_0_2); // 1 if cand2 better
    wire [8:0] pm_107_0 = sel_107_0 ? cand_107_0_2 : cand_107_0_1;
    wire surv_107_0 = sel_107_0;
    wire [1:0] bm_107_1_from_0 = {1'b0, (r_sys[107] ^ 1'b1)} + {1'b0, (r_par1[107] ^ 1'b1)};
    wire [1:0] bm_107_1_from_2 = {1'b0, (r_sys[107] ^ 1'b1)} + {1'b0, (r_par1[107] ^ 1'b0)};
    wire [8:0] cand_107_1_1 = pm_106_0 + {7'b0, bm_107_1_from_0};
    wire [8:0] cand_107_1_2 = pm_106_2 + {7'b0, bm_107_1_from_2};
    wire sel_107_1 = (cand_107_1_1 > cand_107_1_2); // 1 if cand2 better
    wire [8:0] pm_107_1 = sel_107_1 ? cand_107_1_2 : cand_107_1_1;
    wire surv_107_1 = sel_107_1;
    wire [1:0] bm_107_2_from_1 = {1'b0, (r_sys[107] ^ 1'b0)} + {1'b0, (r_par1[107] ^ 1'b1)};
    wire [1:0] bm_107_2_from_3 = {1'b0, (r_sys[107] ^ 1'b0)} + {1'b0, (r_par1[107] ^ 1'b0)};
    wire [8:0] cand_107_2_1 = pm_106_1 + {7'b0, bm_107_2_from_1};
    wire [8:0] cand_107_2_2 = pm_106_3 + {7'b0, bm_107_2_from_3};
    wire sel_107_2 = (cand_107_2_1 > cand_107_2_2); // 1 if cand2 better
    wire [8:0] pm_107_2 = sel_107_2 ? cand_107_2_2 : cand_107_2_1;
    wire surv_107_2 = sel_107_2;
    wire [1:0] bm_107_3_from_1 = {1'b0, (r_sys[107] ^ 1'b1)} + {1'b0, (r_par1[107] ^ 1'b0)};
    wire [1:0] bm_107_3_from_3 = {1'b0, (r_sys[107] ^ 1'b1)} + {1'b0, (r_par1[107] ^ 1'b1)};
    wire [8:0] cand_107_3_1 = pm_106_1 + {7'b0, bm_107_3_from_1};
    wire [8:0] cand_107_3_2 = pm_106_3 + {7'b0, bm_107_3_from_3};
    wire sel_107_3 = (cand_107_3_1 > cand_107_3_2); // 1 if cand2 better
    wire [8:0] pm_107_3 = sel_107_3 ? cand_107_3_2 : cand_107_3_1;
    wire surv_107_3 = sel_107_3;
    // Stage 108
    wire [1:0] bm_108_0_from_0 = {1'b0, (r_sys[108] ^ 1'b0)} + {1'b0, (r_par1[108] ^ 1'b0)};
    wire [1:0] bm_108_0_from_2 = {1'b0, (r_sys[108] ^ 1'b0)} + {1'b0, (r_par1[108] ^ 1'b1)};
    wire [8:0] cand_108_0_1 = pm_107_0 + {7'b0, bm_108_0_from_0};
    wire [8:0] cand_108_0_2 = pm_107_2 + {7'b0, bm_108_0_from_2};
    wire sel_108_0 = (cand_108_0_1 > cand_108_0_2); // 1 if cand2 better
    wire [8:0] pm_108_0 = sel_108_0 ? cand_108_0_2 : cand_108_0_1;
    wire surv_108_0 = sel_108_0;
    wire [1:0] bm_108_1_from_0 = {1'b0, (r_sys[108] ^ 1'b1)} + {1'b0, (r_par1[108] ^ 1'b1)};
    wire [1:0] bm_108_1_from_2 = {1'b0, (r_sys[108] ^ 1'b1)} + {1'b0, (r_par1[108] ^ 1'b0)};
    wire [8:0] cand_108_1_1 = pm_107_0 + {7'b0, bm_108_1_from_0};
    wire [8:0] cand_108_1_2 = pm_107_2 + {7'b0, bm_108_1_from_2};
    wire sel_108_1 = (cand_108_1_1 > cand_108_1_2); // 1 if cand2 better
    wire [8:0] pm_108_1 = sel_108_1 ? cand_108_1_2 : cand_108_1_1;
    wire surv_108_1 = sel_108_1;
    wire [1:0] bm_108_2_from_1 = {1'b0, (r_sys[108] ^ 1'b0)} + {1'b0, (r_par1[108] ^ 1'b1)};
    wire [1:0] bm_108_2_from_3 = {1'b0, (r_sys[108] ^ 1'b0)} + {1'b0, (r_par1[108] ^ 1'b0)};
    wire [8:0] cand_108_2_1 = pm_107_1 + {7'b0, bm_108_2_from_1};
    wire [8:0] cand_108_2_2 = pm_107_3 + {7'b0, bm_108_2_from_3};
    wire sel_108_2 = (cand_108_2_1 > cand_108_2_2); // 1 if cand2 better
    wire [8:0] pm_108_2 = sel_108_2 ? cand_108_2_2 : cand_108_2_1;
    wire surv_108_2 = sel_108_2;
    wire [1:0] bm_108_3_from_1 = {1'b0, (r_sys[108] ^ 1'b1)} + {1'b0, (r_par1[108] ^ 1'b0)};
    wire [1:0] bm_108_3_from_3 = {1'b0, (r_sys[108] ^ 1'b1)} + {1'b0, (r_par1[108] ^ 1'b1)};
    wire [8:0] cand_108_3_1 = pm_107_1 + {7'b0, bm_108_3_from_1};
    wire [8:0] cand_108_3_2 = pm_107_3 + {7'b0, bm_108_3_from_3};
    wire sel_108_3 = (cand_108_3_1 > cand_108_3_2); // 1 if cand2 better
    wire [8:0] pm_108_3 = sel_108_3 ? cand_108_3_2 : cand_108_3_1;
    wire surv_108_3 = sel_108_3;
    // Stage 109
    wire [1:0] bm_109_0_from_0 = {1'b0, (r_sys[109] ^ 1'b0)} + {1'b0, (r_par1[109] ^ 1'b0)};
    wire [1:0] bm_109_0_from_2 = {1'b0, (r_sys[109] ^ 1'b0)} + {1'b0, (r_par1[109] ^ 1'b1)};
    wire [8:0] cand_109_0_1 = pm_108_0 + {7'b0, bm_109_0_from_0};
    wire [8:0] cand_109_0_2 = pm_108_2 + {7'b0, bm_109_0_from_2};
    wire sel_109_0 = (cand_109_0_1 > cand_109_0_2); // 1 if cand2 better
    wire [8:0] pm_109_0 = sel_109_0 ? cand_109_0_2 : cand_109_0_1;
    wire surv_109_0 = sel_109_0;
    wire [1:0] bm_109_1_from_0 = {1'b0, (r_sys[109] ^ 1'b1)} + {1'b0, (r_par1[109] ^ 1'b1)};
    wire [1:0] bm_109_1_from_2 = {1'b0, (r_sys[109] ^ 1'b1)} + {1'b0, (r_par1[109] ^ 1'b0)};
    wire [8:0] cand_109_1_1 = pm_108_0 + {7'b0, bm_109_1_from_0};
    wire [8:0] cand_109_1_2 = pm_108_2 + {7'b0, bm_109_1_from_2};
    wire sel_109_1 = (cand_109_1_1 > cand_109_1_2); // 1 if cand2 better
    wire [8:0] pm_109_1 = sel_109_1 ? cand_109_1_2 : cand_109_1_1;
    wire surv_109_1 = sel_109_1;
    wire [1:0] bm_109_2_from_1 = {1'b0, (r_sys[109] ^ 1'b0)} + {1'b0, (r_par1[109] ^ 1'b1)};
    wire [1:0] bm_109_2_from_3 = {1'b0, (r_sys[109] ^ 1'b0)} + {1'b0, (r_par1[109] ^ 1'b0)};
    wire [8:0] cand_109_2_1 = pm_108_1 + {7'b0, bm_109_2_from_1};
    wire [8:0] cand_109_2_2 = pm_108_3 + {7'b0, bm_109_2_from_3};
    wire sel_109_2 = (cand_109_2_1 > cand_109_2_2); // 1 if cand2 better
    wire [8:0] pm_109_2 = sel_109_2 ? cand_109_2_2 : cand_109_2_1;
    wire surv_109_2 = sel_109_2;
    wire [1:0] bm_109_3_from_1 = {1'b0, (r_sys[109] ^ 1'b1)} + {1'b0, (r_par1[109] ^ 1'b0)};
    wire [1:0] bm_109_3_from_3 = {1'b0, (r_sys[109] ^ 1'b1)} + {1'b0, (r_par1[109] ^ 1'b1)};
    wire [8:0] cand_109_3_1 = pm_108_1 + {7'b0, bm_109_3_from_1};
    wire [8:0] cand_109_3_2 = pm_108_3 + {7'b0, bm_109_3_from_3};
    wire sel_109_3 = (cand_109_3_1 > cand_109_3_2); // 1 if cand2 better
    wire [8:0] pm_109_3 = sel_109_3 ? cand_109_3_2 : cand_109_3_1;
    wire surv_109_3 = sel_109_3;
    // Stage 110
    wire [1:0] bm_110_0_from_0 = {1'b0, (r_sys[110] ^ 1'b0)} + {1'b0, (r_par1[110] ^ 1'b0)};
    wire [1:0] bm_110_0_from_2 = {1'b0, (r_sys[110] ^ 1'b0)} + {1'b0, (r_par1[110] ^ 1'b1)};
    wire [8:0] cand_110_0_1 = pm_109_0 + {7'b0, bm_110_0_from_0};
    wire [8:0] cand_110_0_2 = pm_109_2 + {7'b0, bm_110_0_from_2};
    wire sel_110_0 = (cand_110_0_1 > cand_110_0_2); // 1 if cand2 better
    wire [8:0] pm_110_0 = sel_110_0 ? cand_110_0_2 : cand_110_0_1;
    wire surv_110_0 = sel_110_0;
    wire [1:0] bm_110_1_from_0 = {1'b0, (r_sys[110] ^ 1'b1)} + {1'b0, (r_par1[110] ^ 1'b1)};
    wire [1:0] bm_110_1_from_2 = {1'b0, (r_sys[110] ^ 1'b1)} + {1'b0, (r_par1[110] ^ 1'b0)};
    wire [8:0] cand_110_1_1 = pm_109_0 + {7'b0, bm_110_1_from_0};
    wire [8:0] cand_110_1_2 = pm_109_2 + {7'b0, bm_110_1_from_2};
    wire sel_110_1 = (cand_110_1_1 > cand_110_1_2); // 1 if cand2 better
    wire [8:0] pm_110_1 = sel_110_1 ? cand_110_1_2 : cand_110_1_1;
    wire surv_110_1 = sel_110_1;
    wire [1:0] bm_110_2_from_1 = {1'b0, (r_sys[110] ^ 1'b0)} + {1'b0, (r_par1[110] ^ 1'b1)};
    wire [1:0] bm_110_2_from_3 = {1'b0, (r_sys[110] ^ 1'b0)} + {1'b0, (r_par1[110] ^ 1'b0)};
    wire [8:0] cand_110_2_1 = pm_109_1 + {7'b0, bm_110_2_from_1};
    wire [8:0] cand_110_2_2 = pm_109_3 + {7'b0, bm_110_2_from_3};
    wire sel_110_2 = (cand_110_2_1 > cand_110_2_2); // 1 if cand2 better
    wire [8:0] pm_110_2 = sel_110_2 ? cand_110_2_2 : cand_110_2_1;
    wire surv_110_2 = sel_110_2;
    wire [1:0] bm_110_3_from_1 = {1'b0, (r_sys[110] ^ 1'b1)} + {1'b0, (r_par1[110] ^ 1'b0)};
    wire [1:0] bm_110_3_from_3 = {1'b0, (r_sys[110] ^ 1'b1)} + {1'b0, (r_par1[110] ^ 1'b1)};
    wire [8:0] cand_110_3_1 = pm_109_1 + {7'b0, bm_110_3_from_1};
    wire [8:0] cand_110_3_2 = pm_109_3 + {7'b0, bm_110_3_from_3};
    wire sel_110_3 = (cand_110_3_1 > cand_110_3_2); // 1 if cand2 better
    wire [8:0] pm_110_3 = sel_110_3 ? cand_110_3_2 : cand_110_3_1;
    wire surv_110_3 = sel_110_3;
    // Stage 111
    wire [1:0] bm_111_0_from_0 = {1'b0, (r_sys[111] ^ 1'b0)} + {1'b0, (r_par1[111] ^ 1'b0)};
    wire [1:0] bm_111_0_from_2 = {1'b0, (r_sys[111] ^ 1'b0)} + {1'b0, (r_par1[111] ^ 1'b1)};
    wire [8:0] cand_111_0_1 = pm_110_0 + {7'b0, bm_111_0_from_0};
    wire [8:0] cand_111_0_2 = pm_110_2 + {7'b0, bm_111_0_from_2};
    wire sel_111_0 = (cand_111_0_1 > cand_111_0_2); // 1 if cand2 better
    wire [8:0] pm_111_0 = sel_111_0 ? cand_111_0_2 : cand_111_0_1;
    wire surv_111_0 = sel_111_0;
    wire [1:0] bm_111_1_from_0 = {1'b0, (r_sys[111] ^ 1'b1)} + {1'b0, (r_par1[111] ^ 1'b1)};
    wire [1:0] bm_111_1_from_2 = {1'b0, (r_sys[111] ^ 1'b1)} + {1'b0, (r_par1[111] ^ 1'b0)};
    wire [8:0] cand_111_1_1 = pm_110_0 + {7'b0, bm_111_1_from_0};
    wire [8:0] cand_111_1_2 = pm_110_2 + {7'b0, bm_111_1_from_2};
    wire sel_111_1 = (cand_111_1_1 > cand_111_1_2); // 1 if cand2 better
    wire [8:0] pm_111_1 = sel_111_1 ? cand_111_1_2 : cand_111_1_1;
    wire surv_111_1 = sel_111_1;
    wire [1:0] bm_111_2_from_1 = {1'b0, (r_sys[111] ^ 1'b0)} + {1'b0, (r_par1[111] ^ 1'b1)};
    wire [1:0] bm_111_2_from_3 = {1'b0, (r_sys[111] ^ 1'b0)} + {1'b0, (r_par1[111] ^ 1'b0)};
    wire [8:0] cand_111_2_1 = pm_110_1 + {7'b0, bm_111_2_from_1};
    wire [8:0] cand_111_2_2 = pm_110_3 + {7'b0, bm_111_2_from_3};
    wire sel_111_2 = (cand_111_2_1 > cand_111_2_2); // 1 if cand2 better
    wire [8:0] pm_111_2 = sel_111_2 ? cand_111_2_2 : cand_111_2_1;
    wire surv_111_2 = sel_111_2;
    wire [1:0] bm_111_3_from_1 = {1'b0, (r_sys[111] ^ 1'b1)} + {1'b0, (r_par1[111] ^ 1'b0)};
    wire [1:0] bm_111_3_from_3 = {1'b0, (r_sys[111] ^ 1'b1)} + {1'b0, (r_par1[111] ^ 1'b1)};
    wire [8:0] cand_111_3_1 = pm_110_1 + {7'b0, bm_111_3_from_1};
    wire [8:0] cand_111_3_2 = pm_110_3 + {7'b0, bm_111_3_from_3};
    wire sel_111_3 = (cand_111_3_1 > cand_111_3_2); // 1 if cand2 better
    wire [8:0] pm_111_3 = sel_111_3 ? cand_111_3_2 : cand_111_3_1;
    wire surv_111_3 = sel_111_3;
    // Stage 112
    wire [1:0] bm_112_0_from_0 = {1'b0, (r_sys[112] ^ 1'b0)} + {1'b0, (r_par1[112] ^ 1'b0)};
    wire [1:0] bm_112_0_from_2 = {1'b0, (r_sys[112] ^ 1'b0)} + {1'b0, (r_par1[112] ^ 1'b1)};
    wire [8:0] cand_112_0_1 = pm_111_0 + {7'b0, bm_112_0_from_0};
    wire [8:0] cand_112_0_2 = pm_111_2 + {7'b0, bm_112_0_from_2};
    wire sel_112_0 = (cand_112_0_1 > cand_112_0_2); // 1 if cand2 better
    wire [8:0] pm_112_0 = sel_112_0 ? cand_112_0_2 : cand_112_0_1;
    wire surv_112_0 = sel_112_0;
    wire [1:0] bm_112_1_from_0 = {1'b0, (r_sys[112] ^ 1'b1)} + {1'b0, (r_par1[112] ^ 1'b1)};
    wire [1:0] bm_112_1_from_2 = {1'b0, (r_sys[112] ^ 1'b1)} + {1'b0, (r_par1[112] ^ 1'b0)};
    wire [8:0] cand_112_1_1 = pm_111_0 + {7'b0, bm_112_1_from_0};
    wire [8:0] cand_112_1_2 = pm_111_2 + {7'b0, bm_112_1_from_2};
    wire sel_112_1 = (cand_112_1_1 > cand_112_1_2); // 1 if cand2 better
    wire [8:0] pm_112_1 = sel_112_1 ? cand_112_1_2 : cand_112_1_1;
    wire surv_112_1 = sel_112_1;
    wire [1:0] bm_112_2_from_1 = {1'b0, (r_sys[112] ^ 1'b0)} + {1'b0, (r_par1[112] ^ 1'b1)};
    wire [1:0] bm_112_2_from_3 = {1'b0, (r_sys[112] ^ 1'b0)} + {1'b0, (r_par1[112] ^ 1'b0)};
    wire [8:0] cand_112_2_1 = pm_111_1 + {7'b0, bm_112_2_from_1};
    wire [8:0] cand_112_2_2 = pm_111_3 + {7'b0, bm_112_2_from_3};
    wire sel_112_2 = (cand_112_2_1 > cand_112_2_2); // 1 if cand2 better
    wire [8:0] pm_112_2 = sel_112_2 ? cand_112_2_2 : cand_112_2_1;
    wire surv_112_2 = sel_112_2;
    wire [1:0] bm_112_3_from_1 = {1'b0, (r_sys[112] ^ 1'b1)} + {1'b0, (r_par1[112] ^ 1'b0)};
    wire [1:0] bm_112_3_from_3 = {1'b0, (r_sys[112] ^ 1'b1)} + {1'b0, (r_par1[112] ^ 1'b1)};
    wire [8:0] cand_112_3_1 = pm_111_1 + {7'b0, bm_112_3_from_1};
    wire [8:0] cand_112_3_2 = pm_111_3 + {7'b0, bm_112_3_from_3};
    wire sel_112_3 = (cand_112_3_1 > cand_112_3_2); // 1 if cand2 better
    wire [8:0] pm_112_3 = sel_112_3 ? cand_112_3_2 : cand_112_3_1;
    wire surv_112_3 = sel_112_3;
    // Stage 113
    wire [1:0] bm_113_0_from_0 = {1'b0, (r_sys[113] ^ 1'b0)} + {1'b0, (r_par1[113] ^ 1'b0)};
    wire [1:0] bm_113_0_from_2 = {1'b0, (r_sys[113] ^ 1'b0)} + {1'b0, (r_par1[113] ^ 1'b1)};
    wire [8:0] cand_113_0_1 = pm_112_0 + {7'b0, bm_113_0_from_0};
    wire [8:0] cand_113_0_2 = pm_112_2 + {7'b0, bm_113_0_from_2};
    wire sel_113_0 = (cand_113_0_1 > cand_113_0_2); // 1 if cand2 better
    wire [8:0] pm_113_0 = sel_113_0 ? cand_113_0_2 : cand_113_0_1;
    wire surv_113_0 = sel_113_0;
    wire [1:0] bm_113_1_from_0 = {1'b0, (r_sys[113] ^ 1'b1)} + {1'b0, (r_par1[113] ^ 1'b1)};
    wire [1:0] bm_113_1_from_2 = {1'b0, (r_sys[113] ^ 1'b1)} + {1'b0, (r_par1[113] ^ 1'b0)};
    wire [8:0] cand_113_1_1 = pm_112_0 + {7'b0, bm_113_1_from_0};
    wire [8:0] cand_113_1_2 = pm_112_2 + {7'b0, bm_113_1_from_2};
    wire sel_113_1 = (cand_113_1_1 > cand_113_1_2); // 1 if cand2 better
    wire [8:0] pm_113_1 = sel_113_1 ? cand_113_1_2 : cand_113_1_1;
    wire surv_113_1 = sel_113_1;
    wire [1:0] bm_113_2_from_1 = {1'b0, (r_sys[113] ^ 1'b0)} + {1'b0, (r_par1[113] ^ 1'b1)};
    wire [1:0] bm_113_2_from_3 = {1'b0, (r_sys[113] ^ 1'b0)} + {1'b0, (r_par1[113] ^ 1'b0)};
    wire [8:0] cand_113_2_1 = pm_112_1 + {7'b0, bm_113_2_from_1};
    wire [8:0] cand_113_2_2 = pm_112_3 + {7'b0, bm_113_2_from_3};
    wire sel_113_2 = (cand_113_2_1 > cand_113_2_2); // 1 if cand2 better
    wire [8:0] pm_113_2 = sel_113_2 ? cand_113_2_2 : cand_113_2_1;
    wire surv_113_2 = sel_113_2;
    wire [1:0] bm_113_3_from_1 = {1'b0, (r_sys[113] ^ 1'b1)} + {1'b0, (r_par1[113] ^ 1'b0)};
    wire [1:0] bm_113_3_from_3 = {1'b0, (r_sys[113] ^ 1'b1)} + {1'b0, (r_par1[113] ^ 1'b1)};
    wire [8:0] cand_113_3_1 = pm_112_1 + {7'b0, bm_113_3_from_1};
    wire [8:0] cand_113_3_2 = pm_112_3 + {7'b0, bm_113_3_from_3};
    wire sel_113_3 = (cand_113_3_1 > cand_113_3_2); // 1 if cand2 better
    wire [8:0] pm_113_3 = sel_113_3 ? cand_113_3_2 : cand_113_3_1;
    wire surv_113_3 = sel_113_3;
    // Stage 114
    wire [1:0] bm_114_0_from_0 = {1'b0, (r_sys[114] ^ 1'b0)} + {1'b0, (r_par1[114] ^ 1'b0)};
    wire [1:0] bm_114_0_from_2 = {1'b0, (r_sys[114] ^ 1'b0)} + {1'b0, (r_par1[114] ^ 1'b1)};
    wire [8:0] cand_114_0_1 = pm_113_0 + {7'b0, bm_114_0_from_0};
    wire [8:0] cand_114_0_2 = pm_113_2 + {7'b0, bm_114_0_from_2};
    wire sel_114_0 = (cand_114_0_1 > cand_114_0_2); // 1 if cand2 better
    wire [8:0] pm_114_0 = sel_114_0 ? cand_114_0_2 : cand_114_0_1;
    wire surv_114_0 = sel_114_0;
    wire [1:0] bm_114_1_from_0 = {1'b0, (r_sys[114] ^ 1'b1)} + {1'b0, (r_par1[114] ^ 1'b1)};
    wire [1:0] bm_114_1_from_2 = {1'b0, (r_sys[114] ^ 1'b1)} + {1'b0, (r_par1[114] ^ 1'b0)};
    wire [8:0] cand_114_1_1 = pm_113_0 + {7'b0, bm_114_1_from_0};
    wire [8:0] cand_114_1_2 = pm_113_2 + {7'b0, bm_114_1_from_2};
    wire sel_114_1 = (cand_114_1_1 > cand_114_1_2); // 1 if cand2 better
    wire [8:0] pm_114_1 = sel_114_1 ? cand_114_1_2 : cand_114_1_1;
    wire surv_114_1 = sel_114_1;
    wire [1:0] bm_114_2_from_1 = {1'b0, (r_sys[114] ^ 1'b0)} + {1'b0, (r_par1[114] ^ 1'b1)};
    wire [1:0] bm_114_2_from_3 = {1'b0, (r_sys[114] ^ 1'b0)} + {1'b0, (r_par1[114] ^ 1'b0)};
    wire [8:0] cand_114_2_1 = pm_113_1 + {7'b0, bm_114_2_from_1};
    wire [8:0] cand_114_2_2 = pm_113_3 + {7'b0, bm_114_2_from_3};
    wire sel_114_2 = (cand_114_2_1 > cand_114_2_2); // 1 if cand2 better
    wire [8:0] pm_114_2 = sel_114_2 ? cand_114_2_2 : cand_114_2_1;
    wire surv_114_2 = sel_114_2;
    wire [1:0] bm_114_3_from_1 = {1'b0, (r_sys[114] ^ 1'b1)} + {1'b0, (r_par1[114] ^ 1'b0)};
    wire [1:0] bm_114_3_from_3 = {1'b0, (r_sys[114] ^ 1'b1)} + {1'b0, (r_par1[114] ^ 1'b1)};
    wire [8:0] cand_114_3_1 = pm_113_1 + {7'b0, bm_114_3_from_1};
    wire [8:0] cand_114_3_2 = pm_113_3 + {7'b0, bm_114_3_from_3};
    wire sel_114_3 = (cand_114_3_1 > cand_114_3_2); // 1 if cand2 better
    wire [8:0] pm_114_3 = sel_114_3 ? cand_114_3_2 : cand_114_3_1;
    wire surv_114_3 = sel_114_3;
    // Stage 115
    wire [1:0] bm_115_0_from_0 = {1'b0, (r_sys[115] ^ 1'b0)} + {1'b0, (r_par1[115] ^ 1'b0)};
    wire [1:0] bm_115_0_from_2 = {1'b0, (r_sys[115] ^ 1'b0)} + {1'b0, (r_par1[115] ^ 1'b1)};
    wire [8:0] cand_115_0_1 = pm_114_0 + {7'b0, bm_115_0_from_0};
    wire [8:0] cand_115_0_2 = pm_114_2 + {7'b0, bm_115_0_from_2};
    wire sel_115_0 = (cand_115_0_1 > cand_115_0_2); // 1 if cand2 better
    wire [8:0] pm_115_0 = sel_115_0 ? cand_115_0_2 : cand_115_0_1;
    wire surv_115_0 = sel_115_0;
    wire [1:0] bm_115_1_from_0 = {1'b0, (r_sys[115] ^ 1'b1)} + {1'b0, (r_par1[115] ^ 1'b1)};
    wire [1:0] bm_115_1_from_2 = {1'b0, (r_sys[115] ^ 1'b1)} + {1'b0, (r_par1[115] ^ 1'b0)};
    wire [8:0] cand_115_1_1 = pm_114_0 + {7'b0, bm_115_1_from_0};
    wire [8:0] cand_115_1_2 = pm_114_2 + {7'b0, bm_115_1_from_2};
    wire sel_115_1 = (cand_115_1_1 > cand_115_1_2); // 1 if cand2 better
    wire [8:0] pm_115_1 = sel_115_1 ? cand_115_1_2 : cand_115_1_1;
    wire surv_115_1 = sel_115_1;
    wire [1:0] bm_115_2_from_1 = {1'b0, (r_sys[115] ^ 1'b0)} + {1'b0, (r_par1[115] ^ 1'b1)};
    wire [1:0] bm_115_2_from_3 = {1'b0, (r_sys[115] ^ 1'b0)} + {1'b0, (r_par1[115] ^ 1'b0)};
    wire [8:0] cand_115_2_1 = pm_114_1 + {7'b0, bm_115_2_from_1};
    wire [8:0] cand_115_2_2 = pm_114_3 + {7'b0, bm_115_2_from_3};
    wire sel_115_2 = (cand_115_2_1 > cand_115_2_2); // 1 if cand2 better
    wire [8:0] pm_115_2 = sel_115_2 ? cand_115_2_2 : cand_115_2_1;
    wire surv_115_2 = sel_115_2;
    wire [1:0] bm_115_3_from_1 = {1'b0, (r_sys[115] ^ 1'b1)} + {1'b0, (r_par1[115] ^ 1'b0)};
    wire [1:0] bm_115_3_from_3 = {1'b0, (r_sys[115] ^ 1'b1)} + {1'b0, (r_par1[115] ^ 1'b1)};
    wire [8:0] cand_115_3_1 = pm_114_1 + {7'b0, bm_115_3_from_1};
    wire [8:0] cand_115_3_2 = pm_114_3 + {7'b0, bm_115_3_from_3};
    wire sel_115_3 = (cand_115_3_1 > cand_115_3_2); // 1 if cand2 better
    wire [8:0] pm_115_3 = sel_115_3 ? cand_115_3_2 : cand_115_3_1;
    wire surv_115_3 = sel_115_3;
    // Stage 116
    wire [1:0] bm_116_0_from_0 = {1'b0, (r_sys[116] ^ 1'b0)} + {1'b0, (r_par1[116] ^ 1'b0)};
    wire [1:0] bm_116_0_from_2 = {1'b0, (r_sys[116] ^ 1'b0)} + {1'b0, (r_par1[116] ^ 1'b1)};
    wire [8:0] cand_116_0_1 = pm_115_0 + {7'b0, bm_116_0_from_0};
    wire [8:0] cand_116_0_2 = pm_115_2 + {7'b0, bm_116_0_from_2};
    wire sel_116_0 = (cand_116_0_1 > cand_116_0_2); // 1 if cand2 better
    wire [8:0] pm_116_0 = sel_116_0 ? cand_116_0_2 : cand_116_0_1;
    wire surv_116_0 = sel_116_0;
    wire [1:0] bm_116_1_from_0 = {1'b0, (r_sys[116] ^ 1'b1)} + {1'b0, (r_par1[116] ^ 1'b1)};
    wire [1:0] bm_116_1_from_2 = {1'b0, (r_sys[116] ^ 1'b1)} + {1'b0, (r_par1[116] ^ 1'b0)};
    wire [8:0] cand_116_1_1 = pm_115_0 + {7'b0, bm_116_1_from_0};
    wire [8:0] cand_116_1_2 = pm_115_2 + {7'b0, bm_116_1_from_2};
    wire sel_116_1 = (cand_116_1_1 > cand_116_1_2); // 1 if cand2 better
    wire [8:0] pm_116_1 = sel_116_1 ? cand_116_1_2 : cand_116_1_1;
    wire surv_116_1 = sel_116_1;
    wire [1:0] bm_116_2_from_1 = {1'b0, (r_sys[116] ^ 1'b0)} + {1'b0, (r_par1[116] ^ 1'b1)};
    wire [1:0] bm_116_2_from_3 = {1'b0, (r_sys[116] ^ 1'b0)} + {1'b0, (r_par1[116] ^ 1'b0)};
    wire [8:0] cand_116_2_1 = pm_115_1 + {7'b0, bm_116_2_from_1};
    wire [8:0] cand_116_2_2 = pm_115_3 + {7'b0, bm_116_2_from_3};
    wire sel_116_2 = (cand_116_2_1 > cand_116_2_2); // 1 if cand2 better
    wire [8:0] pm_116_2 = sel_116_2 ? cand_116_2_2 : cand_116_2_1;
    wire surv_116_2 = sel_116_2;
    wire [1:0] bm_116_3_from_1 = {1'b0, (r_sys[116] ^ 1'b1)} + {1'b0, (r_par1[116] ^ 1'b0)};
    wire [1:0] bm_116_3_from_3 = {1'b0, (r_sys[116] ^ 1'b1)} + {1'b0, (r_par1[116] ^ 1'b1)};
    wire [8:0] cand_116_3_1 = pm_115_1 + {7'b0, bm_116_3_from_1};
    wire [8:0] cand_116_3_2 = pm_115_3 + {7'b0, bm_116_3_from_3};
    wire sel_116_3 = (cand_116_3_1 > cand_116_3_2); // 1 if cand2 better
    wire [8:0] pm_116_3 = sel_116_3 ? cand_116_3_2 : cand_116_3_1;
    wire surv_116_3 = sel_116_3;
    // Stage 117
    wire [1:0] bm_117_0_from_0 = {1'b0, (r_sys[117] ^ 1'b0)} + {1'b0, (r_par1[117] ^ 1'b0)};
    wire [1:0] bm_117_0_from_2 = {1'b0, (r_sys[117] ^ 1'b0)} + {1'b0, (r_par1[117] ^ 1'b1)};
    wire [8:0] cand_117_0_1 = pm_116_0 + {7'b0, bm_117_0_from_0};
    wire [8:0] cand_117_0_2 = pm_116_2 + {7'b0, bm_117_0_from_2};
    wire sel_117_0 = (cand_117_0_1 > cand_117_0_2); // 1 if cand2 better
    wire [8:0] pm_117_0 = sel_117_0 ? cand_117_0_2 : cand_117_0_1;
    wire surv_117_0 = sel_117_0;
    wire [1:0] bm_117_1_from_0 = {1'b0, (r_sys[117] ^ 1'b1)} + {1'b0, (r_par1[117] ^ 1'b1)};
    wire [1:0] bm_117_1_from_2 = {1'b0, (r_sys[117] ^ 1'b1)} + {1'b0, (r_par1[117] ^ 1'b0)};
    wire [8:0] cand_117_1_1 = pm_116_0 + {7'b0, bm_117_1_from_0};
    wire [8:0] cand_117_1_2 = pm_116_2 + {7'b0, bm_117_1_from_2};
    wire sel_117_1 = (cand_117_1_1 > cand_117_1_2); // 1 if cand2 better
    wire [8:0] pm_117_1 = sel_117_1 ? cand_117_1_2 : cand_117_1_1;
    wire surv_117_1 = sel_117_1;
    wire [1:0] bm_117_2_from_1 = {1'b0, (r_sys[117] ^ 1'b0)} + {1'b0, (r_par1[117] ^ 1'b1)};
    wire [1:0] bm_117_2_from_3 = {1'b0, (r_sys[117] ^ 1'b0)} + {1'b0, (r_par1[117] ^ 1'b0)};
    wire [8:0] cand_117_2_1 = pm_116_1 + {7'b0, bm_117_2_from_1};
    wire [8:0] cand_117_2_2 = pm_116_3 + {7'b0, bm_117_2_from_3};
    wire sel_117_2 = (cand_117_2_1 > cand_117_2_2); // 1 if cand2 better
    wire [8:0] pm_117_2 = sel_117_2 ? cand_117_2_2 : cand_117_2_1;
    wire surv_117_2 = sel_117_2;
    wire [1:0] bm_117_3_from_1 = {1'b0, (r_sys[117] ^ 1'b1)} + {1'b0, (r_par1[117] ^ 1'b0)};
    wire [1:0] bm_117_3_from_3 = {1'b0, (r_sys[117] ^ 1'b1)} + {1'b0, (r_par1[117] ^ 1'b1)};
    wire [8:0] cand_117_3_1 = pm_116_1 + {7'b0, bm_117_3_from_1};
    wire [8:0] cand_117_3_2 = pm_116_3 + {7'b0, bm_117_3_from_3};
    wire sel_117_3 = (cand_117_3_1 > cand_117_3_2); // 1 if cand2 better
    wire [8:0] pm_117_3 = sel_117_3 ? cand_117_3_2 : cand_117_3_1;
    wire surv_117_3 = sel_117_3;
    // Stage 118
    wire [1:0] bm_118_0_from_0 = {1'b0, (r_sys[118] ^ 1'b0)} + {1'b0, (r_par1[118] ^ 1'b0)};
    wire [1:0] bm_118_0_from_2 = {1'b0, (r_sys[118] ^ 1'b0)} + {1'b0, (r_par1[118] ^ 1'b1)};
    wire [8:0] cand_118_0_1 = pm_117_0 + {7'b0, bm_118_0_from_0};
    wire [8:0] cand_118_0_2 = pm_117_2 + {7'b0, bm_118_0_from_2};
    wire sel_118_0 = (cand_118_0_1 > cand_118_0_2); // 1 if cand2 better
    wire [8:0] pm_118_0 = sel_118_0 ? cand_118_0_2 : cand_118_0_1;
    wire surv_118_0 = sel_118_0;
    wire [1:0] bm_118_1_from_0 = {1'b0, (r_sys[118] ^ 1'b1)} + {1'b0, (r_par1[118] ^ 1'b1)};
    wire [1:0] bm_118_1_from_2 = {1'b0, (r_sys[118] ^ 1'b1)} + {1'b0, (r_par1[118] ^ 1'b0)};
    wire [8:0] cand_118_1_1 = pm_117_0 + {7'b0, bm_118_1_from_0};
    wire [8:0] cand_118_1_2 = pm_117_2 + {7'b0, bm_118_1_from_2};
    wire sel_118_1 = (cand_118_1_1 > cand_118_1_2); // 1 if cand2 better
    wire [8:0] pm_118_1 = sel_118_1 ? cand_118_1_2 : cand_118_1_1;
    wire surv_118_1 = sel_118_1;
    wire [1:0] bm_118_2_from_1 = {1'b0, (r_sys[118] ^ 1'b0)} + {1'b0, (r_par1[118] ^ 1'b1)};
    wire [1:0] bm_118_2_from_3 = {1'b0, (r_sys[118] ^ 1'b0)} + {1'b0, (r_par1[118] ^ 1'b0)};
    wire [8:0] cand_118_2_1 = pm_117_1 + {7'b0, bm_118_2_from_1};
    wire [8:0] cand_118_2_2 = pm_117_3 + {7'b0, bm_118_2_from_3};
    wire sel_118_2 = (cand_118_2_1 > cand_118_2_2); // 1 if cand2 better
    wire [8:0] pm_118_2 = sel_118_2 ? cand_118_2_2 : cand_118_2_1;
    wire surv_118_2 = sel_118_2;
    wire [1:0] bm_118_3_from_1 = {1'b0, (r_sys[118] ^ 1'b1)} + {1'b0, (r_par1[118] ^ 1'b0)};
    wire [1:0] bm_118_3_from_3 = {1'b0, (r_sys[118] ^ 1'b1)} + {1'b0, (r_par1[118] ^ 1'b1)};
    wire [8:0] cand_118_3_1 = pm_117_1 + {7'b0, bm_118_3_from_1};
    wire [8:0] cand_118_3_2 = pm_117_3 + {7'b0, bm_118_3_from_3};
    wire sel_118_3 = (cand_118_3_1 > cand_118_3_2); // 1 if cand2 better
    wire [8:0] pm_118_3 = sel_118_3 ? cand_118_3_2 : cand_118_3_1;
    wire surv_118_3 = sel_118_3;
    // Stage 119
    wire [1:0] bm_119_0_from_0 = {1'b0, (r_sys[119] ^ 1'b0)} + {1'b0, (r_par1[119] ^ 1'b0)};
    wire [1:0] bm_119_0_from_2 = {1'b0, (r_sys[119] ^ 1'b0)} + {1'b0, (r_par1[119] ^ 1'b1)};
    wire [8:0] cand_119_0_1 = pm_118_0 + {7'b0, bm_119_0_from_0};
    wire [8:0] cand_119_0_2 = pm_118_2 + {7'b0, bm_119_0_from_2};
    wire sel_119_0 = (cand_119_0_1 > cand_119_0_2); // 1 if cand2 better
    wire [8:0] pm_119_0 = sel_119_0 ? cand_119_0_2 : cand_119_0_1;
    wire surv_119_0 = sel_119_0;
    wire [1:0] bm_119_1_from_0 = {1'b0, (r_sys[119] ^ 1'b1)} + {1'b0, (r_par1[119] ^ 1'b1)};
    wire [1:0] bm_119_1_from_2 = {1'b0, (r_sys[119] ^ 1'b1)} + {1'b0, (r_par1[119] ^ 1'b0)};
    wire [8:0] cand_119_1_1 = pm_118_0 + {7'b0, bm_119_1_from_0};
    wire [8:0] cand_119_1_2 = pm_118_2 + {7'b0, bm_119_1_from_2};
    wire sel_119_1 = (cand_119_1_1 > cand_119_1_2); // 1 if cand2 better
    wire [8:0] pm_119_1 = sel_119_1 ? cand_119_1_2 : cand_119_1_1;
    wire surv_119_1 = sel_119_1;
    wire [1:0] bm_119_2_from_1 = {1'b0, (r_sys[119] ^ 1'b0)} + {1'b0, (r_par1[119] ^ 1'b1)};
    wire [1:0] bm_119_2_from_3 = {1'b0, (r_sys[119] ^ 1'b0)} + {1'b0, (r_par1[119] ^ 1'b0)};
    wire [8:0] cand_119_2_1 = pm_118_1 + {7'b0, bm_119_2_from_1};
    wire [8:0] cand_119_2_2 = pm_118_3 + {7'b0, bm_119_2_from_3};
    wire sel_119_2 = (cand_119_2_1 > cand_119_2_2); // 1 if cand2 better
    wire [8:0] pm_119_2 = sel_119_2 ? cand_119_2_2 : cand_119_2_1;
    wire surv_119_2 = sel_119_2;
    wire [1:0] bm_119_3_from_1 = {1'b0, (r_sys[119] ^ 1'b1)} + {1'b0, (r_par1[119] ^ 1'b0)};
    wire [1:0] bm_119_3_from_3 = {1'b0, (r_sys[119] ^ 1'b1)} + {1'b0, (r_par1[119] ^ 1'b1)};
    wire [8:0] cand_119_3_1 = pm_118_1 + {7'b0, bm_119_3_from_1};
    wire [8:0] cand_119_3_2 = pm_118_3 + {7'b0, bm_119_3_from_3};
    wire sel_119_3 = (cand_119_3_1 > cand_119_3_2); // 1 if cand2 better
    wire [8:0] pm_119_3 = sel_119_3 ? cand_119_3_2 : cand_119_3_1;
    wire surv_119_3 = sel_119_3;
    // Stage 120
    wire [1:0] bm_120_0_from_0 = {1'b0, (r_sys[120] ^ 1'b0)} + {1'b0, (r_par1[120] ^ 1'b0)};
    wire [1:0] bm_120_0_from_2 = {1'b0, (r_sys[120] ^ 1'b0)} + {1'b0, (r_par1[120] ^ 1'b1)};
    wire [8:0] cand_120_0_1 = pm_119_0 + {7'b0, bm_120_0_from_0};
    wire [8:0] cand_120_0_2 = pm_119_2 + {7'b0, bm_120_0_from_2};
    wire sel_120_0 = (cand_120_0_1 > cand_120_0_2); // 1 if cand2 better
    wire [8:0] pm_120_0 = sel_120_0 ? cand_120_0_2 : cand_120_0_1;
    wire surv_120_0 = sel_120_0;
    wire [1:0] bm_120_1_from_0 = {1'b0, (r_sys[120] ^ 1'b1)} + {1'b0, (r_par1[120] ^ 1'b1)};
    wire [1:0] bm_120_1_from_2 = {1'b0, (r_sys[120] ^ 1'b1)} + {1'b0, (r_par1[120] ^ 1'b0)};
    wire [8:0] cand_120_1_1 = pm_119_0 + {7'b0, bm_120_1_from_0};
    wire [8:0] cand_120_1_2 = pm_119_2 + {7'b0, bm_120_1_from_2};
    wire sel_120_1 = (cand_120_1_1 > cand_120_1_2); // 1 if cand2 better
    wire [8:0] pm_120_1 = sel_120_1 ? cand_120_1_2 : cand_120_1_1;
    wire surv_120_1 = sel_120_1;
    wire [1:0] bm_120_2_from_1 = {1'b0, (r_sys[120] ^ 1'b0)} + {1'b0, (r_par1[120] ^ 1'b1)};
    wire [1:0] bm_120_2_from_3 = {1'b0, (r_sys[120] ^ 1'b0)} + {1'b0, (r_par1[120] ^ 1'b0)};
    wire [8:0] cand_120_2_1 = pm_119_1 + {7'b0, bm_120_2_from_1};
    wire [8:0] cand_120_2_2 = pm_119_3 + {7'b0, bm_120_2_from_3};
    wire sel_120_2 = (cand_120_2_1 > cand_120_2_2); // 1 if cand2 better
    wire [8:0] pm_120_2 = sel_120_2 ? cand_120_2_2 : cand_120_2_1;
    wire surv_120_2 = sel_120_2;
    wire [1:0] bm_120_3_from_1 = {1'b0, (r_sys[120] ^ 1'b1)} + {1'b0, (r_par1[120] ^ 1'b0)};
    wire [1:0] bm_120_3_from_3 = {1'b0, (r_sys[120] ^ 1'b1)} + {1'b0, (r_par1[120] ^ 1'b1)};
    wire [8:0] cand_120_3_1 = pm_119_1 + {7'b0, bm_120_3_from_1};
    wire [8:0] cand_120_3_2 = pm_119_3 + {7'b0, bm_120_3_from_3};
    wire sel_120_3 = (cand_120_3_1 > cand_120_3_2); // 1 if cand2 better
    wire [8:0] pm_120_3 = sel_120_3 ? cand_120_3_2 : cand_120_3_1;
    wire surv_120_3 = sel_120_3;
    // Stage 121
    wire [1:0] bm_121_0_from_0 = {1'b0, (r_sys[121] ^ 1'b0)} + {1'b0, (r_par1[121] ^ 1'b0)};
    wire [1:0] bm_121_0_from_2 = {1'b0, (r_sys[121] ^ 1'b0)} + {1'b0, (r_par1[121] ^ 1'b1)};
    wire [8:0] cand_121_0_1 = pm_120_0 + {7'b0, bm_121_0_from_0};
    wire [8:0] cand_121_0_2 = pm_120_2 + {7'b0, bm_121_0_from_2};
    wire sel_121_0 = (cand_121_0_1 > cand_121_0_2); // 1 if cand2 better
    wire [8:0] pm_121_0 = sel_121_0 ? cand_121_0_2 : cand_121_0_1;
    wire surv_121_0 = sel_121_0;
    wire [1:0] bm_121_1_from_0 = {1'b0, (r_sys[121] ^ 1'b1)} + {1'b0, (r_par1[121] ^ 1'b1)};
    wire [1:0] bm_121_1_from_2 = {1'b0, (r_sys[121] ^ 1'b1)} + {1'b0, (r_par1[121] ^ 1'b0)};
    wire [8:0] cand_121_1_1 = pm_120_0 + {7'b0, bm_121_1_from_0};
    wire [8:0] cand_121_1_2 = pm_120_2 + {7'b0, bm_121_1_from_2};
    wire sel_121_1 = (cand_121_1_1 > cand_121_1_2); // 1 if cand2 better
    wire [8:0] pm_121_1 = sel_121_1 ? cand_121_1_2 : cand_121_1_1;
    wire surv_121_1 = sel_121_1;
    wire [1:0] bm_121_2_from_1 = {1'b0, (r_sys[121] ^ 1'b0)} + {1'b0, (r_par1[121] ^ 1'b1)};
    wire [1:0] bm_121_2_from_3 = {1'b0, (r_sys[121] ^ 1'b0)} + {1'b0, (r_par1[121] ^ 1'b0)};
    wire [8:0] cand_121_2_1 = pm_120_1 + {7'b0, bm_121_2_from_1};
    wire [8:0] cand_121_2_2 = pm_120_3 + {7'b0, bm_121_2_from_3};
    wire sel_121_2 = (cand_121_2_1 > cand_121_2_2); // 1 if cand2 better
    wire [8:0] pm_121_2 = sel_121_2 ? cand_121_2_2 : cand_121_2_1;
    wire surv_121_2 = sel_121_2;
    wire [1:0] bm_121_3_from_1 = {1'b0, (r_sys[121] ^ 1'b1)} + {1'b0, (r_par1[121] ^ 1'b0)};
    wire [1:0] bm_121_3_from_3 = {1'b0, (r_sys[121] ^ 1'b1)} + {1'b0, (r_par1[121] ^ 1'b1)};
    wire [8:0] cand_121_3_1 = pm_120_1 + {7'b0, bm_121_3_from_1};
    wire [8:0] cand_121_3_2 = pm_120_3 + {7'b0, bm_121_3_from_3};
    wire sel_121_3 = (cand_121_3_1 > cand_121_3_2); // 1 if cand2 better
    wire [8:0] pm_121_3 = sel_121_3 ? cand_121_3_2 : cand_121_3_1;
    wire surv_121_3 = sel_121_3;
    // Stage 122
    wire [1:0] bm_122_0_from_0 = {1'b0, (r_sys[122] ^ 1'b0)} + {1'b0, (r_par1[122] ^ 1'b0)};
    wire [1:0] bm_122_0_from_2 = {1'b0, (r_sys[122] ^ 1'b0)} + {1'b0, (r_par1[122] ^ 1'b1)};
    wire [8:0] cand_122_0_1 = pm_121_0 + {7'b0, bm_122_0_from_0};
    wire [8:0] cand_122_0_2 = pm_121_2 + {7'b0, bm_122_0_from_2};
    wire sel_122_0 = (cand_122_0_1 > cand_122_0_2); // 1 if cand2 better
    wire [8:0] pm_122_0 = sel_122_0 ? cand_122_0_2 : cand_122_0_1;
    wire surv_122_0 = sel_122_0;
    wire [1:0] bm_122_1_from_0 = {1'b0, (r_sys[122] ^ 1'b1)} + {1'b0, (r_par1[122] ^ 1'b1)};
    wire [1:0] bm_122_1_from_2 = {1'b0, (r_sys[122] ^ 1'b1)} + {1'b0, (r_par1[122] ^ 1'b0)};
    wire [8:0] cand_122_1_1 = pm_121_0 + {7'b0, bm_122_1_from_0};
    wire [8:0] cand_122_1_2 = pm_121_2 + {7'b0, bm_122_1_from_2};
    wire sel_122_1 = (cand_122_1_1 > cand_122_1_2); // 1 if cand2 better
    wire [8:0] pm_122_1 = sel_122_1 ? cand_122_1_2 : cand_122_1_1;
    wire surv_122_1 = sel_122_1;
    wire [1:0] bm_122_2_from_1 = {1'b0, (r_sys[122] ^ 1'b0)} + {1'b0, (r_par1[122] ^ 1'b1)};
    wire [1:0] bm_122_2_from_3 = {1'b0, (r_sys[122] ^ 1'b0)} + {1'b0, (r_par1[122] ^ 1'b0)};
    wire [8:0] cand_122_2_1 = pm_121_1 + {7'b0, bm_122_2_from_1};
    wire [8:0] cand_122_2_2 = pm_121_3 + {7'b0, bm_122_2_from_3};
    wire sel_122_2 = (cand_122_2_1 > cand_122_2_2); // 1 if cand2 better
    wire [8:0] pm_122_2 = sel_122_2 ? cand_122_2_2 : cand_122_2_1;
    wire surv_122_2 = sel_122_2;
    wire [1:0] bm_122_3_from_1 = {1'b0, (r_sys[122] ^ 1'b1)} + {1'b0, (r_par1[122] ^ 1'b0)};
    wire [1:0] bm_122_3_from_3 = {1'b0, (r_sys[122] ^ 1'b1)} + {1'b0, (r_par1[122] ^ 1'b1)};
    wire [8:0] cand_122_3_1 = pm_121_1 + {7'b0, bm_122_3_from_1};
    wire [8:0] cand_122_3_2 = pm_121_3 + {7'b0, bm_122_3_from_3};
    wire sel_122_3 = (cand_122_3_1 > cand_122_3_2); // 1 if cand2 better
    wire [8:0] pm_122_3 = sel_122_3 ? cand_122_3_2 : cand_122_3_1;
    wire surv_122_3 = sel_122_3;
    // Stage 123
    wire [1:0] bm_123_0_from_0 = {1'b0, (r_sys[123] ^ 1'b0)} + {1'b0, (r_par1[123] ^ 1'b0)};
    wire [1:0] bm_123_0_from_2 = {1'b0, (r_sys[123] ^ 1'b0)} + {1'b0, (r_par1[123] ^ 1'b1)};
    wire [8:0] cand_123_0_1 = pm_122_0 + {7'b0, bm_123_0_from_0};
    wire [8:0] cand_123_0_2 = pm_122_2 + {7'b0, bm_123_0_from_2};
    wire sel_123_0 = (cand_123_0_1 > cand_123_0_2); // 1 if cand2 better
    wire [8:0] pm_123_0 = sel_123_0 ? cand_123_0_2 : cand_123_0_1;
    wire surv_123_0 = sel_123_0;
    wire [1:0] bm_123_1_from_0 = {1'b0, (r_sys[123] ^ 1'b1)} + {1'b0, (r_par1[123] ^ 1'b1)};
    wire [1:0] bm_123_1_from_2 = {1'b0, (r_sys[123] ^ 1'b1)} + {1'b0, (r_par1[123] ^ 1'b0)};
    wire [8:0] cand_123_1_1 = pm_122_0 + {7'b0, bm_123_1_from_0};
    wire [8:0] cand_123_1_2 = pm_122_2 + {7'b0, bm_123_1_from_2};
    wire sel_123_1 = (cand_123_1_1 > cand_123_1_2); // 1 if cand2 better
    wire [8:0] pm_123_1 = sel_123_1 ? cand_123_1_2 : cand_123_1_1;
    wire surv_123_1 = sel_123_1;
    wire [1:0] bm_123_2_from_1 = {1'b0, (r_sys[123] ^ 1'b0)} + {1'b0, (r_par1[123] ^ 1'b1)};
    wire [1:0] bm_123_2_from_3 = {1'b0, (r_sys[123] ^ 1'b0)} + {1'b0, (r_par1[123] ^ 1'b0)};
    wire [8:0] cand_123_2_1 = pm_122_1 + {7'b0, bm_123_2_from_1};
    wire [8:0] cand_123_2_2 = pm_122_3 + {7'b0, bm_123_2_from_3};
    wire sel_123_2 = (cand_123_2_1 > cand_123_2_2); // 1 if cand2 better
    wire [8:0] pm_123_2 = sel_123_2 ? cand_123_2_2 : cand_123_2_1;
    wire surv_123_2 = sel_123_2;
    wire [1:0] bm_123_3_from_1 = {1'b0, (r_sys[123] ^ 1'b1)} + {1'b0, (r_par1[123] ^ 1'b0)};
    wire [1:0] bm_123_3_from_3 = {1'b0, (r_sys[123] ^ 1'b1)} + {1'b0, (r_par1[123] ^ 1'b1)};
    wire [8:0] cand_123_3_1 = pm_122_1 + {7'b0, bm_123_3_from_1};
    wire [8:0] cand_123_3_2 = pm_122_3 + {7'b0, bm_123_3_from_3};
    wire sel_123_3 = (cand_123_3_1 > cand_123_3_2); // 1 if cand2 better
    wire [8:0] pm_123_3 = sel_123_3 ? cand_123_3_2 : cand_123_3_1;
    wire surv_123_3 = sel_123_3;
    // Stage 124
    wire [1:0] bm_124_0_from_0 = {1'b0, (r_sys[124] ^ 1'b0)} + {1'b0, (r_par1[124] ^ 1'b0)};
    wire [1:0] bm_124_0_from_2 = {1'b0, (r_sys[124] ^ 1'b0)} + {1'b0, (r_par1[124] ^ 1'b1)};
    wire [8:0] cand_124_0_1 = pm_123_0 + {7'b0, bm_124_0_from_0};
    wire [8:0] cand_124_0_2 = pm_123_2 + {7'b0, bm_124_0_from_2};
    wire sel_124_0 = (cand_124_0_1 > cand_124_0_2); // 1 if cand2 better
    wire [8:0] pm_124_0 = sel_124_0 ? cand_124_0_2 : cand_124_0_1;
    wire surv_124_0 = sel_124_0;
    wire [1:0] bm_124_1_from_0 = {1'b0, (r_sys[124] ^ 1'b1)} + {1'b0, (r_par1[124] ^ 1'b1)};
    wire [1:0] bm_124_1_from_2 = {1'b0, (r_sys[124] ^ 1'b1)} + {1'b0, (r_par1[124] ^ 1'b0)};
    wire [8:0] cand_124_1_1 = pm_123_0 + {7'b0, bm_124_1_from_0};
    wire [8:0] cand_124_1_2 = pm_123_2 + {7'b0, bm_124_1_from_2};
    wire sel_124_1 = (cand_124_1_1 > cand_124_1_2); // 1 if cand2 better
    wire [8:0] pm_124_1 = sel_124_1 ? cand_124_1_2 : cand_124_1_1;
    wire surv_124_1 = sel_124_1;
    wire [1:0] bm_124_2_from_1 = {1'b0, (r_sys[124] ^ 1'b0)} + {1'b0, (r_par1[124] ^ 1'b1)};
    wire [1:0] bm_124_2_from_3 = {1'b0, (r_sys[124] ^ 1'b0)} + {1'b0, (r_par1[124] ^ 1'b0)};
    wire [8:0] cand_124_2_1 = pm_123_1 + {7'b0, bm_124_2_from_1};
    wire [8:0] cand_124_2_2 = pm_123_3 + {7'b0, bm_124_2_from_3};
    wire sel_124_2 = (cand_124_2_1 > cand_124_2_2); // 1 if cand2 better
    wire [8:0] pm_124_2 = sel_124_2 ? cand_124_2_2 : cand_124_2_1;
    wire surv_124_2 = sel_124_2;
    wire [1:0] bm_124_3_from_1 = {1'b0, (r_sys[124] ^ 1'b1)} + {1'b0, (r_par1[124] ^ 1'b0)};
    wire [1:0] bm_124_3_from_3 = {1'b0, (r_sys[124] ^ 1'b1)} + {1'b0, (r_par1[124] ^ 1'b1)};
    wire [8:0] cand_124_3_1 = pm_123_1 + {7'b0, bm_124_3_from_1};
    wire [8:0] cand_124_3_2 = pm_123_3 + {7'b0, bm_124_3_from_3};
    wire sel_124_3 = (cand_124_3_1 > cand_124_3_2); // 1 if cand2 better
    wire [8:0] pm_124_3 = sel_124_3 ? cand_124_3_2 : cand_124_3_1;
    wire surv_124_3 = sel_124_3;
    // Stage 125
    wire [1:0] bm_125_0_from_0 = {1'b0, (r_sys[125] ^ 1'b0)} + {1'b0, (r_par1[125] ^ 1'b0)};
    wire [1:0] bm_125_0_from_2 = {1'b0, (r_sys[125] ^ 1'b0)} + {1'b0, (r_par1[125] ^ 1'b1)};
    wire [8:0] cand_125_0_1 = pm_124_0 + {7'b0, bm_125_0_from_0};
    wire [8:0] cand_125_0_2 = pm_124_2 + {7'b0, bm_125_0_from_2};
    wire sel_125_0 = (cand_125_0_1 > cand_125_0_2); // 1 if cand2 better
    wire [8:0] pm_125_0 = sel_125_0 ? cand_125_0_2 : cand_125_0_1;
    wire surv_125_0 = sel_125_0;
    wire [1:0] bm_125_1_from_0 = {1'b0, (r_sys[125] ^ 1'b1)} + {1'b0, (r_par1[125] ^ 1'b1)};
    wire [1:0] bm_125_1_from_2 = {1'b0, (r_sys[125] ^ 1'b1)} + {1'b0, (r_par1[125] ^ 1'b0)};
    wire [8:0] cand_125_1_1 = pm_124_0 + {7'b0, bm_125_1_from_0};
    wire [8:0] cand_125_1_2 = pm_124_2 + {7'b0, bm_125_1_from_2};
    wire sel_125_1 = (cand_125_1_1 > cand_125_1_2); // 1 if cand2 better
    wire [8:0] pm_125_1 = sel_125_1 ? cand_125_1_2 : cand_125_1_1;
    wire surv_125_1 = sel_125_1;
    wire [1:0] bm_125_2_from_1 = {1'b0, (r_sys[125] ^ 1'b0)} + {1'b0, (r_par1[125] ^ 1'b1)};
    wire [1:0] bm_125_2_from_3 = {1'b0, (r_sys[125] ^ 1'b0)} + {1'b0, (r_par1[125] ^ 1'b0)};
    wire [8:0] cand_125_2_1 = pm_124_1 + {7'b0, bm_125_2_from_1};
    wire [8:0] cand_125_2_2 = pm_124_3 + {7'b0, bm_125_2_from_3};
    wire sel_125_2 = (cand_125_2_1 > cand_125_2_2); // 1 if cand2 better
    wire [8:0] pm_125_2 = sel_125_2 ? cand_125_2_2 : cand_125_2_1;
    wire surv_125_2 = sel_125_2;
    wire [1:0] bm_125_3_from_1 = {1'b0, (r_sys[125] ^ 1'b1)} + {1'b0, (r_par1[125] ^ 1'b0)};
    wire [1:0] bm_125_3_from_3 = {1'b0, (r_sys[125] ^ 1'b1)} + {1'b0, (r_par1[125] ^ 1'b1)};
    wire [8:0] cand_125_3_1 = pm_124_1 + {7'b0, bm_125_3_from_1};
    wire [8:0] cand_125_3_2 = pm_124_3 + {7'b0, bm_125_3_from_3};
    wire sel_125_3 = (cand_125_3_1 > cand_125_3_2); // 1 if cand2 better
    wire [8:0] pm_125_3 = sel_125_3 ? cand_125_3_2 : cand_125_3_1;
    wire surv_125_3 = sel_125_3;
    // Stage 126
    wire [1:0] bm_126_0_from_0 = {1'b0, (r_sys[126] ^ 1'b0)} + {1'b0, (r_par1[126] ^ 1'b0)};
    wire [1:0] bm_126_0_from_2 = {1'b0, (r_sys[126] ^ 1'b0)} + {1'b0, (r_par1[126] ^ 1'b1)};
    wire [8:0] cand_126_0_1 = pm_125_0 + {7'b0, bm_126_0_from_0};
    wire [8:0] cand_126_0_2 = pm_125_2 + {7'b0, bm_126_0_from_2};
    wire sel_126_0 = (cand_126_0_1 > cand_126_0_2); // 1 if cand2 better
    wire [8:0] pm_126_0 = sel_126_0 ? cand_126_0_2 : cand_126_0_1;
    wire surv_126_0 = sel_126_0;
    wire [1:0] bm_126_1_from_0 = {1'b0, (r_sys[126] ^ 1'b1)} + {1'b0, (r_par1[126] ^ 1'b1)};
    wire [1:0] bm_126_1_from_2 = {1'b0, (r_sys[126] ^ 1'b1)} + {1'b0, (r_par1[126] ^ 1'b0)};
    wire [8:0] cand_126_1_1 = pm_125_0 + {7'b0, bm_126_1_from_0};
    wire [8:0] cand_126_1_2 = pm_125_2 + {7'b0, bm_126_1_from_2};
    wire sel_126_1 = (cand_126_1_1 > cand_126_1_2); // 1 if cand2 better
    wire [8:0] pm_126_1 = sel_126_1 ? cand_126_1_2 : cand_126_1_1;
    wire surv_126_1 = sel_126_1;
    wire [1:0] bm_126_2_from_1 = {1'b0, (r_sys[126] ^ 1'b0)} + {1'b0, (r_par1[126] ^ 1'b1)};
    wire [1:0] bm_126_2_from_3 = {1'b0, (r_sys[126] ^ 1'b0)} + {1'b0, (r_par1[126] ^ 1'b0)};
    wire [8:0] cand_126_2_1 = pm_125_1 + {7'b0, bm_126_2_from_1};
    wire [8:0] cand_126_2_2 = pm_125_3 + {7'b0, bm_126_2_from_3};
    wire sel_126_2 = (cand_126_2_1 > cand_126_2_2); // 1 if cand2 better
    wire [8:0] pm_126_2 = sel_126_2 ? cand_126_2_2 : cand_126_2_1;
    wire surv_126_2 = sel_126_2;
    wire [1:0] bm_126_3_from_1 = {1'b0, (r_sys[126] ^ 1'b1)} + {1'b0, (r_par1[126] ^ 1'b0)};
    wire [1:0] bm_126_3_from_3 = {1'b0, (r_sys[126] ^ 1'b1)} + {1'b0, (r_par1[126] ^ 1'b1)};
    wire [8:0] cand_126_3_1 = pm_125_1 + {7'b0, bm_126_3_from_1};
    wire [8:0] cand_126_3_2 = pm_125_3 + {7'b0, bm_126_3_from_3};
    wire sel_126_3 = (cand_126_3_1 > cand_126_3_2); // 1 if cand2 better
    wire [8:0] pm_126_3 = sel_126_3 ? cand_126_3_2 : cand_126_3_1;
    wire surv_126_3 = sel_126_3;
    // Stage 127
    wire [1:0] bm_127_0_from_0 = {1'b0, (r_sys[127] ^ 1'b0)} + {1'b0, (r_par1[127] ^ 1'b0)};
    wire [1:0] bm_127_0_from_2 = {1'b0, (r_sys[127] ^ 1'b0)} + {1'b0, (r_par1[127] ^ 1'b1)};
    wire [8:0] cand_127_0_1 = pm_126_0 + {7'b0, bm_127_0_from_0};
    wire [8:0] cand_127_0_2 = pm_126_2 + {7'b0, bm_127_0_from_2};
    wire sel_127_0 = (cand_127_0_1 > cand_127_0_2); // 1 if cand2 better
    wire [8:0] pm_127_0 = sel_127_0 ? cand_127_0_2 : cand_127_0_1;
    wire surv_127_0 = sel_127_0;
    wire [1:0] bm_127_1_from_0 = {1'b0, (r_sys[127] ^ 1'b1)} + {1'b0, (r_par1[127] ^ 1'b1)};
    wire [1:0] bm_127_1_from_2 = {1'b0, (r_sys[127] ^ 1'b1)} + {1'b0, (r_par1[127] ^ 1'b0)};
    wire [8:0] cand_127_1_1 = pm_126_0 + {7'b0, bm_127_1_from_0};
    wire [8:0] cand_127_1_2 = pm_126_2 + {7'b0, bm_127_1_from_2};
    wire sel_127_1 = (cand_127_1_1 > cand_127_1_2); // 1 if cand2 better
    wire [8:0] pm_127_1 = sel_127_1 ? cand_127_1_2 : cand_127_1_1;
    wire surv_127_1 = sel_127_1;
    wire [1:0] bm_127_2_from_1 = {1'b0, (r_sys[127] ^ 1'b0)} + {1'b0, (r_par1[127] ^ 1'b1)};
    wire [1:0] bm_127_2_from_3 = {1'b0, (r_sys[127] ^ 1'b0)} + {1'b0, (r_par1[127] ^ 1'b0)};
    wire [8:0] cand_127_2_1 = pm_126_1 + {7'b0, bm_127_2_from_1};
    wire [8:0] cand_127_2_2 = pm_126_3 + {7'b0, bm_127_2_from_3};
    wire sel_127_2 = (cand_127_2_1 > cand_127_2_2); // 1 if cand2 better
    wire [8:0] pm_127_2 = sel_127_2 ? cand_127_2_2 : cand_127_2_1;
    wire surv_127_2 = sel_127_2;
    wire [1:0] bm_127_3_from_1 = {1'b0, (r_sys[127] ^ 1'b1)} + {1'b0, (r_par1[127] ^ 1'b0)};
    wire [1:0] bm_127_3_from_3 = {1'b0, (r_sys[127] ^ 1'b1)} + {1'b0, (r_par1[127] ^ 1'b1)};
    wire [8:0] cand_127_3_1 = pm_126_1 + {7'b0, bm_127_3_from_1};
    wire [8:0] cand_127_3_2 = pm_126_3 + {7'b0, bm_127_3_from_3};
    wire sel_127_3 = (cand_127_3_1 > cand_127_3_2); // 1 if cand2 better
    wire [8:0] pm_127_3 = sel_127_3 ? cand_127_3_2 : cand_127_3_1;
    wire surv_127_3 = sel_127_3;
    // Traceback
    wire [1:0] best_state_127;
    wire [8:0] min_pm_01 = (pm_127_0 < pm_127_1) ? pm_127_0 : pm_127_1;
    wire [8:0] min_pm_23 = (pm_127_2 < pm_127_3) ? pm_127_2 : pm_127_3;
    wire [8:0] min_pm_all = (min_pm_01 < min_pm_23) ? min_pm_01 : min_pm_23;
    assign best_state_127 = (pm_127_0 == min_pm_all) ? 2'd0 :
                                (pm_127_1 == min_pm_all) ? 2'd1 :
                                (pm_127_2 == min_pm_all) ? 2'd2 : 2'd3;
    wire dec_bit_127 = best_state_127[0];
    wire surv_bit_127 = (best_state_127==0) ? surv_127_0 :
                        (best_state_127==1) ? surv_127_1 :
                        (best_state_127==2) ? surv_127_2 : surv_127_3;
    wire [1:0] best_state_126 = {surv_bit_127, best_state_127[1]};
    wire dec_bit_126 = best_state_126[0];
    wire surv_bit_126 = (best_state_126==0) ? surv_126_0 :
                        (best_state_126==1) ? surv_126_1 :
                        (best_state_126==2) ? surv_126_2 : surv_126_3;
    wire [1:0] best_state_125 = {surv_bit_126, best_state_126[1]};
    wire dec_bit_125 = best_state_125[0];
    wire surv_bit_125 = (best_state_125==0) ? surv_125_0 :
                        (best_state_125==1) ? surv_125_1 :
                        (best_state_125==2) ? surv_125_2 : surv_125_3;
    wire [1:0] best_state_124 = {surv_bit_125, best_state_125[1]};
    wire dec_bit_124 = best_state_124[0];
    wire surv_bit_124 = (best_state_124==0) ? surv_124_0 :
                        (best_state_124==1) ? surv_124_1 :
                        (best_state_124==2) ? surv_124_2 : surv_124_3;
    wire [1:0] best_state_123 = {surv_bit_124, best_state_124[1]};
    wire dec_bit_123 = best_state_123[0];
    wire surv_bit_123 = (best_state_123==0) ? surv_123_0 :
                        (best_state_123==1) ? surv_123_1 :
                        (best_state_123==2) ? surv_123_2 : surv_123_3;
    wire [1:0] best_state_122 = {surv_bit_123, best_state_123[1]};
    wire dec_bit_122 = best_state_122[0];
    wire surv_bit_122 = (best_state_122==0) ? surv_122_0 :
                        (best_state_122==1) ? surv_122_1 :
                        (best_state_122==2) ? surv_122_2 : surv_122_3;
    wire [1:0] best_state_121 = {surv_bit_122, best_state_122[1]};
    wire dec_bit_121 = best_state_121[0];
    wire surv_bit_121 = (best_state_121==0) ? surv_121_0 :
                        (best_state_121==1) ? surv_121_1 :
                        (best_state_121==2) ? surv_121_2 : surv_121_3;
    wire [1:0] best_state_120 = {surv_bit_121, best_state_121[1]};
    wire dec_bit_120 = best_state_120[0];
    wire surv_bit_120 = (best_state_120==0) ? surv_120_0 :
                        (best_state_120==1) ? surv_120_1 :
                        (best_state_120==2) ? surv_120_2 : surv_120_3;
    wire [1:0] best_state_119 = {surv_bit_120, best_state_120[1]};
    wire dec_bit_119 = best_state_119[0];
    wire surv_bit_119 = (best_state_119==0) ? surv_119_0 :
                        (best_state_119==1) ? surv_119_1 :
                        (best_state_119==2) ? surv_119_2 : surv_119_3;
    wire [1:0] best_state_118 = {surv_bit_119, best_state_119[1]};
    wire dec_bit_118 = best_state_118[0];
    wire surv_bit_118 = (best_state_118==0) ? surv_118_0 :
                        (best_state_118==1) ? surv_118_1 :
                        (best_state_118==2) ? surv_118_2 : surv_118_3;
    wire [1:0] best_state_117 = {surv_bit_118, best_state_118[1]};
    wire dec_bit_117 = best_state_117[0];
    wire surv_bit_117 = (best_state_117==0) ? surv_117_0 :
                        (best_state_117==1) ? surv_117_1 :
                        (best_state_117==2) ? surv_117_2 : surv_117_3;
    wire [1:0] best_state_116 = {surv_bit_117, best_state_117[1]};
    wire dec_bit_116 = best_state_116[0];
    wire surv_bit_116 = (best_state_116==0) ? surv_116_0 :
                        (best_state_116==1) ? surv_116_1 :
                        (best_state_116==2) ? surv_116_2 : surv_116_3;
    wire [1:0] best_state_115 = {surv_bit_116, best_state_116[1]};
    wire dec_bit_115 = best_state_115[0];
    wire surv_bit_115 = (best_state_115==0) ? surv_115_0 :
                        (best_state_115==1) ? surv_115_1 :
                        (best_state_115==2) ? surv_115_2 : surv_115_3;
    wire [1:0] best_state_114 = {surv_bit_115, best_state_115[1]};
    wire dec_bit_114 = best_state_114[0];
    wire surv_bit_114 = (best_state_114==0) ? surv_114_0 :
                        (best_state_114==1) ? surv_114_1 :
                        (best_state_114==2) ? surv_114_2 : surv_114_3;
    wire [1:0] best_state_113 = {surv_bit_114, best_state_114[1]};
    wire dec_bit_113 = best_state_113[0];
    wire surv_bit_113 = (best_state_113==0) ? surv_113_0 :
                        (best_state_113==1) ? surv_113_1 :
                        (best_state_113==2) ? surv_113_2 : surv_113_3;
    wire [1:0] best_state_112 = {surv_bit_113, best_state_113[1]};
    wire dec_bit_112 = best_state_112[0];
    wire surv_bit_112 = (best_state_112==0) ? surv_112_0 :
                        (best_state_112==1) ? surv_112_1 :
                        (best_state_112==2) ? surv_112_2 : surv_112_3;
    wire [1:0] best_state_111 = {surv_bit_112, best_state_112[1]};
    wire dec_bit_111 = best_state_111[0];
    wire surv_bit_111 = (best_state_111==0) ? surv_111_0 :
                        (best_state_111==1) ? surv_111_1 :
                        (best_state_111==2) ? surv_111_2 : surv_111_3;
    wire [1:0] best_state_110 = {surv_bit_111, best_state_111[1]};
    wire dec_bit_110 = best_state_110[0];
    wire surv_bit_110 = (best_state_110==0) ? surv_110_0 :
                        (best_state_110==1) ? surv_110_1 :
                        (best_state_110==2) ? surv_110_2 : surv_110_3;
    wire [1:0] best_state_109 = {surv_bit_110, best_state_110[1]};
    wire dec_bit_109 = best_state_109[0];
    wire surv_bit_109 = (best_state_109==0) ? surv_109_0 :
                        (best_state_109==1) ? surv_109_1 :
                        (best_state_109==2) ? surv_109_2 : surv_109_3;
    wire [1:0] best_state_108 = {surv_bit_109, best_state_109[1]};
    wire dec_bit_108 = best_state_108[0];
    wire surv_bit_108 = (best_state_108==0) ? surv_108_0 :
                        (best_state_108==1) ? surv_108_1 :
                        (best_state_108==2) ? surv_108_2 : surv_108_3;
    wire [1:0] best_state_107 = {surv_bit_108, best_state_108[1]};
    wire dec_bit_107 = best_state_107[0];
    wire surv_bit_107 = (best_state_107==0) ? surv_107_0 :
                        (best_state_107==1) ? surv_107_1 :
                        (best_state_107==2) ? surv_107_2 : surv_107_3;
    wire [1:0] best_state_106 = {surv_bit_107, best_state_107[1]};
    wire dec_bit_106 = best_state_106[0];
    wire surv_bit_106 = (best_state_106==0) ? surv_106_0 :
                        (best_state_106==1) ? surv_106_1 :
                        (best_state_106==2) ? surv_106_2 : surv_106_3;
    wire [1:0] best_state_105 = {surv_bit_106, best_state_106[1]};
    wire dec_bit_105 = best_state_105[0];
    wire surv_bit_105 = (best_state_105==0) ? surv_105_0 :
                        (best_state_105==1) ? surv_105_1 :
                        (best_state_105==2) ? surv_105_2 : surv_105_3;
    wire [1:0] best_state_104 = {surv_bit_105, best_state_105[1]};
    wire dec_bit_104 = best_state_104[0];
    wire surv_bit_104 = (best_state_104==0) ? surv_104_0 :
                        (best_state_104==1) ? surv_104_1 :
                        (best_state_104==2) ? surv_104_2 : surv_104_3;
    wire [1:0] best_state_103 = {surv_bit_104, best_state_104[1]};
    wire dec_bit_103 = best_state_103[0];
    wire surv_bit_103 = (best_state_103==0) ? surv_103_0 :
                        (best_state_103==1) ? surv_103_1 :
                        (best_state_103==2) ? surv_103_2 : surv_103_3;
    wire [1:0] best_state_102 = {surv_bit_103, best_state_103[1]};
    wire dec_bit_102 = best_state_102[0];
    wire surv_bit_102 = (best_state_102==0) ? surv_102_0 :
                        (best_state_102==1) ? surv_102_1 :
                        (best_state_102==2) ? surv_102_2 : surv_102_3;
    wire [1:0] best_state_101 = {surv_bit_102, best_state_102[1]};
    wire dec_bit_101 = best_state_101[0];
    wire surv_bit_101 = (best_state_101==0) ? surv_101_0 :
                        (best_state_101==1) ? surv_101_1 :
                        (best_state_101==2) ? surv_101_2 : surv_101_3;
    wire [1:0] best_state_100 = {surv_bit_101, best_state_101[1]};
    wire dec_bit_100 = best_state_100[0];
    wire surv_bit_100 = (best_state_100==0) ? surv_100_0 :
                        (best_state_100==1) ? surv_100_1 :
                        (best_state_100==2) ? surv_100_2 : surv_100_3;
    wire [1:0] best_state_99 = {surv_bit_100, best_state_100[1]};
    wire dec_bit_99 = best_state_99[0];
    wire surv_bit_99 = (best_state_99==0) ? surv_99_0 :
                        (best_state_99==1) ? surv_99_1 :
                        (best_state_99==2) ? surv_99_2 : surv_99_3;
    wire [1:0] best_state_98 = {surv_bit_99, best_state_99[1]};
    wire dec_bit_98 = best_state_98[0];
    wire surv_bit_98 = (best_state_98==0) ? surv_98_0 :
                        (best_state_98==1) ? surv_98_1 :
                        (best_state_98==2) ? surv_98_2 : surv_98_3;
    wire [1:0] best_state_97 = {surv_bit_98, best_state_98[1]};
    wire dec_bit_97 = best_state_97[0];
    wire surv_bit_97 = (best_state_97==0) ? surv_97_0 :
                        (best_state_97==1) ? surv_97_1 :
                        (best_state_97==2) ? surv_97_2 : surv_97_3;
    wire [1:0] best_state_96 = {surv_bit_97, best_state_97[1]};
    wire dec_bit_96 = best_state_96[0];
    wire surv_bit_96 = (best_state_96==0) ? surv_96_0 :
                        (best_state_96==1) ? surv_96_1 :
                        (best_state_96==2) ? surv_96_2 : surv_96_3;
    wire [1:0] best_state_95 = {surv_bit_96, best_state_96[1]};
    wire dec_bit_95 = best_state_95[0];
    wire surv_bit_95 = (best_state_95==0) ? surv_95_0 :
                        (best_state_95==1) ? surv_95_1 :
                        (best_state_95==2) ? surv_95_2 : surv_95_3;
    wire [1:0] best_state_94 = {surv_bit_95, best_state_95[1]};
    wire dec_bit_94 = best_state_94[0];
    wire surv_bit_94 = (best_state_94==0) ? surv_94_0 :
                        (best_state_94==1) ? surv_94_1 :
                        (best_state_94==2) ? surv_94_2 : surv_94_3;
    wire [1:0] best_state_93 = {surv_bit_94, best_state_94[1]};
    wire dec_bit_93 = best_state_93[0];
    wire surv_bit_93 = (best_state_93==0) ? surv_93_0 :
                        (best_state_93==1) ? surv_93_1 :
                        (best_state_93==2) ? surv_93_2 : surv_93_3;
    wire [1:0] best_state_92 = {surv_bit_93, best_state_93[1]};
    wire dec_bit_92 = best_state_92[0];
    wire surv_bit_92 = (best_state_92==0) ? surv_92_0 :
                        (best_state_92==1) ? surv_92_1 :
                        (best_state_92==2) ? surv_92_2 : surv_92_3;
    wire [1:0] best_state_91 = {surv_bit_92, best_state_92[1]};
    wire dec_bit_91 = best_state_91[0];
    wire surv_bit_91 = (best_state_91==0) ? surv_91_0 :
                        (best_state_91==1) ? surv_91_1 :
                        (best_state_91==2) ? surv_91_2 : surv_91_3;
    wire [1:0] best_state_90 = {surv_bit_91, best_state_91[1]};
    wire dec_bit_90 = best_state_90[0];
    wire surv_bit_90 = (best_state_90==0) ? surv_90_0 :
                        (best_state_90==1) ? surv_90_1 :
                        (best_state_90==2) ? surv_90_2 : surv_90_3;
    wire [1:0] best_state_89 = {surv_bit_90, best_state_90[1]};
    wire dec_bit_89 = best_state_89[0];
    wire surv_bit_89 = (best_state_89==0) ? surv_89_0 :
                        (best_state_89==1) ? surv_89_1 :
                        (best_state_89==2) ? surv_89_2 : surv_89_3;
    wire [1:0] best_state_88 = {surv_bit_89, best_state_89[1]};
    wire dec_bit_88 = best_state_88[0];
    wire surv_bit_88 = (best_state_88==0) ? surv_88_0 :
                        (best_state_88==1) ? surv_88_1 :
                        (best_state_88==2) ? surv_88_2 : surv_88_3;
    wire [1:0] best_state_87 = {surv_bit_88, best_state_88[1]};
    wire dec_bit_87 = best_state_87[0];
    wire surv_bit_87 = (best_state_87==0) ? surv_87_0 :
                        (best_state_87==1) ? surv_87_1 :
                        (best_state_87==2) ? surv_87_2 : surv_87_3;
    wire [1:0] best_state_86 = {surv_bit_87, best_state_87[1]};
    wire dec_bit_86 = best_state_86[0];
    wire surv_bit_86 = (best_state_86==0) ? surv_86_0 :
                        (best_state_86==1) ? surv_86_1 :
                        (best_state_86==2) ? surv_86_2 : surv_86_3;
    wire [1:0] best_state_85 = {surv_bit_86, best_state_86[1]};
    wire dec_bit_85 = best_state_85[0];
    wire surv_bit_85 = (best_state_85==0) ? surv_85_0 :
                        (best_state_85==1) ? surv_85_1 :
                        (best_state_85==2) ? surv_85_2 : surv_85_3;
    wire [1:0] best_state_84 = {surv_bit_85, best_state_85[1]};
    wire dec_bit_84 = best_state_84[0];
    wire surv_bit_84 = (best_state_84==0) ? surv_84_0 :
                        (best_state_84==1) ? surv_84_1 :
                        (best_state_84==2) ? surv_84_2 : surv_84_3;
    wire [1:0] best_state_83 = {surv_bit_84, best_state_84[1]};
    wire dec_bit_83 = best_state_83[0];
    wire surv_bit_83 = (best_state_83==0) ? surv_83_0 :
                        (best_state_83==1) ? surv_83_1 :
                        (best_state_83==2) ? surv_83_2 : surv_83_3;
    wire [1:0] best_state_82 = {surv_bit_83, best_state_83[1]};
    wire dec_bit_82 = best_state_82[0];
    wire surv_bit_82 = (best_state_82==0) ? surv_82_0 :
                        (best_state_82==1) ? surv_82_1 :
                        (best_state_82==2) ? surv_82_2 : surv_82_3;
    wire [1:0] best_state_81 = {surv_bit_82, best_state_82[1]};
    wire dec_bit_81 = best_state_81[0];
    wire surv_bit_81 = (best_state_81==0) ? surv_81_0 :
                        (best_state_81==1) ? surv_81_1 :
                        (best_state_81==2) ? surv_81_2 : surv_81_3;
    wire [1:0] best_state_80 = {surv_bit_81, best_state_81[1]};
    wire dec_bit_80 = best_state_80[0];
    wire surv_bit_80 = (best_state_80==0) ? surv_80_0 :
                        (best_state_80==1) ? surv_80_1 :
                        (best_state_80==2) ? surv_80_2 : surv_80_3;
    wire [1:0] best_state_79 = {surv_bit_80, best_state_80[1]};
    wire dec_bit_79 = best_state_79[0];
    wire surv_bit_79 = (best_state_79==0) ? surv_79_0 :
                        (best_state_79==1) ? surv_79_1 :
                        (best_state_79==2) ? surv_79_2 : surv_79_3;
    wire [1:0] best_state_78 = {surv_bit_79, best_state_79[1]};
    wire dec_bit_78 = best_state_78[0];
    wire surv_bit_78 = (best_state_78==0) ? surv_78_0 :
                        (best_state_78==1) ? surv_78_1 :
                        (best_state_78==2) ? surv_78_2 : surv_78_3;
    wire [1:0] best_state_77 = {surv_bit_78, best_state_78[1]};
    wire dec_bit_77 = best_state_77[0];
    wire surv_bit_77 = (best_state_77==0) ? surv_77_0 :
                        (best_state_77==1) ? surv_77_1 :
                        (best_state_77==2) ? surv_77_2 : surv_77_3;
    wire [1:0] best_state_76 = {surv_bit_77, best_state_77[1]};
    wire dec_bit_76 = best_state_76[0];
    wire surv_bit_76 = (best_state_76==0) ? surv_76_0 :
                        (best_state_76==1) ? surv_76_1 :
                        (best_state_76==2) ? surv_76_2 : surv_76_3;
    wire [1:0] best_state_75 = {surv_bit_76, best_state_76[1]};
    wire dec_bit_75 = best_state_75[0];
    wire surv_bit_75 = (best_state_75==0) ? surv_75_0 :
                        (best_state_75==1) ? surv_75_1 :
                        (best_state_75==2) ? surv_75_2 : surv_75_3;
    wire [1:0] best_state_74 = {surv_bit_75, best_state_75[1]};
    wire dec_bit_74 = best_state_74[0];
    wire surv_bit_74 = (best_state_74==0) ? surv_74_0 :
                        (best_state_74==1) ? surv_74_1 :
                        (best_state_74==2) ? surv_74_2 : surv_74_3;
    wire [1:0] best_state_73 = {surv_bit_74, best_state_74[1]};
    wire dec_bit_73 = best_state_73[0];
    wire surv_bit_73 = (best_state_73==0) ? surv_73_0 :
                        (best_state_73==1) ? surv_73_1 :
                        (best_state_73==2) ? surv_73_2 : surv_73_3;
    wire [1:0] best_state_72 = {surv_bit_73, best_state_73[1]};
    wire dec_bit_72 = best_state_72[0];
    wire surv_bit_72 = (best_state_72==0) ? surv_72_0 :
                        (best_state_72==1) ? surv_72_1 :
                        (best_state_72==2) ? surv_72_2 : surv_72_3;
    wire [1:0] best_state_71 = {surv_bit_72, best_state_72[1]};
    wire dec_bit_71 = best_state_71[0];
    wire surv_bit_71 = (best_state_71==0) ? surv_71_0 :
                        (best_state_71==1) ? surv_71_1 :
                        (best_state_71==2) ? surv_71_2 : surv_71_3;
    wire [1:0] best_state_70 = {surv_bit_71, best_state_71[1]};
    wire dec_bit_70 = best_state_70[0];
    wire surv_bit_70 = (best_state_70==0) ? surv_70_0 :
                        (best_state_70==1) ? surv_70_1 :
                        (best_state_70==2) ? surv_70_2 : surv_70_3;
    wire [1:0] best_state_69 = {surv_bit_70, best_state_70[1]};
    wire dec_bit_69 = best_state_69[0];
    wire surv_bit_69 = (best_state_69==0) ? surv_69_0 :
                        (best_state_69==1) ? surv_69_1 :
                        (best_state_69==2) ? surv_69_2 : surv_69_3;
    wire [1:0] best_state_68 = {surv_bit_69, best_state_69[1]};
    wire dec_bit_68 = best_state_68[0];
    wire surv_bit_68 = (best_state_68==0) ? surv_68_0 :
                        (best_state_68==1) ? surv_68_1 :
                        (best_state_68==2) ? surv_68_2 : surv_68_3;
    wire [1:0] best_state_67 = {surv_bit_68, best_state_68[1]};
    wire dec_bit_67 = best_state_67[0];
    wire surv_bit_67 = (best_state_67==0) ? surv_67_0 :
                        (best_state_67==1) ? surv_67_1 :
                        (best_state_67==2) ? surv_67_2 : surv_67_3;
    wire [1:0] best_state_66 = {surv_bit_67, best_state_67[1]};
    wire dec_bit_66 = best_state_66[0];
    wire surv_bit_66 = (best_state_66==0) ? surv_66_0 :
                        (best_state_66==1) ? surv_66_1 :
                        (best_state_66==2) ? surv_66_2 : surv_66_3;
    wire [1:0] best_state_65 = {surv_bit_66, best_state_66[1]};
    wire dec_bit_65 = best_state_65[0];
    wire surv_bit_65 = (best_state_65==0) ? surv_65_0 :
                        (best_state_65==1) ? surv_65_1 :
                        (best_state_65==2) ? surv_65_2 : surv_65_3;
    wire [1:0] best_state_64 = {surv_bit_65, best_state_65[1]};
    wire dec_bit_64 = best_state_64[0];
    wire surv_bit_64 = (best_state_64==0) ? surv_64_0 :
                        (best_state_64==1) ? surv_64_1 :
                        (best_state_64==2) ? surv_64_2 : surv_64_3;
    wire [1:0] best_state_63 = {surv_bit_64, best_state_64[1]};
    wire dec_bit_63 = best_state_63[0];
    wire surv_bit_63 = (best_state_63==0) ? surv_63_0 :
                        (best_state_63==1) ? surv_63_1 :
                        (best_state_63==2) ? surv_63_2 : surv_63_3;
    wire [1:0] best_state_62 = {surv_bit_63, best_state_63[1]};
    wire dec_bit_62 = best_state_62[0];
    wire surv_bit_62 = (best_state_62==0) ? surv_62_0 :
                        (best_state_62==1) ? surv_62_1 :
                        (best_state_62==2) ? surv_62_2 : surv_62_3;
    wire [1:0] best_state_61 = {surv_bit_62, best_state_62[1]};
    wire dec_bit_61 = best_state_61[0];
    wire surv_bit_61 = (best_state_61==0) ? surv_61_0 :
                        (best_state_61==1) ? surv_61_1 :
                        (best_state_61==2) ? surv_61_2 : surv_61_3;
    wire [1:0] best_state_60 = {surv_bit_61, best_state_61[1]};
    wire dec_bit_60 = best_state_60[0];
    wire surv_bit_60 = (best_state_60==0) ? surv_60_0 :
                        (best_state_60==1) ? surv_60_1 :
                        (best_state_60==2) ? surv_60_2 : surv_60_3;
    wire [1:0] best_state_59 = {surv_bit_60, best_state_60[1]};
    wire dec_bit_59 = best_state_59[0];
    wire surv_bit_59 = (best_state_59==0) ? surv_59_0 :
                        (best_state_59==1) ? surv_59_1 :
                        (best_state_59==2) ? surv_59_2 : surv_59_3;
    wire [1:0] best_state_58 = {surv_bit_59, best_state_59[1]};
    wire dec_bit_58 = best_state_58[0];
    wire surv_bit_58 = (best_state_58==0) ? surv_58_0 :
                        (best_state_58==1) ? surv_58_1 :
                        (best_state_58==2) ? surv_58_2 : surv_58_3;
    wire [1:0] best_state_57 = {surv_bit_58, best_state_58[1]};
    wire dec_bit_57 = best_state_57[0];
    wire surv_bit_57 = (best_state_57==0) ? surv_57_0 :
                        (best_state_57==1) ? surv_57_1 :
                        (best_state_57==2) ? surv_57_2 : surv_57_3;
    wire [1:0] best_state_56 = {surv_bit_57, best_state_57[1]};
    wire dec_bit_56 = best_state_56[0];
    wire surv_bit_56 = (best_state_56==0) ? surv_56_0 :
                        (best_state_56==1) ? surv_56_1 :
                        (best_state_56==2) ? surv_56_2 : surv_56_3;
    wire [1:0] best_state_55 = {surv_bit_56, best_state_56[1]};
    wire dec_bit_55 = best_state_55[0];
    wire surv_bit_55 = (best_state_55==0) ? surv_55_0 :
                        (best_state_55==1) ? surv_55_1 :
                        (best_state_55==2) ? surv_55_2 : surv_55_3;
    wire [1:0] best_state_54 = {surv_bit_55, best_state_55[1]};
    wire dec_bit_54 = best_state_54[0];
    wire surv_bit_54 = (best_state_54==0) ? surv_54_0 :
                        (best_state_54==1) ? surv_54_1 :
                        (best_state_54==2) ? surv_54_2 : surv_54_3;
    wire [1:0] best_state_53 = {surv_bit_54, best_state_54[1]};
    wire dec_bit_53 = best_state_53[0];
    wire surv_bit_53 = (best_state_53==0) ? surv_53_0 :
                        (best_state_53==1) ? surv_53_1 :
                        (best_state_53==2) ? surv_53_2 : surv_53_3;
    wire [1:0] best_state_52 = {surv_bit_53, best_state_53[1]};
    wire dec_bit_52 = best_state_52[0];
    wire surv_bit_52 = (best_state_52==0) ? surv_52_0 :
                        (best_state_52==1) ? surv_52_1 :
                        (best_state_52==2) ? surv_52_2 : surv_52_3;
    wire [1:0] best_state_51 = {surv_bit_52, best_state_52[1]};
    wire dec_bit_51 = best_state_51[0];
    wire surv_bit_51 = (best_state_51==0) ? surv_51_0 :
                        (best_state_51==1) ? surv_51_1 :
                        (best_state_51==2) ? surv_51_2 : surv_51_3;
    wire [1:0] best_state_50 = {surv_bit_51, best_state_51[1]};
    wire dec_bit_50 = best_state_50[0];
    wire surv_bit_50 = (best_state_50==0) ? surv_50_0 :
                        (best_state_50==1) ? surv_50_1 :
                        (best_state_50==2) ? surv_50_2 : surv_50_3;
    wire [1:0] best_state_49 = {surv_bit_50, best_state_50[1]};
    wire dec_bit_49 = best_state_49[0];
    wire surv_bit_49 = (best_state_49==0) ? surv_49_0 :
                        (best_state_49==1) ? surv_49_1 :
                        (best_state_49==2) ? surv_49_2 : surv_49_3;
    wire [1:0] best_state_48 = {surv_bit_49, best_state_49[1]};
    wire dec_bit_48 = best_state_48[0];
    wire surv_bit_48 = (best_state_48==0) ? surv_48_0 :
                        (best_state_48==1) ? surv_48_1 :
                        (best_state_48==2) ? surv_48_2 : surv_48_3;
    wire [1:0] best_state_47 = {surv_bit_48, best_state_48[1]};
    wire dec_bit_47 = best_state_47[0];
    wire surv_bit_47 = (best_state_47==0) ? surv_47_0 :
                        (best_state_47==1) ? surv_47_1 :
                        (best_state_47==2) ? surv_47_2 : surv_47_3;
    wire [1:0] best_state_46 = {surv_bit_47, best_state_47[1]};
    wire dec_bit_46 = best_state_46[0];
    wire surv_bit_46 = (best_state_46==0) ? surv_46_0 :
                        (best_state_46==1) ? surv_46_1 :
                        (best_state_46==2) ? surv_46_2 : surv_46_3;
    wire [1:0] best_state_45 = {surv_bit_46, best_state_46[1]};
    wire dec_bit_45 = best_state_45[0];
    wire surv_bit_45 = (best_state_45==0) ? surv_45_0 :
                        (best_state_45==1) ? surv_45_1 :
                        (best_state_45==2) ? surv_45_2 : surv_45_3;
    wire [1:0] best_state_44 = {surv_bit_45, best_state_45[1]};
    wire dec_bit_44 = best_state_44[0];
    wire surv_bit_44 = (best_state_44==0) ? surv_44_0 :
                        (best_state_44==1) ? surv_44_1 :
                        (best_state_44==2) ? surv_44_2 : surv_44_3;
    wire [1:0] best_state_43 = {surv_bit_44, best_state_44[1]};
    wire dec_bit_43 = best_state_43[0];
    wire surv_bit_43 = (best_state_43==0) ? surv_43_0 :
                        (best_state_43==1) ? surv_43_1 :
                        (best_state_43==2) ? surv_43_2 : surv_43_3;
    wire [1:0] best_state_42 = {surv_bit_43, best_state_43[1]};
    wire dec_bit_42 = best_state_42[0];
    wire surv_bit_42 = (best_state_42==0) ? surv_42_0 :
                        (best_state_42==1) ? surv_42_1 :
                        (best_state_42==2) ? surv_42_2 : surv_42_3;
    wire [1:0] best_state_41 = {surv_bit_42, best_state_42[1]};
    wire dec_bit_41 = best_state_41[0];
    wire surv_bit_41 = (best_state_41==0) ? surv_41_0 :
                        (best_state_41==1) ? surv_41_1 :
                        (best_state_41==2) ? surv_41_2 : surv_41_3;
    wire [1:0] best_state_40 = {surv_bit_41, best_state_41[1]};
    wire dec_bit_40 = best_state_40[0];
    wire surv_bit_40 = (best_state_40==0) ? surv_40_0 :
                        (best_state_40==1) ? surv_40_1 :
                        (best_state_40==2) ? surv_40_2 : surv_40_3;
    wire [1:0] best_state_39 = {surv_bit_40, best_state_40[1]};
    wire dec_bit_39 = best_state_39[0];
    wire surv_bit_39 = (best_state_39==0) ? surv_39_0 :
                        (best_state_39==1) ? surv_39_1 :
                        (best_state_39==2) ? surv_39_2 : surv_39_3;
    wire [1:0] best_state_38 = {surv_bit_39, best_state_39[1]};
    wire dec_bit_38 = best_state_38[0];
    wire surv_bit_38 = (best_state_38==0) ? surv_38_0 :
                        (best_state_38==1) ? surv_38_1 :
                        (best_state_38==2) ? surv_38_2 : surv_38_3;
    wire [1:0] best_state_37 = {surv_bit_38, best_state_38[1]};
    wire dec_bit_37 = best_state_37[0];
    wire surv_bit_37 = (best_state_37==0) ? surv_37_0 :
                        (best_state_37==1) ? surv_37_1 :
                        (best_state_37==2) ? surv_37_2 : surv_37_3;
    wire [1:0] best_state_36 = {surv_bit_37, best_state_37[1]};
    wire dec_bit_36 = best_state_36[0];
    wire surv_bit_36 = (best_state_36==0) ? surv_36_0 :
                        (best_state_36==1) ? surv_36_1 :
                        (best_state_36==2) ? surv_36_2 : surv_36_3;
    wire [1:0] best_state_35 = {surv_bit_36, best_state_36[1]};
    wire dec_bit_35 = best_state_35[0];
    wire surv_bit_35 = (best_state_35==0) ? surv_35_0 :
                        (best_state_35==1) ? surv_35_1 :
                        (best_state_35==2) ? surv_35_2 : surv_35_3;
    wire [1:0] best_state_34 = {surv_bit_35, best_state_35[1]};
    wire dec_bit_34 = best_state_34[0];
    wire surv_bit_34 = (best_state_34==0) ? surv_34_0 :
                        (best_state_34==1) ? surv_34_1 :
                        (best_state_34==2) ? surv_34_2 : surv_34_3;
    wire [1:0] best_state_33 = {surv_bit_34, best_state_34[1]};
    wire dec_bit_33 = best_state_33[0];
    wire surv_bit_33 = (best_state_33==0) ? surv_33_0 :
                        (best_state_33==1) ? surv_33_1 :
                        (best_state_33==2) ? surv_33_2 : surv_33_3;
    wire [1:0] best_state_32 = {surv_bit_33, best_state_33[1]};
    wire dec_bit_32 = best_state_32[0];
    wire surv_bit_32 = (best_state_32==0) ? surv_32_0 :
                        (best_state_32==1) ? surv_32_1 :
                        (best_state_32==2) ? surv_32_2 : surv_32_3;
    wire [1:0] best_state_31 = {surv_bit_32, best_state_32[1]};
    wire dec_bit_31 = best_state_31[0];
    wire surv_bit_31 = (best_state_31==0) ? surv_31_0 :
                        (best_state_31==1) ? surv_31_1 :
                        (best_state_31==2) ? surv_31_2 : surv_31_3;
    wire [1:0] best_state_30 = {surv_bit_31, best_state_31[1]};
    wire dec_bit_30 = best_state_30[0];
    wire surv_bit_30 = (best_state_30==0) ? surv_30_0 :
                        (best_state_30==1) ? surv_30_1 :
                        (best_state_30==2) ? surv_30_2 : surv_30_3;
    wire [1:0] best_state_29 = {surv_bit_30, best_state_30[1]};
    wire dec_bit_29 = best_state_29[0];
    wire surv_bit_29 = (best_state_29==0) ? surv_29_0 :
                        (best_state_29==1) ? surv_29_1 :
                        (best_state_29==2) ? surv_29_2 : surv_29_3;
    wire [1:0] best_state_28 = {surv_bit_29, best_state_29[1]};
    wire dec_bit_28 = best_state_28[0];
    wire surv_bit_28 = (best_state_28==0) ? surv_28_0 :
                        (best_state_28==1) ? surv_28_1 :
                        (best_state_28==2) ? surv_28_2 : surv_28_3;
    wire [1:0] best_state_27 = {surv_bit_28, best_state_28[1]};
    wire dec_bit_27 = best_state_27[0];
    wire surv_bit_27 = (best_state_27==0) ? surv_27_0 :
                        (best_state_27==1) ? surv_27_1 :
                        (best_state_27==2) ? surv_27_2 : surv_27_3;
    wire [1:0] best_state_26 = {surv_bit_27, best_state_27[1]};
    wire dec_bit_26 = best_state_26[0];
    wire surv_bit_26 = (best_state_26==0) ? surv_26_0 :
                        (best_state_26==1) ? surv_26_1 :
                        (best_state_26==2) ? surv_26_2 : surv_26_3;
    wire [1:0] best_state_25 = {surv_bit_26, best_state_26[1]};
    wire dec_bit_25 = best_state_25[0];
    wire surv_bit_25 = (best_state_25==0) ? surv_25_0 :
                        (best_state_25==1) ? surv_25_1 :
                        (best_state_25==2) ? surv_25_2 : surv_25_3;
    wire [1:0] best_state_24 = {surv_bit_25, best_state_25[1]};
    wire dec_bit_24 = best_state_24[0];
    wire surv_bit_24 = (best_state_24==0) ? surv_24_0 :
                        (best_state_24==1) ? surv_24_1 :
                        (best_state_24==2) ? surv_24_2 : surv_24_3;
    wire [1:0] best_state_23 = {surv_bit_24, best_state_24[1]};
    wire dec_bit_23 = best_state_23[0];
    wire surv_bit_23 = (best_state_23==0) ? surv_23_0 :
                        (best_state_23==1) ? surv_23_1 :
                        (best_state_23==2) ? surv_23_2 : surv_23_3;
    wire [1:0] best_state_22 = {surv_bit_23, best_state_23[1]};
    wire dec_bit_22 = best_state_22[0];
    wire surv_bit_22 = (best_state_22==0) ? surv_22_0 :
                        (best_state_22==1) ? surv_22_1 :
                        (best_state_22==2) ? surv_22_2 : surv_22_3;
    wire [1:0] best_state_21 = {surv_bit_22, best_state_22[1]};
    wire dec_bit_21 = best_state_21[0];
    wire surv_bit_21 = (best_state_21==0) ? surv_21_0 :
                        (best_state_21==1) ? surv_21_1 :
                        (best_state_21==2) ? surv_21_2 : surv_21_3;
    wire [1:0] best_state_20 = {surv_bit_21, best_state_21[1]};
    wire dec_bit_20 = best_state_20[0];
    wire surv_bit_20 = (best_state_20==0) ? surv_20_0 :
                        (best_state_20==1) ? surv_20_1 :
                        (best_state_20==2) ? surv_20_2 : surv_20_3;
    wire [1:0] best_state_19 = {surv_bit_20, best_state_20[1]};
    wire dec_bit_19 = best_state_19[0];
    wire surv_bit_19 = (best_state_19==0) ? surv_19_0 :
                        (best_state_19==1) ? surv_19_1 :
                        (best_state_19==2) ? surv_19_2 : surv_19_3;
    wire [1:0] best_state_18 = {surv_bit_19, best_state_19[1]};
    wire dec_bit_18 = best_state_18[0];
    wire surv_bit_18 = (best_state_18==0) ? surv_18_0 :
                        (best_state_18==1) ? surv_18_1 :
                        (best_state_18==2) ? surv_18_2 : surv_18_3;
    wire [1:0] best_state_17 = {surv_bit_18, best_state_18[1]};
    wire dec_bit_17 = best_state_17[0];
    wire surv_bit_17 = (best_state_17==0) ? surv_17_0 :
                        (best_state_17==1) ? surv_17_1 :
                        (best_state_17==2) ? surv_17_2 : surv_17_3;
    wire [1:0] best_state_16 = {surv_bit_17, best_state_17[1]};
    wire dec_bit_16 = best_state_16[0];
    wire surv_bit_16 = (best_state_16==0) ? surv_16_0 :
                        (best_state_16==1) ? surv_16_1 :
                        (best_state_16==2) ? surv_16_2 : surv_16_3;
    wire [1:0] best_state_15 = {surv_bit_16, best_state_16[1]};
    wire dec_bit_15 = best_state_15[0];
    wire surv_bit_15 = (best_state_15==0) ? surv_15_0 :
                        (best_state_15==1) ? surv_15_1 :
                        (best_state_15==2) ? surv_15_2 : surv_15_3;
    wire [1:0] best_state_14 = {surv_bit_15, best_state_15[1]};
    wire dec_bit_14 = best_state_14[0];
    wire surv_bit_14 = (best_state_14==0) ? surv_14_0 :
                        (best_state_14==1) ? surv_14_1 :
                        (best_state_14==2) ? surv_14_2 : surv_14_3;
    wire [1:0] best_state_13 = {surv_bit_14, best_state_14[1]};
    wire dec_bit_13 = best_state_13[0];
    wire surv_bit_13 = (best_state_13==0) ? surv_13_0 :
                        (best_state_13==1) ? surv_13_1 :
                        (best_state_13==2) ? surv_13_2 : surv_13_3;
    wire [1:0] best_state_12 = {surv_bit_13, best_state_13[1]};
    wire dec_bit_12 = best_state_12[0];
    wire surv_bit_12 = (best_state_12==0) ? surv_12_0 :
                        (best_state_12==1) ? surv_12_1 :
                        (best_state_12==2) ? surv_12_2 : surv_12_3;
    wire [1:0] best_state_11 = {surv_bit_12, best_state_12[1]};
    wire dec_bit_11 = best_state_11[0];
    wire surv_bit_11 = (best_state_11==0) ? surv_11_0 :
                        (best_state_11==1) ? surv_11_1 :
                        (best_state_11==2) ? surv_11_2 : surv_11_3;
    wire [1:0] best_state_10 = {surv_bit_11, best_state_11[1]};
    wire dec_bit_10 = best_state_10[0];
    wire surv_bit_10 = (best_state_10==0) ? surv_10_0 :
                        (best_state_10==1) ? surv_10_1 :
                        (best_state_10==2) ? surv_10_2 : surv_10_3;
    wire [1:0] best_state_9 = {surv_bit_10, best_state_10[1]};
    wire dec_bit_9 = best_state_9[0];
    wire surv_bit_9 = (best_state_9==0) ? surv_9_0 :
                        (best_state_9==1) ? surv_9_1 :
                        (best_state_9==2) ? surv_9_2 : surv_9_3;
    wire [1:0] best_state_8 = {surv_bit_9, best_state_9[1]};
    wire dec_bit_8 = best_state_8[0];
    wire surv_bit_8 = (best_state_8==0) ? surv_8_0 :
                        (best_state_8==1) ? surv_8_1 :
                        (best_state_8==2) ? surv_8_2 : surv_8_3;
    wire [1:0] best_state_7 = {surv_bit_8, best_state_8[1]};
    wire dec_bit_7 = best_state_7[0];
    wire surv_bit_7 = (best_state_7==0) ? surv_7_0 :
                        (best_state_7==1) ? surv_7_1 :
                        (best_state_7==2) ? surv_7_2 : surv_7_3;
    wire [1:0] best_state_6 = {surv_bit_7, best_state_7[1]};
    wire dec_bit_6 = best_state_6[0];
    wire surv_bit_6 = (best_state_6==0) ? surv_6_0 :
                        (best_state_6==1) ? surv_6_1 :
                        (best_state_6==2) ? surv_6_2 : surv_6_3;
    wire [1:0] best_state_5 = {surv_bit_6, best_state_6[1]};
    wire dec_bit_5 = best_state_5[0];
    wire surv_bit_5 = (best_state_5==0) ? surv_5_0 :
                        (best_state_5==1) ? surv_5_1 :
                        (best_state_5==2) ? surv_5_2 : surv_5_3;
    wire [1:0] best_state_4 = {surv_bit_5, best_state_5[1]};
    wire dec_bit_4 = best_state_4[0];
    wire surv_bit_4 = (best_state_4==0) ? surv_4_0 :
                        (best_state_4==1) ? surv_4_1 :
                        (best_state_4==2) ? surv_4_2 : surv_4_3;
    wire [1:0] best_state_3 = {surv_bit_4, best_state_4[1]};
    wire dec_bit_3 = best_state_3[0];
    wire surv_bit_3 = (best_state_3==0) ? surv_3_0 :
                        (best_state_3==1) ? surv_3_1 :
                        (best_state_3==2) ? surv_3_2 : surv_3_3;
    wire [1:0] best_state_2 = {surv_bit_3, best_state_3[1]};
    wire dec_bit_2 = best_state_2[0];
    wire surv_bit_2 = (best_state_2==0) ? surv_2_0 :
                        (best_state_2==1) ? surv_2_1 :
                        (best_state_2==2) ? surv_2_2 : surv_2_3;
    wire [1:0] best_state_1 = {surv_bit_2, best_state_2[1]};
    wire dec_bit_1 = best_state_1[0];
    wire surv_bit_1 = (best_state_1==0) ? surv_1_0 :
                        (best_state_1==1) ? surv_1_1 :
                        (best_state_1==2) ? surv_1_2 : surv_1_3;
    wire [1:0] best_state_0 = {surv_bit_1, best_state_1[1]};
    wire dec_bit_0 = best_state_0[0];
    wire [127:0] decoded_data = { dec_bit_127, dec_bit_126, dec_bit_125, dec_bit_124, dec_bit_123, dec_bit_122, dec_bit_121, dec_bit_120, dec_bit_119, dec_bit_118, dec_bit_117, dec_bit_116, dec_bit_115, dec_bit_114, dec_bit_113, dec_bit_112, dec_bit_111, dec_bit_110, dec_bit_109, dec_bit_108, dec_bit_107, dec_bit_106, dec_bit_105, dec_bit_104, dec_bit_103, dec_bit_102, dec_bit_101, dec_bit_100, dec_bit_99, dec_bit_98, dec_bit_97, dec_bit_96, dec_bit_95, dec_bit_94, dec_bit_93, dec_bit_92, dec_bit_91, dec_bit_90, dec_bit_89, dec_bit_88, dec_bit_87, dec_bit_86, dec_bit_85, dec_bit_84, dec_bit_83, dec_bit_82, dec_bit_81, dec_bit_80, dec_bit_79, dec_bit_78, dec_bit_77, dec_bit_76, dec_bit_75, dec_bit_74, dec_bit_73, dec_bit_72, dec_bit_71, dec_bit_70, dec_bit_69, dec_bit_68, dec_bit_67, dec_bit_66, dec_bit_65, dec_bit_64, dec_bit_63, dec_bit_62, dec_bit_61, dec_bit_60, dec_bit_59, dec_bit_58, dec_bit_57, dec_bit_56, dec_bit_55, dec_bit_54, dec_bit_53, dec_bit_52, dec_bit_51, dec_bit_50, dec_bit_49, dec_bit_48, dec_bit_47, dec_bit_46, dec_bit_45, dec_bit_44, dec_bit_43, dec_bit_42, dec_bit_41, dec_bit_40, dec_bit_39, dec_bit_38, dec_bit_37, dec_bit_36, dec_bit_35, dec_bit_34, dec_bit_33, dec_bit_32, dec_bit_31, dec_bit_30, dec_bit_29, dec_bit_28, dec_bit_27, dec_bit_26, dec_bit_25, dec_bit_24, dec_bit_23, dec_bit_22, dec_bit_21, dec_bit_20, dec_bit_19, dec_bit_18, dec_bit_17, dec_bit_16, dec_bit_15, dec_bit_14, dec_bit_13, dec_bit_12, dec_bit_11, dec_bit_10, dec_bit_9, dec_bit_8, dec_bit_7, dec_bit_6, dec_bit_5, dec_bit_4, dec_bit_3, dec_bit_2, dec_bit_1, dec_bit_0 };
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0;
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
            valid_out <= 0;
        end else begin
            valid_out <= 0;
            
            if (encode_en) begin
                codeword_out <= {parity2, parity1, data_in};
                valid_out <= 1'b1;
            end
            
            if (decode_en) begin
                data_out <= decoded_data;
                valid_out <= 1'b1;
                // Simple error detection: Encode decoded data and check against input parity?
                // Skipping for now to save area.
            end
        end
    end
endmodule