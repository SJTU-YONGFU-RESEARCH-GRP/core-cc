#!/usr/bin/env bash
# Universal-driver regression: BCH(7,4,t=1) golden LUT.
set -euo pipefail
cd "$(dirname "$0")"

RTL="../verilogs/repaired_golden/generated/bch_ecc_w4.v"
Mdir="obj_dir_univ_bch_w4"
EXE="univ_bch_w4"

verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
  --cc --exe --build -j 0 \
  --top-module bch_ecc_w4 \
  "$RTL" universal_driver.cpp \
  -CFLAGS "-I. -DTEST_BCH -DDATA_WIDTH=4" \
  -Mdir "$Mdir" -o "$EXE"

DATASET="${CORE_CC_DATASET:-../dataset/core_cc_vectors_w4_exhaust.jsonl}"
if [[ ! -f "$DATASET" ]]; then
  echo "WARN: $DATASET missing; run: python3 dataset/gen_w4_exhaust.py"
  DATASET="../dataset/core_cc_vectors.jsonl"
fi
CORE_CC_DATASET="$DATASET" ./"$Mdir"/"$EXE"
