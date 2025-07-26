`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module simple_tb;
    reg [7:0] data;
    reg [11:0] codeword;

    initial begin
        data = 8'b00000001;
        codeword = 12'b000000000001;
        $display("data=%b, codeword=%b", data, codeword);
        
        data = 8'b10101010;
        codeword = 12'b101010101010;
        $display("data=%b, codeword=%b", data, codeword);
        
        $finish;
    end
endmodule

/* verilator lint_on STMTDLY */