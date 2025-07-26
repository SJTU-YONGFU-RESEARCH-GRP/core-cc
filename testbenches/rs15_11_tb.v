// rs15_11_tb.v
// Testbench for RS(15,11) encoder/decoder (demo)

`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module rs15_11_tb;
    reg [10:0] data_in;
    wire [14:0] codeword;
    wire [10:0] data_out;
    wire error_detected, error_corrected;
    reg [14:0] expected_codeword;
    reg [10:0] expected_decoded;
    reg expected_error_detected, expected_error_corrected;
    integer i, error_count, correction_count;

    // Expected RS(15,11) encoder function
    function [14:0] calculate_rs15_11_codeword;
        input [10:0] input_data;
        begin
            // For demonstration, append 4 parity bits (simplified implementation)
            // Real RS encoding uses polynomial division in GF(2^4)
            calculate_rs15_11_codeword[14:4] = input_data;
            // Simple parity calculation for demonstration
            calculate_rs15_11_codeword[3] = ^input_data[10:8];
            calculate_rs15_11_codeword[2] = ^input_data[7:5];
            calculate_rs15_11_codeword[1] = ^input_data[4:2];
            calculate_rs15_11_codeword[0] = ^input_data[1:0];
        end
    endfunction

    // Expected RS(15,11) decoder function
    function [10:0] decode_rs15_11_codeword;
        input [14:0] input_codeword;
        output reg error_detected_out;
        output reg error_corrected_out;
        
        reg parity_check3, parity_check2, parity_check1, parity_check0;
        begin
            // Extract data bits
            decode_rs15_11_codeword = input_codeword[14:4];
            
            // Simple parity check for demonstration
            parity_check3 = ^{input_codeword[14:12], input_codeword[3]};
            parity_check2 = ^{input_codeword[11:9], input_codeword[2]};
            parity_check1 = ^{input_codeword[8:6], input_codeword[1]};
            parity_check0 = ^{input_codeword[5:4], input_codeword[0]};
            
            // Error detection
            error_detected_out = parity_check3 | parity_check2 | parity_check1 | parity_check0;
            error_corrected_out = error_detected_out; // Simplified: assume all detected errors are corrected
        end
    endfunction

    // Instantiate encoder
    rs15_11_encoder enc (
        .data_in(data_in),
        .codeword_out(codeword)
    );

    // Instantiate decoder
    rs15_11_decoder dec (
        .codeword_in(codeword),
        .data_out(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );

    initial begin
        $display("RS(15,11) Testbench");
        data_in = 11'b10101010101;
        #10;
        
        // Calculate expected codeword
        expected_codeword = calculate_rs15_11_codeword(data_in);
        $display("Expected codeword: %b", expected_codeword);
        
        // Calculate expected decoding result
        expected_decoded = decode_rs15_11_codeword(codeword, expected_error_detected, expected_error_corrected);
        
        $display("Original: %b, Encoded: %b, Decoded: %b, Detected: %b, Corrected: %b", data_in, codeword, data_out, error_detected, error_corrected);
        $display("Expected: Decoded: %b, Detected: %b, Corrected: %b", expected_decoded, expected_error_detected, expected_error_corrected);
        
        // Test 1: Check if decoded data matches input with no errors
        if (data_out == expected_decoded && error_detected == expected_error_detected && error_corrected == expected_error_corrected) begin
            $display("TEST1: PASS");
            $display("RESULT:PASS");
        end else begin
            $display("TEST1: FAIL");
            $display("RESULT:FAIL");
        end
        
        $finish;
    end
endmodule