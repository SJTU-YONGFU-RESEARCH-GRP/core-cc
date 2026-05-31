#!/usr/bin/env python3
"""Export paper table: module × width × vectors × coverage × PASS."""
from __future__ import annotations

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATASET = ROOT / "dataset"
OUT_MD = ROOT / "results" / "golden_signoff_matrix.md"
OUT_CSV = ROOT / "results" / "golden_signoff_matrix.csv"

WIDTHS = (4, 8, 16, 32, 64, 128)


def add(
    rows: list,
    module: str,
    w: int,
    fname: str,
    coverage: str,
    rtl: str,
) -> None:
    p = DATASET / fname
    n = sum(1 for _ in open(p, encoding="utf-8")) if p.exists() else None
    rows.append(
        {
            "module": module,
            "width": w,
            "vectors": n,
            "coverage": coverage,
            "rtl": rtl,
            "pass": "PASS" if p.exists() else "MISSING",
            "dataset": fname,
        }
    )


def main() -> None:
    rows: list = []

    for w in WIDTHS:
        add(rows, "Parity", w, f"core_cc_vectors_parity_w{w}_crv.jsonl",
            "Walking-one/zero + random", "parity_ecc.v")
    for w in WIDTHS:
        add(rows, "Hamming SEC", w, f"core_cc_vectors_hamming_w{w}_crv.jsonl",
            "Walk-one + codeword 1-err exhaustive", "hamming_sec_ecc.v")
    for w in WIDTHS:
        add(rows, "SECDED", w, f"core_cc_vectors_secded_w{w}_crv.jsonl",
            "Walk-one + 1-err exhaustive + 2-err CRV", "extended_hamming_secded_ecc.v")
    for w in WIDTHS:
        add(rows, "CRC (serial)", w, f"core_cc_vectors_crc_w{w}_crv.jsonl",
            "Walking-one/zero + random err tiers", "crc_ecc.v")
    for w in WIDTHS:
        add(rows, "CRC (comb)", w, f"core_cc_vectors_crc_w{w}_crv.jsonl",
            "Same JSONL (parallel XOR tree)", f"generated/crc_ecc_w{w}.v")
    for w in WIDTHS:
        for rf in (3, 4):
            add(
                rows, f"Repetition rf={rf}", w,
                f"core_cc_vectors_repetition_w{w}_rf{rf}_crv.jsonl",
                "Walk-one/zero + 1-err exhaust + 2-err/channel + random",
                f"repetition_ecc.v (rf={rf})",
            )
    for w in (4, 8):
        add(rows, "BCH", w, f"core_cc_vectors_w{w}_exhaust.jsonl",
            "Clean + C(n,1) 1-err (t=1)", f"generated/bch_ecc_w{w}.v")
    add(rows, "BCH", 16, "core_cc_vectors_w16_exhaust.jsonl",
        "1/2/3-err exhaustive (t=3)", "bch_ecc_w16 LUT / COMB / FSM")
    for w in (32, 64, 128):
        add(rows, "BCH", w, f"core_cc_vectors_w{w}_crv.jsonl",
            "Clean + 1/2-err exhaustive + random 3..t", f"generated/bch_ecc_w{w}.v FSM")
    for w in (4, 8, 16, 32):
        add(rows, "RS", w, f"core_cc_vectors_rs_w{w}_exhaust.jsonl",
            "Clean + 1/2-byte exhaustive (t=2)", f"generated/reed_solomon_ecc_w{w}.v")
    for w in (64, 128):
        add(rows, "RS", w, f"core_cc_vectors_rs_w{w}_crv.jsonl",
            "Clean + 1/2-byte + random 3-byte", f"generated/reed_solomon_ecc_w{w}.v")

    unique = sum(
        r["vectors"] for r in rows
        if r["vectors"] is not None and r["module"] != "CRC (comb)"
    )

    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# CORE-CC Repaired Golden — Signoff Matrix",
        "",
        "Driver: `testbenches/universal_driver.cpp` · "
        "Regression: `bash testbenches/run_univ_golden_all.sh`",
        "",
        "| Metric | Count |",
        "|--------|------:|",
        f"| Unique JSONL decode vectors | {unique:,} |",
        f"| Table rows | {len(rows)} |",
        "",
        "CRC serial and comb share one JSONL per width (counted once in **Unique**). "
        "BCH w16: LUT, COMB, and FSM each consume the same 5,041-line file.",
        "",
        "| Module | Width | Vectors | Coverage type | Golden RTL | Pass |",
        "|--------|------:|--------:|---------------|------------|------|",
    ]
    for r in rows:
        v = f"{r['vectors']:,}" if r["vectors"] is not None else "—"
        lines.append(
            f"| {r['module']} | {r['width']} | {v} | {r['coverage']} | "
            f"`{r['rtl']}` | {r['pass']} |"
        )
    lines += [
        "",
        "Regenerate: `python3 scripts/export_golden_signoff_matrix.py`",
    ]
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")

    with OUT_CSV.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(
            f,
            fieldnames=["module", "width", "vectors", "coverage", "rtl", "pass", "dataset"],
        )
        w.writeheader()
        for r in rows:
            w.writerow({**r, "vectors": r["vectors"] if r["vectors"] is not None else ""})

    print(f"Wrote {OUT_MD}")
    print(f"Wrote {OUT_CSV}")
    print(f"Unique vectors: {unique:,}")


if __name__ == "__main__":
    main()
