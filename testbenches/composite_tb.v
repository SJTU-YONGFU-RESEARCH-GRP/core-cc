// composite_tb.v
// Testbench for composite_ecc.v

`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module composite_tb #(parameter DATA_WIDTH = 8);
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire error_detected, error_corrected;
    reg [DATA_WIDTH-1:0] expected_data_out;
    reg expected_error_detected, expected_error_corrected;

    // Expected composite ECC function
    function [DATA_WIDTH-1:0] calculate_composite_ecc;
        input [DATA_WIDTH-1:0] input_data;
        output reg error_detected_out;
        output reg error_corrected_out;
        
        reg [DATA_WIDTH:0] parity_code;
        reg [DATA_WIDTH+3:0] hamming_code;
        reg parity_error_detected, hamming_error_detected, hamming_error_corrected;
        reg p0, p1, p2, p3;
        reg [3:0] syndrome;
        reg [DATA_WIDTH+3:0] corrected_hamming;
        begin
            // Parity encoding
            parity_code[DATA_WIDTH-1:0] = input_data;
            parity_code[DATA_WIDTH] = ~^input_data; // Odd parity
            
            // Hamming encoding
            // Parity bit calculations based on data bits
            p0 = input_data[0] ^ input_data[1] ^ input_data[3] ^ input_data[4] ^ input_data[6];
            p1 = input_data[0] ^ input_data[2] ^ input_data[3] ^ input_data[5] ^ input_data[6];
            p2 = input_data[1] ^ input_data[2] ^ input_data[3] ^ input_data[7];
            p3 = input_data[4] ^ input_data[5] ^ input_data[6] ^ input_data[7];
            
            // Build hamming codeword: [d7 d6 d5 d4 p3 d3 d2 d1 p2 d0 p1 p0]
            hamming_code = {
                input_data[7], input_data[6], input_data[5], input_data[4],
                p3, input_data[3], input_data[2], input_data[1],
                p2, input_data[0], p1, p0
            };
            
            // Parity error detection
            parity_error_detected = 0; // No errors in this test
            
            // Hamming error detection and correction
            // Recalculate parity bits
            p0 = hamming_code[2] ^ hamming_code[4] ^ hamming_code[6] ^ hamming_code[8] ^ hamming_code[10];
            p1 = hamming_code[2] ^ hamming_code[5] ^ hamming_code[6] ^ hamming_code[9] ^ hamming_code[10];
            p2 = hamming_code[4] ^ hamming_code[5] ^ hamming_code[6] ^ hamming_code[11];
            p3 = hamming_code[8] ^ hamming_code[9] ^ hamming_code[10] ^ hamming_code[11];
            
            // Syndrome calculation
            syndrome[0] = hamming_code[0] ^ p0;
            syndrome[1] = hamming_code[1] ^ p1;
            syndrome[2] = hamming_code[3] ^ p2;
            syndrome[3] = hamming_code[7] ^ p3;
            
            hamming_error_detected = |syndrome;
            hamming_error_corrected = hamming_error_detected && (syndrome > 0) && (syndrome <= 12);
            
            // Extract corrected data
            corrected_hamming = hamming_code;
            if (hamming_error_corrected) begin
                corrected_hamming = hamming_code ^ (12'b1 << (syndrome - 1));
            end
            
            calculate_composite_ecc = {corrected_hamming[11], corrected_hamming[10], corrected_hamming[9], corrected_hamming[8],
                                      corrected_hamming[6], corrected_hamming[5], corrected_hamming[4], corrected_hamming[2]};
            
            // Combined error detection and correction
            error_detected_out = parity_error_detected | hamming_error_detected;
            error_corrected_out = hamming_error_corrected;
        end
    endfunction

    composite_ecc uut (
        .data_in(data_in),
        .data_out(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );

    initial begin
        // Test 1: No error injection
        data_in = 8'hA5;
        #1; // Wait for combinational logic to settle
        
        // Calculate expected result
        expected_data_out = calculate_composite_ecc(data_in, expected_error_detected, expected_error_corrected);
        
        $display("TEST1 - No Error: DATA=%h, OUTPUT=%h, ERROR_DETECTED=%b, ERROR_CORRECTED=%b",
                 data_in, data_out, error_detected, error_corrected);
        $display("Expected: OUTPUT=%h, ERROR_DETECTED=%b, ERROR_CORRECTED=%b",
                 expected_data_out, expected_error_detected, expected_error_corrected);

        if (data_out == expected_data_out && error_detected == expected_error_detected && error_corrected == expected_error_corrected) begin
            $display("TEST1: PASS");
        end else begin
            $display("TEST1: FAIL");
        end

        // Test 2: Test with different data
        data_in = 8'h3C;
        #1; // Wait for combinational logic to settle
        
        expected_data_out = calculate_composite_ecc(data_in, expected_error_detected, expected_error_corrected);
        
        $display("TEST2 - Different Data: DATA=%h, OUTPUT=%h, ERROR_DETECTED=%b, ERROR_CORRECTED=%b",
                 data_in, data_out, error_detected, error_corrected);
        $display("Expected: OUTPUT=%h, ERROR_DETECTED=%b, ERROR_CORRECTED=%b",
                 expected_data_out, expected_error_detected, expected_error_corrected);

        if (data_out == expected_data_out && error_detected == expected_error_detected && error_corrected == expected_error_corrected) begin
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