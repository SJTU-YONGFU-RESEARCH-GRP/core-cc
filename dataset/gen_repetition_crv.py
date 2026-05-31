#!/usr/bin/env python3
"""
Generate repetition (TMR) signoff CRV JSONL for w4..w128, rf=3 and rf=4.
"""
from generate_vectors import ECCDatasetGenerator

# (width, rf3_random_singles, rf4_random_singles)
REPETITION_CRV_PROFILES = (
    (4, 100, 100),
    (8, 200, 200),
    (16, 300, 300),
    (32, 500, 500),
    (64, 800, 800),
    (128, 1000, 1000),
)

if __name__ == "__main__":
    import sys

    g = ECCDatasetGenerator()
    profiles = REPETITION_CRV_PROFILES
    if len(sys.argv) > 1:
        want = {int(x) for x in sys.argv[1:]}
        profiles = [p for p in profiles if p[0] in want]
    for w, r3, r4 in profiles:
        print(f"\n>>> repetition CRV width={w}")
        g.generate_repetition_crv_all(w, rf3_random=r3, rf4_random=r4)
    print("\nDone. Run: bash testbenches/run_univ_golden_all.sh")
