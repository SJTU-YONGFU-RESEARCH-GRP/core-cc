/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module system_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [DATA_WIDTH+8:0]   codeword_in, // Rigid port width from runner
    output reg  [DATA_WIDTH+8:0]   codeword_out,
    output reg  [DATA_WIDTH-1:0]   data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // 1. Calculate Exact Hamming Width to match sub-module
    // 1. Calculate Exact Hamming Width to match sub-module
    localparam HAMMING_WIDTH = (DATA_WIDTH <= 2) ? 5 :
                               (DATA_WIDTH <= 4) ? 7 : 
                               (DATA_WIDTH <= 8) ? 12 : 
                               (DATA_WIDTH <= 16) ? 21 : 
                               (DATA_WIDTH <= 32) ? 38 : 
                               (DATA_WIDTH <= 64) ? 71 : 136;
                               
    // 2. Define Wires
    wire [HAMMING_WIDTH-1:0] hamming_cw_out;
    wire [HAMMING_WIDTH-1:0] hamming_cw_in = codeword_in[HAMMING_WIDTH-1:0];
    
    wire h_valid, h_det, h_corr;
    wire [DATA_WIDTH-1:0] h_data_out;
    
    // 3. Instantiate
    hamming_secded_ecc #(
        .DATA_WIDTH(DATA_WIDTH)
    ) hamming_inst (
        .clk(clk),
        .rst_n(rst_n),
        .encode_en(encode_en),
        .decode_en(decode_en),
        .data_in(data_in),
        .codeword_in(hamming_cw_in), // Connect only relevant bits
        .codeword_out(hamming_cw_out),
        .data_out(h_data_out),
        .error_detected(h_det),
        .error_corrected(h_corr),
        .valid_out(h_valid)
    );
    
    // 4. System Parity (Encoder)
    wire system_parity_enc = ^hamming_cw_out;
    
    // Use h_valid to trigger output capture (Pipeline Stage 2)
    // This block is removed as per instruction.
    
    // Unified Delay Logic
    reg h_valid_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) h_valid_d <= 0;
        else h_valid_d <= h_valid;
    end
    
    reg doing_encode;
    reg doing_decode;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            doing_encode <= 0;
            doing_decode <= 0;
        end else begin
            if (encode_en) doing_encode <= 1;
            else if (h_valid_d) doing_encode <= 0;
            
            if (decode_en) doing_decode <= 1;
            else if (h_valid_d) doing_decode <= 0;
        end
    end

    // Safe padding calculation
    localparam PAD_BITS = (DATA_WIDTH + 9) > (HAMMING_WIDTH + 1) ? 
                          (DATA_WIDTH + 9) - (HAMMING_WIDTH + 1) : 0;

    // Encoder Output Capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 0;
            // valid_out handled below combined?
        end else if (h_valid_d && doing_encode) begin
             if (PAD_BITS > 0) begin
                 codeword_out <= { {PAD_BITS{1'b0}}, system_parity_enc, hamming_cw_out };
             end else begin
                 codeword_out <= { system_parity_enc, hamming_cw_out };
             end
        end
    end
    
    // Decoder Output Capture
    wire system_parity_rx = codeword_in[HAMMING_WIDTH];
    // Note: codeword_in is Input. It is stable.
    wire [HAMMING_WIDTH-1:0] h_cw_in_wire = codeword_in[HAMMING_WIDTH-1:0]; 
    // Wait, calc_parity_rx needs correct input subset.
    wire calc_parity_rx = ^h_cw_in_wire;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
        end else if (h_valid_d && doing_decode) begin
             if (system_parity_rx != calc_parity_rx) begin
                 data_out <= h_data_out; 
                 error_detected <= 1;
                 error_corrected <= 0;
             end else begin
                 data_out <= h_data_out;
                 error_detected <= h_det;
                 error_corrected <= h_corr;
             end
        end
    end
    
    // Valid Signal - Unified
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) valid_out <= 0;
        else valid_out <= h_valid_d;
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
