#!/usr/bin/env bash
# Remove Verilator/C++ build artifacts (obj_dir*, obj_quick*, ad-hoc obj_*). RTL/datasets kept.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

count=0
while IFS= read -r -d '' d; do
  rm -rf "$d"
  count=$((count + 1))
done < <(
  find "$ROOT" -type d \( \
    -name 'obj_dir' -o -name 'obj_dir_*' -o \
    -name 'obj_quick*' -o -name 'obj_chk*' -o \
    -name 'obj_rep*' -o -name 'obj_r*' -o -name 'obj_status*' \
  \) -print0 2>/dev/null
)

# Ad-hoc /tmp verilator dirs from manual runs
rm -rf /tmp/v16test /tmp/v16test 2>/dev/null || true

echo "Removed ${count} Verilator build directory(ies) under ${ROOT}."
echo "Re-run any testbenches/*.sh to rebuild (incremental compile is fast)."
