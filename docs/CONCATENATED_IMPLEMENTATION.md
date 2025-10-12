# Concatenated Error Correction Code Implementation

This document describes the Concatenated Error Correction Code (Concatenated ECC) implementation in both Python and Verilog.

## Overview

Concatenated ECC applies multiple error correction codes in sequence, creating a layered protection scheme. Data is first encoded with an inner code, then the result is encoded with an outer code. This approach provides superior error correction capabilities compared to single-layer codes, as it can correct both random and burst errors effectively.

## Architecture

The concatenated ECC uses a two-stage encoding/decoding process:

1. **Inner Code**: Applied first to individual data segments
2. **Outer Code**: Applied to the inner code's output as a whole
3. **Sequential Processing**: Encoding and decoding happen in reverse order
4. **Error Correction**: Combines capabilities of both code layers

## Supported Configurations

The implementation supports various concatenated configurations:

| Data Length | Inner Code | Outer Code | Total Overhead | Use Case |
|-------------|------------|------------|----------------|----------|
| 8-bit | Parity (4-bit) | Hamming SECDED | 13-bit | Standard protection |
| 16-bit | Parity (4-bit) | Hamming SECDED | 26-bit | Extended data |
| 32-bit | Parity (4-bit) | Hamming SECDED | 52-bit | Large data blocks |

## Python Implementation

### Location: `src/concatenated_ecc.py`

The Python implementation provides:

- **ConcatenatedECC**: Main concatenated ECC class
- **Automatic Sub-word Division**: Splits data into appropriate segments
- **Inner/Outer Code Management**: Handles ECC chain coordination
- **Error Propagation Control**: Manages error correction across layers

### Key Features

1. **Two-Layer Protection**: Inner and outer code combination
2. **Automatic Segmentation**: Data divided into optimal sub-words
3. **Error Correction Cascade**: Errors corrected at multiple levels
4. **Flexible Configuration**: Supports different inner/outer code combinations

### Usage Example

```python
from src.concatenated_ecc import ConcatenatedECC

# Create concatenated ECC (Parity inner + Hamming SECDED outer)
concatenated = ConcatenatedECC(word_length=8)

# Encode data through both layers
data = 0b10110100
codeword = concatenated.encode(data)  # Inner encode → Outer encode

# Decode through both layers (reverse order)
decoded_data, error_type = concatenated.decode(codeword)  # Outer decode → Inner decode

# Get concatenation information
info = concatenated.get_concatenation_info()
print(f"Inner code: {info['inner_code']}")
print(f"Outer code: {info['outer_code']}")
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of:

1. **concatenated_ecc.v**: Main concatenated ECC module with sequential processing

### Key Features

1. **Pipelined Architecture**: Efficient sequential ECC processing
2. **Hardware Optimization**: Specialized logic for inner/outer code operations
3. **Error Tracking**: Maintains error status across decoding layers
4. **Resource Management**: Balances complexity between code layers

### Module Interface

```verilog
module concatenated_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 26  // 8-bit data + 18-bit parity (concatenated)
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

1. **concatenated_ecc_tb.c**: C testbench for hardware verification
2. **test_concatenated_ecc.py**: Python unit tests for layered error correction

### Test Coverage

- **Layer Separation**: Tests inner and outer code independently
- **Sequential Processing**: Validates encoding/decoding order
- **Error Propagation**: Tests error handling across layers
- **Boundary Conditions**: Tests edge cases in data segmentation

## Mathematical Background

### Concatenation Principle

For data D, inner code C₁, outer code C₂:

```
Encoding: C₂(C₁(D))
Decoding: C₁⁻¹(C₂⁻¹(codeword))
```

### Sub-word Division

Data is divided into equal segments:

```
8-bit data: [d₇ d₆ d₅ d₄] [d₃ d₂ d₁ d₀] (two 4-bit segments)
Inner encoding: Apply C₁ to each segment
Outer encoding: Apply C₂ to concatenated inner codewords
```

### Error Correction Capability

The concatenated code can correct:

- **Inner Code Errors**: Corrected by inner decoder
- **Outer Code Errors**: Corrected by outer decoder
- **Combined Errors**: Enhanced correction through layered approach

## Performance Characteristics

### Error Correction Capability

- **Random Errors**: Excellent (inner + outer correction)
- **Burst Errors**: Good (outer code handles burst patterns)
- **Detection**: Superior (multiple detection layers)
- **Correction**: Enhanced through code combination

### Code Rate

- **8-bit data**: 8/26 ≈ 31% (significant overhead)
- **16-bit data**: 16/52 ≈ 31%
- **Overhead**: Higher due to multiple encoding layers

### Hardware Complexity

- **Encoding**: O(data_width × 2) operations
- **Decoding**: O(codeword_width × 2) operations
- **Latency**: Multiple clock cycles for sequential processing

## Usage Guidelines

### Choosing Concatenated Configurations

1. **High Reliability**: Use when maximum error correction is needed
2. **Mixed Error Types**: Effective against both random and burst errors
3. **Communication Systems**: Ideal for noisy channels
4. **Storage Systems**: Good for long-term data preservation

### Implementation Considerations

1. **Performance Impact**: Consider latency of sequential processing
2. **Code Selection**: Choose complementary inner/outer codes
3. **Hardware Resources**: Higher resource usage than single codes
4. **Testing**: Thorough testing of both code layers

## Comparison with Other ECCs

| ECC Type | Layers | Error Correction | Complexity | Code Rate |
|----------|--------|------------------|------------|-----------|
| Single ECC | 1 | Moderate | Low | High |
| Composite | 1-2 | Good | Medium | Medium |
| Concatenated | 2+ | Excellent | High | Low |
| Turbo/Product | 2+ | Very High | Very High | Low |

## Advantages of Concatenation

1. **Enhanced Correction**: Better than individual codes alone
2. **Error Diversity**: Different codes handle different error patterns
3. **Reliability**: Multiple correction opportunities
4. **Flexibility**: Can combine various ECC types

## Future Enhancements

1. **Multi-Level Concatenation**: More than two code layers
2. **Adaptive Concatenation**: Dynamic code selection
3. **Optimized Segmentation**: Intelligent data division
4. **Parallel Processing**: Reduce latency through parallelism

## References

1. Forney, G. D. (1966). Concatenated codes. MIT Press.
2. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.
3. Costello, D. J., & Lin, S. (1983). Error control coding for digital communications. In Applications of Calculus (pp. 1-32). Springer.
