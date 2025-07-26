`timescale 1ns/1ps

module simple_test;
    reg [7:0] data;
    wire [11:0] codeword;

    // Simple test - just pass through the data
    assign codeword = {4'b0000, data};

    initial begin
        data = 8'b00000001;
        #1;
        $display("data=%b, codeword=%b", data, codeword);
        
        data = 8'b10101010;
        #1;
        $display("data=%b, codeword=%b", data, codeword);
        
        $finish;
    end
endmodule 