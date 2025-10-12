# Burst Error Correction Code Implementation

This document describes the Burst Error Correction Code (Burst ECC) implementation in both Python and Verilog.

## Overview

Burst Error ECC is designed to handle burst errors - consecutive bit errors that commonly occur in communication channels and storage systems. It uses interleaving and specialized parity protection to detect and correct bursts of errors, making it particularly effective against channel impairments that affect multiple adjacent bits.

## Supported Configurations

The implementation supports the following burst error configurations based on data length:

| Data Bits (k) | Codeword Bits (n) | Burst Length (b) | Use Case |
|---------------|-------------------|------------------|----------|
| 4 | 8 | 2 | Small data blocks |
| 8 | 16 | 3 | Standard data blocks |
| 16 | 32 | 4 | Medium data blocks |
| 32 | 64 | 5 | Large data blocks |

## Python Implementation

### Location: `src/burst_error_ecc.py`

The Python implementation provides:

- **BurstErrorECC**: Main burst error correction class
- **Configurable burst length**: Adapts protection based on data size
- **Interleaving support**: Optional data interleaving for better burst protection
- **Burst error injection**: Specialized error injection for testing

### Key Features

1. **Adaptive Burst Protection**: Automatically configures based on data length
2. **Burst-Resistant Parity**: Specialized parity calculation for burst error detection
3. **Error Correction**: Attempts to correct detected burst errors
4. **Hardware-Compatible**: Designed for efficient hardware implementation

### Usage Example

```python
from src.burst_error_ecc import BurstErrorECC

# Create burst ECC for 8-bit data (handles up to 3-bit bursts)
burst_ecc = BurstErrorECC(word_length=8)

# Encode data
data = 0b10110100
codeword = burst_ecc.encode(data)

# Inject a burst error
corrupted = burst_ecc.inject_burst_error(codeword, burst_start=5, burst_length=3)

# Decode - should correct the burst error
decoded_data, error_type = burst_ecc.decode(corrupted)

# Get burst protection information
info = burst_ecc.get_burst_info()
print(f"Burst length: {info['burst_length']}")
print(f"Codeword length: {info['codeword_length']}")
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of:

1. **burst_error_ecc.v**: Main burst error correction module

### Key Features

1. **Hardware-Optimized**: Efficient combinational logic for burst detection
2. **Configurable Parameters**: Supports different data widths and burst lengths
3. **Real-time Correction**: Corrects burst errors in single clock cycle
4. **Resource Efficient**: Minimal hardware resources for burst protection

### Module Interface

```verilog
module burst_error_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 16
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [CODEWORD_WIDTH-1:0] codeword_in,
    output reg  [CODEWORD_WIDTH-1:0] codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);
```

## Testbenches

### Available Testbenches

1. **burst_error_ecc_tb.c**: C testbench for hardware verification
2. **test_burst_error_ecc.py**: Python unit tests for burst error handling

### Test Coverage

- **Burst Error Injection**: Tests various burst lengths and positions
- **Correction Verification**: Validates burst error correction capabilities
- **Boundary Testing**: Tests edge cases and maximum burst lengths
- **Performance Testing**: Measures correction success rates

## Mathematical Background

### Burst Error Model

Burst errors are modeled as consecutive bit flips:

```
Error Pattern: 000...0111...1000...0
                    └─── b bits ──┘
```

Where `b` is the burst length.

### Parity Calculation

The burst-resistant parity uses a specialized calculation:

```
For each parity bit p_i at position pos:
p_i = XOR of data bits where (j + pos) % burst_length == 0
```

### Syndrome Calculation

Error detection uses syndrome computation:

```
Syndrome = calculated_parity ⊕ received_parity
```

### Burst Correction

Correction attempts to flip all possible burst patterns and checks which one corrects the syndrome.

## Performance Characteristics

### Error Correction Capability

- **Burst Length**: Up to b consecutive errors (varies by data size)
- **Random Errors**: Limited protection against scattered errors
- **Detection**: Reliable detection of bursts up to designed length

### Code Rate

- **4-bit data**: 4/8 = 50%
- **8-bit data**: 8/16 = 50%
- **16-bit data**: 16/32 = 50%
- **32-bit data**: 32/64 = 50%

### Hardware Complexity

- **Encoding**: O(n) operations
- **Decoding**: O(n × burst_length) operations
- **Memory**: Minimal additional storage

## Usage Guidelines

### Choosing Burst Configurations

1. **Communication Channels**: Use when burst errors are expected
2. **Storage Systems**: Effective for magnetic/optical media errors
3. **Network Transmission**: Good for wired communication with interference
4. **Small Data Blocks**: Use shorter burst lengths for efficiency

### Implementation Considerations

1. **Channel Characteristics**: Match burst length to expected error patterns
2. **Performance vs Overhead**: Balance protection level with code rate
3. **Hardware Resources**: Consider implementation complexity
4. **Testing**: Use burst-specific test patterns

## Comparison with Other ECCs

| ECC Type | Random Errors | Burst Errors | Code Rate | Complexity |
|----------|---------------|--------------|-----------|------------|
| Hamming | Good | Limited | High | Low |
| BCH | Good | Limited | Medium | Medium |
| Burst ECC | Limited | Excellent | Medium | Medium |
| Reed-Solomon | Limited | Excellent | Low | High |

## Future Enhancements

1. **Interleaving Integration**: Add optional interleaving for better protection
2. **Adaptive Burst Length**: Dynamic burst length adjustment
3. **Soft Decision**: Soft-decision decoding for better performance
4. **Hybrid Approaches**: Combine with other ECC types

## References

1. Fire, P. (1959). A class of multiple-error-correcting binary codes for non-independent errors. Sylvania Report RSL-E-2.
2. Burton, H. O., & Sullivan, D. D. (1972). Errors and error control. Proceedings of the IEEE, 60(11), 1293-1301.
3. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.
