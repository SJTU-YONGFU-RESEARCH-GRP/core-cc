// general_bch_tb.v
// Testbench for General BCH ECC Module
// Tests different BCH configurations: (7,4,1), (15,7,2), (31,16,3), (63,32,6)

`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module general_bch_tb;
    // Test parameters for different BCH configurations
    parameter BCH74_DATA_WIDTH = 4;
    parameter BCH74_CODE_WIDTH = 7;
    parameter BCH74_PARITY_WIDTH = 3;
    
    parameter BCH1572_DATA_WIDTH = 7;
    parameter BCH1572_CODE_WIDTH = 15;
    parameter BCH1572_PARITY_WIDTH = 8;
    
    parameter BCH31163_DATA_WIDTH = 16;
    parameter BCH31163_CODE_WIDTH = 31;
    parameter BCH31163_PARITY_WIDTH = 15;
    
    parameter BCH63326_DATA_WIDTH = 32;
    parameter BCH63326_CODE_WIDTH = 63;
    parameter BCH63326_PARITY_WIDTH = 31;
    
    // Test signals for BCH(7,4,1)
    reg [BCH74_DATA_WIDTH-1:0] data_74;
    wire [BCH74_CODE_WIDTH-1:0] codeword_74;
    wire [BCH74_DATA_WIDTH-1:0] data_out_74;
    wire error_detected_74, error_corrected_74;
    wire [3:0] error_count_74;
    reg [BCH74_CODE_WIDTH-1:0] corrupted_74;
    
    // Test signals for BCH(15,7,2)
    reg [BCH1572_DATA_WIDTH-1:0] data_1572;
    wire [BCH1572_CODE_WIDTH-1:0] codeword_1572;
    wire [BCH1572_DATA_WIDTH-1:0] data_out_1572;
    wire error_detected_1572, error_corrected_1572;
    wire [3:0] error_count_1572;
    reg [BCH1572_CODE_WIDTH-1:0] corrupted_1572;
    
    // Test signals for BCH(31,16,3)
    reg [BCH31163_DATA_WIDTH-1:0] data_31163;
    wire [BCH31163_CODE_WIDTH-1:0] codeword_31163;
    wire [BCH31163_DATA_WIDTH-1:0] data_out_31163;
    wire error_detected_31163, error_corrected_31163;
    wire [3:0] error_count_31163;
    reg [BCH31163_CODE_WIDTH-1:0] corrupted_31163;
    
    // Test signals for BCH(63,32,6)
    reg [BCH63326_DATA_WIDTH-1:0] data_63326;
    wire [BCH63326_CODE_WIDTH-1:0] codeword_63326;
    wire [BCH63326_DATA_WIDTH-1:0] data_out_63326;
    wire error_detected_63326, error_corrected_63326;
    wire [3:0] error_count_63326;
    reg [BCH63326_CODE_WIDTH-1:0] corrupted_63326;
    
    integer test_count, pass_count;
    integer i, j;

    // Instantiate BCH(7,4,1) encoder/decoder
    general_bch_encoder #(
        .DATA_WIDTH(BCH74_DATA_WIDTH),
        .CODE_WIDTH(BCH74_CODE_WIDTH),
        .PARITY_WIDTH(BCH74_PARITY_WIDTH)
    ) enc_74 (
        .data_in(data_74),
        .codeword_out(codeword_74)
    );

    general_bch_decoder #(
        .DATA_WIDTH(BCH74_DATA_WIDTH),
        .CODE_WIDTH(BCH74_CODE_WIDTH),
        .PARITY_WIDTH(BCH74_PARITY_WIDTH)
    ) dec_74 (
        .codeword_in(corrupted_74),
        .data_out(data_out_74),
        .error_detected(error_detected_74),
        .error_corrected(error_corrected_74),
        .error_count(error_count_74)
    );

    // Instantiate BCH(15,7,2) encoder/decoder
    general_bch_encoder #(
        .DATA_WIDTH(BCH1572_DATA_WIDTH),
        .CODE_WIDTH(BCH1572_CODE_WIDTH),
        .PARITY_WIDTH(BCH1572_PARITY_WIDTH)
    ) enc_1572 (
        .data_in(data_1572),
        .codeword_out(codeword_1572)
    );

    general_bch_decoder #(
        .DATA_WIDTH(BCH1572_DATA_WIDTH),
        .CODE_WIDTH(BCH1572_CODE_WIDTH),
        .PARITY_WIDTH(BCH1572_PARITY_WIDTH)
    ) dec_1572 (
        .codeword_in(corrupted_1572),
        .data_out(data_out_1572),
        .error_detected(error_detected_1572),
        .error_corrected(error_corrected_1572),
        .error_count(error_count_1572)
    );

    // Instantiate BCH(31,16,3) encoder/decoder
    general_bch_encoder #(
        .DATA_WIDTH(BCH31163_DATA_WIDTH),
        .CODE_WIDTH(BCH31163_CODE_WIDTH),
        .PARITY_WIDTH(BCH31163_PARITY_WIDTH)
    ) enc_31163 (
        .data_in(data_31163),
        .codeword_out(codeword_31163)
    );

    general_bch_decoder #(
        .DATA_WIDTH(BCH31163_DATA_WIDTH),
        .CODE_WIDTH(BCH31163_CODE_WIDTH),
        .PARITY_WIDTH(BCH31163_PARITY_WIDTH)
    ) dec_31163 (
        .codeword_in(corrupted_31163),
        .data_out(data_out_31163),
        .error_detected(error_detected_31163),
        .error_corrected(error_corrected_31163),
        .error_count(error_count_31163)
    );

    // Instantiate BCH(63,32,6) encoder/decoder
    general_bch_encoder #(
        .DATA_WIDTH(BCH63326_DATA_WIDTH),
        .CODE_WIDTH(BCH63326_CODE_WIDTH),
        .PARITY_WIDTH(BCH63326_PARITY_WIDTH)
    ) enc_63326 (
        .data_in(data_63326),
        .codeword_out(codeword_63326)
    );

    general_bch_decoder #(
        .DATA_WIDTH(BCH63326_DATA_WIDTH),
        .CODE_WIDTH(BCH63326_CODE_WIDTH),
        .PARITY_WIDTH(BCH63326_PARITY_WIDTH)
    ) dec_63326 (
        .codeword_in(corrupted_63326),
        .data_out(data_out_63326),
        .error_detected(error_detected_63326),
        .error_corrected(error_corrected_63326),
        .error_count(error_count_63326)
    );

    initial begin
        $display("General BCH ECC Testbench");
        test_count = 0;
        pass_count = 0;
        
        // Test BCH(7,4,1)
        $display("Testing BCH(7,4,1)...");
        test_count = test_count + 1;
        data_74 = 4'b1011;
        #1;
        
        $display("BCH(7,4,1): Input=%b, Codeword=%b", data_74, codeword_74);
        
        // Test no error case
        corrupted_74 = codeword_74;
        #1;
        $display("BCH(7,4,1): Decoded=%b, Error=%b", data_out_74, error_detected_74);
        
        if (data_out_74 == data_74 && !error_detected_74) begin
            pass_count = pass_count + 1;
            $display("BCH(7,4,1): PASS");
        end else begin
            $display("BCH(7,4,1): FAIL");
        end
        
        // Test BCH(15,7,2)
        $display("Testing BCH(15,7,2)...");
        test_count = test_count + 1;
        data_1572 = 7'b1011011;
        #1;
        
        $display("BCH(15,7,2): Input=%b, Codeword=%b", data_1572, codeword_1572);
        
        // Test no error case
        corrupted_1572 = codeword_1572;
        #1;
        $display("BCH(15,7,2): Decoded=%b, Error=%b", data_out_1572, error_detected_1572);
        
        if (data_out_1572 == data_1572 && !error_detected_1572) begin
            pass_count = pass_count + 1;
            $display("BCH(15,7,2): PASS");
        end else begin
            $display("BCH(15,7,2): FAIL");
        end
        
        // Test BCH(31,16,3)
        $display("Testing BCH(31,16,3)...");
        test_count = test_count + 1;
        data_31163 = 16'hABCD;
        #1;
        
        $display("BCH(31,16,3): Input=%h, Codeword=%h", data_31163, codeword_31163);
        
        // Test no error case
        corrupted_31163 = codeword_31163;
        #1;
        $display("BCH(31,16,3): Decoded=%h, Error=%b", data_out_31163, error_detected_31163);
        
        if (data_out_31163 == data_31163 && !error_detected_31163) begin
            pass_count = pass_count + 1;
            $display("BCH(31,16,3): PASS");
        end else begin
            $display("BCH(31,16,3): FAIL");
        end
        
        // Test BCH(63,32,6)
        $display("Testing BCH(63,32,6)...");
        test_count = test_count + 1;
        data_63326 = 32'h12345678;
        #1;
        
        $display("BCH(63,32,6): Input=%h, Codeword=%h", data_63326, codeword_63326);
        
        // Test no error case
        corrupted_63326 = codeword_63326;
        #1;
        $display("BCH(63,32,6): Decoded=%h, Error=%b", data_out_63326, error_detected_63326);
        
        if (data_out_63326 == data_63326 && !error_detected_63326) begin
            pass_count = pass_count + 1;
            $display("BCH(63,32,6): PASS");
        end else begin
            $display("BCH(63,32,6): FAIL");
        end
        
        // Test error injection for BCH(7,4,1)
        $display("Testing error injection for BCH(7,4,1)...");
        test_count = test_count + 1;
        j = 0;
        for (i = 0; i < 7; i = i + 1) begin
            corrupted_74 = codeword_74 ^ (1 << i);
            #1;
            if (error_detected_74) j = j + 1;
        end
        
        if (j == 7) begin
            pass_count = pass_count + 1;
            $display("BCH(7,4,1) Error Detection: PASS");
        end else begin
            $display("BCH(7,4,1) Error Detection: FAIL");
        end
        
        // Overall result
        $display("Total tests: %0d, Passed: %0d", test_count, pass_count);
        if (pass_count == test_count)
            $display("RESULT:PASS");
        else
            $display("RESULT:FAIL");
        
        $finish;
    end