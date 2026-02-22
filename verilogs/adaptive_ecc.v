/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module adaptive_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [DATA_WIDTH+8:0]   codeword_in, // Wide enough for Hamming
    output reg  [DATA_WIDTH+8:0]   codeword_out,
    output reg  [DATA_WIDTH-1:0]   data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // Adaptive ECC Wrapper
    // For hardware mock, we fix the mode to "Hamming SECDED" (Standard).
    // In a real implementation, this would have a 'mode' input to switch between Parity, Hamming, BCH, RS.
    
    // Internal Signals for Hamming
    // Calculate correct Hamming CW width to avoid warnings/errors
    localparam HAMMING_CW_WIDTH = (DATA_WIDTH <= 2) ? 5 :
                                  (DATA_WIDTH <= 4) ? 7 :
                                  (DATA_WIDTH <= 8) ? 12 :
                                  (DATA_WIDTH <= 16) ? 21 :
                                  (DATA_WIDTH <= 32) ? 38 :
                                  (DATA_WIDTH <= 64) ? 71 : 136;
                                  
    wire [HAMMING_CW_WIDTH-1:0] hamming_cw_out;
    // Slice input to match expected width
    wire [HAMMING_CW_WIDTH-1:0] hamming_cw_in = codeword_in[HAMMING_CW_WIDTH-1:0];
    wire h_valid, h_det, h_corr;
    wire [DATA_WIDTH-1:0] h_data_out;
    
    hamming_secded_ecc #(
        .DATA_WIDTH(DATA_WIDTH),
        .CODEWORD_WIDTH(HAMMING_CW_WIDTH)
    ) hamming_inst (
        .clk(clk),
        .rst_n(rst_n),
        .encode_en(encode_en),
        .decode_en(decode_en),
        .data_in(data_in),
        .codeword_in(hamming_cw_in),
        .codeword_out(hamming_cw_out),
        .data_out(h_data_out),
        .error_detected(h_det),
        .error_corrected(h_corr),
        .valid_out(h_valid)
    );
    
    // Pass-through Logic
    always @(*) begin
        codeword_out = 0; // Clear upper bits
        codeword_out[DATA_WIDTH+8-1:0] = hamming_cw_out;
        
        data_out = h_data_out;
        error_detected = h_det;
        error_corrected = h_corr;
        valid_out = h_valid;
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
