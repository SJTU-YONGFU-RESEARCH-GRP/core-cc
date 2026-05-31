module repetition_ecc #(parameter DATA_WIDTH = 8, parameter REPETITION_FACTOR = 3) (
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

    // Local parameters
    localparam CODEWORD_WIDTH = DATA_WIDTH * REPETITION_FACTOR;
    
    // Encoding logic
    wire [CODEWORD_WIDTH-1:0] encoded_codeword;
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : encode_gen
            assign encoded_codeword[i*REPETITION_FACTOR +: REPETITION_FACTOR] = {REPETITION_FACTOR{data_in[i]}};
        end
    endgenerate
    
    // Decoding logic with majority voting
    // Decoding and Error Logic
    reg [DATA_WIDTH-1:0] decoded_data_reg;
    reg error_detected_comb;
    reg error_corrected_comb;
    
    wire [DATA_WIDTH-1:0] decoded_data;
    assign decoded_data = decoded_data_reg;

    always @(*) begin
        integer j, k;
        integer ones_count;
        
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
            
            // Majority vote
            if (ones_count > REPETITION_FACTOR/2) begin
                decoded_data_reg[j] = 1'b1;
            end else begin
                decoded_data_reg[j] = 1'b0;
            end
            
            // Error detection (if not all bits are same)
            if (ones_count != 0 && ones_count != REPETITION_FACTOR) begin
                // For Repetition(3), any disagreement is a corrected error
                // We don't really have "detected but uncorrected" unless we can't decide majority
                // But for odd repetition factor, we always correct.
                // So we mark it as corrected.
                error_corrected_comb = 1'b1;
            end
        end
    end

    // Synchronous logic
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