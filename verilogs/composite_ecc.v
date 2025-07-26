// composite_ecc.v
// Composite ECC: on-chip ECC (parity) + system ECC (SECDED)
// Parameterized for 8-bit data

module composite_ecc #(parameter DATA_WIDTH = 8) (
    input  [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out,
    output error_detected,
    output error_corrected
);
    wire [DATA_WIDTH:0] parity_code; // Data + 1 parity bit
    wire [DATA_WIDTH+3:0] hamming_code; // Data + 4 parity bits

    parity_encoder p_enc (
        .data_in(data_in),
        .parity_out(parity_code[DATA_WIDTH])
    );
    assign parity_code[DATA_WIDTH-1:0] = data_in; // Data part of parity_code

    hamming_encoder h_enc (
        .data_in(data_in),
        .codeword(hamming_code)
    );

    // Error detection and correction logic
    wire parity_error_detected, hamming_error_detected, hamming_error_corrected;

    parity_decoder p_dec (
        .data_in(parity_code[DATA_WIDTH-1:0]),
        .parity_in(parity_code[DATA_WIDTH]),
        .error_detected(parity_error_detected)
    );

    hamming_decoder h_dec (
        .codeword(hamming_code),
        .data_out(data_out),
        .error_detected(hamming_error_detected),
        .error_corrected(hamming_error_corrected)
    );

    // Combined error detection and correction
    // Error is detected if either parity or hamming detects an error
    assign error_detected = parity_error_detected | hamming_error_detected;
    
    // Error is corrected only if hamming corrected it
    // Note: parity can only detect errors, not correct them
    assign error_corrected = hamming_error_corrected;
endmodule