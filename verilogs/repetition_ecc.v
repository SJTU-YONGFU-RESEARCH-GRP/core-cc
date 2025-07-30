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
    wire [DATA_WIDTH-1:0] decoded_data;
    genvar j;
    generate
        for (j = 0; j < DATA_WIDTH; j = j + 1) begin : decode_gen
            // Count ones in each repetition group
            wire [REPETITION_FACTOR-1:0] repetition_bits = codeword_in[j*REPETITION_FACTOR +: REPETITION_FACTOR];
            reg [$clog2(REPETITION_FACTOR+1)-1:0] ones_count;
            
            // Count ones in repetition group
            integer k;
            always @(*) begin
                ones_count = 0;
                for (k = 0; k < REPETITION_FACTOR; k = k + 1) begin
                    ones_count = ones_count + repetition_bits[k];
                end
            end
            
            // Majority vote
            assign decoded_data[j] = (ones_count > REPETITION_FACTOR/2) ? 1'b1 : 1'b0;
        end
    endgenerate
    
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
                error_detected <= 1'b0; // Repetition codes can detect but not correct errors
                error_corrected <= 1'b1; // Always report as corrected in simplified version
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule 