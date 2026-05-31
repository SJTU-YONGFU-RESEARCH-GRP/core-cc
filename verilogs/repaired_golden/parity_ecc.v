// Parity ECC Module - Complete implementation with encoder and decoder
// Matches Python ParityECC implementation
// Parity ECC Module - Complete implementation with encoder and decoder
// Fixed Version: Strict isolation between Encoder inputs and Decoder inputs.
module parity_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [DATA_WIDTH:0]     codeword_in,  // received data + parity bit
    output reg  [DATA_WIDTH:0]     codeword_out, // transmitted data + parity bit
    output reg  [DATA_WIDTH-1:0]   data_out,
    output reg                     error_detected,
    output reg                     valid_out
);

    // ==========================================
    // 1. ENCODER LOGIC (Only relies on data_in)
    // ==========================================
    wire encode_parity_bit;
    wire [DATA_WIDTH:0] encoded_codeword;
    
    // Calculate even parity for encoding
    assign encode_parity_bit = ^data_in;
    // Concatenate data with parity bit (parity in LSB)
    assign encoded_codeword = {data_in, encode_parity_bit};
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {(DATA_WIDTH+1){1'b0}};
        end else if (encode_en) begin
            codeword_out <= encoded_codeword;
        end
    end

    // ==========================================
    // 2. DECODER LOGIC (Only relies on codeword_in)
    // ==========================================
    wire [DATA_WIDTH-1:0] received_data_bits;
    wire received_parity_bit;
    wire decode_calculated_parity;
    
    // Extract strictly from the received codeword
    assign received_data_bits = codeword_in[DATA_WIDTH:1];
    assign received_parity_bit = codeword_in[0];
    
    // Calculate parity based ONLY on what was received
    assign decode_calculated_parity = ^received_data_bits;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
        end else if (decode_en) begin
            data_out <= received_data_bits;
            // Error detected if the parity we calculate doesn't match the parity we received
            error_detected <= (received_parity_bit != decode_calculated_parity);
        end
    end

    // ==========================================
    // 3. VALID SIGNAL LOGIC
    // ==========================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
        end else begin
            // Valid goes high if either encode or decode is active
            valid_out <= (encode_en | decode_en);
        end
    end

endmodule