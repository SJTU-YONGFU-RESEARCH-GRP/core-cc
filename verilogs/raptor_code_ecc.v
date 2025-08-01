/* verilator lint_off WIDTHEXPAND */

module raptor_code_ecc #(
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
    
    // Function to encode using systematic encoding matrix (matches Python algorithm)
    function [15:0] encode_raptor_code;
        input [7:0] data;
        reg [15:0] codeword;
        reg [7:0] parity_bits;
        integer i, j;
        begin
            codeword = 0;
            
            // Systematic part: data bits (matches Python G[i,i] = 1 for i < k)
            codeword[7:0] = data;
            
            // Parity part: deterministic pattern (matches Python G[i,j] = 1 if (i+j)%2 == 0)
            parity_bits = 0;
            // For 8-bit data, hardcode the checkerboard pattern from Python algorithm
            // i ranges from 8-15, j ranges from 0-7, so (i+j)%2 == 0 becomes ((8+i)+j)%2 == 0
            parity_bits[0] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[8,j] where j%2==0
            parity_bits[1] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[9,j] where j%2==1
            parity_bits[2] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[10,j] where j%2==0
            parity_bits[3] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[11,j] where j%2==1
            parity_bits[4] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[12,j] where j%2==0
            parity_bits[5] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[13,j] where j%2==1
            parity_bits[6] = data[0] ^ data[2] ^ data[4] ^ data[6];  // G[14,j] where j%2==0
            parity_bits[7] = data[1] ^ data[3] ^ data[5] ^ data[7];  // G[15,j] where j%2==1
            
            // Place parity bits in codeword
            codeword[15:8] = parity_bits;
            
            encode_raptor_code = codeword;
        end
    endfunction
    
    // Function to extract data from systematic codeword (matches Python _matrix_decode)
    function [7:0] extract_data;
        input [15:0] codeword;
        reg [7:0] data;
        begin
            // Extract first K bits as data (matches Python systematic_bits = received_bits[:self.k])
            data = codeword[7:0];
            extract_data = data;
        end
    endfunction
    
    // Encode Raptor Code ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            encoded_codeword = encode_raptor_code(data_in);
        end else begin
            encoded_codeword = 0;
        end
    end
    
    // Decode Raptor Code ECC (matches Python decode logic)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Extract data from systematic part (matches Python _matrix_decode)
            extracted_data = extract_data(codeword_in);
            
            // For simplified version, assume no errors detected (matches Python return systematic_bits, 'corrected')
            no_error = 1;
            single_error = 0;
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