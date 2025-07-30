// Hamming SECDED ECC Module - Complete implementation with encoder and decoder
// Matches Python HammingSECDEDECC implementation
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module hamming_secded_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [31:0]            codeword_in,  // Variable length based on DATA_WIDTH
    output reg  [31:0]            codeword_out, // Variable length based on DATA_WIDTH
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // Configuration based on DATA_WIDTH (matching Python implementation)
    localparam [31:0] N = (DATA_WIDTH <= 4) ? 7 : 
                          (DATA_WIDTH <= 8) ? 12 : 
                          (DATA_WIDTH <= 16) ? 21 : 
                          (DATA_WIDTH <= 32) ? 38 : 38;
    
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] PARITY_BITS = N - K;
    
    // Parity bit positions (matching Python implementation)
    wire [15:0] parity_positions;
    assign parity_positions = (DATA_WIDTH <= 4) ? 16'h0007 :  // [0,1,3]
                             (DATA_WIDTH <= 8) ? 16'h0087 :   // [0,1,3,7]
                             (DATA_WIDTH <= 16) ? 16'h8087 :  // [0,1,3,7,15]
                             16'h8087;                        // [0,1,3,7,15,31]
    
    // Internal signals
    wire [N-1:0] syndrome;
    wire [N-1:0] encoded_codeword;
    wire [N-1:0] decoded_codeword;
    wire [PARITY_BITS-1:0] parity_bits;
    wire [K-1:0] extracted_data;
    wire single_error, double_error;
    
    // Generate parity bits
    genvar i;
    generate
        for (i = 0; i < PARITY_BITS; i = i + 1) begin : parity_gen
            reg parity_bit;
            integer j;
            
            always @(*) begin
                parity_bit = 1'b0;
                for (j = 0; j < N; j = j + 1) begin
                    if (j != i && ((j + 1) & (1 << i))) begin
                        parity_bit = parity_bit ^ ((data_in >> j) & 1'b1);
                    end
                end
            end
            
            assign parity_bits[i] = parity_bit;
        end
    endgenerate
    
    // Encode: insert data and calculate parity
    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin : encode_gen
            if (k < PARITY_BITS) begin
                // Parity bit position
                assign encoded_codeword[k] = parity_bits[k];
            end else begin
                // Data bit position
                assign encoded_codeword[k] = data_in[k - PARITY_BITS];
            end
        end
    endgenerate
    
    // Calculate syndrome for decoding
    genvar m;
    generate
        for (m = 0; m < PARITY_BITS; m = m + 1) begin : syndrome_gen
            reg syndrome_bit;
            integer n;
            
            always @(*) begin
                syndrome_bit = 1'b0;
                for (n = 0; n < N; n = n + 1) begin
                    if (n != m && ((n + 1) & (1 << m))) begin
                        syndrome_bit = syndrome_bit ^ ((codeword_in >> n) & 1'b1);
                    end
                end
            end
            
            assign syndrome[m] = syndrome_bit ^ ((codeword_in >> m) & 1'b1);
        end
    endgenerate
    
    // Error detection and correction logic
    assign single_error = (syndrome != 0) && (syndrome <= N);
    assign double_error = (syndrome != 0) && (syndrome > N);
    
    // Correct single bit errors
    wire [N-1:0] corrected_codeword;
    assign corrected_codeword = (single_error) ? 
                               (codeword_in ^ (1 << (syndrome - 1))) : 
                               codeword_in;
    
    // Extract data from corrected codeword
    genvar p;
    generate
        for (p = 0; p < K; p = p + 1) begin : data_extract
            assign extracted_data[p] = corrected_codeword[p + PARITY_BITS];
        end
    endgenerate
    
    // Encoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 32'b0;
            valid_out <= 1'b0;
        end else if (encode_en) begin
            codeword_out <= encoded_codeword;
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
    
    // Decoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
        end else if (decode_en) begin
            data_out <= extracted_data;
            error_detected <= (syndrome != 0);
            error_corrected <= single_error;
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */ 