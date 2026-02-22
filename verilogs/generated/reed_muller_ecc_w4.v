module reed_muller_ecc_w4 (
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

    // Encoder Logic
    reg [7:0] encoded_data;
    always @(*) begin
        encoded_data[3:0] = data_in;
        encoded_data[4] = data_in[0] ^ data_in[2];
        encoded_data[5] = data_in[1] ^ data_in[3];
        encoded_data[6] = data_in[0] ^ data_in[2];
        encoded_data[7] = data_in[1] ^ data_in[3];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0;
            valid_out <= 0;
        end else if (encode_en) begin
            codeword_out <= encoded_data;
            valid_out <= 1;
        end else if (decode_en) begin
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end

    // Decoder Logic
    wire [3:0] syndrome;
    assign syndrome[0] = codeword_in[4] ^ (codeword_in[0] ^ codeword_in[2]);
    assign syndrome[1] = codeword_in[5] ^ (codeword_in[1] ^ codeword_in[3]);
    assign syndrome[2] = codeword_in[6] ^ (codeword_in[0] ^ codeword_in[2]);
    assign syndrome[3] = codeword_in[7] ^ (codeword_in[1] ^ codeword_in[3]);

    reg [3:0] corrected_data;
    reg err_det, err_corr;
    always @(*) begin
        corrected_data = codeword_in[3:0];
        err_det = (|syndrome);
        err_corr = 0;

        if (err_det) begin
            if (syndrome == 4'd5) begin
                corrected_data[0] = ~codeword_in[0];
                err_corr = 1;
            end
            if (syndrome == 4'd10) begin
                corrected_data[1] = ~codeword_in[1];
                err_corr = 1;
            end
            if (syndrome == 4'd5) begin
                corrected_data[2] = ~codeword_in[2];
                err_corr = 1;
            end
            if (syndrome == 4'd10) begin
                corrected_data[3] = ~codeword_in[3];
                err_corr = 1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (decode_en) begin
            data_out <= corrected_data;
            error_detected <= err_det;
            error_corrected <= err_corr;
        end
    end
endmodule