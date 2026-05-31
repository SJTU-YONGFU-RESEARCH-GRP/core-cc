#!/usr/bin/env python3
import sys
from itertools import combinations

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent / "src"))
from bch_codec import BCHCodec

for w in (4, 8):
    c = BCHCodec.for_width(w)
    cw = c.encode(0xA & ((1 << w) - 1))
    n = c.n
    c1 = list(combinations(range(n), 1))
    c2 = list(combinations(range(n), 2))
    ok1 = sum(1 for comb in c1 if c.decode(cw ^ sum(1 << p for p in comb))[2])
    ok2 = sum(1 for comb in c2 if c.decode(cw ^ sum(1 << p for p in comb))[1] and not c.decode(cw ^ sum(1 << p for p in comb))[2])
    print(f"w{w} BCH({n},{c.k},t={c.t}): 1-err {ok1}/{len(c1)} cor=1, 2-err {ok2}/{len(c2)} det-only")
    det2 = cor2 = misc = 0
    for comb in c2:
        d, det, cor = c.decode(cw ^ sum(1 << p for p in comb))
        if det and cor:
            cor2 += 1
        elif det and not cor:
            det2 += 1
        else:
            misc += 1
    print(f"       2-err breakdown: det+cor={cor2} det-only={det2} other={misc}")
