// Golay ECC Module - Real Implementation (Cyclic Error Trapping Decoder)
// Matches Python GolayECC (N=23, K=12)
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module golay_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [22:0]            codeword_in, // 23 bits
    output reg  [22:0]            codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);
    // Note: Parameter DATA_WIDTH usually 8 for benchmark interface.
    // Golay is fixed (23,12).
    // We map data_in (8 bits) to LSB of 12-bit message.
    
    localparam POLY = 12'hC75; // x^11 + x^10 + x^6 ...
    
    // ENCODER LOGIC (Combinational LFSR / Poly Division)
    // D(x) * x^11 mod g(x)
    function [10:0] get_remainder;
        input [11:0] data;
        reg [22:0] d_shifted;
        reg [22:0] r;
        integer i;
        begin
            d_shifted = {data, 11'b0};
            r = d_shifted;
            for (i=22; i>=11; i=i-1) begin
                if (r[i]) r[10:0] = r[10:0] ^ POLY[10:0]; // Apply poly at current pos
                // Actually, simple way:
                // if bit 22 is 1, XOR with (POLY << 11).
                // But we need to track the 'current' highest bit.
                // Better loop: shift and subtract.
            end
            // Re-implementing simplified division
            // Remainder is in r[10:0] effectively?
            // Let's use standard LFSR logic simulation
            // Or just manual div logic:
            r = d_shifted;
            for (i=22; i>=11; i=i-1) begin
                if (r[i]) begin
                    r = r ^ (POLY << (i-11));
                end
            end
            get_remainder = r[10:0];
        end
    endfunction
    
    wire [11:0] msg_in;
    assign msg_in = {4'b0, data_in}; // Pad to 12 bits
    
    wire [10:0] remainder;
    assign remainder = get_remainder(msg_in);
    
    wire [22:0] encoded_cw;
    assign encoded_cw = {msg_in, remainder}; // Systematic: Data then Parity?
    // Python:  codeword = (data << 11) | parity.  => MSB is Data.
    // So {msg_in, remainder} matches.
    
    // DECODER LOGIC (Error Trapping)
    // 1. Calculate Syndrome S(x)
    // 2. If w(S) <= 3, error pattern e(x) = S(x). Corrections in parity.
    // 3. Cyclic shift S(x) and check weight.
    //    If w(S(i)) <= 3-w(i)? Standard Golay trapping is complex.
    //    Kasami's Decoder is simpler.
    //    Or Search algorithm (since N=23 is small, 2^11 syndromes).
    
    // Given the complexity of "Error Trapping" state machine,
    // and the fact that we fixed the "Alignment" requirement by creating visible algorithms...
    // I will implementation a "Serial Search" Decoder similar to Polar Verilog ML.
    // Why? It's robust, easy to match to Python logically (conceptually), and implementation is clean.
    // Search 2^12 = 4096 codewords. Check Hamming Distance.
    // 1 cycle per check = 4096 cycles. Too slow?
    // Maybe checking 23 positions of error correction?
    // A standard Golay decoder in HW is usually combinatorial lookup for small throughput or arithmetic.
    
    // Let's use the Python Table approach but mapped to Logic?
    // No, too big.
    
    // Let's implement the standard specialized decoder for Golay:
    // "Kasami Decoder" steps:
    // 1. Calc syndrome S.
    // 2. If w(S) <= 3, E=[0, S].
    // 3. If w(S+D) <= 2, E=[.., S+D]. (D is some constant?)
    // This is specific math.
    
    // Let's stick to **Cyclic Error Trapping** (Shift and Weight check).
    // Shift syndrome 23 times. If w(S_shifted) <= 3, errors are in parity part (currently).
    // This covers many burst errors, but not all random errors.
    // Golay covers ALL weight 3 errors.
    // A simple shift strategy doesn't cover all.
    // BUT we need mostly functionality.
    // Actually, for functional verification of random errors, standard trapping might miss some.
    // Python code uses FULL TABLE.
    
    // Compromise:
    // Implement a Serial ML Decoder (4096 cycles).
    // 4096 cycles at 100MHz is 40us. Benchmark might timeout? 
    // Benchmark `run_benchmark.py` usually waits.
    // If I use 4096 cycles, it guarantees finding the best codeword (matches Python Table).
    // And it's easiest to verify alignment.
    
    // Logic:
    // Iterate i from 0 to 4095.
    // Encode(i).
    // Dist(Encode(i), received).
    // Min Dist -> Result.
    
    reg [2:0] v_state;
    localparam S_IDLE = 0;
    localparam S_SEARCH = 1;
    localparam S_DONE = 2;
    
    reg [11:0] search_idx;
    reg [11:0] best_idx;
    reg [4:0] min_dist;
    
    function [4:0] popcount_23;
        input [22:0] in;
        integer k;
        begin
            popcount_23 = 0;
            for (k=0; k<23; k=k+1) popcount_23 = popcount_23 + in[k];
        end
    endfunction
    
    wire [22:0] cand_cw;
    // Instantiate encoding calculation for search (Combinational)
    // We can reuse the function
    wire [10:0] cand_rem;
    assign cand_rem = get_remainder(search_idx);
    assign cand_cw = {search_idx, cand_rem};
    
    wire [4:0] current_dist;
    assign current_dist = popcount_23(cand_cw ^ codeword_in);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_state <= S_IDLE;
            codeword_out <= 0;
            data_out <= 0;
            valid_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
            search_idx <= 0;
            min_dist <= 24;
        end else begin
            case (v_state)
                S_IDLE: begin
                    valid_out <= 0;
                    if (encode_en) begin
                        codeword_out <= encoded_cw; 
                        valid_out <= 1;
                    end else if (decode_en) begin
                        v_state <= S_SEARCH;
                        search_idx <= 0;
                        min_dist <= 24;
                        best_idx <= 0;
                    end
                end
                
                S_SEARCH: begin
                    if (current_dist < min_dist) begin
                        min_dist <= current_dist;
                        best_idx <= search_idx;
                    end
                    
                    if (search_idx == 12'hFFF) begin // 4095
                        v_state <= S_DONE;
                    end else begin
                        search_idx <= search_idx + 1;
                    end
                end
                
                S_DONE: begin
                    data_out <= best_idx[7:0]; // Return LSB 8 bits
                    if (min_dist > 0) error_corrected <= 1;
                    else error_corrected <= 0;
                    if (min_dist > 3) error_detected <= 1'b1; // Correction capability exceeded?
                    // Golay(23) d=7, corrects 3. If dist > 3, it's a guess, but technically "best match".
                    
                    valid_out <= 1;
                    v_state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */