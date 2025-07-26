`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module hamming_direct_tb;
    reg [7:0] data;
    reg [11:0] codeword;
    
    // Calculate parity bits directly in testbench
    wire p0, p1, p2, p3;
    
    // Parity bit calculations based on data bits (matching Python implementation)
    // Parity bit 0 covers bits 0,1,3,4,6
    assign p0 = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6];
    
    // Parity bit 1 covers bits 0,2,3,5,6  
    assign p1 = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6];
    
    // Parity bit 2 covers bits 1,2,3,7
    assign p2 = data[1] ^ data[2] ^ data[3] ^ data[7];
    
    // Parity bit 3 covers bits 4,5,6,7
    assign p3 = data[4] ^ data[5] ^ data[6] ^ data[7];
    
    // Build codeword: [p3 p2 p1 p0 d7 d6 d5 d4 d3 d2 d1 d0]
    // Indices:          [11 10  9  8  7  6  5  4  3  2  1  0]
    // This matches Python: [p[3], p[2], p[1], p[0]] + d[::-1]
    always @(*) begin
        codeword = {p3, p2, p1, p0, data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};
    end

    // Test block
    initial begin
        // Initialize data
        data = 8'b00000000;
        
        // Test 1: Input 0x01
        data = 8'b00000001;
        $display("Test 1: data=%b, codeword=%b", data, codeword);
        
        // Test 2: Input 0xAA
        data = 8'b10101010;
        $display("Test 2: data=%b, codeword=%b", data, codeword);
        
        // Test 3: Input 0xFF
        data = 8'b11111111;
        $display("Test 3: data=%b, codeword=%b", data, codeword);
        
        $finish;
    end
endmodule

/* verilator lint_on STMTDLY */ 