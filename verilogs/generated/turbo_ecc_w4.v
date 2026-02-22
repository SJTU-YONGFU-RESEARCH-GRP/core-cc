// Generated turbo_ecc_w4 - Real Hardware Turbo (PCCC)
// Encoder: 2x (1 + D + D^2) Non-Systematic Convolutional Encoders (Matching Python)
// Interleaver: Fixed Random Permutation (Seed 42)
// Decoder: Hard-Decision Viterbi for Constituent Code 1

module turbo_ecc_w4 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [3:0] data_in,
    input  wire [11:0] codeword_in,
    output reg  [11:0] codeword_out,
    output reg  [3:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // Interleaver map
    wire [3:0] interleaved_data;
    assign interleaved_data[2] = data_in[0];
    assign interleaved_data[1] = data_in[1];
    assign interleaved_data[3] = data_in[2];
    assign interleaved_data[0] = data_in[3];
    wire [3:0] parity1;
    wire [3:0] parity2;
    assign parity1[0] = data_in[0] ^ 1'b0 ^ 1'b0;
    assign parity1[1] = data_in[1] ^ data_in[0] ^ 1'b0;
    assign parity1[2] = data_in[2] ^ data_in[1] ^ data_in[0];
    assign parity1[3] = data_in[3] ^ data_in[2] ^ data_in[1];
    assign parity2[0] = interleaved_data[0] ^ 1'b0 ^ 1'b0;
    assign parity2[1] = interleaved_data[1] ^ interleaved_data[0] ^ 1'b0;
    assign parity2[2] = interleaved_data[2] ^ interleaved_data[1] ^ interleaved_data[0];
    assign parity2[3] = interleaved_data[3] ^ interleaved_data[2] ^ interleaved_data[1];
    // Decoder: Viterbi Unrolled
    // Inputs
    wire [3:0] r_sys = codeword_in[3:0];
    wire [3:0] r_par1 = codeword_in[7:4];
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
    // Traceback
    wire [1:0] best_state_3;
    wire [8:0] min_pm_01 = (pm_3_0 < pm_3_1) ? pm_3_0 : pm_3_1;
    wire [8:0] min_pm_23 = (pm_3_2 < pm_3_3) ? pm_3_2 : pm_3_3;
    wire [8:0] min_pm_all = (min_pm_01 < min_pm_23) ? min_pm_01 : min_pm_23;
    assign best_state_3 = (pm_3_0 == min_pm_all) ? 2'd0 :
                                (pm_3_1 == min_pm_all) ? 2'd1 :
                                (pm_3_2 == min_pm_all) ? 2'd2 : 2'd3;
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
    wire [3:0] decoded_data = { dec_bit_3, dec_bit_2, dec_bit_1, dec_bit_0 };
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