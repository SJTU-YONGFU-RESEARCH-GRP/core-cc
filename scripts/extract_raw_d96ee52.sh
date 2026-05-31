#!/usr/bin/env bash
# Re-populate verilogs/raw_llm_generated and testbenches/legacy_d96ee52 from git d96ee52
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REV=d96ee52
RAW="$ROOT/verilogs/raw_llm_generated"
LEGACY="$ROOT/testbenches/legacy_d96ee52"

mkdir -p "$RAW/generated" "$LEGACY"

for f in parity_ecc.v crc_ecc.v repetition_ecc.v hamming_secded_ecc.v extended_hamming_ecc.v bch_ecc.v; do
  git show "$REV:verilogs/$f" > "$RAW/$f"
done

git ls-tree -r --name-only "$REV" verilogs/generated/ | while read -r path; do
  git show "$REV:$path" > "$RAW/generated/$(basename "$path")"
done

for tb in parity_ecc_tb.cpp crc_ecc_tb.cpp hamming_secded_ecc_tb.cpp \
          extended_hamming_ecc_tb.cpp bch_ecc_tb.cpp repetition_ecc_tb.cpp; do
  git show "$REV:testbenches/$tb" > "$LEGACY/$tb"
done

rm -f "$RAW/hamming_sec_ecc.v" "$RAW/extended_hamming_secded_ecc.v"
echo "Extracted raw RTL and legacy testbenches from $REV"
