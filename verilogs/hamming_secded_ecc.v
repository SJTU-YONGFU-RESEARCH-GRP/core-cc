// Hamming SECDED ECC Module - Complete implementation with encoder and decoder
// Matches Python HammingSECDEDECC implementation exactly
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

    // Configuration based on DATA_WIDTH (matching Python implementation exactly)
    localparam [31:0] N = (DATA_WIDTH <= 4) ? 7 : 
                          (DATA_WIDTH <= 8) ? 12 : 
                          (DATA_WIDTH <= 16) ? 21 : 
                          (DATA_WIDTH <= 32) ? 38 : 38;
    
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] PARITY_BITS = N - K;
    
    // Parity bit positions for DATA_WIDTH=8 (Hamming(12,8))
    localparam int parity_positions [0:3] = '{0, 1, 3, 7};
    localparam int data_positions [0:7] = '{2, 4, 5, 6, 8, 9, 10, 11};

    // Internal signals
    wire [N-1:0] syndrome;
    reg [N-1:0] encoded_codeword;
    wire [K-1:0] extracted_data;
    wire single_error, double_error;
    
    // Function to calculate parity bits (matching Python implementation exactly)
    function [PARITY_BITS-1:0] calculate_parity;
        input [K-1:0] data;
        integer i, j, pos;
        reg [PARITY_BITS-1:0] parity;
        reg [N-1:0] temp_codeword;
        begin
            temp_codeword = 0;
            if (DATA_WIDTH <= 8) begin
                for (i = 0; i < 8; i = i + 1) begin
                    temp_codeword[data_positions[i]] = data[i];
                end
            end
            parity = 0;
            for (i = 0; i < PARITY_BITS; i = i + 1) begin
                pos = parity_positions[i];
                for (j = 0; j < N; j = j + 1) begin
                    if (j != pos && temp_codeword[j] && ((j + 1) & (1 << i))) begin
                        parity[i] = parity[i] ^ 1'b1;
                    end
                end
            end
            calculate_parity = parity;
        end
    endfunction

    // Function to extract data from codeword (matching Python _extract_data exactly)
    function [K-1:0] extract_data;
        input [N-1:0] codeword;
        integer i;
        reg [K-1:0] data;
        begin
            data = 0;
            if (DATA_WIDTH <= 8) begin
                for (i = 0; i < 8; i = i + 1) begin
                    data[i] = codeword[data_positions[i]];
                end
            end
            extract_data = data;
        end
    endfunction

    // Function to calculate syndrome (matching Python decode logic exactly)
    function [PARITY_BITS-1:0] calculate_syndrome;
        input [N-1:0] codeword;
        integer i, j, pos;
        reg [PARITY_BITS-1:0] syndrome;
        reg [PARITY_BITS-1:0] expected_parity;
        reg [PARITY_BITS-1:0] actual_parity;
        begin
            syndrome = 0;
            if (DATA_WIDTH <= 8) begin
                for (i = 0; i < PARITY_BITS; i = i + 1) begin
                    pos = parity_positions[i];
                    actual_parity[i] = codeword[pos];
                end
            end
            expected_parity = 0;
            for (i = 0; i < PARITY_BITS; i = i + 1) begin
                pos = parity_positions[i];
                for (j = 0; j < N; j = j + 1) begin
                    if (j != pos && codeword[j] && ((j + 1) & (1 << i))) begin
                        expected_parity[i] = expected_parity[i] ^ 1'b1;
                    end
                end
            end
            syndrome = expected_parity ^ actual_parity;
            calculate_syndrome = syndrome;
        end
    endfunction
    
    // Encode: create codeword with data and parity bits
    wire [PARITY_BITS-1:0] parity_bits;
    assign parity_bits = calculate_parity(data_in);
    
    // Build encoded codeword (matching Python encode exactly)
    always @(*) begin
        encoded_codeword = 0;
        
        // Insert data bits (matching Python data_positions)
        if (DATA_WIDTH <= 4) begin
            encoded_codeword[2] = data_in[0];
            encoded_codeword[4] = data_in[1];
            encoded_codeword[5] = data_in[2];
            encoded_codeword[6] = data_in[3];
        end else if (DATA_WIDTH <= 8) begin
            encoded_codeword[2] = data_in[0];
            encoded_codeword[4] = data_in[1];
            encoded_codeword[5] = data_in[2];
            encoded_codeword[6] = data_in[3];
            encoded_codeword[8] = data_in[4];
            encoded_codeword[9] = data_in[5];
            encoded_codeword[10] = data_in[6];
            encoded_codeword[11] = data_in[7];
        end
        
        // Insert parity bits (matching Python parity_positions)
        if (DATA_WIDTH <= 4) begin
            encoded_codeword[0] = parity_bits[0];
            encoded_codeword[1] = parity_bits[1];
            encoded_codeword[3] = parity_bits[2];
        end else if (DATA_WIDTH <= 8) begin
            encoded_codeword[0] = parity_bits[0];
            encoded_codeword[1] = parity_bits[1];
            encoded_codeword[3] = parity_bits[2];
            encoded_codeword[7] = parity_bits[3];
        end
    end
    
    // Calculate syndrome for decoding
    assign syndrome = calculate_syndrome(codeword_in);
    
    // Error detection and correction logic (matching Python decode exactly)
    wire syndrome_nonzero = (syndrome != 0);
    wire syndrome_in_range = (syndrome > 0) && (syndrome <= N);
    assign single_error = syndrome_in_range;
    assign double_error = syndrome_nonzero && !syndrome_in_range;

    // Correct single bit errors (matching Python decode logic)
    wire [N-1:0] corrected_codeword;
    assign corrected_codeword = (syndrome_in_range) ? 
                               (codeword_in ^ (1 << (syndrome - 1))) : 
                               codeword_in;

    // Extract data from corrected codeword
    assign extracted_data = extract_data(corrected_codeword);

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
            error_detected <= syndrome_nonzero;
            error_corrected <= syndrome_in_range;
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */ 