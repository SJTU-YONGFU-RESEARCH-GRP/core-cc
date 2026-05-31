// Generated ldpc_ecc_w16 - Do not edit manually
module ldpc_ecc_w16 (
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
    reg [3:0] state;
    localparam IDLE = 0, CALC_SYNDROME = 1, FLIP_BITS = 2, CHECK_DONE = 3, FINISH = 4;
    reg [4:0] iter_count;
    localparam MAX_ITER = 10;
    
    reg [31:0] current_cw;
    wire [15:0] syndrome;
    wire has_error;
    wire [15:0] parity_out;
    assign parity_out[0] = data_in[8] ^ data_in[13] ^ data_in[14];
    assign parity_out[1] = data_in[0] ^ data_in[7] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    assign parity_out[2] = data_in[0] ^ data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    assign parity_out[3] = data_in[0] ^ data_in[1] ^ data_in[7] ^ data_in[11] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    assign parity_out[4] = data_in[0] ^ data_in[5] ^ data_in[7] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[15];
    assign parity_out[5] = data_in[0] ^ data_in[5] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[15];
    assign parity_out[6] = data_in[0] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[10] ^ data_in[11];
    assign parity_out[7] = data_in[2] ^ data_in[4] ^ data_in[7] ^ data_in[10] ^ data_in[11];
    assign parity_out[8] = data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[11];
    assign parity_out[9] = data_in[4] ^ data_in[7] ^ data_in[11];
    assign parity_out[10] = data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[11] ^ data_in[14];
    assign parity_out[11] = data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[13] ^ data_in[14];
    assign parity_out[12] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[13] ^ data_in[14];
    assign parity_out[13] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    assign parity_out[14] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    assign parity_out[15] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    assign syndrome[0] = current_cw[8] ^ current_cw[13] ^ current_cw[14] ^ current_cw[16];
    assign syndrome[1] = current_cw[0] ^ current_cw[7] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[17];
    assign syndrome[2] = current_cw[0] ^ current_cw[3] ^ current_cw[6] ^ current_cw[7] ^ current_cw[11] ^ current_cw[12] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[18];
    assign syndrome[3] = current_cw[0] ^ current_cw[1] ^ current_cw[7] ^ current_cw[11] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[19];
    assign syndrome[4] = current_cw[0] ^ current_cw[5] ^ current_cw[7] ^ current_cw[10] ^ current_cw[11] ^ current_cw[14] ^ current_cw[15] ^ current_cw[20];
    assign syndrome[5] = current_cw[0] ^ current_cw[5] ^ current_cw[10] ^ current_cw[11] ^ current_cw[14] ^ current_cw[15] ^ current_cw[21];
    assign syndrome[6] = current_cw[0] ^ current_cw[4] ^ current_cw[5] ^ current_cw[7] ^ current_cw[10] ^ current_cw[11] ^ current_cw[22];
    assign syndrome[7] = current_cw[2] ^ current_cw[4] ^ current_cw[7] ^ current_cw[10] ^ current_cw[11] ^ current_cw[23];
    assign syndrome[8] = current_cw[4] ^ current_cw[7] ^ current_cw[9] ^ current_cw[11] ^ current_cw[24];
    assign syndrome[9] = current_cw[4] ^ current_cw[7] ^ current_cw[11] ^ current_cw[25];
    assign syndrome[10] = current_cw[4] ^ current_cw[5] ^ current_cw[7] ^ current_cw[11] ^ current_cw[14] ^ current_cw[26];
    assign syndrome[11] = current_cw[1] ^ current_cw[3] ^ current_cw[5] ^ current_cw[7] ^ current_cw[13] ^ current_cw[14] ^ current_cw[27];
    assign syndrome[12] = current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[5] ^ current_cw[7] ^ current_cw[8] ^ current_cw[13] ^ current_cw[14] ^ current_cw[28];
    assign syndrome[13] = current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[7] ^ current_cw[8] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[29];
    assign syndrome[14] = current_cw[0] ^ current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[7] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[12] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[30];
    assign syndrome[15] = current_cw[0] ^ current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[6] ^ current_cw[7] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[12] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[31];
    assign has_error = |syndrome;
    wire [3:0] sum_0 = { 3'd0, syndrome[1] } + { 3'd0, syndrome[2] } + { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_0 = (sum_0 >= 4'd4);
    wire [2:0] sum_1 = { 2'd0, syndrome[3] } + { 2'd0, syndrome[11] } + { 2'd0, syndrome[12] } + { 2'd0, syndrome[13] } + { 2'd0, syndrome[14] } + { 2'd0, syndrome[15] };
    wire flip_1 = (sum_1 >= 3'd3);
    wire [2:0] sum_2 = { 2'd0, syndrome[7] } + { 2'd0, syndrome[12] } + { 2'd0, syndrome[13] } + { 2'd0, syndrome[14] } + { 2'd0, syndrome[15] };
    wire flip_2 = (sum_2 >= 3'd3);
    wire [2:0] sum_3 = { 2'd0, syndrome[2] } + { 2'd0, syndrome[11] } + { 2'd0, syndrome[12] } + { 2'd0, syndrome[13] } + { 2'd0, syndrome[14] } + { 2'd0, syndrome[15] };
    wire flip_3 = (sum_3 >= 3'd3);
    wire [3:0] sum_4 = { 3'd0, syndrome[6] } + { 3'd0, syndrome[7] } + { 3'd0, syndrome[8] } + { 3'd0, syndrome[9] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_4 = (sum_4 >= 4'd4);
    wire [3:0] sum_5 = { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_5 = (sum_5 >= 4'd5);
    wire [1:0] sum_6 = { 1'd0, syndrome[2] } + { 1'd0, syndrome[15] };
    wire flip_6 = (sum_6 >= 2'd1);
    wire [3:0] sum_7 = { 3'd0, syndrome[1] } + { 3'd0, syndrome[2] } + { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[7] } + { 3'd0, syndrome[8] } + { 3'd0, syndrome[9] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_7 = (sum_7 >= 4'd7);
    wire [2:0] sum_8 = { 2'd0, syndrome[0] } + { 2'd0, syndrome[12] } + { 2'd0, syndrome[13] } + { 2'd0, syndrome[14] } + { 2'd0, syndrome[15] };
    wire flip_8 = (sum_8 >= 3'd3);
    wire [1:0] sum_9 = { 1'd0, syndrome[8] } + { 1'd0, syndrome[14] } + { 1'd0, syndrome[15] };
    wire flip_9 = (sum_9 >= 2'd2);
    wire [2:0] sum_10 = { 2'd0, syndrome[4] } + { 2'd0, syndrome[5] } + { 2'd0, syndrome[6] } + { 2'd0, syndrome[7] } + { 2'd0, syndrome[14] } + { 2'd0, syndrome[15] };
    wire flip_10 = (sum_10 >= 3'd3);
    wire [3:0] sum_11 = { 3'd0, syndrome[2] } + { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[7] } + { 3'd0, syndrome[8] } + { 3'd0, syndrome[9] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_11 = (sum_11 >= 4'd6);
    wire [1:0] sum_12 = { 1'd0, syndrome[2] } + { 1'd0, syndrome[14] } + { 1'd0, syndrome[15] };
    wire flip_12 = (sum_12 >= 2'd2);
    wire [3:0] sum_13 = { 3'd0, syndrome[0] } + { 3'd0, syndrome[1] } + { 3'd0, syndrome[2] } + { 3'd0, syndrome[3] } + { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_13 = (sum_13 >= 4'd5);
    wire [3:0] sum_14 = { 3'd0, syndrome[0] } + { 3'd0, syndrome[1] } + { 3'd0, syndrome[2] } + { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_14 = (sum_14 >= 4'd6);
    wire [3:0] sum_15 = { 3'd0, syndrome[1] } + { 3'd0, syndrome[2] } + { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] };
    wire flip_15 = (sum_15 >= 4'd4);
    wire [0:0] sum_16 = syndrome[0];
    wire flip_16 = (sum_16 >= 1'd1);
    wire [0:0] sum_17 = syndrome[1];
    wire flip_17 = (sum_17 >= 1'd1);
    wire [0:0] sum_18 = syndrome[2];
    wire flip_18 = (sum_18 >= 1'd1);
    wire [0:0] sum_19 = syndrome[3];
    wire flip_19 = (sum_19 >= 1'd1);
    wire [0:0] sum_20 = syndrome[4];
    wire flip_20 = (sum_20 >= 1'd1);
    wire [0:0] sum_21 = syndrome[5];
    wire flip_21 = (sum_21 >= 1'd1);
    wire [0:0] sum_22 = syndrome[6];
    wire flip_22 = (sum_22 >= 1'd1);
    wire [0:0] sum_23 = syndrome[7];
    wire flip_23 = (sum_23 >= 1'd1);
    wire [0:0] sum_24 = syndrome[8];
    wire flip_24 = (sum_24 >= 1'd1);
    wire [0:0] sum_25 = syndrome[9];
    wire flip_25 = (sum_25 >= 1'd1);
    wire [0:0] sum_26 = syndrome[10];
    wire flip_26 = (sum_26 >= 1'd1);
    wire [0:0] sum_27 = syndrome[11];
    wire flip_27 = (sum_27 >= 1'd1);
    wire [0:0] sum_28 = syndrome[12];
    wire flip_28 = (sum_28 >= 1'd1);
    wire [0:0] sum_29 = syndrome[13];
    wire flip_29 = (sum_29 >= 1'd1);
    wire [0:0] sum_30 = syndrome[14];
    wire flip_30 = (sum_30 >= 1'd1);
    wire [0:0] sum_31 = syndrome[15];
    wire flip_31 = (sum_31 >= 1'd1);
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
                        current_cw[16] <= current_cw[16] ^ flip_16;
                        current_cw[17] <= current_cw[17] ^ flip_17;
                        current_cw[18] <= current_cw[18] ^ flip_18;
                        current_cw[19] <= current_cw[19] ^ flip_19;
                        current_cw[20] <= current_cw[20] ^ flip_20;
                        current_cw[21] <= current_cw[21] ^ flip_21;
                        current_cw[22] <= current_cw[22] ^ flip_22;
                        current_cw[23] <= current_cw[23] ^ flip_23;
                        current_cw[24] <= current_cw[24] ^ flip_24;
                        current_cw[25] <= current_cw[25] ^ flip_25;
                        current_cw[26] <= current_cw[26] ^ flip_26;
                        current_cw[27] <= current_cw[27] ^ flip_27;
                        current_cw[28] <= current_cw[28] ^ flip_28;
                        current_cw[29] <= current_cw[29] ^ flip_29;
                        current_cw[30] <= current_cw[30] ^ flip_30;
                        current_cw[31] <= current_cw[31] ^ flip_31;
                        iter_count <= iter_count + 1;
                        state <= CALC_SYNDROME;
                    end
                    FINISH: begin
                        data_out <= current_cw[15:0];
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