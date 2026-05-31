module fire_code_ecc_w128 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [127:0] data_in,
    input  wire [137:0] codeword_in,
    output reg  [137:0] codeword_out,
    output reg  [127:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    reg [9:0] parity_calc;
    always @(*) begin
        parity_calc[0] = data_in[0] ^ data_in[10] ^ data_in[20] ^ data_in[30] ^ data_in[40] ^ data_in[50] ^ data_in[60] ^ data_in[70] ^ data_in[80] ^ data_in[90] ^ data_in[100] ^ data_in[110] ^ data_in[120];
        parity_calc[1] = data_in[1] ^ data_in[11] ^ data_in[21] ^ data_in[31] ^ data_in[41] ^ data_in[51] ^ data_in[61] ^ data_in[71] ^ data_in[81] ^ data_in[91] ^ data_in[101] ^ data_in[111] ^ data_in[121];
        parity_calc[2] = data_in[2] ^ data_in[12] ^ data_in[22] ^ data_in[32] ^ data_in[42] ^ data_in[52] ^ data_in[62] ^ data_in[72] ^ data_in[82] ^ data_in[92] ^ data_in[102] ^ data_in[112] ^ data_in[122];
        parity_calc[3] = data_in[3] ^ data_in[13] ^ data_in[23] ^ data_in[33] ^ data_in[43] ^ data_in[53] ^ data_in[63] ^ data_in[73] ^ data_in[83] ^ data_in[93] ^ data_in[103] ^ data_in[113] ^ data_in[123];
        parity_calc[4] = data_in[4] ^ data_in[14] ^ data_in[24] ^ data_in[34] ^ data_in[44] ^ data_in[54] ^ data_in[64] ^ data_in[74] ^ data_in[84] ^ data_in[94] ^ data_in[104] ^ data_in[114] ^ data_in[124];
        parity_calc[5] = data_in[5] ^ data_in[15] ^ data_in[25] ^ data_in[35] ^ data_in[45] ^ data_in[55] ^ data_in[65] ^ data_in[75] ^ data_in[85] ^ data_in[95] ^ data_in[105] ^ data_in[115] ^ data_in[125];
        parity_calc[6] = data_in[6] ^ data_in[16] ^ data_in[26] ^ data_in[36] ^ data_in[46] ^ data_in[56] ^ data_in[66] ^ data_in[76] ^ data_in[86] ^ data_in[96] ^ data_in[106] ^ data_in[116] ^ data_in[126];
        parity_calc[7] = data_in[7] ^ data_in[17] ^ data_in[27] ^ data_in[37] ^ data_in[47] ^ data_in[57] ^ data_in[67] ^ data_in[77] ^ data_in[87] ^ data_in[97] ^ data_in[107] ^ data_in[117] ^ data_in[127];
        parity_calc[8] = data_in[8] ^ data_in[18] ^ data_in[28] ^ data_in[38] ^ data_in[48] ^ data_in[58] ^ data_in[68] ^ data_in[78] ^ data_in[88] ^ data_in[98] ^ data_in[108] ^ data_in[118];
        parity_calc[9] = data_in[9] ^ data_in[19] ^ data_in[29] ^ data_in[39] ^ data_in[49] ^ data_in[59] ^ data_in[69] ^ data_in[79] ^ data_in[89] ^ data_in[99] ^ data_in[109] ^ data_in[119];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0;
            valid_out <= 0;
        end else if (encode_en) begin
            // Systematic: Data (shifted) | Parity
            // Python: codeword = (data << P) | parity
            codeword_out <= {data_in, parity_calc};
            valid_out <= 1;
        end else if (decode_en) begin
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end

    wire [127:0] data_rx = codeword_in[137:10];
    wire [9:0] parity_rx = codeword_in[9:0];
    reg [9:0] expected_parity;
    always @(*) begin
        expected_parity[0] = data_rx[0] ^ data_rx[10] ^ data_rx[20] ^ data_rx[30] ^ data_rx[40] ^ data_rx[50] ^ data_rx[60] ^ data_rx[70] ^ data_rx[80] ^ data_rx[90] ^ data_rx[100] ^ data_rx[110] ^ data_rx[120];
        expected_parity[1] = data_rx[1] ^ data_rx[11] ^ data_rx[21] ^ data_rx[31] ^ data_rx[41] ^ data_rx[51] ^ data_rx[61] ^ data_rx[71] ^ data_rx[81] ^ data_rx[91] ^ data_rx[101] ^ data_rx[111] ^ data_rx[121];
        expected_parity[2] = data_rx[2] ^ data_rx[12] ^ data_rx[22] ^ data_rx[32] ^ data_rx[42] ^ data_rx[52] ^ data_rx[62] ^ data_rx[72] ^ data_rx[82] ^ data_rx[92] ^ data_rx[102] ^ data_rx[112] ^ data_rx[122];
        expected_parity[3] = data_rx[3] ^ data_rx[13] ^ data_rx[23] ^ data_rx[33] ^ data_rx[43] ^ data_rx[53] ^ data_rx[63] ^ data_rx[73] ^ data_rx[83] ^ data_rx[93] ^ data_rx[103] ^ data_rx[113] ^ data_rx[123];
        expected_parity[4] = data_rx[4] ^ data_rx[14] ^ data_rx[24] ^ data_rx[34] ^ data_rx[44] ^ data_rx[54] ^ data_rx[64] ^ data_rx[74] ^ data_rx[84] ^ data_rx[94] ^ data_rx[104] ^ data_rx[114] ^ data_rx[124];
        expected_parity[5] = data_rx[5] ^ data_rx[15] ^ data_rx[25] ^ data_rx[35] ^ data_rx[45] ^ data_rx[55] ^ data_rx[65] ^ data_rx[75] ^ data_rx[85] ^ data_rx[95] ^ data_rx[105] ^ data_rx[115] ^ data_rx[125];
        expected_parity[6] = data_rx[6] ^ data_rx[16] ^ data_rx[26] ^ data_rx[36] ^ data_rx[46] ^ data_rx[56] ^ data_rx[66] ^ data_rx[76] ^ data_rx[86] ^ data_rx[96] ^ data_rx[106] ^ data_rx[116] ^ data_rx[126];
        expected_parity[7] = data_rx[7] ^ data_rx[17] ^ data_rx[27] ^ data_rx[37] ^ data_rx[47] ^ data_rx[57] ^ data_rx[67] ^ data_rx[77] ^ data_rx[87] ^ data_rx[97] ^ data_rx[107] ^ data_rx[117] ^ data_rx[127];
        expected_parity[8] = data_rx[8] ^ data_rx[18] ^ data_rx[28] ^ data_rx[38] ^ data_rx[48] ^ data_rx[58] ^ data_rx[68] ^ data_rx[78] ^ data_rx[88] ^ data_rx[98] ^ data_rx[108] ^ data_rx[118];
        expected_parity[9] = data_rx[9] ^ data_rx[19] ^ data_rx[29] ^ data_rx[39] ^ data_rx[49] ^ data_rx[59] ^ data_rx[69] ^ data_rx[79] ^ data_rx[89] ^ data_rx[99] ^ data_rx[109] ^ data_rx[119];
    end
    wire [9:0] syndrome = expected_parity ^ parity_rx;
    reg [127:0] correction_mask;
    always @(*) begin
        correction_mask = 0;
        if (syndrome != 0) begin
            if (syndrome[0]) correction_mask[0] = 1'b1;
            if (syndrome[1]) correction_mask[1] = 1'b1;
            if (syndrome[2]) correction_mask[2] = 1'b1;
            if (syndrome[3]) correction_mask[3] = 1'b1;
            if (syndrome[4]) correction_mask[4] = 1'b1;
            if (syndrome[5]) correction_mask[5] = 1'b1;
            if (syndrome[6]) correction_mask[6] = 1'b1;
            if (syndrome[7]) correction_mask[7] = 1'b1;
            if (syndrome[8]) correction_mask[8] = 1'b1;
            if (syndrome[9]) correction_mask[9] = 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (decode_en) begin
            data_out <= data_rx ^ correction_mask;
            error_detected <= (syndrome != 0);
            error_corrected <= (syndrome != 0);
        end
    end
endmodule