// Generated turbo_ecc_w8 - Real Hardware Turbo (PCCC)
// Encoder: 2x (1 + D + D^2) Non-Systematic Convolutional Encoders (Matching Python)
// Interleaver: Fixed Random Permutation (Seed 42)
// Decoder: Hard-Decision Viterbi for Constituent Code 1

module turbo_ecc_w8 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [7:0] data_in,
    input  wire [23:0] codeword_in,
    output reg  [23:0] codeword_out,
    output reg  [7:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // Interleaver map
    wire [7:0] interleaved_data;
    assign interleaved_data[3] = data_in[0];
    assign interleaved_data[4] = data_in[1];
    assign interleaved_data[6] = data_in[2];
    assign interleaved_data[7] = data_in[3];
    assign interleaved_data[2] = data_in[4];
    assign interleaved_data[5] = data_in[5];
    assign interleaved_data[0] = data_in[6];
    assign interleaved_data[1] = data_in[7];
    wire [7:0] parity1;
    wire [7:0] parity2;
    assign parity1[0] = data_in[0] ^ 1'b0 ^ 1'b0;
    assign parity1[1] = data_in[1] ^ data_in[0] ^ 1'b0;
    assign parity1[2] = data_in[2] ^ data_in[1] ^ data_in[0];
    assign parity1[3] = data_in[3] ^ data_in[2] ^ data_in[1];
    assign parity1[4] = data_in[4] ^ data_in[3] ^ data_in[2];
    assign parity1[5] = data_in[5] ^ data_in[4] ^ data_in[3];
    assign parity1[6] = data_in[6] ^ data_in[5] ^ data_in[4];
    assign parity1[7] = data_in[7] ^ data_in[6] ^ data_in[5];
    assign parity2[0] = interleaved_data[0] ^ 1'b0 ^ 1'b0;
    assign parity2[1] = interleaved_data[1] ^ interleaved_data[0] ^ 1'b0;
    assign parity2[2] = interleaved_data[2] ^ interleaved_data[1] ^ interleaved_data[0];
    assign parity2[3] = interleaved_data[3] ^ interleaved_data[2] ^ interleaved_data[1];
    assign parity2[4] = interleaved_data[4] ^ interleaved_data[3] ^ interleaved_data[2];
    assign parity2[5] = interleaved_data[5] ^ interleaved_data[4] ^ interleaved_data[3];
    assign parity2[6] = interleaved_data[6] ^ interleaved_data[5] ^ interleaved_data[4];
    assign parity2[7] = interleaved_data[7] ^ interleaved_data[6] ^ interleaved_data[5];
    // Decoder: Viterbi Unrolled
    // Inputs
    wire [7:0] r_sys = codeword_in[7:0];
    wire [7:0] r_par1 = codeword_in[15:8];
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
    // Traceback
    wire [1:0] best_state_7;
    wire [8:0] min_pm_01 = (pm_7_0 < pm_7_1) ? pm_7_0 : pm_7_1;
    wire [8:0] min_pm_23 = (pm_7_2 < pm_7_3) ? pm_7_2 : pm_7_3;
    wire [8:0] min_pm_all = (min_pm_01 < min_pm_23) ? min_pm_01 : min_pm_23;
    assign best_state_7 = (pm_7_0 == min_pm_all) ? 2'd0 :
                                (pm_7_1 == min_pm_all) ? 2'd1 :
                                (pm_7_2 == min_pm_all) ? 2'd2 : 2'd3;
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
    wire [7:0] decoded_data = { dec_bit_7, dec_bit_6, dec_bit_5, dec_bit_4, dec_bit_3, dec_bit_2, dec_bit_1, dec_bit_0 };
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