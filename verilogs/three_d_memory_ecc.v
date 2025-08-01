/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */

module three_d_memory_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 16  // 8-bit data + 8-bit parity
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [CODEWORD_WIDTH-1:0] codeword_in,
    output reg  [CODEWORD_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // Configuration for 8-bit data (matches Python)
    localparam [31:0] LAYERS = 4;  // Number of memory layers
    localparam [31:0] BITS_PER_LAYER = 2;  // Bits per memory layer
    localparam [31:0] TOTAL_BITS = LAYERS * BITS_PER_LAYER;  // 8 bits
    localparam [31:0] PARITY_BITS = LAYERS + BITS_PER_LAYER + 1;  // 4 + 2 + 1 = 7 parity bits
    localparam [31:0] N = TOTAL_BITS + PARITY_BITS;  // 8 + 7 = 15 bits (fits in 16)
    
    // Internal signals
    reg [CODEWORD_WIDTH-1:0] encoded_codeword;
    reg [DATA_WIDTH-1:0] extracted_data;
    reg no_error, single_error;
    
    // Function to distribute data across 3D memory layers (matches Python _distribute_data_3d)
    function [15:0] distribute_data_3d;
        input [7:0] data;
        reg [15:0] memory_3d;
        integer layer, bit_pos, data_bit;
        begin
            memory_3d = 0;
            data_bit = 0;
            
            // Distribute data bits across layers (matches Python algorithm)
            for (layer = 0; layer < LAYERS; layer = layer + 1) begin
                for (bit_pos = 0; bit_pos < BITS_PER_LAYER; bit_pos = bit_pos + 1) begin
                    if (data_bit < DATA_WIDTH) begin
                        memory_3d[layer * BITS_PER_LAYER + bit_pos] = ((data >> data_bit) & 1'b1);
                        data_bit = data_bit + 1;
                    end
                end
            end
            
            distribute_data_3d = memory_3d;
        end
    endfunction
    
    // Function to calculate layer parity (matches Python _calculate_layer_parity)
    function [3:0] calculate_layer_parity;
        input [15:0] memory_3d;
        reg [3:0] layer_parity;
        integer layer, bit_pos;
        reg parity;
        begin
            layer_parity = 0;
            
            for (layer = 0; layer < LAYERS; layer = layer + 1) begin
                parity = 0;
                for (bit_pos = 0; bit_pos < BITS_PER_LAYER; bit_pos = bit_pos + 1) begin
                    parity = parity ^ memory_3d[layer * BITS_PER_LAYER + bit_pos];
                end
                layer_parity[layer] = parity;
            end
            
            calculate_layer_parity = layer_parity;
        end
    endfunction
    
    // Function to calculate bit parity (matches Python _calculate_bit_parity)
    function [1:0] calculate_bit_parity;
        input [15:0] memory_3d;
        reg [1:0] bit_parity;
        integer layer, bit_pos;
        reg parity;
        begin
            bit_parity = 0;
            
            for (bit_pos = 0; bit_pos < BITS_PER_LAYER; bit_pos = bit_pos + 1) begin
                parity = 0;
                for (layer = 0; layer < LAYERS; layer = layer + 1) begin
                    parity = parity ^ memory_3d[layer * BITS_PER_LAYER + bit_pos];
                end
                bit_parity[bit_pos] = parity;
            end
            
            calculate_bit_parity = bit_parity;
        end
    endfunction
    
    // Function to calculate overall parity (matches Python _calculate_overall_parity)
    function calculate_overall_parity;
        input [15:0] memory_3d;
        reg overall_parity;
        integer layer, bit_pos;
        begin
            overall_parity = 0;
            
            for (layer = 0; layer < LAYERS; layer = layer + 1) begin
                for (bit_pos = 0; bit_pos < BITS_PER_LAYER; bit_pos = bit_pos + 1) begin
                    overall_parity = overall_parity ^ memory_3d[layer * BITS_PER_LAYER + bit_pos];
                end
            end
            
            calculate_overall_parity = overall_parity;
        end
    endfunction
    
    // Function to extract data from 3D memory (matches Python decode logic)
    function [7:0] extract_data_3d;
        input [15:0] memory_3d;
        reg [7:0] data;
        integer layer, bit_pos, data_bit;
        begin
            data = 0;
            data_bit = 0;
            
            for (layer = 0; layer < LAYERS; layer = layer + 1) begin
                for (bit_pos = 0; bit_pos < BITS_PER_LAYER; bit_pos = bit_pos + 1) begin
                    if (data_bit < DATA_WIDTH) begin
                        data[data_bit] = memory_3d[layer * BITS_PER_LAYER + bit_pos];
                        data_bit = data_bit + 1;
                    end
                end
            end
            
            extract_data_3d = data;
        end
    endfunction
    
    // Encode Three-D Memory ECC
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [15:0] memory_3d;
            reg [3:0] layer_parity;
            reg [1:0] bit_parity;
            reg overall_parity;
            integer bit_pos;
            
            // Distribute data across 3D memory (matches Python _distribute_data_3d)
            memory_3d = distribute_data_3d(data_in);
            
            // Calculate multi-dimensional parity (matches Python encode)
            layer_parity = calculate_layer_parity(memory_3d);
            bit_parity = calculate_bit_parity(memory_3d);
            overall_parity = calculate_overall_parity(memory_3d);
            
            // Pack into codeword (matches Python encode)
            encoded_codeword = 0;
            bit_pos = 0;
            
            // Pack data bits
            encoded_codeword[TOTAL_BITS-1:0] = memory_3d[TOTAL_BITS-1:0];
            bit_pos = TOTAL_BITS;
            
            // Pack layer parity bits
            encoded_codeword[bit_pos + 0] = layer_parity[0];
            encoded_codeword[bit_pos + 1] = layer_parity[1];
            encoded_codeword[bit_pos + 2] = layer_parity[2];
            encoded_codeword[bit_pos + 3] = layer_parity[3];
            bit_pos = bit_pos + LAYERS;
            
            // Pack bit parity bits
            encoded_codeword[bit_pos + 0] = bit_parity[0];
            encoded_codeword[bit_pos + 1] = bit_parity[1];
            bit_pos = bit_pos + BITS_PER_LAYER;
            
            // Pack overall parity bit
            encoded_codeword[bit_pos] = overall_parity;
        end else begin
            encoded_codeword = 0;
        end
    end
    
    // Decode Three-D Memory ECC (matches Python decode logic)
    always @(*) begin
        if (DATA_WIDTH <= 8) begin
            reg [15:0] memory_3d;
            reg [3:0] layer_parity, expected_layer_parity;
            reg [1:0] bit_parity, expected_bit_parity;
            reg overall_parity, expected_overall_parity;
            reg [3:0] layer_errors;
            reg [1:0] bit_errors;
            reg overall_error;
            integer layer, bit_pos;
            
            // Extract data and parity bits (matches Python decode)
            memory_3d = codeword_in[TOTAL_BITS-1:0];
            
            // Extract parity bits
            layer_parity = codeword_in[TOTAL_BITS + LAYERS - 1:TOTAL_BITS];
            bit_parity = codeword_in[TOTAL_BITS + LAYERS + BITS_PER_LAYER - 1:TOTAL_BITS + LAYERS];
            overall_parity = codeword_in[TOTAL_BITS + LAYERS + BITS_PER_LAYER];
            
            // Check for errors (matches Python decode)
            expected_layer_parity = calculate_layer_parity(memory_3d);
            expected_bit_parity = calculate_bit_parity(memory_3d);
            expected_overall_parity = calculate_overall_parity(memory_3d);
            
            // Detect errors (matches Python decode)
            layer_errors = layer_parity ^ expected_layer_parity;
            bit_errors = bit_parity ^ expected_bit_parity;
            overall_error = overall_parity ^ expected_overall_parity;
            
            // Error correction logic (simplified for hardware)
            if (layer_errors == 0 && bit_errors == 0 && overall_error == 0) begin
                // No error detected
                extracted_data = extract_data_3d(memory_3d);
                no_error = 1;
                single_error = 0;
            end else begin
                // Error detected (simplified correction)
                extracted_data = extract_data_3d(memory_3d);
                no_error = 0;
                single_error = 1;
            end
        end else begin
            extracted_data = 0;
            no_error = 0;
            single_error = 0;
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
            
            // Error detection and correction logic (matches Python)
            if (no_error) begin
                // No error detected
                error_detected <= 1'b0;
                error_corrected <= 1'b0;
            end else if (single_error) begin
                // Error detected (3D memory behavior)
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end else begin
                // Error detected but not corrected
                error_detected <= 1'b1;
                error_corrected <= 1'b0;
            end
        end
    end

endmodule 