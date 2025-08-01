// Fire Code ECC Module - Burst error correction implementation
// Matches Python FireCodeECC implementation for burst error correction
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module fire_code_ecc #(
    parameter DATA_WIDTH = 8,
    parameter BURST_LENGTH = 3
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [31:0]            codeword_in,
    output reg  [31:0]            codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // Fire Code parameters
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] PARITY_LENGTH = 2 * BURST_LENGTH;
    localparam [31:0] N = K + PARITY_LENGTH;
    
    // Internal signals
    reg [N-1:0] encoded_codeword;
    reg [K-1:0] extracted_data;
    reg [PARITY_LENGTH-1:0] syndrome;
    reg no_error, burst_error_corrected;
    
    // Function to calculate parity bits
    function [PARITY_LENGTH-1:0] calculate_parity;
        input [K-1:0] data;
        integer i;
        reg [PARITY_LENGTH-1:0] parity;
        begin
            parity = 0;
            for (i = 0; i < K; i = i + 1) begin
                if (data[i]) begin
                    // Add contribution to parity
                    parity[i % PARITY_LENGTH] = parity[i % PARITY_LENGTH] ^ 1'b1;
                end
            end
            calculate_parity = parity;
        end
    endfunction

    // Function to extract data from codeword
    function [K-1:0] extract_data;
        input [N-1:0] codeword;
        begin
            extract_data = (codeword >> PARITY_LENGTH) & ((1 << K) - 1);
        end
    endfunction

    // Function to calculate syndrome
    function [PARITY_LENGTH-1:0] calculate_syndrome;
        input [N-1:0] codeword;
        reg [K-1:0] data;
        reg [PARITY_LENGTH-1:0] received_parity;
        reg [PARITY_LENGTH-1:0] expected_parity;
        begin
            data = extract_data(codeword);
            received_parity = codeword & ((1 << PARITY_LENGTH) - 1);
            expected_parity = calculate_parity(data);
            calculate_syndrome = received_parity ^ expected_parity;
        end
    endfunction

    // Function to correct burst errors (simplified)
    function [K-1:0] correct_burst_errors;
        input [K-1:0] data;
        input [PARITY_LENGTH-1:0] syndrome;
        integer start_pos, i;
        reg [K-1:0] corrected_data;
        reg [PARITY_LENGTH-1:0] error_pattern;
        reg correction_found;
        begin
            corrected_data = data;
            correction_found = 0;
            
            // Try different burst positions
            for (start_pos = 0; start_pos < N; start_pos = start_pos + 1) begin
                // Try to correct a burst starting at start_pos
                error_pattern = 0;
                for (i = 0; i < BURST_LENGTH; i = i + 1) begin
                    if (start_pos + i < PARITY_LENGTH) begin
                        error_pattern[start_pos + i] = 1'b1;
                    end
                end
                
                // Check if this error pattern matches the syndrome
                if ((error_pattern & ((1 << PARITY_LENGTH) - 1)) == syndrome) begin
                    // Found matching error pattern
                    for (i = 0; i < BURST_LENGTH; i = i + 1) begin
                        if (start_pos + i >= PARITY_LENGTH) begin
                            if ((start_pos + i - PARITY_LENGTH) < K) begin
                                corrected_data[start_pos + i - PARITY_LENGTH] = 
                                    corrected_data[start_pos + i - PARITY_LENGTH] ^ 1'b1;
                            end
                        end
                    end
                    correction_found = 1;
                end
            end
            
            if (!correction_found) begin
                corrected_data = data; // No correction possible
            end
            
            correct_burst_errors = corrected_data;
        end
    endfunction

    // Encode Fire Code ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Create systematic code: data bits followed by parity bits
            encoded_codeword = data_in << PARITY_LENGTH;
            
            // Calculate and add parity bits
            encoded_codeword = encoded_codeword | calculate_parity(data_in);
        end else begin
            encoded_codeword = 0;
        end
    end

    // Decode Fire Code ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Extract data and calculate syndrome
            extracted_data = extract_data(codeword_in);
            syndrome = calculate_syndrome(codeword_in);
            
            // Check for errors
            no_error = (syndrome == 0);
            
            if (no_error) begin
                // No errors
                burst_error_corrected = 0;
            end else begin
                // Try to correct burst errors
                extracted_data = correct_burst_errors(extracted_data, syndrome);
                burst_error_corrected = 1;
            end
        end else begin
            syndrome = 0;
            no_error = 0;
            burst_error_corrected = 0;
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
            
            // Error detection and correction logic
            if (no_error) begin
                // No error detected
                error_detected <= 1'b0;
                error_corrected <= 1'b0;
            end else if (burst_error_corrected) begin
                // Burst error detected and corrected
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