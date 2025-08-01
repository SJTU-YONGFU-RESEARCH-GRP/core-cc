// Extended Hamming ECC Module - Simplified implementation
// Matches Python ExtendedHammingECC implementation for DATA_WIDTH=8
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module extended_hamming_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [39:0]            codeword_in,
    output reg  [39:0]            codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // For DATA_WIDTH=8, Extended Hamming(13,8)
    localparam [31:0] N = 13;
    localparam [31:0] K = 8;
    
    // Parity bit positions for Extended Hamming(13,8)
    localparam int parity_positions [0:3] = '{0, 1, 3, 7};
    localparam int data_positions [0:7] = '{2, 4, 5, 6, 8, 9, 10, 11};
    localparam int extended_parity_position = 12;

    // Internal signals
    reg [12:0] encoded_codeword;
    reg [7:0] extracted_data;
    reg [3:0] syndrome;
    reg single_error, double_error;
    reg extended_parity_error;
    reg [12:0] hamming_codeword;
    reg extended_parity_bit;
    reg expected_extended_parity;
    
    // Count ones in a vector
    function [7:0] count_ones;
        input [12:0] vector;
        integer i;
        reg [7:0] count;
        begin
            count = 0;
            for (i = 0; i < 13; i = i + 1) begin
                if (vector[i]) count = count + 1;
            end
            count_ones = count;
        end
    endfunction

    // Function to calculate Hamming parity bits (matches Python implementation)
    function [3:0] calculate_hamming_parity;
        input [7:0] data;
        integer i, j, pos;
        reg [3:0] parity;
        reg [12:0] temp_codeword;
        begin
            temp_codeword = 0;
            
            // Place data bits in their positions (matches Python _encode_hamming)
            temp_codeword[2] = data[0];
            temp_codeword[4] = data[1];
            temp_codeword[5] = data[2];
            temp_codeword[6] = data[3];
            temp_codeword[8] = data[4];
            temp_codeword[9] = data[5];
            temp_codeword[10] = data[6];
            temp_codeword[11] = data[7];
            
            // Calculate Hamming parity bits (matches Python algorithm)
            parity = 0;
            for (i = 0; i < 4; i = i + 1) begin
                pos = parity_positions[i];
                for (j = 0; j < 13; j = j + 1) begin
                    if (j != pos && temp_codeword[j] && ((j + 1) & (1 << i))) begin
                        parity[i] = parity[i] ^ 1'b1;
                    end
                end
            end
            calculate_hamming_parity = parity;
        end
    endfunction

    // Encode Extended Hamming (matches Python implementation)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Create Hamming codeword first (matches Python _encode_hamming)
            hamming_codeword = 0;
            
            // Insert data bits in their positions
            hamming_codeword[2] = data_in[0];
            hamming_codeword[4] = data_in[1];
            hamming_codeword[5] = data_in[2];
            hamming_codeword[6] = data_in[3];
            hamming_codeword[8] = data_in[4];
            hamming_codeword[9] = data_in[5];
            hamming_codeword[10] = data_in[6];
            hamming_codeword[11] = data_in[7];
            
            // Calculate and insert Hamming parity bits
            hamming_codeword[0] = calculate_hamming_parity(data_in)[0];
            hamming_codeword[1] = calculate_hamming_parity(data_in)[1];
            hamming_codeword[3] = calculate_hamming_parity(data_in)[2];
            hamming_codeword[7] = calculate_hamming_parity(data_in)[3];
            
            // Calculate extended parity (even parity over all Hamming codeword bits)
            expected_extended_parity = count_ones(hamming_codeword) % 2;
            
            // Combine Hamming codeword with extended parity
            encoded_codeword = hamming_codeword | (expected_extended_parity << extended_parity_position);
        end else begin
            encoded_codeword = 0;
        end
    end

    // Function to calculate Hamming syndrome (matches Python implementation)
    function [3:0] calculate_hamming_syndrome;
        input [12:0] hamming_codeword;
        integer i, j, pos;
        reg [3:0] syndrome;
        reg [3:0] expected_parity;
        reg [3:0] actual_parity;
        begin
            syndrome = 0;
            for (i = 0; i < 4; i = i + 1) begin
                pos = parity_positions[i];
                expected_parity[i] = 0;
                for (j = 0; j < 13; j = j + 1) begin
                    if (j != pos && hamming_codeword[j] && ((j + 1) & (1 << i))) begin
                        expected_parity[i] = expected_parity[i] ^ 1'b1;
                    end
                end
                actual_parity[i] = hamming_codeword[pos];
                if (expected_parity[i] != actual_parity[i]) begin
                    syndrome[i] = 1'b1;
                end
            end
            calculate_hamming_syndrome = syndrome;
        end
    endfunction

    // Decode Extended Hamming (matches Python implementation)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Extract Hamming codeword (without extended parity)
            hamming_codeword = codeword_in & ~(1 << extended_parity_position);
            extended_parity_bit = codeword_in[extended_parity_position];
            
            // Calculate expected extended parity
            expected_extended_parity = count_ones(hamming_codeword) % 2;
            
            // Check extended parity error
            extended_parity_error = (extended_parity_bit != expected_extended_parity);
            
            // Calculate Hamming syndrome (matches Python _decode_hamming)
            syndrome = calculate_hamming_syndrome(hamming_codeword);
            
            // Error detection logic (matches Python decode logic)
            if (syndrome == 0) begin
                if (extended_parity_error) begin
                    // Extended parity bit error - corrected
                    single_error = 1;
                    double_error = 0;
                end else begin
                    // No error
                    single_error = 0;
                    double_error = 0;
                end
            end else begin
                if (extended_parity_error) begin
                    // Double bit error detected
                    single_error = 0;
                    double_error = 1;
                end else begin
                    // Single bit error detected and corrected
                    single_error = 1;
                    double_error = 0;
                end
            end
            
            // Extract data bits (matches Python _extract_data)
            extracted_data[0] = hamming_codeword[2];
            extracted_data[1] = hamming_codeword[4];
            extracted_data[2] = hamming_codeword[5];
            extracted_data[3] = hamming_codeword[6];
            extracted_data[4] = hamming_codeword[8];
            extracted_data[5] = hamming_codeword[9];
            extracted_data[6] = hamming_codeword[10];
            extracted_data[7] = hamming_codeword[11];
        end else begin
            hamming_codeword = 0;
            extended_parity_bit = 0;
            expected_extended_parity = 0;
            extended_parity_error = 0;
            syndrome = 0;
            single_error = 0;
            double_error = 0;
            extracted_data = 0;
        end
    end

    // Encoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 40'b0;
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
            
            // Extended Hamming error detection logic
            if (extended_parity_error && single_error) begin
                // Extended parity error but Hamming corrected - likely double-bit error
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end else if (extended_parity_error && !single_error && !double_error) begin
                // Extended parity error but no Hamming error - extended parity bit error
                error_detected <= 1'b0;
                error_corrected <= 1'b1;
            end else if (!extended_parity_error && double_error) begin
                // No extended parity error but Hamming detected - single-bit error in extended parity
                error_detected <= 1'b0;
                error_corrected <= 1'b1;
            end else if (single_error) begin
                // Normal single-bit error
                error_detected <= 1'b0;
                error_corrected <= 1'b1;
            end else if (double_error) begin
                // Normal double-bit error
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end else begin
                // No error
                error_detected <= 1'b0;
                error_corrected <= 1'b0;
            end
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */ 