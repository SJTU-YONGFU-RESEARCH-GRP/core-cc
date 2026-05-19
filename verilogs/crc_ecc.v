// CRC ECC Module - detection only (no correction)
// Codeword layout matches crc_ecc_tb.cpp / src/crc_ecc.py:
//   bits [DATA_WIDTH-1:0] = data, bits [CODEWORD_WIDTH-1:DATA_WIDTH] = CRC
module crc_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CRC_WIDTH = 8
) (
    input  wire                            clk,
    input  wire                            rst_n,
    input  wire                            encode_en,
    input  wire                            decode_en,
    input  wire [DATA_WIDTH-1:0]           data_in,
    input  wire [DATA_WIDTH+CRC_WIDTH-1:0] codeword_in,
    output reg  [DATA_WIDTH+CRC_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]           data_out,
    output reg                             error_detected,
    output reg                             error_corrected,
    output reg                             valid_out
);

    localparam CODEWORD_WIDTH = DATA_WIDTH + CRC_WIDTH;
    localparam [CRC_WIDTH-1:0] CRC_POLY = 8'h07;
    localparam [CRC_WIDTH-1:0] CRC_INIT = 8'h00;

    function [CRC_WIDTH-1:0] calculate_crc;
        input [DATA_WIDTH-1:0] data;
        integer i, j;
        reg [CRC_WIDTH-1:0] crc;
        begin
            crc = CRC_INIT;
            // Matches crc_ecc_tb.cpp / src/crc_ecc.py bit-serial model
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                if (data[i]) begin
                    crc = crc ^ 8'h80;
                end
                for (j = 0; j < CRC_WIDTH; j = j + 1) begin
                    if (crc[CRC_WIDTH-1]) begin
                        crc = (crc << 1) ^ CRC_POLY;
                    end else begin
                        crc = (crc << 1);
                    end
                end
            end
            calculate_crc = crc;
        end
    endfunction

    wire [CRC_WIDTH-1:0] calculated_crc;
    wire [CODEWORD_WIDTH-1:0] encoded_codeword;
    wire [DATA_WIDTH-1:0] extracted_data;
    wire [CRC_WIDTH-1:0] received_crc;
    wire [CRC_WIDTH-1:0] expected_crc_for_rx;
    wire crc_mismatch;

    assign calculated_crc = calculate_crc(data_in);
    assign encoded_codeword = {calculated_crc, data_in};

    assign extracted_data = codeword_in[DATA_WIDTH-1:0];
    assign received_crc = codeword_in[CODEWORD_WIDTH-1:DATA_WIDTH];
    assign expected_crc_for_rx = calculate_crc(extracted_data);
    assign crc_mismatch = (expected_crc_for_rx != received_crc);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out    <= {CODEWORD_WIDTH{1'b0}};
            data_out        <= {DATA_WIDTH{1'b0}};
            error_detected  <= 1'b0;
            error_corrected <= 1'b0;
            valid_out       <= 1'b0;
        end else if (encode_en) begin
            codeword_out    <= encoded_codeword;
            data_out        <= {DATA_WIDTH{1'b0}};
            error_detected  <= 1'b0;
            error_corrected <= 1'b0;
            valid_out       <= 1'b1;
        end else if (decode_en) begin
            codeword_out    <= {CODEWORD_WIDTH{1'b0}};
            data_out        <= extracted_data;
            error_detected  <= crc_mismatch;
            error_corrected <= 1'b0;
            valid_out       <= 1'b1;
        end else begin
            valid_out       <= 1'b0;
        end
    end

endmodule
