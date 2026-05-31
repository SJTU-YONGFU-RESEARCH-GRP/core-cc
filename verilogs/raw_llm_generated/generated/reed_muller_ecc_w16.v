module reed_muller_ecc_w16 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [15:0] data_in,
    input  wire [31:0] codeword_in,
    output reg  [31:0] codeword_out,
    output reg  [15:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    // Encoder Logic
    reg [31:0] encoded_data;
    always @(*) begin
        encoded_data[15:0] = data_in;
        encoded_data[16] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[17] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
        encoded_data[18] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[19] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
        encoded_data[20] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[21] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
        encoded_data[22] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[23] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
        encoded_data[24] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[25] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
        encoded_data[26] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[27] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
        encoded_data[28] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[29] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
        encoded_data[30] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
        encoded_data[31] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15];
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
    wire [15:0] syndrome;
    assign syndrome[0] = codeword_in[16] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[1] = codeword_in[17] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);
    assign syndrome[2] = codeword_in[18] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[3] = codeword_in[19] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);
    assign syndrome[4] = codeword_in[20] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[5] = codeword_in[21] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);
    assign syndrome[6] = codeword_in[22] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[7] = codeword_in[23] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);
    assign syndrome[8] = codeword_in[24] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[9] = codeword_in[25] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);
    assign syndrome[10] = codeword_in[26] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[11] = codeword_in[27] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);
    assign syndrome[12] = codeword_in[28] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[13] = codeword_in[29] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);
    assign syndrome[14] = codeword_in[30] ^ (codeword_in[0] ^ codeword_in[2] ^ codeword_in[4] ^ codeword_in[6] ^ codeword_in[8] ^ codeword_in[10] ^ codeword_in[12] ^ codeword_in[14]);
    assign syndrome[15] = codeword_in[31] ^ (codeword_in[1] ^ codeword_in[3] ^ codeword_in[5] ^ codeword_in[7] ^ codeword_in[9] ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15]);

    reg [15:0] corrected_data;
    reg err_det, err_corr;
    always @(*) begin
        corrected_data = codeword_in[15:0];
        err_det = (|syndrome);
        err_corr = 0;

        if (err_det) begin
            if (syndrome == 16'd21845) begin
                corrected_data[0] = ~codeword_in[0];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[1] = ~codeword_in[1];
                err_corr = 1;
            end
            if (syndrome == 16'd21845) begin
                corrected_data[2] = ~codeword_in[2];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[3] = ~codeword_in[3];
                err_corr = 1;
            end
            if (syndrome == 16'd21845) begin
                corrected_data[4] = ~codeword_in[4];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[5] = ~codeword_in[5];
                err_corr = 1;
            end
            if (syndrome == 16'd21845) begin
                corrected_data[6] = ~codeword_in[6];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[7] = ~codeword_in[7];
                err_corr = 1;
            end
            if (syndrome == 16'd21845) begin
                corrected_data[8] = ~codeword_in[8];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[9] = ~codeword_in[9];
                err_corr = 1;
            end
            if (syndrome == 16'd21845) begin
                corrected_data[10] = ~codeword_in[10];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[11] = ~codeword_in[11];
                err_corr = 1;
            end
            if (syndrome == 16'd21845) begin
                corrected_data[12] = ~codeword_in[12];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[13] = ~codeword_in[13];
                err_corr = 1;
            end
            if (syndrome == 16'd21845) begin
                corrected_data[14] = ~codeword_in[14];
                err_corr = 1;
            end
            if (syndrome == 16'd43690) begin
                corrected_data[15] = ~codeword_in[15];
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