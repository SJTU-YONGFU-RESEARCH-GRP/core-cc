// File: ecc/parity_encoder.v
module parity_encoder #(
    parameter DATA_WIDTH = 8
) (
    input  [DATA_WIDTH-1:0] data_in,
    output                  parity_out
);
    // Odd parity: XOR all bits, then invert
    assign parity_out = ~(^data_in);
endmodule