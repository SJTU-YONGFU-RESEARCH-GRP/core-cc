// Generated turbo_ecc_w32 - Real Hardware Turbo (PCCC)
// Encoder: 2x (1 + D + D^2) Non-Systematic Convolutional Encoders (Matching Python)
// Interleaver: Fixed Random Permutation (Seed 42)
// Decoder: Hard-Decision Viterbi for Constituent Code 1

module turbo_ecc_w32 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [31:0] data_in,
    input  wire [95:0] codeword_in,
    output reg  [95:0] codeword_out,
    output reg  [31:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // Interleaver map
    wire [31:0] interleaved_data;
    assign interleaved_data[26] = data_in[0];
    assign interleaved_data[5] = data_in[1];
    assign interleaved_data[10] = data_in[2];
    assign interleaved_data[15] = data_in[3];
    assign interleaved_data[25] = data_in[4];
    assign interleaved_data[11] = data_in[5];
    assign interleaved_data[22] = data_in[6];
    assign interleaved_data[6] = data_in[7];
    assign interleaved_data[19] = data_in[8];
    assign interleaved_data[12] = data_in[9];
    assign interleaved_data[16] = data_in[10];
    assign interleaved_data[9] = data_in[11];
    assign interleaved_data[28] = data_in[12];
    assign interleaved_data[14] = data_in[13];
    assign interleaved_data[24] = data_in[14];
    assign interleaved_data[20] = data_in[15];
    assign interleaved_data[30] = data_in[16];
    assign interleaved_data[1] = data_in[17];
    assign interleaved_data[13] = data_in[18];
    assign interleaved_data[18] = data_in[19];
    assign interleaved_data[2] = data_in[20];
    assign interleaved_data[17] = data_in[21];
    assign interleaved_data[21] = data_in[22];
    assign interleaved_data[3] = data_in[23];
    assign interleaved_data[29] = data_in[24];
    assign interleaved_data[4] = data_in[25];
    assign interleaved_data[27] = data_in[26];
    assign interleaved_data[31] = data_in[27];
    assign interleaved_data[8] = data_in[28];
    assign interleaved_data[23] = data_in[29];
    assign interleaved_data[0] = data_in[30];
    assign interleaved_data[7] = data_in[31];
    wire [31:0] parity1;
    wire [31:0] parity2;
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
    // Decoder: Viterbi Unrolled
    // Inputs
    wire [31:0] r_sys = codeword_in[31:0];
    wire [31:0] r_par1 = codeword_in[63:32];
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
    // Traceback
    wire [1:0] best_state_31;
    wire [8:0] min_pm_01 = (pm_31_0 < pm_31_1) ? pm_31_0 : pm_31_1;
    wire [8:0] min_pm_23 = (pm_31_2 < pm_31_3) ? pm_31_2 : pm_31_3;
    wire [8:0] min_pm_all = (min_pm_01 < min_pm_23) ? min_pm_01 : min_pm_23;
    assign best_state_31 = (pm_31_0 == min_pm_all) ? 2'd0 :
                                (pm_31_1 == min_pm_all) ? 2'd1 :
                                (pm_31_2 == min_pm_all) ? 2'd2 : 2'd3;
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
    wire [31:0] decoded_data = { dec_bit_31, dec_bit_30, dec_bit_29, dec_bit_28, dec_bit_27, dec_bit_26, dec_bit_25, dec_bit_24, dec_bit_23, dec_bit_22, dec_bit_21, dec_bit_20, dec_bit_19, dec_bit_18, dec_bit_17, dec_bit_16, dec_bit_15, dec_bit_14, dec_bit_13, dec_bit_12, dec_bit_11, dec_bit_10, dec_bit_9, dec_bit_8, dec_bit_7, dec_bit_6, dec_bit_5, dec_bit_4, dec_bit_3, dec_bit_2, dec_bit_1, dec_bit_0 };
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