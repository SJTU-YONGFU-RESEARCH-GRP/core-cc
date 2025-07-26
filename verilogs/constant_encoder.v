module constant_encoder (
    input  [7:0] data_in,
    output [11:0] codeword
);
    // Just output a constant value
    assign codeword = 12'b101010101010;
endmodule 