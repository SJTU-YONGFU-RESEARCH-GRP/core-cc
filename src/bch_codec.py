#!/usr/bin/env python3
"""
BCH codec matching verilogs/generated/bch_ecc_w*.v (systematic {data_k, parity} layout).

Decode: odd syndromes S_1..S_{2t-1}, Berlekamp-Massey, Chien search, bit-flip correction.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Tuple

# width -> (n, k, t, prim_poly)
BCH_CONFIGS: Dict[int, Tuple[int, int, int, int]] = {
    4: (7, 4, 1, 0b1011),
    8: (15, 11, 1, 0b10011),
    16: (31, 16, 3, 0b100101),
    32: (63, 32, 5, 0b1000011),
    64: (127, 64, 9, 0b10001001),
    128: (255, 128, 15, 0b100011101),
}


class GF2m:
    def __init__(self, m: int, prim_poly: int) -> None:
        self.m = m
        self.prim_poly = prim_poly
        self.size = 1 << m
        self.order = self.size - 1
        self.alpha_to_int = [0] * self.size
        self.int_to_alpha = [-1] * self.size
        x = 1
        for i in range(self.order):
            self.alpha_to_int[i] = x
            self.int_to_alpha[x] = i
            x <<= 1
            if x & self.size:
                x ^= self.prim_poly

    def add(self, a: int, b: int) -> int:
        return a ^ b

    def mul(self, a: int, b: int) -> int:
        if a == 0 or b == 0:
            return 0
        log_res = (self.int_to_alpha[a] + self.int_to_alpha[b]) % self.order
        return self.alpha_to_int[log_res]

    def div(self, a: int, b: int) -> int:
        if b == 0:
            raise ZeroDivisionError
        if a == 0:
            return 0
        log_res = (self.int_to_alpha[a] - self.int_to_alpha[b]) % self.order
        return self.alpha_to_int[log_res]

    def inv(self, a: int) -> int:
        return self.power(a, self.order - 1)

    def power(self, a: int, exp: int) -> int:
        if a == 0:
            return 0
        log_a = self.int_to_alpha[a]
        return self.alpha_to_int[(log_a * exp) % self.order]

    def alpha_pow(self, exp: int) -> int:
        """Return alpha^exp (alpha = primitive element 2)."""
        return self.power(2, exp % self.order)


def poly_eval(coeffs: List[int], x: int, gf: GF2m) -> int:
    """Evaluate poly at x; coeffs[i] is coeff of x^i."""
    y = 0
    xp = 1
    for c in coeffs:
        if c:
            y = gf.add(y, gf.mul(c, xp))
        xp = gf.mul(xp, x)
    return y


def berlekamp_massey(syndromes: List[int], gf: GF2m, max_degree: int) -> List[int]:
    """Return error-locator polynomial coefficients (low degree first)."""
    # Workspace must allow B(x)*x^m shifts without truncating (need ~len(synd)+max_degree).
    size = len(syndromes) + max_degree + 1
    c = [0] * size
    b = [0] * size
    c[0] = 1
    b[0] = 1
    L = 0
    m = 1
    b_val = 1

    for n in range(len(syndromes)):
        d = syndromes[n]
        for i in range(1, L + 1):
            d = gf.add(d, gf.mul(c[i], syndromes[n - i]))

        if d == 0:
            m += 1
        else:
            t_poly = c[:]
            coef = gf.div(d, b_val)
            # B(x) shifted by x^m (not x^{n-m})
            for i in range(size):
                j = i + m
                if b[i] and j < size:
                    c[j] = gf.add(c[j], gf.mul(coef, b[i]))
            if 2 * L <= n:
                L = n + 1 - L
                b = t_poly
                b_val = d
                m = 1
            else:
                m += 1

    out = c[: L + 1]
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out if out else [1]


def chien_search(sigma: List[int], gf: GF2m, n: int) -> List[int]:
  """Return error bit positions 0..n-1."""
  errs: List[int] = []
  for pos in range(n):
      x = gf.alpha_pow(-pos)
      if poly_eval(sigma, x, gf) == 0:
          errs.append(pos)
  return errs


@dataclass
class BCHCodec:
    width: int
    n: int
    k: int  # user data bits (width); may be < k_encode for w32+
    t: int
    prim_poly: int
    gf: GF2m
    parity_bits: int  # deg(g), not always n - k from the table
    k_encode: int  # message bits in codeword (n - parity_bits)
    g_poly: List[int]

    @classmethod
    def for_width(cls, width: int) -> "BCHCodec":
        if width not in BCH_CONFIGS:
            raise ValueError(f"unsupported width {width}")
        n, k, t, pp = BCH_CONFIGS[width]
        gf = GF2m(n.bit_length(), pp)
        from generate_bch_verilog import get_bch_generator_poly  # noqa: WPS433

        g_poly = get_bch_generator_poly(gf.m, n, k, t, pp)
        if g_poly is None:
            raise ValueError(f"no generator poly for width {width}")
        parity_bits = len(g_poly) - 1
        k_encode = n - parity_bits
        return cls(width, n, k, t, pp, gf, parity_bits, k_encode, g_poly)

    def pack_data_k(self, data: int) -> int:
        """Map width-bit user data into low bits of k_encode-bit message."""
        return data & ((1 << self.width) - 1)

    def encode(self, data: int) -> int:
        """Systematic codeword = {data_k, parity} (data MSB, parity LSB)."""
        dk = self.pack_data_k(data)
        g = self.g_poly
        rem = [0] * self.parity_bits
        for bit_i in range(self.k_encode - 1, -1, -1):
            feedback = ((dk >> bit_i) & 1) ^ rem[-1]
            nrem = [0] * self.parity_bits
            for j in range(self.parity_bits):
                src = rem[j - 1] if j > 0 else 0
                nrem[j] = src
                if j < len(g) and g[j]:
                    nrem[j] ^= feedback
            rem = nrem
        parity = 0
        for j in range(self.parity_bits):
            if rem[j]:
                parity |= 1 << j
        return (dk << self.parity_bits) | parity

    def syndromes_gf(self, codeword: int) -> List[int]:
        """S_1 .. S_{2t} as GF elements (matches generated syndrome wiring)."""
        cw = codeword & ((1 << self.n) - 1)
        alpha = 2
        out: List[int] = []
        for j in range(1, 2 * self.t + 1):
            sj = 0
            for i in range(self.n):
                if (cw >> i) & 1:
                    sj = self.gf.add(sj, self.gf.power(alpha, (j * i) % self.gf.order))
            out.append(sj)
        return out

    def syndrome_key(self, syn: List[int]) -> int:
        """Pack S_1..S_{2t} (m bits each, bit0 first) for ROM lookup."""
        key = 0
        shift = 0
        for sj in syn:
            for b in range(self.gf.m):
                if (sj >> b) & 1:
                    key |= 1 << shift
                shift += 1
        return key

    def decode(self, codeword: int) -> Tuple[int, int, int]:
        """Decode via Berlekamp-Massey + Chien search (O(t^2 + n*t))."""
        cw = codeword & ((1 << self.n) - 1)
        syn = self.syndromes_gf(cw)
        data_mask = (1 << self.width) - 1
        data_out = ((cw >> self.parity_bits) & ((1 << self.k_encode) - 1)) & data_mask

        if all(s == 0 for s in syn):
            return data_out, 0, 0

        sigma = berlekamp_massey(syn, self.gf, self.t)
        deg = len(sigma) - 1
        if deg <= 0 or deg > self.t:
            return data_out, 1, 0

        positions = chien_search(sigma, self.gf, self.n)
        if not positions or len(positions) > self.t:
            return data_out, 1, 0

        mask = sum(1 << p for p in positions)
        corrected = cw ^ mask
        data_out = ((corrected >> self.parity_bits) & ((1 << self.k_encode) - 1)) & data_mask
        return data_out, 1, 1


_DECODE_TABLES: Dict[int, Dict[int, int]] = {}
# Pre-build ROM tables where enumeration is feasible.
_TABLE_ERR_LIMIT: Dict[int, int] = {
    4: 1,
    8: 1,
    16: 3,
    32: 3,
    64: 2,
    128: 2,
}


def _get_decode_table(width: int) -> Dict[int, int]:
    if width not in _DECODE_TABLES:
        if width in _TABLE_ERR_LIMIT:
            _DECODE_TABLES[width] = build_syndrome_mask_table(
                width, max_errors=_TABLE_ERR_LIMIT[width]
            )
        else:
            _DECODE_TABLES[width] = {}
    return _DECODE_TABLES[width]


def _find_mask_for_syndrome(codec: "BCHCodec", syn: List[int]) -> int:
    """Locate error mask: fast paths, then bounded enumeration with caching."""
    from itertools import combinations

    gf = codec.gf
    target = codec.syndrome_key(syn)

    # --- 1-bit: S_j = S_1^j ---
    s1 = syn[0]
    if s1 != 0:
        ok = True
        for j in range(2, 2 * codec.t + 1):
            if syn[j - 1] != gf.power(s1, j):
                ok = False
                break
        if ok:
            e = gf.int_to_alpha[s1]
            return 1 << e

    # --- bounded search (w32+ skips 4..t bit patterns for speed) ---
    search_t = codec.t if codec.n <= 31 else min(codec.t, 3)
    base = codec.encode(0)
    for err_count in range(1, search_t + 1):
        for positions in combinations(range(codec.n), err_count):
            mask = sum(1 << p for p in positions)
            if codec.syndrome_key(codec.syndromes_gf(base ^ mask)) == target:
                return mask
    return 0


def build_syndrome_mask_table(width: int, max_errors: int | None = None) -> Dict[int, int]:
    """Brute-force syndrome -> err_mask (patterns up to max_errors bit flips)."""
    from itertools import combinations

    codec = BCHCodec.for_width(width)
    limit = max_errors if max_errors is not None else codec.t
    limit = min(limit, codec.t)
    table: Dict[int, int] = {}
    base = codec.encode(0)

    for err_count in range(1, limit + 1):
        for positions in combinations(range(codec.n), err_count):
            mask = sum(1 << p for p in positions)
            syn = codec.syndromes_gf(base ^ mask)
            if all(s == 0 for s in syn):
                continue
            key = codec.syndrome_key(syn)
            if key in table and table[key] != mask:
                raise RuntimeError(f"syndrome collision w{width} key={key:#x}")
            table[key] = mask
    return table
