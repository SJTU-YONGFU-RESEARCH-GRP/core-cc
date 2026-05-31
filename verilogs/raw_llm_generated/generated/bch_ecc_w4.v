// Generated bch_ecc_w4 - Real Hardware Encoder/Detector
module bch_ecc_w4 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [3:0] data_in,
    input  wire [6:0] codeword_in,
    output reg  [6:0] codeword_out,
    output reg  [3:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    // BCH(7,4,t=1)  k_encode=4 parity_bits=3 deg(g)=3
    wire [3:0] data_k = data_in;
    wire [2:0] parity;
    assign parity[0] = data_k[0] ^ data_k[2] ^ data_k[3];
    assign parity[1] = data_k[0] ^ data_k[1] ^ data_k[2];
    assign parity[2] = data_k[1] ^ data_k[2] ^ data_k[3];
    wire synd_1_0 = codeword_in[0] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[6];
    wire synd_1_1 = codeword_in[1] ^ codeword_in[3] ^ codeword_in[4] ^ codeword_in[5];
    wire synd_1_2 = codeword_in[2] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[6];
    wire synd_2_0 = codeword_in[0] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[6];
    wire synd_2_1 = codeword_in[2] ^ codeword_in[4] ^ codeword_in[5] ^ codeword_in[6];
    wire synd_2_2 = codeword_in[1] ^ codeword_in[2] ^ codeword_in[3] ^ codeword_in[6];
    wire any_syndrome = synd_1_0 | synd_1_1 | synd_1_2 | synd_2_0 | synd_2_1 | synd_2_2;
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
                data_out <= codeword_in[6:3];
                error_detected <= any_syndrome;
                error_corrected <= 1'b0; // Corrected placeholder
                valid_out <= 1'b1;
            end
        end
    end
endmodule