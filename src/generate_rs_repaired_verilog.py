#!/usr/bin/env python3
"""
Splice LLM RS encoder/syndrome with meta-generated t=2 PGZ comb decoder (FCR=0).
"""

from __future__ import annotations

import os
import re
import sys
from typing import List

sys.path.insert(0, os.path.dirname(__file__))
from generate_reed_solomon_verilog import GF256, generate_const_matrix_mul  # noqa: E402
from rs_codec import RSCodec  # noqa: E402


def _emit_gf_mul_module(gf, name: str) -> List[str]:
    lines = [
        f"module {name} (",
        "    input  wire [7:0] a,",
        "    input  wire [7:0] b,",
        "    output wire [7:0] y",
        ");",
        "    reg [7:0] log_a, log_b, y_r;",
        "    reg [8:0] sum;",
        "    always @(*) begin",
        "        log_a = 8'd0; log_b = 8'd0; sum = 9'd0; y_r = 8'd0;",
        "        if (a != 8'd0) begin case (a)",
    ]
    for v in range(1, 256):
        if gf.log[v] >= 0:
            lines.append(f"            8'd{v}: log_a = 8'd{gf.log[v]};")
    lines += ["            default: log_a = 8'd0;", "        endcase end"]
    lines += ["        if (b != 8'd0) begin case (b)"]
    for v in range(1, 256):
        if gf.log[v] >= 0:
            lines.append(f"            8'd{v}: log_b = 8'd{gf.log[v]};")
    lines += [
        "            default: log_b = 8'd0;",
        "        endcase end",
        "        if (a == 8'd0 || b == 8'd0) y_r = 8'd0;",
        "        else begin",
        "            sum = {1'b0, log_a} + {1'b0, log_b};",
        "            if (sum >= 9'd255) sum = sum - 9'd255;",
        "            case (sum[7:0])",
    ]
    for log_i in range(255):
        lines.append(f"                8'd{log_i}: y_r = 8'd{gf.exp[log_i]};")
    lines += [
        "                default: y_r = 8'd0;",
        "            endcase",
        "        end",
        "    end",
        "    assign y = y_r;",
        "endmodule",
        "",
    ]
    return lines


def _emit_rs_horner_syndromes(
    gf: GF256, n: int, cw_sig: str, tag: str, lines: List[str]
) -> List[str]:
    """Return final syndrome wire names S0..S3 (Horner, FCR=0)."""
    finals: List[str] = []
    for i in range(4):
        root = gf.exp[i]
        current = "8'b0"
        for j in range(n):
            byte_j = f"{cw_sig}[{j * 8 + 7}:{j * 8}]"
            if j > 0:
                mult = f"{tag}_mul_{i}_{j}"
                lines.extend(generate_const_matrix_mul(gf, root, current, mult))
                lines.append(f"    wire [7:0] {mult};")
                nxt = f"{tag}_sum_{i}_{j}"
                lines.append(f"    wire [7:0] {nxt} = {mult} ^ {byte_j};")
                current = nxt
            else:
                current = byte_j
        finals.append(current)
    return finals


def _emit_gf_inv_module(gf, name: str) -> List[str]:
    lines = [
        f"module {name} (",
        "    input  wire [7:0] a,",
        "    output wire [7:0] y",
        ");",
        "    reg [7:0] y_r;",
        "    always @(*) begin",
        "        y_r = 8'd0;",
        "        if (a != 8'd0) begin case (a)",
    ]
    for v in range(1, 256):
        lines.append(f"            8'd{v}: y_r = 8'd{gf.inv(v)};")
    lines += [
        "        default: y_r = 8'd0;",
        "        endcase end",
        "    end",
        "    assign y = y_r;",
        "endmodule",
        "",
    ]
    return lines


def emit_rs_t2_decoder_comb(
    codec: RSCodec,
    lines: List[str],
    syn_last_idx: int,
) -> None:
    gf = codec.gf
    n, k, width = codec.n, codec.k, codec.width

    def gmul(a: str, b: str, tag: str) -> str:
        o = f"gm_{tag}"
        lines.append(f"    wire [7:0] {o};")
        lines.append(f"    rs_gf_mul u_{tag} (.a({a}), .b({b}), .y({o}));")
        return o

    lines.append("    // --- BEGIN METAPROGRAMMING COMPLETION (t=2 PGZ + Forney, FCR=0) ---")
    for i in range(4):
        lines.append(f"    wire [7:0] S{i} = syn_sum_{i}_{syn_last_idx};")

    s0s2 = gmul("S0", "S2", "s0s2")
    s1sq = gmul("S1", "S1", "s1sq")
    lines.append(f"    wire [7:0] delta = {s0s2} ^ {s1sq};")
    lines.append("    wire delta_zero = (delta == 8'd0);")
    lines.append("    wire one_err = delta_zero & (|S0);")

    lines.append("    wire [7:0] inv_S0;")
    lines.append("    rs_gf_inv u_inv_s0 (.a(S0), .y(inv_S0));")
    sigma1_one = gmul("S1", "inv_S0", "s1o0")
    lines.append(f"    wire [7:0] sigma1_one = {sigma1_one};")
    lines.append("    wire [7:0] sigma2_one = 8'd0;")

    lines.append("    wire [7:0] inv_delta;")
    lines.append("    rs_gf_inv u_inv_d (.a(delta), .y(inv_delta));")
    s0s3 = gmul("S0", "S3", "s0s3")
    s1s2 = gmul("S1", "S2", "s1s2")
    s1s3 = gmul("S1", "S3", "s1s3")
    s2sq = gmul("S2", "S2", "s2sq")
    lines.append(f"    wire [7:0] pgz_num1 = {s0s3} ^ {s1s2};")
    lines.append(f"    wire [7:0] pgz_num2 = {s1s3} ^ {s2sq};")
    sig1_two = gmul("pgz_num1", "inv_delta", "sig1t")
    sig2_two = gmul("pgz_num2", "inv_delta", "sig2t")
    lines.append(f"    wire [7:0] sigma1_two = {sig1_two};")
    lines.append(f"    wire [7:0] sigma2_two = {sig2_two};")
    lines.append("    wire [7:0] sigma1 = one_err ? sigma1_one : sigma1_two;")
    lines.append("    wire [7:0] sigma2 = one_err ? sigma2_one : sigma2_two;")

    lines.append("    wire [7:0] Omega0 = S0;")
    o1t = gmul("S0", "sigma1", "o1t")
    lines.append(f"    wire [7:0] Omega1 = S1 ^ {o1t};")

    lines.append("    wire [7:0] inv_sigma1;")
    lines.append("    rs_gf_inv u_inv_s1 (.a(sigma1), .y(inv_sigma1));")

    root_hits = []
    for pos in range(n):
        x_loc = codec.locator_x(pos)
        x_inv = codec.chien_x(pos)
        t1 = gmul("sigma1", f"8'd{x_inv}", f"x1_{pos}")
        t2 = gmul("sigma2", f"8'd{x_inv}", f"x2_{pos}")
        t2sq = gmul(t2, f"8'd{x_inv}", f"x2sq_{pos}")
        lines.append(f"    wire [7:0] sigma_at_{pos} = 8'd1 ^ {t1} ^ {t2sq};")
        lines.append(f"    wire chien_hit_{pos} = (sigma_at_{pos} == 8'd0) & (|sigma1);")
        root_hits.append(f"chien_hit_{pos}")

        omt = gmul("Omega1", f"8'd{x_inv}", f"om_{pos}")
        num = f"Omega0 ^ {omt}"
        numt = gmul(num, "inv_sigma1", f"nt_{pos}")
        mag = gmul(numt, f"8'd{x_loc}", f"mag_{pos}")
        lines.append(f"    wire [7:0] err_mag_{pos} = chien_hit_{pos} ? {mag} : 8'd0;")

    cnt_w = max(1, (n).bit_length())
    lines.append(f"    wire [{cnt_w - 1}:0] root_cnt = {' + '.join(root_hits)};")
    lines.append(f"    wire [{cnt_w - 1}:0] exp_roots = one_err ? {cnt_w}'d1 : {cnt_w}'d2;")
    lines.append("    wire decode_ok = has_error & (root_cnt == exp_roots);")

    for i in range(k):
        hi = i * 8 + 7
        lo = i * 8
        lines.append(
            f"    wire [7:0] corr_byte_{i} = codeword_in[{hi}:{lo}] ^ err_mag_{i};"
        )
    pack = ", ".join(f"corr_byte_{i}" for i in reversed(range(k)))
    lines.append(f"    wire [{width - 1}:0] data_out_corr = {{{pack}}};")
    lines.append(
        f"    wire [{width - 1}:0] data_out_dec = (has_error & decode_ok & "
        f"syndromes_clear) ? data_out_corr : codeword_in[{width - 1}:0];"
    )
    lines.append(f"    wire [{8 * n - 1}:0] corr_cw;")
    for j in range(n):
        lines.append(
            f"    assign corr_cw[{j * 8 + 7}:{j * 8}] = "
            f"codeword_in[{j * 8 + 7}:{j * 8}] ^ err_mag_{j};"
        )
    gf256 = GF256()
    chk_syns = _emit_rs_horner_syndromes(gf256, n, "corr_cw", "syn_chk", lines)
    chk_ok = []
    for i, s in enumerate(chk_syns):
        lines.append(f"    wire syn_chk_zero_{i} = ({s} == 8'd0);")
        chk_ok.append(f"syn_chk_zero_{i}")
    lines.append(f"    wire syndromes_clear = {' & '.join(chk_ok)};")
    lines.append(
        "    wire error_corrected_dec = has_error & decode_ok & syndromes_clear;"
    )
    lines.append("    // --- END METAPROGRAMMING COMPLETION ---")


def generate_rs_repaired(width: int, raw_path: str, out_path: str) -> None:
    codec = RSCodec.for_width(width)
    cw_bits = 8 * codec.n
    with open(raw_path, encoding="utf-8") as f:
        src = f.read()

    cut = src.find("    assign has_error = ")
    if cut < 0:
        raise RuntimeError("has_error assign not found")
    end_has = src.find(";", cut) + 1
    legacy = src[:end_has]
    syn_idxs = [int(x) for x in re.findall(r"syn_sum_0_(\d+)", legacy)]
    if not syn_idxs:
        raise RuntimeError("cannot find syn_sum_0_N in legacy RTL")
    syn_last_idx = max(syn_idxs)
    if syn_last_idx != codec.n - 1:
        print(
            f"  note w{width}: syn_last_idx={syn_last_idx} (expected {codec.n - 1})"
        )

    parts: List[str] = [
        f"// Repaired reed_solomon_ecc_w{width}: RS(n={codec.n},k={codec.k},t=2) LLM syndrome + PGZ comb",
        "",
    ]
    parts += _emit_gf_mul_module(codec.gf, "rs_gf_mul")
    parts += _emit_gf_inv_module(codec.gf, "rs_gf_inv")

    mod_start = legacy.find("module")
    body = legacy[mod_start:]
    body_lines = []
    for ln in body.splitlines():
        if ln.strip().startswith("always @"):
            break
        body_lines.append(ln)
    parts.extend(body_lines)

    dec: List[str] = []
    emit_rs_t2_decoder_comb(codec, dec, syn_last_idx)
    parts.extend(dec)

    parts += [
        "    always @(posedge clk or negedge rst_n) begin",
        "        if (!rst_n) begin",
        f"            codeword_out <= {cw_bits}'d0;",
        f"            data_out <= {width}'d0;",
        "            error_detected <= 1'b0;",
        "            error_corrected <= 1'b0;",
        "            valid_out <= 1'b0;",
        "        end else begin",
        "            valid_out <= 1'b0;",
        "            if (encode_en) begin",
        "                codeword_out <= encoded_result;",
        "                valid_out <= 1'b1;",
        "            end",
        "            if (decode_en) begin",
        "                data_out <= data_out_dec;",
        "                error_detected <= has_error;",
        "                error_corrected <= error_corrected_dec;",
        "                valid_out <= 1'b1;",
        "            end",
        "        end",
        "    end",
        "endmodule",
        "",
    ]

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(parts))
    print(f"Wrote {out_path}")


RS_WIDTHS = (4, 8, 16, 32, 64, 128)


def main() -> None:
    root = os.path.join(os.path.dirname(__file__), "..")
    out_dir = os.path.join(root, "verilogs/repaired_golden/generated")
    for width in RS_WIDTHS:
        mod = f"reed_solomon_ecc_w{width}"
        for sub in ("verilogs/raw_llm_generated/generated", "verilogs/generated"):
            raw = os.path.join(root, sub, f"{mod}.v")
            if os.path.isfile(raw):
                break
        else:
            print(f"SKIP w{width}: no LLM source for {mod}")
            continue
        generate_rs_repaired(width, raw, os.path.join(out_dir, f"{mod}.v"))


if __name__ == "__main__":
    main()
