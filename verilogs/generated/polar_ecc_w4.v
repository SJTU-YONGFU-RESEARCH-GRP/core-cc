// Generated polar_ecc_w4 - Real Hardware Polar Code (SC Decoder)
// N=8, K=4 (Recursive Construction)

module polar_ecc_w4 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [3:0] data_in,
    input  wire [7:0] codeword_in,
    output reg  [7:0] codeword_out,
    output reg  [3:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // Saturation Arithmetic Functions
    function signed [5:0] sat_add;
        input signed [5:0] a;
        input signed [5:0] b;
        reg signed [6:0] sum;
        begin
            sum = a + b;
            if (sum > 31) sat_add = 31;
            else if (sum < -32) sat_add = -32;
            else sat_add = sum[5:0];
        end
    endfunction
    
    function signed [5:0] sat_sub;
        input signed [5:0] a;
        input signed [5:0] b;
        reg signed [6:0] diff;
        begin
            diff = a - b;
            if (diff > 31) sat_sub = 31;
            else if (diff < -32) sat_sub = -32;
            else sat_sub = diff[5:0];
        end
    endfunction
    
    function [5:0] safe_abs;
        input signed [5:0] a;
        begin
            if (a == -32) safe_abs = 31; // Clamp MAX negative
            else safe_abs = (a < 0) ? -a : a;
        end
    endfunction
    // Encoder Logic
    wire [7:0] u_vec;
    assign u_vec[0] = 1'b0;
    assign u_vec[1] = 1'b0;
    assign u_vec[2] = 1'b0;
    assign u_vec[3] = data_in[0];
    assign u_vec[4] = 1'b0;
    assign u_vec[5] = data_in[1];
    assign u_vec[6] = data_in[2];
    assign u_vec[7] = data_in[3];
    wire enc_s0_0 = u_vec[0];
    wire enc_s0_1 = u_vec[1];
    wire enc_s0_2 = u_vec[2];
    wire enc_s0_3 = u_vec[3];
    wire enc_s0_4 = u_vec[4];
    wire enc_s0_5 = u_vec[5];
    wire enc_s0_6 = u_vec[6];
    wire enc_s0_7 = u_vec[7];
    wire enc_s1_0 = enc_s0_0 ^ enc_s0_1;
    wire enc_s1_1 = enc_s0_1;
    wire enc_s1_2 = enc_s0_2 ^ enc_s0_3;
    wire enc_s1_3 = enc_s0_3;
    wire enc_s1_4 = enc_s0_4 ^ enc_s0_5;
    wire enc_s1_5 = enc_s0_5;
    wire enc_s1_6 = enc_s0_6 ^ enc_s0_7;
    wire enc_s1_7 = enc_s0_7;
    wire enc_s2_0 = enc_s1_0 ^ enc_s1_2;
    wire enc_s2_2 = enc_s1_2;
    wire enc_s2_1 = enc_s1_1 ^ enc_s1_3;
    wire enc_s2_3 = enc_s1_3;
    wire enc_s2_4 = enc_s1_4 ^ enc_s1_6;
    wire enc_s2_6 = enc_s1_6;
    wire enc_s2_5 = enc_s1_5 ^ enc_s1_7;
    wire enc_s2_7 = enc_s1_7;
    wire enc_s3_0 = enc_s2_0 ^ enc_s2_4;
    wire enc_s3_4 = enc_s2_4;
    wire enc_s3_1 = enc_s2_1 ^ enc_s2_5;
    wire enc_s3_5 = enc_s2_5;
    wire enc_s3_2 = enc_s2_2 ^ enc_s2_6;
    wire enc_s3_6 = enc_s2_6;
    wire enc_s3_3 = enc_s2_3 ^ enc_s2_7;
    wire enc_s3_7 = enc_s2_7;
    wire [7:0] encoded_result;
    assign encoded_result[0] = enc_s3_0;
    assign encoded_result[1] = enc_s3_1;
    assign encoded_result[2] = enc_s3_2;
    assign encoded_result[3] = enc_s3_3;
    assign encoded_result[4] = enc_s3_4;
    assign encoded_result[5] = enc_s3_5;
    assign encoded_result[6] = enc_s3_6;
    assign encoded_result[7] = enc_s3_7;
    // Decoder Logic (6-bit Saturated)
    wire signed [5:0] llr_ch_0 = codeword_in[0] ? -6'sd8 : 6'sd8;
    wire signed [5:0] llr_ch_1 = codeword_in[1] ? -6'sd8 : 6'sd8;
    wire signed [5:0] llr_ch_2 = codeword_in[2] ? -6'sd8 : 6'sd8;
    wire signed [5:0] llr_ch_3 = codeword_in[3] ? -6'sd8 : 6'sd8;
    wire signed [5:0] llr_ch_4 = codeword_in[4] ? -6'sd8 : 6'sd8;
    wire signed [5:0] llr_ch_5 = codeword_in[5] ? -6'sd8 : 6'sd8;
    wire signed [5:0] llr_ch_6 = codeword_in[6] ? -6'sd8 : 6'sd8;
    wire signed [5:0] llr_ch_7 = codeword_in[7] ? -6'sd8 : 6'sd8;
    wire [5:0] abs_llr_s2_r0_T = safe_abs(llr_ch_0);
    wire [5:0] abs_llr_s2_r0_B = safe_abs(llr_ch_4);
    wire [5:0] min_llr_s2_r0 = (abs_llr_s2_r0_T < abs_llr_s2_r0_B) ? abs_llr_s2_r0_T : abs_llr_s2_r0_B;
    wire sign_llr_s2_r0 = llr_ch_0[5] ^ llr_ch_4[5];
    wire signed [5:0] llr_s2_r0 = sign_llr_s2_r0 ? -min_llr_s2_r0 : min_llr_s2_r0;
    wire [5:0] abs_llr_s2_r2_T = safe_abs(llr_ch_2);
    wire [5:0] abs_llr_s2_r2_B = safe_abs(llr_ch_6);
    wire [5:0] min_llr_s2_r2 = (abs_llr_s2_r2_T < abs_llr_s2_r2_B) ? abs_llr_s2_r2_T : abs_llr_s2_r2_B;
    wire sign_llr_s2_r2 = llr_ch_2[5] ^ llr_ch_6[5];
    wire signed [5:0] llr_s2_r2 = sign_llr_s2_r2 ? -min_llr_s2_r2 : min_llr_s2_r2;
    wire [5:0] abs_llr_s1_r0_T = safe_abs(llr_s2_r0);
    wire [5:0] abs_llr_s1_r0_B = safe_abs(llr_s2_r2);
    wire [5:0] min_llr_s1_r0 = (abs_llr_s1_r0_T < abs_llr_s1_r0_B) ? abs_llr_s1_r0_T : abs_llr_s1_r0_B;
    wire sign_llr_s1_r0 = llr_s2_r0[5] ^ llr_s2_r2[5];
    wire signed [5:0] llr_s1_r0 = sign_llr_s1_r0 ? -min_llr_s1_r0 : min_llr_s1_r0;
    wire [5:0] abs_llr_s2_r1_T = safe_abs(llr_ch_1);
    wire [5:0] abs_llr_s2_r1_B = safe_abs(llr_ch_5);
    wire [5:0] min_llr_s2_r1 = (abs_llr_s2_r1_T < abs_llr_s2_r1_B) ? abs_llr_s2_r1_T : abs_llr_s2_r1_B;
    wire sign_llr_s2_r1 = llr_ch_1[5] ^ llr_ch_5[5];
    wire signed [5:0] llr_s2_r1 = sign_llr_s2_r1 ? -min_llr_s2_r1 : min_llr_s2_r1;
    wire [5:0] abs_llr_s2_r3_T = safe_abs(llr_ch_3);
    wire [5:0] abs_llr_s2_r3_B = safe_abs(llr_ch_7);
    wire [5:0] min_llr_s2_r3 = (abs_llr_s2_r3_T < abs_llr_s2_r3_B) ? abs_llr_s2_r3_T : abs_llr_s2_r3_B;
    wire sign_llr_s2_r3 = llr_ch_3[5] ^ llr_ch_7[5];
    wire signed [5:0] llr_s2_r3 = sign_llr_s2_r3 ? -min_llr_s2_r3 : min_llr_s2_r3;
    wire [5:0] abs_llr_s1_r1_T = safe_abs(llr_s2_r1);
    wire [5:0] abs_llr_s1_r1_B = safe_abs(llr_s2_r3);
    wire [5:0] min_llr_s1_r1 = (abs_llr_s1_r1_T < abs_llr_s1_r1_B) ? abs_llr_s1_r1_T : abs_llr_s1_r1_B;
    wire sign_llr_s1_r1 = llr_s2_r1[5] ^ llr_s2_r3[5];
    wire signed [5:0] llr_s1_r1 = sign_llr_s1_r1 ? -min_llr_s1_r1 : min_llr_s1_r1;
    wire [5:0] abs_llr_s0_r0_T = safe_abs(llr_s1_r0);
    wire [5:0] abs_llr_s0_r0_B = safe_abs(llr_s1_r1);
    wire [5:0] min_llr_s0_r0 = (abs_llr_s0_r0_T < abs_llr_s0_r0_B) ? abs_llr_s0_r0_T : abs_llr_s0_r0_B;
    wire sign_llr_s0_r0 = llr_s1_r0[5] ^ llr_s1_r1[5];
    wire signed [5:0] llr_s0_r0 = sign_llr_s0_r0 ? -min_llr_s0_r0 : min_llr_s0_r0;
    wire u_est_0 = 1'b0;
    wire signed [5:0] llr_s0_r1 = u_est_0 ? sat_sub(llr_s1_r1, llr_s1_r0) : sat_add(llr_s1_r1, llr_s1_r0);
    wire u_est_1 = 1'b0;
    wire psum_s1_0 = u_est_0 ^ u_est_1;
    wire signed [5:0] llr_s1_r2 = psum_s1_0 ? sat_sub(llr_s2_r2, llr_s2_r0) : sat_add(llr_s2_r2, llr_s2_r0);
    wire psum_s1_1 = u_est_1;
    wire signed [5:0] llr_s1_r3 = psum_s1_1 ? sat_sub(llr_s2_r3, llr_s2_r1) : sat_add(llr_s2_r3, llr_s2_r1);
    wire [5:0] abs_llr_s0_r2_T = safe_abs(llr_s1_r2);
    wire [5:0] abs_llr_s0_r2_B = safe_abs(llr_s1_r3);
    wire [5:0] min_llr_s0_r2 = (abs_llr_s0_r2_T < abs_llr_s0_r2_B) ? abs_llr_s0_r2_T : abs_llr_s0_r2_B;
    wire sign_llr_s0_r2 = llr_s1_r2[5] ^ llr_s1_r3[5];
    wire signed [5:0] llr_s0_r2 = sign_llr_s0_r2 ? -min_llr_s0_r2 : min_llr_s0_r2;
    wire u_est_2 = 1'b0;
    wire signed [5:0] llr_s0_r3 = u_est_2 ? sat_sub(llr_s1_r3, llr_s1_r2) : sat_add(llr_s1_r3, llr_s1_r2);
    wire u_est_3 = llr_s0_r3[5];
    wire psum_s1_2 = u_est_2 ^ u_est_3;
    wire psum_s2_0 = psum_s1_0 ^ psum_s1_2;
    wire signed [5:0] llr_s2_r4 = psum_s2_0 ? sat_sub(llr_ch_4, llr_ch_0) : sat_add(llr_ch_4, llr_ch_0);
    wire psum_s2_2 = psum_s1_2;
    wire signed [5:0] llr_s2_r6 = psum_s2_2 ? sat_sub(llr_ch_6, llr_ch_2) : sat_add(llr_ch_6, llr_ch_2);
    wire [5:0] abs_llr_s1_r4_T = safe_abs(llr_s2_r4);
    wire [5:0] abs_llr_s1_r4_B = safe_abs(llr_s2_r6);
    wire [5:0] min_llr_s1_r4 = (abs_llr_s1_r4_T < abs_llr_s1_r4_B) ? abs_llr_s1_r4_T : abs_llr_s1_r4_B;
    wire sign_llr_s1_r4 = llr_s2_r4[5] ^ llr_s2_r6[5];
    wire signed [5:0] llr_s1_r4 = sign_llr_s1_r4 ? -min_llr_s1_r4 : min_llr_s1_r4;
    wire psum_s1_3 = u_est_3;
    wire psum_s2_1 = psum_s1_1 ^ psum_s1_3;
    wire signed [5:0] llr_s2_r5 = psum_s2_1 ? sat_sub(llr_ch_5, llr_ch_1) : sat_add(llr_ch_5, llr_ch_1);
    wire psum_s2_3 = psum_s1_3;
    wire signed [5:0] llr_s2_r7 = psum_s2_3 ? sat_sub(llr_ch_7, llr_ch_3) : sat_add(llr_ch_7, llr_ch_3);
    wire [5:0] abs_llr_s1_r5_T = safe_abs(llr_s2_r5);
    wire [5:0] abs_llr_s1_r5_B = safe_abs(llr_s2_r7);
    wire [5:0] min_llr_s1_r5 = (abs_llr_s1_r5_T < abs_llr_s1_r5_B) ? abs_llr_s1_r5_T : abs_llr_s1_r5_B;
    wire sign_llr_s1_r5 = llr_s2_r5[5] ^ llr_s2_r7[5];
    wire signed [5:0] llr_s1_r5 = sign_llr_s1_r5 ? -min_llr_s1_r5 : min_llr_s1_r5;
    wire [5:0] abs_llr_s0_r4_T = safe_abs(llr_s1_r4);
    wire [5:0] abs_llr_s0_r4_B = safe_abs(llr_s1_r5);
    wire [5:0] min_llr_s0_r4 = (abs_llr_s0_r4_T < abs_llr_s0_r4_B) ? abs_llr_s0_r4_T : abs_llr_s0_r4_B;
    wire sign_llr_s0_r4 = llr_s1_r4[5] ^ llr_s1_r5[5];
    wire signed [5:0] llr_s0_r4 = sign_llr_s0_r4 ? -min_llr_s0_r4 : min_llr_s0_r4;
    wire u_est_4 = 1'b0;
    wire signed [5:0] llr_s0_r5 = u_est_4 ? sat_sub(llr_s1_r5, llr_s1_r4) : sat_add(llr_s1_r5, llr_s1_r4);
    wire u_est_5 = llr_s0_r5[5];
    wire psum_s1_4 = u_est_4 ^ u_est_5;
    wire signed [5:0] llr_s1_r6 = psum_s1_4 ? sat_sub(llr_s2_r6, llr_s2_r4) : sat_add(llr_s2_r6, llr_s2_r4);
    wire psum_s1_5 = u_est_5;
    wire signed [5:0] llr_s1_r7 = psum_s1_5 ? sat_sub(llr_s2_r7, llr_s2_r5) : sat_add(llr_s2_r7, llr_s2_r5);
    wire [5:0] abs_llr_s0_r6_T = safe_abs(llr_s1_r6);
    wire [5:0] abs_llr_s0_r6_B = safe_abs(llr_s1_r7);
    wire [5:0] min_llr_s0_r6 = (abs_llr_s0_r6_T < abs_llr_s0_r6_B) ? abs_llr_s0_r6_T : abs_llr_s0_r6_B;
    wire sign_llr_s0_r6 = llr_s1_r6[5] ^ llr_s1_r7[5];
    wire signed [5:0] llr_s0_r6 = sign_llr_s0_r6 ? -min_llr_s0_r6 : min_llr_s0_r6;
    wire u_est_6 = llr_s0_r6[5];
    wire signed [5:0] llr_s0_r7 = u_est_6 ? sat_sub(llr_s1_r7, llr_s1_r6) : sat_add(llr_s1_r7, llr_s1_r6);
    wire u_est_7 = llr_s0_r7[5];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0; data_out <= 0; valid_out <= 0;
        end else if (encode_en) begin
            codeword_out <= encoded_result; valid_out <= 1; error_detected<=0; error_corrected<=0;
        end else if (decode_en) begin
            valid_out <= 1; error_detected<=0; error_corrected<=0;
            data_out[0] <= u_est_3;
            data_out[1] <= u_est_5;
            data_out[2] <= u_est_6;
            data_out[3] <= u_est_7;
        end else valid_out <= 0;
    end
endmodule