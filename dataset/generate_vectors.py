#!/usr/bin/env python3
"""
Data-driven ECC test vector generator.

Produces JSONL records consumed by a universal Verilator C++ driver.
Each line is one decode test vector with inputs and expected outputs.
"""

import json
import random
from pathlib import Path
from typing import Optional, Tuple


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


def main() -> None:
  generator = ECCDatasetGenerator("core_cc_vectors.jsonl")

  for width in [4, 8, 16, 32, 64, 128]:
    generator.generate_parity(width, num_tests=10)
    generator.generate_repetition(width, rep_factor=3, num_tests=10)
    generator.generate_repetition(width, rep_factor=4, num_tests=10)
    generator.generate_hamming_sec(width, num_tests=10)
    generator.generate_secded(width, num_tests=10)
    generator.generate_crc(width, num_tests=10)

  generator.save_to_file()


if __name__ == "__main__":
  main()
