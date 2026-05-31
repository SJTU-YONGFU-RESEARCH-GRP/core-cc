#!/usr/bin/env bash
# Universal-driver regression: RS(8,4,t=2) w32 — LLM syndrome + PGZ comb golden.
set -euo pipefail
cd "$(dirname "$0")"

RTL="../verilogs/repaired_golden/generated/reed_solomon_ecc_w32.v"
Mdir="obj_dir_univ_rs_w32"
EXE="univ_rs_w32"

verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
  --cc --exe --build -j 0 \
  --top-module reed_solomon_ecc_w32 \
  "$RTL" universal_driver.cpp \
  -CFLAGS "-I. -DTEST_RS -DDATA_WIDTH=32" \
  -Mdir "$Mdir" -o "$EXE"

DATASET="${CORE_CC_DATASET:-../dataset/core_cc_vectors_rs_w32_exhaust.jsonl}"
if [[ ! -f "$DATASET" ]]; then
  echo "WARN: $DATASET missing; run: python3 dataset/gen_rs_w32_exhaust.py"
  DATASET="../dataset/core_cc_vectors.jsonl"
fi
CORE_CC_DATASET="$DATASET" ./"$Mdir"/"$EXE"
