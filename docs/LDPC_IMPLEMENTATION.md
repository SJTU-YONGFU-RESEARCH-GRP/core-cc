# LDPC Error Correction Code Implementation

This document describes the Low-Density Parity-Check (LDPC) Error Correction Code implementation in both Python and Verilog.

## Overview

LDPC codes are a class of linear block codes that provide near-Shannon limit performance with practical decoding complexity. They use sparse parity-check matrices and iterative message-passing decoding algorithms. LDPC codes are widely used in modern communication standards including WiFi (802.11n/ac), DVB-S2, and 10G Ethernet.

## Supported Configurations

The implementation supports regular LDPC configurations:

| Configuration | Codeword Length (n) | Data Length (k) | Variable Degree (d_v) | Check Degree (d_c) |
|---------------|---------------------|-----------------|----------------------|-------------------|
| LDPC(8,4) | 8 | 4 | 2 | 4 |
| LDPC(16,8) | 16 | 8 | 2 | 4 |
| LDPC(32,16) | 32 | 16 | 2 | 4 |
| LDPC(64,32) | 64 | 32 | 2 | 4 |

## Python Implementation

### Location: `src/ldpc_ecc.py`

The Python implementation provides:

- **LDPCECC**: Main LDPC ECC class
- **Sparse Matrix Operations**: Efficient sparse parity-check matrices
- **Message-Passing Decoding**: Belief Propagation (BP) algorithm
- **pyldpc Integration**: Uses pyldpc library for matrix generation

### Key Features

1. **Near-Optimal Performance**: Approaches Shannon limit
2. **Iterative Decoding**: Efficient message-passing algorithms
3. **Sparse Matrices**: Low-density parity-check matrices
4. **Flexible Construction**: Regular and irregular LDPC codes

### Usage Example

```python
from src.ldpc_ecc import LDPCECC

# Create LDPC(16,8) code
ldpc_ecc = LDPCECC(n=16, d_v=2, d_c=4)

# Encode data
data = 0b10110100  # 8 bits
codeword = ldpc_ecc.encode(data)

# Decode with message-passing
decoded_data, error_type = ldpc_ecc.decode(codeword)

# Get code parameters
print(f"Code rate: {ldpc_ecc.get_code_rate()}")
print(f"Minimum distance: {ldpc_ecc.get_minimum_distance()}")
```

## Verilog Implementation

### Module Structure

The Verilog implementation consists of:

1. **ldpc_ecc.v**: Main LDPC ECC module with message-passing decoder

### Key Features

1. **Hardware Message-Passing**: Parallel variable and check node updates
2. **Fixed-Point Arithmetic**: Efficient fixed-point LLR computations
3. **Memory Architecture**: Specialized memory for sparse matrices
4. **Pipeline Processing**: High-throughput iterative decoding

### Module Interface

```verilog
module ldpc_ecc #(
    parameter N = 16,            // Codeword length
    parameter K = 8              // Data length
) (
    input  wire                clk,
    input  wire                rst_n,
    input  wire                encode_en,
    input  wire                decode_en,
    input  wire [K-1:0]        data_in,
    input  wire [N-1:0]        codeword_in,
    output reg  [N-1:0]        codeword_out,
    output reg  [K-1:0]        data_out,
    output reg                 error_detected,
    output reg                 error_corrected,
    output reg                 valid_out
);
```

## Mathematical Background

### Parity-Check Matrix

LDPC codes are defined by sparse parity-check matrix H:

```
H: (n-k) × n binary matrix with row weight d_c, column weight d_v
Code: C = {x | Hx^T = 0}
Minimum distance: Related to girth and degree distribution
```

### Tanner Graph

LDPC codes can be represented as bipartite graphs:

- **Variable Nodes**: Correspond to codeword bits
- **Check Nodes**: Correspond to parity-check equations
- **Edges**: Connect variables to checks they participate in

### Message-Passing Decoding

Belief Propagation algorithm:

1. **Initialization**: Set variable node LLRs from channel
2. **Check Node Update**: Compute extrinsic information for checks
3. **Variable Node Update**: Update variable beliefs
4. **Tentative Decoding**: Make hard decisions
5. **Parity Check**: Verify codeword validity
6. **Iteration**: Repeat until convergence or max iterations

### Degree Distributions

Regular LDPC codes have constant degrees:

- **Variable Degree**: λ(x) = x^(d_v-1)
- **Check Degree**: ρ(x) = x^(d_c-1)

## Performance Characteristics

### Error Correction Capability

- **Near Shannon Limit**: Within 0.0045 dB of capacity
- **Excellent Performance**: Better than Turbo codes at high rates
- **Waterfall Region**: Sharp threshold behavior
- **Error Floor**: Potential high-SNR performance degradation

### Code Rate

- **Configurable**: R = k/n depending on matrix construction
- **High Rates**: Can achieve rates close to 1
- **Flexible**: Various rate options available

### Hardware Complexity

- **Encoding**: O(n) operations with generator matrix
- **Decoding**: O(n × w × I) operations (w = degree, I = iterations)
- **Memory**: Significant for storing sparse matrices
- **Parallelism**: High potential for parallel processing

## Usage Guidelines

### Choosing LDPC Configurations

1. **WiFi Standards**: 802.11n/ac LDPC codes
2. **DVB-S2**: Satellite broadcasting
3. **10G Ethernet**: High-speed networking
4. **Optical Communications**: Long-haul fiber optics

### Implementation Considerations

1. **Matrix Construction**: Choose appropriate degree distributions
2. **Iteration Count**: Balance performance vs latency
3. **Fixed-Point Precision**: Consider quantization effects
4. **Memory Architecture**: Optimize sparse matrix storage

## Comparison with Other ECCs

| ECC Type | Performance | Complexity | Parallelism | Applications |
|----------|-------------|------------|-------------|--------------|
| Turbo | Excellent | High | Medium | 3G/4G wireless |
| LDPC | Excellent | Very High | High | WiFi, DVB, Ethernet |
| Polar | Very Good | Medium | High | 5G control channels |
| Convolutional | Good | Low | Low | Voice communications |

## Advantages of LDPC Codes

1. **Near-Optimal Performance**: Closest to Shannon limit
2. **High Parallelism**: Excellent for hardware implementation
3. **Flexible Rates**: Wide range of code rates available
4. **Standards Adoption**: Used in major modern standards

## Applications

LDPC codes are used in:

- **Wireless Networks**: WiFi 802.11n/ac/ax
- **Satellite Communications**: DVB-S2, DVB-S2X
- **Optical Networks**: 10G/40G/100G Ethernet
- **Mobile Communications**: 4G/5G data channels
- **Magnetic Recording**: Hard disk drives
- **Deep Space**: Mars reconnaissance orbiter

## Future Enhancements

1. **Irregular LDPC**: Optimized degree distributions
2. **Non-Binary LDPC**: Higher order Galois fields
3. **Spatially Coupled**: Convolutional LDPC codes
4. **Neural Decoding**: Machine learning enhanced decoding

## References

1. Gallager, R. G. (1962). Low-density parity-check codes. IRE Transactions on Information Theory, 8(1), 21-28.
2. Richardson, T. J., & Urbanke, R. L. (2001). The capacity of low-density parity-check codes under message-passing decoding. IEEE Transactions on Information Theory, 47(2), 599-618.
3. Mackay, D. J. C., & Neal, R. M. (1996). Near Shannon limit performance of low density parity check codes. Electronics Letters, 32(18), 1645-1646.
4. Lin, S., & Costello, D. J. (2004). Error control coding: fundamentals and applications. Pearson Education.
