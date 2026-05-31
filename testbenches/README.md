# Testbenches

## Full repaired_golden matrix

```bash
python3 dataset/gen_classic_ecc_crv.py   # parity/hamming/secded CRV w4..w128
python3 dataset/gen_crc_crv_all.py
bash testbenches/run_univ_golden_all.sh
```

Runs classic CRV when JSONL exists (else 50-vector smoke), plus BCH/RS/CRC signoff; prints a PASS/FAIL table. Logs under `testbenches/.golden_all_logs/`.

### Classic ECC signoff (parity / Hamming SEC / SECDED)

| Module | Coverage |
|--------|----------|
| `parity_ecc` | Walking-one/zero + random |
| `hamming_sec_ecc` | Walking-one bases + exhaustive 1-bit flip per SEC codeword |
| `extended_hamming_secded_ecc` | Exhaustive 1-err + 2-err CRV (`det=1`, `cor=0`) |

Datasets: `core_cc_vectors_{parity,hamming,secded}_w{4..128}_crv.jsonl`

### Repetition (TMR) signoff

```bash
python3 dataset/gen_repetition_crv.py
```

| Coverage | rf=3 | rf=4 |
|----------|------|------|
| Walking-one/zero | ✓ | ✓ |
| 1-bit codeword exhaustive | ✓ (full walk bases if w×cw≤4096, else 0+all-ones) | ✓ |
| 2-bit same-channel | miscorrect oracle (det=1) | tie: det=1 cor=0 |

Datasets: `core_cc_vectors_repetition_w{4..128}_rf{3,4}_crv.jsonl`

## What to keep vs delete

| Path | Keep? | Notes |
|------|-------|--------|
| `universal_driver.cpp`, `ecc_test_utils.h` | **Yes** | Shared JSONL regression driver |
| `tb_*.cpp`, `legacy_d96ee52/` | **Yes** | Focused / historical testbenches |
| `run_univ_*.sh`, `run_univ_bch_*.sh` | **Yes** | Build + run scripts |
| `obj_dir*` (anywhere) | **No** | Verilator `-Mdir` output; regenerated on each run |
| `*.vcd`, `*.fst` | **No** | Waveforms (optional debug) |

`.gitignore` already excludes `obj_dir/` and `obj_dir_*/`.

Clean all Verilator build dirs:

```bash
./scripts/clean_verilator_builds.sh
```

## RS w4–w128 (LLM syndrome + t=2 PGZ comb golden)

| Width | Script | Dataset | Vectors |
|-------|--------|---------|---------|
| w4–w32 | `run_univ_rs_all.sh` (exhaust) | `core_cc_vectors_rs_w{N}_exhaust.jsonl` | 35/35/41/56 |
| w64, w128 | same (crv) | `core_cc_vectors_rs_w{N}_crv.jsonl` | ~2,378 / ~3,010 |

```bash
python3 src/generate_rs_repaired_verilog.py   # all widths
python3 dataset/gen_rs_all_vectors.py
bash testbenches/run_univ_rs_all.sh
```

## BCH w4 / w8 (repaired golden, t=1 LUT)

| Script | Top | Dataset |
|--------|-----|---------|
| `run_univ_bch_w4.sh` | `bch_ecc_w4` | `core_cc_vectors_w4_exhaust.jsonl` (27) |
| `run_univ_bch_w8.sh` | `bch_ecc_w8` | `core_cc_vectors_w8_exhaust.jsonl` (35) |

Vectors: 20 clean + C(n,1) only (t=1; 100% correctable ball).

```bash
python3 dataset/gen_w4_exhaust.py
python3 dataset/gen_w8_exhaust.py
bash run_univ_bch_w4.sh
bash run_univ_bch_w8.sh
```

## BCH w16 (repaired golden)

| Script | Top module | RTL | Dataset (default) |
|--------|------------|-----|-------------------|
| `run_univ_bch_w16_lut.sh` | `bch_ecc_w16` | wrapper + `bch_ecc_w16_lut.v` | `core_cc_vectors_w16_exhaust.jsonl` (5041) |
| `run_univ_bch_w16_pgz.sh` | `bch_ecc_w16` | wrapper + `bch_ecc_w16_fsm.v` | same |
| `run_univ_bch_w16_comb.sh` | `bch_ecc_w16` | wrapper + `bch_ecc_w16_pgz_comb.v` | same |
| `run_univ_bch_wrapper_w16.sh` | `bch_ecc` | `bch_ecc.v` + w16 child | same; `TRACK=repaired_golden` or `raw_llm_generated` |

Generate exhaustive w16 vectors:

```bash
python3 dataset/gen_w16_exhaust.py
```

## BCH w32 / w64 / w128 (FSM decoder golden)

| Script | BCH | Dataset (default) |
|--------|-----|-------------------|
| `run_univ_bch_w32.sh` | (63,32,t=5) | `core_cc_vectors_w32_crv.jsonl` |
| `run_univ_bch_w64.sh` | (127,64,t=9) pad=7 | `core_cc_vectors_w64_crv.jsonl` |
| `run_univ_bch_w128.sh` | (255,128,t=15) pad=11 | `core_cc_vectors_w128_crv.jsonl` |

Regenerate RTL: `python3 src/generate_bch_decoder_fsm.py`  
Regenerate vectors: `python3 dataset/gen_w{32,64,128}_crv.py`  
Driver decode timeout: **256** (w16 FSM), 256 / 512 / **2500** (w32/w64/w128).

```bash
bash run_univ_bch_w32.sh
bash run_univ_bch_w64.sh
bash run_univ_bch_w128.sh
```

## CRC parallel golden (w4–w128)

| Script | RTL | Notes |
|--------|-----|--------|
| `run_univ_crc_comb_all.sh` | `repaired_golden/generated/crc_ecc_w*.v` | Impulse-response XOR trees; `-DCRC_USE_COMB` |

Regenerate RTL: `python3 src/generate_crc_comb.py`  
Smoke: `core_cc_vectors.jsonl` (50/width, 5-case contract).  
Signoff CRV: `python3 dataset/gen_crc_crv_all.py` → `core_cc_vectors_crc_w{4,8,16,32,64,128}_crv.jsonl` (walking-one/zero + 3× random error tiers).  
Serial reference: `crc_ecc.v`.

## Other ECC modules

Older universal runs use `obj_dir_univ_*` under this directory (parity, hamming, crc, etc.). Same rule: safe to delete; scripts in `scripts/compare_dual_track.sh` recreate them.
