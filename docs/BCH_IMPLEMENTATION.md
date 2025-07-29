# BCH Error Correction Code Implementation

This document describes the BCH (Bose-Chaudhuri-Hocquenghem) Error Correction Code implementations in both Python and Verilog.

## Overview

BCH codes are a class of cyclic error-correcting codes that are constructed using polynomials over a finite field (Galois Field). They are widely used in digital communications and storage systems due to their excellent error detection and correction capabilities.

## Supported BCH Configurations

The implementation supports the following BCH configurations:

| Configuration | Data Bits (k) | Codeword Bits (n) | Error Correction (t) | Use Case |
|---------------|---------------|-------------------|---------------------|----------|
| BCH(7,4,1)   | 4             | 7                 | 1                   | Simple applications |
| BCH(15,7,2)  | 7             | 15                | 2                   | Default configuration |
| BCH(31,16,3) | 16            | 31                | 3                   | Medium reliability |
| BCH(63,32,6) | 32            | 63                | 6                   | High reliability |

## Python Implementation

### Location: `src/bch_ecc.py`

The Python implementation uses the `bchlib` library and provides:

- **BCHConfig**: Dataclass for BCH configuration parameters
- **BCHECC**: Main BCH ECC class with encode/decode methods
- **Error injection**: Method to simulate bit errors for testing

### Key Features

1. **Flexible Configuration**: Supports all standard BCH configurations
2. **Automatic Parameter Selection**: Chooses appropriate parameters based on data length
3. **Error Handling**: Comprehensive error detection and correction
4. **Fallback Support**: Graceful degradation when bchlib is unavailable

### Usage Example

```python
from src.bch_ecc import BCHECC, BCHConfig

# Create BCH encoder/decoder
bch = BCHECC(n=15, k=7, t=2)  # BCH(15,7,2)

# Encode data
data = 0b1011011
codeword = bch.encode(data)

# Decode codeword
decoded_data, error_type = bch.decode(codeword)
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of several modules:

1. **bch74_ecc.v**: BCH(7,4,1) implementation
2. **bch1572_ecc.v**: BCH(15,7,2) implementation  
3. **bch31163_ecc.v**: BCH(31,16,3) implementation
4. **bch63326_ecc.v**: BCH(63,32,6) implementation
5. **general_bch_ecc.v**: Parameterized general BCH module

### Key Features

1. **Systematic Encoding**: Data bits followed by parity bits
2. **Syndrome Calculation**: Error detection using syndrome computation
3. **Error Correction**: Single-bit error correction for BCH(7,4,1)
4. **Parameterized Design**: General module supports multiple configurations

### Module Interface

#### Encoder
```verilog
module bch_encoder (
    input  [k-1:0] data_in,
    output [n-1:0] codeword_out
);
```

#### Decoder
```verilog
module bch_decoder (
    input  [n-1:0] codeword_in,
    output [k-1:0] data_out,
    output error_detected,
    output error_corrected,
    output [3:0] error_count
);
```

## Testbenches

### Available Testbenches

1. **bch74_tb.v**: Tests BCH(7,4,1) implementation
2. **bch1572_tb.v**: Tests BCH(15,7,2) implementation
3. **general_bch_tb.v**: Tests all BCH configurations
4. **bch_comparison_tb.v**: Compares Verilog with Python results

### Test Coverage

- **Encoder Tests**: Verify correct codeword generation
- **Decoder Tests**: Verify correct data recovery
- **Error Detection**: Test error detection capabilities
- **Error Correction**: Test error correction (where applicable)
- **Multiple Vectors**: Test with various input patterns

## Mathematical Background

### Generator Polynomials

Each BCH configuration uses a specific generator polynomial:

- **BCH(7,4,1)**: g(x) = x³ + x + 1
- **BCH(15,7,2)**: g(x) = x⁸ + x⁷ + x⁶ + x⁴ + 1
- **BCH(31,16,3)**: g(x) = x¹⁵ + x¹¹ + x¹⁰ + x⁹ + x⁸ + x⁷ + x⁵ + x³ + x² + x + 1
- **BCH(63,32,6)**: g(x) = x³¹ + x³⁰ + x²⁹ + ... + x + 1

### Syndrome Calculation

The decoder calculates syndromes to detect errors:

```
S₁ = r(α), S₂ = r(α²), S₃ = r(α³), ..., S₂ₜ = r(α²ᵗ)
```

where r(x) is the received polynomial and α is a primitive element.

## Performance Characteristics

### Error Correction Capability

- **BCH(7,4,1)**: Corrects up to 1 bit error
- **BCH(15,7,2)**: Corrects up to 2 bit errors
- **BCH(31,16,3)**: Corrects up to 3 bit errors
- **BCH(63,32,6)**: Corrects up to 6 bit errors

### Code Rate

- **BCH(7,4,1)**: 4/7 ≈ 57%
- **BCH(15,7,2)**: 7/15 ≈ 47%
- **BCH(31,16,3)**: 16/31 ≈ 52%
- **BCH(63,32,6)**: 32/63 ≈ 51%

## Usage Guidelines

### Choosing a BCH Configuration

1. **BCH(7,4,1)**: Use for simple applications with low error rates
2. **BCH(15,7,2)**: Default choice for most applications
3. **BCH(31,16,3)**: Use for medium reliability requirements
4. **BCH(63,32,6)**: Use for high reliability requirements

### Implementation Considerations

1. **Hardware vs Software**: Verilog for hardware, Python for software
2. **Performance**: Verilog implementations are faster for real-time applications
3. **Flexibility**: Python implementation supports more configurations
4. **Testing**: Use provided testbenches for verification

## Future Enhancements

1. **Advanced Decoding**: Implement Berlekamp-Massey algorithm
2. **Soft Decision**: Add soft-decision decoding capabilities
3. **Pipelined Architecture**: Optimize for high-speed applications
4. **More Configurations**: Support additional BCH parameters

## References

1. Bose, R. C., & Ray-Chaudhuri, D. K. (1960). On a class of error correcting binary group codes. Information and Control, 3(1), 68-79.
2. Hocquenghem, A. (1959). Codes correcteurs d'erreurs. Chiffres, 2, 147-156.
3. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.