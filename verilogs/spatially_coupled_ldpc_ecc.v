/* verilator lint_off WIDTHEXPAND */

module spatially_coupled_ldpc_ecc #(
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
    
    // Function to encode using generator matrix (matches Python algorithm)
    function [15:0] encode_spatially_coupled_ldpc;
        input [7:0] data;
        reg [15:0] codeword;
        reg [7:0] parity_bits;
        integer i, j;
        begin
            codeword = 0;
            
            // Systematic part: data bits (matches Python G[i,i] = 1)
            codeword[7:0] = data;
            
            // Parity part: deterministic pattern (matches Python G[i,j] = 1 if (i+j)%2 == 0)
            parity_bits = 0;
            // For 8-bit data, hardcode the checkerboard pattern from Python algorithm
            parity_bits[0] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[0,8], G[2,8], G[4,8], G[6,8]
            parity_bits[1] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[1,9], G[3,9], G[5,9], G[7,9]
            parity_bits[2] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[0,10], G[2,10], G[4,10], G[6,10]
            parity_bits[3] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[1,11], G[3,11], G[5,11], G[7,11]
            parity_bits[4] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[0,12], G[2,12], G[4,12], G[6,12]
            parity_bits[5] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[1,13], G[3,13], G[5,13], G[7,13]
            parity_bits[6] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[0,14], G[2,14], G[4,14], G[6,14]
            parity_bits[7] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[1,15], G[3,15], G[5,15], G[7,15]
            
            // Place parity bits in codeword
            codeword[15:8] = parity_bits;
            
            encode_spatially_coupled_ldpc = codeword;
        end
    endfunction
    
    // Function to calculate syndrome (matches Python parity check matrix)
    function [7:0] calculate_syndrome;
        input [15:0] codeword;
        reg [7:0] syndrome;
        reg [7:0] data_part, parity_part;
        integer i, j;
        begin
            // Extract data and parity parts
            data_part = codeword[7:0];
            parity_part = codeword[15:8];
            
            // Calculate syndrome using parity check matrix (matches Python H matrix)
            // For 8-bit data, hardcode the pattern from Python parity check matrix
            syndrome[0] = data_part[0] ^ data_part[2] ^ data_part[4] ^ data_part[6] ^ parity_part[0];  // H[0,:]
            syndrome[1] = data_part[1] ^ data_part[3] ^ data_part[5] ^ data_part[7] ^ parity_part[1];  // H[1,:]
            syndrome[2] = data_part[0] ^ data_part[2] ^ data_part[4] ^ data_part[6] ^ parity_part[2];  // H[2,:]
            syndrome[3] = data_part[1] ^ data_part[3] ^ data_part[5] ^ data_part[7] ^ parity_part[3];  // H[3,:]
            syndrome[4] = data_part[0] ^ data_part[2] ^ data_part[4] ^ data_part[6] ^ parity_part[4];  // H[4,:]
            syndrome[5] = data_part[1] ^ data_part[3] ^ data_part[5] ^ data_part[7] ^ parity_part[5];  // H[5,:]
            syndrome[6] = data_part[0] ^ data_part[2] ^ data_part[4] ^ data_part[6] ^ parity_part[6];  // H[6,:]
            syndrome[7] = data_part[1] ^ data_part[3] ^ data_part[5] ^ data_part[7] ^ parity_part[7];  // H[7,:]
            
            calculate_syndrome = syndrome;
        end
    endfunction
    
    // Function to correct single bit errors (simplified for 8-bit data)
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
    
    // Function to extract data from systematic codeword (matches Python _extract_data)
    function [7:0] extract_data;
        input [15:0] codeword;
        reg [7:0] data;
        integer i;
        begin
            data = 0;
            // Extract first K bits (systematic part)
            for (i = 0; i < K; i = i + 1) begin
                data[i] = codeword[i];
            end
            extract_data = data;
        end
    endfunction
    
    // Encode Spatially-Coupled LDPC ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            encoded_codeword = encode_spatially_coupled_ldpc(data_in);
        end else begin
            encoded_codeword = 0;
        end
    end
    
    // Decode Spatially-Coupled LDPC ECC (matches Python decode logic)
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
            
            // Calculate syndrome (matches Python)
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