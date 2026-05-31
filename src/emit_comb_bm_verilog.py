#!/usr/bin/env python3
"""Emit combinational straight-line BM Verilog (matches bch_codec BM + swap/m timing)."""

from __future__ import annotations

from typing import List, Tuple

_M = 5
_T = 3
_BM_SIZE = 2 * _T + _T + 1


def emit_comb_bm(
    syn: List[str],
    mul_mod: str,
    inv_mod: str,
) -> Tuple[List[str], List[str]]:
    lines: List[str] = []
    mul_id = 0

    def const(v: int) -> str:
        return f"{_M}'d{v}"

    def xor2(a: str, b: str) -> str:
        if a.endswith("'d0"):
            return b
        if b.endswith("'d0"):
            return a
        return f"({a} ^ {b})"

    def mul(a: str, b: str) -> str:
        nonlocal mul_id
        if a.endswith("'d0") or b.endswith("'d0"):
            return f"{_M}'d0"
        if a.endswith("'d1"):
            return b
        if b.endswith("'d1"):
            return a
        mul_id += 1
        y = f"cbm_m{mul_id}"
        lines.append(f"    wire [{_M - 1}:0] {y};")
        lines.append(f"    {mul_mod} u_{y} (.a({a}), .b({b}), .y({y}));")
        return y

    def div(a: str, b: str) -> str:
        nonlocal mul_id
        mul_id += 1
        inv = f"cbm_inv{mul_id}"
        lines.append(f"    wire [{_M - 1}:0] {inv};")
        lines.append(f"    {inv_mod} u_{inv} (.a({b}), .y({inv}));")
        return mul(a, inv)

    lines.append("    wire [4:0] bm_L_s0 = 5'd0;")
    lines.append("    wire [4:0] bm_mreg_s0 = 5'd1;")

    c = [const(1 if i == 0 else 0) for i in range(_BM_SIZE)]
    b = [const(1 if i == 0 else 0) for i in range(_BM_SIZE)]
    bval = const(1)
    L_wire = "bm_L_s0"
    mreg_wire = "bm_mreg_s0"

    for n in range(2 * _T):
        d = syn[n]
        for i in range(1, _T + 1):
            if n >= i:
                d = xor2(d, mul(c[i], syn[n - i]))

        lines.append(f"    wire [{_M - 1}:0] bm_d_s{n};")
        lines.append(f"    assign bm_d_s{n} = {d};")
        lines.append(f"    wire bm_dz_s{n} = (bm_d_s{n} == {_M}'d0);")

        coef = div(f"bm_d_s{n}", bval)

        # Save t_poly = c before update
        t_poly = [f"bm_t_s{n}_{i}" for i in range(_BM_SIZE)]
        for i in range(_BM_SIZE):
            lines.append(f"    wire [{_M - 1}:0] {t_poly[i]};")
            lines.append(f"    assign {t_poly[i]} = {c[i]};")

        c_busy = c[:]
        prod_cache: dict[int, str] = {}
        for ui in range(_BM_SIZE):
            for m in range(1, 8):
                j = ui + m
                if j < _BM_SIZE:
                    if ui not in prod_cache:
                        prod_cache[ui] = mul(coef, b[ui])
                    gate = f"cbm_g{n}_{ui}_{m}"
                    lines.append(f"    wire [{_M - 1}:0] {gate};")
                    lines.append(
                        f"    assign {gate} = ({mreg_wire} == 5'd{m}) ? "
                        f"{prod_cache[ui]} : {_M}'d0;"
                    )
                    c_busy[j] = xor2(c_busy[j], gate)

        lines.append(f"    wire bm_swap_s{n} = (({L_wire} << 1) <= 5'd{n});")

        b_busy = [f"bm_bb_s{n}_{i}" for i in range(_BM_SIZE)]
        for i in range(_BM_SIZE):
            lines.append(f"    wire [{_M - 1}:0] {b_busy[i]};")
            lines.append(
                f"    assign {b_busy[i]} = bm_swap_s{n} ? {t_poly[i]} : {b[i]};"
            )

        bval_busy = f"bm_d_s{n}"
        m_busy = "5'd1"
        m_inc = f"({mreg_wire} + 5'd1)"
        L_busy_expr = f"({n} + 5'd1 - {L_wire})"

        c_next, b_next = [], []
        for i in range(_BM_SIZE):
            cn = f"bm_c{n + 1}_{i}"
            lines.append(f"    wire [{_M - 1}:0] {cn};")
            lines.append(f"    assign {cn} = bm_dz_s{n} ? {c[i]} : {c_busy[i]};")
            c_next.append(cn)
            bn = f"bm_b{n + 1}_{i}"
            lines.append(f"    wire [{_M - 1}:0] {bn};")
            lines.append(
                f"    assign {bn} = bm_dz_s{n} ? {b[i]} : {b_busy[i]};"
            )
            b_next.append(bn)

        bv = f"bm_bv{n + 1}"
        lines.append(f"    wire [{_M - 1}:0] {bv};")
        lines.append(
            f"    assign {bv} = bm_dz_s{n} ? {bval} : "
            f"(bm_swap_s{n} ? {bval_busy} : {bval});"
        )

        mn = f"bm_mreg_s{n + 1}"
        lines.append(f"    wire [4:0] {mn};")
        lines.append(
            f"    assign {mn} = bm_dz_s{n} ? {m_inc} : "
            f"(bm_swap_s{n} ? 5'd1 : {m_inc});"
        )

        ln = f"bm_L_s{n + 1}"
        lines.append(f"    wire [4:0] {ln};")
        lines.append(
            f"    assign {ln} = bm_dz_s{n} ? {L_wire} : "
            f"(bm_swap_s{n} ? {L_busy_expr} : {L_wire});"
        )

        c, b, bval = c_next, b_next, bv
        L_wire = ln
        mreg_wire = mn

    lam = [c[i] for i in range(_T + 1)]
    return lines, lam
