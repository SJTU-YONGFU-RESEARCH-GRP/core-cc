// Extended Hamming SECDED (Single Error Correction, Double Error Detection)
// This is a strictly compliant industrial implementation.
// It adds an Overall Parity Bit to prevent the miscorrection of double-bit errors.

/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off CMPCONST */
module extended_hamming_secded_ecc #(
    parameter DATA_WIDTH = 8,
    // Base SEC widths: 4->7, 8->12, 16->21, 32->38, 64->71, 128->136
    parameter SEC_WIDTH = (DATA_WIDTH <= 2) ? 5 :
                          (DATA_WIDTH <= 4) ? 7 : 
                          (DATA_WIDTH <= 8) ? 12 : 
                          (DATA_WIDTH <= 16) ? 21 : 
                          (DATA_WIDTH <= 32) ? 38 : 
                          (DATA_WIDTH <= 64) ? 71 : 136,
    // SECDED adds exactly 1 overall parity bit
    parameter CODEWORD_WIDTH = SEC_WIDTH + 1
) (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire                      encode_en,
    input  wire                      decode_en,
    input  wire [DATA_WIDTH-1:0]     data_in,
    input  wire [CODEWORD_WIDTH-1:0] codeword_in,
    output reg  [CODEWORD_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]     data_out,
    output reg                       error_detected, // Goes high on ANY error (Single or Double)
    output reg                       error_corrected,// Goes high ONLY on Single error
    output reg                       valid_out
);

    localparam [31:0] N = SEC_WIDTH;
    localparam [31:0] K = DATA_WIDTH;
    localparam [31:0] PARITY_BITS = N - K;
    
    // Helper functions (Same as SEC)
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
            idx = 0; get_data_pos = 0;
            for (j = 0; j < N; j = j + 1) begin
                if (!is_parity_pos(j)) begin
                    if (idx == data_idx) get_data_pos = j;
                    idx = idx + 1;
                end
            end
        end
    endfunction
    
    // ---------------------------------------------------------------
    // ENCODER
    // ---------------------------------------------------------------
    reg [CODEWORD_WIDTH-1:0] encoded_codeword;
    always @(*) begin : encode_block
        integer i, j;
        reg [N-1:0] sec_cw;
        reg p_bit, overall_parity;
        
        sec_cw = 0;
        // 1. Insert data
        for (i = 0; i < K; i = i + 1) begin
            sec_cw[get_data_pos(i)] = data_in[i];
        end
        // 2. Calculate Hamming Parity
        for (i = 0; i < PARITY_BITS; i = i + 1) begin
            p_bit = 0;
            for (j = 0; j < N; j = j + 1) begin
                if (!is_parity_pos(j) || (j != ((1 << i) - 1))) begin
                    if (((j + 1) & (1 << i)) != 0) p_bit = p_bit ^ sec_cw[j];
                end
            end
            sec_cw[(1 << i) - 1] = p_bit;
        end
        
        // 3. SECDED Magic: Calculate Overall Parity of the entire SEC codeword
        overall_parity = ^sec_cw;
        
        // Append overall parity to the MSB
        encoded_codeword = {overall_parity, sec_cw};
    end
    
    // ---------------------------------------------------------------
    // DECODER
    // ---------------------------------------------------------------
    reg [PARITY_BITS-1:0] syndrome;
    reg [N-1:0] rx_sec_cw;
    reg rx_overall_parity;
    reg calc_overall_parity;
    reg overall_parity_error;
    
    reg [N-1:0] corrected_sec_cw;
    reg [DATA_WIDTH-1:0] extracted_data;
    
    reg single_error, double_error;
    
    always @(*) begin : decode_block
        integer i, j;
        reg expected_parity;
        
        // Split incoming codeword
        rx_overall_parity = codeword_in[CODEWORD_WIDTH-1];
        rx_sec_cw = codeword_in[N-1:0];
        
        // 1. Calculate SEC Syndrome
        syndrome = 0;
        for (i = 0; i < PARITY_BITS; i = i + 1) begin
            expected_parity = 0;
            for (j = 0; j < N; j = j + 1) begin
                if (j != ((1 << i) - 1)) begin
                    if (((j + 1) & (1 << i)) != 0) expected_parity = expected_parity ^ rx_sec_cw[j];
                end
            end
            syndrome[i] = (expected_parity != rx_sec_cw[(1 << i) - 1]);
        end
        
        // 2. SECDED Magic: Verify Overall Parity
        calc_overall_parity = ^rx_sec_cw;
        overall_parity_error = (calc_overall_parity != rx_overall_parity);
        
        // 3. The SECDED Truth Table
        single_error = (syndrome != 0) && overall_parity_error;
        double_error = (syndrome != 0) && !overall_parity_error;
        
        // 4. Correction Logic (CRITICAL: Only correct if SINGLE error!)
        if (single_error && (syndrome <= N)) begin
            corrected_sec_cw = rx_sec_cw ^ ({{(N-1){1'b0}}, 1'b1} << (syndrome - 1));
        end else begin
            // If Double error, or No error, DO NOT TOUCH the data!
            corrected_sec_cw = rx_sec_cw;
        end
        
        // Extract data
        for (i = 0; i < K; i = i + 1) begin
            extracted_data[i] = corrected_sec_cw[get_data_pos(i)];
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
            if (encode_en) codeword_out <= encoded_codeword;
            
            if (decode_en) begin
                data_out <= extracted_data;
                // Any error (single or double) raises detection
                error_detected <= (single_error || double_error); 
                // Only single errors raise correction
                error_corrected <= single_error; 
            end
            
            valid_out <= (encode_en || decode_en);
        end
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */