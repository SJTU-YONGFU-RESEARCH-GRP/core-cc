// system_ecc.v
// System-level SECDED ECC (Hamming SECDED + system parity)
// Parameterized for 8-bit data

module system_ecc_encoder #(parameter DATA_WIDTH = 8) (
    input  [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH+4:0] codeword_out // 8 data + 4 hamming + 1 system parity
);
    wire [DATA_WIDTH+3:0] hamming_code;
    hamming_encoder h_enc (
        .data_in(data_in),
        .codeword(hamming_code)
    );
    wire system_parity = ^hamming_code; // Even parity over all bits
    assign codeword_out = {system_parity, hamming_code};
endmodule

module system_ecc_decoder #(parameter DATA_WIDTH = 8) (
    input  [DATA_WIDTH+4:0] codeword_in,
    output [DATA_WIDTH-1:0] data_out,
    output error_detected,
    output error_corrected
);
    wire [DATA_WIDTH+3:0] hamming_code = codeword_in[DATA_WIDTH+3:0];
    wire system_parity = codeword_in[DATA_WIDTH+4];
    wire expected_parity = ^hamming_code;
    wire parity_error = (system_parity != expected_parity);
    wire hamming_error_detected;
    wire hamming_error_corrected;
    
    hamming_decoder h_dec (
        .codeword(hamming_code),
        .data_out(data_out),
        .error_detected(hamming_error_detected),
        .error_corrected(hamming_error_corrected)
    );
    
    // error_detected is high if either hamming or system parity error
    assign error_detected = hamming_error_detected | parity_error;
    
    // error is corrected only if hamming corrected it and there's no system parity error
    // If there's a system parity error but hamming didn't detect an error, it could be a double-bit error
    // which hamming can't correct, or an error in the system parity bit itself
    assign error_corrected = hamming_error_corrected & !parity_error;
endmodule