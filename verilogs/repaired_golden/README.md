# Repaired Golden RTL (Reference Track)

Hand-verified RTL that **passes** `dataset/core_cc_vectors.jsonl` via `universal_driver.cpp`.

| File | Fix summary |
|------|-------------|
| `parity_ecc.v` | Decode parity check uses codeword data bits only |
| `hamming_sec_ecc.v` | Clean SEC decode; Case 5 documents intentional double-bit miscorrection |
| `extended_hamming_secded_ecc.v` | SECDED truth table: correct only on single errors; overall parity at MSB |
| `crc_ecc.v` | Serial `for`-loop CRC-8 (parametric); detection only |
| `generated/crc_ecc_w{4,8,16,32,64,128}.v` | **Parallel XOR trees** (impulse response) — `src/generate_crc_comb.py` |
| `repetition_ecc.v` | Majority vote + tie handling |
| `generated/bch_ecc_w4.v`, `w8` | Syndrome → error-mask lookup (t=1) |
| `generated/bch_ecc_w16.v` | **Triplet wrapper** (`USE_PGZ_COMB` / `USE_PGZ_FSM` / LUT) |
| `generated/bch_ecc_w16_lut.v` | **4991-entry ROM** — 0-cycle, `generate_bch_repaired_verilog.py` |
| `generated/bch_ecc_w16_fsm.v` | **BM + Chien FSM** — ~40 cycles, area-optimal — `generate_bch_w16_pgz.py` |
| `generated/bch_ecc_w16_pgz_comb.v` | **Combinational BM + 31× Chien** — 0-cycle algebraic — `generate_bch_w16_pgz_comb.py` |
| `generated/bch_ecc_w32.v` | BM + Chien FSM for BCH(63,32,t=5) — `generate_bch_decoder_fsm.py` |

Regenerate repaired BCH RTL:

```bash
python3 src/generate_bch_repaired_verilog.py   # w4/w8/w16_lut
python3 src/generate_bch_w16_pgz.py            # w16_fsm + wrapper
python3 src/generate_bch_w16_pgz_comb.py       # w16_pgz_comb + wrapper
python3 src/generate_bch_decoder_fsm.py        # w32 FSM
python3 src/generate_crc_comb.py             # crc_ecc_w4..w128 (PPA golden)
```

CRC comb regression (smoke w4–w32; CRV w64/w128):

```bash
python3 dataset/gen_crc_crv_all.py   # w4..w128 CRV JSONL
testbenches/run_univ_crc_comb_all.sh
```

Full golden matrix (all ECC types):

```bash
testbenches/run_univ_golden_all.sh
```

w16 regression (same JSONL contract, Universal Driver unchanged):

```bash
python3 dataset/gen_w16_exhaust.py   # 5041 vectors -> core_cc_vectors_w16_exhaust.jsonl
testbenches/run_univ_bch_w16_lut.sh    # ROM — expect 5041 PASS
testbenches/run_univ_bch_w16_pgz.sh    # FSM (+define+USE_PGZ_FSM)
testbenches/run_univ_bch_w16_comb.sh   # COMB (+define+USE_PGZ_COMB)
```

Python oracle for w32+ lives in `src/bch_codec.py` (table + bounded search); JSONL currently includes **w4–w16**.

Active default builds use `verilogs/*.v` at repo root (same content as this folder for core ECC modules).

```bash
./scripts/compare_dual_track.sh
```
