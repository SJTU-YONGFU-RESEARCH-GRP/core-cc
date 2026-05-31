// Repetition (N-fold) ECC — encode by bit replication, decode by majority vote.
// Codeword layout: for each data bit j, replicas occupy
//   codeword[j*REPETITION_FACTOR +: REPETITION_FACTOR] (bit-major).
// Matches Python RepetitionECC in the universal-driver oracle.
//
// error_detected:  any bit group has mixed 0/1 replicas.
// error_corrected: detected and majority is decisive (no even-RF tie).
//   RF=3: corrects one wrong replica per bit; two wrong replicas may miscorrect.
//   RF=4: 3:1 votes are corrected; 2:2 ties set detected only.

module repetition_ecc #(
    parameter DATA_WIDTH = 8,
    parameter REPETITION_FACTOR = 3
) (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire [DATA_WIDTH*REPETITION_FACTOR-1:0] codeword_in,
    output reg  [DATA_WIDTH*REPETITION_FACTOR-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);

    localparam CODEWORD_WIDTH = DATA_WIDTH * REPETITION_FACTOR;

    // ==========================================
    // Encoder — replicate each data bit RF times
    // ==========================================
    wire [CODEWORD_WIDTH-1:0] encoded_codeword;
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : encode_gen
            assign encoded_codeword[i*REPETITION_FACTOR +: REPETITION_FACTOR] =
                {REPETITION_FACTOR{data_in[i]}};
        end
    endgenerate

    // ==========================================
    // Decoder — per-bit majority vote (combinational)
    // ==========================================
    reg [DATA_WIDTH-1:0] decoded_data_reg;
    reg error_detected_comb;
    reg error_corrected_comb;

    wire [DATA_WIDTH-1:0] decoded_data;
    assign decoded_data = decoded_data_reg;

    always @(*) begin
        integer j, k;
        integer ones_count;
        reg is_tie;

        decoded_data_reg = 0;
        error_detected_comb = 0;
        error_corrected_comb = 0;

        for (j = 0; j < DATA_WIDTH; j = j + 1) begin
            ones_count = 0;
            for (k = 0; k < REPETITION_FACTOR; k = k + 1) begin
                if (codeword_in[j*REPETITION_FACTOR + k]) begin
                    ones_count = ones_count + 1;
                end
            end

            // Majority: more than half of the replicas are 1
            if (ones_count > REPETITION_FACTOR/2) begin
                decoded_data_reg[j] = 1'b1;
            end else begin
                decoded_data_reg[j] = 1'b0;
            end

            // Mixed replicas => error; corrected only when vote is not tied
            if (ones_count != 0 && ones_count != REPETITION_FACTOR) begin
                error_detected_comb = 1'b1;

                is_tie = ((REPETITION_FACTOR % 2 == 0) &&
                          (ones_count == REPETITION_FACTOR/2));

                if (!is_tie) begin
                    error_corrected_comb = 1'b1;
                end
            end
        end
    end

    // ==========================================
    // Register outputs on encode_en / decode_en
    // ==========================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {CODEWORD_WIDTH{1'b0}};
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (encode_en) begin
                codeword_out <= encoded_codeword;
                data_out <= {DATA_WIDTH{1'b0}};
                error_detected <= 1'b0;
                error_corrected <= 1'b0;
                valid_out <= 1'b1;
            end else if (decode_en) begin
                codeword_out <= {CODEWORD_WIDTH{1'b0}};
                data_out <= decoded_data;
                error_detected <= error_detected_comb;
                error_corrected <= error_corrected_comb;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule
