module fire_code_ecc_w64 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [63:0] data_in,
    input  wire [73:0] codeword_in,
    output reg  [73:0] codeword_out,
    output reg  [63:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    reg [9:0] parity_calc;
    always @(*) begin
        parity_calc[0] = data_in[0] ^ data_in[10] ^ data_in[20] ^ data_in[30] ^ data_in[40] ^ data_in[50] ^ data_in[60];
        parity_calc[1] = data_in[1] ^ data_in[11] ^ data_in[21] ^ data_in[31] ^ data_in[41] ^ data_in[51] ^ data_in[61];
        parity_calc[2] = data_in[2] ^ data_in[12] ^ data_in[22] ^ data_in[32] ^ data_in[42] ^ data_in[52] ^ data_in[62];
        parity_calc[3] = data_in[3] ^ data_in[13] ^ data_in[23] ^ data_in[33] ^ data_in[43] ^ data_in[53] ^ data_in[63];
        parity_calc[4] = data_in[4] ^ data_in[14] ^ data_in[24] ^ data_in[34] ^ data_in[44] ^ data_in[54];
        parity_calc[5] = data_in[5] ^ data_in[15] ^ data_in[25] ^ data_in[35] ^ data_in[45] ^ data_in[55];
        parity_calc[6] = data_in[6] ^ data_in[16] ^ data_in[26] ^ data_in[36] ^ data_in[46] ^ data_in[56];
        parity_calc[7] = data_in[7] ^ data_in[17] ^ data_in[27] ^ data_in[37] ^ data_in[47] ^ data_in[57];
        parity_calc[8] = data_in[8] ^ data_in[18] ^ data_in[28] ^ data_in[38] ^ data_in[48] ^ data_in[58];
        parity_calc[9] = data_in[9] ^ data_in[19] ^ data_in[29] ^ data_in[39] ^ data_in[49] ^ data_in[59];
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

    wire [63:0] data_rx = codeword_in[73:10];
    wire [9:0] parity_rx = codeword_in[9:0];
    reg [9:0] expected_parity;
    always @(*) begin
        expected_parity[0] = data_rx[0] ^ data_rx[10] ^ data_rx[20] ^ data_rx[30] ^ data_rx[40] ^ data_rx[50] ^ data_rx[60];
        expected_parity[1] = data_rx[1] ^ data_rx[11] ^ data_rx[21] ^ data_rx[31] ^ data_rx[41] ^ data_rx[51] ^ data_rx[61];
        expected_parity[2] = data_rx[2] ^ data_rx[12] ^ data_rx[22] ^ data_rx[32] ^ data_rx[42] ^ data_rx[52] ^ data_rx[62];
        expected_parity[3] = data_rx[3] ^ data_rx[13] ^ data_rx[23] ^ data_rx[33] ^ data_rx[43] ^ data_rx[53] ^ data_rx[63];
        expected_parity[4] = data_rx[4] ^ data_rx[14] ^ data_rx[24] ^ data_rx[34] ^ data_rx[44] ^ data_rx[54];
        expected_parity[5] = data_rx[5] ^ data_rx[15] ^ data_rx[25] ^ data_rx[35] ^ data_rx[45] ^ data_rx[55];
        expected_parity[6] = data_rx[6] ^ data_rx[16] ^ data_rx[26] ^ data_rx[36] ^ data_rx[46] ^ data_rx[56];
        expected_parity[7] = data_rx[7] ^ data_rx[17] ^ data_rx[27] ^ data_rx[37] ^ data_rx[47] ^ data_rx[57];
        expected_parity[8] = data_rx[8] ^ data_rx[18] ^ data_rx[28] ^ data_rx[38] ^ data_rx[48] ^ data_rx[58];
        expected_parity[9] = data_rx[9] ^ data_rx[19] ^ data_rx[29] ^ data_rx[39] ^ data_rx[49] ^ data_rx[59];
    end
    wire [9:0] syndrome = expected_parity ^ parity_rx;
    reg [63:0] correction_mask;
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