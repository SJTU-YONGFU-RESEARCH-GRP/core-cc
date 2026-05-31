#!/usr/bin/env python3
"""Generate core_cc_vectors_crc_w128_crv.jsonl (walking + ~10k CRV)."""
from generate_vectors import ECCDatasetGenerator

if __name__ == "__main__":
    g = ECCDatasetGenerator("core_cc_vectors_crc_w128_crv.jsonl")
    g.generate_crc_large_crv(128, num_random_per_tier=2500, num_clean_random=2000)
    g.save_to_file()
