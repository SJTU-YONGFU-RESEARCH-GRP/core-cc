// Extended Hamming ECC Module - Fully parameterized for DATA_WIDTH 4/8/16/32/64/128
// Uses Hamming SECDED + 1 Algorithm
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off CMPCONST */
/* verilator lint_off SELRANGE */
module extended_hamming_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]   data_in,
    input  wire [137:0]            codeword_in, // Max width for 128-bit data (128+9=137)
    output reg  [137:0]            codeword_out,
    output reg  [DATA_WIDTH-1:0]   data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // ---------------------------------------------------------------
    // Parameter Derivation
    // ---------------------------------------------------------------
    // Calculate Hamming parameters first
    // N_HAMMING: Total bits for standard Hamming code
    localparam [31:0] N_HAMMING = (DATA_WIDTH <= 4) ? 7 : 
                                  (DATA_WIDTH <= 8) ? 12 : 
                                  (DATA_WIDTH <= 16) ? 21 : 
                                  (DATA_WIDTH <= 32) ? 38 : 
                                  (DATA_WIDTH <= 64) ? 71 : 136; // 128 data + 8 parity for Hamming
                                  
    // Total encoded length = Hamming bits + 1 extended parity bit
    localparam [31:0] N_TOTAL = N_HAMMING + 1;
    
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] PARITY_BITS_HAMMING = N_HAMMING - K;
    
    // ---------------------------------------------------------------
    // Helper Functions (Identical to hamming_secded_ecc)
    // ---------------------------------------------------------------
    function automatic is_parity_pos;
        input integer pos;
        integer check;
        begin
            check = pos + 1;
            is_parity_pos = (check != 0) && ((check & (check - 1)) == 0);
        end
    endfunction
    
    function automatic integer get_data_pos;
        input integer data_idx;
        integer idx, j;
        begin
            idx = 0;
            get_data_pos = 0;
            for (j = 0; j < N_HAMMING; j = j + 1) begin
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
    // Encoder Logic
    // ---------------------------------------------------------------
    reg extended_parity_bit_enc;
    reg [N_TOTAL-1:0] full_encoded_word;
    reg [N_HAMMING-1:0] hamming_codeword_enc; // Added missing declaration

    always @(*) begin : encode_block
        integer i, j;
        reg [N_HAMMING-1:0] cw;
        reg parity_bit;
        
        cw = 0;
        
        // 1. Place data bits (Standard Hamming)
        for (i = 0; i < K; i = i + 1) begin
            cw[get_data_pos(i)] = data_in[i];
        end
        
        // 2. Calculate Hamming parity bits
        for (i = 0; i < PARITY_BITS_HAMMING; i = i + 1) begin
            parity_bit = 0;
            for (j = 0; j < N_HAMMING; j = j + 1) begin
                if (!is_parity_pos(j) || (j != ((1 << i) - 1))) begin
                    if (((j + 1) & (1 << i)) != 0) begin
                        parity_bit = parity_bit ^ cw[j];
                    end
                end
            end
            cw[(1 << i) - 1] = parity_bit;
        end
        
        hamming_codeword_enc = cw;
        
        // 3. Calculate Extended Parity (parity of the entire Hamming codeword)
        extended_parity_bit_enc = ^cw;
        
        // 4. Assemble full codeword: [ExtendedParity, HammingCodeword]
        // Note: Python implementation puts extended parity at the end (highest bit index usually, or appended)
        // Python: codeword = hamming_codeword | (extended_parity << self.extended_parity_position)
        // The extended position is usually N_HAMMING.
        full_encoded_word = {extended_parity_bit_enc, cw};
    end

    // ---------------------------------------------------------------
    // Decoder Logic
    // ---------------------------------------------------------------
    reg [N_HAMMING-1:0] hamming_codeword_in;
    reg extended_parity_in;
    reg [PARITY_BITS_HAMMING-1:0] syndrome;
    reg calculated_extended_parity;
    reg extended_parity_error;
    reg syndrome_in_range;
    
    reg [N_HAMMING-1:0] corrected_hamming_codeword;
    reg [K-1:0] final_data;
    
    // Status flags
    reg s_error, d_error; // Single, Double
    reg syndrome_nonzero; // Added missing declaration

    always @(*) begin : decode_block
        integer i, j;
        reg expected_p;
        reg actual_p;
        
        // Extract parts
        hamming_codeword_in = codeword_in[N_HAMMING-1:0];
        extended_parity_in = codeword_in[N_HAMMING];
        
        // 1. Calculate Hamming Syndrome
        syndrome = 0;
        for (i = 0; i < PARITY_BITS_HAMMING; i = i + 1) begin
            expected_p = 0;
            for (j = 0; j < N_HAMMING; j = j + 1) begin
                if (j != ((1 << i) - 1)) begin
                    if (((j + 1) & (1 << i)) != 0) begin
                        expected_p = expected_p ^ hamming_codeword_in[j];
                    end
                end
            end
            actual_p = hamming_codeword_in[(1 << i) - 1];
            if (expected_p != actual_p) begin
                syndrome[i] = 1'b1;
            end
        end
        
        // 2. Check Extended Parity
        calculated_extended_parity = ^hamming_codeword_in;
        extended_parity_error = (calculated_extended_parity != extended_parity_in);
        
        // 3. Analyze Errors
        syndrome_nonzero = (syndrome != 0);
        syndrome_in_range = (syndrome > 0) && (syndrome <= N_HAMMING);
        
        s_error = 0;
        d_error = 0;
        corrected_hamming_codeword = hamming_codeword_in;
        
        if (syndrome == 0) begin
            if (extended_parity_error) begin
                // Error in extended parity bit only -> Corrected (ignore it)
                s_error = 1;
            end
            // Else no error
        end else begin
            if (extended_parity_error) begin
                // Syndrome != 0 AND Parity Error -> Single Bit Error in Hamming part
                s_error = 1;
                if (syndrome_in_range) begin
                    corrected_hamming_codeword = hamming_codeword_in ^ ({{(N_HAMMING-1){1'b0}}, 1'b1} << (syndrome - 1));
                end
            end else begin
                // Syndrome != 0 BUT Parity OK -> Double Bit Error (even number of errors)
                d_error = 1;
            end
        end
        
        // 4. Extract Data
        for (i = 0; i < K; i = i + 1) begin
            final_data[i] = corrected_hamming_codeword[get_data_pos(i)];
        end
    end

    // ---------------------------------------------------------------
    // Sequential Logic
    // ---------------------------------------------------------------
    // Encoder Output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= 138'b0;
            valid_out <= 1'b0;
        end else if (encode_en) begin
            codeword_out <= {{(138-N_TOTAL){1'b0}}, full_encoded_word};
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
    
    // Decoder Output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
        end else if (decode_en) begin
            data_out <= final_data;
            // Error Reporting Logic
            if (s_error) begin
                error_detected <= 1'b0; // Single errors are corrected, so "detected" (uncorrectable) is low?
                                        // Wait, usually error_detected means "any error seen".
                                        // But in previous implementation: 
                                        // "Single errors are corrected" -> error_detected = 0, error_corrected = 1
                                        // "Double errors are detected" -> error_detected = 1, error_corrected = 0
                error_detected <= 1'b0; 
                error_corrected <= 1'b1;
            end else if (d_error) begin
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end else begin
                error_detected <= 1'b0;
                error_corrected <= 1'b0;
            end
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
