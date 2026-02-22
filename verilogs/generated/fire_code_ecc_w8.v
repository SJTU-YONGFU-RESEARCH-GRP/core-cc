module fire_code_ecc_w8 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [7:0] data_in,
    input  wire [13:0] codeword_in,
    output reg  [13:0] codeword_out,
    output reg  [7:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    reg [5:0] parity_calc;
    always @(*) begin
        parity_calc[0] = data_in[0] ^ data_in[6];
        parity_calc[1] = data_in[1] ^ data_in[7];
        parity_calc[2] = data_in[2];
        parity_calc[3] = data_in[3];
        parity_calc[4] = data_in[4];
        parity_calc[5] = data_in[5];
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

    wire [7:0] data_rx = codeword_in[13:6];
    wire [5:0] parity_rx = codeword_in[5:0];
    reg [5:0] expected_parity;
    always @(*) begin
        expected_parity[0] = data_rx[0] ^ data_rx[6];
        expected_parity[1] = data_rx[1] ^ data_rx[7];
        expected_parity[2] = data_rx[2];
        expected_parity[3] = data_rx[3];
        expected_parity[4] = data_rx[4];
        expected_parity[5] = data_rx[5];
    end
    wire [5:0] syndrome = expected_parity ^ parity_rx;
    reg [7:0] correction_mask;
    always @(*) begin
        correction_mask = 0;
        if (syndrome != 0) begin
            if (syndrome[0]) correction_mask[0] = 1'b1;
            if (syndrome[1]) correction_mask[1] = 1'b1;
            if (syndrome[2]) correction_mask[2] = 1'b1;
            if (syndrome[3]) correction_mask[3] = 1'b1;
            if (syndrome[4]) correction_mask[4] = 1'b1;
            if (syndrome[5]) correction_mask[5] = 1'b1;
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