# Convolutional Error Correction Code Implementation

This document describes the Convolutional Error Correction Code (Convolutional ECC) implementation in both Python and Verilog.

## Overview

Convolutional codes are a class of error-correcting codes that operate on data streams rather than fixed blocks. They use shift registers and generator polynomials to create parity bits that depend on multiple input bits, providing excellent error correction capabilities for continuous data transmission.

## Supported Configurations

The implementation uses a (2,1,2) convolutional code:

| Parameter | Value | Description |
|-----------|-------|-------------|
| Rate | 1/2 | 1 input bit → 2 output bits |
| Constraint Length | 2 | Memory depth of the encoder |
| Generator Polynomials | (3, 2)₈ | G₁ = 3, G₂ = 2 in octal |

## Python Implementation

### Location: `src/convolutional_ecc.py`

The Python implementation provides:

- **ConvolutionalECC**: Main convolutional ECC class
- **ConvolutionalCode**: Core convolutional encoder/decoder
- **ViterbiDecoder**: Maximum likelihood decoding algorithm
- **Configurable Parameters**: Support for different code parameters

### Key Features

1. **Stream Processing**: Designed for continuous data streams
2. **Viterbi Decoding**: Optimal maximum likelihood decoding
3. **Flexible Rate**: Supports different code rates
4. **Memory Efficient**: Uses finite state machine approach

### Usage Example

```python
from src.convolutional_ecc import ConvolutionalECC

# Create convolutional ECC with 8-bit data blocks
conv_ecc = ConvolutionalECC(data_length=8)

# Encode data stream
data = 0b10110100
codeword = conv_ecc.encode(data)  # Rate 1/2 encoding

# Decode with Viterbi algorithm
decoded_data, error_type = conv_ecc.decode(codeword)

# Access convolutional code directly
conv_code = conv_ecc.conv
encoded_bits = conv_code.encode([1, 0, 1, 1, 0, 1, 0, 0])
decoded_bits = conv_code.viterbi_decode(encoded_bits)
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of:

1. **convolutional_ecc.v**: Main convolutional ECC module with hardware encoder/decoder

### Key Features

1. **Hardware Viterbi**: Efficient hardware implementation of Viterbi algorithm
2. **Shift Register Architecture**: Traditional convolutional encoder structure
3. **Real-time Processing**: Single-cycle encoding, pipelined decoding
4. **Resource Optimized**: Balanced performance and area usage

### Module Interface

```verilog
module convolutional_ecc #(
    parameter DATA_WIDTH = 8,
    parameter CODEWORD_WIDTH = 16  // DATA_WIDTH * 2 (rate 1/2)
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

1. **convolutional_ecc_tb.c**: C testbench for hardware verification
2. **test_convolutional_ecc.py**: Python unit tests for convolutional coding

### Test Coverage

- **Encoder Verification**: Tests correct codeword generation
- **Viterbi Decoding**: Validates maximum likelihood decoding
- **Error Correction**: Tests various error patterns and correction
- **Boundary Conditions**: Tests edge cases and state transitions

## Mathematical Background

### Convolutional Encoding

The encoder uses generator polynomials:

```
Input bit stream: u₀, u₁, u₂, u₃, ...
Generator G₁ = 3₈ = 11₂ (x + 1)
Generator G₂ = 2₈ = 10₂ (x)

For each input bit uₖ:
    Shift register: [uₖ, uₖ₋₁]
    Output: [p₁ₖ, p₂ₖ] where p₁ₖ = uₖ ⊕ uₖ₋₁, p₂ₖ = uₖ
```

### Trellis Diagram

The code can be represented as a trellis with 2^K states:

```
States: 00, 01, 10, 11
Transitions: Each state connects to 2 next states
Branch metrics: Hamming distance between received and expected
```

### Viterbi Algorithm

The decoder uses dynamic programming:

```
Initialize: Path metrics for all states
For each time step:
    For each state:
        Calculate branch metrics for both transitions
        Update path metrics: min(previous + branch_metric)
        Store survivor paths
Backtrack: Find minimum metric path from final state
```

## Performance Characteristics

### Error Correction Capability

- **Random Errors**: Good correction capability
- **Burst Errors**: Limited (depends on constraint length)
- **Soft Decision**: Can be extended for soft-decision decoding
- **Performance**: Near Shannon limit for long codes

### Code Rate

- **Rate 1/2**: 50% efficiency
- **Variable Rate**: Can be punctured for higher rates
- **Overhead**: Fixed 2x expansion

### Hardware Complexity

- **Encoding**: O(constraint_length) operations
- **Decoding**: O(2^K × codeword_length) operations
- **Memory**: State metric storage for Viterbi

## Usage Guidelines

### Choosing Convolutional Configurations

1. **Streaming Data**: Ideal for continuous data transmission
2. **Wireless Communications**: Excellent for fading channels
3. **Real-time Systems**: Good for latency-sensitive applications
4. **Memory Channels**: Less optimal than block codes

### Implementation Considerations

1. **Constraint Length**: Balance correction capability vs complexity
2. **Code Rate**: Choose appropriate rate for channel conditions
3. **Decoding Delay**: Consider Viterbi decoding latency
4. **Memory Usage**: State metrics grow exponentially with K

## Comparison with Block Codes

| Feature | Convolutional | Block Codes |
|---------|---------------|-------------|
| Data Processing | Streaming | Block-based |
| Latency | Variable | Fixed |
| Memory | Higher | Lower |
| Burst Errors | Limited | Better |
| Implementation | More complex | Simpler |

## Advantages

1. **Continuous Operation**: No block boundaries
2. **Excellent Performance**: Near-optimal error correction
3. **Flexible Rate**: Can be punctured for different rates
4. **Systematic**: Easy to implement in hardware

## Future Enhancements

1. **Soft-Decision Decoding**: Improved performance with soft inputs
2. **Punctured Codes**: Higher code rates for better efficiency
3. **Turbo Codes**: Integration with turbo coding principles
4. **Adaptive Coding**: Dynamic rate adjustment

## References

1. Viterbi, A. J. (1967). Error bounds for convolutional codes and an asymptotically optimum decoding algorithm. IEEE Transactions on Information Theory, 13(2), 260-269.
2. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.
3. Johannesson, R., & Zigangirov, K. S. (1999). Fundamentals of convolutional coding. IEEE Press.
