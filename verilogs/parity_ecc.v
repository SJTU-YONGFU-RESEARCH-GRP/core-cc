// Parity ECC Module - Complete implementation with encoder and decoder
// Matches Python ParityECC implementation
module parity_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [DATA_WIDTH:0]    codeword_in,  // data + parity bit
    output reg  [DATA_WIDTH:0]    codeword_out, // data + parity bit
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     valid_out
);

    // Internal signals
    wire [DATA_WIDTH-1:0] data_bits;
    wire parity_bit;
    wire expected_parity;
    wire [DATA_WIDTH:0] encoded_codeword;
    
    // Extract data bits and parity bit from input codeword
    assign data_bits = codeword_in[DATA_WIDTH:1];
    assign parity_bit = codeword_in[0];
    
    // Calculate expected parity (even parity) - same as C testbench
    assign expected_parity = ^data_in;
    
    // Encode: concatenate data with parity bit (parity in LSB to match C testbench)
    assign encoded_codeword = {data_in, expected_parity};
    
    // Encoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {(DATA_WIDTH+1){1'b0}};
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
        end else if (decode_en) begin
            data_out <= data_bits;
            // Error detected if parity doesn't match
            error_detected <= (parity_bit != expected_parity);
        end
    end

endmodule 