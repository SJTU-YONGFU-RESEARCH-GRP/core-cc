module fire_code_ecc_w16 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [15:0] data_in,
    input  wire [23:0] codeword_in,
    output reg  [23:0] codeword_out,
    output reg  [15:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    reg [7:0] parity_calc;
    always @(*) begin
        parity_calc[0] = data_in[0] ^ data_in[8];
        parity_calc[1] = data_in[1] ^ data_in[9];
        parity_calc[2] = data_in[2] ^ data_in[10];
        parity_calc[3] = data_in[3] ^ data_in[11];
        parity_calc[4] = data_in[4] ^ data_in[12];
        parity_calc[5] = data_in[5] ^ data_in[13];
        parity_calc[6] = data_in[6] ^ data_in[14];
        parity_calc[7] = data_in[7] ^ data_in[15];
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

    wire [15:0] data_rx = codeword_in[23:8];
    wire [7:0] parity_rx = codeword_in[7:0];
    reg [7:0] expected_parity;
    always @(*) begin
        expected_parity[0] = data_rx[0] ^ data_rx[8];
        expected_parity[1] = data_rx[1] ^ data_rx[9];
        expected_parity[2] = data_rx[2] ^ data_rx[10];
        expected_parity[3] = data_rx[3] ^ data_rx[11];
        expected_parity[4] = data_rx[4] ^ data_rx[12];
        expected_parity[5] = data_rx[5] ^ data_rx[13];
        expected_parity[6] = data_rx[6] ^ data_rx[14];
        expected_parity[7] = data_rx[7] ^ data_rx[15];
    end
    wire [7:0] syndrome = expected_parity ^ parity_rx;
    reg [15:0] correction_mask;
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