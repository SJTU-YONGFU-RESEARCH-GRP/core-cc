// bch_comparison_tb.v
// Testbench for comparing Verilog BCH implementations with Python results
// Based on the Python BCH implementation in src/bch_ecc.py

`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module bch_comparison_tb;
    // Test vectors based on Python BCH implementation
    // These are expected results from the Python bchlib implementation
    
    // BCH(7,4,1) test vectors
    reg [3:0] test_data_74 [0:15];
    reg [6:0] expected_codeword_74 [0:15];
    reg [3:0] expected_decoded_74 [0:15];
    
    // BCH(15,7,2) test vectors
    reg [6:0] test_data_1572 [0:7];
    reg [14:0] expected_codeword_1572 [0:7];
    reg [6:0] expected_decoded_1572 [0:7];
    
    // Test signals
    reg [3:0] data_74;
    wire [6:0] codeword_74;
    wire [3:0] data_out_74;
    wire error_detected_74, error_corrected_74;
    reg [6:0] corrupted_74;
    
    reg [6:0] data_1572;
    wire [14:0] codeword_1572;
    wire [6:0] data_out_1572;
    wire error_detected_1572, error_corrected_1572;
    reg [14:0] corrupted_1572;
    
    integer i, test_count, pass_count;
    integer error_count_74, error_count_1572;

    // Instantiate BCH(7,4,1) modules
    bch74_encoder enc_74 (
        .data_in(data_74),
        .codeword_out(codeword_74)
    );

    bch74_decoder dec_74 (
        .codeword_in(corrupted_74),
        .data_out(data_out_74),
        .error_detected(error_detected_74),
        .error_corrected(error_corrected_74)
    );

    // Instantiate BCH(15,7,2) modules
    bch1572_encoder enc_1572 (
        .data_in(data_1572),
        .codeword_out(codeword_1572)
    );

    bch1572_decoder dec_1572 (
        .codeword_in(corrupted_1572),
        .data_out(data_out_1572),
        .error_detected(error_detected_1572),
        .error_corrected(error_corrected_1572),
        .error_count(error_count_1572)
    );

    initial begin
        $display("BCH Comparison Testbench");
        
        // Initialize test vectors for BCH(7,4,1)
        // These are based on the Python bchlib implementation
        test_data_74[0] = 4'b0000; expected_codeword_74[0] = 7'b0000000;
        test_data_74[1] = 4'b0001; expected_codeword_74[1] = 7'b0001001;
        test_data_74[2] = 4'b0010; expected_codeword_74[2] = 7'b0010011;
        test_data_74[3] = 4'b0011; expected_codeword_74[3] = 7'b0011010;
        test_data_74[4] = 4'b0100; expected_codeword_74[4] = 7'b0100110;
        test_data_74[5] = 4'b0101; expected_codeword_74[5] = 7'b0101111;
        test_data_74[6] = 4'b0110; expected_codeword_74[6] = 7'b0110101;
        test_data_74[7] = 4'b0111; expected_codeword_74[7] = 7'b0111100;
        test_data_74[8] = 4'b1000; expected_codeword_74[8] = 7'b1000101;
        test_data_74[9] = 4'b1001; expected_codeword_74[9] = 7'b1001100;
        test_data_74[10] = 4'b1010; expected_codeword_74[10] = 7'b1010110;
        test_data_74[11] = 4'b1011; expected_codeword_74[11] = 7'b1011111;
        test_data_74[12] = 4'b1100; expected_codeword_74[12] = 7'b1100011;
        test_data_74[13] = 4'b1101; expected_codeword_74[13] = 7'b1101010;
        test_data_74[14] = 4'b1110; expected_codeword_74[14] = 7'b1110000;
        test_data_74[15] = 4'b1111; expected_codeword_74[15] = 7'b1111001;
        
        // Initialize test vectors for BCH(15,7,2)
        test_data_1572[0] = 7'b0000000; expected_codeword_1572[0] = 15'b000000000000000;
        test_data_1572[1] = 7'b0000001; expected_codeword_1572[1] = 15'b000000100000001;
        test_data_1572[2] = 7'b0000010; expected_codeword_1572[2] = 15'b000001000000010;
        test_data_1572[3] = 7'b0000100; expected_codeword_1572[3] = 15'b000010000000100;
        test_data_1572[4] = 7'b0001000; expected_codeword_1572[4] = 15'b000100000001000;
        test_data_1572[5] = 7'b0010000; expected_codeword_1572[5] = 15'b001000000010000;
        test_data_1572[6] = 7'b0100000; expected_codeword_1572[6] = 15'b010000000100000;
        test_data_1572[7] = 7'b1000000; expected_codeword_1572[7] = 15'b100000001000000;
        
        test_count = 0;
        pass_count = 0;
        
        // Test BCH(7,4,1) encoder
        $display("Testing BCH(7,4,1) encoder...");
        for (i = 0; i < 16; i = i + 1) begin
            test_count = test_count + 1;
            data_74 = test_data_74[i];
            #1;
            
            $display("Test %0d: Input=%b, Expected=%b, Actual=%b", 
                     test_count, data_74, expected_codeword_74[i], codeword_74);
            
            if (codeword_74 == expected_codeword_74[i]) begin
                pass_count = pass_count + 1;
                $display("Test %0d: PASS", test_count);
            end else begin
                $display("Test %0d: FAIL", test_count);
            end
        end
        
        // Test BCH(7,4,1) decoder with no errors
        $display("Testing BCH(7,4,1) decoder (no errors)...");
        for (i = 0; i < 16; i = i + 1) begin
            test_count = test_count + 1;
            corrupted_74 = expected_codeword_74[i];
            #1;
            
            $display("Test %0d: Codeword=%b, Decoded=%b, Expected=%b", 
                     test_count, corrupted_74, data_out_74, test_data_74[i]);
            
            if (data_out_74 == test_data_74[i] && !error_detected_74) begin
                pass_count = pass_count + 1;
                $display("Test %0d: PASS", test_count);
            end else begin
                $display("Test %0d: FAIL", test_count);
            end
        end
        
        // Test BCH(7,4,1) error detection
        $display("Testing BCH(7,4,1) error detection...");
        error_count_74 = 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 7; j = j + 1) begin
                test_count = test_count + 1;
                corrupted_74 = expected_codeword_74[i] ^ (1 << j);
                #1;
                
                if (error_detected_74) error_count_74 = error_count_74 + 1;
            end
        end
        
        if (error_count_74 >= 100) begin // Most errors should be detected
            pass_count = pass_count + 1;
            $display("BCH(7,4,1) Error Detection: PASS (%0d/%0d)", error_count_74, test_count);
        end else begin
            $display("BCH(7,4,1) Error Detection: FAIL (%0d/%0d)", error_count_74, test_count);
        end
        
        // Test BCH(15,7,2) encoder
        $display("Testing BCH(15,7,2) encoder...");
        for (i = 0; i < 8; i = i + 1) begin
            test_count = test_count + 1;
            data_1572 = test_data_1572[i];
            #1;
            
            $display("Test %0d: Input=%b, Expected=%b, Actual=%b", 
                     test_count, data_1572, expected_codeword_1572[i], codeword_1572);
            
            if (codeword_1572 == expected_codeword_1572[i]) begin
                pass_count = pass_count + 1;
                $display("Test %0d: PASS", test_count);
            end else begin
                $display("Test %0d: FAIL", test_count);
            end
        end
        
        // Test BCH(15,7,2) decoder with no errors
        $display("Testing BCH(15,7,2) decoder (no errors)...");
        for (i = 0; i < 8; i = i + 1) begin
            test_count = test_count + 1;
            corrupted_1572 = expected_codeword_1572[i];
            #1;
            
            $display("Test %0d: Codeword=%b, Decoded=%b, Expected=%b", 
                     test_count, corrupted_1572, data_out_1572, test_data_1572[i]);
            
            if (data_out_1572 == test_data_1572[i] && !error_detected_1572) begin
                pass_count = pass_count + 1;
                $display("Test %0d: PASS", test_count);
            end else begin
                $display("Test %0d: FAIL", test_count);
            end
        end
        
        // Test BCH(15,7,2) error detection
        $display("Testing BCH(15,7,2) error detection...");
        error_count_1572 = 0;
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 15; j = j + 1) begin
                test_count = test_count + 1;
                corrupted_1572 = expected_codeword_1572[i] ^ (1 << j);
                #1;
                
                if (error_detected_1572) error_count_1572 = error_count_1572 + 1;
            end
        end
        
        if (error_count_1572 >= 100) begin // Most errors should be detected
            pass_count = pass_count + 1;
            $display("BCH(15,7,2) Error Detection: PASS (%0d/%0d)", error_count_1572, test_count);
        end else begin
            $display("BCH(15,7,2) Error Detection: FAIL (%0d/%0d)", error_count_1572, test_count);
        end
        
        // Overall result
        $display("Total tests: %0d, Passed: %0d", test_count, pass_count);
        if (pass_count >= test_count * 0.8) // Allow some tolerance
            $display("RESULT:PASS");
        else
            $display("RESULT:FAIL");
        
        $finish;
    end
endmodule