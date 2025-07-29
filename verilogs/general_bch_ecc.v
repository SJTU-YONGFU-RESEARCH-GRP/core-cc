// General BCH ECC Module
// Supports different BCH configurations: (7,4,1), (15,7,2), (31,16,3), (63,32,6)
// Parameterized design for flexibility

module general_bch_encoder #(
    parameter DATA_WIDTH = 7,    // k: data width
    parameter CODE_WIDTH = 15,   // n: codeword width
    parameter PARITY_WIDTH = 8   // n-k: parity width
)(
    input  [DATA_WIDTH-1:0] data_in,
    output [CODE_WIDTH-1:0] codeword_out
);
    // Systematic encoding: data bits followed by parity bits
    assign codeword_out[CODE_WIDTH-1:PARITY_WIDTH] = data_in;
    
    // Parity bit calculation based on BCH configuration
    generate
        if (CODE_WIDTH == 7 && DATA_WIDTH == 4) begin : bch74
            // BCH(7,4,1) - Generator polynomial: x^3 + x + 1
            assign codeword_out[2] = data_in[3] ^ data_in[2] ^ data_in[0];
            assign codeword_out[1] = data_in[3] ^ data_in[1] ^ data_in[0];
            assign codeword_out[0] = data_in[2] ^ data_in[1] ^ data_in[0];
        end
        else if (CODE_WIDTH == 15 && DATA_WIDTH == 7) begin : bch1572
            // BCH(15,7,2) - Generator polynomial: x^8 + x^7 + x^6 + x^4 + 1
            assign codeword_out[7] = data_in[6] ^ data_in[5] ^ data_in[4] ^ data_in[2];
            assign codeword_out[6] = data_in[6] ^ data_in[5] ^ data_in[3] ^ data_in[1];
            assign codeword_out[5] = data_in[6] ^ data_in[4] ^ data_in[3] ^ data_in[0];
            assign codeword_out[4] = data_in[5] ^ data_in[4] ^ data_in[2] ^ data_in[1];
            assign codeword_out[3] = data_in[6] ^ data_in[5] ^ data_in[3] ^ data_in[2] ^ data_in[0];
            assign codeword_out[2] = data_in[6] ^ data_in[4] ^ data_in[3] ^ data_in[1] ^ data_in[0];
            assign codeword_out[1] = data_in[5] ^ data_in[4] ^ data_in[2] ^ data_in[1] ^ data_in[0];
            assign codeword_out[0] = data_in[6] ^ data_in[5] ^ data_in[4] ^ data_in[3] ^ data_in[2] ^ data_in[1] ^ data_in[0];
        end
        else if (CODE_WIDTH == 31 && DATA_WIDTH == 16) begin : bch31163
            // BCH(31,16,3) - Simplified parity calculation
            genvar i;
            for (i = 0; i < 15; i = i + 1) begin : parity_bits
                assign codeword_out[14-i] = ^(data_in & (16'hFFFF >> i));
            end
        end
        else if (CODE_WIDTH == 63 && DATA_WIDTH == 32) begin : bch63326
            // BCH(63,32,6) - Simplified parity calculation
            genvar i;
            for (i = 0; i < 31; i = i + 1) begin : parity_bits
                assign codeword_out[30-i] = ^(data_in & (32'hFFFFFFFF >> i));
            end
        end
        else begin : default_encoder
            // Default: simple parity encoding
            assign codeword_out[PARITY_WIDTH-1:0] = ^data_in;
        end
    endgenerate
endmodule

module general_bch_decoder #(
    parameter DATA_WIDTH = 7,    // k: data width
    parameter CODE_WIDTH = 15,   // n: codeword width
    parameter PARITY_WIDTH = 8   // n-k: parity width
)(
    input  [CODE_WIDTH-1:0] codeword_in,
    output [DATA_WIDTH-1:0] data_out,
    output error_detected,
    output error_corrected,
    output [3:0] error_count
);
    // Syndrome calculation and error correction based on BCH configuration
    generate
        if (CODE_WIDTH == 7 && DATA_WIDTH == 4) begin : bch74_decoder
            // BCH(7,4,1) decoder
            wire [2:0] syndrome;
            reg [6:0] corrected;
            
            // Syndrome calculation
            assign syndrome[0] = codeword_in[6] ^ codeword_in[2] ^ codeword_in[0];
            assign syndrome[1] = codeword_in[5] ^ codeword_in[1] ^ codeword_in[0];
            assign syndrome[2] = codeword_in[4] ^ codeword_in[2] ^ codeword_in[1];
            
            assign error_detected = |syndrome;
            
            always @* begin
                corrected = codeword_in;
                if (error_detected) begin
                    case (syndrome)
                        3'b001: corrected[0] = ~codeword_in[0];
                        3'b010: corrected[1] = ~codeword_in[1];
                        3'b011: corrected[2] = ~codeword_in[2];
                        3'b100: corrected[3] = ~codeword_in[3];
                        3'b101: corrected[4] = ~codeword_in[4];
                        3'b110: corrected[5] = ~codeword_in[5];
                        3'b111: corrected[6] = ~codeword_in[6];
                        default: corrected = codeword_in;
                    endcase
                end
            end
            
            assign data_out = corrected[6:3];
            assign error_corrected = error_detected;
            assign error_count = error_detected ? 1 : 0;
        end
        else if (CODE_WIDTH == 15 && DATA_WIDTH == 7) begin : bch1572_decoder
            // BCH(15,7,2) decoder - simplified
            wire [3:0] s1, s2, s3, s4;
            
            // Simplified syndrome calculation
            assign s1 = codeword_in[14] ^ codeword_in[13] ^ codeword_in[12] ^ codeword_in[11] ^ 
                       codeword_in[10] ^ codeword_in[9] ^ codeword_in[8] ^ codeword_in[7];
            assign s2 = codeword_in[13] ^ codeword_in[12] ^ codeword_in[11] ^ codeword_in[10] ^ 
                       codeword_in[9] ^ codeword_in[8] ^ codeword_in[7] ^ codeword_in[6];
            assign s3 = codeword_in[12] ^ codeword_in[11] ^ codeword_in[10] ^ codeword_in[9] ^ 
                       codeword_in[8] ^ codeword_in[7] ^ codeword_in[6] ^ codeword_in[5];
            assign s4 = codeword_in[11] ^ codeword_in[10] ^ codeword_in[9] ^ codeword_in[8] ^ 
                       codeword_in[7] ^ codeword_in[6] ^ codeword_in[5] ^ codeword_in[4];
            
            assign error_detected = |s1 || |s2 || |s3 || |s4;
            assign data_out = codeword_in[14:8];
            assign error_corrected = 0; // Simplified - no correction
            assign error_count = (s1 != 0) + (s2 != 0) + (s3 != 0) + (s4 != 0);
        end
        else if (CODE_WIDTH == 31 && DATA_WIDTH == 16) begin : bch31163_decoder
            // BCH(31,16,3) decoder - simplified
            wire [4:0] s1, s2, s3, s4, s5, s6;
            
            // Simplified syndrome calculation
            assign s1 = codeword_in[30] ^ codeword_in[29] ^ codeword_in[28] ^ codeword_in[27] ^ 
                       codeword_in[26] ^ codeword_in[25] ^ codeword_in[24] ^ codeword_in[23];
            assign s2 = codeword_in[29] ^ codeword_in[28] ^ codeword_in[27] ^ codeword_in[26] ^ 
                       codeword_in[25] ^ codeword_in[24] ^ codeword_in[23] ^ codeword_in[22];
            assign s3 = codeword_in[28] ^ codeword_in[27] ^ codeword_in[26] ^ codeword_in[25] ^ 
                       codeword_in[24] ^ codeword_in[23] ^ codeword_in[22] ^ codeword_in[21];
            assign s4 = codeword_in[27] ^ codeword_in[26] ^ codeword_in[25] ^ codeword_in[24] ^ 
                       codeword_in[23] ^ codeword_in[22] ^ codeword_in[21] ^ codeword_in[20];
            assign s5 = codeword_in[26] ^ codeword_in[25] ^ codeword_in[24] ^ codeword_in[23] ^ 
                       codeword_in[22] ^ codeword_in[21] ^ codeword_in[20] ^ codeword_in[19];
            assign s6 = codeword_in[25] ^ codeword_in[24] ^ codeword_in[23] ^ codeword_in[22] ^ 
                       codeword_in[21] ^ codeword_in[20] ^ codeword_in[19] ^ codeword_in[18];
            
            assign error_detected = |s1 || |s2 || |s3 || |s4 || |s5 || |s6;
            assign data_out = codeword_in[30:15];
            assign error_corrected = 0; // Simplified - no correction
            assign error_count = (s1 != 0) + (s2 != 0) + (s3 != 0) + (s4 != 0) + (s5 != 0) + (s6 != 0);
        end
        else if (CODE_WIDTH == 63 && DATA_WIDTH == 32) begin : bch63326_decoder
            // BCH(63,32,6) decoder - simplified
            wire [5:0] s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12;
            
            // Simplified syndrome calculation
            assign s1 = codeword_in[62] ^ codeword_in[61] ^ codeword_in[60] ^ codeword_in[59] ^ 
                       codeword_in[58] ^ codeword_in[57] ^ codeword_in[56] ^ codeword_in[55];
            assign s2 = codeword_in[61] ^ codeword_in[60] ^ codeword_in[59] ^ codeword_in[58] ^ 
                       codeword_in[57] ^ codeword_in[56] ^ codeword_in[55] ^ codeword_in[54];
            assign s3 = codeword_in[60] ^ codeword_in[59] ^ codeword_in[58] ^ codeword_in[57] ^ 
                       codeword_in[56] ^ codeword_in[55] ^ codeword_in[54] ^ codeword_in[53];
            assign s4 = codeword_in[59] ^ codeword_in[58] ^ codeword_in[57] ^ codeword_in[56] ^ 
                       codeword_in[55] ^ codeword_in[54] ^ codeword_in[53] ^ codeword_in[52];
            assign s5 = codeword_in[58] ^ codeword_in[57] ^ codeword_in[56] ^ codeword_in[55] ^ 
                       codeword_in[54] ^ codeword_in[53] ^ codeword_in[52] ^ codeword_in[51];
            assign s6 = codeword_in[57] ^ codeword_in[56] ^ codeword_in[55] ^ codeword_in[54] ^ 
                       codeword_in[53] ^ codeword_in[52] ^ codeword_in[51] ^ codeword_in[50];
            assign s7 = codeword_in[56] ^ codeword_in[55] ^ codeword_in[54] ^ codeword_in[53] ^ 
                       codeword_in[52] ^ codeword_in[51] ^ codeword_in[50] ^ codeword_in[49];
            assign s8 = codeword_in[55] ^ codeword_in[54] ^ codeword_in[53] ^ codeword_in[52] ^ 
                       codeword_in[51] ^ codeword_in[50] ^ codeword_in[49] ^ codeword_in[48];
            assign s9 = codeword_in[54] ^ codeword_in[53] ^ codeword_in[52] ^ codeword_in[51] ^ 
                       codeword_in[50] ^ codeword_in[49] ^ codeword_in[48] ^ codeword_in[47];
            assign s10 = codeword_in[53] ^ codeword_in[52] ^ codeword_in[51] ^ codeword_in[50] ^ 
                        codeword_in[49] ^ codeword_in[48] ^ codeword_in[47] ^ codeword_in[46];
            assign s11 = codeword_in[52] ^ codeword_in[51] ^ codeword_in[50] ^ codeword_in[49] ^ 
                        codeword_in[48] ^ codeword_in[47] ^ codeword_in[46] ^ codeword_in[45];
            assign s12 = codeword_in[51] ^ codeword_in[50] ^ codeword_in[49] ^ codeword_in[48] ^ 
                        codeword_in[47] ^ codeword_in[46] ^ codeword_in[45] ^ codeword_in[44];
            
            assign error_detected = |s1 || |s2 || |s3 || |s4 || |s5 || |s6 || 
                                   |s7 || |s8 || |s9 || |s10 || |s11 || |s12;
            assign data_out = codeword_in[62:31];
            assign error_corrected = 0; // Simplified - no correction
            assign error_count = (s1 != 0) + (s2 != 0) + (s3 != 0) + (s4 != 0) + 
                                (s5 != 0) + (s6 != 0) + (s7 != 0) + (s8 != 0) + 
                                (s9 != 0) + (s10 != 0) + (s11 != 0) + (s12 != 0);
        end
        else begin : default_decoder
            // Default: simple parity decoder
            assign error_detected = ^codeword_in;
            assign data_out = codeword_in[CODE_WIDTH-1:PARITY_WIDTH];
            assign error_corrected = 0;
            assign error_count = error_detected ? 1 : 0;
        end
    endgenerate
endmodule