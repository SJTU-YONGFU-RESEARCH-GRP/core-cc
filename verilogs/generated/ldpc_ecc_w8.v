// Generated ldpc_ecc_w8 - Do not edit manually
module ldpc_ecc_w8 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [7:0] data_in,
    input  wire [15:0] codeword_in,
    output reg  [15:0] codeword_out,
    output reg  [7:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    reg [3:0] state;
    localparam IDLE = 0, CALC_SYNDROME = 1, FLIP_BITS = 2, CHECK_DONE = 3, FINISH = 4;
    reg [4:0] iter_count;
    localparam MAX_ITER = 10;
    
    reg [15:0] current_cw;
    wire [7:0] syndrome;
    wire has_error;
    wire [7:0] parity_out;
    assign parity_out[0] = data_in[0] ^ data_in[4] ^ data_in[6] ^ data_in[7];
    assign parity_out[1] = data_in[4] ^ data_in[5] ^ data_in[7];
    assign parity_out[2] = data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5];
    assign parity_out[3] = data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5];
    assign parity_out[4] = data_in[5];
    assign parity_out[5] = data_in[2];
    assign parity_out[6] = data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[7];
    assign parity_out[7] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];
    assign syndrome[0] = current_cw[0] ^ current_cw[4] ^ current_cw[6] ^ current_cw[7] ^ current_cw[8];
    assign syndrome[1] = current_cw[4] ^ current_cw[5] ^ current_cw[7] ^ current_cw[9];
    assign syndrome[2] = current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[10];
    assign syndrome[3] = current_cw[1] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[11];
    assign syndrome[4] = current_cw[5] ^ current_cw[12];
    assign syndrome[5] = current_cw[2] ^ current_cw[13];
    assign syndrome[6] = current_cw[1] ^ current_cw[2] ^ current_cw[4] ^ current_cw[6] ^ current_cw[7] ^ current_cw[14];
    assign syndrome[7] = current_cw[0] ^ current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[6] ^ current_cw[7] ^ current_cw[15];
    assign has_error = |syndrome;
    wire [1:0] sum_0 = { 1'd0, syndrome[0] } + { 1'd0, syndrome[7] };
    wire flip_0 = (sum_0 >= 2'd1);
    wire [1:0] sum_1 = { 1'd0, syndrome[3] } + { 1'd0, syndrome[6] } + { 1'd0, syndrome[7] };
    wire flip_1 = (sum_1 >= 2'd2);
    wire [2:0] sum_2 = { 2'd0, syndrome[2] } + { 2'd0, syndrome[5] } + { 2'd0, syndrome[6] } + { 2'd0, syndrome[7] };
    wire flip_2 = (sum_2 >= 3'd2);
    wire [1:0] sum_3 = { 1'd0, syndrome[2] } + { 1'd0, syndrome[3] } + { 1'd0, syndrome[7] };
    wire flip_3 = (sum_3 >= 2'd2);
    wire [2:0] sum_4 = { 2'd0, syndrome[0] } + { 2'd0, syndrome[1] } + { 2'd0, syndrome[2] } + { 2'd0, syndrome[3] } + { 2'd0, syndrome[6] } + { 2'd0, syndrome[7] };
    wire flip_4 = (sum_4 >= 3'd3);
    wire [2:0] sum_5 = { 2'd0, syndrome[1] } + { 2'd0, syndrome[2] } + { 2'd0, syndrome[3] } + { 2'd0, syndrome[4] } + { 2'd0, syndrome[7] };
    wire flip_5 = (sum_5 >= 3'd3);
    wire [1:0] sum_6 = { 1'd0, syndrome[0] } + { 1'd0, syndrome[6] } + { 1'd0, syndrome[7] };
    wire flip_6 = (sum_6 >= 2'd2);
    wire [2:0] sum_7 = { 2'd0, syndrome[0] } + { 2'd0, syndrome[1] } + { 2'd0, syndrome[6] } + { 2'd0, syndrome[7] };
    wire flip_7 = (sum_7 >= 3'd2);
    wire [0:0] sum_8 = syndrome[0];
    wire flip_8 = (sum_8 >= 1'd1);
    wire [0:0] sum_9 = syndrome[1];
    wire flip_9 = (sum_9 >= 1'd1);
    wire [0:0] sum_10 = syndrome[2];
    wire flip_10 = (sum_10 >= 1'd1);
    wire [0:0] sum_11 = syndrome[3];
    wire flip_11 = (sum_11 >= 1'd1);
    wire [0:0] sum_12 = syndrome[4];
    wire flip_12 = (sum_12 >= 1'd1);
    wire [0:0] sum_13 = syndrome[5];
    wire flip_13 = (sum_13 >= 1'd1);
    wire [0:0] sum_14 = syndrome[6];
    wire flip_14 = (sum_14 >= 1'd1);
    wire [0:0] sum_15 = syndrome[7];
    wire flip_15 = (sum_15 >= 1'd1);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            current_cw <= 0;
            iter_count <= 0;
            codeword_out <= 0;
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
            valid_out <= 0;
        end else begin
            // Default valid_out to 0 unless pulsed
            valid_out <= 0; 
            
            if (encode_en) begin
                codeword_out <= {parity_out, data_in};
                valid_out <= 1'b1;
            end
            
            else if (decode_en && state == IDLE) begin
                state <= CALC_SYNDROME;
                current_cw <= codeword_in;
                iter_count <= 0;
            end
            
            else begin
                case (state)
                    CALC_SYNDROME: begin
                        if (!has_error) begin
                             state <= FINISH;
                        end else if (iter_count == MAX_ITER) begin
                             state <= FINISH;
                        end else begin
                             state <= FLIP_BITS;
                        end
                    end
                    FLIP_BITS: begin
                        // Apply flips
                        current_cw[0] <= current_cw[0] ^ flip_0;
                        current_cw[1] <= current_cw[1] ^ flip_1;
                        current_cw[2] <= current_cw[2] ^ flip_2;
                        current_cw[3] <= current_cw[3] ^ flip_3;
                        current_cw[4] <= current_cw[4] ^ flip_4;
                        current_cw[5] <= current_cw[5] ^ flip_5;
                        current_cw[6] <= current_cw[6] ^ flip_6;
                        current_cw[7] <= current_cw[7] ^ flip_7;
                        current_cw[8] <= current_cw[8] ^ flip_8;
                        current_cw[9] <= current_cw[9] ^ flip_9;
                        current_cw[10] <= current_cw[10] ^ flip_10;
                        current_cw[11] <= current_cw[11] ^ flip_11;
                        current_cw[12] <= current_cw[12] ^ flip_12;
                        current_cw[13] <= current_cw[13] ^ flip_13;
                        current_cw[14] <= current_cw[14] ^ flip_14;
                        current_cw[15] <= current_cw[15] ^ flip_15;
                        iter_count <= iter_count + 1;
                        state <= CALC_SYNDROME;
                    end
                    FINISH: begin
                        data_out <= current_cw[7:0];
                        error_detected <= has_error;
                        error_corrected <= (has_error == 0); // Approx
                        valid_out <= 1'b1;
                        state <= IDLE;
                    end
                    default: state <= IDLE;
                endcase
            end
        end
    end
endmodule