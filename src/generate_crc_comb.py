#!/usr/bin/env python3
"""
Impulse-response probing: derive parallel CRC-8 XOR trees for DATA_WIDTH in {4..128}.

Matches crc_ecc.v / dataset/generate_vectors.py bit-serial model (poly 0x07, LSB-first).
"""

from __future__ import annotations

import os
import random
import sys
from typing import Dict, List

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(ROOT, "verilogs", "repaired_golden", "generated")

CRC_WIDTH = 8
CRC_POLY = 0x07
CRC_INIT = 0x00
WIDTHS = (4, 8, 16, 32, 64, 128)


def serial_crc_8(data: int, data_width: int) -> int:
    """Bit-serial CRC-8; matches crc_ecc.v calculate_crc / generate_vectors.py."""
    crc = CRC_INIT
    mask = (1 << data_width) - 1
    data &= mask
    for i in range(data_width):
        if (data >> i) & 1:
            crc ^= 0x80
        for _ in range(CRC_WIDTH):
            if crc & 0x80:
                crc = ((crc << 1) ^ CRC_POLY) & 0xFF
            else:
                crc = (crc << 1) & 0xFF
    return crc


def impulse_dependencies(data_width: int) -> Dict[int, List[int]]:
    """For each CRC output bit k, list data bit indices that XOR into it."""
    deps: Dict[int, List[int]] = {k: [] for k in range(CRC_WIDTH)}
    for bit_index in range(data_width):
        crc = serial_crc_8(1 << bit_index, data_width)
        for k in range(CRC_WIDTH):
            if crc & (1 << k):
                deps[k].append(bit_index)
    return deps


def parallel_crc_from_deps(data: int, deps: Dict[int, List[int]]) -> int:
    crc = 0
    for k, indices in deps.items():
        bit = 0
        for d in indices:
            bit ^= (data >> d) & 1
        if bit:
            crc |= 1 << k
    return crc


def _emit_xor_assign(signal: str, bit: int, indices: List[int], src: str) -> str:
    if not indices:
        return f"    assign {signal}[{bit}] = 1'b0;\n"
    terms = [f"{src}[{d}]" for d in indices]
    expr = " ^ ".join(terms)
    return f"    assign {signal}[{bit}] = {expr};\n"


def emit_verilog(data_width: int, deps: Dict[int, List[int]]) -> str:
    cw = data_width + CRC_WIDTH
    lines = [
        f"// Auto-generated parallel CRC-8 (impulse response), DATA_WIDTH={data_width}",
        f"// Polynomial 0x{CRC_POLY:02X}; combinational XOR trees, O(1) cycle encode/decode.",
        f"// Regenerate: python3 src/generate_crc_comb.py",
        f"module crc_ecc_w{data_width} (",
        "    input  wire                          clk,",
        "    input  wire                          rst_n,",
        "    input  wire                          encode_en,",
        "    input  wire                          decode_en,",
        f"    input  wire [{data_width - 1}:0]       data_in,",
        f"    input  wire [{cw - 1}:0]               codeword_in,",
        f"    output reg  [{cw - 1}:0]               codeword_out,",
        f"    output reg  [{data_width - 1}:0]       data_out,",
        "    output reg                           error_detected,",
        "    output reg                           error_corrected,",
        "    output reg                           valid_out",
        ");",
        "",
        f"    wire [{CRC_WIDTH - 1}:0] calculated_crc;",
        f"    wire [{CRC_WIDTH - 1}:0] expected_crc_for_rx;",
        f"    wire [{data_width - 1}:0] extracted_data = codeword_in[{data_width - 1}:0];",
        f"    wire [{CRC_WIDTH - 1}:0] received_crc = codeword_in[{cw - 1}:{data_width}];",
        "",
        "    // --- TX: parallel XOR tree ---",
    ]
    for k in range(CRC_WIDTH):
        lines.append(_emit_xor_assign("calculated_crc", k, deps[k], "data_in").rstrip())
    lines.append("")
    lines.append("    // --- RX: parallel XOR tree ---")
    for k in range(CRC_WIDTH):
        lines.append(
            _emit_xor_assign("expected_crc_for_rx", k, deps[k], "extracted_data").rstrip()
        )
    lines.extend(
        [
            "",
            "    wire crc_mismatch = (expected_crc_for_rx != received_crc);",
            "",
            "    always @(posedge clk or negedge rst_n) begin",
            "        if (!rst_n) begin",
            f"            codeword_out    <= {cw}'d0;",
            f"            data_out        <= {data_width}'d0;",
            "            error_detected  <= 1'b0;",
            "            error_corrected <= 1'b0;",
            "            valid_out       <= 1'b0;",
            "        end else if (encode_en) begin",
            "            codeword_out    <= {calculated_crc, data_in};",
            f"            data_out        <= {data_width}'d0;",
            "            error_detected  <= 1'b0;",
            "            error_corrected <= 1'b0;",
            "            valid_out       <= 1'b1;",
            "        end else if (decode_en) begin",
            f"            codeword_out    <= {cw}'d0;",
            "            data_out        <= extracted_data;",
            "            error_detected  <= crc_mismatch;",
            "            error_corrected <= 1'b0;",
            "            valid_out       <= 1'b1;",
            "        end else begin",
            "            valid_out       <= 1'b0;",
            "        end",
            "    end",
            "endmodule",
            "",
        ]
    )
    return "\n".join(lines)


def self_test(data_width: int, deps: Dict[int, List[int]], trials: int = 512) -> None:
    mask = (1 << data_width) - 1
    for _ in range(trials):
        data = random.randint(0, mask)
        if parallel_crc_from_deps(data, deps) != serial_crc_8(data, data_width):
            raise RuntimeError(f"CRC comb mismatch at DATA_WIDTH={data_width}, data=0x{data:x}")
    for bit in range(data_width):
        data = 1 << bit
        if parallel_crc_from_deps(data, deps) != serial_crc_8(data, data_width):
            raise RuntimeError(f"CRC comb one-hot mismatch w={data_width} bit={bit}")


def generate_one(data_width: int) -> str:
    deps = impulse_dependencies(data_width)
    self_test(data_width, deps)
    text = emit_verilog(data_width, deps)
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, f"crc_ecc_w{data_width}.v")
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)
    xor_terms = sum(len(deps[k]) for k in range(CRC_WIDTH))
    print(f"Generated {path} ({xor_terms} XOR terms across {CRC_WIDTH} CRC bits)")
    return path


def main() -> None:
    for w in WIDTHS:
        generate_one(w)
    print(f"Done: {len(WIDTHS)} parallel CRC modules in {OUT_DIR}")


if __name__ == "__main__":
    main()
