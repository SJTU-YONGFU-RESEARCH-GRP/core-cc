module simple_encoder (
    input  [7:0] data_in,
    output [11:0] codeword
);
    // Output 12 bits: 8 bits of data followed by the lower 4 bits again
    assign codeword = {data_in, data_in[3:0]};
endmodule