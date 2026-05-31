#!/usr/bin/env bash
# Universal driver through parametric bch_ecc.v wrapper (top = bch_ecc, DATA_WIDTH=16).
# Usage: TRACK=repaired_golden|raw_llm_generated [CORE_CC_DATASET=...] ./run_univ_bch_wrapper_w16.sh
set -euo pipefail
cd "$(dirname "$0")"

TRACK="${TRACK:-repaired_golden}"
ROOT="../verilogs/${TRACK}"
GEN="${ROOT}/generated"

if [[ "$TRACK" == "repaired_golden" ]]; then
  RTL="${ROOT}/bch_ecc.v ${GEN}/bch_ecc_w16.v ${GEN}/bch_ecc_w16_lut.v"
else
  RTL="${ROOT}/bch_ecc.v ${GEN}/bch_ecc_w16.v"
fi

Mdir="obj_dir_univ_wrapper_${TRACK}_w16"
EXE="univ_bch_wrapper_${TRACK}_w16"
DATASET="${CORE_CC_DATASET:-../dataset/core_cc_vectors_w16_exhaust.jsonl}"

verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
  --cc --exe --build -j 0 \
  --top-module bch_ecc \
  $RTL universal_driver.cpp \
  -CFLAGS "-I. -DTEST_BCH -DDATA_WIDTH=16 -DBCH_USE_WRAPPER" \
  -GDATA_WIDTH=16 \
  -Mdir "$Mdir" -o "$EXE"

echo "TRACK=$TRACK DATASET=$DATASET"
CORE_CC_DATASET="$DATASET" ./"$Mdir"/"$EXE"
