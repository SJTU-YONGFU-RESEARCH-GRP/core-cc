#!/usr/bin/env bash
# Compare raw_llm_generated vs repaired_golden against core_cc_vectors.jsonl
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TB="$ROOT/testbenches"
DATASET="$ROOT/dataset/core_cc_vectors.jsonl"
WIDTHS=(4 8)

run_single() {
  local track="$1"
  local dut="$2"      # TEST_PARITY, TEST_HAMMING_SEC, TEST_SECDED, TEST_CRC
  local module="$3"   # verilog filename without .v
  local width="$4"
  local extra_cflags="${5:-}"
  local extra_g="${6:-}"

  local vfile="$ROOT/verilogs/${track}/${module}.v"
  local obj="obj_dir_dual_${track}_${module}_w${width}"
  local bin="univ_dual_${track}_${module}_w${width}"

  if [[ ! -f "$vfile" ]]; then
    echo "SKIP ${track} ${module} w${width}: missing $vfile"
    return
  fi

  local vflags="-Wno-EOFNEWLINE"
  if [[ "$dut" == "TEST_SECDED" ]]; then
    vflags="$vflags -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-CMPCONST"
  fi
  verilator $vflags --cc --exe --build -j 0 \
    "$vfile" "$TB/universal_driver.cpp" \
    -CFLAGS "-I${TB} -D${dut} -DDATA_WIDTH=${width} ${extra_cflags}" \
    -GDATA_WIDTH="${width}" ${extra_g} -I"${TB}" \
    --Mdir "${TB}/${obj}" -o "$bin" >/dev/null 2>&1

  echo "=== ${track} ${module} DATA_WIDTH=${width} ==="
  CORE_CC_DATASET="$DATASET" "${TB}/${obj}/${bin}" 2>&1 | grep -E 'Results:|RESULT:' || true
  echo
}

run_bch() {
  local track="$1"
  local width="$2"
  local bch_sub="$ROOT/verilogs/${track}/generated/bch_ecc_w${width}.v"
  local bch_wrap="$ROOT/verilogs/${track}/bch_ecc.v"
  local obj="obj_dir_dual_${track}_bch_w${width}"
  local bin="univ_dual_${track}_bch_w${width}"

  if [[ ! -f "$bch_sub" ]]; then
    echo "SKIP ${track} BCH w${width}: missing $bch_sub"
    return
  fi

  verilator -Wno-EOFNEWLINE --cc --exe --build -j 0 \
    "$bch_wrap" "$bch_sub" "$TB/universal_driver.cpp" \
    -CFLAGS "-I${TB} -DTEST_BCH -DDATA_WIDTH=${width}" \
    -GDATA_WIDTH="${width}" -I"${TB}" \
    --Mdir "${TB}/${obj}" -o "$bin" >/dev/null 2>&1

  echo "=== ${track} bch_ecc DATA_WIDTH=${width} ==="
  CORE_CC_DATASET="$DATASET" "${TB}/${obj}/${bin}" 2>&1 | grep -E 'Results:|RESULT:' || true
  echo
}

echo "CORE-CC Dual-Track Comparison"
echo "Dataset: $DATASET"
echo

for w in "${WIDTHS[@]}"; do
  for track in raw_llm_generated repaired_golden; do
    run_single "$track" TEST_PARITY parity_ecc "$w"
    if [[ "$track" == "raw_llm_generated" ]]; then
      run_single "$track" TEST_HAMMING_SEC hamming_secded_ecc "$w"
    else
      run_single "$track" TEST_HAMMING_SEC hamming_sec_ecc "$w"
    fi
    if [[ "$track" == "repaired_golden" ]]; then
      run_single "$track" TEST_SECDED extended_hamming_secded_ecc "$w"
    fi
    run_single "$track" TEST_CRC crc_ecc "$w"
    run_bch "$track" "$w"
  done
  echo "---"
done
