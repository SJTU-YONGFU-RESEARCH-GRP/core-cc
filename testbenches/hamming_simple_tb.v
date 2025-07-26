`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module hamming_simple_tb;
    reg [7:0] data;
    reg [11:0] codeword;

    // Instantiate encoder
    hamming_encoder enc (
        .data_in(data),
        .codeword(codeword)
    );

    // Test block
    initial begin
        // Test 1: Input 0x01
        data = 8'b00000001;
        #1;
        $display("Test 1: data=%b, codeword=%b", data, codeword);
        
        // Test 2: Input 0xAA
        data = 8'b10101010;
        #1;
        $display("Test 2: data=%b, codeword=%b", data, codeword);
        
        // Test 3: Input 0xFF
        data = 8'b11111111;
        #1;
        $display("Test 3: data=%b, codeword=%b", data, codeword);
        
        $finish;
    end
endmodule

/* verilator lint_on STMTDLY */