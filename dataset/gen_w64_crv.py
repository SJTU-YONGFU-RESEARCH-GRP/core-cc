#!/usr/bin/env python3
"""Generate core_cc_vectors_w64_crv.jsonl only."""
from generate_vectors import ECCDatasetGenerator

if __name__ == "__main__":
    g = ECCDatasetGenerator("core_cc_vectors_w64_crv.jsonl")
    g.generate_bch_large_crv(64, num_random_per_tier=500)
    g.save_to_file()
