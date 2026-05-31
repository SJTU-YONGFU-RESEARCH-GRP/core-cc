#!/usr/bin/env bash
# Demonstrate false positives: legacy TB + raw RTL pass, improved TB + raw RTL fail.
set -uo pipefail  # note: pipelines use '|| true' so failing DUT (expected) does not abort

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TB="$ROOT/testbenches"
RAW="$ROOT/verilogs/raw_llm_generated"
GOLD="$ROOT/verilogs/repaired_golden"
LEGACY="$TB/legacy_d96ee52"
WIDTH="${1:-8}"

run_legacy() {
  local mod="$1"       # verilog module file basename
  local tb="$2"        # legacy testbench basename
  local extra_v="${3:-}" # optional extra verilog (e.g. bch_ecc_w8.v)
  local vflags="${4:--Wno-EOFNEWLINE}"

  local obj="obj_dir_legacy_${mod}_w${WIDTH}"
  local bin="legacy_${mod}_w${WIDTH}"
  local vlist=("$RAW/${mod}.v")
  [[ -n "$extra_v" ]] && vlist+=("$extra_v")

  verilator $vflags --cc --exe --build -j 0 \
    "${vlist[@]}" "$LEGACY/${tb}_tb.cpp" \
    -CFLAGS "-I${TB} -DDATA_WIDTH=${WIDTH}" -GDATA_WIDTH="${WIDTH}" -I"${TB}" \
    --Mdir "${TB}/${obj}" -o "$bin" >/dev/null 2>&1 || { echo "  BUILD FAIL"; return; }

  local out
  out="$("${TB}/${obj}/${bin}" 2>&1)" || true
  echo "$out" | grep -E 'RESULT:|Passed:' | head -2 | sed 's/^/  /'
}

run_improved_tb() {
  local vfile="$1"
  local tb="$2"
  local vflags="${3:--Wno-EOFNEWLINE}"

  local base
  base=$(basename "$vfile" .v)
  local obj="obj_dir_improved_${base}_w${WIDTH}"
  local bin="improved_${base}_w${WIDTH}"

  verilator $vflags --cc --exe --build -j 0 \
    "$vfile" "$TB/${tb}_tb.cpp" \
    -CFLAGS "-I${TB} -DDATA_WIDTH=${WIDTH}" -GDATA_WIDTH="${WIDTH}" -I"${TB}" \
    --Mdir "${TB}/${obj}" -o "$bin" >/dev/null 2>&1 || { echo "  BUILD FAIL"; return; }

  local out
  out="$("${TB}/${obj}/${bin}" 2>&1)" || true
  echo "$out" | grep -E 'RESULT:|Check outcomes:|Passed:' | head -2 | sed 's/^/  /'
}

run_univ() {
  local track="$1"
  local dut="$2"
  local mod="$3"
  shift 3
  local -a vfiles=("$@")
  if [[ ${#vfiles[@]} -eq 0 ]]; then
    vfiles=("$ROOT/verilogs/${track}/${mod}.v")
  fi

  local vflags="-Wno-EOFNEWLINE"
  [[ "$dut" == "TEST_SECDED" ]] && vflags="$vflags -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-CMPCONST"

  local obj="obj_dir_univ_${track}_${mod}_w${WIDTH}"
  local bin="univ_${track}_${mod}_w${WIDTH}"

  verilator $vflags --cc --exe --build -j 0 \
    "${vfiles[@]}" "$TB/universal_driver.cpp" \
    -CFLAGS "-I${TB} -D${dut} -DDATA_WIDTH=${WIDTH}" -GDATA_WIDTH="${WIDTH}" -I"${TB}" \
    --Mdir "${TB}/${obj}" -o "$bin" >/dev/null 2>&1 || { echo "  BUILD FAIL"; return; }

  CORE_CC_DATASET="$ROOT/dataset/core_cc_vectors.jsonl" \
    "${TB}/${obj}/${bin}" 2>&1 | grep -E 'Results:|RESULT:' | sed 's/^/  /' || true
}

echo "============================================================"
echo " CORE-CC: Legacy (d96ee52) vs Improved Verification"
echo " DATA_WIDTH=${WIDTH}  |  raw RTL: ${RAW}"
echo "============================================================"
echo

echo "## Parity"
echo "[1] Legacy TB + raw RTL (expected PASS — false confidence):"
run_legacy parity_ecc parity_ecc
echo "[2] Improved 5-case TB + raw RTL (expected FAIL):"
run_improved_tb "$RAW/parity_ecc.v" parity_ecc
echo "[3] Improved 5-case TB + golden RTL (expected PASS):"
run_improved_tb "$GOLD/parity_ecc.v" parity_ecc
echo "[4] Universal driver JSONL + raw (expected FAIL):"
run_univ raw_llm_generated TEST_PARITY parity_ecc
echo "[5] Universal driver JSONL + golden (expected PASS):"
run_univ repaired_golden TEST_PARITY parity_ecc
echo

echo "## Hamming (d96ee52: hamming_secded_ecc only)"
echo "[1] Legacy TB + raw hamming_secded (loopback, expected PASS):"
run_legacy hamming_secded_ecc hamming_secded_ecc
echo "[2] Improved hamming_sec TB + golden (expected PASS):"
run_improved_tb "$GOLD/hamming_sec_ecc.v" hamming_sec_ecc
echo "[3] Universal driver (hamming_sec_ecc JSONL) + golden:"
run_univ repaired_golden TEST_HAMMING_SEC hamming_sec_ecc
echo

echo "## Extended Hamming (d96ee52: extended_hamming_ecc only)"
echo "[1] Legacy TB + raw (loopback, expected PASS):"
run_legacy extended_hamming_ecc extended_hamming_ecc \
  "" "-Wno-EOFNEWLINE -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-CMPCONST"
echo "[2] Improved SECDED TB + golden (expected PASS):"
run_improved_tb "$GOLD/extended_hamming_secded_ecc.v" extended_hamming_secded_ecc \
  "-Wno-EOFNEWLINE -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-CMPCONST"
echo

echo "## BCH"
echo "[1] Legacy loopback TB + raw placeholder RTL (expected PASS):"
run_legacy bch_ecc bch_ecc "$RAW/generated/bch_ecc_w${WIDTH}.v"
echo "[2] Universal driver JSONL + raw (expected FAIL on correction cases):"
run_univ raw_llm_generated TEST_BCH bch_ecc \
  "$RAW/bch_ecc.v" "$RAW/generated/bch_ecc_w${WIDTH}.v"
echo "[3] Universal driver + golden repaired w${WIDTH}:"
run_univ repaired_golden TEST_BCH bch_ecc \
  "$GOLD/bch_ecc.v" "$GOLD/generated/bch_ecc_w${WIDTH}.v"
echo

echo "## CRC"
echo "[1] Legacy TB + raw (expected PASS):"
run_legacy crc_ecc crc_ecc
echo "[2] Universal driver + raw (error_corrected masked in driver):"
run_univ raw_llm_generated TEST_CRC crc_ecc
echo

echo "Done."
