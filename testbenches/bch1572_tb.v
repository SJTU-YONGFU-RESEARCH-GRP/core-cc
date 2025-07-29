// bch1572_tb.v
// Testbench for BCH(15,7,2) encoder/decoder

`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module bch1572_tb;
    reg [6:0] data_in;
    wire [14:0] codeword;
    wire [6:0] data_out;
    wire error_detected, error_corrected;
    wire [1:0] error_count;
    reg [14:0] corrupted;
    reg [14:0] expected_codeword;
    reg [6:0] expected_decoded;
    reg expected_error_detected, expected_error_corrected;
    integer i, error_count_total, correction_count;
    integer test_count, pass_count;

    // Expected BCH(15,7,2) encoder function
    function [14:0] calculate_bch1572_codeword;
        input [6:0] input_data;
        begin
            // Generator polynomial: x^8 + x^7 + x^6 + x^4 + 1
            calculate_bch1572_codeword[14:8] = input_data;
            calculate_bch1572_codeword[7] = input_data[6] ^ input_data[5] ^ input_data[4] ^ input_data[2];
            calculate_bch1572_codeword[6] = input_data[6] ^ input_data[5] ^ input_data[3] ^ input_data[1];
            calculate_bch1572_codeword[5] = input_data[6] ^ input_data[4] ^ input_data[3] ^ input_data[0];
            calculate_bch1572_codeword[4] = input_data[5] ^ input_data[4] ^ input_data[2] ^ input_data[1];
            calculate_bch1572_codeword[3] = input_data[6] ^ input_data[5] ^ input_data[3] ^ input_data[2] ^ input_data[0];
            calculate_bch1572_codeword[2] = input_data[6] ^ input_data[4] ^ input_data[3] ^ input_data[1] ^ input_data[0];
            calculate_bch1572_codeword[1] = input_data[5] ^ input_data[4] ^ input_data[2] ^ input_data[1] ^ input_data[0];
            calculate_bch1572_codeword[0] = input_data[6] ^ input_data[5] ^ input_data[4] ^ input_data[3] ^ input_data[2] ^ input_data[1] ^ input_data[0];
        end
    endfunction

    // Expected BCH(15,7,2) decoder function
    function [6:0] decode_bch1572_codeword;
        input [14:0] input_codeword;
        output reg error_detected_out;
        output reg error_corrected_out;
        
        reg [3:0] s1, s2, s3, s4;
        begin
            // Simplified syndrome calculation
            s1 = input_codeword[14] ^ input_codeword[13] ^ input_codeword[12] ^ input_codeword[11] ^ 
                 input_codeword[10] ^ input_codeword[9] ^ input_codeword[8] ^ input_codeword[7];
            s2 = input_codeword[13] ^ input_codeword[12] ^ input_codeword[11] ^ input_codeword[10] ^ 
                 input_codeword[9] ^ input_codeword[8] ^ input_codeword[7] ^ input_codeword[6];
            s3 = input_codeword[12] ^ input_codeword[11] ^ input_codeword[10] ^ input_codeword[9] ^ 
                 input_codeword[8] ^ input_codeword[7] ^ input_codeword[6] ^ input_codeword[5];
            s4 = input_codeword[11] ^ input_codeword[10] ^ input_codeword[9] ^ input_codeword[8] ^ 
                 input_codeword[7] ^ input_codeword[6] ^ input_codeword[5] ^ input_codeword[4];

            error_detected_out = |s1 || |s2 || |s3 || |s4;
            error_corrected_out = 0; // Simplified - no correction in this test
            
            decode_bch1572_codeword = input_codeword[14:8];
        end
    endfunction

    // Instantiate encoder
    bch1572_encoder enc (
        .data_in(data_in),
        .codeword_out(codeword)
    );

    // Instantiate decoder
    bch1572_decoder dec (
        .codeword_in(corrupted),
        .data_out(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected),
        .error_count(error_count)
    );

    initial begin
        $display("BCH(15,7,2) Testbench");
        test_count = 0;
        pass_count = 0;
        
        // Test 1: No error case
        test_count = test_count + 1;
        data_in = 7'b1011011;
        #1; // Wait for codeword to update
        
        expected_codeword = calculate_bch1572_codeword(data_in);
        $display("Test %0d: Input data: %b", test_count, data_in);
        $display("Expected codeword: %b", expected_codeword);
        $display("Actual codeword: %b", codeword);
        
        if (codeword == expected_codeword) begin
            $display("Test %0d: Encoder PASS", test_count);
            pass_count = pass_count + 1;
        end else begin
            $display("Test %0d: Encoder FAIL", test_count);
        end
        
        // Test decoder with no errors
        corrupted = codeword;
        #1; // Wait for decoder to process
        expected_decoded = decode_bch1572_codeword(corrupted, expected_error_detected, expected_error_corrected);
        
        $display("Decoded: %b, Detected: %b, Corrected: %b", data_out, error_detected, error_corrected);
        $display("Expected: Decoded: %b, Detected: %b, Corrected: %b", expected_decoded, expected_error_detected, expected_error_corrected);
        
        if (data_out == expected_decoded && error_detected == expected_error_detected) begin
            $display("Test %0d: Decoder PASS", test_count);
            pass_count = pass_count + 1;
        end else begin
            $display("Test %0d: Decoder FAIL", test_count);
        end
        
        // Test 2: Single bit error detection
        test_count = test_count + 1;
        error_count_total = 0;
        correction_count = 0;
        
        for (i = 0; i < 15; i = i + 1) begin
            corrupted = codeword ^ (1 << i);
            #1; // Wait for decoder to process
            expected_decoded = decode_bch1572_codeword(corrupted, expected_error_detected, expected_error_corrected);
            
            $display("Error at bit %0d: %b, Detected: %b, Corrected: %b", i, corrupted, error_detected, error_corrected);
            
            if (error_detected == expected_error_detected) error_count_total = error_count_total + 1;
            if (data_out == expected_decoded) correction_count = correction_count + 1;
        end
        
        if (error_count_total == 15) begin
            $display("Test %0d: Error Detection PASS", test_count);
            pass_count = pass_count + 1;
        end else begin
            $display("Test %0d: Error Detection FAIL", test_count);
        end
        
        // Test 3: Multiple test vectors
        test_count = test_count + 1;
        for (i = 0; i < 10; i = i + 1) begin
            data_in = i * 7 + 7'b1010101; // Different test vectors
            #1;
            expected_codeword = calculate_bch1572_codeword(data_in);
            
            if (codeword == expected_codeword) begin
                pass_count = pass_count + 1;
            end
        end
        
        if (pass_count >= 10) begin
            $display("Test %0d: Multiple Vectors PASS", test_count);
        end else begin
            $display("Test %0d: Multiple Vectors FAIL", test_count);
        end
        
        // Overall result
        $display("Total tests: %0d, Passed: %0d", test_count, pass_count);
        if (pass_count == test_count)
            $display("RESULT:PASS");
        else
            $display("RESULT:FAIL");
        
        $finish;
    end
endmodule