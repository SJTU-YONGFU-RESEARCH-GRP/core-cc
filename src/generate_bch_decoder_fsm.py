#!/usr/bin/env python3
"""
Meta-generate BCH(63,32,t=5) golden RTL aligned with bch_codec.py.

Encoder: data_k = {4'b0, data_in}, parity[26:0] (deg(g)=27, no zero-padding).
Decoder: 4-state FSM — syndrome (comb) -> BM (10 cyc) -> Chien (63 cyc) -> DONE.
"""

from __future__ import annotations

import os
import sys
from typing import List

sys.path.insert(0, os.path.dirname(__file__))
from bch_codec import BCHCodec, BCH_CONFIGS, GF2m  # noqa: E402
from generate_bch_verilog import (  # noqa: E402
    GF2m as GenGF2m,
    emit_data_k_wire,
    emit_encoder_lfsr,
    emit_syndrome_wires,
)


def gf_const_mult_matrix(gf: GF2m, constant: int) -> List[List[int]]:
    m = gf.m
    mat: List[List[int]] = []
    for out_bit in range(m):
        row = []
        for in_bit in range(m):
            inp = 1 << in_bit
            prod = 0 if constant == 0 else gf.mul(inp, constant)
            row.append((prod >> out_bit) & 1)
        mat.append(row)
    return mat


def emit_const_mult_module(name: str, gf: GF2m, constant: int) -> str:
    m = gf.m
    mat = gf_const_mult_matrix(gf, constant)
    lines = [f"module {name} (", f"    input  wire [{m - 1}:0] in,", f"    output wire [{m - 1}:0] out", ");"]
    for i, row in enumerate(mat):
        terms = [f"in[{j}]" for j, v in enumerate(row) if v]
        expr = "1'b0" if not terms else " ^ ".join(terms)
        lines.append(f"    assign out[{i}] = {expr};")
    lines.append("endmodule")
    return "\n".join(lines)


def emit_gf_mul_module(name: str, gf: GF2m) -> str:
    m, order = gf.m, gf.order
    lines = [
        f"module {name} (",
        f"    input  wire [{m - 1}:0] a,",
        f"    input  wire [{m - 1}:0] b,",
        f"    output wire [{m - 1}:0] y",
        ");",
        f"    reg [{m - 1}:0] log_a, log_b, y_r;",
        f"    reg [{m}:0] sum;  // log_a+log_b needs m+1 bits before mod {order}",
        "    always @(*) begin",
        f"        log_a = {m}'d0; log_b = {m}'d0; sum = {m}'d0; y_r = {m}'d0;",
        f"        if (a != {m}'d0) begin",
        "            case (a)",
    ]
    for v in range(1, gf.size):
        if gf.int_to_alpha[v] >= 0:
            lines.append(f"                {m}'d{v}: log_a = {m}'d{gf.int_to_alpha[v]};")
    lines += [f"                default: log_a = {m}'d0;", "            endcase", "        end"]
    lines += [f"        if (b != {m}'d0) begin", "            case (b)"]
    for v in range(1, gf.size):
        if gf.int_to_alpha[v] >= 0:
            lines.append(f"                {m}'d{v}: log_b = {m}'d{gf.int_to_alpha[v]};")
    lines += [
        f"                default: log_b = {m}'d0;",
        "            endcase",
        "        end",
        f"        if (a == {m}'d0 || b == {m}'d0) y_r = {m}'d0;",
        "        else begin",
        f"            sum = {{1'b0, log_a}} + {{1'b0, log_b}};",
        f"            if (sum >= {order}) sum = sum - {order}'d{order};",
        f"            case (sum[{m - 1}:0])",
    ]
    for log_i in range(order):
        lines.append(f"                {m}'d{log_i}: y_r = {m}'d{gf.alpha_to_int[log_i]};")
    lines += [
        f"                default: y_r = {m}'d0;",
        "            endcase",
        "        end",
        "    end",
        f"    assign y = y_r;",
        "endmodule",
    ]
    return "\n".join(lines)


def emit_gf_inv_module(name: str, gf: GF2m) -> str:
    m = gf.m
    lines = [
        f"module {name} (",
        f"    input  wire [{m - 1}:0] a,",
        f"    output wire [{m - 1}:0] y",
        ");",
        f"    reg [{m - 1}:0] y_r;",
        "    always @(*) begin",
        f"        y_r = {m}'d0;",
        f"        if (a != {m}'d0) begin",
        "            case (a)",
    ]
    for v in range(1, gf.size):
        lines.append(f"                {m}'d{v}: y_r = {m}'d{gf.inv(v)};")
    lines += [
        f"                default: y_r = {m}'d0;",
        "            endcase",
        "        end",
        "    end",
        f"    assign y = y_r;",
        "endmodule",
    ]
    return "\n".join(lines)


def emit_bm_discrepancy_wires(v: List[str], gf: GF2m, t: int) -> None:
    """Parallel GF muls for d = S_n + sum c[i]*S_{n-i}."""
    m = gf.m
    for i in range(1, t + 1):
        v.append(f"    wire [{m - 1}:0] bm_syn_m{i};")
        v.append(
            f"    assign bm_syn_m{i} = (bm_step >= {i}) ? syn_reg[bm_step - {i}] : {m}'d0;"
        )
        v.append(f"    wire [{m - 1}:0] bm_prod{i};")
        v.append(
            f"    gf_mul_w{m} u_bm_p{i} (.a(bm_c[{i}]), .b(bm_syn_m{i}), .y(bm_prod{i}));"
        )
    terms = ["syn_reg[bm_step]"] + [f"((bm_L >= {i}) ? bm_prod{i} : {m}'d0)" for i in range(1, t + 1)]
    v.append(f"    wire [{m - 1}:0] bm_d_comb = {' ^ '.join(terms)};")


def emit_lambda_latch_chien(
    v: List[str], t: int, m: int, lambda_deg_w: int, chien_w: int
) -> None:
    """Latch bm_c -> lambda and enter CHIEN (use bm_c, not stale lambda)."""
    for i in range(t + 1):
        v.append(f"                            lambda[{i}] <= bm_c[{i}];")
    v.append(
        f"                            lambda_deg <= (bm_L > {t}) ? {lambda_deg_w}'d{t} "
        f": bm_L[{lambda_deg_w - 1}:0];"
    )
    v.append(f"                            state <= ST_CHIEN; chien_pos <= {chien_w}'d0;")


def emit_decoder_fsm(v: List[str], codec: BCHCodec, n: int, width: int, parity_bits: int) -> None:
    """Synthesizable BM + Chien FSM (parametric n, m, t)."""
    m, t = codec.gf.m, codec.t
    gf = codec.gf
    chien_w = max(3, (n - 1).bit_length())
    chien_last = n - 1
    lambda_deg_w = max(3, t.bit_length())
    bm_step_w = max(4, (2 * t).bit_length())
    bm_L_w = max(5, (t + 1).bit_length())
    # Match bch_codec.berlekamp_massey workspace: len(syndromes) + max_degree + 1
    bm_size = 2 * t + t + 1
    # Must hold 0..BM_SIZE (inclusive) without wrap, else bm_c_busy never finishes.
    upd_w = max(4, bm_size.bit_length())

    for j in range(1, 2 * t + 1):
        # Pack bit0 (x^0 coeff) in synd_j_0 as LSB of synd_j_gf (matches bch_codec / gf_mul).
        bits = "{" + ", ".join(f"synd_{j}_{b}" for b in reversed(range(m))) + "}"
        v.append(f"    wire [{m - 1}:0] synd_{j}_gf = {bits};")

    v.append(f"    wire [{2 * t * m - 1}:0] synd_bus;")
    chunks = []
    for j in range(1, 2 * t + 1):
        for b in range(m):
            chunks.append(f"synd_{j}_{b}")
    v.append("    assign synd_bus = {" + ", ".join(reversed(chunks)) + "};")
    v.append("    wire any_syndrome = |synd_bus;")

    v.append("    localparam [1:0] ST_IDLE=2'd0, ST_BM=2'd1, ST_CHIEN=2'd2, ST_DONE=2'd3;")
    v.append("    reg [1:0] state;")
    v.append(f"    localparam integer BM_SIZE = {bm_size};")
    v.append(f"    reg [{m - 1}:0] bm_c [0:BM_SIZE-1];")
    v.append(f"    reg [{m - 1}:0] bm_b [0:BM_SIZE-1];")
    v.append(f"    reg [{m - 1}:0] bm_bval, bm_coef, bm_coef_latched;")
    v.append(f"    reg [{bm_L_w - 1}:0] bm_L, bm_mreg;")
    v.append(f"    reg [{bm_step_w - 1}:0] bm_step;")
    v.append(f"    reg [{m - 1}:0] syn_reg [0:{2 * t - 1}];")
    v.append(f"    reg [{m - 1}:0] lambda [0:{t}];")
    v.append(f"    reg [{lambda_deg_w - 1}:0] lambda_deg;")
    v.append(f"    reg [{n - 1}:0] err_mask;")
    v.append(f"    reg [{chien_w - 1}:0] chien_pos;")
    v.append(f"    reg [{n - 1}:0] corrected_cw;")

    emit_bm_discrepancy_wires(v, gf, t)
    v.append("    reg bm_c_busy, bm_upd_arm, bm_swap_pending;")
    v.append(f"    reg [{m - 1}:0] bm_new_bval;")
    v.append(f"    reg [{m - 1}:0] bm_t [0:BM_SIZE-1];  // t_poly = C before update (for swap)")
    v.append(f"    wire [{m - 1}:0] bm_inv;")
    v.append(f"    gf_inv_w{m} u_bm_inv (.a(bm_bval), .y(bm_inv));")
    v.append(f"    gf_mul_w{m} u_bm_coef (.a(bm_d_comb), .b(bm_inv), .y(bm_coef));")

    # Shared update mul: coef * bm_b[i] -> upd; apply to bm_c[i+mreg]
    v.append(f"    wire [{m - 1}:0] bm_upd;")
    v.append(f"    reg [{upd_w - 1}:0] upd_i;")
    v.append(f"    gf_mul_w{m} u_bm_upd (.a(bm_coef_latched), .b(bm_b[upd_i]), .y(bm_upd));")

    v.append(f"    reg [{m - 1}:0] alpha_inv_rom [0:{chien_last}];")
    v.append("    initial begin")
    for pos in range(n):
        v.append(f"        alpha_inv_rom[{pos}] = {m}'d{gf.alpha_pow(-pos)};")
    v.append("    end")
    v.append(f"    wire [{m - 1}:0] chien_X = alpha_inv_rom[chien_pos];")
    # Horner: sigma(x)=sum lambda[i]*x^i, evaluate from lambda[deg] down to lambda[0]
    v.append(f"    wire [{m - 1}:0] chien_h{t};")
    v.append(f"    assign chien_h{t} = lambda[{t}];")
    for i in range(t - 1, -1, -1):
        v.append(f"    wire [{m - 1}:0] chien_p{i}, chien_h{i};")
        v.append(
            f"    gf_mul_w{m} u_chien_p{i} (.a(chien_h{i + 1}), .b(chien_X), .y(chien_p{i}));"
        )
        v.append(f"    assign chien_h{i} = chien_p{i} ^ lambda[{i}];")
    v.append(f"    wire [{m - 1}:0] chien_eval;")
    v.append(f"    assign chien_eval = chien_h0;")
    v.append(
        f"    wire chien_is_root = (lambda_deg == {lambda_deg_w}'d0) ? "
        f"(lambda[0] == {m}'d0) : (chien_eval == {m}'d0);"
    )
    v.append(f"    wire [{n - 1}:0] chien_flip = chien_is_root ? ({n}'d1 << chien_pos) : {n}'d0;")

    v.append("    always @(posedge clk or negedge rst_n) begin")
    v.append("        if (!rst_n) begin")
    v.append("            state <= ST_IDLE; valid_out <= 1'b0;")
    v.append("            error_detected <= 1'b0; error_corrected <= 1'b0;")
    v.append(f"            codeword_out <= {n}'d0; data_out <= {width}'d0;")
    v.append(f"            err_mask <= {n}'d0; bm_step <= {bm_step_w}'d0; chien_pos <= {chien_w}'d0;")
    v.append(f"            upd_i <= {upd_w}'d0; bm_coef_latched <= {m}'d0;")
    v.append("            bm_c_busy <= 1'b0; bm_upd_arm <= 1'b0; bm_swap_pending <= 1'b0;")
    v.append(f"            bm_L <= {bm_L_w}'d0; bm_mreg <= {bm_L_w}'d1; bm_bval <= {m}'d1;")
    for i in range(t + 1):
        v.append(f"            lambda[{i}] <= {m}'d0;")
    v.append(f"            lambda_deg <= {lambda_deg_w}'d0;")
    v.append("        end else begin")
    v.append("            valid_out <= 1'b0;")
    v.append("            if (encode_en) begin")
    v.append("                codeword_out <= {data_k, parity};")
    v.append(f"                data_out <= {width}'d0;")
    v.append("                error_detected <= 1'b0; error_corrected <= 1'b0;")
    v.append("                valid_out <= 1'b1; state <= ST_IDLE;")
    v.append("            end else if (decode_en && state == ST_IDLE) begin")
    v.append("                corrected_cw <= codeword_in; err_mask <= {n}'d0;".format(n=n))
    for j in range(2 * t):
        v.append(f"                syn_reg[{j}] <= synd_{j + 1}_gf;")
    for i in range(t + 1):
        v.append(f"                lambda[{i}] <= {m}'d0;")
    v.append(f"                lambda_deg <= {lambda_deg_w}'d0;")
    v.append(f"                bm_c[0] <= {m}'d1;")
    for i in range(1, bm_size):
        v.append(f"                bm_c[{i}] <= {m}'d0;")
    v.append(f"                bm_b[0] <= {m}'d1;")
    for i in range(1, bm_size):
        v.append(f"                bm_b[{i}] <= {m}'d0;")
    v.append(
        f"                bm_bval <= {m}'d1; bm_L <= {bm_L_w}'d0; bm_mreg <= {bm_L_w}'d1; "
        f"bm_step <= {bm_step_w}'d0;"
    )
    v.append(
        f"                chien_pos <= {chien_w}'d0; upd_i <= {upd_w}'d0; bm_coef_latched <= {m}'d0;"
    )
    v.append("                bm_c_busy <= 1'b0; bm_upd_arm <= 1'b0; bm_swap_pending <= 1'b0;")
    v.append("                state <= any_syndrome ? ST_BM : ST_DONE;")
    v.append("                error_detected <= any_syndrome; error_corrected <= 1'b0;")
    v.append("            end else case (state)")
    v.append("                ST_BM: begin")
    v.append("                    if (bm_c_busy) begin")
    v.append("                        if (!bm_upd_arm) begin")
    v.append(f"                            bm_coef_latched <= bm_coef;")
    v.append(f"                            upd_i <= {upd_w}'d0;")
    v.append("                            bm_upd_arm <= 1'b1;")
    v.append(f"                        end else if (upd_i < BM_SIZE) begin")
    v.append(f"                            if (bm_b[upd_i] != {m}'d0 && (upd_i + bm_mreg) < BM_SIZE)")
    v.append("                                bm_c[upd_i + bm_mreg] <= bm_c[upd_i + bm_mreg] ^ bm_upd;")
    v.append(f"                            upd_i <= upd_i + {upd_w}'d1;")
    v.append("                        end else begin")
    v.append(f"                            upd_i <= {upd_w}'d0;")
    v.append("                            bm_c_busy <= 1'b0; bm_upd_arm <= 1'b0;")
    v.append("                            if (bm_swap_pending) begin")
    for i in range(bm_size):
        v.append(f"                                bm_b[{i}] <= bm_t[{i}];")
    v.append("                                bm_bval <= bm_new_bval;")
    v.append(f"                                bm_mreg <= {bm_L_w}'d1;")
    v.append("                                bm_swap_pending <= 1'b0;")
    v.append(f"                            end else bm_mreg <= bm_mreg + {bm_L_w}'d1;")
    v.append(f"                            if (bm_step == {2 * t - 1}) begin")
    emit_lambda_latch_chien(v, t, m, lambda_deg_w, chien_w)
    v.append(f"                            end else bm_step <= bm_step + {bm_step_w}'d1;")
    v.append("                        end")
    v.append("                    end else begin")
    v.append("                        if (bm_d_comb == {m}'d0) begin".format(m=m))
    v.append(f"                            bm_mreg <= bm_mreg + {bm_L_w}'d1;")
    v.append(f"                            if (bm_step == {2 * t - 1}) begin")
    emit_lambda_latch_chien(v, t, m, lambda_deg_w, chien_w)
    v.append(f"                            end else bm_step <= bm_step + {bm_step_w}'d1;")
    v.append("                        end else begin")
    for i in range(bm_size):
        v.append(f"                                bm_t[{i}] <= bm_c[{i}];")
    v.append(f"                            upd_i <= {upd_w}'d0; bm_c_busy <= 1'b1; bm_upd_arm <= 1'b0;")
    v.append("                            if ((bm_L << 1) <= bm_step) begin")
    v.append(f"                                bm_L <= bm_step + {bm_L_w}'d1 - bm_L;")
    v.append("                                bm_new_bval <= bm_d_comb;")
    v.append("                                bm_swap_pending <= 1'b1;")
    v.append("                            end")
    v.append("                        end")
    v.append("                    end")
    v.append("                end")
    v.append("                ST_CHIEN: begin")
    v.append("                    if (chien_is_root)")
    v.append("                        err_mask <= err_mask | chien_flip;")
    v.append(f"                    if (chien_pos == {chien_w}'d{chien_last}) begin")
    v.append("                        corrected_cw <= codeword_in ^ err_mask ^ chien_flip;")
    v.append("                        state <= ST_DONE;")
    v.append(f"                    end else chien_pos <= chien_pos + {chien_w}'d1;")
    v.append("                end")
    v.append("                ST_DONE: begin")
    v.append(f"                    data_out <= corrected_cw[{parity_bits + width - 1}:{parity_bits}];")
    v.append("                    codeword_out <= corrected_cw;")
    v.append("                    error_corrected <= any_syndrome; valid_out <= 1'b1;")
    v.append("                    state <= ST_IDLE;")
    v.append("                end")
    v.append("                default: state <= ST_IDLE;")
    v.append("            endcase")
    v.append("        end")
    v.append("    end")


def generate_bch_ecc_fsm(
    out_dir: str,
    width: int,
    module_name: str | None = None,
) -> None:
    """BM + Chien FSM decoder (algebraic / PGZ track)."""
    codec = BCHCodec.for_width(width)
    n, k_user, t = codec.n, codec.k, codec.t
    pp = codec.prim_poly
    m = codec.gf.m
    parity_bits = codec.parity_bits
    k_encode = codec.k_encode
    g_poly = codec.g_poly
    pad = k_encode - width
    mod = module_name or f"bch_ecc_w{width}"
    gf = codec.gf
    gen_gf = GenGF2m(m, pp)
    step_w = max(3, (2 * t).bit_length())

    parts: List[str] = [
        "// Auto-generated by src/generate_bch_decoder_fsm.py",
        f"// BCH({n},{k_user},t={t}) GF(2^{m}) k_encode={k_encode} parity_bits={parity_bits} pad={pad}",
        "",
        emit_gf_mul_module(f"gf_mul_w{m}", gf),
        "",
        emit_gf_inv_module(f"gf_inv_w{m}", gf),
        "",
    ]
    for p in range(1, t + 1):
        parts.append(emit_const_mult_module(f"gf_mul_alpha{p}_w{m}", gf, gf.alpha_pow(p)))
        parts.append("")

    v: List[str] = [f"module {mod} ("]
    v += [
        "    input  wire clk,",
        "    input  wire rst_n,",
        "    input  wire encode_en,",
        "    input  wire decode_en,",
        f"    input  wire [{width - 1}:0] data_in,",
        f"    input  wire [{n - 1}:0] codeword_in,",
        f"    output reg  [{n - 1}:0] codeword_out,",
        f"    output reg  [{width - 1}:0] data_out,",
        "    output reg  error_detected,",
        "    output reg  error_corrected,",
        "    output reg  valid_out",
        ");",
    ]
    emit_data_k_wire(v, width, k_encode)
    emit_encoder_lfsr(v, k_encode, parity_bits, g_poly)
    emit_syndrome_wires(v, gen_gf, n, t)
    emit_decoder_fsm(v, codec, n, width, parity_bits)
    v.append("endmodule")

    parts.extend(v)
    parts.append("")
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, f"{mod}.v")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(parts))
    print(f"Wrote {path} ({len(parts)} lines)")


FSM_WIDTHS = (32, 64, 128)


def main() -> None:
    root = os.path.join(os.path.dirname(__file__), "..")
    out = os.path.join(root, "verilogs/repaired_golden/generated")
    for w in FSM_WIDTHS:
        print(f"=== BCH FSM w{w} ===")
        generate_bch_ecc_fsm(out, width=w)
    # LUT golden for small widths (w4/w8/w16)
    from generate_bch_verilog import generate_bch_verilog  # noqa: WPS433

    raw = os.path.join(root, "verilogs/raw_llm_generated/generated")
    for cfg in [
        (4, 7, 4, 1, 0b1011),
        (8, 15, 11, 1, 0b10011),
        (16, 31, 16, 3, 0b100101),
        (32, 63, 32, 5, 0b1000011),
        (64, 127, 64, 9, 0b10001001),
        (128, 255, 128, 15, 0b100011101),
    ]:
        if cfg[0] not in FSM_WIDTHS:
            generate_bch_verilog(*cfg, raw)


if __name__ == "__main__":
    main()
