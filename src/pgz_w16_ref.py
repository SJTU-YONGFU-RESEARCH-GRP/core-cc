#!/usr/bin/env python3
"""Reference PGZ / Cramer locator for BCH(31,16,t=3) — validate before comb Verilog emit."""

from __future__ import annotations

from itertools import combinations
from typing import List, Tuple

import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from bch_codec import BCHCodec, GF2m, berlekamp_massey, chien_search, poly_eval  # noqa: E402


def gf_det3(
    gf: GF2m,
    a: int,
    b: int,
    c: int,
    d: int,
    e: int,
    f: int,
    g: int,
    h: int,
    i: int,
) -> int:
    """3x3 determinant in GF."""
    return gf.add(
        gf.add(gf.mul(a, gf.add(gf.mul(e, i), gf.mul(f, h))),
               gf.mul(b, gf.add(gf.mul(d, i), gf.mul(f, g)))),
        gf.mul(c, gf.add(gf.mul(d, h), gf.mul(e, g))),
    )


def pgz_locator(syn: List[int], gf: GF2m, t: int = 3) -> Tuple[List[int], int]:
    """
    Combinatorial PGZ (Cramer) for nu in {0,1,2,3}.
    Returns (lambda coeffs low-to-high, nu_est).
    """
    s = list(syn) + [0] * (2 * t - len(syn))
    S1, S2, S3, S4, S5, S6 = s[: 2 * t]

    if all(x == 0 for x in s):
        return [1], 0

    # nu = 1: lambda = 1 + S1*x
    if S2 == gf.mul(S1, S1) and S4 == gf.mul(S2, S2) and S6 == gf.mul(S4, S2):
        return [1, S1], 1

    # nu = 2: Cramer on 2x2 system for 1 + l1 x + l2 x^2
    delta = gf.add(gf.mul(gf.mul(S1, S1), S1), S3)  # S1^3 + S3
    if delta != 0:
        delta2 = gf.add(gf.mul(gf.mul(S1, S1), S3), S5)  # S1^2*S3 + S5
        l2 = gf.div(delta2, delta)
        l1 = gf.add(S1, gf.div(gf.add(gf.mul(S1, S3), S5), delta))
        # alt l1 from PGZ: l1 = S1 + (S1*S3+S5)/delta — verify vs BM
        lam = [1, l1, l2]
        deg = 2 if l2 else (1 if l1 else 0)
        if deg == 2 and l2 == 0:
            lam = [1, l1]
            deg = 1
        return lam, 2

    # nu = 3: Cramer 3x3
    m11, m12, m13 = S1, S2, S3
    m21, m22, m23 = S2, S3, S4
    m31, m32, m33 = S3, S4, S5
    det_m = gf_det3(gf, m11, m12, m13, m21, m22, m23, m31, m32, m33)
    if det_m != 0:
        l3 = gf.div(
            gf_det3(gf, S4, S2, S3, S5, S3, S4, S6, S4, S5),
            det_m,
        )
        l2 = gf.div(
            gf_det3(gf, S1, S4, S3, S2, S5, S4, S3, S6, S5),
            det_m,
        )
        l1 = gf.div(
            gf_det3(gf, S1, S2, S4, S2, S3, S5, S3, S4, S6),
            det_m,
        )
        return [1, l1, l2, l3], 3

    return [1, S1], 1  # fallback


def pgz_locator_v2(syn: List[int], gf: GF2m, t: int = 3) -> List[int]:
    """Improved PGZ: pick nu by minors, then closed-form coefficients."""
    s = list(syn) + [0] * (2 * t - len(syn))
    S1, S2, S3, S4, S5, S6 = s[: 2 * t]

    if all(x == 0 for x in s):
        return [1]

    # 1-error consistency (odd syndromes = powers of S1)
    ok1 = S1 != 0
    if ok1:
        a2 = gf.mul(S1, S1)
        a4 = gf.mul(a2, a2)
        a6 = gf.mul(a4, a2)
        ok1 = S2 == a2 and S4 == a4 and S6 == a6
    if ok1:
        return [1, S1]

    delta = gf.add(gf.mul(gf.mul(S1, S1), S1), S3)
    det2 = gf.add(gf.mul(S1, S2), S3)  # S1*S2 + S3 for 2-error minor

    if delta != 0:
        l2 = gf.div(gf.add(gf.mul(gf.mul(S1, S1), S3), S5), delta)
        # Standard 2-error: l1 = S1 + l2*S1 ??? use BM-consistent:
        l1 = gf.add(
            S1,
            gf.div(gf.add(gf.mul(S1, S3), S5), delta),
        )
        if l2 != 0:
            return [1, l1, l2]
        return [1, l1]

    det_m = gf_det3(gf, S1, S2, S3, S2, S3, S4, S3, S4, S5)
    if det_m != 0:
        l3 = gf.div(gf_det3(gf, S4, S2, S3, S5, S3, S4, S6, S4, S5), det_m)
        l2 = gf.div(gf_det3(gf, S1, S4, S3, S2, S5, S4, S3, S6, S5), det_m)
        l1 = gf.div(gf_det3(gf, S1, S2, S4, S2, S3, S5, S3, S4, S6), det_m)
        return [1, l1, l2, l3]

    return berlekamp_massey(syn, gf, t)


def validate() -> None:
    codec = BCHCodec.for_width(16)
    gf = codec.gf
    n = codec.n
    fails = 0
    tests = 0
    data = 0x1234
    cw = codec.encode(data)
    for errs in range(4):
        if errs == 0:
            masks = [0]
        else:
            masks = [sum(1 << p for p in c) for c in combinations(range(n), errs)]
        for mask in masks:
            cw_e = cw ^ mask
            syn = codec.syndromes_gf(cw_e)
            lam_bm = berlekamp_massey(syn, gf, 3)
            lam_pgz = pgz_locator_v2(syn, gf)
            roots_bm = chien_search(lam_bm, gf, n)
            roots_pgz = chien_search(lam_pgz, gf, n)
            tests += 1
            if roots_bm != roots_pgz:
                fails += 1
                if fails <= 5:
                    print("FAIL", errs, hex(mask), "syn", syn)
                    print("  bm", lam_bm, roots_bm)
                    print("  pgz", lam_pgz, roots_pgz)
    print(f"tests={tests} fails={fails}")


def _debug_two() -> None:
    codec = BCHCodec.for_width(16)
    gf = codec.gf
    syn = [3, 5, 9, 17, 4, 11]
    S1, S2 = syn[0], syn[1]
    l2 = gf.add(gf.mul(S1, S1), S2)
    for lam in ([1, S1, l2], [1, l2, S1]):
        print(lam, chien_search(lam, gf, 31))
    print("bm", berlekamp_massey(syn, gf, 3), chien_search(berlekamp_massey(syn, gf, 3), gf, 31))


if __name__ == "__main__":
    _debug_two()
    validate()
