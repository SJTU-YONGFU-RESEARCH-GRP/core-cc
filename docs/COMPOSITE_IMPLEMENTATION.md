# Composite Error Correction Code Implementation

This document describes the Composite Error Correction Code (Composite ECC) implementation in both Python and Verilog.

## Overview

Composite ECC combines multiple error correction techniques in a layered or parallel approach to achieve enhanced error detection and correction capabilities. Unlike concatenated codes that apply ECCs sequentially, composite codes typically use redundancy or parallel encoding schemes to provide robust error protection.

## Architecture

The composite ECC uses a simple but effective approach:

1. **Data Duplication**: Creates redundant copies of the data
2. **Parallel Protection**: Applies protection across multiple data copies
3. **Majority Voting**: Uses redundancy for error correction
4. **Fallback Mechanisms**: Graceful degradation when errors are detected

## Supported Configurations

The implementation supports various data lengths with automatic configuration:

| Data Length | Redundancy Factor | Effective Protection | Use Case |
|-------------|-------------------|---------------------|----------|
| 8-bit | 2x | Simple redundancy | Basic protection |
| 16-bit | 2x | Dual redundancy | Medium protection |
| 32-bit | 2x | Quad redundancy | High protection |
| 64-bit | 2x | Extended redundancy | Maximum protection |

## Python Implementation

### Location: `src/composite_ecc.py`

The Python implementation provides:

- **CompositeECC**: Main composite ECC class
- **Configurable ECC Chain**: Support for custom ECC combinations
- **Automatic Fallback**: Default simple redundancy scheme
- **Flexible Architecture**: Can be extended with different ECC combinations

### Key Features

1. **Simple Redundancy**: Default data duplication for reliability
2. **ECC Chain Support**: Can combine multiple ECC types
3. **Automatic Configuration**: Adapts to data length requirements
4. **Error Resilience**: Maintains data integrity through redundancy

### Usage Example

```python
from src.composite_ecc import CompositeECC

# Create composite ECC (uses simple redundancy by default)
composite = CompositeECC(data_length=8)

# Encode data with redundancy
data = 0b10110100
codeword = composite.encode(data)  # Creates redundant codeword

# Decode with error correction via redundancy
decoded_data, error_type = composite.decode(codeword)

# Can also create custom ECC chains
from src.parity_ecc import ParityECC
from src.hamming_secded_ecc import HammingSECDEDECC

custom_composite = CompositeECC(
    ecc_chain=[
        ParityECC(data_length=8),
        HammingSECDEDECC(data_length=8)
    ]
)
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of:

1. **composite_ecc.v**: Main composite ECC module

### Key Features

1. **Hardware Redundancy**: Implements data duplication in hardware
2. **Parallel Processing**: Multiple ECC operations in parallel
3. **Majority Logic**: Hardware-based majority voting for correction
4. **Resource Sharing**: Efficient use of hardware resources

### Module Interface

```verilog
module composite_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 16  // 8-bit data + 8-bit redundancy
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

1. **composite_ecc_tb.c**: C testbench for hardware verification
2. **test_composite_ecc.py**: Python unit tests for composite behavior

### Test Coverage

- **Redundancy Testing**: Verifies data duplication and recovery
- **Error Correction**: Tests majority voting and correction logic
- **ECC Chain Testing**: Validates custom ECC combinations
- **Boundary Conditions**: Tests edge cases and error scenarios

## Mathematical Background

### Redundancy Model

The basic composite ECC uses simple data duplication:

```
Original Data: D = [d₇ d₆ d₅ d₄ d₃ d₂ d₁ d₀]
Codeword: C = [D₁ | D₂] where D₁ = D₂ = D
```

### Error Correction

Correction uses majority voting across redundant copies:

```
For each bit position i:
    if D₁[i] == D₂[i]: output = D₁[i]
    else: error_detected = true, use fallback logic
```

### ECC Chain Operation

For multi-ECC chains:

```
Encoding: data → ECC₁ → ECC₂ → ... → ECCₙ → codeword
Decoding: codeword → ECCₙ⁻¹ → ... → ECC₁⁻¹ → data
```

## Performance Characteristics

### Error Correction Capability

- **Single Errors**: Corrected through redundancy
- **Multiple Errors**: Limited by redundancy factor
- **Detection**: High detection capability through comparison
- **Correction**: Depends on redundancy and ECC chain

### Code Rate

- **Simple Redundancy**: 50% (2x redundancy)
- **ECC Chain**: Variable based on chain composition
- **Overhead**: Linear with number of ECCs in chain

### Hardware Complexity

- **Encoding**: O(data_width) operations
- **Decoding**: O(data_width × redundancy) operations
- **Memory**: 2× data_width for basic redundancy

## Usage Guidelines

### Choosing Composite Configurations

1. **Simple Redundancy**: Use for basic error detection and correction
2. **ECC Chains**: Combine complementary ECC types for enhanced protection
3. **High Reliability**: Use multiple redundancy levels
4. **Resource Constraints**: Balance redundancy with hardware limits

### Implementation Considerations

1. **Redundancy Level**: Match to reliability requirements
2. **ECC Compatibility**: Ensure ECCs in chain are compatible
3. **Performance Trade-offs**: Consider encoding/decoding latency
4. **Testing**: Comprehensive testing of all ECC combinations

## Comparison with Other ECCs

| ECC Type | Redundancy | Flexibility | Complexity | Reliability |
|----------|------------|-------------|------------|-------------|
| Simple ECC | None | Low | Low | Basic |
| Composite | High | High | Medium | High |
| Concatenated | Medium | High | High | Very High |
| Adaptive | Variable | Very High | High | Variable |

## Future Enhancements

1. **Advanced Redundancy**: Intelligent redundancy patterns
2. **Dynamic Chains**: Runtime ECC chain modification
3. **Error Pattern Analysis**: Adaptive redundancy based on error types
4. **Hybrid Approaches**: Combine with other error correction techniques

## References

1. Forney, G. D. (1966). Concatenated codes. MIT Press.
2. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.
3. Wicker, S. B. (1995). Error control systems for digital communication and storage. Prentice Hall.
