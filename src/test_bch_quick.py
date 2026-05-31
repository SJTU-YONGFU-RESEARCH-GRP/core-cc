import sys
sys.path.insert(0, ".")
from bch_codec import BCHCodec
from itertools import combinations

for w in [4, 8, 16, 32]:
    c = BCHCodec.for_width(w)
    data = 0xABCD if w == 16 else 0x12345678
    cw = c.encode(data)
    fails = 0
    tests = 0
    for errc in range(1, c.t + 1):
        for pos in combinations(range(c.n), errc):
            tests += 1
            d, det, cor = c.decode(cw ^ sum(1 << p for p in pos))
            if d != (data & ((1 << c.width) - 1)) or not det or not cor:
                fails += 1
    print(f"w{w}: {fails}/{tests} fails")
