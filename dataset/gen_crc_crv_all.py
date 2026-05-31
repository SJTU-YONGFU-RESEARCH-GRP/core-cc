#!/usr/bin/env python3
"""Generate CRC CRV JSONL for w4..w128 (walking-one/zero + random error tiers)."""
from generate_vectors import ECCDatasetGenerator

# (width, random vectors per error tier, random clean count)
CRC_CRV_PROFILES = (
    (4, 200, 50),
    (8, 300, 100),
    (16, 500, 200),
    (32, 1000, 500),
    (64, 1000, 500),
    (128, 2500, 2000),
)

if __name__ == "__main__":
    for w, tier, clean in CRC_CRV_PROFILES:
        g = ECCDatasetGenerator(f"core_cc_vectors_crc_w{w}_crv.jsonl")
        g.generate_crc_large_crv(w, num_random_per_tier=tier, num_clean_random=clean)
        g.save_to_file()
