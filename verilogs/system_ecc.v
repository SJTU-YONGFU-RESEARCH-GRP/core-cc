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
    // Hamming SECDED parity bit positions for 8-bit data
    // localparam int parity_positions [0:3] = '{0, 1, 3, 7};
    // localparam int data_positions [0:7] = '{2, 4, 5, 6, 8, 9, 10, 11};
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
        input [7:0] data;
        reg [3:0] parity;
        reg [11:0] temp_cw;
        begin
            temp_cw = 0;
            // Hardcoded data positions
            temp_cw[2] = data[0];
            temp_cw[4] = data[1];
            temp_cw[5] = data[2];
            temp_cw[6] = data[3];
            temp_cw[8] = data[4];
            temp_cw[9] = data[5];
            temp_cw[10] = data[6];
            temp_cw[11] = data[7];
            
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

    // Function to extract data from Hamming codeword
    function [K-1:0] extract_data;
        input [HAMMING_N-1:0] codeword;
        reg [K-1:0] data;
        begin
            data = 0;
            data[0] = codeword[2];
            data[1] = codeword[4];
            data[2] = codeword[5];
            data[3] = codeword[6];
            data[4] = codeword[8];
            data[5] = codeword[9];
            data[6] = codeword[10];
            data[7] = codeword[11];
            extract_data = data;
        end
    endfunction

    // Function to calculate Hamming syndrome
    function [3:0] calculate_hamming_syndrome;
        input [11:0] hamming_cw;
        reg [3:0] syndrome;
        reg [3:0] expected_parity;
        reg [3:0] actual_parity;
        begin
            // Extract actual parity bits
            actual_parity[0] = hamming_cw[0];
            actual_parity[1] = hamming_cw[1];
            actual_parity[2] = hamming_cw[3];
            actual_parity[3] = hamming_cw[7];
            
            // Calculate expected parity
            // P1
            expected_parity[0] = hamming_cw[2] ^ hamming_cw[4] ^ hamming_cw[6] ^ hamming_cw[8] ^ hamming_cw[10];
            // P2
            expected_parity[1] = hamming_cw[2] ^ hamming_cw[5] ^ hamming_cw[6] ^ hamming_cw[9] ^ hamming_cw[10];
            // P4
            expected_parity[2] = hamming_cw[4] ^ hamming_cw[5] ^ hamming_cw[6] ^ hamming_cw[11];
            // P8
            expected_parity[3] = hamming_cw[8] ^ hamming_cw[9] ^ hamming_cw[10] ^ hamming_cw[11];
            
            syndrome = expected_parity ^ actual_parity;
            calculate_hamming_syndrome = syndrome;
        end
    endfunction
    
    // Encode logic
    always @(*) begin
        // Insert data bits
        hamming_codeword[2] = data_in[0];
        hamming_codeword[4] = data_in[1];
        hamming_codeword[5] = data_in[2];
        hamming_codeword[6] = data_in[3];
        hamming_codeword[8] = data_in[4];
        hamming_codeword[9] = data_in[5];
        hamming_codeword[10] = data_in[6];
        hamming_codeword[11] = data_in[7];
        
        // Calculate and insert Hamming parity bits
        temp_parity = calculate_hamming_parity(data_in);
        hamming_codeword[0] = temp_parity[0];
        hamming_codeword[1] = temp_parity[1];
        hamming_codeword[3] = temp_parity[2];
        hamming_codeword[7] = temp_parity[3];
        
        // Calculate system parity (even parity over all Hamming codeword bits)
        expected_system_parity = ^hamming_codeword;
        
        // Combine Hamming codeword with system parity
        encoded_codeword = {expected_system_parity, hamming_codeword};
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
            syndrome = calculate_hamming_syndrome(hamming_codeword);
            
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
            if (syndrome == 0) begin
                if (system_parity_error) begin
                    // System parity bit error (corrected)
                    error_detected <= 1'b0;
                    error_corrected <= 1'b1;
                end else begin
                    // No error
                    error_detected <= 1'b0;
                    error_corrected <= 1'b0;
                end
            end else begin
                if (system_parity_error) begin
                    // Single bit error detected and corrected by Hamming
                    error_detected <= 1'b0;
                    error_corrected <= 1'b1;
                end else begin
                    // Double bit error detected but not corrected
                    error_detected <= 1'b1;
                    error_corrected <= 1'b0;
                end
            end
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */