#!/usr/bin/env python3
"""BM step-by-step trace for BCH w32 forensic (Python vs hardware FSM model)."""

from __future__ import annotations

import sys
from pathlib import Path
from typing import List

_SRC = Path(__file__).resolve().parent
if str(_SRC) not in sys.path:
    sys.path.insert(0, str(_SRC))

from bch_codec import BCHCodec, berlekamp_massey, chien_search  # noqa: E402


def fmt_c(c: List[int], n: int = 8) -> str:
    return "[" + ", ".join(str(x) for x in c[:n]) + "]"


def trace_canonical_bm(syndromes: List[int], gf, t: int) -> List[int]:
    """Matches bch_codec.berlekamp_massey (reference oracle)."""
    size = len(syndromes) + t + 1
    c = [0] * size
    b = [0] * size
    c[0] = 1
    b[0] = 1
    L = 0
    m = 1
    b_val = 1

    print("\n=== Canonical BM (bch_codec.berlekamp_massey) ===")
    print(f"syndromes S1..S{len(syndromes)} = {syndromes}")

    for n in range(len(syndromes)):
        d = syndromes[n]
        for i in range(1, L + 1):
            d = gf.add(d, gf.mul(c[i], syndromes[n - i]))
        print(f"\nstep n={n}: d={d} L={L} m={m} b_val={b_val}")
        print(f"  c before: {fmt_c(c)}")
        if d == 0:
            m += 1
            print("  action: d==0 -> m++")
        else:
            t_poly = c[:]
            coef = gf.div(d, b_val)
            swap = 2 * L <= n
            print(f"  coef=d/bval={coef} swap(2*L<=n)={swap} ({2*L}<={n})")
            for i in range(size):
                j = i + m
                if b[i] and j < size:
                    c[j] = gf.add(c[j], gf.mul(coef, b[i]))
            if swap:
                L = n + 1 - L
                b = t_poly
                b_val = d
                m = 1
                print(f"  after update+swap: L={L} m={m} b_val={b_val}")
            else:
                m += 1
                print(f"  after update: m={m}")
            print(f"  c after:  {fmt_c(c)}")

    out = c[: L + 1]
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    print(f"\nfinal lambda (deg {len(out)-1}): {out}")
    return out


def trace_hardware_bm(syndromes: List[int], gf, t: int, bm_size: int = 16) -> List[int]:
    """Cycle-accurate model of generate_bch_decoder_fsm.py BM FSM."""
    bm_c = [0] * bm_size
    bm_b = [0] * bm_size
    bm_c[0] = 1
    bm_b[0] = 1
    bm_L = 0
    bm_mreg = 1
    bm_bval = 1

    print("\n=== Hardware FSM BM model (deferred bval swap, coef latch) ===")
    print(f"syndromes = {syndromes}")

    for bm_step in range(len(syndromes)):
        d = syndromes[bm_step]
        for i in range(1, bm_L + 1):
            d = gf.add(d, gf.mul(bm_c[i], syndromes[bm_step - i]))

        print(f"\n--- bm_step={bm_step} ---")
        print(f"  bm_d_comb={d} bm_L={bm_L} bm_mreg={bm_mreg} bm_bval={bm_bval}")
        print(f"  bm_c: {fmt_c(bm_c)}")
        print(f"  bm_b: {fmt_c(bm_b)}")

        if d == 0:
            bm_mreg += 1
            print("  action: d==0 -> bm_mreg++")
        else:
            bm_t = bm_c[:]
            coef = gf.div(d, bm_bval)
            swap = 2 * bm_L <= bm_step
            print(f"  coef={coef} swap={swap} t_poly={fmt_c(bm_t)}")
            m_shift = bm_mreg
            if swap:
                bm_new_bval = d
                bm_L = bm_step + 1 - bm_L
                swap_pending = True
            else:
                swap_pending = False
                bm_new_bval = bm_bval
            coef_lat = coef
            for upd_i in range(bm_size):
                if bm_b[upd_i] and upd_i + m_shift < bm_size:
                    upd = gf.mul(coef_lat, bm_b[upd_i])
                    bm_c[upd_i + m_shift] = gf.add(bm_c[upd_i + m_shift], upd)
            if swap_pending:
                bm_b = bm_t[:]
                bm_bval = bm_new_bval
                bm_mreg = 1
                print(f"  swap end: bm_b<-t_poly, bm_L={bm_L} bm_bval={bm_bval} bm_mreg=1")
            else:
                bm_mreg += 1
            print(f"  after busy: bm_c={fmt_c(bm_c)} bm_bval={bm_bval}")

    lam = bm_c[: bm_L + 1]
    while len(lam) > 1 and lam[-1] == 0:
        lam.pop()
    print(f"\nfinal bm_c -> lambda: {lam} (L={bm_L})")
    return lam


def main() -> None:
    # Forensic target from JSONL: w32 [Exhaustive 2-Error] bits 0,5
    data = 0x138D994C
    cw_err = 0x9C6CCA604A12C9

    codec = BCHCodec.for_width(32)
    gf = codec.gf
    synd = codec.syndromes_gf(cw_err)

    print("=== Case: w32 2-error bits 0,5 ===")
    print(f"data_in   = 0x{data:08X}")
    print(f"codeword  = 0x{cw_err:015X}")
    print(f"weight    = {bin(cw_err).count('1')} (expect 2 err + codeword)")

    cw = codec.encode(data)
    print(f"err mask  = 0x{cw ^ cw_err:015X} (popcount={bin(cw ^ cw_err).count('1')})")

    d_out, det, cor = codec.decode(cw_err)
    print(f"decode    = 0x{d_out:08X} det={det} cor={cor} ok={d_out == data}")

    lam_ref = trace_canonical_bm(synd, gf, codec.t)
    lam_hw = trace_hardware_bm(synd, gf, codec.t)

    roots_ref = chien_search(lam_ref, gf, codec.n)
    roots_hw = chien_search(lam_hw, gf, codec.n)
    print(f"\nChien roots (canonical): {roots_ref}")
    print(f"Chien roots (hw model):  {roots_hw}")
    print(f"expected error positions: [0, 5]")


if __name__ == "__main__":
    main()
