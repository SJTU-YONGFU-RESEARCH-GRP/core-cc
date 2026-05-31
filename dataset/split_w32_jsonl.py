#!/usr/bin/env python3
"""Split w32 BCH CRV vectors from core_cc_vectors.jsonl into a dedicated file."""
import json
from pathlib import Path

src = Path(__file__).parent / "core_cc_vectors.jsonl"
w32_out = Path(__file__).parent / "core_cc_vectors_w32_crv.jsonl"
slim_out = Path(__file__).parent / "core_cc_vectors_slim.jsonl"

w32_lines, rest_lines = [], []
with src.open() as f:
    for line in f:
        r = json.loads(line)
        if r.get("data_width") == 32 and r.get("module") == "bch_ecc":
            w32_lines.append(line)
        else:
            rest_lines.append(line)

w32_out.write_text("".join(w32_lines))
slim_out.write_text("".join(rest_lines))
print(f"w32_crv={len(w32_lines)} slim={len(rest_lines)}")
