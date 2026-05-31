#!/usr/bin/env python3
"""
Generate signoff CRV JSONL for parity / Hamming SEC / SECDED (w4..w128).

  parity_*   : walking-one/zero + random
  hamming_*  : walking-one bases + exhaustive 1-bit codeword errors
  secded_*   : walking-one + exhaustive 1-err + 2-err CRV (det=1, cor=0)
"""
from generate_vectors import ECCDatasetGenerator

# (width, random_err_tier, parity_clean_random, secded_double_random)
CLASSIC_ECC_PROFILES = (
    (4, 200, 50, 100),
    (8, 300, 100, 200),
    (16, 500, 200, 500),
    (32, 1000, 500, 1500),
    (64, 1000, 500, 2500),
    (128, 2500, 2000, 5000),
)

if __name__ == "__main__":
    import sys

    g = ECCDatasetGenerator()
    profiles = CLASSIC_ECC_PROFILES
    if len(sys.argv) > 1:
        want = {int(x) for x in sys.argv[1:]}
        profiles = [p for p in profiles if p[0] in want]
    for w, tier, clean, dbl in profiles:
        print(f"\n>>> classic ECC CRV width={w}")
        g.generate_classic_ecc_crv_all(
            w,
            num_random_per_tier=tier,
            num_clean_random=clean,
            num_double_random=dbl,
        )
    print("\nDone. Run: bash testbenches/run_univ_golden_all.sh")
