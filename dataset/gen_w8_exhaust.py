#!/usr/bin/env python3
"""Generate core_cc_vectors_w8_exhaust.jsonl only (20 clean + C(15,1)=15)."""
from generate_vectors import ECCDatasetGenerator

if __name__ == "__main__":
    g = ECCDatasetGenerator("core_cc_vectors_w8_exhaust.jsonl")
    g.generate_bch_exhaustive(8)
    g.save_to_file()
