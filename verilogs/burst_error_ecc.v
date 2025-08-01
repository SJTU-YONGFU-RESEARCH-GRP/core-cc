/* verilator lint_off WIDTHEXPAND */

module burst_error_ecc #(
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
    localparam [31:0] BURST_LENGTH = 3;  // Burst length for 8-bit data (matches Python)
    
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
        input [7:0] data_bits;
        reg [15:0] parity;
        begin
            parity = 0;
            parity[8]  = data_bits[1] ^ data_bits[4] ^ data_bits[7];
            parity[9]  = data_bits[0] ^ data_bits[3] ^ data_bits[6];
            parity[10] = data_bits[2] ^ data_bits[5];
            parity[11] = data_bits[1] ^ data_bits[4] ^ data_bits[7];
            parity[12] = data_bits[0] ^ data_bits[3] ^ data_bits[6];
            parity[13] = data_bits[2] ^ data_bits[5];
            parity[14] = data_bits[1] ^ data_bits[4] ^ data_bits[7];
            parity[15] = data_bits[0] ^ data_bits[3] ^ data_bits[6];
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
            data_bits = codeword[7:0];
            expected_parity = data_bits[1] ^ data_bits[4] ^ data_bits[7];
            actual_parity = codeword[8];
            syndrome[0] = (expected_parity != actual_parity);
            expected_parity = data_bits[0] ^ data_bits[3] ^ data_bits[6];
            actual_parity = codeword[9];
            syndrome[1] = (expected_parity != actual_parity);
            expected_parity = data_bits[2] ^ data_bits[5];
            actual_parity = codeword[10];
            syndrome[2] = (expected_parity != actual_parity);
            expected_parity = data_bits[1] ^ data_bits[4] ^ data_bits[7];
            actual_parity = codeword[11];
            syndrome[3] = (expected_parity != actual_parity);
            expected_parity = data_bits[0] ^ data_bits[3] ^ data_bits[6];
            actual_parity = codeword[12];
            syndrome[4] = (expected_parity != actual_parity);
            expected_parity = data_bits[2] ^ data_bits[5];
            actual_parity = codeword[13];
            syndrome[5] = (expected_parity != actual_parity);
            expected_parity = data_bits[1] ^ data_bits[4] ^ data_bits[7];
            actual_parity = codeword[14];
            syndrome[6] = (expected_parity != actual_parity);
            expected_parity = data_bits[0] ^ data_bits[3] ^ data_bits[6];
            actual_parity = codeword[15];
            syndrome[7] = (expected_parity != actual_parity);
            calculate_syndrome = syndrome;
        end
    endfunction
    
    // Encode Burst Error ECC
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
    
    // Decode Burst Error ECC (matches Python decode logic)
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
                // Error detected (matches Python burst error behavior)
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
                // Error detected (burst error behavior)
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