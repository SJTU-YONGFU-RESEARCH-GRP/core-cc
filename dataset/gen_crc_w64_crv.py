#!/usr/bin/env python3
"""Generate core_cc_vectors_crc_w64_crv.jsonl (walking + ~4k CRV)."""
from generate_vectors import ECCDatasetGenerator

if __name__ == "__main__":
    g = ECCDatasetGenerator("core_cc_vectors_crc_w64_crv.jsonl")
    g.generate_crc_large_crv(64, num_random_per_tier=1000, num_clean_random=500)
    g.save_to_file()
