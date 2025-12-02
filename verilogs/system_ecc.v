// System ECC Module - System-level ECC implementation
// Matches Python SystemECC implementation using Hamming SECDED as base
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module system_ecc #(
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

    // For DATA_WIDTH=8, System ECC uses Hamming SECDED(12,8) + 1 system parity bit = 13 bits
    localparam [31:0] N = 13;
    localparam [31:0] K = 8;
    localparam [31:0] HAMMING_N = 12;
    
    // Hamming SECDED parity bit positions for 8-bit data
    localparam int parity_positions [0:3] = '{0, 1, 3, 7};
    localparam int data_positions [0:7] = '{2, 4, 5, 6, 8, 9, 10, 11};
    localparam int system_parity_position = 12;

    // Internal signals
    reg [N-1:0] encoded_codeword;
    reg [K-1:0] extracted_data;
    reg [3:0] syndrome;
    reg single_error, double_error;
    reg system_parity_error;
    reg [HAMMING_N-1:0] hamming_codeword;
    reg system_parity_bit;
    reg expected_system_parity;
    reg [3:0] temp_parity;
    
    // Count ones in a vector (for system parity calculation)
    function [7:0] count_ones;
        input [HAMMING_N-1:0] vector;
        integer i;
        reg [7:0] count;
        begin
            count = 0;
            for (i = 0; i < HAMMING_N; i = i + 1) begin
                if (vector[i]) count = count + 1;
            end
            count_ones = count;
        end
    endfunction

    // Function to calculate Hamming parity bits
    function [3:0] calculate_hamming_parity;
        input [K-1:0] data;
        integer i, j, pos;
        reg [3:0] parity;
        reg [HAMMING_N-1:0] temp_codeword;
        begin
            temp_codeword = 0;
            for (i = 0; i < 8; i = i + 1) begin
                temp_codeword[data_positions[i]] = data[i];
            end
            parity = 0;
            for (i = 0; i < 4; i = i + 1) begin
                pos = parity_positions[i];
                for (j = 0; j < HAMMING_N; j = j + 1) begin
                    if (j != pos && temp_codeword[j] && ((j + 1) & (1 << i))) begin
                        parity[i] = parity[i] ^ 1'b1;
                    end
                end
            end
            calculate_hamming_parity = parity;
        end
    endfunction

    // Function to extract data from Hamming codeword
    function [K-1:0] extract_data;
        input [HAMMING_N-1:0] codeword;
        integer i;
        reg [K-1:0] data;
        begin
            data = 0;
            for (i = 0; i < 8; i = i + 1) begin
                data[i] = codeword[data_positions[i]];
            end
            extract_data = data;
        end
    endfunction

    // Function to calculate Hamming syndrome
    function [3:0] calculate_syndrome;
        input [HAMMING_N-1:0] codeword;
        integer i, j, pos;
        reg [3:0] syndrome;
        reg [3:0] expected_parity;
        reg [3:0] actual_parity;
        begin
            syndrome = 0;
            for (i = 0; i < 4; i = i + 1) begin
                pos = parity_positions[i];
                actual_parity[i] = codeword[pos];
            end
            expected_parity = 0;
            for (i = 0; i < 4; i = i + 1) begin
                pos = parity_positions[i];
                for (j = 0; j < HAMMING_N; j = j + 1) begin
                    if (j != pos && codeword[j] && ((j + 1) & (1 << i))) begin
                        expected_parity[i] = expected_parity[i] ^ 1'b1;
                    end
                end
            end
            syndrome = expected_parity ^ actual_parity;
            calculate_syndrome = syndrome;
        end
    endfunction

    // Encode System ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Create Hamming SECDED codeword first
            hamming_codeword = 0;
            
            // Insert data bits
            for (int i = 0; i < 8; i = i + 1) begin
                hamming_codeword[data_positions[i]] = data_in[i];
            end
            
            // Calculate and insert Hamming parity bits
            // Calculate and insert Hamming parity bits
            temp_parity = calculate_hamming_parity(data_in);
            for (int i = 0; i < 4; i = i + 1) begin
                hamming_codeword[parity_positions[i]] = temp_parity[i];
            end
            
            // Calculate system-level parity (even parity over all Hamming codeword bits)
            expected_system_parity = count_ones(hamming_codeword) % 2;
            
            // Combine Hamming codeword with system parity bit
            encoded_codeword = hamming_codeword | (expected_system_parity << system_parity_position);
        end else begin
            encoded_codeword = 0;
        end
    end

    // Decode System ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Extract Hamming codeword (without system parity)
            hamming_codeword = codeword_in & ~(1 << system_parity_position);
            system_parity_bit = codeword_in[system_parity_position];
            
            // Calculate expected system parity
            expected_system_parity = count_ones(hamming_codeword) % 2;
            
            // Check system parity error
            system_parity_error = (system_parity_bit != expected_system_parity);
            
            // Calculate Hamming syndrome
            syndrome = calculate_syndrome(hamming_codeword);
            
            // Determine error types
            single_error = (syndrome != 0) && (syndrome <= HAMMING_N);
            double_error = (syndrome != 0) && (syndrome > HAMMING_N);
            
            // Extract data
            extracted_data = extract_data(hamming_codeword);
        end else begin
            hamming_codeword = 0;
            system_parity_bit = 0;
            expected_system_parity = 0;
            system_parity_error = 0;
            syndrome = 0;
            single_error = 0;
            double_error = 0;
            extracted_data = 0;
        end
    end

    // Encoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {N{1'b0}};
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
            
            // System ECC error detection logic
            if (system_parity_error) begin
                // System parity error detected
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end else if (single_error) begin
                // Single bit error detected and corrected by Hamming
                error_detected <= 1'b0;
                error_corrected <= 1'b1;
            end else if (double_error) begin
                // Double bit error detected but not corrected
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