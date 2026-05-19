// Hamming SEC (Single Error Correction) ECC Module
// WARNING: This module CANNOT reliably detect double-bit errors. 
// Double-bit errors will likely cause miscorrection.

/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off CMPCONST */
module hamming_sec_ecc #(
    parameter DATA_WIDTH = 8,
    // Standard Hamming codeword widths (NO overall parity bit)
    // 4->7, 8->12, 16->21, 32->38, 64->71, 128->136
    parameter CODEWORD_WIDTH = (DATA_WIDTH <= 2) ? 5 :
                               (DATA_WIDTH <= 4) ? 7 : 
                               (DATA_WIDTH <= 8) ? 12 : 
                               (DATA_WIDTH <= 16) ? 21 : 
                               (DATA_WIDTH <= 32) ? 38 : 
                               (DATA_WIDTH <= 64) ? 71 : 136
) (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire                      encode_en,
    input  wire                      decode_en,
    input  wire [DATA_WIDTH-1:0]     data_in,
    input  wire [CODEWORD_WIDTH-1:0] codeword_in,
    output reg  [CODEWORD_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]     data_out,
    output reg                       error_detected,
    output reg                       error_corrected,
    output reg                       valid_out
);

    localparam [31:0] N = CODEWORD_WIDTH;
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] PARITY_BITS = N - K;
    
    // Helper: is_parity_position (1-indexed power of 2)
    function automatic is_parity_pos;
        input integer pos;
        integer check;
        begin
            check = pos + 1; 
            is_parity_pos = (check != 0) && ((check & (check - 1)) == 0);
        end
    endfunction
    
    // Helper: get_data_position
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
    // ENCODER (Strictly uses data_in)
    // ---------------------------------------------------------------
    reg [N-1:0] encoded_codeword;
    always @(*) begin : encode_block
        integer i, j;
        reg [N-1:0] cw;
        reg parity_bit;
        
        cw = 0;
        
        // Insert data bits
        for (i = 0; i < K; i = i + 1) begin
            cw[get_data_pos(i)] = data_in[i];
        end
        
        // Calculate Hamming parity bits
        for (i = 0; i < PARITY_BITS; i = i + 1) begin
            parity_bit = 0;
            for (j = 0; j < N; j = j + 1) begin
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
    // DECODER (Strictly uses codeword_in)
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
        syndrome = 0;
        
        // Calculate Syndrome
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
            syndrome[i] = (expected_parity != actual_parity);
        end
        
        syndrome_nonzero = (syndrome != 0);
        syndrome_in_range = (syndrome > 0) && (syndrome <= N);
        
        // Correct single bit error (VULNERABLE TO DOUBLE-BIT ERRORS)
        if (syndrome_in_range) begin
            corrected_codeword = cw_in ^ ({{(N-1){1'b0}}, 1'b1} << (syndrome - 1));
        end else begin
            corrected_codeword = cw_in;
        end
        
        // Extract corrected data
        for (i = 0; i < K; i = i + 1) begin
            extracted_data[i] = corrected_codeword[get_data_pos(i)];
        end
    end

    // ---------------------------------------------------------------
    // SEQUENTIAL REGISTERS
    // ---------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {CODEWORD_WIDTH{1'b0}};
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (encode_en) begin
                codeword_out <= encoded_codeword;
            end
            
            if (decode_en) begin
                data_out <= extracted_data;
                error_detected <= syndrome_nonzero;
                error_corrected <= syndrome_in_range;
            end
            
            valid_out <= (encode_en || decode_en);
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */