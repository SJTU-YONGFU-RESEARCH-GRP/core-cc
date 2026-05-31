#!/usr/bin/env python3
"""
Data-driven ECC test vector generator.

Produces JSONL records consumed by a universal Verilator C++ driver.
Each line is one decode test vector with inputs and expected outputs.
"""

import json
import random
import sys
from itertools import combinations
from math import comb
from pathlib import Path
from typing import Optional, Tuple

_SRC = Path(__file__).resolve().parent.parent / "src"
if str(_SRC) not in sys.path:
  sys.path.insert(0, str(_SRC))
from bch_codec import BCHCodec  # noqa: E402


class ECCDatasetGenerator:
  """Builds JSONL test vectors from software golden models."""

  def __init__(self, filename: str = "core_cc_vectors.jsonl"):
    self.filename = Path(__file__).parent / filename
    self.vectors = []
    random.seed(42)

  def add_vector(
      self,
      module: str,
      data_width: int,
      codeword_width: int,
      data_in: int,
      codeword_in: int,
      exp_data_out: int,
      exp_error_detected: int,
      exp_error_corrected: int,
      test_case: str,
      repetition_factor: Optional[int] = None,
  ) -> None:
    record = {
        "module": module,
        "data_width": data_width,
        "codeword_width": codeword_width,
        "data_in": hex(data_in),
        "codeword_in": hex(codeword_in),
        "exp_data_out": hex(exp_data_out),
        "exp_error_detected": exp_error_detected,
        "exp_error_corrected": exp_error_corrected,
        "test_case": test_case,
        "op": "decode",
    }
    if repetition_factor is not None:
      record["repetition_factor"] = repetition_factor
    self.vectors.append(record)

  def save_to_file(self) -> None:
    with open(self.filename, "w", encoding="utf-8") as f:
      for v in self.vectors:
        f.write(json.dumps(v) + "\n")
    print(f"Wrote {len(self.vectors)} vectors to {self.filename}")

  # ------------------------------------------------------------------
  # Golden models (combinational, match Verilog semantics)
  # ------------------------------------------------------------------

  @staticmethod
  def parity_encode(data: int, data_width: int) -> int:
    mask = (1 << data_width) - 1
    data &= mask
    parity_bit = bin(data).count("1") % 2
    return (data << 1) | parity_bit

  @staticmethod
  def parity_decode(codeword: int, data_width: int) -> Tuple[int, int, int]:
    mask = (1 << data_width) - 1
    data_out = (codeword >> 1) & mask
    parity_bit = codeword & 1
    expected_parity = bin(data_out).count("1") % 2
    error_detected = int(parity_bit != expected_parity)
    return data_out, error_detected, 0

  @staticmethod
  def repetition_encode(data: int, data_width: int, rep_factor: int) -> int:
    codeword = 0
    for bit_idx in range(data_width):
      bit_val = (data >> bit_idx) & 1
      for r in range(rep_factor):
        if bit_val:
          codeword |= 1 << (bit_idx * rep_factor + r)
    return codeword

  @staticmethod
  def repetition_decode(
      codeword: int, data_width: int, rep_factor: int
  ) -> Tuple[int, int, int]:
    data_out = 0
    error_detected = 0
    error_corrected = 0

    for j in range(data_width):
      ones_count = 0
      for k in range(rep_factor):
        if (codeword >> (j * rep_factor + k)) & 1:
          ones_count += 1

      if ones_count > rep_factor // 2:
        data_out |= 1 << j

      if ones_count != 0 and ones_count != rep_factor:
        error_detected = 1
        is_tie = (rep_factor % 2 == 0) and (ones_count == rep_factor // 2)
        if not is_tie:
          error_corrected = 1

    return data_out, error_detected, error_corrected

  # ------------------------------------------------------------------
  # Five-case verification matrix (aligned with C++ testbenches)
  # ------------------------------------------------------------------

  def generate_parity(self, data_width: int, num_tests: int = 10) -> None:
    module_name = "parity_ecc"
    cw_width = data_width + 1
    mask = (1 << data_width) - 1

    for i in range(num_tests):
      data = random.getrandbits(data_width) & mask
      perfect_cw = self.parity_encode(data, data_width)

      # Case 1: clean decode
      d, det, cor = self.parity_decode(perfect_cw, data_width)
      self.add_vector(
          module_name, data_width, cw_width, data, perfect_cw, d, det, cor,
          f"Test {i} [Case 1] Clean decode",
      )

      # Case 2: decoder isolation (poisoned data_in)
      poison = random.getrandbits(data_width) & mask
      d, det, cor = self.parity_decode(perfect_cw, data_width)
      self.add_vector(
          module_name, data_width, cw_width, poison, perfect_cw, d, det, cor,
          f"Test {i} [Case 2] Data poisoning",
      )

      # Case 3: parity-bit single error
      cw3 = perfect_cw ^ 1
      d, det, cor = self.parity_decode(cw3, data_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw3, d, det, cor,
          f"Test {i} [Case 3] Parity-bit single error",
      )

      # Case 4: data-bit single error (detect only)
      bit_pos = random.randint(1, data_width)
      cw4 = perfect_cw ^ (1 << bit_pos)
      d, det, cor = self.parity_decode(cw4, data_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw4, d, det, cor,
          f"Test {i} [Case 4] Data-bit single error",
      )

      # Case 5: two data-bit errors (undetectable for even parity)
      bit1 = random.randint(1, data_width)
      bit2 = (bit1 % data_width) + 1
      cw5 = perfect_cw ^ (1 << bit1) ^ (1 << bit2)
      d, det, cor = self.parity_decode(cw5, data_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw5, d, det, cor,
          f"Test {i} [Case 5] Double data-bit error",
      )

  def generate_repetition(
      self, data_width: int, rep_factor: int, num_tests: int = 10
  ) -> None:
    module_name = "repetition_ecc"
    cw_width = data_width * rep_factor
    mask = (1 << data_width) - 1

    for i in range(num_tests):
      data = random.getrandbits(data_width) & mask
      perfect_cw = self.repetition_encode(data, data_width, rep_factor)

      d, det, cor = self.repetition_decode(perfect_cw, data_width, rep_factor)
      self.add_vector(
          module_name, data_width, cw_width, data, perfect_cw, d, det, cor,
          f"Test {i} [Case 1] Clean decode",
          repetition_factor=rep_factor,
      )

      poison = random.getrandbits(data_width) & mask
      d, det, cor = self.repetition_decode(perfect_cw, data_width, rep_factor)
      self.add_vector(
          module_name, data_width, cw_width, poison, perfect_cw, d, det, cor,
          f"Test {i} [Case 2] Data poisoning",
          repetition_factor=rep_factor,
      )

      cw3 = perfect_cw ^ (1 << random.randint(0, cw_width - 1))
      d, det, cor = self.repetition_decode(cw3, data_width, rep_factor)
      self.add_vector(
          module_name, data_width, cw_width, data, cw3, d, det, cor,
          f"Test {i} [Case 3] Single-bit correction",
          repetition_factor=rep_factor,
      )

      if rep_factor % 2 == 0:
        tie_data = data & ~1
        tie_cw = self.repetition_encode(tie_data, data_width, rep_factor)
        tie_cw ^= (1 << 0) | (1 << 1)
        d, det, cor = self.repetition_decode(tie_cw, data_width, rep_factor)
        self.add_vector(
            module_name, data_width, cw_width, data, tie_cw, d, det, cor,
            f"Test {i} [Case 5] Tie dead-lock",
            repetition_factor=rep_factor,
        )

  def _repetition_add(
      self,
      data_width: int,
      rep_factor: int,
      data: int,
      cw: int,
      desc: str,
  ) -> None:
    cw_width = data_width * rep_factor
    d, det, cor = self.repetition_decode(cw, data_width, rep_factor)
    self.add_vector(
        "repetition_ecc", data_width, cw_width, data, cw, d, det, cor, desc,
        repetition_factor=rep_factor,
    )

  def generate_repetition_crv(
      self,
      width: int,
      rep_factor: int,
      num_random_single: int = 500,
  ) -> int:
    """
    TMR signoff: walking-one/zero, codeword 1-err exhaustive, in-channel 2-err, random.
    """
    from itertools import combinations

    data_width = width
    mask = (1 << data_width) - 1
    cw_width = data_width * rep_factor
    count = 0
    full_exhaust_all_walk = width * cw_width <= 4096

    def add(data: int, cw: int, desc: str) -> None:
      nonlocal count
      self._repetition_add(data_width, rep_factor, data, cw, desc)
      count += 1

    print(
        f"[Repetition CRV w{width} rf={rep_factor}] walk + 1-err + 2-err/channel + "
        f"{num_random_single} random..."
    )

    for bit in range(data_width):
      data = (1 << bit) & mask
      add(data, self.repetition_encode(data, data_width, rep_factor),
          f"w{width} rf{rep_factor} [Rep Walk-One] {bit}")
    for bit in range(data_width):
      data = mask ^ (1 << bit)
      add(data, self.repetition_encode(data, data_width, rep_factor),
          f"w{width} rf{rep_factor} [Rep Walk-Zero] {bit}")

    exhaust_bases = [(1 << b) & mask for b in range(data_width)] if full_exhaust_all_walk else [0, mask]
    for base_i, data in enumerate(exhaust_bases):
      perfect = self.repetition_encode(data, data_width, rep_factor)
      for pos in range(cw_width):
        cw_err = perfect ^ (1 << pos)
        d, det, cor = self.repetition_decode(cw_err, data_width, rep_factor)
        if det != 1 or cor != 1 or d != data:
          raise RuntimeError(
              f"Rep 1-err mismatch w{width} rf{rep_factor} base={base_i} pos={pos}: "
              f"det={det} cor={cor} d=0x{d:x} exp=0x{data:x}"
          )
        add(data, cw_err, f"w{width} rf{rep_factor} [Rep 1-Err Exhaustive] base={base_i} pos={pos}")

    for bit in range(data_width):
      data = (1 << bit) & mask
      perfect = self.repetition_encode(data, data_width, rep_factor)
      for k1, k2 in combinations(range(rep_factor), 2):
        pos1 = bit * rep_factor + k1
        pos2 = bit * rep_factor + k2
        cw_err = perfect ^ (1 << pos1) ^ (1 << pos2)
        d, det, cor = self.repetition_decode(cw_err, data_width, rep_factor)
        if rep_factor == 4:
          if det != 1 or cor != 0:
            raise RuntimeError(
                f"Rep rf4 2-err tie expected det=1 cor=0 at ch {bit}: det={det} cor={cor}"
            )
        elif det != 1:
          raise RuntimeError(f"Rep rf3 2-err expected det=1 at ch {bit}: det={det}")
        add(
            data, cw_err,
            f"w{width} rf{rep_factor} [Rep 2-Err Channel] bit={bit} reps={k1},{k2} "
            f"det={det} cor={cor} out=0x{d:x}",
        )

    for i in range(num_random_single):
      data = random.getrandbits(data_width) & mask
      perfect = self.repetition_encode(data, data_width, rep_factor)
      pos = random.randint(0, cw_width - 1)
      add(data, perfect ^ (1 << pos), f"w{width} rf{rep_factor} [Rep Random 1-Err] {i}")

    print(f"[Repetition CRV w{width} rf={rep_factor}] total {count} vectors")
    return count

  def generate_repetition_crv_all(
      self,
      width: int,
      rf3_random: int = 500,
      rf4_random: int = 500,
  ) -> None:
    self.vectors = []
    self.generate_repetition_crv(width, 3, num_random_single=rf3_random)
    self.filename = Path(__file__).parent / f"core_cc_vectors_repetition_w{width}_rf3_crv.jsonl"
    self.save_to_file()

    self.vectors = []
    self.generate_repetition_crv(width, 4, num_random_single=rf4_random)
    self.filename = Path(__file__).parent / f"core_cc_vectors_repetition_w{width}_rf4_crv.jsonl"
    self.save_to_file()

  @staticmethod
  def is_parity_pos(pos: int) -> bool:
    check = pos + 1
    return check != 0 and (check & (check - 1)) == 0

  @staticmethod
  def get_data_pos(data_idx: int, n: int) -> int:
    idx = 0
    for j in range(n):
      if not ECCDatasetGenerator.is_parity_pos(j):
        if idx == data_idx:
          return j
        idx += 1
    return 0

  @staticmethod
  def calc_sec_width(data_width: int) -> int:
    if data_width <= 2:
      return 5
    if data_width <= 4:
      return 7
    if data_width <= 8:
      return 12
    if data_width <= 16:
      return 21
    if data_width <= 32:
      return 38
    if data_width <= 64:
      return 71
    return 136

  @staticmethod
  def encode_hamming_sec(data: int, data_width: int, sec_width: int) -> int:
    mask = (1 << data_width) - 1
    data &= mask
    codeword = 0
    parity_bits = sec_width - data_width

    for i in range(data_width):
      pos = ECCDatasetGenerator.get_data_pos(i, sec_width)
      if (data >> i) & 1:
        codeword |= 1 << pos

    for i in range(parity_bits):
      p = 0
      for j in range(sec_width):
        if not ECCDatasetGenerator.is_parity_pos(j) or j != ((1 << i) - 1):
          if ((j + 1) & (1 << i)) != 0:
            p ^= (codeword >> j) & 1
      codeword |= p << ((1 << i) - 1)

    return codeword

  @staticmethod
  def decode_hamming_sec(
      codeword: int, data_width: int, sec_width: int
  ) -> Tuple[int, int, int]:
    parity_bits = sec_width - data_width
    syndrome = 0

    for i in range(parity_bits):
      expected = 0
      for j in range(sec_width):
        if j != ((1 << i) - 1):
          if ((j + 1) & (1 << i)) != 0:
            expected ^= (codeword >> j) & 1
      actual = (codeword >> ((1 << i) - 1)) & 1
      if expected != actual:
        syndrome |= 1 << i

    syndrome_in_range = 0 < syndrome <= sec_width
    corrected = codeword
    if syndrome_in_range:
      corrected ^= 1 << (syndrome - 1)

    mask = (1 << data_width) - 1
    data_out = 0
    for i in range(data_width):
      pos = ECCDatasetGenerator.get_data_pos(i, sec_width)
      if (corrected >> pos) & 1:
        data_out |= 1 << i

    error_detected = int(syndrome != 0)
    error_corrected = int(syndrome_in_range)
    return data_out & mask, error_detected, error_corrected

  @staticmethod
  def encode_secded(data: int, data_width: int, sec_width: int) -> int:
    sec_cw = ECCDatasetGenerator.encode_hamming_sec(data, data_width, sec_width)
    overall = 0
    for j in range(sec_width):
      overall ^= (sec_cw >> j) & 1
    return sec_cw | (overall << sec_width)

  @staticmethod
  def decode_secded(
      codeword: int, data_width: int, sec_width: int
  ) -> Tuple[int, int, int]:
    rx_sec = codeword & ((1 << sec_width) - 1)
    rx_overall = (codeword >> sec_width) & 1

    parity_bits = sec_width - data_width
    syndrome = 0
    for i in range(parity_bits):
      expected = 0
      for j in range(sec_width):
        if j != ((1 << i) - 1):
          if ((j + 1) & (1 << i)) != 0:
            expected ^= (rx_sec >> j) & 1
      actual = (rx_sec >> ((1 << i) - 1)) & 1
      if expected != actual:
        syndrome |= 1 << i

    calc_overall = 0
    for j in range(sec_width):
      calc_overall ^= (rx_sec >> j) & 1
    overall_parity_error = int(calc_overall != rx_overall)

    single_error = int(syndrome != 0 and overall_parity_error)
    double_error = int(syndrome != 0 and not overall_parity_error)

    corrected_sec = rx_sec
    if single_error and syndrome <= sec_width:
      corrected_sec ^= 1 << (syndrome - 1)

    mask = (1 << data_width) - 1
    data_out = 0
    for i in range(data_width):
      pos = ECCDatasetGenerator.get_data_pos(i, sec_width)
      if (corrected_sec >> pos) & 1:
        data_out |= 1 << i

    error_detected = int(single_error or double_error)
    error_corrected = int(single_error)
    return data_out & mask, error_detected, error_corrected

  def generate_hamming_sec(self, data_width: int, num_tests: int = 10) -> None:
    module_name = "hamming_sec_ecc"
    sec_width = self.calc_sec_width(data_width)
    mask = (1 << data_width) - 1

    for i in range(num_tests):
      data = random.getrandbits(data_width) & mask
      perfect_cw = self.encode_hamming_sec(data, data_width, sec_width)

      d, det, cor = self.decode_hamming_sec(perfect_cw, data_width, sec_width)
      self.add_vector(
          module_name, data_width, sec_width, data, perfect_cw, d, det, cor,
          f"Test {i} [Case 1] Clean decode",
      )

      poison = random.getrandbits(data_width) & mask
      d, det, cor = self.decode_hamming_sec(perfect_cw, data_width, sec_width)
      self.add_vector(
          module_name, data_width, sec_width, poison, perfect_cw, d, det, cor,
          f"Test {i} [Case 2] Decoder isolation",
      )

      cw3 = perfect_cw ^ 1
      d, det, cor = self.decode_hamming_sec(cw3, data_width, sec_width)
      self.add_vector(
          module_name, data_width, sec_width, data, cw3, d, det, cor,
          f"Test {i} [Case 3] Single parity error",
      )

      data_bit_idx = random.randint(0, data_width - 1)
      flip_pos = self.get_data_pos(data_bit_idx, sec_width)
      cw4 = perfect_cw ^ (1 << flip_pos)
      d, det, cor = self.decode_hamming_sec(cw4, data_width, sec_width)
      self.add_vector(
          module_name, data_width, sec_width, data, cw4, d, det, cor,
          f"Test {i} [Case 4] Single data error",
      )

      # Flip P1 and P2: syndrome=3, hardware miscorrects data bit 0
      cw5 = perfect_cw ^ 1 ^ 2
      ruined, det, cor = self.decode_hamming_sec(cw5, data_width, sec_width)
      self.add_vector(
          module_name, data_width, sec_width, data, cw5, ruined, det, cor,
          f"Test {i} [Case 5] Double error miscorrection",
      )

  def generate_secded(self, data_width: int, num_tests: int = 10) -> None:
    module_name = "extended_hamming_secded_ecc"
    sec_width = self.calc_sec_width(data_width)
    cw_width = sec_width + 1
    mask = (1 << data_width) - 1

    for i in range(num_tests):
      data = random.getrandbits(data_width) & mask
      perfect_cw = self.encode_secded(data, data_width, sec_width)

      d, det, cor = self.decode_secded(perfect_cw, data_width, sec_width)
      self.add_vector(
          module_name, data_width, cw_width, data, perfect_cw, d, det, cor,
          f"Test {i} [Case 1] Clean decode",
      )

      poison = random.getrandbits(data_width) & mask
      d, det, cor = self.decode_secded(perfect_cw, data_width, sec_width)
      self.add_vector(
          module_name, data_width, cw_width, poison, perfect_cw, d, det, cor,
          f"Test {i} [Case 2] Decoder isolation",
      )

      cw3 = perfect_cw ^ 1
      d, det, cor = self.decode_secded(cw3, data_width, sec_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw3, d, det, cor,
          f"Test {i} [Case 3] SEC parity error",
      )

      data_bit_idx = random.randint(0, data_width - 1)
      flip_pos = self.get_data_pos(data_bit_idx, sec_width)
      cw4 = perfect_cw ^ (1 << flip_pos)
      d, det, cor = self.decode_secded(cw4, data_width, sec_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw4, d, det, cor,
          f"Test {i} [Case 4] SEC data error",
      )

      # Double error in SEC region (P1+P2): detect only, payload unchanged
      cw5 = perfect_cw ^ 1 ^ 2
      d, det, cor = self.decode_secded(cw5, data_width, sec_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw5, d, det, cor,
          f"Test {i} [Case 5] Double error detection",
      )

  @staticmethod
  def calculate_crc_8(data: int, data_width: int) -> int:
    """Matches crc_ecc.v / crc_ecc_tb.cpp nested shift model."""
    crc = 0x00
    mask = (1 << data_width) - 1
    data &= mask
    for i in range(data_width):
      bit = (data >> i) & 1
      if bit:
        crc ^= 0x80
      for _ in range(8):
        if crc & 0x80:
          crc = ((crc << 1) ^ 0x07) & 0xFF
        else:
          crc = (crc << 1) & 0xFF
    return crc

  @staticmethod
  def encode_crc(data: int, data_width: int, crc_width: int = 8) -> int:
    crc = ECCDatasetGenerator.calculate_crc_8(data, data_width)
    return (crc << data_width) | (data & ((1 << data_width) - 1))

  @staticmethod
  def decode_crc(
      codeword: int, data_width: int, crc_width: int = 8
  ) -> Tuple[int, int, int]:
    mask = (1 << data_width) - 1
    data_out = codeword & mask
    received_crc = (codeword >> data_width) & ((1 << crc_width) - 1)
    expected_crc = ECCDatasetGenerator.calculate_crc_8(data_out, data_width)
    error_detected = int(expected_crc != received_crc)
    return data_out, error_detected, 0

  def generate_crc(self, data_width: int, num_tests: int = 10) -> None:
    module_name = "crc_ecc"
    crc_width = 8
    cw_width = data_width + crc_width
    mask = (1 << data_width) - 1

    for i in range(num_tests):
      data = random.getrandbits(data_width) & mask
      perfect_cw = self.encode_crc(data, data_width, crc_width)

      d, det, cor = self.decode_crc(perfect_cw, data_width, crc_width)
      self.add_vector(
          module_name, data_width, cw_width, data, perfect_cw, d, det, cor,
          f"Test {i} [Case 1] Clean decode",
      )

      poison = random.getrandbits(data_width) & mask
      d, det, cor = self.decode_crc(perfect_cw, data_width, crc_width)
      self.add_vector(
          module_name, data_width, cw_width, poison, perfect_cw, d, det, cor,
          f"Test {i} [Case 2] Decoder isolation",
      )

      crc_bit = random.randint(0, crc_width - 1)
      cw3 = perfect_cw ^ (1 << (data_width + crc_bit))
      d, det, cor = self.decode_crc(cw3, data_width, crc_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw3, d, det, cor,
          f"Test {i} [Case 3] Single CRC bit error",
      )

      err_bit = random.randint(0, data_width - 1)
      cw4 = perfect_cw ^ (1 << err_bit)
      d, det, cor = self.decode_crc(cw4, data_width, crc_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw4, d, det, cor,
          f"Test {i} [Case 4] Single data error (uncorrected)",
      )

      if data_width >= 3:
        err_start = random.randint(0, data_width - 3)
        burst_mask = 0b111 << err_start
      else:
        burst_mask = (1 << data_width) - 1
      cw5 = perfect_cw ^ burst_mask
      d, det, cor = self.decode_crc(cw5, data_width, crc_width)
      self.add_vector(
          module_name, data_width, cw_width, data, cw5, d, det, cor,
          f"Test {i} [Case 5] Burst error (uncorrected)",
      )

  def _crc_add_vector(
      self,
      data_width: int,
      data_in: int,
      codeword_in: int,
      test_case: str,
  ) -> None:
    crc_width = 8
    cw_width = data_width + crc_width
    d, det, cor = self.decode_crc(codeword_in, data_width, crc_width)
    self.add_vector(
        "crc_ecc", data_width, cw_width, data_in, codeword_in,
        d, det, cor, test_case,
    )

  def generate_crc_large_crv(
      self,
      width: int,
      num_random_per_tier: int = 1000,
      num_clean_random: int = 500,
      walking_crc_errors: bool = True,
  ) -> int:
    """
    Tape-out style CRC signoff: walking-ones/zeros + high-volume CRV.

    Walking patterns activate every data_in[i] in the parallel XOR tree independently.
    Random tiers scale Case 3/4/5 (single CRC, single data, burst) for false-negative hunt.
    """
    crc_width = 8
    data_width = width
    mask = (1 << data_width) - 1
    count = 0

    def add(data: int, cw: int, desc: str) -> None:
      nonlocal count
      self._crc_add_vector(data_width, data, cw, desc)
      count += 1

    print(f"[CRC CRV w{width}] walking + {num_clean_random} clean + "
          f"{num_random_per_tier}/tier random errors...")

    for bit in range(data_width):
      data = 1 << bit
      perfect = self.encode_crc(data, data_width, crc_width)
      add(data, perfect, f"w{width} [Walking-One] bit {bit}")

    for bit in range(data_width):
      data = mask ^ (1 << bit)
      perfect = self.encode_crc(data, data_width, crc_width)
      add(data, perfect, f"w{width} [Walking-Zero] bit {bit}")

    if walking_crc_errors:
      for bit in range(data_width):
        data = 1 << bit
        perfect = self.encode_crc(data, data_width, crc_width)
        for crc_bit in range(crc_width):
          cw_err = perfect ^ (1 << (data_width + crc_bit))
          add(
              data,
              cw_err,
              f"w{width} [Walk-One CRC-Err] data_bit {bit} crc_bit {crc_bit}",
          )

    for i in range(num_clean_random):
      data = random.getrandbits(data_width) & mask
      add(data, self.encode_crc(data, data_width, crc_width), f"w{width} [CRV Clean] {i}")

    for i in range(num_random_per_tier):
      data = random.getrandbits(data_width) & mask
      perfect = self.encode_crc(data, data_width, crc_width)
      crc_bit = random.randint(0, crc_width - 1)
      add(
          data,
          perfect ^ (1 << (data_width + crc_bit)),
          f"w{width} [CRV Single CRC] {i}",
      )

    for i in range(num_random_per_tier):
      data = random.getrandbits(data_width) & mask
      perfect = self.encode_crc(data, data_width, crc_width)
      err_bit = random.randint(0, data_width - 1)
      add(
          data,
          perfect ^ (1 << err_bit),
          f"w{width} [CRV Single Data] {i}",
      )

    for i in range(num_random_per_tier):
      data = random.getrandbits(data_width) & mask
      perfect = self.encode_crc(data, data_width, crc_width)
      if data_width >= 3:
        err_start = random.randint(0, data_width - 3)
        burst_mask = 0b111 << err_start
      else:
        burst_mask = mask
      add(
          data,
          perfect ^ burst_mask,
          f"w{width} [CRV Burst] {i}",
      )

    print(f"[CRC CRV w{width}] total {count} vectors")
    return count

  def _parity_add(self, data_width: int, data: int, cw: int, desc: str) -> None:
    cw_width = data_width + 1
    d, det, cor = self.parity_decode(cw, data_width)
    self.add_vector("parity_ecc", data_width, cw_width, data, cw, d, det, cor, desc)

  def generate_parity_classic_crv(
      self,
      width: int,
      num_random_per_tier: int = 500,
      num_clean_random: int = 200,
  ) -> int:
    """Walking-one/zero on data + random clean/single-error tiers."""
    data_width = width
    mask = (1 << data_width) - 1
    count = 0

    def add(data: int, cw: int, desc: str) -> None:
      nonlocal count
      self._parity_add(data_width, data, cw, desc)
      count += 1

    print(f"[Parity CRV w{width}] walking + {num_clean_random} clean + "
          f"{num_random_per_tier}/tier random...")
    for bit in range(data_width):
      data = 1 << bit
      add(data, self.parity_encode(data, data_width), f"w{width} [Parity Walk-One] {bit}")
    for bit in range(data_width):
      data = mask ^ (1 << bit)
      add(data, self.parity_encode(data, data_width), f"w{width} [Parity Walk-Zero] {bit}")
    for i in range(num_clean_random):
      data = random.getrandbits(data_width) & mask
      add(data, self.parity_encode(data, data_width), f"w{width} [Parity CRV Clean] {i}")
    for i in range(num_random_per_tier):
      data = random.getrandbits(data_width) & mask
      perfect = self.parity_encode(data, data_width)
      add(data, perfect ^ (1 << random.randint(0, data_width)), f"w{width} [Parity CRV Err] {i}")
    print(f"[Parity CRV w{width}] total {count} vectors")
    return count

  def _hamming_add(self, data_width: int, sec_width: int, data: int, cw: int, desc: str) -> None:
    d, det, cor = self.decode_hamming_sec(cw, data_width, sec_width)
    self.add_vector("hamming_sec_ecc", data_width, sec_width, data, cw, d, det, cor, desc)

  def generate_hamming_sec_classic_crv(self, width: int) -> int:
    """Walking-one bases + exhaustive single-bit flip on full SEC codeword."""
    data_width = width
    sec_width = self.calc_sec_width(data_width)
    mask = (1 << data_width) - 1
    count = 0

    def add(data: int, cw: int, desc: str) -> None:
      nonlocal count
      self._hamming_add(data_width, sec_width, data, cw, desc)
      count += 1

    print(f"[Hamming SEC CRV w{width}] walk-one + {sec_width} exhaustive 1-err/base...")
    for bit in range(data_width):
      data = (1 << bit) & mask
      perfect = self.encode_hamming_sec(data, data_width, sec_width)
      add(data, perfect, f"w{width} [Hamming Clean Walk-One] {bit}")
      for pos in range(sec_width):
        cw_err = perfect ^ (1 << pos)
        d, det, cor = self.decode_hamming_sec(cw_err, data_width, sec_width)
        if det != 1 or cor != 1 or d != data:
          raise RuntimeError(
              f"Hamming 1-err oracle mismatch w{width} base={bit} pos={pos}: "
              f"det={det} cor={cor} data=0x{d:x} exp=0x{data:x}"
          )
        add(data, cw_err, f"w{width} [Hamming 1-Err Exhaustive] base={bit} pos={pos}")
    print(f"[Hamming SEC CRV w{width}] total {count} vectors")
    return count

  def _secded_add(self, data_width: int, sec_width: int, data: int, cw: int, desc: str) -> None:
    cw_width = sec_width + 1
    d, det, cor = self.decode_secded(cw, data_width, sec_width)
    self.add_vector(
        "extended_hamming_secded_ecc", data_width, cw_width, data, cw, d, det, cor, desc,
    )

  def generate_secded_classic_crv(
      self,
      width: int,
      num_double_random: int = 2000,
      exhaustive_double: bool = False,
  ) -> int:
    """Walking-one + exhaustive 1-err; 2-err CRV with det=1 cor=0 only."""
    from itertools import combinations

    data_width = width
    sec_width = self.calc_sec_width(data_width)
    cw_width = sec_width + 1
    mask = (1 << data_width) - 1
    count = 0

    def add(data: int, cw: int, desc: str) -> None:
      nonlocal count
      self._secded_add(data_width, sec_width, data, cw, desc)
      count += 1

    print(f"[SECDED CRV w{width}] walk-one + {cw_width} 1-err/base + 2-err CRV...")
    for bit in range(data_width):
      data = (1 << bit) & mask
      perfect = self.encode_secded(data, data_width, sec_width)
      add(data, perfect, f"w{width} [SECDED Clean Walk-One] {bit}")
      for pos in range(cw_width):
        cw_err = perfect ^ (1 << pos)
        d, det, cor = self.decode_secded(cw_err, data_width, sec_width)
        # Overall-parity-only flips are not SEC-correctable singles in this model.
        if det == 1 and cor == 1 and d == data:
          add(data, cw_err, f"w{width} [SECDED 1-Err Exhaustive] base={bit} pos={pos}")
        elif pos == sec_width:
          add(
              data, cw_err,
              f"w{width} [SECDED Overall-Parity Flip] base={bit} (det={det} cor={cor})",
          )

    double_added = 0
    if exhaustive_double and cw_width <= 24:
      for p1, p2 in combinations(range(cw_width), 2):
        data = mask  # use all-ones data base for compact 2-err sweep
        perfect = self.encode_secded(data, data_width, sec_width)
        cw_err = perfect ^ (1 << p1) ^ (1 << p2)
        d, det, cor = self.decode_secded(cw_err, data_width, sec_width)
        if det == 1 and cor == 0:
          add(data, cw_err, f"w{width} [SECDED 2-Err Exhaustive] {p1},{p2}")
          double_added += 1
    else:
      # Two distinct data-bit flips → overwhelmingly double-error (det=1, cor=0).
      for i in range(num_double_random):
        data = random.getrandbits(data_width) & mask
        perfect = self.encode_secded(data, data_width, sec_width)
        b1 = random.randrange(data_width)
        b2 = random.randrange(data_width)
        while b2 == b1:
          b2 = random.randrange(data_width)
        p1 = self.get_data_pos(b1, sec_width)
        p2 = self.get_data_pos(b2, sec_width)
        cw_err = perfect ^ (1 << p1) ^ (1 << p2)
        d, det, cor = self.decode_secded(cw_err, data_width, sec_width)
        if det == 1 and cor == 0:
          add(
              data, cw_err,
              f"w{width} [SECDED 2-Err CRV] {i} data {b1},{b2}",
          )
          double_added += 1
        else:
          # Fallback: two SEC parity bits (classic uncorrectable double).
          cw_err = perfect ^ 1 ^ 2
          d, det, cor = self.decode_secded(cw_err, data_width, sec_width)
          if det == 1 and cor == 0:
            add(data, cw_err, f"w{width} [SECDED 2-Err CRV fallback] {i}")
            double_added += 1

    print(f"[SECDED CRV w{width}] total {count} vectors ({double_added} double-err)")
    return count

  def generate_classic_ecc_crv_all(
      self,
      width: int,
      num_random_per_tier: int = 500,
      num_clean_random: int = 200,
      num_double_random: int = 2000,
  ) -> None:
    """Emit parity / hamming / secded CRV JSONL files for one data width."""
    self.vectors = []
    self.generate_parity_classic_crv(width, num_random_per_tier, num_clean_random)
    self.filename = Path(__file__).parent / f"core_cc_vectors_parity_w{width}_crv.jsonl"
    self.save_to_file()

    self.vectors = []
    self.generate_hamming_sec_classic_crv(width)
    self.filename = Path(__file__).parent / f"core_cc_vectors_hamming_w{width}_crv.jsonl"
    self.save_to_file()

    exhaustive_dbl = width <= 16
    dbl_n = 0 if exhaustive_dbl else num_double_random
    self.vectors = []
    self.generate_secded_classic_crv(
        width, num_double_random=dbl_n, exhaustive_double=exhaustive_dbl,
    )
    self.filename = Path(__file__).parent / f"core_cc_vectors_secded_w{width}_crv.jsonl"
    self.save_to_file()

  def generate_bch(self, width: int, num_tests: int = 10) -> None:
    """Five-case BCH matrix (smoke) for width in {4,8,16,...}."""
    codec = BCHCodec.for_width(width)
    module_name = "bch_ecc"
    data_width = width
    cw_width = codec.n
    mask = (1 << data_width) - 1

    for i in range(num_tests):
      data = random.getrandbits(data_width) & mask
      perfect_cw = codec.encode(data)

      d, det, cor = codec.decode(perfect_cw)
      self.add_vector(
          module_name, data_width, cw_width, data, perfect_cw, d, det, cor,
          f"Test {i} [Case 1] Clean decode",
      )

      poison = random.getrandbits(data_width) & mask
      d, det, cor = codec.decode(perfect_cw)
      self.add_vector(
          module_name, data_width, cw_width, poison, perfect_cw, d, det, cor,
          f"Test {i} [Case 2] Decoder isolation",
      )

      pos = random.randrange(cw_width)
      cw3 = perfect_cw ^ (1 << pos)
      d, det, cor = codec.decode(cw3)
      self.add_vector(
          module_name, data_width, cw_width, data, cw3, d, det, cor,
          f"Test {i} [Case 3] Single-bit error",
      )

      if cw_width >= 2:
        p1, p2 = random.sample(range(cw_width), 2)
        cw4 = perfect_cw ^ (1 << p1) ^ (1 << p2)
      else:
        cw4 = perfect_cw
      d, det, cor = codec.decode(cw4)
      self.add_vector(
          module_name, data_width, cw_width, data, cw4, d, det, cor,
          f"Test {i} [Case 4] Double-bit error",
      )

  @staticmethod
  def _bch_exhaust_test_case(width: int, err_count: int, positions: tuple) -> str:
    if err_count == 1:
      return f"w{width} [Exhaustive 1-Error] bit {positions[0]}"
    if err_count == 2:
      return f"w{width} [Exhaustive 2-Error] bits {positions[0]},{positions[1]}"
    return (
        f"w{width} [Exhaustive 3-Error] bits "
        f"{positions[0]},{positions[1]},{positions[2]}"
    )

  def generate_bch_exhaustive(
      self,
      width: int,
      num_clean: Optional[int] = None,
  ) -> int:
    """100% exhaustive BCH decode vectors for w4/w8/w16 (errors 1..t)."""
    codec = BCHCodec.for_width(width)
    n = codec.n
    t = codec.t
    module_name = "bch_ecc"
    data_width = width
    cw_width = n
    mask = (1 << data_width) - 1
    clean_count = num_clean if num_clean is not None else (50 if width >= 16 else 20)
    base_seeds = {4: 0xA, 8: 0xAB, 16: 0xABCD}
    base_data = base_seeds.get(width, 0xDEAD) & mask

    print(f"[w{width}] exhaustive: n={n}, t={t}, clean={clean_count}...")

    for i in range(clean_count):
      data = random.getrandbits(data_width) & mask
      perfect_cw = codec.encode(data)
      d_out, det, cor = codec.decode(perfect_cw)
      self.add_vector(
          module_name, data_width, cw_width, data, perfect_cw,
          d_out, det, cor, f"w{width} [Clean] test {i}",
      )

    base_cw = codec.encode(base_data)
    err_vectors = 0
    for err_count in range(1, t + 1):
      for positions in combinations(range(n), err_count):
        err_mask = sum(1 << p for p in positions)
        err_cw = base_cw ^ err_mask
        d_out, det, cor = codec.decode(err_cw)
        self.add_vector(
            module_name, data_width, cw_width, base_data, err_cw,
            d_out, det, cor,
            self._bch_exhaust_test_case(width, err_count, positions),
        )
        err_vectors += 1

    expected_err = sum(comb(n, k) for k in range(1, t + 1))
    total = clean_count + err_vectors
    print(
        f"[w{width}] done: {total} vectors "
        f"({clean_count} clean + {err_vectors} errors, expected {expected_err} err)"
    )
    return total

  def generate_bch_large_crv(
      self,
      width: int,
      num_random_per_tier: int = 1000,
      num_clean: int = 50,
  ) -> None:
    """CRV for FSM widths (w32/w64/w128): exhaustive 1/2-error + random 3..t."""
    codec = BCHCodec.for_width(width)
    t = codec.t
    module_name = "bch_ecc"
    data_width = width
    cw_width = codec.n
    n = codec.n
    mask = (1 << data_width) - 1
    vector_count = 0

    def add_test(data: int, cw_err: int, case_desc: str) -> None:
      nonlocal vector_count
      d_out, det, cor = codec.decode(cw_err)
      self.add_vector(
          module_name, data_width, cw_width, data, cw_err,
          d_out, det, cor, case_desc,
      )
      vector_count += 1

    print(f"[CRV] BCH w{width} constrained-random (t={t})...")

    for i in range(num_clean):
      data = random.getrandbits(data_width) & mask
      perfect_cw = codec.encode(data)
      add_test(data, perfect_cw, f"w{width} [Clean] test {i}")

    data = random.getrandbits(data_width) & mask
    perfect_cw = codec.encode(data)
    for bit_pos in range(n):
      add_test(data, perfect_cw ^ (1 << bit_pos), f"w{width} [Exhaustive 1-Error] bit {bit_pos}")

    data = random.getrandbits(data_width) & mask
    perfect_cw = codec.encode(data)
    for pos1, pos2 in combinations(range(n), 2):
      add_test(
          data,
          perfect_cw ^ (1 << pos1) ^ (1 << pos2),
          f"w{width} [Exhaustive 2-Error] bits {pos1},{pos2}",
      )

    for err_count in range(3, t + 1):
      for i in range(num_random_per_tier):
        data = random.getrandbits(data_width) & mask
        perfect_cw = codec.encode(data)
        err_positions = random.sample(range(n), err_count)
        err_mask = sum(1 << p for p in err_positions)
        add_test(
            data,
            perfect_cw ^ err_mask,
            f"w{width} [Random {err_count}-Error] test {i}",
        )

    print(f"[CRV] Total w{width} CRV vectors: {vector_count}")

  def generate_rs_exhaustive(self, width: int, num_clean: int = 20) -> int:
    """RS(t=2): clean + exhaustive 1- and 2-byte error masks."""
    from rs_codec import RSCodec  # noqa: E402

    codec = RSCodec.for_width(width)
    module_name = "reed_solomon_ecc"
    data_width = width
    cw_width = 8 * codec.n
    n = codec.n
    mask = (1 << data_width) - 1
    base_data = {4: 0xA, 8: 0xAB, 16: 0xABCD}.get(width, 0xDEADBEEF) & mask
    base_cw = codec.encode(base_data)

    for i in range(num_clean):
      data = random.getrandbits(data_width) & mask
      cw = codec.encode(data)
      d, det, cor = codec.decode(cw)
      self.add_vector(
          module_name, data_width, cw_width, data, cw, d, det, cor,
          f"w{width} [RS Clean] {i}",
      )

    for err_count in (1, 2):
      for positions in combinations(range(n), err_count):
        err_mask = sum(0xFF << (8 * p) for p in positions)
        err_cw = base_cw ^ err_mask
        d, det, cor = codec.decode(err_cw)
        if err_count == 1:
          desc = f"w{width} [RS Exhaustive 1-Byte] pos {positions[0]}"
        else:
          desc = f"w{width} [RS Exhaustive 2-Byte] pos {positions[0]},{positions[1]}"
        self.add_vector(
            module_name, data_width, cw_width, base_data, err_cw, d, det, cor, desc,
        )

    total = num_clean + n + comb(n, 2)
    print(f"[RS w{width}] exhaustive: {total} vectors")
    return total

  def generate_rs_crv(
      self,
      width: int,
      num_random_per_tier: int = 200,
      num_clean: int = 30,
  ) -> None:
    """RS CRV for large widths: clean + exhaustive 1/2-byte + random 3-byte (uncorrectable)."""
    from rs_codec import RSCodec  # noqa: E402

    codec = RSCodec.for_width(width)
    n = codec.n
    data_width = width
    cw_width = 8 * n
    mask = (1 << data_width) - 1
    count = 0

    def add(data: int, cw: int, desc: str) -> None:
      nonlocal count
      d, det, cor = codec.decode(cw)
      self.add_vector("reed_solomon_ecc", data_width, cw_width, data, cw, d, det, cor, desc)
      count += 1

    print(f"[RS CRV w{width}] n={n} t={codec.t}...")
    for i in range(num_clean):
      data = random.getrandbits(data_width) & mask
      add(data, codec.encode(data), f"w{width} [RS Clean] {i}")

    data = random.getrandbits(data_width) & mask
    base_cw = codec.encode(data)
    for pos in range(n):
      add(data, base_cw ^ (0xFF << (8 * pos)), f"w{width} [RS Exhaustive 1-Byte] pos {pos}")

    data2 = random.getrandbits(data_width) & mask
    base_cw2 = codec.encode(data2)
    for p1, p2 in combinations(range(n), 2):
      add(
          data2,
          base_cw2 ^ (0xFF << (8 * p1)) ^ (0xFF << (8 * p2)),
          f"w{width} [RS Exhaustive 2-Byte] pos {p1},{p2}",
      )

    for i in range(num_random_per_tier):
      data = random.getrandbits(data_width) & mask
      perfect = codec.encode(data)
      pos3 = random.sample(range(n), 3)
      mask3 = sum(0xFF << (8 * p) for p in pos3)
      add(data, perfect ^ mask3, f"w{width} [RS Random 3-Byte] test {i}")

    print(f"[RS CRV w{width}] total {count} vectors")

  def generate_bch_w32_crv(self, num_random_per_tier: int = 1000) -> None:
    """Backward-compatible wrapper."""
    self.generate_bch_large_crv(32, num_random_per_tier=num_random_per_tier)


def main() -> None:
  generator = ECCDatasetGenerator("core_cc_vectors.jsonl")

  for width in [4, 8, 16, 32, 64, 128]:
    generator.generate_parity(width, num_tests=10)
    generator.generate_repetition(width, rep_factor=3, num_tests=10)
    generator.generate_repetition(width, rep_factor=4, num_tests=10)
    generator.generate_hamming_sec(width, num_tests=10)
    generator.generate_secded(width, num_tests=10)
    generator.generate_crc(width, num_tests=10)

  for bch_w in (4, 8, 16):
    generator.generate_bch_exhaustive(bch_w)

  generator.generate_bch(32, num_tests=10)
  generator.save_to_file()

  for w, tier in ((32, 1000), (64, 500), (128, 300)):
    g = ECCDatasetGenerator(f"core_cc_vectors_w{w}_crv.jsonl")
    g.generate_bch_large_crv(w, num_random_per_tier=tier)
    g.save_to_file()

  for w in (4, 8, 16):
    g = ECCDatasetGenerator(f"core_cc_vectors_w{w}_exhaust.jsonl")
    g.generate_bch_exhaustive(w)
    g.save_to_file()

  for w in (4, 8, 16, 32):
    g = ECCDatasetGenerator(f"core_cc_vectors_rs_w{w}_exhaust.jsonl")
    g.generate_rs_exhaustive(w, num_clean=20)
    g.save_to_file()

  for w, clean, tier in ((64, 500, 1800), (128, 800, 2000)):
    g = ECCDatasetGenerator(f"core_cc_vectors_rs_w{w}_crv.jsonl")
    g.generate_rs_crv(w, num_random_per_tier=tier, num_clean=clean)
    g.save_to_file()

  crc_crv_profiles = (
      (4, 200, 50),
      (8, 300, 100),
      (16, 500, 200),
      (32, 1000, 500),
      (64, 1000, 500),
      (128, 2500, 2000),
  )
  for w, tier, clean in crc_crv_profiles:
    g = ECCDatasetGenerator(f"core_cc_vectors_crc_w{w}_crv.jsonl")
    g.generate_crc_large_crv(w, num_random_per_tier=tier, num_clean_random=clean)
    g.save_to_file()

  classic_profiles = (
      (4, 200, 50, 100),
      (8, 300, 100, 200),
      (16, 500, 200, 500),
      (32, 1000, 500, 1500),
      (64, 1000, 500, 2500),
      (128, 2500, 2000, 5000),
  )
  g0 = ECCDatasetGenerator()
  for w, tier, clean, dbl in classic_profiles:
    g0.generate_classic_ecc_crv_all(
        w, num_random_per_tier=tier, num_clean_random=clean, num_double_random=dbl,
    )


if __name__ == "__main__":
  main()
