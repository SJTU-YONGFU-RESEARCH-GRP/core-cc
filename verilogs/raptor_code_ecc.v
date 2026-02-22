/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module raptor_code_ecc #(
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

    // ----------------------------------------------------------------------
    // Combinational Parity Logic (Encode)
    // Python: Same as Raptor (i+j)%2 == 0 for parity rows.
    // ----------------------------------------------------------------------
    reg [PARITY_COUNT-1:0] parity_bits;
    always @(*) begin
        integer i, j;
        parity_bits = 0;
        for (i = 0; i < PARITY_COUNT; i = i + 1) begin
             // i is index of parity bit. Corresponds to row K+i in Generator Matrix
             // Python: if (row_idx + j) % 2 == 0. row_idx = K + i.
             for (j = 0; j < K; j = j + 1) begin
                 if (data_padded[j]) begin
                     if ((( (K+i) + j) % 2) == 0) begin
                         parity_bits[i] = parity_bits[i] ^ 1'b1;
                     end
                 end
             end
        end
    end

    // ----------------------------------------------------------------------
    // Syndrome Logic (Decode)
    // ----------------------------------------------------------------------
    reg [PARITY_COUNT-1:0] syndrome;
    always @(*) begin
        integer i, j;
        syndrome = 0;
        for (i = 0; i < PARITY_COUNT; i = i + 1) begin
            reg p_expected;
            p_expected = 0;
            for (j = 0; j < K; j = j + 1) begin
                if (codeword_in[j]) begin
                    if ((( (K+i) + j) % 2) == 0) begin
                        p_expected = p_expected ^ 1'b1;
                    end
                end
            end
            
            if (p_expected != codeword_in[K + i]) begin
                syndrome[i] = 1'b1;
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
            data_out <= codeword_in[DATA_WIDTH-1:0];
            error_detected <= (syndrome != 0);
            error_corrected <= 1'b0;
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
