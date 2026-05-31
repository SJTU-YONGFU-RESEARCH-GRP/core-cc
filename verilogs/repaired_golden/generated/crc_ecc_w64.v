// Auto-generated parallel CRC-8 (impulse response), DATA_WIDTH=64
// Polynomial 0x07; combinational XOR trees, O(1) cycle encode/decode.
// Regenerate: python3 src/generate_crc_comb.py
module crc_ecc_w64 (
    input  wire                          clk,
    input  wire                          rst_n,
    input  wire                          encode_en,
    input  wire                          decode_en,
    input  wire [63:0]       data_in,
    input  wire [71:0]               codeword_in,
    output reg  [71:0]               codeword_out,
    output reg  [63:0]       data_out,
    output reg                           error_detected,
    output reg                           error_corrected,
    output reg                           valid_out
);

    wire [7:0] calculated_crc;
    wire [7:0] expected_crc_for_rx;
    wire [63:0] extracted_data = codeword_in[63:0];
    wire [7:0] received_crc = codeword_in[71:64];

    // --- TX: parallel XOR tree ---
    assign calculated_crc[0] = data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[26] ^ data_in[34] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[46] ^ data_in[47] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[53] ^ data_in[56] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[63];
    assign calculated_crc[1] = data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[14] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[33] ^ data_in[38] ^ data_in[41] ^ data_in[42] ^ data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[52] ^ data_in[56] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[62];
    assign calculated_crc[2] = data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[25] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[32] ^ data_in[34] ^ data_in[35] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[42] ^ data_in[45] ^ data_in[47] ^ data_in[48] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[56] ^ data_in[58] ^ data_in[59] ^ data_in[62];
    assign calculated_crc[3] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[9] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[26] ^ data_in[29] ^ data_in[31] ^ data_in[32] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[42] ^ data_in[43] ^ data_in[46] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[56] ^ data_in[57] ^ data_in[58] ^ data_in[61] ^ data_in[63];
    assign calculated_crc[4] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[10] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[30] ^ data_in[34] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[45] ^ data_in[47] ^ data_in[50] ^ data_in[51] ^ data_in[55] ^ data_in[56] ^ data_in[59] ^ data_in[60] ^ data_in[62];
    assign calculated_crc[5] = data_in[0] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[29] ^ data_in[31] ^ data_in[34] ^ data_in[35] ^ data_in[39] ^ data_in[40] ^ data_in[43] ^ data_in[44] ^ data_in[46] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[62];
    assign calculated_crc[6] = data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[23] ^ data_in[24] ^ data_in[27] ^ data_in[28] ^ data_in[30] ^ data_in[35] ^ data_in[37] ^ data_in[39] ^ data_in[40] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[58];
    assign calculated_crc[7] = data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[30] ^ data_in[34] ^ data_in[35] ^ data_in[36] ^ data_in[42] ^ data_in[50] ^ data_in[51] ^ data_in[53] ^ data_in[54] ^ data_in[56] ^ data_in[57] ^ data_in[58] ^ data_in[59] ^ data_in[62] ^ data_in[63];

    // --- RX: parallel XOR tree ---
    assign expected_crc_for_rx[0] = extracted_data[3] ^ extracted_data[5] ^ extracted_data[7] ^ extracted_data[8] ^ extracted_data[10] ^ extracted_data[12] ^ extracted_data[14] ^ extracted_data[18] ^ extracted_data[19] ^ extracted_data[20] ^ extracted_data[26] ^ extracted_data[34] ^ extracted_data[35] ^ extracted_data[37] ^ extracted_data[38] ^ extracted_data[40] ^ extracted_data[41] ^ extracted_data[42] ^ extracted_data[43] ^ extracted_data[46] ^ extracted_data[47] ^ extracted_data[48] ^ extracted_data[49] ^ extracted_data[50] ^ extracted_data[51] ^ extracted_data[53] ^ extracted_data[56] ^ extracted_data[59] ^ extracted_data[60] ^ extracted_data[61] ^ extracted_data[63];
    assign expected_crc_for_rx[1] = extracted_data[2] ^ extracted_data[4] ^ extracted_data[5] ^ extracted_data[7] ^ extracted_data[8] ^ extracted_data[12] ^ extracted_data[14] ^ extracted_data[20] ^ extracted_data[21] ^ extracted_data[22] ^ extracted_data[24] ^ extracted_data[25] ^ extracted_data[27] ^ extracted_data[30] ^ extracted_data[31] ^ extracted_data[32] ^ extracted_data[33] ^ extracted_data[38] ^ extracted_data[41] ^ extracted_data[42] ^ extracted_data[44] ^ extracted_data[45] ^ extracted_data[46] ^ extracted_data[48] ^ extracted_data[52] ^ extracted_data[56] ^ extracted_data[57] ^ extracted_data[59] ^ extracted_data[61] ^ extracted_data[62];
    assign expected_crc_for_rx[2] = extracted_data[3] ^ extracted_data[4] ^ extracted_data[6] ^ extracted_data[7] ^ extracted_data[9] ^ extracted_data[10] ^ extracted_data[11] ^ extracted_data[12] ^ extracted_data[15] ^ extracted_data[16] ^ extracted_data[17] ^ extracted_data[18] ^ extracted_data[19] ^ extracted_data[20] ^ extracted_data[22] ^ extracted_data[25] ^ extracted_data[28] ^ extracted_data[29] ^ extracted_data[30] ^ extracted_data[32] ^ extracted_data[34] ^ extracted_data[35] ^ extracted_data[36] ^ extracted_data[37] ^ extracted_data[38] ^ extracted_data[42] ^ extracted_data[45] ^ extracted_data[47] ^ extracted_data[48] ^ extracted_data[53] ^ extracted_data[54] ^ extracted_data[55] ^ extracted_data[56] ^ extracted_data[58] ^ extracted_data[59] ^ extracted_data[62];
    assign expected_crc_for_rx[3] = extracted_data[0] ^ extracted_data[1] ^ extracted_data[2] ^ extracted_data[3] ^ extracted_data[4] ^ extracted_data[6] ^ extracted_data[9] ^ extracted_data[12] ^ extracted_data[13] ^ extracted_data[14] ^ extracted_data[16] ^ extracted_data[18] ^ extracted_data[19] ^ extracted_data[20] ^ extracted_data[21] ^ extracted_data[22] ^ extracted_data[26] ^ extracted_data[29] ^ extracted_data[31] ^ extracted_data[32] ^ extracted_data[37] ^ extracted_data[38] ^ extracted_data[39] ^ extracted_data[40] ^ extracted_data[42] ^ extracted_data[43] ^ extracted_data[46] ^ extracted_data[50] ^ extracted_data[52] ^ extracted_data[53] ^ extracted_data[54] ^ extracted_data[56] ^ extracted_data[57] ^ extracted_data[58] ^ extracted_data[61] ^ extracted_data[63];
    assign expected_crc_for_rx[4] = extracted_data[0] ^ extracted_data[2] ^ extracted_data[3] ^ extracted_data[4] ^ extracted_data[5] ^ extracted_data[6] ^ extracted_data[10] ^ extracted_data[13] ^ extracted_data[15] ^ extracted_data[16] ^ extracted_data[21] ^ extracted_data[22] ^ extracted_data[23] ^ extracted_data[24] ^ extracted_data[26] ^ extracted_data[27] ^ extracted_data[30] ^ extracted_data[34] ^ extracted_data[36] ^ extracted_data[37] ^ extracted_data[38] ^ extracted_data[40] ^ extracted_data[41] ^ extracted_data[42] ^ extracted_data[45] ^ extracted_data[47] ^ extracted_data[50] ^ extracted_data[51] ^ extracted_data[55] ^ extracted_data[56] ^ extracted_data[59] ^ extracted_data[60] ^ extracted_data[62];
    assign expected_crc_for_rx[5] = extracted_data[0] ^ extracted_data[5] ^ extracted_data[6] ^ extracted_data[7] ^ extracted_data[8] ^ extracted_data[10] ^ extracted_data[11] ^ extracted_data[14] ^ extracted_data[18] ^ extracted_data[20] ^ extracted_data[21] ^ extracted_data[22] ^ extracted_data[24] ^ extracted_data[25] ^ extracted_data[26] ^ extracted_data[29] ^ extracted_data[31] ^ extracted_data[34] ^ extracted_data[35] ^ extracted_data[39] ^ extracted_data[40] ^ extracted_data[43] ^ extracted_data[44] ^ extracted_data[46] ^ extracted_data[51] ^ extracted_data[53] ^ extracted_data[55] ^ extracted_data[56] ^ extracted_data[58] ^ extracted_data[60] ^ extracted_data[62];
    assign expected_crc_for_rx[6] = extracted_data[2] ^ extracted_data[4] ^ extracted_data[5] ^ extracted_data[6] ^ extracted_data[8] ^ extracted_data[9] ^ extracted_data[10] ^ extracted_data[13] ^ extracted_data[15] ^ extracted_data[18] ^ extracted_data[19] ^ extracted_data[23] ^ extracted_data[24] ^ extracted_data[27] ^ extracted_data[28] ^ extracted_data[30] ^ extracted_data[35] ^ extracted_data[37] ^ extracted_data[39] ^ extracted_data[40] ^ extracted_data[42] ^ extracted_data[44] ^ extracted_data[46] ^ extracted_data[50] ^ extracted_data[51] ^ extracted_data[52] ^ extracted_data[58];
    assign expected_crc_for_rx[7] = extracted_data[2] ^ extracted_data[3] ^ extracted_data[7] ^ extracted_data[8] ^ extracted_data[11] ^ extracted_data[12] ^ extracted_data[14] ^ extracted_data[19] ^ extracted_data[21] ^ extracted_data[23] ^ extracted_data[24] ^ extracted_data[26] ^ extracted_data[28] ^ extracted_data[30] ^ extracted_data[34] ^ extracted_data[35] ^ extracted_data[36] ^ extracted_data[42] ^ extracted_data[50] ^ extracted_data[51] ^ extracted_data[53] ^ extracted_data[54] ^ extracted_data[56] ^ extracted_data[57] ^ extracted_data[58] ^ extracted_data[59] ^ extracted_data[62] ^ extracted_data[63];

    wire crc_mismatch = (expected_crc_for_rx != received_crc);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out    <= 72'd0;
            data_out        <= 64'd0;
            error_detected  <= 1'b0;
            error_corrected <= 1'b0;
            valid_out       <= 1'b0;
        end else if (encode_en) begin
            codeword_out    <= {calculated_crc, data_in};
            data_out        <= 64'd0;
            error_detected  <= 1'b0;
            error_corrected <= 1'b0;
            valid_out       <= 1'b1;
        end else if (decode_en) begin
            codeword_out    <= 72'd0;
            data_out        <= extracted_data;
            error_detected  <= crc_mismatch;
            error_corrected <= 1'b0;
            valid_out       <= 1'b1;
        end else begin
            valid_out       <= 1'b0;
        end
    end
endmodule
