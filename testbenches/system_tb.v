// system_tb.v
// Testbench for system_ecc.v

`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module system_tb #(parameter DATA_WIDTH = 8);
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire error_detected, error_corrected;
    wire [DATA_WIDTH+4:0] codeword;
    reg [DATA_WIDTH+4:0] corrupted;
    reg [DATA_WIDTH+4:0] expected_codeword;
    reg [DATA_WIDTH-1:0] expected_data_out;
    reg expected_error_detected, expected_error_corrected;

    // Expected system ECC encoder function
    function [DATA_WIDTH+4:0] calculate_system_ecc_codeword;
        input [DATA_WIDTH-1:0] input_data;
        reg [DATA_WIDTH+3:0] hamming_code;
        reg p0, p1, p2, p3;
        reg system_parity;
        begin
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
            
            // System parity (even parity over all hamming bits)
            system_parity = ^hamming_code;
            
            calculate_system_ecc_codeword = {system_parity, hamming_code};
        end
    endfunction

    // Expected system ECC decoder function
    function [DATA_WIDTH-1:0] decode_system_ecc_codeword;
        input [DATA_WIDTH+4:0] input_codeword;
        output reg error_detected_out;
        output reg error_corrected_out;
        
        reg [DATA_WIDTH+3:0] hamming_code;
        reg system_parity, expected_parity, parity_error;
        reg hamming_error_detected, hamming_error_corrected;
        reg p0, p1, p2, p3;
        reg [3:0] syndrome;
        reg [DATA_WIDTH+3:0] corrected_hamming;
        begin
            hamming_code = input_codeword[DATA_WIDTH+3:0];
            system_parity = input_codeword[DATA_WIDTH+4];
            expected_parity = ^hamming_code;
            parity_error = (system_parity != expected_parity);
            
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
            
            decode_system_ecc_codeword = {corrected_hamming[11], corrected_hamming[10], corrected_hamming[9], corrected_hamming[8],
                                         corrected_hamming[6], corrected_hamming[5], corrected_hamming[4], corrected_hamming[2]};
            
            // Combined error detection and correction
            error_detected_out = hamming_error_detected | parity_error;
            error_corrected_out = hamming_error_corrected & !parity_error;
        end
    endfunction

    // Instantiate encoder
    system_ecc_encoder enc (
        .data_in(data_in),
        .codeword_out(codeword)
    );
    
    // Instantiate decoder with corrupted codeword
    system_ecc_decoder dec (
        .codeword_in(corrupted),
        .data_out(data_out),
        .error_detected(error_detected),
        .error_corrected(error_corrected)
    );

    initial begin
        // Test 1: No error injection
        data_in = 8'hA5;
        #1; // Wait for combinational logic to settle
        
        // Calculate expected codeword
        expected_codeword = calculate_system_ecc_codeword(data_in);
        $display("Expected codeword: %b", expected_codeword);
        
        corrupted = codeword; // No corruption for first test
        #1; // Wait for decoder to process
        
        // Calculate expected decoding result
        expected_data_out = decode_system_ecc_codeword(corrupted, expected_error_detected, expected_error_corrected);
        
        $display("TEST1 - No Error: DATA=%h, OUTPUT=%h, ERROR_DETECTED=%b, ERROR_CORRECTED=%b",
                 data_in, data_out, error_detected, error_corrected);
        $display("Expected: OUTPUT=%h, ERROR_DETECTED=%b, ERROR_CORRECTED=%b",
                 expected_data_out, expected_error_detected, expected_error_corrected);

        if (data_out == expected_data_out && error_detected == expected_error_detected && error_corrected == expected_error_corrected) begin
            $display("TEST1: PASS");
        end else begin
            $display("TEST1: FAIL");
        end

        // Test 2: Inject single-bit error
        corrupted = codeword ^ (1 << 2); // Flip bit 2
        #1; // Wait for decoder to process
        
        expected_data_out = decode_system_ecc_codeword(corrupted, expected_error_detected, expected_error_corrected);
        
        $display("TEST2 - Single Error: DATA=%h, CORRUPTED=%h, OUTPUT=%h, ERROR_DETECTED=%b, ERROR_CORRECTED=%b",
                 data_in, corrupted, data_out, error_detected, error_corrected);
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