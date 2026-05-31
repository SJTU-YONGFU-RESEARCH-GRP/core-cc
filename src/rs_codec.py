#!/usr/bin/env python3
"""
RS(2^8) codec — FCR=0, t=2, aligned with generate_reed_solomon_verilog.py.

Syndromes: S0..S3 = eval(R, alpha^0..alpha^3) via Horner (syn_sum_0_7 .. syn_sum_3_7).
Decode: PGZ closed-form sigma + Chien(X^{-1}) + Forney (FCR=0 simplified).
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional, Tuple

PRIM_POLY = 0x11D
T = 2
NSYM = 2 * T


class GF256:
    def __init__(self, prim: int = PRIM_POLY) -> None:
        self.exp = [0] * 512
        self.log = [0] * 256
        x = 1
        for i in range(255):
            self.exp[i] = x
            self.log[x] = i
            x <<= 1
            if x & 0x100:
                x ^= prim
        for i in range(255, 512):
            self.exp[i] = self.exp[i - 255]

    def add(self, a: int, b: int) -> int:
        return a ^ b

    def mul(self, a: int, b: int) -> int:
        if a == 0 or b == 0:
            return 0
        return self.exp[self.log[a] + self.log[b]]

    def div(self, a: int, b: int) -> int:
        if b == 0:
            raise ZeroDivisionError
        if a == 0:
            return 0
        return self.exp[(self.log[a] - self.log[b]) % 255]

    def inv(self, a: int) -> int:
        return self.div(1, a)

    def sqr(self, a: int) -> int:
        return self.mul(a, a)

    def pow(self, a: int, e: int) -> int:
        if a == 0:
            return 0
        if e == 0:
            return 1
        return self.exp[(self.log[a] * e) % 255]


def poly_eval(coeffs_lo_to_hi: List[int], x: int, gf: GF256) -> int:
    y = 0
    xp = 1
    for c in coeffs_lo_to_hi:
        if c:
            y = gf.add(y, gf.mul(c, xp))
        xp = gf.mul(xp, x)
    return y


@dataclass
class RSCodec:
    width: int
    k: int
    n: int
    t: int
    gf: GF256

    @classmethod
    def for_width(cls, width: int) -> "RSCodec":
        k = min((width + 7) // 8, 251)
        return cls(width=width, k=k, n=k + NSYM, t=T, gf=GF256())

    def pack_bytes(self, codeword: int) -> List[int]:
        return [(codeword >> (8 * j)) & 0xFF for j in range(self.n)]

    def syndromes(self, codeword: int) -> List[int]:
        """S0..S3 (FCR=0): Horner at alpha^i."""
        bytes_ = self.pack_bytes(codeword)
        syn = []
        for i in range(NSYM):
            root = self.gf.exp[i]
            val = 0
            for b in bytes_:
                val = self.gf.add(self.gf.mul(val, root), b)
            syn.append(val)
        return syn

    def generator_poly(self) -> List[int]:
        g = [1]
        for i in range(NSYM):
            g = self._poly_mul_hi(g, [1, self.gf.exp[i]])
        return g

    def _poly_mul_hi(self, p1: List[int], p2: List[int]) -> List[int]:
        res = [0] * (len(p1) + len(p2) - 1)
        for i, a in enumerate(p1):
            for j, b in enumerate(p2):
                res[i + j] = self.gf.add(res[i + j], self.gf.mul(a, b))
        return res

    def encode(self, data: int) -> int:
        g = self.generator_poly()
        msg = [(data >> (8 * i)) & 0xFF for i in range(self.k)]
        state = [0] * NSYM
        for step in range(self.k):
            fb = self.gf.add(state[NSYM - 1], msg[step])
            new = [0] * NSYM
            for i in range(NSYM):
                if i == 0:
                    new[0] = self.gf.mul(g[NSYM], fb)
                else:
                    new[i] = self.gf.add(state[i - 1], self.gf.mul(g[NSYM - i], fb))
            state = new
        out = 0
        for i, b in enumerate(msg):
            out |= b << (8 * i)
        for i in range(NSYM):
            out |= state[NSYM - 1 - i] << (8 * (self.k + i))
        return out

    def locator_x(self, pos: int) -> int:
        """X_k = alpha^{n-1-pos} (byte error locator)."""
        return self.gf.pow(2, self.n - 1 - pos)

    def chien_x(self, pos: int) -> int:
        """Chien tests sigma at X_k^{-1}."""
        return self.gf.inv(self.locator_x(pos))

    def pgz_sigma(self, syn: List[int]) -> Optional[Tuple[List[int], int]]:
        """
        Return (sigma coeffs [1, s1, s2?], num_errors) or None if uncorrectable.
        Delta = S0*S2 + S1^2.
        """
        gf = self.gf
        s0, s1, s2, s3 = syn[0], syn[1], syn[2], syn[3]
        delta = gf.add(gf.mul(s0, s2), gf.sqr(s1))
        if delta == 0:
            if s0 == 0:
                return None
            return [1, gf.div(s1, s0)], 1
        s1_num = gf.add(gf.mul(s0, s3), gf.mul(s1, s2))
        s2_num = gf.add(gf.mul(s1, s3), gf.sqr(s2))
        return [1, gf.div(s1_num, delta), gf.div(s2_num, delta)], 2

    def forney_mag(self, syn: List[int], sigma: List[int], pos: int) -> int:
        """e_k = (Omega0 + Omega1*X_k^{-1}) / sigma1 * X_k; sigma' = sigma1 in char 2."""
        gf = self.gf
        s0, s1 = syn[0], syn[1]
        sigma1 = sigma[1]
        if sigma1 == 0:
            return 0
        omega0 = s0
        omega1 = gf.add(s1, gf.mul(s0, sigma1))
        x_inv = self.chien_x(pos)
        x_loc = self.locator_x(pos)
        num = gf.add(omega0, gf.mul(omega1, x_inv))
        return gf.mul(gf.div(num, sigma1), x_loc)

    def chien_positions(self, sigma: List[int]) -> List[int]:
        return [
            j for j in range(self.n)
            if poly_eval(sigma, self.chien_x(j), self.gf) == 0
        ]

    def decode(self, codeword: int) -> Tuple[int, int, int]:
        cw = codeword & ((1 << (8 * self.n)) - 1)
        syn = self.syndromes(cw)
        mask = (1 << self.width) - 1
        data_out = (cw & ((1 << (8 * self.k)) - 1)) & mask

        if all(s == 0 for s in syn):
            return data_out, 0, 0

        pgz = self.pgz_sigma(syn)
        if pgz is None:
            return data_out, 1, 0
        sigma, n_err = pgz

        positions = self.chien_positions(sigma)
        if len(positions) != n_err:
            return data_out, 1, 0

        corrected = self.pack_bytes(cw)
        for pos in positions:
            mag = self.forney_mag(syn, sigma, pos)
            corrected[pos] ^= mag

        out_cw = sum(b << (8 * i) for i, b in enumerate(corrected))
        if any(self.syndromes(out_cw)):
            return data_out, 1, 0

        data_out = (out_cw & ((1 << (8 * self.k)) - 1)) & mask
        return data_out, 1, 1


if __name__ == "__main__":
    from itertools import combinations

    c = RSCodec.for_width(32)
    d = 0xDEADBEEF
    cw = c.encode(d)
    print("clean", hex(c.decode(cw)[0]), c.decode(cw)[1:])
    ok = fail = 0
    for nerr in range(3):
        tests = [()] if nerr == 0 else list(combinations(range(c.n), nerr))
        for pos in tests:
            mask = sum(0xFF << (8 * p) for p in pos)
            dout, det, cor = c.decode(cw ^ mask)
            exp = d & ((1 << 32) - 1)
            good = dout == exp and det == (1 if nerr else 0) and cor == (1 if nerr and nerr <= 2 else 0)
            if good:
                ok += 1
            else:
                fail += 1
                if fail <= 5:
                    print("FAIL", nerr, pos, hex(dout), det, cor)
    print("exhaust", ok, "pass", fail, "fail")
