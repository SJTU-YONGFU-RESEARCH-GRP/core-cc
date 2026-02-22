/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off LATCH */
module primary_secondary_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [2*DATA_WIDTH-1:0] codeword_in, 
    output reg  [2*DATA_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]   data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    localparam K = (DATA_WIDTH <= 4) ? 4 :
                   (DATA_WIDTH <= 8) ? 8 :
                   (DATA_WIDTH <= 16) ? 16 :
                   (DATA_WIDTH <= 32) ? 32 :
                   (DATA_WIDTH <= 64) ? 64 : 128;
                   
    localparam N = 2 * K;
    localparam PARITY_COUNT = N - K;

    wire [K-1:0] data_padded = {{(K-DATA_WIDTH){1'b0}}, data_in};

    reg [PARITY_COUNT-1:0] parity_bits;
    always @(*) begin
        integer i, j;
        parity_bits = 0;
        for (i = 0; i < PARITY_COUNT; i = i + 1) begin
            for (j = 0; j < K; j = j + 1) begin
                if (data_padded[j]) begin
                    if (((j + (K + i)) % 2) == 0) begin
                        parity_bits[i] = parity_bits[i] ^ 1'b1;
                    end
                end
            end
        end
    end

    reg [PARITY_COUNT-1:0] syndrome;
    always @(*) begin
        integer i, j;
        syndrome = 0;
        for (i = 0; i < PARITY_COUNT; i = i + 1) begin
            reg p_expected;
            p_expected = 0;
            for (j = 0; j < K; j = j + 1) begin
                if (codeword_in[j]) begin
                    if (((j + (K + i)) % 2) == 0) begin
                        p_expected = p_expected ^ 1'b1;
                    end
                end
            end
            
            if (p_expected != codeword_in[K + i]) begin
                syndrome[i] = 1'b1;
            end
        end
    end
    
    reg [N-1:0] corrected_cw;
    reg correction_success;
    
    // Explicitly disable LATCH warning if we are confident, or fix it logic.
    // Logic: Iterate b=0..N-1. If flipping bit b fixes syndrome, select it.
    // This is equivalent to finding which bit matches syndrome pattern.
    // To be perfectly safe, we calculate ALL candidate syndromes?
    
    always @(*) begin
        integer b, i, j;
        reg [PARITY_COUNT-1:0] s_flip;
        reg [N-1:0] cw_flip;
        reg match;
        
        corrected_cw = codeword_in;
        correction_success = 0;
        
        if (syndrome != 0) begin
            for (b = 0; b < N; b = b + 1) begin
                // Re-calculate syndrome for codeword with bit b flipped
                // This is equivalent to checking if syndrome == syndrome_of_error_pattern(b).
                // Syndrome is linear. S(r+e) = S(r) + S(e).
                // So S(r^e) = S(r) ^ S(e).
                // We want S(corrected) = 0 => S(r) ^ S(e) = 0 => S(r) = S(e).
                // So we just need to check if current syndrome matches the syndrome of a single bit error at b.
                
                // Calculate Syndrome of Error Pattern (1<<b)
                s_flip = 0;
                // Error pattern has 1 at bit b.
                // If b < K (data bit):
                //    It affects parity bits i where ((b + (K+i)) % 2) == 0.
                // If b >= K (parity bit):
                //    It affects parity bit (b-K) only.
                
                if (b < K) begin
                    for (i = 0; i < PARITY_COUNT; i = i + 1) begin
                        if (((b + (K + i)) % 2) == 0) begin
                            s_flip[i] = 1'b1;
                        end
                    end
                end else begin
                    // Parity bit error
                    s_flip[b - K] = 1'b1;
                end
                
                if (syndrome == s_flip) begin
                     corrected_cw = codeword_in ^ ({{(N-1){1'b0}}, 1'b1} << b);
                     correction_success = 1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {(2*DATA_WIDTH){1'b0}};
            valid_out <= 1'b0;
        end else if (encode_en) begin
            codeword_out <= {parity_bits, data_in}; 
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
        end else if (decode_en) begin
            if (syndrome == 0) begin
                 data_out <= codeword_in[DATA_WIDTH-1:0];
                 error_detected <= 1'b0;
                 error_corrected <= 1'b0;
            end else begin
                 data_out <= corrected_cw[DATA_WIDTH-1:0];
                 error_detected <= 1'b1;
                 error_corrected <= correction_success;
            end
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
/* verilator lint_on LATCH */