/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */

module turbo_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 24  // 8-bit systematic + 8-bit parity1 + 8-bit parity2
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

    // Internal signals
    reg [CODEWORD_WIDTH-1:0] encoded_codeword;
    reg [DATA_WIDTH-1:0] extracted_data;
    reg no_error, single_error;
    
    // Function to perform RSC encoding (simplified)
    function [7:0] rsc_encode;
        input [7:0] data;
        reg [7:0] parity;
        reg [1:0] state;
        integer i;
        begin
            parity = 0;
            state = 0;
            for (i = 0; i < 8; i = i + 1) begin
                // Simple RSC: parity = (bit + state[0] + state[1]) % 2
                parity[i] = data[i] ^ state[0] ^ state[1];
                // Update state: shift and add new bit
                state = {state[0], data[i]};
            end
            rsc_encode = parity;
        end
    endfunction
    
    // Function to perform simple interleaving (bit reversal for 8-bit)
    function [7:0] interleave;
        input [7:0] data;
        reg [7:0] interleaved;
        integer i;
        begin
            interleaved = 0;
            for (i = 0; i < 8; i = i + 1) begin
                interleaved[i] = data[7-i];  // Simple bit reversal
            end
            interleaved = interleaved;
        end
    endfunction
    
    // Encode Turbo ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [7:0] systematic_bits, parity1_bits, parity2_bits;
            reg [7:0] interleaved_data;
            
            // Systematic bits (original data)
            systematic_bits = data_in;
            
            // First encoder (parity1)
            parity1_bits = rsc_encode(systematic_bits);
            
            // Interleave data for second encoder
            interleaved_data = interleave(systematic_bits);
            
            // Second encoder (parity2)
            parity2_bits = rsc_encode(interleaved_data);
            
            // Combine: systematic + parity1 + parity2 (matches Python: data_bits + parity1 + parity2)
            encoded_codeword = {systematic_bits, parity1_bits, parity2_bits};
        end else begin
            encoded_codeword = 0;
        end
    end
    
    // Decode Turbo ECC (matches Python: extract systematic bits from first data_length bits)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            // Extract systematic bits (first 8 bits) - matches Python systematic_bits = codeword_bits[:self.data_length]
            extracted_data = codeword_in[7:0];
            
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
                // Multiple errors detected but not corrected
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */ 