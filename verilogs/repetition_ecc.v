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
            
            // 多数表决逻辑
            if (ones_count > REPETITION_FACTOR/2) begin
                decoded_data_reg[j] = 1'b1;
            end else begin
                decoded_data_reg[j] = 1'b0;
            end
            
            // 错误检测与纠正逻辑 (修复了 AI 的遗漏和盲区)
            if (ones_count != 0 && ones_count != REPETITION_FACTOR) begin
                // 只要票数不统一，绝对是检测到了错误
                error_detected_comb = 1'b1; 
                
                // 判断是否是死局 (Tie)，比如 4次重复里出现 2个1和2个0
                is_tie = ((REPETITION_FACTOR % 2 == 0) && (ones_count == REPETITION_FACTOR/2));
                
                if (!is_tie) begin
                    // 只要不是死局，多数表决一定生效了，算是成功纠正
                    error_corrected_comb = 1'b1;
                end
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