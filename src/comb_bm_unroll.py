#!/usr/bin/env python3
"""Unroll Berlekamp-Massey into combinational wire names (validate vs bch_codec)."""

from __future__ import annotations

import os
import sys
from typing import Dict, List, Tuple

sys.path.insert(0, os.path.dirname(__file__))
from bch_codec import GF2m, berlekamp_massey  # noqa: E402


def bm_step_python(
    syn: List[int],
    gf: GF2m,
    t: int,
    c: List[int],
    b: List[int],
    L: int,
    mreg: int,
    bval: int,
    n: int,
) -> Tuple[List[int], List[int], int, int, int, bool]:
    """One BM iteration; returns updated state + swap flag."""
    d = syn[n]
    for i in range(1, L + 1):
        d = gf.add(d, gf.mul(c[i], syn[n - i]))
    if d == 0:
        return c, b, L, mreg + 1, bval, False
    t_poly = c[:]
    coef = gf.div(d, bval)
    swap = 2 * L <= n
    new_c = c[:]
    for i in range(len(c)):
        if b[i] and i + mreg < len(c):
            new_c[i + mreg] = gf.add(new_c[i + mreg], gf.mul(coef, b[i]))
    if swap:
        L = n + 1 - L
        b = t_poly[:]
        bval = d
        mreg = 1
    else:
        mreg += 1
    return new_c, b, L, mreg, bval, swap


def unroll_bm_int(syn: List[int], gf: GF2m, t: int) -> List[int]:
    """Full unroll; return lambda coeffs."""
    size = 2 * t + t + 1
    c = [0] * size
    b = [0] * size
    c[0] = 1
    b[0] = 1
    L, mreg, bval = 0, 1, 1
    for n in range(2 * t):
        c, b, L, mreg, bval, _ = bm_step_python(syn, gf, t, c, b, L, mreg, bval, n)
    out = c[: L + 1]
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out if out else [1]


def validate_unroll(t: int = 3) -> int:  # noqa: D103
    from itertools import combinations

    from bch_codec import BCHCodec  # noqa: WPS433

    codec = BCHCodec.for_width(16)
    gf = codec.gf
    fails = 0
    cw = codec.encode(0x1234)
    for e in range(4):
        masks = [0] if e == 0 else [sum(1 << p for p in c) for c in combinations(range(codec.n), e)]
        for mask in masks:
            syn = codec.syndromes_gf(cw ^ mask)
            a = berlekamp_massey(syn, gf, t)
            b = unroll_bm_int(syn, gf, t)
            if a != b:
                fails += 1
    return fails


def validate_full_disc(t: int = 3) -> int:
    from itertools import combinations

    from bch_codec import BCHCodec  # noqa: WPS433

    codec = BCHCodec.for_width(16)
    gf = codec.gf
    size = 2 * t + t + 1
    fails = 0
    cw = codec.encode(0x1234)
    for e in range(4):
        masks = [0] if e == 0 else [sum(1 << p for p in c) for c in combinations(range(codec.n), e)]
        for mask in masks:
            syn = codec.syndromes_gf(cw ^ mask)
            c = [0] * size
            b = [0] * size
            c[0] = b[0] = 1
            L, mreg, bval = 0, 1, 1
            for n in range(2 * t):
                d = syn[n]
                for i in range(1, t + 1):
                    if n >= i:
                        d = gf.add(d, gf.mul(c[i], syn[n - i]))
                if d == 0:
                    mreg += 1
                else:
                    tp = c[:]
                    coef = gf.div(d, bval)
                    for i in range(size):
                        if b[i] and i + mreg < size:
                            c[i + mreg] = gf.add(c[i + mreg], gf.mul(coef, b[i]))
                    if 2 * L <= n:
                        L = n + 1 - L
                        b = tp[:]
                        bval = d
                        mreg = 1
                    else:
                        mreg += 1
            out = c[: L + 1]
            while len(out) > 1 and out[-1] == 0:
                out.pop()
            if berlekamp_massey(syn, gf, t) != (out or [1]):
                fails += 1
    return fails


if __name__ == "__main__":
    print("unroll fails:", validate_unroll())
    print("full-disc fails:", validate_full_disc())


class CombBmEmitter:
    """Emit Verilog wire expressions for unrolled BM."""

    def __init__(self, gf: GF2m, t: int, mul_mod: str, inv_mod: str) -> None:
        self.gf = gf
        self.t = t
        self.m = gf.m
        self.size = 2 * t + t + 1
        self.mul_mod = mul_mod
        self.inv_mod = inv_mod
        self.lines: List[str] = []
        self._mul_i = 0

    def _const(self, v: int) -> str:
        return f"{self.m}'d{v}"

    def _mul(self, a: str, b: str) -> str:
        if a == f"{self.m}'d0" or b == f"{self.m}'d0":
            return f"{self.m}'d0"
        if a == f"{self.m}'d1":
            return b
        if b == f"{self.m}'d1":
            return a
        y = f"bm_mul{self._mul_i}"
        self._mul_i += 1
        self.lines.append(f"    wire [{self.m - 1}:0] {y};")
        self.lines.append(f"    {self.mul_mod} u_{y} (.a({a}), .b({b}), .y({y}));")
        return y

    def _add(self, a: str, b: str) -> str:
        if a == f"{self.m}'d0":
            return b
        if b == f"{self.m}'d0":
            return a
        return f"({a} ^ {b})"

    def _div(self, a: str, b: str) -> str:
        inv = f"bm_inv{self._mul_i}"
        self._mul_i += 1
        self.lines.append(f"    wire [{self.m - 1}:0] {inv};")
        self.lines.append(f"    {self.inv_mod} u_{inv} (.a({b}), .y({inv}));")
        return self._mul(a, inv)

    def emit(self, syn: List[str]) -> Tuple[List[str], List[str]]:
        """syn[j] = wire name for S_{j+1}. Returns (lines, lambda wire names)."""
        c = [self._const(1 if i == 0 else 0) for i in range(self.size)]
        b = [self._const(1 if i == 0 else 0) for i in range(self.size)]
        L = 0
        mreg = 1
        bval = self._const(1)

        for n in range(2 * self.t):
            d_terms = [syn[n]]
            for i in range(1, L + 1):
                d_terms.append(self._mul(c[i], syn[n - i]))
            d = d_terms[0]
            for t2 in d_terms[1:]:
                d = self._add(d, t2)

            # d==0 branch: only mreg++
            # For comb we always compute both paths and mux? Simpler: BM for BCH
            # always takes d!=0 path often - use Python to know d const? NO must be dynamic.

            # Emit dynamic update (full hardware)
            d_is_zero = f"bm_d_zero_{n}"
            self.lines.append(f"    wire {d_is_zero} = ({d} == {self.m}'d0);")

            # coef = d/bval
            coef = self._div(d, bval)

            swap = 2 * L <= n
            new_c = c[:]
            for i in range(self.size):
                if i + mreg < self.size:
                    upd = self._mul(coef, b[i])
                    # apply only when b[i]!=0 - in verilog b[i] is wire
                    term = self._mul(coef, b[i])  # mul by zero yields 0
                    new_c[i + mreg] = self._add(new_c[i + mreg], term)

            if swap:
                new_L = n + 1 - L
                new_b = c[:]
                new_bval = d
                new_m = 1
            else:
                new_L = L
                new_b = b[:]
                new_bval = bval
                new_m = mreg + 1

            # Mux d==0: keep state, mreg++
            # This is getting messy - use always @(*) block in verilog instead?

            c, b, L, mreg, bval = new_c, new_b, new_L, new_m, new_bval

        lam = c[: self.t + 1]
        return self.lines, lam
