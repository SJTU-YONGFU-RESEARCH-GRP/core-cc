// Generated turbo_ecc_w64 - Real Hardware Turbo (PCCC)
// Encoder: 2x (1 + D + D^2) Non-Systematic Convolutional Encoders (Matching Python)
// Interleaver: Fixed Random Permutation (Seed 42)
// Decoder: Hard-Decision Viterbi for Constituent Code 1

module turbo_ecc_w64 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [63:0] data_in,
    input  wire [191:0] codeword_in,
    output reg  [191:0] codeword_out,
    output reg  [63:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // Interleaver map
    wire [63:0] interleaved_data;
    assign interleaved_data[23] = data_in[0];
    assign interleaved_data[25] = data_in[1];
    assign interleaved_data[7] = data_in[2];
    assign interleaved_data[22] = data_in[3];
    assign interleaved_data[45] = data_in[4];
    assign interleaved_data[33] = data_in[5];
    assign interleaved_data[19] = data_in[6];
    assign interleaved_data[59] = data_in[7];
    assign interleaved_data[46] = data_in[8];
    assign interleaved_data[9] = data_in[9];
    assign interleaved_data[40] = data_in[10];
    assign interleaved_data[18] = data_in[11];
    assign interleaved_data[42] = data_in[12];
    assign interleaved_data[31] = data_in[13];
    assign interleaved_data[16] = data_in[14];
    assign interleaved_data[21] = data_in[15];
    assign interleaved_data[36] = data_in[16];
    assign interleaved_data[41] = data_in[17];
    assign interleaved_data[29] = data_in[18];
    assign interleaved_data[20] = data_in[19];
    assign interleaved_data[11] = data_in[20];
    assign interleaved_data[50] = data_in[21];
    assign interleaved_data[39] = data_in[22];
    assign interleaved_data[48] = data_in[23];
    assign interleaved_data[3] = data_in[24];
    assign interleaved_data[30] = data_in[25];
    assign interleaved_data[24] = data_in[26];
    assign interleaved_data[55] = data_in[27];
    assign interleaved_data[4] = data_in[28];
    assign interleaved_data[57] = data_in[29];
    assign interleaved_data[54] = data_in[30];
    assign interleaved_data[49] = data_in[31];
    assign interleaved_data[10] = data_in[32];
    assign interleaved_data[0] = data_in[33];
    assign interleaved_data[60] = data_in[34];
    assign interleaved_data[28] = data_in[35];
    assign interleaved_data[44] = data_in[36];
    assign interleaved_data[26] = data_in[37];
    assign interleaved_data[52] = data_in[38];
    assign interleaved_data[12] = data_in[39];
    assign interleaved_data[35] = data_in[40];
    assign interleaved_data[53] = data_in[41];
    assign interleaved_data[38] = data_in[42];
    assign interleaved_data[32] = data_in[43];
    assign interleaved_data[58] = data_in[44];
    assign interleaved_data[13] = data_in[45];
    assign interleaved_data[51] = data_in[46];
    assign interleaved_data[62] = data_in[47];
    assign interleaved_data[2] = data_in[48];
    assign interleaved_data[27] = data_in[49];
    assign interleaved_data[37] = data_in[50];
    assign interleaved_data[5] = data_in[51];
    assign interleaved_data[34] = data_in[52];
    assign interleaved_data[56] = data_in[53];
    assign interleaved_data[43] = data_in[54];
    assign interleaved_data[6] = data_in[55];
    assign interleaved_data[61] = data_in[56];
    assign interleaved_data[8] = data_in[57];
    assign interleaved_data[63] = data_in[58];
    assign interleaved_data[15] = data_in[59];
    assign interleaved_data[17] = data_in[60];
    assign interleaved_data[47] = data_in[61];
    assign interleaved_data[1] = data_in[62];
    assign interleaved_data[14] = data_in[63];
    wire [63:0] parity1;
    wire [63:0] parity2;
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
    // Decoder: Viterbi Unrolled
    // Inputs
    wire [63:0] r_sys = codeword_in[63:0];
    wire [63:0] r_par1 = codeword_in[127:64];
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
    // Traceback
    wire [1:0] best_state_63;
    wire [8:0] min_pm_01 = (pm_63_0 < pm_63_1) ? pm_63_0 : pm_63_1;
    wire [8:0] min_pm_23 = (pm_63_2 < pm_63_3) ? pm_63_2 : pm_63_3;
    wire [8:0] min_pm_all = (min_pm_01 < min_pm_23) ? min_pm_01 : min_pm_23;
    assign best_state_63 = (pm_63_0 == min_pm_all) ? 2'd0 :
                                (pm_63_1 == min_pm_all) ? 2'd1 :
                                (pm_63_2 == min_pm_all) ? 2'd2 : 2'd3;
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
    wire [63:0] decoded_data = { dec_bit_63, dec_bit_62, dec_bit_61, dec_bit_60, dec_bit_59, dec_bit_58, dec_bit_57, dec_bit_56, dec_bit_55, dec_bit_54, dec_bit_53, dec_bit_52, dec_bit_51, dec_bit_50, dec_bit_49, dec_bit_48, dec_bit_47, dec_bit_46, dec_bit_45, dec_bit_44, dec_bit_43, dec_bit_42, dec_bit_41, dec_bit_40, dec_bit_39, dec_bit_38, dec_bit_37, dec_bit_36, dec_bit_35, dec_bit_34, dec_bit_33, dec_bit_32, dec_bit_31, dec_bit_30, dec_bit_29, dec_bit_28, dec_bit_27, dec_bit_26, dec_bit_25, dec_bit_24, dec_bit_23, dec_bit_22, dec_bit_21, dec_bit_20, dec_bit_19, dec_bit_18, dec_bit_17, dec_bit_16, dec_bit_15, dec_bit_14, dec_bit_13, dec_bit_12, dec_bit_11, dec_bit_10, dec_bit_9, dec_bit_8, dec_bit_7, dec_bit_6, dec_bit_5, dec_bit_4, dec_bit_3, dec_bit_2, dec_bit_1, dec_bit_0 };
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