#!/usr/bin/env python3
"""Generate core_cc_vectors_w16_exhaust.jsonl only (50 clean + 1..3 errors)."""
from generate_vectors import ECCDatasetGenerator

if __name__ == "__main__":
    g = ECCDatasetGenerator("core_cc_vectors_w16_exhaust.jsonl")
    g.generate_bch_exhaustive(16)
    g.save_to_file()
