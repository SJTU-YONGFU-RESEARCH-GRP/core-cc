# Raw LLM-Generated RTL @ `d96ee52`

Everything here is extracted from git commit **`d96ee52`** — before
`hamming_sec_ecc.v`, `extended_hamming_secded_ecc.v`, and the improved 5-case testbenches.

```bash
./scripts/extract_raw_d96ee52.sh   # re-sync from git
```

## Top-level modules (snapshot)

| File | Notes |
|------|--------|
| `parity_ecc.v` | Decode uses `^data_in` instead of codeword data |
| `hamming_secded_ecc.v` | Misnamed “SECDED”; duplicate `always` blocks; SEC only |
| `extended_hamming_ecc.v` | Inverted error flags; fixed `[137:0]` ports |
| `crc_ecc.v` | `error_corrected <= crc_mismatch` |
| `bch_ecc.v` + `generated/bch_ecc_w*.v` | Syndrome only; correction placeholder |
| `repetition_ecc.v` | Pre–83e6dbf repetition logic |

There is **no** `hamming_sec_ecc.v` or `extended_hamming_secded_ecc.v` at this commit.

## Pair with legacy testbenches

See `testbenches/legacy_d96ee52/` — same commit, loopback-oriented tests that
**100% pass** this RTL while hiding real bugs.

```bash
./scripts/compare_legacy_vs_improved.sh
```

## Paper figure (typical parity w8)

| Verification | RTL | Outcome |
|--------------|-----|---------|
| Legacy TB (`d96ee52`) | raw | **PASS** (false confidence) |
| Improved 5-case TB | raw | **FAIL** |
| Improved 5-case TB | `repaired_golden` | **PASS** |
| Universal driver + JSONL | raw | **FAIL** |
