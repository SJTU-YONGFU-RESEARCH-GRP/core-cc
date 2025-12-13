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
    reg [3:0] temp_parity;
    
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
        reg [3:0] parity;
        reg [12:0] temp_cw;
        begin
            temp_cw = 0;
            
            // Place data bits in their positions (matches Python _encode_hamming)
            temp_cw[2] = data[0];
            temp_cw[4] = data[1];
            temp_cw[5] = data[2];
            temp_cw[6] = data[3];
            temp_cw[8] = data[4];
            temp_cw[9] = data[5];
            temp_cw[10] = data[6];
            temp_cw[11] = data[7];
            
            // Calculate Hamming parity bits (matches Python algorithm)
            parity = 0;
            
            // P1 (pos 0): checks 0, 2, 4, 6, 8, 10
            parity[0] = temp_cw[2] ^ temp_cw[4] ^ temp_cw[6] ^ temp_cw[8] ^ temp_cw[10];
            
            // P2 (pos 1): checks 1, 2, 5, 6, 9, 10
            parity[1] = temp_cw[2] ^ temp_cw[5] ^ temp_cw[6] ^ temp_cw[9] ^ temp_cw[10];
            
            // P4 (pos 3): checks 3, 4, 5, 6, 11
            parity[2] = temp_cw[4] ^ temp_cw[5] ^ temp_cw[6] ^ temp_cw[11];
            
            // P8 (pos 7): checks 7, 8, 9, 10, 11
            parity[3] = temp_cw[8] ^ temp_cw[9] ^ temp_cw[10] ^ temp_cw[11];
            
            calculate_hamming_parity = parity;
        end
    endfunction

    // Function to calculate syndrome
    function [3:0] calculate_syndrome;
        input [12:0] codeword;
        reg [3:0] syndrome;
        reg [3:0] expected_parity;
        reg [3:0] actual_parity;
        begin
            // Extract actual parity bits
            actual_parity[0] = codeword[0];
            actual_parity[1] = codeword[1];
            actual_parity[2] = codeword[3];
            actual_parity[3] = codeword[7];
            
            // Calculate expected parity
            // P1
            expected_parity[0] = codeword[2] ^ codeword[4] ^ codeword[6] ^ codeword[8] ^ codeword[10];
            // P2
            expected_parity[1] = codeword[2] ^ codeword[5] ^ codeword[6] ^ codeword[9] ^ codeword[10];
            // P4
            expected_parity[2] = codeword[4] ^ codeword[5] ^ codeword[6] ^ codeword[11];
            // P8
            expected_parity[3] = codeword[8] ^ codeword[9] ^ codeword[10] ^ codeword[11];
            
            syndrome = expected_parity ^ actual_parity;
            calculate_syndrome = syndrome;
        end
    endfunction
    
    // Encode logic
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            encoded_codeword = 0;
            // Insert data bits
            encoded_codeword[2] = data_in[0];
            encoded_codeword[4] = data_in[1];
            encoded_codeword[5] = data_in[2];
            encoded_codeword[6] = data_in[3];
            encoded_codeword[8] = data_in[4];
            encoded_codeword[9] = data_in[5];
            encoded_codeword[10] = data_in[6];
            encoded_codeword[11] = data_in[7];
            
            // Calculate Hamming parity bits
            temp_parity = calculate_hamming_parity(data_in);
            
            // Insert parity bits
            encoded_codeword[0] = temp_parity[0];
            encoded_codeword[1] = temp_parity[1];
            encoded_codeword[3] = temp_parity[2];
            encoded_codeword[7] = temp_parity[3];
            
            // Calculate extended parity bit (parity of all 12 bits)
            encoded_codeword[12] = ^encoded_codeword[11:0];
        end else begin
            encoded_codeword = 0;
        end
    end

    // Decode Extended Hamming (matches Python implementation)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Extract Hamming codeword (without extended parity)
            hamming_codeword = codeword_in[12:0] & ~(1 << extended_parity_position); // Masking not strictly needed if we just ignore bit 12
            hamming_codeword = codeword_in[12:0]; // Actually just take the 13 bits
            hamming_codeword[12] = 0; // Clear extended parity bit for Hamming check if needed? No, Hamming check ignores bit 12 usually or we pass 13 bits?
            // Python implementation passes 13 bits to decode_hamming but decode_hamming only looks at 12 bits (0-11).
            // Let's just pass the lower 12 bits to syndrome calc if possible, or pass 13 and ignore 12.
            // My calculate_syndrome takes 13 bits but only uses 0-11.
            
            extended_parity_bit = codeword_in[extended_parity_position];
            
            // Calculate expected extended parity (parity of first 12 bits)
            expected_extended_parity = ^codeword_in[11:0];
            
            // Check extended parity error
            extended_parity_error = (extended_parity_bit != expected_extended_parity);
            
            // Calculate Hamming syndrome (matches Python _decode_hamming)
            syndrome = calculate_syndrome(codeword_in);
            
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
                    // Single bit error detected and corrected
                    single_error = 1;
                    double_error = 0;
                end else begin
                    // Double bit error detected
                    single_error = 0;
                    double_error = 1;
                end
            end
            
            // Extract data bits (matches Python _extract_data)
            extracted_data[0] = codeword_in[2];
            extracted_data[1] = codeword_in[4];
            extracted_data[2] = codeword_in[5];
            extracted_data[3] = codeword_in[6];
            extracted_data[4] = codeword_in[8];
            extracted_data[5] = codeword_in[9];
            extracted_data[6] = codeword_in[10];
            extracted_data[7] = codeword_in[11];
            
            // Correction logic
            if (single_error && syndrome != 0) begin
                // Correct data bit if needed
                // Syndrome tells us the position (1-based index) of the error
                // But wait, my syndrome calculation might be different?
                // Python: syndrome is calculated such that it points to error pos.
                // My calculate_syndrome matches that logic.
                // If syndrome points to a data bit, we flip it.
                // If syndrome points to a parity bit, we flip it (but we don't output parity bits).
                
                // Let's just output extracted_data and flip if needed
                if (syndrome == 3) extracted_data[0] = ~extracted_data[0]; // Pos 2 (1-based 3? No, syndrome is value)
                // Wait, syndrome value IS the position index (1-based).
                // Pos 2 is 2^1 = 2? No.
                // P1 checks 1,3,5,7,9,11.
                // If P1 is wrong, error is in 1,3,5,7,9,11.
                // Syndrome = P8*8 + P4*4 + P2*2 + P1*1.
                // If Syndrome = 3 (0011), error is at pos 3 (1-based) -> index 2 (0-based).
                // Index 2 is data[0].
                
                case (syndrome)
                    3: extracted_data[0] = ~extracted_data[0]; // Index 2
                    5: extracted_data[1] = ~extracted_data[1]; // Index 4
                    6: extracted_data[2] = ~extracted_data[2]; // Index 5
                    7: extracted_data[3] = ~extracted_data[3]; // Index 6
                    9: extracted_data[4] = ~extracted_data[4]; // Index 8
                    10: extracted_data[5] = ~extracted_data[5]; // Index 9
                    11: extracted_data[6] = ~extracted_data[6]; // Index 10
                    12: extracted_data[7] = ~extracted_data[7]; // Index 11
                endcase
            end
            
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
            codeword_out <= {27'b0, encoded_codeword}; // Pad to 40 bits
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
            if (single_error) begin
                error_detected <= 1'b0; // Single errors are corrected
                error_corrected <= 1'b1;
            end else if (double_error) begin
                error_detected <= 1'b1; // Double errors are detected but not corrected
                error_corrected <= 1'b0;
            end else begin
                error_detected <= 1'b0;
                error_corrected <= 1'b0;
            end
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */