#!/usr/bin/env bash
# Universal-driver regression: BCH w16 PGZ (BM + Chien FSM) twin.
set -euo pipefail
cd "$(dirname "$0")"

GEN="../verilogs/repaired_golden/generated"
RTL="${GEN}/bch_ecc_w16.v ${GEN}/bch_ecc_w16_fsm.v"
Mdir="obj_dir_univ_bch_w16_pgz"
EXE="univ_bch_w16_pgz"

verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
  --cc --exe --build -j 0 \
  --top-module bch_ecc_w16 \
  $RTL universal_driver.cpp \
  +define+USE_PGZ_FSM \
  -CFLAGS "-I. -DTEST_BCH -DDATA_WIDTH=16 -DBCH_FSM_DECODER" \
  -Mdir "$Mdir" -o "$EXE"

DATASET="${CORE_CC_DATASET:-../dataset/core_cc_vectors_w16_exhaust.jsonl}"
if [[ ! -f "$DATASET" ]]; then
  echo "WARN: $DATASET missing; run: python3 dataset/generate_vectors.py"
  DATASET="../dataset/core_cc_vectors.jsonl"
fi
CORE_CC_DATASET="$DATASET" ./"$Mdir"/"$EXE"
