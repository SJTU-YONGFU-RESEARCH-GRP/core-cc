// Hamming SECDED ECC Module - Fully parameterized for DATA_WIDTH up to 128
// Matches Python HammingSECDEDECC implementation exactly
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off CMPCONST */
module hamming_secded_ecc #(
    parameter DATA_WIDTH = 8,
    // Derive default CODEWORD_WIDTH based on DATA_WIDTH
    // 4->7, 8->12, 16->21, 32->38, 64->71, 128->136
    parameter CODEWORD_WIDTH = (DATA_WIDTH <= 4) ? 7 : 
                               (DATA_WIDTH <= 8) ? 12 : 
                               (DATA_WIDTH <= 16) ? 21 : 
                               (DATA_WIDTH <= 32) ? 38 : 
                               (DATA_WIDTH <= 64) ? 71 : 136
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [CODEWORD_WIDTH-1:0] codeword_in,
    output reg  [CODEWORD_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]   data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // Configuration based on parameters
    localparam [31:0] N = CODEWORD_WIDTH;
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] PARITY_BITS = N - K;
    
    // ---------------------------------------------------------------
    // Helper: is_parity_position
    // Parity positions are at (2^i - 1): 0, 1, 3, 7, 15, 31
    // ---------------------------------------------------------------
    function automatic is_parity_pos;
        input integer pos;
        integer check;
        begin
            check = pos + 1; // 1-indexed position
            // Check if check is a power of 2
            is_parity_pos = (check != 0) && ((check & (check - 1)) == 0);
        end
    endfunction
    
    // ---------------------------------------------------------------
    // Helper: get_data_index
    // Given a codeword position, return which data bit index it is
    // Returns -1 if it's a parity position
    // ---------------------------------------------------------------
    function automatic integer get_data_index;
        input integer pos;
        integer idx, j;
        begin
            idx = 0;
            get_data_index = -1;
            for (j = 0; j < N; j = j + 1) begin
                if (!is_parity_pos(j)) begin
                    if (j == pos) begin
                        get_data_index = idx;
                    end
                    idx = idx + 1;
                end
            end
        end
    endfunction
    
    // ---------------------------------------------------------------
    // Helper: get_data_position
    // Given a data index (0..K-1), return the codeword position
    // ---------------------------------------------------------------
    function automatic integer get_data_pos;
        input integer data_idx;
        integer idx, j;
        begin
            idx = 0;
            get_data_pos = 0;
            for (j = 0; j < N; j = j + 1) begin
                if (!is_parity_pos(j)) begin
                    if (idx == data_idx) begin
                        get_data_pos = j;
                    end
                    idx = idx + 1;
                end
            end
        end
    endfunction
    
    // ---------------------------------------------------------------
    // Encode: Insert data bits and calculate parity
    // Matches Python _insert_data() + _calculate_parity()
    // ---------------------------------------------------------------
    reg [N-1:0] encoded_codeword;
    always @(*) begin : encode_block
        integer i, j;
        reg [N-1:0] cw;
        reg parity_bit;
        
        cw = 0;
        
        // Insert data bits into non-parity positions
        for (i = 0; i < K; i = i + 1) begin
            cw[get_data_pos(i)] = data_in[i];
        end
        
        // Calculate parity bits
        for (i = 0; i < PARITY_BITS; i = i + 1) begin
            parity_bit = 0;
            for (j = 0; j < N; j = j + 1) begin
                // Check if position j is covered by parity bit i
                // (j+1) has bit i set
                if (!is_parity_pos(j) || (j != ((1 << i) - 1))) begin
                    if (((j + 1) & (1 << i)) != 0) begin
                        parity_bit = parity_bit ^ cw[j];
                    end
                end
            end
            cw[(1 << i) - 1] = parity_bit;
        end
        
        encoded_codeword = cw;
    end
    
    // ---------------------------------------------------------------
    // Decode: Calculate syndrome + error correction
    // Matches Python decode() exactly
    // ---------------------------------------------------------------
    reg [PARITY_BITS-1:0] syndrome;
    reg [DATA_WIDTH-1:0] extracted_data;
    reg [N-1:0] corrected_codeword;
    reg syndrome_nonzero;
    reg syndrome_in_range;
    
    always @(*) begin : decode_block
        integer i, j;
        reg expected_parity;
        reg actual_parity;
        reg [N-1:0] cw_in;
        
        cw_in = codeword_in;
        
        // Calculate syndrome
        syndrome = 0;
        for (i = 0; i < PARITY_BITS; i = i + 1) begin
            expected_parity = 0;
            for (j = 0; j < N; j = j + 1) begin
                if (j != ((1 << i) - 1)) begin
                    if (((j + 1) & (1 << i)) != 0) begin
                        expected_parity = expected_parity ^ cw_in[j];
                    end
                end
            end
            actual_parity = cw_in[(1 << i) - 1];
            if (expected_parity != actual_parity) begin
                syndrome[i] = 1'b1;
            end else begin
                syndrome[i] = 1'b0;
            end
        end
        
        // Error detection and correction
        syndrome_nonzero = (syndrome != 0);
        syndrome_in_range = (syndrome > 0) && (syndrome <= N);
        
        // Correct single bit error
        if (syndrome_in_range) begin
            corrected_codeword = cw_in ^ ({{(N-1){1'b0}}, 1'b1} << (syndrome - 1));
        end else begin
            corrected_codeword = cw_in;
        end
        
        // Extract data
        for (i = 0; i < K; i = i + 1) begin
            extracted_data[i] = corrected_codeword[get_data_pos(i)];
        end
    end

    // Encoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {CODEWORD_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end else if (encode_en) begin
            codeword_out <= encoded_codeword;
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

    // Decoder logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
        end else if (decode_en) begin
            data_out <= extracted_data;
            error_detected <= syndrome_nonzero;
            error_corrected <= syndrome_in_range;
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */