// File: ecc/parity_decoder.v
module parity_decoder #(
    parameter DATA_WIDTH = 8
) (
    input  [DATA_WIDTH-1:0] data_in,
    input                   parity_in,
    output                  error_detected
);
    // For odd parity: error detected when (^data_in) == parity_in
    assign error_detected = (^data_in) == parity_in;
endmodule