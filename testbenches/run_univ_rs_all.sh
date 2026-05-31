#!/usr/bin/env bash
# Run RS universal-driver regression for w4..w128 (golden PGZ comb).
set -euo pipefail
cd "$(dirname "$0")"

run_one() {
  local w=$1
  local kind=$2
  local dataset="../dataset/core_cc_vectors_rs_w${w}_${kind}.jsonl"
  local rtl="../verilogs/repaired_golden/generated/reed_solomon_ecc_w${w}.v"
  local mdir="obj_dir_univ_rs_w${w}"
  local exe="univ_rs_w${w}"

  if [[ ! -f "$rtl" ]]; then
    echo "SKIP w${w}: missing $rtl (run: python3 src/generate_rs_repaired_verilog.py)"
    return 0
  fi
  if [[ ! -f "$dataset" ]]; then
    echo "SKIP w${w}: missing $dataset"
    return 0
  fi

  echo "=== RS w${w} (${kind}) ==="
  verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
    --cc --exe --build -j 0 \
    --top-module "reed_solomon_ecc_w${w}" \
    "$rtl" universal_driver.cpp \
    -CFLAGS "-I. -DTEST_RS -DDATA_WIDTH=${w}" \
    -Mdir "$mdir" -o "$exe" >/dev/null
  local out
  out=$(CORE_CC_DATASET="$dataset" ./"$mdir"/"$exe" 2>&1)
  local pass fail
  pass=$(echo "$out" | grep -oE '[0-9]+ PASS' | awk '{print $1}')
  fail=$(echo "$out" | grep -oE '[0-9]+ FAIL' | awk '{print $1}')
  echo "$out" | tail -4
  if [[ -z "$pass" ]] || [[ "${fail:-0}" != "0" ]] || ! echo "$out" | grep -q "RESULT: PASS"; then
    return 1
  fi
  echo "RS w${w}: ${pass} PASS"
  RS_TOTAL_PASS=$((RS_TOTAL_PASS + pass))
}

FAIL=0
RS_TOTAL_PASS=0
for w in 4 8 16 32; do
  run_one "$w" exhaust || FAIL=1
done
for w in 64 128; do
  run_one "$w" crv || FAIL=1
done

if [[ "$FAIL" -ne 0 ]]; then
  echo "RS ALL: FAIL"
  exit 1
fi
echo "RS ALL: PASS — ${RS_TOTAL_PASS} vectors total"
