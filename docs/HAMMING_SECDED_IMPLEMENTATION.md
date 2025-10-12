# Hamming SECDED Error Correction Code Implementation

This document describes the Hamming SECDED (Single Error Correction, Double Error Detection) Error Correction Code implementation in both Python and Verilog.

## Overview

Hamming SECDED codes are among the most widely used error-correcting codes. They extend the basic Hamming code with an additional parity bit to detect double errors while maintaining single error correction capability. This makes them ideal for applications requiring both error correction and enhanced detection.

## Supported Configurations

The implementation supports extended Hamming SECDED configurations:

| Configuration | Data Bits (k) | Codeword Bits (n) | Parity Bits (m) | Use Case |
|---------------|----------------|-------------------|-----------------|----------|
| Hamming(7,4) SECDED | 4 | 8 | 4 | Small data blocks |
| Hamming(12,8) SECDED | 8 | 13 | 5 | Standard data blocks |
| Hamming(21,16) SECDED | 16 | 22 | 6 | Medium data blocks |
| Hamming(38,32) SECDED | 32 | 39 | 7 | Large data blocks |

## Python Implementation

### Location: `src/hamming_secded_ecc.py`

The Python implementation provides:

- **HammingSECDEDECC**: Main Hamming SECDED ECC class
- **Automatic Configuration**: Adapts to data length requirements
- **Syndrome Decoding**: Efficient error location and correction
- **SECDED Enhancement**: Double error detection capability

### Key Features

1. **Automatic Scaling**: Configures appropriate Hamming code based on data size
2. **Single Error Correction**: Corrects all single-bit errors
3. **Double Error Detection**: Detects all double-bit errors
4. **Systematic Encoding**: Data bits followed by parity bits

### Usage Example

```python
from src.hamming_secded_ecc import HammingSECDEDECC

# Create Hamming SECDED ECC for 8-bit data (becomes 13-bit codeword)
hamming = HammingSECDEDECC(data_length=8)

# Encode data with SECDED protection
data = 0b10110100
codeword = hamming.encode(data)

# Decode with single error correction and double error detection
decoded_data, error_type = hamming.decode(codeword)

# Error types: 'corrected' (single error), 'detected' (double error), 'undetected'
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of:

1. **hamming_secded_ecc.v**: Main Hamming SECDED ECC module

### Key Features

1. **Hardware Syndrome Calculation**: Efficient combinational logic
2. **Real-time Correction**: Single-cycle error correction and detection
3. **Configurable Data Width**: Support for different data sizes
4. **Resource Efficient**: Optimized for hardware implementation

### Module Interface

```verilog
module hamming_secded_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 13  // 8-bit data + 5-bit parity
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

1. **hamming_secded_ecc_tb.c**: C testbench for hardware verification
2. **test_hamming_secded_ecc.py**: Python unit tests for SECDED functionality

### Test Coverage

- **Single Error Correction**: Tests correction of individual bit errors
- **Double Error Detection**: Tests detection of two-bit errors
- **No Error Cases**: Validates correct operation without errors
- **Boundary Conditions**: Tests edge cases and special patterns

## Mathematical Background

### Hamming Code Construction

Hamming codes use parity bits at positions that are powers of 2:

```
Parity positions: 2⁰, 2¹, 2², ... = 1, 2, 4, 8, 16, ...
Data positions: All other positions
```

### SECDED Extension

SECDED adds an overall parity bit:

```
SECDED parity = XOR of all data and Hamming parity bits
Total parity bits = Hamming parity bits + 1 overall parity
```

### Syndrome Calculation

For error detection and correction:

```
Syndrome = received_codeword × H^T
If syndrome = 0: No error
If syndrome weight = 1: Single error at syndrome position
If syndrome weight > 1: Double error detected (SECDED)
```

## Performance Characteristics

### Error Correction Capability

- **Single Errors**: 100% correction
- **Double Errors**: 100% detection (no correction)
- **Triple Errors**: May be miscorrected as single errors
- **Detection**: Excellent for double error detection

### Code Rate

- **Hamming(7,4) SECDED**: 4/8 = 50%
- **Hamming(12,8) SECDED**: 8/13 ≈ 62%
- **Hamming(21,16) SECDED**: 16/22 ≈ 73%
- **Hamming(38,32) SECDED**: 32/39 ≈ 82%

### Hardware Complexity

- **Encoding**: O(log n) parity calculations
- **Decoding**: O(log n) syndrome computation
- **Memory**: Minimal (position tables)
- **Latency**: Single clock cycle

## Usage Guidelines

### Choosing Hamming SECDED Configurations

1. **Memory Systems**: Excellent for DRAM and SRAM error correction
2. **Communication**: Good for reliable data transmission
3. **Storage Systems**: Used in disk drives and SSD controllers
4. **Network Switches**: Common in high-reliability networking

### Implementation Considerations

1. **Data Width**: Choose configuration based on data size
2. **Error Patterns**: Understand single vs double error handling
3. **Performance**: Excellent for real-time applications
4. **Hardware Cost**: Very efficient resource usage

## Comparison with Other ECCs

| ECC Type | Correction | Detection | Code Rate | Complexity |
|----------|------------|-----------|-----------|------------|
| Parity | None | Odd errors | High | Very Low |
| Hamming SECDED | Single error | Double errors | Medium-High | Low |
| BCH | Multiple errors | Multiple errors | Medium | Medium |
| Reed-Solomon | Multiple errors | Burst errors | Low | High |

## Advantages of Hamming SECDED

1. **Balanced Capability**: Good correction and detection
2. **Simple Implementation**: Easy to understand and implement
3. **Hardware Efficient**: Minimal resources required
4. **Widely Used**: Proven in many applications

## Applications

Hamming SECDED is used in:

- **Computer Memory**: DRAM error correction
- **Satellite Communications**: Spacecraft data handling
- **Disk Drives**: Hard disk error correction
- **Network Equipment**: Router and switch memory protection
- **Embedded Systems**: Microcontroller memory protection

## SECDED vs Basic Hamming

| Feature | Basic Hamming | Hamming SECDED |
|---------|----------------|----------------|
| Correction | Single error | Single error |
| Detection | Single error | Double errors |
| Parity Bits | m | m + 1 |
| Reliability | Good | Excellent |
| Complexity | Simple | Slightly more complex |

## Future Enhancements

1. **Extended Hamming**: Further enhanced error detection
2. **Chipkill**: Multi-bit error correction for memory
3. **Adaptive Hamming**: Dynamic configuration based on conditions
4. **Soft Decoding**: Improved performance with soft inputs

## References

1. Hamming, R. W. (1950). Error detecting and error correcting codes. Bell System Technical Journal, 29(2), 147-160.
2. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.
3. Chen, C. L., & Hsiao, M. Y. (1984). Error-correcting codes for semiconductor memory applications: A state-of-the-art review. IBM Journal of Research and Development, 28(2), 124-134.
