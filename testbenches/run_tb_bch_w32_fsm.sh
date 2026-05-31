#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TB="$ROOT/testbenches"
RTL="$ROOT/verilogs/repaired_golden/generated/bch_ecc_w32.v"
OBJ="$TB/obj_dir_tb_bch_w32_fsm"

cd "$TB"
rm -rf "$OBJ"
verilator -Wall -Wno-DECLFILENAME -Wno-WIDTH -Wno-MULTIDRIVEN --cc --exe --build \
  -Mdir "$OBJ" -o Vbch_ecc_w32_fsm --top-module bch_ecc_w32 \
  "$RTL" tb_bch_w32_fsm.cpp

"$OBJ/Vbch_ecc_w32_fsm"
