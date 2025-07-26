// File: ecc/hamming_decoder.v
module hamming_decoder (
    input  [11:0] codeword,
    output [7:0] data_out,
    output       error_detected,
    output       error_corrected
);
    wire [3:0] syndrome;
    wire [11:0] corrected_codeword;

    // Recalculate parity bits based on received data bits
    wire p0_calc, p1_calc, p2_calc, p3_calc;
    
    // Codeword format: [p3 p2 p1 p0 d7 d6 d5 d4 d3 d2 d1 d0]
    // Indices:          [11 10  9  8  7  6  5  4  3  2  1  0]
    
    // Syndrome calculation matching Python implementation:
    // s[0] = c[0] ^ c[4] ^ c[5] ^ c[7] ^ c[8] ^ c[10]
    // s[1] = c[1] ^ c[4] ^ c[6] ^ c[7] ^ c[9] ^ c[10]
    // s[2] = c[2] ^ c[5] ^ c[6] ^ c[7] ^ c[11]
    // s[3] = c[3] ^ c[8] ^ c[9] ^ c[10] ^ c[11]
    
    // Where c[0] to c[11] are the codeword bits from LSB to MSB
    assign syndrome[0] = codeword[0] ^ codeword[4] ^ codeword[5] ^ codeword[7] ^ codeword[8] ^ codeword[10];
    assign syndrome[1] = codeword[1] ^ codeword[4] ^ codeword[6] ^ codeword[7] ^ codeword[9] ^ codeword[10];
    assign syndrome[2] = codeword[2] ^ codeword[5] ^ codeword[6] ^ codeword[7] ^ codeword[11];
    assign syndrome[3] = codeword[3] ^ codeword[8] ^ codeword[9] ^ codeword[10] ^ codeword[11];

    // Error is detected if any syndrome bit is non-zero
    assign error_detected = |syndrome;
    
    // Convert syndrome to bit position (1-based)
    // In Hamming code, the syndrome directly indicates the bit position that needs correction
    wire [3:0] error_position;
    assign error_position = {syndrome[3], syndrome[2], syndrome[1], syndrome[0]};
    
    // Error can be corrected if syndrome points to a valid bit position (1-12)
    assign error_corrected = error_detected && (error_position > 0) && (error_position <= 12);

    // Combinational correction logic
    // Flip the bit at the position indicated by the syndrome
    // If error_position is 0, no correction needed (all-zero syndrome)
    // If error_position > 12, it's an uncorrectable error
    assign corrected_codeword = error_corrected ? (codeword ^ (12'b1 << (error_position - 1))) : codeword;

    // Extract data bits according to mapping
    // Codeword format: [p3 p2 p1 p0 d7 d6 d5 d4 d3 d2 d1 d0]
    // Indices:          [11 10  9  8  7  6  5  4  3  2  1  0]
    // Python extracts: [11, 10, 9, 8, 7, 6, 5, 4] which are d7,d6,d5,d4,d3,d2,d1,d0
    assign data_out = {corrected_codeword[7], corrected_codeword[6], corrected_codeword[5], corrected_codeword[4],
                       corrected_codeword[3], corrected_codeword[2], corrected_codeword[1], corrected_codeword[0]};
endmodule