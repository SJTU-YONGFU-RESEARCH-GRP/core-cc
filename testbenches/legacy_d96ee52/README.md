# Legacy Testbenches (commit `d96ee52`)

Frozen C++ testbenches from the era when the LLM generated both RTL and tests together.
They were designed to pass the **same flawed RTL** in `verilogs/raw_llm_generated/`.

## Why they matter (false positives)

| Pattern | What legacy tests do | What they miss |
|---------|----------------------|----------------|
| Parity | Clean encode/decode + flip parity bit only | `data_in` poisoning on decode (`^data_in` bug) |
| Hamming / Extended | Encode→decode **loopback** only | Single-bit correction, SECDED flags, double-bit cases |
| BCH | Clean loopback | `error_corrected` placeholder (no real fix) |
| CRC | Encode/decode/flip one bit | `error_corrected <= crc_mismatch` semantics |

Pair with **improved** tests in `testbenches/*_tb.cpp` (5-case matrix) or
`universal_driver.cpp` + `dataset/core_cc_vectors.jsonl`.

## Build example

From `testbenches/`:

```bash
verilator -Wno-EOFNEWLINE --cc --exe --build -j 0 \
  ../verilogs/raw_llm_generated/parity_ecc.v legacy_d96ee52/parity_ecc_tb.cpp \
  -CFLAGS "-I.. -DDATA_WIDTH=8" -GDATA_WIDTH=8 -I.. \
  --Mdir obj_dir_legacy_parity_w8 -o legacy_parity_w8
./obj_dir_legacy_parity_w8/legacy_parity_w8
```

Hamming and BCH use `hamming_secded_ecc` / `extended_hamming_ecc` module names (no
`hamming_sec_ecc` or `extended_hamming_secded_ecc` at `d96ee52`).

```bash
./scripts/compare_legacy_vs_improved.sh
```
