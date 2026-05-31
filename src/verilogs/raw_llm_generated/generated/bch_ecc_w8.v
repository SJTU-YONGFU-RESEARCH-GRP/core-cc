// Generated bch_ecc_w8 - Real Hardware Encoder/Detector
module bch_ecc_w8 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [7:0] data_in,
    input  wire [14:0] codeword_in,
    output reg  [14:0] codeword_out,
    output reg  [7:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // BCH(15,11,t=1)  k_encode=11 parity_bits=4 deg(g)=4
    wire [10:0] data_k = {3'b0, data_in};
    wire [3:0] parity;
    assign parity[0] = data_k[0] ^ data_k[3] ^ data_k[4] ^ data_k[6] ^ data_k[8] ^ data_k[9] ^ data_k[10];
    assign parity[1] = data_k[0] ^ data_k[1] ^ data_k[3] ^ data_k[5] ^ data_k[6] ^ data_k[7] ^ data_k[8];
    assign parity[2] = data_k[1] ^ data_k[2] ^ data_k[4] ^ data_k[6] ^ data_k[7] ^ data_k[8] ^ data_k[9];
    assign parity[3] = data_k[2] ^ data_k[3] ^ data_k[5] ^ data_k[7] ^ data_k[8] ^ data_k[9] ^ data_k[10];
    wire synd_1_0 = codeword_in[0] ^ codeword_in[4] ^ codeword_in[7] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14];
    wire synd_1_1 = codeword_in[1] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[12];
    wire synd_1_2 = codeword_in[2] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13];
    wire synd_1_3 = codeword_in[3] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14];
    wire synd_2_0 = codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[11] ^ codeword_in[14];
    wire synd_2_1 = codeword_in[2] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13];
    wire synd_2_2 = codeword_in[1] ^ codeword_in[3] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[6] ^ codeword_in[10] ^ codeword_in[13] ^ codeword_in[14];
    wire synd_2_3 = codeword_in[3] ^ codeword_in[6] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14];
    wire any_syndrome = synd_1_0 | synd_1_1 | synd_1_2 | synd_1_3 | synd_2_0 | synd_2_1 | synd_2_2 | synd_2_3;
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
                data_out <= codeword_in[11:4];
                error_detected <= any_syndrome;
                error_corrected <= 1'b0; // Corrected placeholder
                valid_out <= 1'b1;
            end
        end
    end
endmodule