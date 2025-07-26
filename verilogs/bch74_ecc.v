// BCH(7,4,1) Encoder/Decoder Example
// Encodes 4 data bits into 7 bits, corrects single-bit errors
// For larger BCH codes, use code generators or IP

module bch74_encoder (
    input  [3:0] data_in,
    output [6:0] codeword_out
);
    // Generator polynomial: x^3 + x + 1 (primitive for GF(2^3))
    assign codeword_out[6:3] = data_in;
    assign codeword_out[2] = data_in[3] ^ data_in[2] ^ data_in[0];
    assign codeword_out[1] = data_in[3] ^ data_in[1] ^ data_in[0];
    assign codeword_out[0] = data_in[2] ^ data_in[1] ^ data_in[0];
endmodule

module bch74_decoder (
    input  [6:0] codeword_in,
    output [3:0] data_out,
    output       error_detected,
    output       error_corrected
);
    // Syndrome calculation
    wire s0 = codeword_in[6] ^ codeword_in[2] ^ codeword_in[0];
    wire s1 = codeword_in[5] ^ codeword_in[1] ^ codeword_in[0];
    wire s2 = codeword_in[4] ^ codeword_in[2] ^ codeword_in[1];

    wire [2:0] syndrome = {s2, s1, s0};
    assign error_detected = |syndrome;

    reg [6:0] corrected;
    always @* begin
        corrected = codeword_in;
        if (error_detected) begin
            // Single error correction (lookup table for 7 bits)
            case (syndrome)
                3'b001: corrected[0] = ~codeword_in[0];
                3'b010: corrected[1] = ~codeword_in[1];
                3'b011: corrected[2] = ~codeword_in[2];
                3'b100: corrected[3] = ~codeword_in[3];
                3'b101: corrected[4] = ~codeword_in[4];
                3'b110: corrected[5] = ~codeword_in[5];
                3'b111: corrected[6] = ~codeword_in[6];
                default: corrected = codeword_in;
            endcase
        end
    end
    assign data_out = corrected[6:3];
    assign error_corrected = error_detected;
endmodule 