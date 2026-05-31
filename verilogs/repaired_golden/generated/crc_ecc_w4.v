// Auto-generated parallel CRC-8 (impulse response), DATA_WIDTH=4
// Polynomial 0x07; combinational XOR trees, O(1) cycle encode/decode.
// Regenerate: python3 src/generate_crc_comb.py
module crc_ecc_w4 (
    input  wire                          clk,
    input  wire                          rst_n,
    input  wire                          encode_en,
    input  wire                          decode_en,
    input  wire [3:0]       data_in,
    input  wire [11:0]               codeword_in,
    output reg  [11:0]               codeword_out,
    output reg  [3:0]       data_out,
    output reg                           error_detected,
    output reg                           error_corrected,
    output reg                           valid_out
);

    wire [7:0] calculated_crc;
    wire [7:0] expected_crc_for_rx;
    wire [3:0] extracted_data = codeword_in[3:0];
    wire [7:0] received_crc = codeword_in[11:4];

    // --- TX: parallel XOR tree ---
    assign calculated_crc[0] = data_in[0] ^ data_in[1] ^ data_in[3];
    assign calculated_crc[1] = data_in[1] ^ data_in[2];
    assign calculated_crc[2] = data_in[2];
    assign calculated_crc[3] = data_in[1] ^ data_in[3];
    assign calculated_crc[4] = data_in[0] ^ data_in[2];
    assign calculated_crc[5] = data_in[0] ^ data_in[2];
    assign calculated_crc[6] = 1'b0;
    assign calculated_crc[7] = data_in[2] ^ data_in[3];

    // --- RX: parallel XOR tree ---
    assign expected_crc_for_rx[0] = extracted_data[0] ^ extracted_data[1] ^ extracted_data[3];
    assign expected_crc_for_rx[1] = extracted_data[1] ^ extracted_data[2];
    assign expected_crc_for_rx[2] = extracted_data[2];
    assign expected_crc_for_rx[3] = extracted_data[1] ^ extracted_data[3];
    assign expected_crc_for_rx[4] = extracted_data[0] ^ extracted_data[2];
    assign expected_crc_for_rx[5] = extracted_data[0] ^ extracted_data[2];
    assign expected_crc_for_rx[6] = 1'b0;
    assign expected_crc_for_rx[7] = extracted_data[2] ^ extracted_data[3];

    wire crc_mismatch = (expected_crc_for_rx != received_crc);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out    <= 12'd0;
            data_out        <= 4'd0;
            error_detected  <= 1'b0;
            error_corrected <= 1'b0;
            valid_out       <= 1'b0;
        end else if (encode_en) begin
            codeword_out    <= {calculated_crc, data_in};
            data_out        <= 4'd0;
            error_detected  <= 1'b0;
            error_corrected <= 1'b0;
            valid_out       <= 1'b1;
        end else if (decode_en) begin
            codeword_out    <= 12'd0;
            data_out        <= extracted_data;
            error_detected  <= crc_mismatch;
            error_corrected <= 1'b0;
            valid_out       <= 1'b1;
        end else begin
            valid_out       <= 1'b0;
        end
    end
endmodule
