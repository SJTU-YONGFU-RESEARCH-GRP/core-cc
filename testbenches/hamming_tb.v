`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module hamming_tb;
    reg [7:0] data;
    wire [11:0] codeword;
    reg [11:0] corrupted_codeword;
    wire [7:0] decoded_data;
    wire error_detected;
    wire error_corrected;
    reg [11:0] expected_codeword;
    reg [7:0] expected_decoded;
    reg expected_error_detected, expected_error_corrected;

    // Expected Hamming encoder function
    function [11:0] calculate_hamming_codeword;
        input [7:0] input_data;
        reg p0, p1, p2, p3;
        begin
            // Parity bit calculations based on data bits
            // Parity bit 0 covers bits 0,1,3,4,6
            p0 = input_data[0] ^ input_data[1] ^ input_data[3] ^ input_data[4] ^ input_data[6];
            
            // Parity bit 1 covers bits 0,2,3,5,6  
            p1 = input_data[0] ^ input_data[2] ^ input_data[3] ^ input_data[5] ^ input_data[6];
            
            // Parity bit 2 covers bits 1,2,3,7
            p2 = input_data[1] ^ input_data[2] ^ input_data[3] ^ input_data[7];
            
            // Parity bit 3 covers bits 4,5,6,7
            p3 = input_data[4] ^ input_data[5] ^ input_data[6] ^ input_data[7];
            
            // Build codeword: [p3 p2 p1 p0 d7 d6 d5 d4 d3 d2 d1 d0]
            // Indices:          [11 10  9  8  7  6  5  4  3  2  1  0]
            calculate_hamming_codeword = {
                p3, p2, p1, p0,
                input_data[7], input_data[6], input_data[5], input_data[4],
                input_data[3], input_data[2], input_data[1], input_data[0]
            };
        end
    endfunction

    // Expected Hamming decoder function
    function [7:0] decode_hamming_codeword;
        input [11:0] input_codeword;
        input [11:0] corrupted_codeword;
        output reg error_detected_out;
        output reg error_corrected_out;
        
        reg [3:0] syndrome;
        reg [3:0] error_position;
        reg [11:0] corrected_codeword;
        begin
            // Syndrome calculation matching Python implementation:
            // s[0] = c[0] ^ c[4] ^ c[5] ^ c[7] ^ c[8] ^ c[10]
            // s[1] = c[1] ^ c[4] ^ c[6] ^ c[7] ^ c[9] ^ c[10]
            // s[2] = c[2] ^ c[5] ^ c[6] ^ c[7] ^ c[11]
            // s[3] = c[3] ^ c[8] ^ c[9] ^ c[10] ^ c[11]
            
            // Where c[0] to c[11] are the codeword bits from LSB to MSB
            syndrome[0] = corrupted_codeword[0] ^ corrupted_codeword[4] ^ corrupted_codeword[5] ^ corrupted_codeword[7] ^ corrupted_codeword[8] ^ corrupted_codeword[10];
            syndrome[1] = corrupted_codeword[1] ^ corrupted_codeword[4] ^ corrupted_codeword[6] ^ corrupted_codeword[7] ^ corrupted_codeword[9] ^ corrupted_codeword[10];
            syndrome[2] = corrupted_codeword[2] ^ corrupted_codeword[5] ^ corrupted_codeword[6] ^ corrupted_codeword[7] ^ corrupted_codeword[11];
            syndrome[3] = corrupted_codeword[3] ^ corrupted_codeword[8] ^ corrupted_codeword[9] ^ corrupted_codeword[10] ^ corrupted_codeword[11];

            // Error is detected if any syndrome bit is non-zero
            error_detected_out = |syndrome;
            
            // Convert syndrome to bit position (1-based)
            error_position = {syndrome[3], syndrome[2], syndrome[1], syndrome[0]};
            
            // Error can be corrected if syndrome points to a valid bit position (1-12)
            error_corrected_out = error_detected_out && (error_position > 0) && (error_position <= 12);

            // Combinational correction logic
            corrected_codeword = error_corrected_out ? (corrupted_codeword ^ (12'b1 << (error_position - 1))) : corrupted_codeword;

            // Extract data bits according to mapping
            // Codeword format: [p3 p2 p1 p0 d7 d6 d5 d4 d3 d2 d1 d0]
            // Indices:          [11 10  9  8  7  6  5  4  3  2  1  0]
            // Python extracts: [11, 10, 9, 8, 7, 6, 5, 4] which are d7,d6,d5,d4,d3,d2,d1,d0
            decode_hamming_codeword = {corrected_codeword[7], corrected_codeword[6], corrected_codeword[5], corrected_codeword[4],
                                       corrected_codeword[3], corrected_codeword[2], corrected_codeword[1], corrected_codeword[0]};
        end
    endfunction

    // Instantiate encoder
    hamming_encoder enc (
        .data_in(data),
        .codeword(codeword)
    );

    // Instantiate decoder
    hamming_decoder dec (
        .codeword(corrupted_codeword),
        .data_out(decoded_data),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );

    // Test block
    initial begin
        // Initialize inputs
        data = 8'b00000000;
        corrupted_codeword = 12'b000000000000;
        
        // Test 0: Simple test with single bit
        data = 8'b00000001;
        #1; // Wait for codeword to update
        $display("DEBUG0: data=%b, codeword=%b", data, codeword);

        // Test 1: No error injection
        data = 8'b10101010;
        #1; // Wait for codeword to update
        $display("DEBUG1: data=%b, codeword=%b", data, codeword);

        // Calculate expected codeword
        expected_codeword = calculate_hamming_codeword(data);
        $display("Expected codeword: %b", expected_codeword);

        corrupted_codeword = codeword;
        #1; // Wait for decoder to update

        // Calculate expected decoding result
        expected_decoded = decode_hamming_codeword(codeword, corrupted_codeword, expected_error_detected, expected_error_corrected);

        $display("TEST1 - No Error: DATA=%b CODEWORD=%b DECODED=%b ERROR_DETECTED=%b ERROR_CORRECTED=%b", 
                 data, codeword, decoded_data, error_detected, error_corrected);
        $display("Expected: DECODED=%b ERROR_DETECTED=%b ERROR_CORRECTED=%b", 
                 expected_decoded, expected_error_detected, expected_error_corrected);

        if (decoded_data == expected_decoded && error_detected == expected_error_detected && error_corrected == expected_error_corrected) begin
            $display("TEST1: PASS");
        end else begin
            $display("TEST1: FAIL");
        end

        // Test 2: Inject single-bit error at bit 0
        corrupted_codeword = codeword ^ 12'b1;
        #1; // Wait for decoder to update

        // Calculate expected decoding result for corrupted codeword
        expected_decoded = decode_hamming_codeword(codeword, corrupted_codeword, expected_error_detected, expected_error_corrected);

        $display("TEST2 - Single Error: DATA=%b CODEWORD=%b CORRUPTED=%b DECODED=%b ERROR_DETECTED=%b ERROR_CORRECTED=%b", 
                 data, codeword, corrupted_codeword, decoded_data, error_detected, error_corrected);
        $display("Expected: DECODED=%b ERROR_DETECTED=%b ERROR_CORRECTED=%b", 
                 expected_decoded, expected_error_detected, expected_error_corrected);

        if (decoded_data == expected_decoded && error_detected == expected_error_detected && error_corrected == expected_error_corrected) begin
            $display("TEST2: PASS");
            $display("RESULT:PASS");
        end else begin
            $display("TEST2: FAIL");
            $display("RESULT:FAIL");
        end

        $finish;
    end
endmodule

/* verilator lint_on STMTDLY */