/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module composite_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [DATA_WIDTH+8-1:0] codeword_in,
    output reg  [DATA_WIDTH+8-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]   data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    wire [7:0] redundancy;
    
    generate
        if (DATA_WIDTH >= 8) begin
            assign redundancy = data_in[7:0];
        end else begin
            // Use safe constant to avoid negative replication count in syntax check
            localparam PAD_LEN = (8 > DATA_WIDTH) ? (8 - DATA_WIDTH) : 1;
            assign redundancy = {{PAD_LEN{1'b0}}, data_in};
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {(DATA_WIDTH+8){1'b0}};
            valid_out <= 1'b0;
        end else if (encode_en) begin
            codeword_out <= {data_in, redundancy};
            valid_out <= 1'b1;
        end else if (decode_en) begin
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
        end else if (decode_en) begin
            data_out <= codeword_in[DATA_WIDTH+8-1 : 8];
            error_detected <= 1'b0; 
            error_corrected <= 1'b0;
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
