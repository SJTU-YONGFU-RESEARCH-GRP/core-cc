module fire_code_ecc_w4 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [3:0] data_in,
    input  wire [7:0] codeword_in,
    output reg  [7:0] codeword_out,
    output reg  [3:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    reg [3:0] parity_calc;
    always @(*) begin
        parity_calc[0] = data_in[0];
        parity_calc[1] = data_in[1];
        parity_calc[2] = data_in[2];
        parity_calc[3] = data_in[3];
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

    wire [3:0] data_rx = codeword_in[7:4];
    wire [3:0] parity_rx = codeword_in[3:0];
    reg [3:0] expected_parity;
    always @(*) begin
        expected_parity[0] = data_rx[0];
        expected_parity[1] = data_rx[1];
        expected_parity[2] = data_rx[2];
        expected_parity[3] = data_rx[3];
    end
    wire [3:0] syndrome = expected_parity ^ parity_rx;
    reg [3:0] correction_mask;
    always @(*) begin
        correction_mask = 0;
        if (syndrome != 0) begin
            if (syndrome[0]) correction_mask[0] = 1'b1;
            if (syndrome[1]) correction_mask[1] = 1'b1;
            if (syndrome[2]) correction_mask[2] = 1'b1;
            if (syndrome[3]) correction_mask[3] = 1'b1;
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