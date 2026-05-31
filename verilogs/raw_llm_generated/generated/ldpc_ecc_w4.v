// Generated ldpc_ecc_w4 - Do not edit manually
module ldpc_ecc_w4 (
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
    reg [3:0] state;
    localparam IDLE = 0, CALC_SYNDROME = 1, FLIP_BITS = 2, CHECK_DONE = 3, FINISH = 4;
    reg [4:0] iter_count;
    localparam MAX_ITER = 10;
    
    reg [7:0] current_cw;
    wire [3:0] syndrome;
    wire has_error;
    wire [3:0] parity_out;
    assign parity_out[0] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3];
    assign parity_out[1] = data_in[2] ^ data_in[3];
    assign parity_out[2] = data_in[1];
    assign parity_out[3] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3];
    assign syndrome[0] = current_cw[0] ^ current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4];
    assign syndrome[1] = current_cw[2] ^ current_cw[3] ^ current_cw[5];
    assign syndrome[2] = current_cw[1] ^ current_cw[6];
    assign syndrome[3] = current_cw[0] ^ current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[7];
    assign has_error = |syndrome;
    wire [1:0] sum_0 = { 1'd0, syndrome[0] } + { 1'd0, syndrome[3] };
    wire flip_0 = (sum_0 >= 2'd1);
    wire [1:0] sum_1 = { 1'd0, syndrome[0] } + { 1'd0, syndrome[2] } + { 1'd0, syndrome[3] };
    wire flip_1 = (sum_1 >= 2'd2);
    wire [1:0] sum_2 = { 1'd0, syndrome[0] } + { 1'd0, syndrome[1] } + { 1'd0, syndrome[3] };
    wire flip_2 = (sum_2 >= 2'd2);
    wire [1:0] sum_3 = { 1'd0, syndrome[0] } + { 1'd0, syndrome[1] } + { 1'd0, syndrome[3] };
    wire flip_3 = (sum_3 >= 2'd2);
    wire [0:0] sum_4 = syndrome[0];
    wire flip_4 = (sum_4 >= 1'd1);
    wire [0:0] sum_5 = syndrome[1];
    wire flip_5 = (sum_5 >= 1'd1);
    wire [0:0] sum_6 = syndrome[2];
    wire flip_6 = (sum_6 >= 1'd1);
    wire [0:0] sum_7 = syndrome[3];
    wire flip_7 = (sum_7 >= 1'd1);
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
                        iter_count <= iter_count + 1;
                        state <= CALC_SYNDROME;
                    end
                    FINISH: begin
                        data_out <= current_cw[3:0];
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