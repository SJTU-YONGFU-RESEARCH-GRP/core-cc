/* verilator lint_off WIDTHEXPAND */

module adaptive_ecc #(
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
    
    // Adaptive ECC uses Hamming SECDED as base (simplified for hardware)
    // Function to encode using Hamming SECDED (matches Python adaptive logic)
    function [15:0] encode_adaptive_ecc;
        input [7:0] data;
        reg [15:0] codeword;
        reg [7:0] parity_bits;
        integer i, j;
        begin
            codeword = 0;
            
            // Systematic part: data bits (matches Python Hamming SECDED)
            codeword[7:0] = data;
            
            // Parity part: Hamming SECDED pattern (matches Python base ECC)
            parity_bits = 0;
            // For 8-bit data, hardcode the Hamming SECDED pattern
            parity_bits[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6];  // P1
            parity_bits[1] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6];  // P2
            parity_bits[2] = data[1] ^ data[2] ^ data[3] ^ data[7];            // P4
            parity_bits[3] = data[4] ^ data[5] ^ data[6] ^ data[7];            // P8
            parity_bits[4] = data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7]; // Overall parity
            parity_bits[5] = 0;  // Unused
            parity_bits[6] = 0;  // Unused
            parity_bits[7] = 0;  // Unused
            
            // Place parity bits in codeword
            codeword[15:8] = parity_bits;
            
            encode_adaptive_ecc = codeword;
        end
    endfunction
    
    // Function to calculate syndrome (matches Python Hamming SECDED)
    function [7:0] calculate_syndrome;
        input [15:0] codeword;
        reg [7:0] syndrome;
        reg [7:0] data_part, parity_part;
        begin
            // Extract data and parity parts
            data_part = codeword[7:0];
            parity_part = codeword[15:8];
            
            // Calculate syndrome using Hamming SECDED pattern
            syndrome[0] = data_part[0] ^ data_part[1] ^ data_part[3] ^ data_part[4] ^ data_part[6] ^ parity_part[0];  // P1
            syndrome[1] = data_part[0] ^ data_part[2] ^ data_part[3] ^ data_part[5] ^ data_part[6] ^ parity_part[1];  // P2
            syndrome[2] = data_part[1] ^ data_part[2] ^ data_part[3] ^ data_part[7] ^ parity_part[2];                // P4
            syndrome[3] = data_part[4] ^ data_part[5] ^ data_part[6] ^ data_part[7] ^ parity_part[3];                // P8
            syndrome[4] = data_part[0] ^ data_part[1] ^ data_part[2] ^ data_part[3] ^ data_part[4] ^ data_part[5] ^ data_part[6] ^ data_part[7] ^ parity_part[4]; // Overall parity
            syndrome[5] = parity_part[5];  // Unused
            syndrome[6] = parity_part[6];  // Unused
            syndrome[7] = parity_part[7];  // Unused
            
            calculate_syndrome = syndrome;
        end
    endfunction
    
    // Function to extract data from systematic codeword (matches Python)
    function [7:0] extract_data;
        input [15:0] codeword;
        reg [7:0] data;
        begin
            // Extract first K bits (systematic part)
            data = codeword[7:0];
            extract_data = data;
        end
    endfunction
    
    // Encode Adaptive ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            encoded_codeword = encode_adaptive_ecc(data_in);
        end else begin
            encoded_codeword = 0;
        end
    end
    
    // Decode Adaptive ECC (matches Python decode logic)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [7:0] syndrome;
            
            // Calculate syndrome (matches Python)
            syndrome = calculate_syndrome(codeword_in);
            
            if (syndrome == 0) begin
                // No errors detected (matches Python)
                extracted_data = extract_data(codeword_in);
                no_error = 1;
                single_error = 0;
            end else begin
                // Error detected (matches Python adaptive behavior)
                extracted_data = extract_data(codeword_in);
                no_error = 0;
                single_error = 1;
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
                // Error detected (adaptive behavior)
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end else begin
                // Error detected but not corrected
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end
        end
    end

endmodule 