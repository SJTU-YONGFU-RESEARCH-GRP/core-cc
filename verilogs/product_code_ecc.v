/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module product_code_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    // Codeword size depends on sub-block count and their ECC sizes.
    // We over-provision for simplicity or calculate exact?
    // Let's use a large enough width or try to calculate.
    // Sub-block logic:
    // W<=4: Sub=2. Blocks=W/2. Row=Ham(2)->5? Col=Par(2)->3. Total=8/2 * (5+3) = 4*8=32? No.
    // Hamming(2): N=5 (P=3)? 2 data, 3 parity.
    // Parity(2): N=3. 2 data, 1 parity.
    // Total per block: 5+3 = 8.
    // Blocks = 4/2 = 2. Total = 16.
    input  wire [DATA_WIDTH*4+32-1:0] codeword_in, 
    output wire [DATA_WIDTH*4+32-1:0] codeword_out,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    error_detected,
    output wire                    error_corrected,
    output wire                    valid_out
);

    // ----------------------------------------------------------------------
    // Configuration Parameters matching Python logic
    // ----------------------------------------------------------------------
    localparam SUB_WIDTH = (DATA_WIDTH <= 4) ? 2 :
                           (DATA_WIDTH <= 8) ? 4 :
                           (DATA_WIDTH <= 16) ? 8 : 16;
                           
    localparam NUM_BLOCKS = DATA_WIDTH / SUB_WIDTH;
    
    // Row ECC (Hamming) Parameters
    localparam ROW_CW_WIDTH = (SUB_WIDTH <= 4) ? 7 : // Hamming(4) -> 7. Hamming(2) -> ?
                              (SUB_WIDTH <= 8) ? 12 :
                              (SUB_WIDTH <= 16) ? 21 : 38; // Hamming(16) -> 21
                              
    // Col ECC (Parity) Parameters
    localparam COL_CW_WIDTH = SUB_WIDTH + 1;

    // Total bits used
    localparam TOTAL_BITS = NUM_BLOCKS * (ROW_CW_WIDTH + COL_CW_WIDTH);

    // ----------------------------------------------------------------------
    // Internal Signals
    // ----------------------------------------------------------------------
    
    wire [NUM_BLOCKS-1:0] row_valid;
    wire [NUM_BLOCKS-1:0] col_valid;
    wire [NUM_BLOCKS-1:0] row_err_det;
    wire [NUM_BLOCKS-1:0] col_err_det;
    wire [NUM_BLOCKS-1:0] row_err_corr; // Row can correct
    // Col is parity, can only detect.
    
    wire [ROW_CW_WIDTH*NUM_BLOCKS-1:0] row_cws;
    wire [COL_CW_WIDTH*NUM_BLOCKS-1:0] col_cws;
    
    wire [SUB_WIDTH*NUM_BLOCKS-1:0] row_data_out;
    
    genvar i;
    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : gen_blocks
            // Slicing
            wire [SUB_WIDTH-1:0] sub_data_in = data_in[(i+1)*SUB_WIDTH-1 : i*SUB_WIDTH];
            
            // Codeword Slicing
            // Row Codewords first: [Block0_Row][Block1_Row]... 
            // Python: 
            // for word in row_encoded_words: codeword |= (word << bit_pos)...
            // for word in col_encoded_words: codeword |= (word << bit_pos)...
            
            // So Row CWs are at [0 .. NUM*ROW_W - 1]
            // Col CWs are at [NUM*ROW_W .. Total - 1]
            
            wire [ROW_CW_WIDTH-1:0] row_cw_in = codeword_in[(i)*ROW_CW_WIDTH + ROW_CW_WIDTH - 1 : (i)*ROW_CW_WIDTH];
            
            // Col CWs start after ALL Row CWs
            localparam COL_START = NUM_BLOCKS * ROW_CW_WIDTH;
            wire [COL_CW_WIDTH-1:0] col_cw_in = codeword_in[COL_START + (i)*COL_CW_WIDTH + COL_CW_WIDTH - 1 : COL_START + (i)*COL_CW_WIDTH];
            
            wire [ROW_CW_WIDTH-1:0] row_cw_out;
            wire [COL_CW_WIDTH-1:0] col_cw_out;
            wire [SUB_WIDTH-1:0] sub_data_out;
            wire row_ed, row_ec, row_v;
            wire col_ed, col_ec, col_v; // Col EC is likely 0
            wire [SUB_WIDTH-1:0] col_data_out_dummy;
            
            // Instantiate Row ECC (Hamming)
            hamming_secded_ecc #(
                .DATA_WIDTH(SUB_WIDTH)
            ) u_row_ecc (
                .clk(clk),
                .rst_n(rst_n),
                .encode_en(encode_en),
                .decode_en(decode_en),
                .data_in(sub_data_in),
                .codeword_in(row_cw_in),
                .codeword_out(row_cw_out),
                .data_out(sub_data_out), // We use Rows for data recovery (Hamming is better)
                .error_detected(row_ed),
                .error_corrected(row_ec),
                .valid_out(row_v)
            );
            
            // Instantiate Col ECC (Parity)
            parity_ecc #(
                .DATA_WIDTH(SUB_WIDTH)
            ) u_col_ecc (
                .clk(clk),
                .rst_n(rst_n),
                .encode_en(encode_en),
                .decode_en(decode_en),
                .data_in(sub_data_in),
                .codeword_in(col_cw_in),
                .codeword_out(col_cw_out),
                .data_out(col_data_out_dummy),
                .error_detected(col_ed),
                .valid_out(col_v)
            );
            
            assign row_valid[i] = row_v;
            assign col_valid[i] = col_v;
            assign row_err_det[i] = row_ed;
            assign col_err_det[i] = col_ed;
            assign row_err_corr[i] = row_ec;
            
            assign row_cws[(i+1)*ROW_CW_WIDTH-1 : i*ROW_CW_WIDTH] = row_cw_out;
            assign col_cws[(i+1)*COL_CW_WIDTH-1 : i*COL_CW_WIDTH] = col_cw_out;
            assign row_data_out[(i+1)*SUB_WIDTH-1 : i*SUB_WIDTH] = sub_data_out;
        end
    endgenerate

    // Aggregation
    assign codeword_out = {{((DATA_WIDTH*4+32)-TOTAL_BITS){1'b0}}, col_cws, row_cws};
    assign data_out = row_data_out;
    
    assign valid_out = row_valid[0]; // Assume all finish together
    assign error_detected = (|row_err_det) | (|col_err_det);
    assign error_corrected = (|row_err_corr); // Only Hamming can correct
    
endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */