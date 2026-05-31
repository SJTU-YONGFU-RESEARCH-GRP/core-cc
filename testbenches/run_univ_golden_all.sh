#!/usr/bin/env bash
# Full repaired_golden regression via universal_driver.cpp
# Prints a consolidated PASS/FAIL matrix at the end.
set -uo pipefail
cd "$(dirname "$0")"

ROOT="$(cd .. && pwd)"
TB="$ROOT/testbenches"
DATASET_SMOKE="$ROOT/dataset/core_cc_vectors.jsonl"
LOG_DIR="${TB}/.golden_all_logs"
mkdir -p "$LOG_DIR"

declare -a ROWS=()
FAIL_COUNT=0

record() {
  local status=$1 name=$2 detail=$3
  ROWS+=("$status|$name|$detail")
  [[ "$status" == "PASS" ]] || FAIL_COUNT=$((FAIL_COUNT + 1))
}

# Parse universal_driver "Results: N PASS, M FAIL" (sum if sub-scripts ran many widths).
parse_results_from_log() {
  local log=$1
  local pass fail
  if grep -qE 'vectors total' "$log"; then
    pass=$(grep -oE '[0-9]+ vectors total' "$log" | tail -1 | grep -oE '^[0-9]+' || echo "?")
    fail=0
  elif grep -qE '[0-9]+ PASS' "$log"; then
    pass=$(grep -oE '[0-9]+ PASS' "$log" | awk '{s+=$1} END {print s+0}')
    fail=$(grep -oE '[0-9]+ FAIL' "$log" | awk '{s+=$1} END {print s+0}')
  else
    pass="?"
    fail="?"
  fi
  echo "${pass} pass, ${fail} fail"
}

run_logged() {
  local name=$1
  shift
  local log="$LOG_DIR/${name// /_}.log"
  echo ""
  echo "################################################################"
  echo "# $name"
  echo "################################################################"
  if "$@" >"$log" 2>&1; then
    local rc=0
  else
    local rc=$?
  fi
  tail -6 "$log" || true
  if grep -qE "RESULT: PASS|ALL: PASS" "$log" && \
     ! grep -qE "RESULT: FAIL|ALL: FAIL|FAIL \(" "$log"; then
    record "PASS" "$name" "$(parse_results_from_log "$log")"
  else
    record "FAIL" "$name" "exit=$rc (see $log)"
  fi
  return 0
}

dataset_for_classic() {
  local key=$1 width=$2
  local f="$ROOT/dataset/core_cc_vectors_${key}_w${width}_crv.jsonl"
  if [[ -f "$f" ]]; then
    echo "$f"
  else
    echo "$DATASET_SMOKE"
  fi
}

run_smoke() {
  local dut=$1 module=$2 width=$3 crv_key=$4
  local dataset
  dataset="$(dataset_for_classic "$crv_key" "$width")"
  local tag="smoke"
  [[ "$dataset" != "$DATASET_SMOKE" ]] && tag="crv"
  local name="${module} w${width} ${tag}"
  local vfile="$ROOT/verilogs/repaired_golden/${module}.v"
  local obj="obj_dir_golden_${module}_w${width}"
  local exe="golden_${module}_w${width}"
  local log="$LOG_DIR/${module}_w${width}_${tag}.log"

  if [[ ! -f "$vfile" ]]; then
    record "SKIP" "$name" "missing RTL"
    return 0
  fi

  local vflags="-Wno-EOFNEWLINE"
  [[ "$dut" == "TEST_SECDED" ]] && vflags="$vflags -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-CMPCONST"

  verilator $vflags --cc --exe --build -j 0 \
    "$vfile" "$TB/universal_driver.cpp" \
    -CFLAGS "-I${TB} -D${dut} -DDATA_WIDTH=${width}" \
    -GDATA_WIDTH="${width}" -Mdir "${TB}/${obj}" -o "$exe" >/dev/null 2>&1 || {
    record "FAIL" "$name" "verilator build"
    return 0
  }

  CORE_CC_DATASET="$dataset" "${TB}/${obj}/${exe}" >"$log" 2>&1 || true
  if grep -q "RESULT: PASS" "$log"; then
    record "PASS" "$name" "$(parse_results_from_log "$log")"
  else
    record "FAIL" "$name" "$(grep -E 'RESULT:|FAIL' "$log" | tail -2 | tr '\n' ' ')"
  fi
}

dataset_for_repetition() {
  local width=$1 rf=$2
  local f="$ROOT/dataset/core_cc_vectors_repetition_w${width}_rf${rf}_crv.jsonl"
  if [[ -f "$f" ]]; then
    echo "$f"
  else
    echo "$DATASET_SMOKE"
  fi
}

run_repetition() {
  local width=$1 rf=$2
  local dataset
  dataset="$(dataset_for_repetition "$width" "$rf")"
  local tag="smoke"
  [[ "$dataset" != "$DATASET_SMOKE" ]] && tag="crv"
  local name="repetition_ecc w${width} rf${rf} ${tag}"
  local obj="obj_dir_golden_rep${rf}_w${width}"
  local exe="golden_rep${rf}_w${width}"
  local log="$LOG_DIR/rep${rf}_w${width}_${tag}.log"

  verilator -Wno-EOFNEWLINE -Wno-LATCH --cc --exe --build -j 0 \
    "$ROOT/verilogs/repaired_golden/repetition_ecc.v" "$TB/universal_driver.cpp" \
    -CFLAGS "-I${TB} -DTEST_REPETITION -DDATA_WIDTH=${width} -DREPETITION_FACTOR=${rf}" \
    -GDATA_WIDTH="${width}" -GREPETITION_FACTOR="${rf}" \
    -Mdir "${TB}/${obj}" -o "$exe" >/dev/null 2>&1 || {
    record "FAIL" "$name" "verilator build"
    return 0
  }

  CORE_CC_DATASET="$dataset" "${TB}/${obj}/${exe}" >"$log" 2>&1 || true
  if grep -q "RESULT: PASS" "$log"; then
    record "PASS" "$name" "$(parse_results_from_log "$log")"
  else
    record "FAIL" "$name" "$(grep -E 'RESULT:|FAIL' "$log" | tail -2 | tr '\n' ' ')"
  fi
}

run_crc_comb() {
  local width=$1
  local name="crc_ecc_w${width} comb"
  local dataset="$ROOT/dataset/core_cc_vectors_crc_w${width}_crv.jsonl"
  local rtl="$ROOT/verilogs/repaired_golden/generated/crc_ecc_w${width}.v"
  local obj="obj_dir_golden_crc_comb_w${width}"
  local exe="golden_crc_comb_w${width}"
  local log="$LOG_DIR/crc_comb_w${width}.log"

  [[ -f "$rtl" ]] || { record "SKIP" "$name" "missing RTL"; return 0; }
  [[ -f "$dataset" ]] || { record "SKIP" "$name" "missing dataset"; return 0; }

  verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME \
    --cc --exe --build -j 0 \
    --top-module "crc_ecc_w${width}" \
    "$rtl" "$TB/universal_driver.cpp" \
    -CFLAGS "-I${TB} -DTEST_CRC -DCRC_USE_COMB -DDATA_WIDTH=${width}" \
    -Mdir "${TB}/${obj}" -o "$exe" >/dev/null 2>&1 || {
    record "FAIL" "$name" "verilator build"
    return 0
  }

  CORE_CC_DATASET="$dataset" "${TB}/${obj}/${exe}" >"$log" 2>&1 || true
  if grep -q "RESULT: PASS" "$log"; then
    record "PASS" "$name" "$(parse_results_from_log "$log")"
  else
    record "FAIL" "$name" "$(grep -E 'RESULT:|FAIL' "$log" | tail -2 | tr '\n' ' ')"
  fi
}

run_rs() {
  local width=$1
  local kind=$2
  local name="reed_solomon_ecc w${width} ${kind}"
  local dataset="$ROOT/dataset/core_cc_vectors_rs_w${width}_${kind}.jsonl"
  local rtl="$ROOT/verilogs/repaired_golden/generated/reed_solomon_ecc_w${width}.v"
  local obj="obj_dir_golden_rs_w${width}"
  local exe="golden_rs_w${width}"
  local log="$LOG_DIR/rs_w${width}_${kind}.log"

  [[ -f "$rtl" ]] || { record "SKIP" "$name" "missing RTL"; return 0; }
  [[ -f "$dataset" ]] || { record "SKIP" "$name" "missing dataset"; return 0; }

  verilator -Wno-EOFNEWLINE -Wno-WIDTH -Wno-DECLFILENAME -Wno-MULTIDRIVEN \
    --cc --exe --build -j 0 \
    --top-module "reed_solomon_ecc_w${width}" \
    "$rtl" "$TB/universal_driver.cpp" \
    -CFLAGS "-I${TB} -DTEST_RS -DDATA_WIDTH=${width}" \
    -Mdir "${TB}/${obj}" -o "$exe" >/dev/null 2>&1 || {
    record "FAIL" "$name" "verilator build"
    return 0
  }

  CORE_CC_DATASET="$dataset" "${TB}/${obj}/${exe}" >"$log" 2>&1 || true
  if grep -q "RESULT: PASS" "$log"; then
    record "PASS" "$name" "$(parse_results_from_log "$log")"
  else
    record "FAIL" "$name" "$(grep -E 'RESULT:|FAIL' "$log" | tail -2 | tr '\n' ' ')"
  fi
}

echo "CORE-CC repaired_golden — universal driver full matrix"
echo "Smoke dataset: $DATASET_SMOKE"
echo "Logs: $LOG_DIR"
echo

# --- Parametric RTL (module-major: w4..w128 per ECC type) ---
WIDTHS=(4 8 16 32 64 128)
for w in "${WIDTHS[@]}"; do
  run_smoke TEST_PARITY parity_ecc "$w" parity
done
for w in "${WIDTHS[@]}"; do
  run_smoke TEST_HAMMING_SEC hamming_sec_ecc "$w" hamming
done
for w in "${WIDTHS[@]}"; do
  run_smoke TEST_SECDED extended_hamming_secded_ecc "$w" secded
done
for w in "${WIDTHS[@]}"; do
  run_smoke TEST_CRC crc_ecc "$w" crc
done

# --- Repetition (rf-major: all widths per factor) ---
for rf in 3 4; do
  for w in "${WIDTHS[@]}"; do
    run_repetition "$w" "$rf"
  done
done

# --- CRC parallel golden (per width; serial crc_ecc tested above as crc_ecc w*) ---
for w in "${WIDTHS[@]}"; do
  run_crc_comb "$w"
done

# --- RS golden (per width) ---
for w in 4 8 16 32; do
  run_rs "$w" exhaust
done
for w in 64 128; do
  run_rs "$w" crv
done

# --- BCH (per width / variant) ---
run_logged "BCH w4 exhaust" bash "$TB/run_univ_bch_w4.sh"
run_logged "BCH w8 exhaust" bash "$TB/run_univ_bch_w8.sh"
run_logged "BCH w16 LUT" bash "$TB/run_univ_bch_w16_lut.sh"
run_logged "BCH w16 COMB" bash "$TB/run_univ_bch_w16_comb.sh"
run_logged "BCH w16 FSM" bash "$TB/run_univ_bch_w16_pgz.sh"
run_logged "BCH w32 CRV" bash "$TB/run_univ_bch_w32.sh"
run_logged "BCH w64 CRV" bash "$TB/run_univ_bch_w64.sh"
run_logged "BCH w128 CRV" bash "$TB/run_univ_bch_w128.sh"

# --- Summary table ---
echo ""
echo "================================================================================"
printf "%-6s %-42s %s\n" "STATUS" "TEST" "DETAIL"
echo "--------------------------------------------------------------------------------"
for row in "${ROWS[@]}"; do
  IFS='|' read -r st name detail <<< "$row"
  printf "%-6s %-42s %s\n" "$st" "$name" "$detail"
done
echo "================================================================================"
if [[ "$FAIL_COUNT" -eq 0 ]]; then
  echo "GOLDEN ALL: PASS (${#ROWS[@]} suites)"
  exit 0
fi
echo "GOLDEN ALL: FAIL ($FAIL_COUNT / ${#ROWS[@]} suites failed)"
exit 1
