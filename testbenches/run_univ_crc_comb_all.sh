#!/usr/bin/env bash
# Run parallel CRC golden w4..w128 (prefers core_cc_vectors_crc_w*_crv.jsonl per width)
set -euo pipefail
cd "$(dirname "$0")"

dataset_for_width() {
  local w=$1
  if [[ -f "../dataset/core_cc_vectors_crc_w${w}_crv.jsonl" ]]; then
    echo "../dataset/core_cc_vectors_crc_w${w}_crv.jsonl"
  else
    echo "${CORE_CC_DATASET:-../dataset/core_cc_vectors.jsonl}"
  fi
}

run_one() {
  local w=$1
  local dataset
  dataset="$(dataset_for_width "$w")"
  local rtl="../verilogs/repaired_golden/generated/crc_ecc_w${w}.v"
  local mdir="obj_dir_univ_crc_comb_w${w}"
  local exe="univ_crc_comb_w${w}"

  if [[ ! -f "$rtl" ]]; then
    echo "SKIP w${w}: missing $rtl (run: python3 ../src/generate_crc_comb.py)"
    return 0
  fi

  echo "=== CRC comb w${w} (${dataset}) ==="
  verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME \
    --cc --exe --build -j 0 \
    --top-module "crc_ecc_w${w}" \
    "$rtl" universal_driver.cpp \
    -CFLAGS "-I. -DTEST_CRC -DCRC_USE_COMB -DDATA_WIDTH=${w}" \
    -Mdir "$mdir" -o "$exe" >/dev/null
  CORE_CC_DATASET="$dataset" ./"$mdir"/"$exe" | tail -4
}

FAIL=0
for w in 4 8 16 32 64 128; do
  run_one "$w" || FAIL=1
done

if [[ "$FAIL" -ne 0 ]]; then
  echo "CRC COMB ALL: FAIL"
  exit 1
fi
echo "CRC COMB ALL: PASS"
