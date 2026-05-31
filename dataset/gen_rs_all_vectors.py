#!/usr/bin/env python3
"""Generate all RS exhaustive + CRV JSONL files."""
from generate_vectors import ECCDatasetGenerator

EXHAUST_WIDTHS = (4, 8, 16, 32)
# (width, num_clean, num_random_3byte) — target ~2.4k–3k vectors per width
# Fixed: n + C(n,2) exhaustive 1/2-byte on random base + clean + 3-byte CRV tier
CRV_WIDTHS = ((64, 500, 1800), (128, 800, 2000))

if __name__ == "__main__":
    for w in EXHAUST_WIDTHS:
        g = ECCDatasetGenerator(f"core_cc_vectors_rs_w{w}_exhaust.jsonl")
        g.generate_rs_exhaustive(w, num_clean=20)
        g.save_to_file()
    for w, clean, tier in CRV_WIDTHS:
        g = ECCDatasetGenerator(f"core_cc_vectors_rs_w{w}_crv.jsonl")
        g.generate_rs_crv(w, num_random_per_tier=tier, num_clean=clean)
        g.save_to_file()
