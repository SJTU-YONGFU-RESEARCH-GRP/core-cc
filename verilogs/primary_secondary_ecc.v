/* verilator lint_off WIDTHEXPAND */

module primary_secondary_ecc #(
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
        input [7:0] data_bits;  // Only data bits (positions 0-7)
        reg [15:0] parity;
        begin
            parity = 0;
            // Hardcoded parity equations for 8-bit data (positions 8-15)
            // Python algorithm: (j + pos) % 2 == 0 where j=0-7, pos=8-15
            // Let me calculate: (j + pos) % 2 == 0 for each parity bit
            // P8: (0+8)%2=0, (1+8)%2=1, (2+8)%2=0, (3+8)%2=1, (4+8)%2=0, (5+8)%2=1, (6+8)%2=0, (7+8)%2=1
            // So P8 = d0 ^ d2 ^ d4 ^ d6
            parity[8]  = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];  // (0+8)%2=0, (2+8)%2=0, (4+8)%2=0, (6+8)%2=0
            parity[9]  = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];  // (1+9)%2=0, (3+9)%2=0, (5+9)%2=0, (7+9)%2=0
            parity[10] = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];  // (0+10)%2=0, (2+10)%2=0, (4+10)%2=0, (6+10)%2=0
            parity[11] = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];  // (1+11)%2=0, (3+11)%2=0, (5+11)%2=0, (7+11)%2=0
            parity[12] = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];  // (0+12)%2=0, (2+12)%2=0, (4+12)%2=0, (6+12)%2=0
            parity[13] = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];  // (1+13)%2=0, (3+13)%2=0, (5+13)%2=0, (7+13)%2=0
            parity[14] = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];  // (0+14)%2=0, (2+14)%2=0, (4+14)%2=0, (6+14)%2=0
            parity[15] = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];  // (1+15)%2=0, (3+15)%2=0, (5+15)%2=0, (7+15)%2=0
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
        reg [7:0] data_bits;
        reg expected_parity, actual_parity;
        begin
            // Extract data bits from codeword
            data_bits = codeword[7:0];
            
            // Parity bit 8
            expected_parity = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];
            actual_parity = codeword[8];
            syndrome[0] = (expected_parity != actual_parity);
            // Parity bit 9
            expected_parity = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];
            actual_parity = codeword[9];
            syndrome[1] = (expected_parity != actual_parity);
            // Parity bit 10
            expected_parity = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];
            actual_parity = codeword[10];
            syndrome[2] = (expected_parity != actual_parity);
            // Parity bit 11
            expected_parity = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];
            actual_parity = codeword[11];
            syndrome[3] = (expected_parity != actual_parity);
            // Parity bit 12
            expected_parity = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];
            actual_parity = codeword[12];
            syndrome[4] = (expected_parity != actual_parity);
            // Parity bit 13
            expected_parity = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];
            actual_parity = codeword[13];
            syndrome[5] = (expected_parity != actual_parity);
            // Parity bit 14
            expected_parity = data_bits[0] ^ data_bits[2] ^ data_bits[4] ^ data_bits[6];
            actual_parity = codeword[14];
            syndrome[6] = (expected_parity != actual_parity);
            // Parity bit 15
            expected_parity = data_bits[1] ^ data_bits[3] ^ data_bits[5] ^ data_bits[7];
            actual_parity = codeword[15];
            syndrome[7] = (expected_parity != actual_parity);
            calculate_syndrome = syndrome;
        end
    endfunction
    
    // Encode Primary-Secondary ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [15:0] data_codeword, parity_bits;
            
            // Insert data bits into codeword (matches Python _insert_data)
            data_codeword = insert_data(data_in);
            
            // Calculate and insert parity bits (matches Python _calculate_parity)
            parity_bits = calculate_parity(data_in);
            
            // Combine data and parity (matches Python encode)
            encoded_codeword = data_codeword | parity_bits;
        end else begin
            encoded_codeword = 0;
        end
    end
    
    // Decode Primary-Secondary ECC (matches Python decode logic)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [7:0] syndrome;
            
            // Calculate syndrome (matches Python decode)
            syndrome = calculate_syndrome(codeword_in);
            
            if (syndrome == 0) begin
                // No error detected (matches Python)
                extracted_data = extract_data(codeword_in);
                no_error = 1;
                single_error = 0;
            end else begin
                // Error detected (matches Python primary/secondary behavior)
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
                // Error detected (primary/secondary behavior)
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