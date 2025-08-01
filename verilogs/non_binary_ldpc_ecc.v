/* verilator lint_off WIDTHEXPAND */

module non_binary_ldpc_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 16  // 8-bit data + 8-bit parity
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [CODEWORD_WIDTH-1:0] codeword_in,
    output reg  [CODEWORD_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // Configuration for 8-bit data (matches Python)
    localparam [31:0] K = 8;  // Data bits
    localparam [31:0] N = 16; // Total codeword bits
    localparam [31:0] M = 8;  // Parity bits (N - K)
    
    // Internal signals
    reg [CODEWORD_WIDTH-1:0] encoded_codeword;
    reg [DATA_WIDTH-1:0] extracted_data;
    reg no_error, single_error;
    
    // Function to insert data bits into codeword positions (matches Python _insert_data)
    function [15:0] insert_data;
        input [7:0] data;
        reg [15:0] codeword;
        integer i;
        begin
            codeword = 0;
            // Insert data bits in their positions (matches Python data_positions)
            for (i = 0; i < K; i = i + 1) begin
                codeword[i] = data[i];
            end
            insert_data = codeword;
        end
    endfunction
    
    // Function to calculate parity bits (hardware-friendly, matches Python for 8-bit data)
    function [15:0] calculate_parity;
        input [15:0] codeword;
        reg [15:0] parity;
        begin
            parity = 0;
            // Hardcoded parity equations for 8-bit data (positions 8-15)
            parity[8]  = codeword[1] ^ codeword[4] ^ codeword[7];
            parity[9]  = codeword[0] ^ codeword[3] ^ codeword[6];
            parity[10] = codeword[2] ^ codeword[5];
            parity[11] = codeword[1] ^ codeword[4] ^ codeword[7];
            parity[12] = codeword[0] ^ codeword[3] ^ codeword[6];
            parity[13] = codeword[2] ^ codeword[5];
            parity[14] = codeword[1] ^ codeword[4] ^ codeword[7];
            parity[15] = codeword[0] ^ codeword[3] ^ codeword[6];
            calculate_parity = parity;
        end
    endfunction
    
    // Function to extract data from codeword (matches Python _extract_data)
    function [7:0] extract_data;
        input [15:0] codeword;
        reg [7:0] data;
        integer i;
        begin
            data = 0;
            // Extract data bits from their positions (matches Python data_positions)
            for (i = 0; i < K; i = i + 1) begin
                data[i] = codeword[i];
            end
            extract_data = data;
        end
    endfunction
    
    // Function to calculate syndrome (hardware-friendly, matches Python for 8-bit data)
    function [7:0] calculate_syndrome;
        input [15:0] codeword;
        reg [7:0] syndrome;
        reg expected_parity, actual_parity;
        begin
            // Parity bit 8
            expected_parity = codeword[1] ^ codeword[4] ^ codeword[7];
            actual_parity = codeword[8];
            syndrome[0] = (expected_parity != actual_parity);
            // Parity bit 9
            expected_parity = codeword[0] ^ codeword[3] ^ codeword[6];
            actual_parity = codeword[9];
            syndrome[1] = (expected_parity != actual_parity);
            // Parity bit 10
            expected_parity = codeword[2] ^ codeword[5];
            actual_parity = codeword[10];
            syndrome[2] = (expected_parity != actual_parity);
            // Parity bit 11
            expected_parity = codeword[1] ^ codeword[4] ^ codeword[7];
            actual_parity = codeword[11];
            syndrome[3] = (expected_parity != actual_parity);
            // Parity bit 12
            expected_parity = codeword[0] ^ codeword[3] ^ codeword[6];
            actual_parity = codeword[12];
            syndrome[4] = (expected_parity != actual_parity);
            // Parity bit 13
            expected_parity = codeword[2] ^ codeword[5];
            actual_parity = codeword[13];
            syndrome[5] = (expected_parity != actual_parity);
            // Parity bit 14
            expected_parity = codeword[1] ^ codeword[4] ^ codeword[7];
            actual_parity = codeword[14];
            syndrome[6] = (expected_parity != actual_parity);
            // Parity bit 15
            expected_parity = codeword[0] ^ codeword[3] ^ codeword[6];
            actual_parity = codeword[15];
            syndrome[7] = (expected_parity != actual_parity);
            calculate_syndrome = syndrome;
        end
    endfunction
    
    // Function to correct single bit errors (matches Python decode algorithm)
    function [15:0] correct_single_error;
        input [15:0] codeword;
        input [7:0] syndrome;
        reg [15:0] corrected_codeword;
        reg [7:0] test_syndrome;
        reg [15:0] test_codeword;
        integer bit_pos;
        begin
            corrected_codeword = codeword;
            
            // Try flipping each bit and check if syndrome becomes zero
            for (bit_pos = 0; bit_pos < N; bit_pos = bit_pos + 1) begin
                test_codeword = codeword ^ (1 << bit_pos);
                test_syndrome = calculate_syndrome(test_codeword);
                
                // If syndrome is zero, error is corrected
                if (test_syndrome == 0) begin
                    corrected_codeword = test_codeword;
                end
            end
            
            correct_single_error = corrected_codeword;
        end
    endfunction
    
    // Encode Non-Binary LDPC ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [15:0] data_codeword, parity_bits;
            
            // Insert data bits into codeword (matches Python _insert_data)
            data_codeword = insert_data(data_in);
            
            // Calculate and insert parity bits (matches Python _calculate_parity)
            parity_bits = calculate_parity(data_codeword);
            
            // Combine data and parity (matches Python encode)
            encoded_codeword = data_codeword | parity_bits;
        end else begin
            encoded_codeword = 0;
        end
    end
    
    // Decode Non-Binary LDPC ECC (matches Python decode logic)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [7:0] syndrome;
            reg [15:0] corrected_codeword;
            reg correction_success;
            reg [7:0] test_syndrome;
            
            // Initialize variables to prevent latch inference
            corrected_codeword = codeword_in;
            test_syndrome = 0;
            correction_success = 0;
            
            // Calculate syndrome (matches Python decode)
            syndrome = calculate_syndrome(codeword_in);
            
            if (syndrome == 0) begin
                // No errors detected (matches Python)
                extracted_data = extract_data(codeword_in);
                no_error = 1;
                single_error = 0;
            end else begin
                // Try to correct single bit errors (matches Python)
                corrected_codeword = correct_single_error(codeword_in, syndrome);
                
                // Check if correction was successful
                test_syndrome = calculate_syndrome(corrected_codeword);
                correction_success = (test_syndrome == 0);
                
                if (correction_success) begin
                    // Error corrected (matches Python)
                    extracted_data = extract_data(corrected_codeword);
                    no_error = 0;
                    single_error = 1;
                end else begin
                    // Error detected but not corrected (matches Python)
                    extracted_data = extract_data(codeword_in);
                    no_error = 0;
                    single_error = 0;
                end
            end
        end else begin
            extracted_data = 0;
            no_error = 0;
            single_error = 0;
        end
    end

    // Encoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {CODEWORD_WIDTH{1'b0}};
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
            
            // Error detection and correction logic (matches Python)
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