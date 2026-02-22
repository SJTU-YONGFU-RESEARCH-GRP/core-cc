
import os
import sys
import math

class PolarCodeGenerator:
    def __init__(self, N, K):
        self.N = N
        self.K = K
        self.n = int(math.log2(N))
        
        indices = list(range(N))
        self.channel_reliability = sorted([(i, bin(i).count('1'), i) for i in indices], key=lambda x: (x[1], x[2]))
        
        self.info_indices = set([x[0] for x in self.channel_reliability[-K:]])
        self.frozen_indices = set([x[0] for x in self.channel_reliability[:-K]])

    def generate_verilog(self, module_name):
        self.lines = []
        self.add_line(f"// Generated {module_name} - Real Hardware Polar Code (SC Decoder)")
        self.add_line(f"// N={self.N}, K={self.K} (Recursive Construction)")
        self.add_line(f"")
        self.add_line(f"module {module_name} (")
        self.add_line(f"    input  wire clk,")
        self.add_line(f"    input  wire rst_n,")
        self.add_line(f"    input  wire encode_en,")
        self.add_line(f"    input  wire decode_en,")
        self.add_line(f"    input  wire [{self.K-1}:0] data_in,")
        self.add_line(f"    input  wire [{self.N-1}:0] codeword_in,")
        self.add_line(f"    output reg  [{self.N-1}:0] codeword_out,")
        self.add_line(f"    output reg  [{self.K-1}:0] data_out,")
        self.add_line(f"    output reg  error_detected,")
        self.add_line(f"    output reg  error_corrected,")
        self.add_line(f"    output reg  valid_out")
        self.add_line(f");")
        
        # Functions for Saturation Arithmetic
        self.add_line(f"    // Saturation Arithmetic Functions")
        self.add_line(f"    function signed [5:0] sat_add;")
        self.add_line(f"        input signed [5:0] a;")
        self.add_line(f"        input signed [5:0] b;")
        self.add_line(f"        reg signed [6:0] sum;")
        self.add_line(f"        begin")
        self.add_line(f"            sum = a + b;")
        self.add_line(f"            if (sum > 31) sat_add = 31;")
        self.add_line(f"            else if (sum < -32) sat_add = -32;")
        self.add_line(f"            else sat_add = sum[5:0];")
        self.add_line(f"        end")
        self.add_line(f"    endfunction")
        self.add_line(f"    ")
        self.add_line(f"    function signed [5:0] sat_sub;")
        self.add_line(f"        input signed [5:0] a;")
        self.add_line(f"        input signed [5:0] b;")
        self.add_line(f"        reg signed [6:0] diff;")
        self.add_line(f"        begin")
        self.add_line(f"            diff = a - b;")
        self.add_line(f"            if (diff > 31) sat_sub = 31;")
        self.add_line(f"            else if (diff < -32) sat_sub = -32;")
        self.add_line(f"            else sat_sub = diff[5:0];")
        self.add_line(f"        end")
        self.add_line(f"    endfunction")
        self.add_line(f"    ")
        self.add_line(f"    function [5:0] safe_abs;")
        self.add_line(f"        input signed [5:0] a;")
        self.add_line(f"        begin")
        self.add_line(f"            if (a == -32) safe_abs = 31; // Clamp MAX negative")
        self.add_line(f"            else safe_abs = (a < 0) ? -a : a;")
        self.add_line(f"        end")
        self.add_line(f"    endfunction")
        
        # --------------------------------------------------------
        # ENCODER
        # --------------------------------------------------------
        self.add_line(f"    // Encoder Logic")
        self.add_line(f"    wire [{self.N-1}:0] u_vec;")
        
        info_count = 0
        for i in range(self.N):
            if i in self.info_indices:
                self.add_line(f"    assign u_vec[{i}] = data_in[{info_count}];")
                info_count += 1
            else:
                self.add_line(f"    assign u_vec[{i}] = 1'b0;")
        
        for i in range(self.N):
            self.add_line(f"    wire enc_s0_{i} = u_vec[{i}];")
            
        for s in range(1, self.n + 1):
            stride = 1 << (s - 1)
            for base in range(0, self.N, 2 * stride):
                for j in range(stride):
                    top = base + j
                    bot = base + j + stride
                    self.add_line(f"    wire enc_s{s}_{top} = enc_s{s-1}_{top} ^ enc_s{s-1}_{bot};")
                    self.add_line(f"    wire enc_s{s}_{bot} = enc_s{s-1}_{bot};")
        
        self.add_line(f"    wire [{self.N-1}:0] encoded_result;")
        for i in range(self.N):
            self.add_line(f"    assign encoded_result[{i}] = enc_s{self.n}_{i};")

        # --------------------------------------------------------
        # DECODER
        # --------------------------------------------------------
        self.add_line(f"    // Decoder Logic (6-bit Saturated)")
        self.memo_llr = {}
        self.memo_psum = {}
        
        VAL_POS = "6'sd8"
        VAL_NEG = "-6'sd8"
        for i in range(self.N):
            self.add_line(f"    wire signed [5:0] llr_ch_{i} = codeword_in[{i}] ? {VAL_NEG} : {VAL_POS};")
            
        for i in range(self.N):
            llr_wire = self.get_node_llr(0, i, i) 
            res_wire = f"u_est_{i}"
            is_frozen = (i in self.frozen_indices)
            
            if is_frozen:
                 self.add_line(f"    wire {res_wire} = 1'b0;")
            else:
                 # Hard decision: MSB=1 -> Negative -> Bit 1.
                 self.add_line(f"    wire {res_wire} = {llr_wire}[5];")

        # Assignments
        self.add_line(f"    always @(posedge clk or negedge rst_n) begin")
        self.add_line(f"        if (!rst_n) begin")
        self.add_line(f"            codeword_out <= 0; data_out <= 0; valid_out <= 0;")
        self.add_line(f"        end else if (encode_en) begin")
        self.add_line(f"            codeword_out <= encoded_result; valid_out <= 1; error_detected<=0; error_corrected<=0;")
        self.add_line(f"        end else if (decode_en) begin")
        self.add_line(f"            valid_out <= 1; error_detected<=0; error_corrected<=0;")
        
        # Extract Data Out
        info_count = 0
        for i in range(self.N):
            if i in self.info_indices:
                self.add_line(f"            data_out[{info_count}] <= u_est_{i};")
                info_count += 1
                
        self.add_line(f"        end else valid_out <= 0;")
        self.add_line(f"    end")
        self.add_line(f"endmodule")
        return self.lines

    def add_line(self, text):
        self.lines.append(text)

    def get_node_llr(self, stage, row, target_leaf):
        # Key should NOT include target_leaf, as the node logic (s, r) is unique in the graph.
        # The target_leaf was only used for traversing, but the logic cone is shared.
        key = (stage, row)
        if key in self.memo_llr: return self.memo_llr[key]
        
        if stage == self.n:
            return f"llr_ch_{row}"
            
        parent_s = stage + 1
        stride = 1 << stage 
        offset = row % (stride * 2)
        
        if offset < stride:
            # f (MinSum)
            # Pass target_leaf down? 
            # Actually, target_leaf is irrelevant for determining the dependencies 
            # of node (s,r). We just need to follow the connections.
            # But the recursive structure needs to know which parent nodes to query.
            # (s, r) always connects to (s+1, r) and (s+1, r+stride).
            pT = self.get_node_llr(parent_s, row, target_leaf)
            pB = self.get_node_llr(parent_s, row + stride, target_leaf)
            
            res_wire = f"llr_s{stage}_r{row}"
            
            # Use safe_abs
            self.add_line(f"    wire [5:0] abs_{res_wire}_T = safe_abs({pT});")
            self.add_line(f"    wire [5:0] abs_{res_wire}_B = safe_abs({pB});")
            self.add_line(f"    wire [5:0] min_{res_wire} = (abs_{res_wire}_T < abs_{res_wire}_B) ? abs_{res_wire}_T : abs_{res_wire}_B;")
            self.add_line(f"    wire sign_{res_wire} = {pT}[5] ^ {pB}[5];")
            self.add_line(f"    wire signed [5:0] {res_wire} = sign_{res_wire} ? -min_{res_wire} : min_{res_wire};")
            
        else:
            # g (Sum)
            pT = self.get_node_llr(parent_s, row - stride, target_leaf)
            pB = self.get_node_llr(parent_s, row, target_leaf)
            psum = self.get_node_psum(stage, row - stride, target_leaf)
            
            res_wire = f"llr_s{stage}_r{row}"
            # Use sat_add / sat_sub
            self.add_line(f"    wire signed [5:0] {res_wire} = {psum} ? sat_sub({pB}, {pT}) : sat_add({pB}, {pT});")

        self.memo_llr[key] = res_wire
        return res_wire

    def get_node_psum(self, stage, row, target_leaf):
        if stage == 0:
            return f"u_est_{row}"
    
        stride = 1 << (stage - 1)
        offset = row % (2 * stride)
        
        key = (stage, row) 
        if key in self.memo_psum: return self.memo_psum[key]

        if offset < stride:
            cT = self.get_node_psum(stage-1, row, target_leaf)
            cB = self.get_node_psum(stage-1, row + stride, target_leaf)
            res = f"psum_s{stage}_{row}"
            self.add_line(f"    wire {res} = {cT} ^ {cB};")
        else:
            cB = self.get_node_psum(stage-1, row, target_leaf)
            res = f"psum_s{stage}_{row}"
            self.add_line(f"    wire {res} = {cB};")
            
        self.memo_psum[key] = res
        return res

def main():
    out_dir = "verilogs/generated"
    if not os.path.exists(out_dir): os.makedirs(out_dir)
    for w in [4, 8, 16, 32, 64, 128]:
        print(f"Generating polar_ecc_w{w}...")
        gen = PolarCodeGenerator(2*w, w)
        lines = gen.generate_verilog(f"polar_ecc_w{w}")
        with open(f"{out_dir}/polar_ecc_w{w}.v", "w") as f:
            f.write("\n".join(lines))

if __name__ == "__main__":
    main()
