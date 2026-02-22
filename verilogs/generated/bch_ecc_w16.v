// Generated bch_ecc_w16 - Real Hardware Encoder/Detector
module bch_ecc_w16 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [15:0] data_in,
    input  wire [30:0] codeword_in,
    output reg  [30:0] codeword_out,
    output reg  [15:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // Configuration: n=31, k=16, t=3
    // Generator Poly Limit: x^15
    wire [15:0] data_k = data_in;
    wire [14:0] parity;
    assign parity[0] = data_k[0] ^ data_k[4] ^ data_k[5] ^ data_k[6] ^ data_k[7] ^ data_k[12] ^ data_k[15];
    assign parity[1] = data_k[0] ^ data_k[1] ^ data_k[4] ^ data_k[8] ^ data_k[12] ^ data_k[13] ^ data_k[15];
    assign parity[2] = data_k[0] ^ data_k[1] ^ data_k[2] ^ data_k[4] ^ data_k[6] ^ data_k[7] ^ data_k[9] ^ data_k[12] ^ data_k[13] ^ data_k[14] ^ data_k[15];
    assign parity[3] = data_k[0] ^ data_k[1] ^ data_k[2] ^ data_k[3] ^ data_k[4] ^ data_k[6] ^ data_k[8] ^ data_k[10] ^ data_k[12] ^ data_k[13] ^ data_k[14];
    assign parity[4] = data_k[1] ^ data_k[2] ^ data_k[3] ^ data_k[4] ^ data_k[5] ^ data_k[7] ^ data_k[9] ^ data_k[11] ^ data_k[13] ^ data_k[14] ^ data_k[15];
    assign parity[5] = data_k[0] ^ data_k[2] ^ data_k[3] ^ data_k[7] ^ data_k[8] ^ data_k[10] ^ data_k[14];
    assign parity[6] = data_k[1] ^ data_k[3] ^ data_k[4] ^ data_k[8] ^ data_k[9] ^ data_k[11] ^ data_k[15];
    assign parity[7] = data_k[0] ^ data_k[2] ^ data_k[6] ^ data_k[7] ^ data_k[9] ^ data_k[10] ^ data_k[15];
    assign parity[8] = data_k[0] ^ data_k[1] ^ data_k[3] ^ data_k[4] ^ data_k[5] ^ data_k[6] ^ data_k[8] ^ data_k[10] ^ data_k[11] ^ data_k[12] ^ data_k[15];
    assign parity[9] = data_k[0] ^ data_k[1] ^ data_k[2] ^ data_k[9] ^ data_k[11] ^ data_k[13] ^ data_k[15];
    assign parity[10] = data_k[0] ^ data_k[1] ^ data_k[2] ^ data_k[3] ^ data_k[4] ^ data_k[5] ^ data_k[6] ^ data_k[7] ^ data_k[10] ^ data_k[14] ^ data_k[15];
    assign parity[11] = data_k[0] ^ data_k[1] ^ data_k[2] ^ data_k[3] ^ data_k[8] ^ data_k[11] ^ data_k[12];
    assign parity[12] = data_k[1] ^ data_k[2] ^ data_k[3] ^ data_k[4] ^ data_k[9] ^ data_k[12] ^ data_k[13];
    assign parity[13] = data_k[2] ^ data_k[3] ^ data_k[4] ^ data_k[5] ^ data_k[10] ^ data_k[13] ^ data_k[14];
    assign parity[14] = data_k[3] ^ data_k[4] ^ data_k[5] ^ data_k[6] ^ data_k[11] ^ data_k[14] ^ data_k[15];
    wire [29:0] syndromes_flat;
    wire synd_1_0 = codeword_in[0] ^ codeword_in[5] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[16] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[29];
    wire synd_1_1 = codeword_in[1] ^ codeword_in[6] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[15] ^ codeword_in[16] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[30];
    wire synd_1_2 = codeword_in[2] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[19] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28];
    wire synd_1_3 = codeword_in[3] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[16] ^ codeword_in[20] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29];
    wire synd_1_4 = codeword_in[4] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[10] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[16] ^ codeword_in[17] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[30];
    wire synd_2_0 = codeword_in[0] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[18] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30];
    wire synd_2_1 = codeword_in[3] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[16] ^ codeword_in[20] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29];
    wire synd_2_2 = codeword_in[1] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27];
    wire synd_2_3 = codeword_in[3] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[17] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30];
    wire synd_2_4 = codeword_in[2] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[19] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28];
    wire synd_3_0 = codeword_in[0] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[9] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[20] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[29];
    wire synd_3_1 = codeword_in[2] ^ codeword_in[3] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[10] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[30];
    wire synd_3_2 = codeword_in[4] ^ codeword_in[5] ^ codeword_in[8] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[30];
    wire synd_3_3 = codeword_in[1] ^ codeword_in[2] ^ codeword_in[3] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[29];
    wire synd_3_4 = codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[15] ^ codeword_in[16] ^ codeword_in[19] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30];
    wire synd_4_0 = codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[9] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[20] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[30];
    wire synd_4_1 = codeword_in[3] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[17] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30];
    wire synd_4_2 = codeword_in[2] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[16] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[29];
    wire synd_4_3 = codeword_in[2] ^ codeword_in[3] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[24] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[30];
    wire synd_4_4 = codeword_in[1] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27];
    wire synd_5_0 = codeword_in[0] ^ codeword_in[1] ^ codeword_in[2] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[9] ^ codeword_in[12] ^ codeword_in[14] ^ codeword_in[16] ^ codeword_in[17] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[30];
    wire synd_5_1 = codeword_in[3] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[16] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[30];
    wire synd_5_2 = codeword_in[1] ^ codeword_in[3] ^ codeword_in[4] ^ codeword_in[9] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[20] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[27] ^ codeword_in[30];
    wire synd_5_3 = codeword_in[3] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[21] ^ codeword_in[24] ^ codeword_in[26] ^ codeword_in[28] ^ codeword_in[29];
    wire synd_5_4 = codeword_in[2] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[15] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30];
    wire synd_6_0 = codeword_in[0] ^ codeword_in[3] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[30];
    wire synd_6_1 = codeword_in[1] ^ codeword_in[2] ^ codeword_in[3] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[9] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[20] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[29];
    wire synd_6_2 = codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[18] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[29];
    wire synd_6_3 = codeword_in[1] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[9] ^ codeword_in[10] ^ codeword_in[13] ^ codeword_in[16] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[20] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[28] ^ codeword_in[30];
    wire synd_6_4 = codeword_in[4] ^ codeword_in[5] ^ codeword_in[8] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[30];
    wire any_syndrome = synd_1_0 | synd_1_1 | synd_1_2 | synd_1_3 | synd_1_4 | synd_2_0 | synd_2_1 | synd_2_2 | synd_2_3 | synd_2_4 | synd_3_0 | synd_3_1 | synd_3_2 | synd_3_3 | synd_3_4 | synd_4_0 | synd_4_1 | synd_4_2 | synd_4_3 | synd_4_4 | synd_5_0 | synd_5_1 | synd_5_2 | synd_5_3 | synd_5_4 | synd_6_0 | synd_6_1 | synd_6_2 | synd_6_3 | synd_6_4;
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
                codeword_out <= {data_k, parity};
                valid_out <= 1'b1;
            end
            
            if (decode_en) begin
                // Extract Systematic Data
                data_out <= codeword_in[30:15];
                error_detected <= any_syndrome;
                error_corrected <= 1'b0; // Corrected placeholder
                valid_out <= 1'b1;
            end
        end
    end
endmodule