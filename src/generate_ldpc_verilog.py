
import os
import sys
import numpy as np

# Add src to path to import ldpc_ecc
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ldpc_ecc import LDPCECC

def generate_verilog_for_width(k, output_dir):
    """
    Generates a fixed-width LDPC Verilog module.
    k: Data width (4, 8, 16, 32, 64, 128)
    n will be 2*k (Rate 1/2)
    """
    n = k * 2
    module_name = f"ldpc_ecc_w{k}"
    filename = os.path.join(output_dir, f"{module_name}.v")
    
    print(f"Generating {module_name} (n={n}, k={k})...")
    
    # 1. Instantiate Model to get Matrices
    ecc = LDPCECC(k=k, data_length=k) 
    
    # G = [I | P.T]. We only need P.T for encoding parity.
    assert np.array_equal(ecc.G[:, :k], np.eye(k, dtype=int)), "G must be systematic [I | P.T]"
    P_T = ecc.G[:, k:] # (k x m)
    
    # H Matrix for decoding
    H = ecc.H # (m x n)
    m = n - k
    
    verilog = []
    verilog.append(f"// Generated {module_name} - Do not edit manually")
    verilog.append(f"module {module_name} (")
    verilog.append(f"    input  wire clk,")
    verilog.append(f"    input  wire rst_n,")
    verilog.append(f"    input  wire encode_en,")
    verilog.append(f"    input  wire decode_en,")
    verilog.append(f"    input  wire [{k-1}:0] data_in,")
    verilog.append(f"    input  wire [{n-1}:0] codeword_in,")
    verilog.append(f"    output reg  [{n-1}:0] codeword_out,")
    verilog.append(f"    output reg  [{k-1}:0] data_out,")
    verilog.append(f"    output reg  error_detected,")
    verilog.append(f"    output reg  error_corrected,")
    verilog.append(f"    output reg  valid_out")
    verilog.append(f");")
    
    # ---------------------------------------------------------
    # INTERNAL SIGNALS
    # ---------------------------------------------------------
    verilog.append(f"    reg [3:0] state;")
    verilog.append(f"    localparam IDLE = 0, CALC_SYNDROME = 1, FLIP_BITS = 2, CHECK_DONE = 3, FINISH = 4;")
    verilog.append(f"    reg [4:0] iter_count;")
    verilog.append(f"    localparam MAX_ITER = 10;")
    verilog.append(f"    ")
    verilog.append(f"    reg [{n-1}:0] current_cw;")
    verilog.append(f"    wire [{m-1}:0] syndrome;")
    verilog.append(f"    wire has_error;")

    # ---------------------------------------------------------
    # ENCODING LOGIC (Combinational Parity Calc)
    # ---------------------------------------------------------
    verilog.append(f"    wire [{m-1}:0] parity_out;")
    for j in range(m): 
        input_contributors = np.where(P_T[:, j] == 1)[0]
        if len(input_contributors) == 0:
             verilog.append(f"    assign parity_out[{j}] = 1'b0;")
        else:
             terms = [f"data_in[{idx}]" for idx in input_contributors]
             verilog.append(f"    assign parity_out[{j}] = {' ^ '.join(terms)};")

    # ---------------------------------------------------------
    # SYNDROME LOGIC (Combinational)
    # ---------------------------------------------------------
    for i in range(m):
        contributors = np.where(H[i, :] == 1)[0]
        if len(contributors) == 0:
            verilog.append(f"    assign syndrome[{i}] = 1'b0;")
        else:
            terms = [f"current_cw[{idx}]" for idx in contributors]
            verilog.append(f"    assign syndrome[{i}] = {' ^ '.join(terms)};")
            
    verilog.append(f"    assign has_error = |syndrome;")

    # ---------------------------------------------------------
    # BIT FLIPPING VOTING LOGIC (Combinational)
    # ---------------------------------------------------------
    vn_connections = {}
    for j in range(n):
        vn_connections[j] = np.where(H[:, j] == 1)[0]

    for j in range(n):
        checks = vn_connections[j]
        if len(checks) == 0:
             verilog.append(f"    wire flip_{j} = 1'b0;")
        else:
             terms = [f"syndrome[{c}]" for c in checks]
             
             # Dynamic width calculation
             max_val = len(checks)
             width = max_val.bit_length()
             if width == 0: width = 1
             
             pad = width - 1
             if pad > 0:
                extended_terms = [f"{{ {pad}'d0, {t} }}" for t in terms]
             else:
                extended_terms = terms

             sum_expr = " + ".join(extended_terms)
             verilog.append(f"    wire [{width-1}:0] sum_{j} = {sum_expr};")
             threshold = int(len(checks)/2 + 0.5)
             verilog.append(f"    wire flip_{j} = (sum_{j} >= {width}'d{threshold});")

    # ---------------------------------------------------------
    # MAIN CONTROL BLOCK (Single Always Block)
    # ---------------------------------------------------------
    verilog.append(f"    always @(posedge clk or negedge rst_n) begin")
    verilog.append(f"        if (!rst_n) begin")
    verilog.append(f"            state <= IDLE;")
    verilog.append(f"            current_cw <= 0;")
    verilog.append(f"            iter_count <= 0;")
    verilog.append(f"            codeword_out <= 0;")
    verilog.append(f"            data_out <= 0;")
    verilog.append(f"            error_detected <= 0;")
    verilog.append(f"            error_corrected <= 0;")
    verilog.append(f"            valid_out <= 0;")
    verilog.append(f"        end else begin")
    verilog.append(f"            // Default valid_out to 0 unless pulsed")
    verilog.append(f"            valid_out <= 0; ")
    verilog.append(f"            ")
    verilog.append(f"            if (encode_en) begin")
    verilog.append(f"                codeword_out <= {{parity_out, data_in}};")
    verilog.append(f"                valid_out <= 1'b1;")
    verilog.append(f"            end")
    verilog.append(f"            ")
    verilog.append(f"            else if (decode_en && state == IDLE) begin")
    verilog.append(f"                state <= CALC_SYNDROME;")
    verilog.append(f"                current_cw <= codeword_in;")
    verilog.append(f"                iter_count <= 0;")
    verilog.append(f"            end")
    verilog.append(f"            ")
    verilog.append(f"            else begin")
    verilog.append(f"                case (state)")
    verilog.append(f"                    CALC_SYNDROME: begin")
    verilog.append(f"                        if (!has_error) begin")
    verilog.append(f"                             state <= FINISH;")
    verilog.append(f"                        end else if (iter_count == MAX_ITER) begin")
    verilog.append(f"                             state <= FINISH;")
    verilog.append(f"                        end else begin")
    verilog.append(f"                             state <= FLIP_BITS;")
    verilog.append(f"                        end")
    verilog.append(f"                    end")
    verilog.append(f"                    FLIP_BITS: begin")
    verilog.append(f"                        // Apply flips")
    for j in range(n):
        verilog.append(f"                        current_cw[{j}] <= current_cw[{j}] ^ flip_{j};")
    verilog.append(f"                        iter_count <= iter_count + 1;")
    verilog.append(f"                        state <= CALC_SYNDROME;")
    verilog.append(f"                    end")
    verilog.append(f"                    FINISH: begin")
    verilog.append(f"                        data_out <= current_cw[{k-1}:0];")
    verilog.append(f"                        error_detected <= has_error;")
    verilog.append(f"                        error_corrected <= (has_error == 0); // Approx")
    verilog.append(f"                        valid_out <= 1'b1;")
    verilog.append(f"                        state <= IDLE;")
    verilog.append(f"                    end")
    verilog.append(f"                    default: state <= IDLE;")
    verilog.append(f"                endcase")
    verilog.append(f"            end")
    verilog.append(f"        end")
    verilog.append(f"    end")

    verilog.append(f"endmodule")
    
    with open(filename, "w") as f:
        f.write("\n".join(verilog))

def main():
    output_dir = "verilogs/generated"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        
    widths = [4, 8, 16, 32, 64, 128]
    for w in widths:
        try:
            generate_verilog_for_width(w, output_dir)
            print(f"FAILED: None (Passed {w})") 
        except Exception as e:
            print(f"FAILED: {w} - {e}")
            import traceback
            traceback.print_exc()

if __name__ == "__main__":
    main()
