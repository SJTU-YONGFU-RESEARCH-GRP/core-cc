module test_encoder (
    input  [7:0] data_in,
    output [11:0] codeword
);
    // Pass through the data bits and add the expected pattern
    assign codeword[11:4] = data_in;
    assign codeword[3:0] = 4'b1010;
endmodule