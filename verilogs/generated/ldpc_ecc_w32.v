// Generated ldpc_ecc_w32 - Do not edit manually
module ldpc_ecc_w32 (
    input  wire clk,
    input  wire rst_n,
    input  wire encode_en,
    input  wire decode_en,
    input  wire [31:0] data_in,
    input  wire [63:0] codeword_in,
    output reg  [63:0] codeword_out,
    output reg  [31:0] data_out,
    output reg  error_detected,
    output reg  error_corrected,
    output reg  valid_out
);
    reg [3:0] state;
    localparam IDLE = 0, CALC_SYNDROME = 1, FLIP_BITS = 2, CHECK_DONE = 3, FINISH = 4;
    reg [4:0] iter_count;
    localparam MAX_ITER = 10;
    
    reg [63:0] current_cw;
    wire [31:0] syndrome;
    wire has_error;
    wire [31:0] parity_out;
    assign parity_out[0] = data_in[23] ^ data_in[26];
    assign parity_out[1] = data_in[12] ^ data_in[15] ^ data_in[19] ^ data_in[23] ^ data_in[26] ^ data_in[31];
    assign parity_out[2] = data_in[10] ^ data_in[15] ^ data_in[19] ^ data_in[23] ^ data_in[26] ^ data_in[31];
    assign parity_out[3] = data_in[2] ^ data_in[7] ^ data_in[10] ^ data_in[15] ^ data_in[19] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[31];
    assign parity_out[4] = data_in[2] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[15] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[31];
    assign parity_out[5] = data_in[3] ^ data_in[7] ^ data_in[9] ^ data_in[14] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[27] ^ data_in[31];
    assign parity_out[6] = data_in[0] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[14] ^ data_in[18] ^ data_in[21] ^ data_in[23] ^ data_in[27] ^ data_in[31];
    assign parity_out[7] = data_in[0] ^ data_in[3] ^ data_in[8] ^ data_in[9] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[23] ^ data_in[27] ^ data_in[30] ^ data_in[31];
    assign parity_out[8] = data_in[0] ^ data_in[3] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[23] ^ data_in[27] ^ data_in[30] ^ data_in[31];
    assign parity_out[9] = data_in[0] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[23] ^ data_in[27] ^ data_in[30] ^ data_in[31];
    assign parity_out[10] = data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[18] ^ data_in[21] ^ data_in[27] ^ data_in[30] ^ data_in[31];
    assign parity_out[11] = data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[18] ^ data_in[21] ^ data_in[24] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[12] = data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[18] ^ data_in[21] ^ data_in[24] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[13] = data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[20] ^ data_in[21] ^ data_in[24] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[14] = data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15] ^ data_in[16] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[30] ^ data_in[31];
    assign parity_out[15] = data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15] ^ data_in[16] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[30] ^ data_in[31];
    assign parity_out[16] = data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15] ^ data_in[16] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[30] ^ data_in[31];
    assign parity_out[17] = data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15] ^ data_in[16] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[31];
    assign parity_out[18] = data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15] ^ data_in[16] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[31];
    assign parity_out[19] = data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[31];
    assign parity_out[20] = data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[29] ^ data_in[31];
    assign parity_out[21] = data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[15] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[22] = data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[23] = data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[24] = data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[25] = data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[26] = data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[27] = data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[28] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[29] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30];
    assign parity_out[30] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign parity_out[31] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign syndrome[0] = current_cw[23] ^ current_cw[26] ^ current_cw[32];
    assign syndrome[1] = current_cw[12] ^ current_cw[15] ^ current_cw[19] ^ current_cw[23] ^ current_cw[26] ^ current_cw[31] ^ current_cw[33];
    assign syndrome[2] = current_cw[10] ^ current_cw[15] ^ current_cw[19] ^ current_cw[23] ^ current_cw[26] ^ current_cw[31] ^ current_cw[34];
    assign syndrome[3] = current_cw[2] ^ current_cw[7] ^ current_cw[10] ^ current_cw[15] ^ current_cw[19] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[31] ^ current_cw[35];
    assign syndrome[4] = current_cw[2] ^ current_cw[7] ^ current_cw[9] ^ current_cw[10] ^ current_cw[14] ^ current_cw[15] ^ current_cw[19] ^ current_cw[21] ^ current_cw[22] ^ current_cw[23] ^ current_cw[31] ^ current_cw[36];
    assign syndrome[5] = current_cw[3] ^ current_cw[7] ^ current_cw[9] ^ current_cw[14] ^ current_cw[18] ^ current_cw[19] ^ current_cw[21] ^ current_cw[23] ^ current_cw[27] ^ current_cw[31] ^ current_cw[37];
    assign syndrome[6] = current_cw[0] ^ current_cw[3] ^ current_cw[7] ^ current_cw[8] ^ current_cw[9] ^ current_cw[14] ^ current_cw[18] ^ current_cw[21] ^ current_cw[23] ^ current_cw[27] ^ current_cw[31] ^ current_cw[38];
    assign syndrome[7] = current_cw[0] ^ current_cw[3] ^ current_cw[8] ^ current_cw[9] ^ current_cw[14] ^ current_cw[17] ^ current_cw[18] ^ current_cw[21] ^ current_cw[23] ^ current_cw[27] ^ current_cw[30] ^ current_cw[31] ^ current_cw[39];
    assign syndrome[8] = current_cw[0] ^ current_cw[3] ^ current_cw[8] ^ current_cw[9] ^ current_cw[13] ^ current_cw[14] ^ current_cw[17] ^ current_cw[18] ^ current_cw[21] ^ current_cw[23] ^ current_cw[27] ^ current_cw[30] ^ current_cw[31] ^ current_cw[40];
    assign syndrome[9] = current_cw[0] ^ current_cw[8] ^ current_cw[9] ^ current_cw[13] ^ current_cw[14] ^ current_cw[17] ^ current_cw[18] ^ current_cw[21] ^ current_cw[23] ^ current_cw[27] ^ current_cw[30] ^ current_cw[31] ^ current_cw[41];
    assign syndrome[10] = current_cw[8] ^ current_cw[9] ^ current_cw[13] ^ current_cw[14] ^ current_cw[18] ^ current_cw[21] ^ current_cw[27] ^ current_cw[30] ^ current_cw[31] ^ current_cw[42];
    assign syndrome[11] = current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[18] ^ current_cw[21] ^ current_cw[24] ^ current_cw[27] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[43];
    assign syndrome[12] = current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[18] ^ current_cw[21] ^ current_cw[24] ^ current_cw[27] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[44];
    assign syndrome[13] = current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[20] ^ current_cw[21] ^ current_cw[24] ^ current_cw[27] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[45];
    assign syndrome[14] = current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[15] ^ current_cw[16] ^ current_cw[20] ^ current_cw[21] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[30] ^ current_cw[31] ^ current_cw[46];
    assign syndrome[15] = current_cw[4] ^ current_cw[6] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[15] ^ current_cw[16] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[30] ^ current_cw[31] ^ current_cw[47];
    assign syndrome[16] = current_cw[3] ^ current_cw[4] ^ current_cw[6] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[15] ^ current_cw[16] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[30] ^ current_cw[31] ^ current_cw[48];
    assign syndrome[17] = current_cw[3] ^ current_cw[5] ^ current_cw[6] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[15] ^ current_cw[16] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[30] ^ current_cw[31] ^ current_cw[49];
    assign syndrome[18] = current_cw[3] ^ current_cw[5] ^ current_cw[6] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[15] ^ current_cw[16] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[30] ^ current_cw[31] ^ current_cw[50];
    assign syndrome[19] = current_cw[3] ^ current_cw[5] ^ current_cw[6] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[15] ^ current_cw[22] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[30] ^ current_cw[31] ^ current_cw[51];
    assign syndrome[20] = current_cw[3] ^ current_cw[4] ^ current_cw[6] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[15] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[29] ^ current_cw[31] ^ current_cw[52];
    assign syndrome[21] = current_cw[3] ^ current_cw[4] ^ current_cw[6] ^ current_cw[7] ^ current_cw[8] ^ current_cw[10] ^ current_cw[15] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[53];
    assign syndrome[22] = current_cw[3] ^ current_cw[4] ^ current_cw[6] ^ current_cw[7] ^ current_cw[8] ^ current_cw[10] ^ current_cw[12] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[54];
    assign syndrome[23] = current_cw[1] ^ current_cw[3] ^ current_cw[4] ^ current_cw[6] ^ current_cw[7] ^ current_cw[10] ^ current_cw[12] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[55];
    assign syndrome[24] = current_cw[3] ^ current_cw[4] ^ current_cw[6] ^ current_cw[7] ^ current_cw[10] ^ current_cw[12] ^ current_cw[13] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[56];
    assign syndrome[25] = current_cw[3] ^ current_cw[4] ^ current_cw[7] ^ current_cw[10] ^ current_cw[12] ^ current_cw[13] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[57];
    assign syndrome[26] = current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[7] ^ current_cw[10] ^ current_cw[12] ^ current_cw[13] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[58];
    assign syndrome[27] = current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[7] ^ current_cw[10] ^ current_cw[12] ^ current_cw[13] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[59];
    assign syndrome[28] = current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[6] ^ current_cw[7] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[12] ^ current_cw[13] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[22] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[60];
    assign syndrome[29] = current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[6] ^ current_cw[7] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[12] ^ current_cw[13] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[21] ^ current_cw[22] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[61];
    assign syndrome[30] = current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[6] ^ current_cw[7] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[12] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[16] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[21] ^ current_cw[22] ^ current_cw[23] ^ current_cw[25] ^ current_cw[26] ^ current_cw[27] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[62];
    assign syndrome[31] = current_cw[0] ^ current_cw[1] ^ current_cw[2] ^ current_cw[3] ^ current_cw[4] ^ current_cw[5] ^ current_cw[6] ^ current_cw[7] ^ current_cw[8] ^ current_cw[9] ^ current_cw[10] ^ current_cw[11] ^ current_cw[12] ^ current_cw[13] ^ current_cw[14] ^ current_cw[15] ^ current_cw[16] ^ current_cw[17] ^ current_cw[18] ^ current_cw[19] ^ current_cw[20] ^ current_cw[21] ^ current_cw[22] ^ current_cw[23] ^ current_cw[24] ^ current_cw[25] ^ current_cw[26] ^ current_cw[27] ^ current_cw[28] ^ current_cw[29] ^ current_cw[30] ^ current_cw[31] ^ current_cw[63];
    assign has_error = |syndrome;
    wire [2:0] sum_0 = { 2'd0, syndrome[6] } + { 2'd0, syndrome[7] } + { 2'd0, syndrome[8] } + { 2'd0, syndrome[9] } + { 2'd0, syndrome[31] };
    wire flip_0 = (sum_0 >= 3'd3);
    wire [2:0] sum_1 = { 2'd0, syndrome[23] } + { 2'd0, syndrome[28] } + { 2'd0, syndrome[29] } + { 2'd0, syndrome[30] } + { 2'd0, syndrome[31] };
    wire flip_1 = (sum_1 >= 3'd3);
    wire [3:0] sum_2 = { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_2 = (sum_2 >= 4'd4);
    wire [4:0] sum_3 = { 4'd0, syndrome[5] } + { 4'd0, syndrome[6] } + { 4'd0, syndrome[7] } + { 4'd0, syndrome[8] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_3 = (sum_3 >= 5'd10);
    wire [3:0] sum_4 = { 3'd0, syndrome[15] } + { 3'd0, syndrome[16] } + { 3'd0, syndrome[20] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_4 = (sum_4 >= 4'd7);
    wire [2:0] sum_5 = { 2'd0, syndrome[17] } + { 2'd0, syndrome[18] } + { 2'd0, syndrome[19] } + { 2'd0, syndrome[29] } + { 2'd0, syndrome[30] } + { 2'd0, syndrome[31] };
    wire flip_5 = (sum_5 >= 3'd3);
    wire [3:0] sum_6 = { 3'd0, syndrome[15] } + { 3'd0, syndrome[16] } + { 3'd0, syndrome[17] } + { 3'd0, syndrome[18] } + { 3'd0, syndrome[19] } + { 3'd0, syndrome[20] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_6 = (sum_6 >= 4'd7);
    wire [3:0] sum_7 = { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_7 = (sum_7 >= 4'd8);
    wire [4:0] sum_8 = { 4'd0, syndrome[6] } + { 4'd0, syndrome[7] } + { 4'd0, syndrome[8] } + { 4'd0, syndrome[9] } + { 4'd0, syndrome[10] } + { 4'd0, syndrome[11] } + { 4'd0, syndrome[12] } + { 4'd0, syndrome[13] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_8 = (sum_8 >= 5'd10);
    wire [4:0] sum_9 = { 4'd0, syndrome[4] } + { 4'd0, syndrome[5] } + { 4'd0, syndrome[6] } + { 4'd0, syndrome[7] } + { 4'd0, syndrome[8] } + { 4'd0, syndrome[9] } + { 4'd0, syndrome[10] } + { 4'd0, syndrome[11] } + { 4'd0, syndrome[12] } + { 4'd0, syndrome[13] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_9 = (sum_9 >= 5'd11);
    wire [4:0] sum_10 = { 4'd0, syndrome[2] } + { 4'd0, syndrome[3] } + { 4'd0, syndrome[4] } + { 4'd0, syndrome[11] } + { 4'd0, syndrome[12] } + { 4'd0, syndrome[13] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_10 = (sum_10 >= 5'd12);
    wire [3:0] sum_11 = { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] } + { 3'd0, syndrome[16] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_11 = (sum_11 >= 4'd5);
    wire [3:0] sum_12 = { 3'd0, syndrome[1] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_12 = (sum_12 >= 4'd6);
    wire [3:0] sum_13 = { 3'd0, syndrome[8] } + { 3'd0, syndrome[9] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_13 = (sum_13 >= 4'd6);
    wire [3:0] sum_14 = { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[7] } + { 3'd0, syndrome[8] } + { 3'd0, syndrome[9] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_14 = (sum_14 >= 4'd5);
    wire [4:0] sum_15 = { 4'd0, syndrome[1] } + { 4'd0, syndrome[2] } + { 4'd0, syndrome[3] } + { 4'd0, syndrome[4] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_15 = (sum_15 >= 5'd11);
    wire [3:0] sum_16 = { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] } + { 3'd0, syndrome[16] } + { 3'd0, syndrome[17] } + { 3'd0, syndrome[18] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_16 = (sum_16 >= 4'd8);
    wire [2:0] sum_17 = { 2'd0, syndrome[7] } + { 2'd0, syndrome[8] } + { 2'd0, syndrome[9] } + { 2'd0, syndrome[31] };
    wire flip_17 = (sum_17 >= 3'd2);
    wire [4:0] sum_18 = { 4'd0, syndrome[5] } + { 4'd0, syndrome[6] } + { 4'd0, syndrome[7] } + { 4'd0, syndrome[8] } + { 4'd0, syndrome[9] } + { 4'd0, syndrome[10] } + { 4'd0, syndrome[11] } + { 4'd0, syndrome[12] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_18 = (sum_18 >= 5'd9);
    wire [3:0] sum_19 = { 3'd0, syndrome[1] } + { 3'd0, syndrome[2] } + { 3'd0, syndrome[3] } + { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_19 = (sum_19 >= 4'd7);
    wire [3:0] sum_20 = { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[20] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_20 = (sum_20 >= 4'd7);
    wire [3:0] sum_21 = { 3'd0, syndrome[4] } + { 3'd0, syndrome[5] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[7] } + { 3'd0, syndrome[8] } + { 3'd0, syndrome[9] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_21 = (sum_21 >= 4'd7);
    wire [3:0] sum_22 = { 3'd0, syndrome[4] } + { 3'd0, syndrome[19] } + { 3'd0, syndrome[20] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_22 = (sum_22 >= 4'd7);
    wire [4:0] sum_23 = { 4'd0, syndrome[0] } + { 4'd0, syndrome[1] } + { 4'd0, syndrome[2] } + { 4'd0, syndrome[3] } + { 4'd0, syndrome[4] } + { 4'd0, syndrome[5] } + { 4'd0, syndrome[6] } + { 4'd0, syndrome[7] } + { 4'd0, syndrome[8] } + { 4'd0, syndrome[9] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_23 = (sum_23 >= 5'd14);
    wire [3:0] sum_24 = { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[14] } + { 3'd0, syndrome[15] } + { 3'd0, syndrome[16] } + { 3'd0, syndrome[17] } + { 3'd0, syndrome[18] } + { 3'd0, syndrome[19] } + { 3'd0, syndrome[20] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[31] };
    wire flip_24 = (sum_24 >= 4'd7);
    wire [4:0] sum_25 = { 4'd0, syndrome[3] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_25 = (sum_25 >= 5'd10);
    wire [4:0] sum_26 = { 4'd0, syndrome[0] } + { 4'd0, syndrome[1] } + { 4'd0, syndrome[2] } + { 4'd0, syndrome[3] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_26 = (sum_26 >= 5'd10);
    wire [3:0] sum_27 = { 3'd0, syndrome[5] } + { 3'd0, syndrome[6] } + { 3'd0, syndrome[7] } + { 3'd0, syndrome[8] } + { 3'd0, syndrome[9] } + { 3'd0, syndrome[10] } + { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_27 = (sum_27 >= 4'd6);
    wire [3:0] sum_28 = { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_28 = (sum_28 >= 4'd7);
    wire [3:0] sum_29 = { 3'd0, syndrome[11] } + { 3'd0, syndrome[12] } + { 3'd0, syndrome[13] } + { 3'd0, syndrome[20] } + { 3'd0, syndrome[21] } + { 3'd0, syndrome[22] } + { 3'd0, syndrome[23] } + { 3'd0, syndrome[24] } + { 3'd0, syndrome[25] } + { 3'd0, syndrome[26] } + { 3'd0, syndrome[27] } + { 3'd0, syndrome[28] } + { 3'd0, syndrome[29] } + { 3'd0, syndrome[30] } + { 3'd0, syndrome[31] };
    wire flip_29 = (sum_29 >= 4'd8);
    wire [4:0] sum_30 = { 4'd0, syndrome[7] } + { 4'd0, syndrome[8] } + { 4'd0, syndrome[9] } + { 4'd0, syndrome[10] } + { 4'd0, syndrome[11] } + { 4'd0, syndrome[12] } + { 4'd0, syndrome[13] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[29] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_30 = (sum_30 >= 5'd12);
    wire [4:0] sum_31 = { 4'd0, syndrome[1] } + { 4'd0, syndrome[2] } + { 4'd0, syndrome[3] } + { 4'd0, syndrome[4] } + { 4'd0, syndrome[5] } + { 4'd0, syndrome[6] } + { 4'd0, syndrome[7] } + { 4'd0, syndrome[8] } + { 4'd0, syndrome[9] } + { 4'd0, syndrome[10] } + { 4'd0, syndrome[11] } + { 4'd0, syndrome[12] } + { 4'd0, syndrome[13] } + { 4'd0, syndrome[14] } + { 4'd0, syndrome[15] } + { 4'd0, syndrome[16] } + { 4'd0, syndrome[17] } + { 4'd0, syndrome[18] } + { 4'd0, syndrome[19] } + { 4'd0, syndrome[20] } + { 4'd0, syndrome[21] } + { 4'd0, syndrome[22] } + { 4'd0, syndrome[23] } + { 4'd0, syndrome[24] } + { 4'd0, syndrome[25] } + { 4'd0, syndrome[26] } + { 4'd0, syndrome[27] } + { 4'd0, syndrome[28] } + { 4'd0, syndrome[30] } + { 4'd0, syndrome[31] };
    wire flip_31 = (sum_31 >= 5'd15);
    wire [0:0] sum_32 = syndrome[0];
    wire flip_32 = (sum_32 >= 1'd1);
    wire [0:0] sum_33 = syndrome[1];
    wire flip_33 = (sum_33 >= 1'd1);
    wire [0:0] sum_34 = syndrome[2];
    wire flip_34 = (sum_34 >= 1'd1);
    wire [0:0] sum_35 = syndrome[3];
    wire flip_35 = (sum_35 >= 1'd1);
    wire [0:0] sum_36 = syndrome[4];
    wire flip_36 = (sum_36 >= 1'd1);
    wire [0:0] sum_37 = syndrome[5];
    wire flip_37 = (sum_37 >= 1'd1);
    wire [0:0] sum_38 = syndrome[6];
    wire flip_38 = (sum_38 >= 1'd1);
    wire [0:0] sum_39 = syndrome[7];
    wire flip_39 = (sum_39 >= 1'd1);
    wire [0:0] sum_40 = syndrome[8];
    wire flip_40 = (sum_40 >= 1'd1);
    wire [0:0] sum_41 = syndrome[9];
    wire flip_41 = (sum_41 >= 1'd1);
    wire [0:0] sum_42 = syndrome[10];
    wire flip_42 = (sum_42 >= 1'd1);
    wire [0:0] sum_43 = syndrome[11];
    wire flip_43 = (sum_43 >= 1'd1);
    wire [0:0] sum_44 = syndrome[12];
    wire flip_44 = (sum_44 >= 1'd1);
    wire [0:0] sum_45 = syndrome[13];
    wire flip_45 = (sum_45 >= 1'd1);
    wire [0:0] sum_46 = syndrome[14];
    wire flip_46 = (sum_46 >= 1'd1);
    wire [0:0] sum_47 = syndrome[15];
    wire flip_47 = (sum_47 >= 1'd1);
    wire [0:0] sum_48 = syndrome[16];
    wire flip_48 = (sum_48 >= 1'd1);
    wire [0:0] sum_49 = syndrome[17];
    wire flip_49 = (sum_49 >= 1'd1);
    wire [0:0] sum_50 = syndrome[18];
    wire flip_50 = (sum_50 >= 1'd1);
    wire [0:0] sum_51 = syndrome[19];
    wire flip_51 = (sum_51 >= 1'd1);
    wire [0:0] sum_52 = syndrome[20];
    wire flip_52 = (sum_52 >= 1'd1);
    wire [0:0] sum_53 = syndrome[21];
    wire flip_53 = (sum_53 >= 1'd1);
    wire [0:0] sum_54 = syndrome[22];
    wire flip_54 = (sum_54 >= 1'd1);
    wire [0:0] sum_55 = syndrome[23];
    wire flip_55 = (sum_55 >= 1'd1);
    wire [0:0] sum_56 = syndrome[24];
    wire flip_56 = (sum_56 >= 1'd1);
    wire [0:0] sum_57 = syndrome[25];
    wire flip_57 = (sum_57 >= 1'd1);
    wire [0:0] sum_58 = syndrome[26];
    wire flip_58 = (sum_58 >= 1'd1);
    wire [0:0] sum_59 = syndrome[27];
    wire flip_59 = (sum_59 >= 1'd1);
    wire [0:0] sum_60 = syndrome[28];
    wire flip_60 = (sum_60 >= 1'd1);
    wire [0:0] sum_61 = syndrome[29];
    wire flip_61 = (sum_61 >= 1'd1);
    wire [0:0] sum_62 = syndrome[30];
    wire flip_62 = (sum_62 >= 1'd1);
    wire [0:0] sum_63 = syndrome[31];
    wire flip_63 = (sum_63 >= 1'd1);
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
                        current_cw[32] <= current_cw[32] ^ flip_32;
                        current_cw[33] <= current_cw[33] ^ flip_33;
                        current_cw[34] <= current_cw[34] ^ flip_34;
                        current_cw[35] <= current_cw[35] ^ flip_35;
                        current_cw[36] <= current_cw[36] ^ flip_36;
                        current_cw[37] <= current_cw[37] ^ flip_37;
                        current_cw[38] <= current_cw[38] ^ flip_38;
                        current_cw[39] <= current_cw[39] ^ flip_39;
                        current_cw[40] <= current_cw[40] ^ flip_40;
                        current_cw[41] <= current_cw[41] ^ flip_41;
                        current_cw[42] <= current_cw[42] ^ flip_42;
                        current_cw[43] <= current_cw[43] ^ flip_43;
                        current_cw[44] <= current_cw[44] ^ flip_44;
                        current_cw[45] <= current_cw[45] ^ flip_45;
                        current_cw[46] <= current_cw[46] ^ flip_46;
                        current_cw[47] <= current_cw[47] ^ flip_47;
                        current_cw[48] <= current_cw[48] ^ flip_48;
                        current_cw[49] <= current_cw[49] ^ flip_49;
                        current_cw[50] <= current_cw[50] ^ flip_50;
                        current_cw[51] <= current_cw[51] ^ flip_51;
                        current_cw[52] <= current_cw[52] ^ flip_52;
                        current_cw[53] <= current_cw[53] ^ flip_53;
                        current_cw[54] <= current_cw[54] ^ flip_54;
                        current_cw[55] <= current_cw[55] ^ flip_55;
                        current_cw[56] <= current_cw[56] ^ flip_56;
                        current_cw[57] <= current_cw[57] ^ flip_57;
                        current_cw[58] <= current_cw[58] ^ flip_58;
                        current_cw[59] <= current_cw[59] ^ flip_59;
                        current_cw[60] <= current_cw[60] ^ flip_60;
                        current_cw[61] <= current_cw[61] ^ flip_61;
                        current_cw[62] <= current_cw[62] ^ flip_62;
                        current_cw[63] <= current_cw[63] ^ flip_63;
                        iter_count <= iter_count + 1;
                        state <= CALC_SYNDROME;
                    end
                    FINISH: begin
                        data_out <= current_cw[31:0];
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