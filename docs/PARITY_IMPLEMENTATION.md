# Parity Error Correction Code Implementation

This document describes the Parity Error Correction Code implementation in both Python and Verilog.

## Overview

Parity codes are the simplest form of error detection and correction codes. They add a single parity bit to detect odd numbers of bit errors. While limited in correction capability, parity codes are widely used due to their simplicity and low overhead.

## Supported Configurations

The implementation supports standard parity configurations:

| Configuration | Data Bits | Total Bits | Error Detection | Error Correction |
|---------------|-----------|------------|-----------------|------------------|
| Single Parity | k | k+1 | Odd errors | None |
| Even Parity | k | k+1 | Odd errors | None |
| Odd Parity | k | k+1 | Even errors | None |

## Python Implementation

### Location: `src/parity_ecc.py`

The Python implementation provides:

- **ParityECC**: Main parity ECC class
- **Even/Odd Parity**: Configurable parity types
- **Error Detection**: Reliable odd/even error detection
- **Simple Interface**: Easy integration with other systems

### Key Features

1. **Minimal Overhead**: Only 1 parity bit added
2. **Fast Computation**: Simple XOR operation
3. **Configurable Parity**: Even or odd parity support
4. **Hardware Friendly**: Extremely simple hardware implementation

### Usage Example

```python
from src.parity_ecc import ParityECC

# Create parity ECC for 8-bit data (default: even parity)
parity_ecc = ParityECC(data_length=8)

# Encode data with parity bit
data = 0b10110100
codeword = parity_ecc.encode(data)  # Adds 1 parity bit

# Decode and check parity
decoded_data, error_type = parity_ecc.decode(codeword)

# Check if data has correct parity
is_valid = parity_ecc.check_parity(data)
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of:

1. **parity_ecc.v**: Main parity ECC module
2. **parity_encoder.v**: Dedicated parity encoder
3. **parity_decoder.v**: Dedicated parity decoder

### Key Features

1. **Single-Cycle Operation**: Instant encoding/decoding
2. **Minimal Resources**: Few logic gates required
3. **Pipeline Friendly**: Can be used in high-speed pipelines
4. **Configurable**: Support for different data widths

### Module Interface

```verilog
module parity_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                clk,
    input  wire                rst_n,
    input  wire                encode_en,
    input  wire                decode_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire [DATA_WIDTH:0] codeword_in,
    output reg  [DATA_WIDTH:0] codeword_out,
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg                 error_detected,
    output reg                 error_corrected,
    output reg                 valid_out
);
```

## Testbenches

### Available Testbenches

1. **parity_ecc_tb.c**: C testbench for hardware verification
2. **test_parity_ecc.py**: Python unit tests for parity functionality

### Test Coverage

- **Parity Calculation**: Verifies correct even/odd parity
- **Error Detection**: Tests single and multiple error detection
- **Systematic Encoding**: Validates data + parity structure
- **Edge Cases**: Tests all-zeros, all-ones, and boundary conditions

## Mathematical Background

### Even Parity

For even parity, the parity bit is set so total number of 1s is even:

```
Parity bit = XOR of all data bits
Total 1s in codeword = even number
```

### Odd Parity

For odd parity, the parity bit is set so total number of 1s is odd:

```
Parity bit = NOT(XOR of all data bits)
Total 1s in codeword = odd number
```

### Error Detection

Parity detects any odd number of errors:

- **1 error**: Detected (parity changes)
- **2 errors**: Not detected (parity unchanged)
- **3 errors**: Detected (parity changes)
- **Even errors**: Not detected
- **Odd errors**: Always detected

## Performance Characteristics

### Error Detection Capability

- **Single Errors**: 100% detection
- **Triple Errors**: 100% detection
- **Odd Errors**: 100% detection
- **Even Errors**: 0% detection

### Error Correction Capability

- **No Correction**: Parity only detects, doesn't correct
- **Limited Use**: Must combine with other ECCs for correction

### Code Rate

- **k/(k+1)**: Approaches 100% as data length increases
- **8-bit data**: 8/9 = 89% efficiency
- **Overhead**: Minimal (1 bit regardless of data size)

### Hardware Complexity

- **Encoding**: O(k) XOR operations
- **Decoding**: O(k) XOR operations
- **Latency**: Single gate delay
- **Area**: Minimal silicon area

## Usage Guidelines

### Choosing Parity Configurations

1. **Basic Detection**: Use when minimal overhead is needed
2. **Legacy Systems**: Common in older communication protocols
3. **Checksum**: Good for basic data integrity checking
4. **Combined ECC**: Use as foundation for more complex codes

### Implementation Considerations

1. **Parity Type**: Choose even or odd based on system requirements
2. **Data Width**: Scales well with data size
3. **Performance**: Excellent for high-speed applications
4. **Limitations**: Understand detection limitations

## Comparison with Other ECCs

| ECC Type | Overhead | Detection | Correction | Complexity |
|----------|----------|-----------|------------|------------|
| Parity | 1 bit | Odd errors | None | Very Low |
| Hamming | ~50% | Double errors | Single error | Low |
| CRC | 8 bits | Excellent | Limited | Medium |
| BCH | Variable | Multiple | Multiple | High |

## Advantages

1. **Simplicity**: Extremely simple to implement
2. **Speed**: Fastest error detection method
3. **Low Overhead**: Minimal bandwidth impact
4. **Universal**: Works with any data size

## Limitations

1. **No Correction**: Cannot correct detected errors
2. **Limited Detection**: Misses even numbers of errors
3. **Burst Errors**: Poor performance on burst errors
4. **Modern Systems**: Often insufficient alone

## Applications

Parity is commonly used in:

- **Serial Communication**: UART, RS-232
- **Memory Systems**: Basic DRAM error detection
- **Network Protocols**: Ethernet FCS (combined with CRC)
- **Storage Systems**: Basic disk sector validation

## Future Enhancements

1. **Multiple Parity**: Horizontal and vertical parity
2. **Parity Prediction**: Hardware-assisted parity generation
3. **Error Correction**: Extended parity with correction capability
4. **Adaptive Parity**: Dynamic parity bit allocation

## References

1. Hamming, R. W. (1950). Error detecting and error correcting codes. Bell System Technical Journal, 29(2), 147-160.
2. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.
3. Peterson, W. W., & Weldon, E. J. (1972). Error-correcting codes. MIT Press.
