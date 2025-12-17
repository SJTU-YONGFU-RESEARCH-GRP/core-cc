// Polar ECC Module - Real Implementation (Combinational SC Decoder)
// Matches Python PolarECC (N=16, K=8)
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module polar_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [15:0]            codeword_in,
    output reg  [15:0]            codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // Fixed Frozen Bits for N=16, K=8
    // Reliability sequence used in Python:
    // [0, 1, 2, 4, 8, 3, 5, 6, 9, 10, 12, 7, 11, 13, 14, 15]
    // Frozen (first 8): {0,1,2,3,4,5,6,8}
    // Info Bits: {7, 9, 10, 11, 12, 13, 14, 15}
    
    // Mapping
    wire [15:0] u;
    assign u[0] = 0;
    assign u[1] = 0;
    assign u[2] = 0;
    assign u[3] = 0;
    assign u[4] = 0;
    assign u[5] = 0;
    assign u[6] = 0;
    assign u[7] = data_in[0];
    assign u[8] = 0;
    assign u[9] = data_in[1];
    assign u[10] = data_in[2];
    assign u[11] = data_in[3];
    assign u[12] = data_in[4];
    assign u[13] = data_in[5];
    assign u[14] = data_in[6];
    assign u[15] = data_in[7];
    
    // Helper function equivalent logic
    function [15:0] polar_transform_16;
        input [15:0] in;
        reg [15:0] s1, s2, s3, s4;
        integer i;
        begin
            // Stage 1 (Stride 8): Top adds Bottom
            for(i=0; i<8; i=i+1) begin
                s1[i] = in[i] ^ in[i+8];
                s1[i+8] = in[i+8];
            end
            
            // Stage 2 (Stride 4): Within 8-blocks
            for(i=0; i<4; i=i+1) begin
                s2[i]   = s1[i] ^ s1[i+4];   s2[i+4]   = s1[i+4];
                s2[i+8] = s1[i+8] ^ s1[i+12]; s2[i+12] = s1[i+12];
            end
            
            // Stage 3 (Stride 2)
            for(i=0; i<16; i=i+1) begin // simplified loop
                 if ((i/2)%2 == 0) begin
                    s3[i] = s2[i] ^ s2[i+2];
                    s3[i+2] = s2[i+2];
                 end
            end
            // Correction for stage 3 loop (manual unroll for safety)
            s3[0]=s2[0]^s2[2]; s3[1]=s2[1]^s2[3]; s3[2]=s2[2]; s3[3]=s2[3];
            s3[4]=s2[4]^s2[6]; s3[5]=s2[5]^s2[7]; s3[6]=s2[6]; s3[7]=s2[7];
            s3[8]=s2[8]^s2[10]; s3[9]=s2[9]^s2[11]; s3[10]=s2[10]; s3[11]=s2[11];
            s3[12]=s2[12]^s2[14]; s3[13]=s2[13]^s2[15]; s3[14]=s2[14]; s3[15]=s2[15];
            
            // Stage 4 (Stride 1)
            for(i=0; i<16; i=i+2) begin
                s4[i] = s3[i] ^ s3[i+1];
                s4[i+1] = s3[i+1];
            end
            
            polar_transform_16 = s4;
        end
    endfunction

    // Encode
    wire [15:0] encoded_x;
    assign encoded_x = polar_transform_16(u);
    
    // Serial ML Decoder implementation (Search 0..255)
    reg [2:0] v_state;
    localparam S_IDLE = 0;
    localparam S_SEARCH = 1;
    localparam S_DONE = 2;
    
    reg [7:0] search_idx;
    reg [7:0] best_idx;
    reg [4:0] min_dist;
    
    // Map Search Index to U
    wire [15:0] u_curr;
    assign u_curr[0] = 0;
    assign u_curr[1] = 0;
    assign u_curr[2] = 0;
    assign u_curr[3] = 0; 
    assign u_curr[4] = 0;
    assign u_curr[5] = 0;
    assign u_curr[6] = 0;
    assign u_curr[7] = search_idx[0];
    assign u_curr[8] = 0;
    assign u_curr[9] = search_idx[1];
    assign u_curr[10] = search_idx[2];
    assign u_curr[11] = search_idx[3];
    assign u_curr[12] = search_idx[4];
    assign u_curr[13] = search_idx[5];
    assign u_curr[14] = search_idx[6];
    assign u_curr[15] = search_idx[7];
    
    wire [15:0] cand_cw;
    assign cand_cw = polar_transform_16(u_curr);
    
    // Distance calc
    wire [15:0] xor_diff;
    assign xor_diff = cand_cw ^ codeword_in;
    
    // Population Count (Hamming Weight)
    function [4:0] popcount_16;
        input [15:0] in;
        integer k;
        begin
            popcount_16 = 0;
            for (k=0; k<16; k=k+1) popcount_16 = popcount_16 + in[k];
        end
    endfunction
    
    wire [4:0] current_dist;
    assign current_dist = popcount_16(xor_diff);
    
    // Sequential Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_state <= S_IDLE;
            search_idx <= 0;
            data_out <= 0;
            valid_out <= 0;
            error_corrected <= 0;
            error_detected <= 0;
            min_dist <= 17; // Max distance + 1
        end else begin
            case (v_state)
                S_IDLE: begin
                    valid_out <= 0;
                    if (encode_en) begin
                        codeword_out <= encoded_x;
                        valid_out <= 1;
                    end else if (decode_en) begin
                        v_state <= S_SEARCH;
                        search_idx <= 0;
                        min_dist <= 17;
                        best_idx <= 0;
                    end
                end
                
                S_SEARCH: begin
                    if (current_dist < min_dist) begin
                        min_dist <= current_dist;
                        best_idx <= search_idx;
                    end
                    
                    if (search_idx == 255) begin
                        v_state <= S_DONE;
                    end else begin
                        search_idx <= search_idx + 1;
                    end
                end
                
                S_DONE: begin
                    data_out <= best_idx;
                    // Check if corrected (min_dist > 0)
                    if (min_dist > 0) error_corrected <= 1'b1;
                    else error_corrected <= 1'b0;
                    valid_out <= 1;
                    v_state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */