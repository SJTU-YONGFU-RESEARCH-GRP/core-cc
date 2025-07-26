`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

// Hamming encoder module
module hamming_encoder (
    input  [7:0] data_in,
    output [11:0] codeword
);
    // Calculate parity bits
    wire p0, p1, p2, p3;
    
    // Parity bit calculations based on data bits (matching Python implementation)
    // Parity bit 0 covers bits 0,1,3,4,6
    assign p0 = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6];
    
    // Parity bit 1 covers bits 0,2,3,5,6  
    assign p1 = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6];
    
    // Parity bit 2 covers bits 1,2,3,7
    assign p2 = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7];
    
    // Parity bit 3 covers bits 4,5,6,7
    assign p3 = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];
    
    // Build codeword: [p3 p2 p1 p0 d7 d6 d5 d4 d3 d2 d1 d0]
    // Indices:          [11 10  9  8  7  6  5  4  3  2  1  0]
    // This matches Python: [p[3], p[2], p[1], p[0]] + d[::-1]
    assign codeword = {p3, p2, p1, p0, data_in[7], data_in[6], data_in[5], data_in[4], data_in[3], data_in[2], data_in[1], data_in[0]};
endmodule

// Testbench
module hamming_inline_tb;
    reg [7:0] data;
    wire [11:0] codeword;

    // Instantiate encoder
    hamming_encoder enc (
        .data_in(data),
        .codeword(codeword)
    );

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