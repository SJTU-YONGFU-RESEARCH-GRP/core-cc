#!/usr/bin/env python3
"""Generate core_cc_vectors_rs_w32_exhaust.jsonl."""
from generate_vectors import ECCDatasetGenerator

if __name__ == "__main__":
    g = ECCDatasetGenerator("core_cc_vectors_rs_w32_exhaust.jsonl")
    g.generate_rs_exhaustive(32, num_clean=20)
    g.save_to_file()
