/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off CMPCONST */
/* verilator lint_off SELRANGE */

// Convolutional ECC Module - Fully parameterized for DATA_WIDTH 4/8/16/32
// Rate 1/2, Constraint Length K=2
// Generator polynomials: g1 = 3 (0b11), g2 = 2 (0b10)
// Matches Python ConvolutionalECC implementation exactly
// Codeword width = (DATA_WIDTH + 2) * 2  (includes 2 tail bits)

module convolutional_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = (DATA_WIDTH + 2) * 2
) (
    input  wire                        clk,
    input  wire                        rst_n,
    input  wire                        encode_en,
    input  wire                        decode_en,
    input  wire [DATA_WIDTH-1:0]       data_in,
    input  wire [CODEWORD_WIDTH-1:0]   codeword_in,
    output reg  [CODEWORD_WIDTH-1:0]   codeword_out,
    output reg  [DATA_WIDTH-1:0]       data_out,
    output reg                          error_detected,
    output reg                          error_corrected,
    output reg                          valid_out
);

    // Configuration (matches Python ConvolutionalCode.__init__)
    localparam [1:0] G1 = 2'b11;  // g1 = 3
    localparam [1:0] G2 = 2'b10;  // g2 = 2
    localparam [31:0] K_TOTAL = DATA_WIDTH + 2;  // Data + 2 tail bits
    
    // ---------------------------------------------------------------
    // Encode: Rate 1/2 convolutional encoding with tail bits
    // Matches Python ConvolutionalECC.encode() exactly
    // ---------------------------------------------------------------
    reg [CODEWORD_WIDTH-1:0] encoded_codeword;
    
    always @(*) begin : encode_block
        integer i;
        reg [1:0] state;
        reg data_bit;
        reg o1, o2;
        
        encoded_codeword = 0;
        state = 2'b00;
        
        for (i = 0; i < K_TOTAL; i = i + 1) begin
            if (i < DATA_WIDTH) begin
                data_bit = data_in[i];
            end else begin
                data_bit = 1'b0;  // Tail bits
            end
            
            // state = ((state << 1) | bit) & 3
            state = {state[0], data_bit};
            
            // o1 = parity(state & g1), o2 = parity(state & g2)
            o1 = ^(state & G1);
            o2 = ^(state & G2);
            
            encoded_codeword[2*i]     = o1;
            encoded_codeword[2*i + 1] = o2;
        end
    end
    
    // ---------------------------------------------------------------
    // Decode: Deterministic reverse-lookup decoder
    // 
    // The code (g1=3, g2=2, K=2) has an UNAMBIGUOUS reverse mapping:
    // For every (state, o1, o2) there is exactly one input_bit.
    //
    // Reverse lookup table:
    //   state=00, o1=0,o2=0 -> input=0, next=00
    //   state=00, o1=1,o2=0 -> input=1, next=01
    //   state=01, o1=0,o2=1 -> input=1, next=11
    //   state=01, o1=1,o2=1 -> input=0, next=10
    //   state=10, o1=0,o2=0 -> input=0, next=00
    //   state=10, o1=1,o2=0 -> input=1, next=01
    //   state=11, o1=0,o2=1 -> input=1, next=11
    //   state=11, o1=1,o2=1 -> input=0, next=10
    //
    // Pattern: input_bit = o1 ^ state[0]
    //          (since state = {prev_state[0], prev_input_bit})
    //          and the reverse is deterministic for this specific code
    // ---------------------------------------------------------------
    
    // Reverse lookup function: given (state, o1, o2) returns {input_bit, next_state}
    function automatic [2:0] reverse_lookup;
        input [1:0] state;
        input o1;
        input o2;
        reg input_bit;
        reg [1:0] next_state;
        begin
            // Try input_bit=0
            next_state = {state[0], 1'b0};
            if ((^(next_state & G1)) == o1 && (^(next_state & G2)) == o2) begin
                reverse_lookup = {1'b0, next_state};
            end else begin
                // Must be input_bit=1
                next_state = {state[0], 1'b1};
                reverse_lookup = {1'b1, next_state};
            end
        end
    endfunction
    
    reg [DATA_WIDTH-1:0] decoded_data;
    reg decode_valid;
    
    always @(*) begin : decode_block
        integer i;
        reg [1:0] dec_state;
        reg recv_o1, recv_o2;
        reg [2:0] lookup_result;
        reg input_bit;
        reg valid;
        reg [1:0] check_ns;
        
        decoded_data = 0;
        dec_state = 2'b00;  // Start at state 0 (same as encoder)
        valid = 1'b1;
        
        for (i = 0; i < K_TOTAL; i = i + 1) begin
            recv_o1 = codeword_in[2*i];
            recv_o2 = codeword_in[2*i + 1];
            
            // Reverse lookup
            lookup_result = reverse_lookup(dec_state, recv_o1, recv_o2);
            input_bit = lookup_result[2];
            dec_state = lookup_result[1:0];
            
            // Verify the lookup is correct
            check_ns = {dec_state[1], input_bit};
            if ((^(dec_state & G1)) != recv_o1 || (^(dec_state & G2)) != recv_o2) begin
                valid = 1'b0;
            end
            
            // Store data bit (only first DATA_WIDTH bits, not tail)
            if (i < DATA_WIDTH) begin
                decoded_data[i] = input_bit;
            end
        end
        
        decode_valid = valid;
    end

    // Encoder output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            codeword_out <= {CODEWORD_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end else if (encode_en) begin
            codeword_out <= encoded_codeword;
            valid_out <= 1'b1;
        end else if (decode_en) begin
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

    // Decoder output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_WIDTH{1'b0}};
            error_detected <= 1'b0;
            error_corrected <= 1'b0;
        end else if (decode_en) begin
            data_out <= decoded_data;
            error_detected <= ~decode_valid;
            error_corrected <= decode_valid;
        end
    end

endmodule
/* verilator lint_on WIDTHEXPAND */
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on CMPCONST */