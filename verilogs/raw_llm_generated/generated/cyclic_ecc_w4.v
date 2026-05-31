module cyclic_ecc_w4 (
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

    wire [3:0] crc_out;
    assign crc_out[0] = data_in[0];
    assign crc_out[1] = 1'b0;
    assign crc_out[2] = data_in[0] ^ data_in[1];
    assign crc_out[3] = 1'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0;
            valid_out <= 0;
        end else if (encode_en) begin
            // Systematic: Data | CRC
            codeword_out <= {data_in, crc_out};
            valid_out <= 1;
        end else if (decode_en) begin
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end

    wire [3:0] crc_recalc;
    wire [3:0] data_rx = codeword_in[7:4];
    wire [3:0] crc_rx = codeword_in[3:0];
    assign crc_recalc[0] = data_rx[0];
    assign crc_recalc[1] = 1'b0;
    assign crc_recalc[2] = data_rx[0] ^ data_rx[1];
    assign crc_recalc[3] = 1'b0;
    wire [3:0] syndrome = crc_recalc ^ crc_rx;
    reg [7:0] error_pattern;
    always @(*) begin
        case(syndrome)
            4'h0: error_pattern = 0;
            4'h1: error_pattern = 8'd1 << 0;
            4'h2: error_pattern = 8'd1 << 1;
            4'h4: error_pattern = 8'd1 << 2;
            4'h8: error_pattern = 8'd1 << 3;
            4'h3: error_pattern = 8'd1 << 4;
            4'h6: error_pattern = 8'd1 << 5;
            4'hc: error_pattern = 8'd1 << 6;
            4'hb: error_pattern = 8'd1 << 7;
            default: error_pattern = 0; // Uncorrectable (Multi-bit)
        endcase
    end

    wire [7:0] corrected_cw = codeword_in ^ error_pattern;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (decode_en) begin
            data_out <= corrected_cw[7:4];
            error_detected <= (syndrome != 0);
            error_corrected <= (syndrome != 0) && (error_pattern != 0);
        end
    end
endmodule