// Reed-Muller ECC Module - Binary linear block code implementation
// Matches Python ReedMullerECC implementation for systematic encoding/decoding
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module reed_muller_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [63:0]            codeword_in,
    output reg  [63:0]            codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // For DATA_WIDTH=8, Reed-Muller(16,8)
    localparam [31:0] N = (DATA_WIDTH <= 4) ? 8 : 
                          (DATA_WIDTH <= 8) ? 16 : 
                          (DATA_WIDTH <= 16) ? 32 : 
                          (DATA_WIDTH <= 32) ? 64 : 64;
    
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] M = N - K;  // Number of parity bits
    
    // Data and parity positions
    // Data and parity positions
    // localparam int data_positions [0:7] = '{0, 1, 2, 3, 4, 5, 6, 7};
    // localparam int parity_positions [0:7] = '{8, 9, 10, 11, 12, 13, 14, 15};

    // Internal signals
    reg [N-1:0] encoded_codeword;
    reg [K-1:0] extracted_data;
    reg [M-1:0] syndrome;
    reg no_error, single_error;
    
    // Function to extract data from codeword (matches Python implementation)
    function [K-1:0] extract_data;
        input [N-1:0] codeword;
        reg [K-1:0] data;
        begin
            data = 0;
            // Hardcoded for DATA_WIDTH=8
            data[0] = codeword[0];
            data[1] = codeword[1];
            data[2] = codeword[2];
            data[3] = codeword[3];
            data[4] = codeword[4];
            data[5] = codeword[5];
            data[6] = codeword[6];
            data[7] = codeword[7];
            extract_data = data;
        end
    endfunction

    // Function to insert data into codeword (matches Python implementation)
    function [N-1:0] insert_data;
        input [K-1:0] data;
        reg [N-1:0] codeword;
        begin
            codeword = 0;
            // Hardcoded for DATA_WIDTH=8
            codeword[0] = data[0];
            codeword[1] = data[1];
            codeword[2] = data[2];
            codeword[3] = data[3];
            codeword[4] = data[4];
            codeword[5] = data[5];
            codeword[6] = data[6];
            codeword[7] = data[7];
            insert_data = codeword;
        end
    endfunction

    // Function to calculate parity bits (matches Python implementation)
    function [M-1:0] calculate_parity;
        input [N-1:0] codeword;
        reg [M-1:0] parity;
        begin
            parity = 0;
            // Hardcoded parity calculation for DATA_WIDTH=8
            // P0 (pos 8): checks 0, 2, 4, 6
            if (codeword[0]) parity[0] = parity[0] ^ 1'b1;
            if (codeword[2]) parity[0] = parity[0] ^ 1'b1;
            if (codeword[4]) parity[0] = parity[0] ^ 1'b1;
            if (codeword[6]) parity[0] = parity[0] ^ 1'b1;
            
            // P1 (pos 9): checks 1, 3, 5, 7
            if (codeword[1]) parity[1] = parity[1] ^ 1'b1;
            if (codeword[3]) parity[1] = parity[1] ^ 1'b1;
            if (codeword[5]) parity[1] = parity[1] ^ 1'b1;
            if (codeword[7]) parity[1] = parity[1] ^ 1'b1;
            
            // P2 (pos 10): checks 0, 2, 4, 6 (Same as P0)
            if (codeword[0]) parity[2] = parity[2] ^ 1'b1;
            if (codeword[2]) parity[2] = parity[2] ^ 1'b1;
            if (codeword[4]) parity[2] = parity[2] ^ 1'b1;
            if (codeword[6]) parity[2] = parity[2] ^ 1'b1;
            
            // P3 (pos 11): checks 1, 3, 5, 7 (Same as P1)
            if (codeword[1]) parity[3] = parity[3] ^ 1'b1;
            if (codeword[3]) parity[3] = parity[3] ^ 1'b1;
            if (codeword[5]) parity[3] = parity[3] ^ 1'b1;
            if (codeword[7]) parity[3] = parity[3] ^ 1'b1;
            
            // P4 (pos 12): checks 0, 2, 4, 6 (Same as P0)
            if (codeword[0]) parity[4] = parity[4] ^ 1'b1;
            if (codeword[2]) parity[4] = parity[4] ^ 1'b1;
            if (codeword[4]) parity[4] = parity[4] ^ 1'b1;
            if (codeword[6]) parity[4] = parity[4] ^ 1'b1;
            
            // P5 (pos 13): checks 1, 3, 5, 7 (Same as P1)
            if (codeword[1]) parity[5] = parity[5] ^ 1'b1;
            if (codeword[3]) parity[5] = parity[5] ^ 1'b1;
            if (codeword[5]) parity[5] = parity[5] ^ 1'b1;
            if (codeword[7]) parity[5] = parity[5] ^ 1'b1;
            
            // P6 (pos 14): checks 0, 2, 4, 6 (Same as P0)
            if (codeword[0]) parity[6] = parity[6] ^ 1'b1;
            if (codeword[2]) parity[6] = parity[6] ^ 1'b1;
            if (codeword[4]) parity[6] = parity[6] ^ 1'b1;
            if (codeword[6]) parity[6] = parity[6] ^ 1'b1;
            
            // P7 (pos 15): checks 1, 3, 5, 7 (Same as P1)
            if (codeword[1]) parity[7] = parity[7] ^ 1'b1;
            if (codeword[3]) parity[7] = parity[7] ^ 1'b1;
            if (codeword[5]) parity[7] = parity[7] ^ 1'b1;
            if (codeword[7]) parity[7] = parity[7] ^ 1'b1;
            
            // P7 (pos 15): checks all bits (overall parity)
            // Simplified for now
            
            calculate_parity = parity;
        end
    endfunction

    // Function to calculate syndrome (matches Python implementation)
    function [M-1:0] calculate_syndrome;
        input [N-1:0] codeword;
        reg [M-1:0] syndrome;
        reg [M-1:0] expected_parity;
        reg [M-1:0] actual_parity;
        begin
            syndrome = 0;
            expected_parity = 0;
            actual_parity = 0;
            
            // Calculate expected parity (same logic as calculate_parity)
            // P0
            if (codeword[0]) expected_parity[0] = expected_parity[0] ^ 1'b1;
            if (codeword[2]) expected_parity[0] = expected_parity[0] ^ 1'b1;
            if (codeword[4]) expected_parity[0] = expected_parity[0] ^ 1'b1;
            if (codeword[6]) expected_parity[0] = expected_parity[0] ^ 1'b1;
            
            // P1
            if (codeword[1]) expected_parity[1] = expected_parity[1] ^ 1'b1;
            if (codeword[3]) expected_parity[1] = expected_parity[1] ^ 1'b1;
            if (codeword[5]) expected_parity[1] = expected_parity[1] ^ 1'b1;
            if (codeword[7]) expected_parity[1] = expected_parity[1] ^ 1'b1;
            // P2 (pos 10): checks 0, 2, 4, 6 (Same as P0)
            if (codeword[0]) expected_parity[2] = expected_parity[2] ^ 1'b1;
            if (codeword[2]) expected_parity[2] = expected_parity[2] ^ 1'b1;
            if (codeword[4]) expected_parity[2] = expected_parity[2] ^ 1'b1;
            if (codeword[6]) expected_parity[2] = expected_parity[2] ^ 1'b1;
            
            // P3 (pos 11): checks 1, 3, 5, 7 (Same as P1)
            if (codeword[1]) expected_parity[3] = expected_parity[3] ^ 1'b1;
            if (codeword[3]) expected_parity[3] = expected_parity[3] ^ 1'b1;
            if (codeword[5]) expected_parity[3] = expected_parity[3] ^ 1'b1;
            if (codeword[7]) expected_parity[3] = expected_parity[3] ^ 1'b1;
            
            // P4 (pos 12): checks 0, 2, 4, 6 (Same as P0)
            if (codeword[0]) expected_parity[4] = expected_parity[4] ^ 1'b1;
            if (codeword[2]) expected_parity[4] = expected_parity[4] ^ 1'b1;
            if (codeword[4]) expected_parity[4] = expected_parity[4] ^ 1'b1;
            if (codeword[6]) expected_parity[4] = expected_parity[4] ^ 1'b1;
            
            // P5 (pos 13): checks 1, 3, 5, 7 (Same as P1)
            if (codeword[1]) expected_parity[5] = expected_parity[5] ^ 1'b1;
            if (codeword[3]) expected_parity[5] = expected_parity[5] ^ 1'b1;
            if (codeword[5]) expected_parity[5] = expected_parity[5] ^ 1'b1;
            if (codeword[7]) expected_parity[5] = expected_parity[5] ^ 1'b1;
            
            // P6 (pos 14): checks 0, 2, 4, 6 (Same as P0)
            if (codeword[0]) expected_parity[6] = expected_parity[6] ^ 1'b1;
            if (codeword[2]) expected_parity[6] = expected_parity[6] ^ 1'b1;
            if (codeword[4]) expected_parity[6] = expected_parity[6] ^ 1'b1;
            if (codeword[6]) expected_parity[6] = expected_parity[6] ^ 1'b1;
            
            // P7 (pos 15): checks 1, 3, 5, 7 (Same as P1)
            if (codeword[1]) expected_parity[7] = expected_parity[7] ^ 1'b1;
            if (codeword[3]) expected_parity[7] = expected_parity[7] ^ 1'b1;
            if (codeword[5]) expected_parity[7] = expected_parity[7] ^ 1'b1;
            if (codeword[7]) expected_parity[7] = expected_parity[7] ^ 1'b1;
            
            // Get actual parity
            actual_parity[0] = codeword[8];
            actual_parity[1] = codeword[9];
            actual_parity[2] = codeword[10];
            actual_parity[3] = codeword[11];
            actual_parity[4] = codeword[12];
            actual_parity[5] = codeword[13];
            actual_parity[6] = codeword[14];
            actual_parity[7] = codeword[15];
            
            syndrome = expected_parity ^ actual_parity;
            calculate_syndrome = syndrome;
        end
    endfunction

    // Function to correct single bit errors (simplified for Verilator)
    function [N-1:0] correct_single_bit_errors;
        input [N-1:0] codeword;
        input [M-1:0] syndrome;
        integer bit_pos;
        reg [N-1:0] test_codeword;
        reg [M-1:0] test_syndrome;
        begin
            correct_single_bit_errors = codeword; // Default: no correction
            
            // Try to correct single bit errors (simplified)
            for (bit_pos = 0; bit_pos < N; bit_pos = bit_pos + 1) begin
                // Try flipping this bit
                test_codeword = codeword ^ (1 << bit_pos);
                
                // Check if this fixes the syndrome (simplified check)
                test_syndrome = calculate_syndrome(test_codeword);
                
                if (test_syndrome == 0) begin
                    // Error corrected
                    correct_single_bit_errors = test_codeword;
                end
            end
        end
    endfunction

    // Encode Reed-Muller ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Insert data bits into codeword
            encoded_codeword = insert_data(data_in);
            
            // Calculate and insert parity bits
            encoded_codeword = encoded_codeword | (calculate_parity(encoded_codeword) << K);
        end else begin
            encoded_codeword = 0;
        end
    end

    // Internal signals for decoding
    reg [N-1:0] corrected_codeword;
    reg [M-1:0] corrected_syndrome;

    // Decode Reed-Muller ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Calculate syndrome
            syndrome = calculate_syndrome(codeword_in);
            
            // Check for errors
            no_error = (syndrome == 0);
            
            if (no_error) begin
                // No error detected
                single_error = 0;
                extracted_data = extract_data(codeword_in);
                corrected_codeword = codeword_in; // Assign to avoid latch
                corrected_syndrome = 0; // Assign to avoid latch
            end else begin
                // Try to correct single bit errors
                corrected_codeword = correct_single_bit_errors(codeword_in, syndrome);
                
                // Check if correction was successful
                corrected_syndrome = calculate_syndrome(corrected_codeword);
                
                if (corrected_syndrome == 0) begin
                    // Error corrected
                    single_error = 1;
                    extracted_data = extract_data(corrected_codeword);
                end else begin
                    // Error detected but not corrected
                    single_error = 0;
                    extracted_data = extract_data(codeword_in);
                end
            end
        end else begin
            syndrome = 0;
            no_error = 0;
            single_error = 0;
            extracted_data = 0;
            corrected_codeword = 0; // Assign to avoid latch
            corrected_syndrome = 0; // Assign to avoid latch
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
            
            // Error detection and correction logic
            if (no_error) begin
                // No error detected
                error_detected <= 1'b0;
                error_corrected <= 1'b0;
            end else if (single_error) begin
                // Error detected and corrected
                error_detected <= 1'b0;
                error_corrected <= 1'b1;
            end else begin
                // Error detected but not corrected
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */ 