#!/usr/bin/env bash
# Universal-driver regression for repaired BCH(63,32) FSM decoder.
set -euo pipefail
cd "$(dirname "$0")"

RTL="../verilogs/repaired_golden/generated/bch_ecc_w32.v"
Mdir="obj_dir_univ_bch_w32"
EXE="univ_bch_test_w32"

verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
  --cc --exe --build -j 0 \
  --top-module bch_ecc_w32 \
  "$RTL" universal_driver.cpp \
  -CFLAGS "-I. -DTEST_BCH -DDATA_WIDTH=32" \
  -Mdir "$Mdir" -o "$EXE"

DATASET="${CORE_CC_DATASET:-../dataset/core_cc_vectors_w32_crv.jsonl}"
if [[ ! -f "$DATASET" ]]; then
  echo "WARN: $DATASET missing; falling back to core_cc_vectors.jsonl"
  DATASET="../dataset/core_cc_vectors.jsonl"
fi
CORE_CC_DATASET="$DATASET" ./"$Mdir"/"$EXE"
