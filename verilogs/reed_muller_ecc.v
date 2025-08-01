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
    localparam int data_positions [0:7] = '{0, 1, 2, 3, 4, 5, 6, 7};
    localparam int parity_positions [0:7] = '{8, 9, 10, 11, 12, 13, 14, 15};

    // Internal signals
    reg [N-1:0] encoded_codeword;
    reg [K-1:0] extracted_data;
    reg [M-1:0] syndrome;
    reg no_error, single_error;
    
    // Function to extract data from codeword (matches Python implementation)
    function [K-1:0] extract_data;
        input [N-1:0] codeword;
        integer i;
        reg [K-1:0] data;
        begin
            data = 0;
            for (i = 0; i < K; i = i + 1) begin
                data[i] = codeword[data_positions[i]];
            end
            extract_data = data;
        end
    endfunction

    // Function to insert data into codeword (matches Python implementation)
    function [N-1:0] insert_data;
        input [K-1:0] data;
        integer i;
        reg [N-1:0] codeword;
        begin
            codeword = 0;
            for (i = 0; i < K; i = i + 1) begin
                codeword[data_positions[i]] = data[i];
            end
            insert_data = codeword;
        end
    endfunction

    // Function to calculate parity bits (matches Python implementation)
    function [M-1:0] calculate_parity;
        input [N-1:0] codeword;
        integer i, j, pos;
        reg [M-1:0] parity;
        begin
            parity = 0;
            for (i = 0; i < M; i = i + 1) begin
                pos = parity_positions[i];
                for (j = 0; j < K; j = j + 1) begin
                    if (codeword[data_positions[j]] && ((j + pos) % 2 == 0)) begin
                        parity[i] = parity[i] ^ 1'b1;
                    end
                end
            end
            calculate_parity = parity;
        end
    endfunction

    // Function to calculate syndrome (matches Python implementation)
    function [M-1:0] calculate_syndrome;
        input [N-1:0] codeword;
        integer i, j, pos;
        reg [M-1:0] syndrome;
        reg [M-1:0] expected_parity;
        reg [M-1:0] actual_parity;
        begin
            syndrome = 0;
            expected_parity = 0;
            actual_parity = 0;
            
            // Calculate expected parity
            for (i = 0; i < M; i = i + 1) begin
                pos = parity_positions[i];
                for (j = 0; j < K; j = j + 1) begin
                    if (codeword[data_positions[j]] && ((j + pos) % 2 == 0)) begin
                        expected_parity[i] = expected_parity[i] ^ 1'b1;
                    end
                end
            end
            
            // Get actual parity
            for (i = 0; i < M; i = i + 1) begin
                actual_parity[i] = codeword[parity_positions[i]];
            end
            
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