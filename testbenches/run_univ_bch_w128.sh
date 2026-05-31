#!/usr/bin/env bash
# Universal-driver regression: BCH(255,128,t=15) FSM decoder golden.
set -euo pipefail
cd "$(dirname "$0")"

RTL="../verilogs/repaired_golden/generated/bch_ecc_w128.v"
Mdir="obj_dir_univ_bch_w128"
EXE="univ_bch_w128"

verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
  --cc --exe --build -j 0 \
  --top-module bch_ecc_w128 \
  "$RTL" universal_driver.cpp \
  -CFLAGS "-I. -DTEST_BCH -DDATA_WIDTH=128" \
  -Mdir "$Mdir" -o "$EXE"

DATASET="${CORE_CC_DATASET:-../dataset/core_cc_vectors_w128_crv.jsonl}"
if [[ ! -f "$DATASET" ]]; then
  echo "WARN: $DATASET missing; run: python3 dataset/gen_w128_crv.py"
  DATASET="../dataset/core_cc_vectors.jsonl"
fi
CORE_CC_DATASET="$DATASET" ./"$Mdir"/"$EXE"
