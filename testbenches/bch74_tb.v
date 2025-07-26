// bch74_tb.v
// Testbench for BCH(7,4,1) encoder/decoder

`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module bch74_tb;
    reg [3:0] data_in;
    wire [6:0] codeword;
    wire [3:0] data_out;
    wire error_detected, error_corrected;
    reg [6:0] corrupted;
    reg [6:0] expected_codeword;
    reg [3:0] expected_decoded;
    reg expected_error_detected, expected_error_corrected;
    integer i, error_count, correction_count;

    // Expected BCH(7,4,1) encoder function
    function [6:0] calculate_bch74_codeword;
        input [3:0] input_data;
        begin
            // Generator polynomial: x^3 + x + 1 (primitive for GF(2^3))
            calculate_bch74_codeword[6:3] = input_data;
            calculate_bch74_codeword[2] = input_data[3] ^ input_data[2] ^ input_data[0];
            calculate_bch74_codeword[1] = input_data[3] ^ input_data[1] ^ input_data[0];
            calculate_bch74_codeword[0] = input_data[2] ^ input_data[1] ^ input_data[0];
        end
    endfunction

    // Expected BCH(7,4,1) decoder function
    function [3:0] decode_bch74_codeword;
        input [6:0] input_codeword;
        output reg error_detected_out;
        output reg error_corrected_out;
        
        reg [2:0] syndrome;
        reg [6:0] corrected;
        begin
            // Syndrome calculation
            syndrome[0] = input_codeword[6] ^ input_codeword[2] ^ input_codeword[0];
            syndrome[1] = input_codeword[5] ^ input_codeword[1] ^ input_codeword[0];
            syndrome[2] = input_codeword[4] ^ input_codeword[2] ^ input_codeword[1];

            error_detected_out = |syndrome;
            error_corrected_out = error_detected_out;

            // Single error correction (lookup table for 7 bits)
            corrected = input_codeword;
            if (error_detected_out) begin
                case (syndrome)
                    3'b001: corrected[0] = ~input_codeword[0];
                    3'b010: corrected[1] = ~input_codeword[1];
                    3'b011: corrected[2] = ~input_codeword[2];
                    3'b100: corrected[3] = ~input_codeword[3];
                    3'b101: corrected[4] = ~input_codeword[4];
                    3'b110: corrected[5] = ~input_codeword[5];
                    3'b111: corrected[6] = ~input_codeword[6];
                    default: corrected = input_codeword;
                endcase
            end
            
            decode_bch74_codeword = corrected[6:3];
        end
    endfunction

    // Instantiate encoder
    bch74_encoder enc (
        .data_in(data_in),
        .codeword_out(codeword)
    );

    // Instantiate decoder
    bch74_decoder dec (
        .codeword_in(corrupted),
        .data_out(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );

    initial begin
        $display("BCH(7,4,1) Testbench");
        data_in = 4'b1011;
        #1; // Wait for codeword to update
        
        // Calculate expected codeword
        expected_codeword = calculate_bch74_codeword(data_in);
        $display("Expected codeword: %b", expected_codeword);
        $display("Actual codeword: %b", codeword);
        $display("Input data: %b", data_in);
        
        // Debug: Check individual bits
        $display("Expected: [6:3]=%b, [2]=%b, [1]=%b, [0]=%b", 
                 expected_codeword[6:3], expected_codeword[2], expected_codeword[1], expected_codeword[0]);
        $display("Actual:   [6:3]=%b, [2]=%b, [1]=%b, [0]=%b", 
                 codeword[6:3], codeword[2], codeword[1], codeword[0]);
        
        // Test 1: No error case
        corrupted = codeword;
        #1; // Wait for decoder to process
        expected_decoded = decode_bch74_codeword(corrupted, expected_error_detected, expected_error_corrected);
        
        $display("Original: %b, Encoded: %b, Decoded: %b, Detected: %b, Corrected: %b", data_in, codeword, data_out, error_detected, error_corrected);
        $display("Expected: Decoded: %b, Detected: %b, Corrected: %b", expected_decoded, expected_error_detected, expected_error_corrected);
        
        if (data_out == expected_decoded && error_detected == expected_error_detected && error_corrected == expected_error_corrected)
            $display("TEST1 - No Error: PASS");
        else
            $display("TEST1 - No Error: FAIL");
        
        // Test 2: Single bit error detection and correction
        error_count = 0;
        correction_count = 0;
        
        for (i = 0; i < 7; i = i + 1) begin
            corrupted = codeword ^ (1 << i);
            #1; // Wait for decoder to process
            expected_decoded = decode_bch74_codeword(corrupted, expected_error_detected, expected_error_corrected);
            
            $display("Error at bit %0d: %b, Decoded: %b, Detected: %b, Corrected: %b", i, corrupted, data_out, error_detected, error_corrected);
            $display("Expected: Decoded: %b, Detected: %b, Corrected: %b", expected_decoded, expected_error_detected, expected_error_corrected);
            
            if (error_detected == expected_error_detected) error_count = error_count + 1;
            if (error_corrected == expected_error_corrected && data_out == expected_decoded) correction_count = correction_count + 1;
        end
        
        if (error_count == 7 && correction_count == 7)
            $display("TEST2 - Single Bit Errors: PASS");
        else
            $display("TEST2 - Single Bit Errors: FAIL");
        
        // Overall result
        if (data_out == expected_decoded && error_detected == expected_error_detected && error_corrected == expected_error_corrected && error_count == 7 && correction_count == 7)
            $display("RESULT:PASS");
        else
            $display("RESULT:FAIL");
        
        $finish;
    end
endmodule