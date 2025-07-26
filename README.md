# ECC Analysis Framework v1.0

A comprehensive framework for benchmarking, analyzing, and comparing different Error Correction Code (ECC) implementations with support for hardware verification, detailed performance analysis, and parallel processing capabilities.

## Table of Contents

1. [Quick Start](#quick-start)
   - [1.1 Basic Usage](#1-basic-usage)
   - [1.2 Python Framework Usage](#2-python-framework-usage)
   - [1.3 Shell Script Integration](#7-shell-script-integration)
   - [1.4 Performance Testing](#6-performance-testing-and-demonstration)

2. [Features](#features)
   - [2.1 Comprehensive Benchmarking](#-comprehensive-benchmarking)
   - [2.2 Supported ECC Types](#-supported-ecc-types)
   - [2.3 Advanced Analysis](#-advanced-analysis)
   - [2.4 Hardware Verification](#-hardware-verification)
   - [2.5 Enhanced Reporting](#-enhanced-reporting)
   - [2.6 Parallel Processing](#-parallel-processing)

3. [Setup & Installation](#setup)
   - [3.1 Linux/macOS](#linuxmacos)
   - [3.2 Windows (with WSL)](#windows-with-wsl)
   - [3.3 Hardware Requirements](#hardware-requirements)

4. [Usage Guide](#usage-guide)
   - [4.1 Execution Modes](#execution-modes)
   - [4.2 Command Line Options](#command-line-options)
   - [4.3 Configuration Options](#configuration-options)
   - [4.4 Custom Configuration](#3-custom-configuration)
   - [4.5 Selective Execution](#4-selective-execution)

5. [Advanced Usage](#advanced-usage)
   - [5.1 Comprehensive Shell Script Examples](#comprehensive-shell-script-examples)
   - [5.2 Custom ECC Implementation](#custom-ecc-implementation)
   - [5.3 Custom Analysis](#custom-analysis)
   - [5.4 Batch Processing](#batch-processing)

6. [Output & Results](#output-files)
   - [6.1 Benchmark Results](#benchmark-results)
   - [6.2 Analysis Visualizations](#analysis-visualizations)
   - [6.3 Hardware Verification](#hardware-verification-1)
   - [6.4 Final Report](#final-report)
   - [6.5 Logs](#logs)
   - [6.6 Individual Testbench Execution](#individual-testbench-execution)

7. [Performance & Metrics](#performance-metrics)
   - [7.1 Primary Metrics](#primary-metrics)
   - [7.2 Timing Metrics](#timing-metrics)
   - [7.3 Hardware Metrics](#hardware-metrics)
   - [7.4 Performance Considerations](#performance-considerations)

8. [Framework Architecture](#framework-architecture)
   - [8.1 Core Modules](#core-modules)
   - [8.2 Data Flow](#data-flow)

9. [Use Cases](#use-cases-by-mode)

10. [Troubleshooting](#troubleshooting)
    - [10.1 Common Issues](#common-issues)
    - [10.2 Verilator Not Found](#verilator-not-found)
    - [10.3 Yosys Not Found](#yosys-not-found)
    - [10.4 Debug Mode](#debug-mode)

11. [Contributing](#contributing)

12. [Results Interpretation](#results-interpretation)

13. [License](#license)

14. [Support](#support)

## Features

### 🚀 **Comprehensive Benchmarking**
- **Multiple ECC Types**: Support for 11+ ECC schemes including Parity, Hamming SECDED, BCH, Reed-Solomon, CRC, Golay, LDPC, Turbo, Convolutional, Polar, and Repetition codes
- **Flexible Configuration**: Test different word lengths (4, 8, 16, 32 bits) and error patterns (single, double, burst, random)
- **Performance Metrics**: Success rates, correction rates, detection rates, code rates, timing analysis
- **Parallel Execution**: Multi-threaded and multi-processed benchmarking for faster results

### 📋 **Supported ECC Types**

The framework supports a comprehensive range of Error Correction Codes, each with specific characteristics and use cases:

#### **Basic ECC Codes**
| ECC Type | Class Name | Error Detection | Error Correction | Code Rate | Use Case |
|----------|------------|----------------|------------------|-----------|----------|
| **Parity** | `ParityECC` | Single-bit errors | None | High | Simple error detection |
| **Repetition** | `RepetitionECC` | Multiple-bit errors | Single-bit errors | Low | High reliability, simple implementation |
| **Hamming SECDED** | `HammingSECDEDECC` | Double-bit errors | Single-bit errors | Medium | Memory systems, moderate reliability |

#### **Advanced ECC Codes**
| ECC Type | Class Name | Error Detection | Error Correction | Code Rate | Use Case |
|----------|------------|----------------|------------------|-----------|----------|
| **BCH** | `BCHECC` | Multiple-bit errors | Multiple-bit errors | Medium-High | Storage systems, moderate complexity |
| **Reed-Solomon** | `ReedSolomonECC` | Burst errors | Burst errors | High | Communication systems, burst error handling |
| **CRC** | `CRCECC` | Multiple-bit errors | None (detection only) | Very High | Data integrity checking |
| **Golay** | `GolayECC` | Triple-bit errors | Double-bit errors | Medium | Aerospace, high reliability |

#### **Modern ECC Codes**
| ECC Type | Class Name | Error Detection | Error Correction | Code Rate | Use Case |
|----------|------------|----------------|------------------|-----------|----------|
| **LDPC** | `LDPCECC` | Multiple-bit errors | Multiple-bit errors | High | Modern communication, near-Shannon limit |
| **Turbo** | `TurboECC` | Multiple-bit errors | Multiple-bit errors | High | 3G/4G communications, iterative decoding |
| **Convolutional** | `ConvolutionalECC` | Multiple-bit errors | Multiple-bit errors | Medium-High | Wireless communications, streaming data |
| **Polar** | `PolarECC` | Multiple-bit errors | Multiple-bit errors | High | 5G communications, capacity-achieving |

#### **ECC Characteristics Comparison**

| Characteristic | Parity | Hamming | BCH | Reed-Solomon | LDPC | Turbo | Polar |
|----------------|--------|---------|-----|--------------|------|-------|-------|
| **Complexity** | Very Low | Low | Medium | Medium | High | High | Very High |
| **Latency** | Very Low | Low | Medium | Medium | High | High | Very High |
| **Power Efficiency** | Very High | High | Medium | Medium | Low | Low | Very Low |
| **Hardware Cost** | Very Low | Low | Medium | Medium | High | High | Very High |
| **Error Correction** | None | Single-bit | Multi-bit | Burst | Multi-bit | Multi-bit | Multi-bit |
| **Best Error Pattern** | Single | Single | Random | Burst | Random | Random | Random |

#### **Error Pattern Handling**

| ECC Type | Single-Bit | Double-Bit | Burst Errors | Random Errors |
|----------|------------|------------|--------------|---------------|
| **Parity** | ✅ Detect | ❌ | ❌ | ❌ |
| **Repetition** | ✅ Correct | ✅ Detect | ❌ | ❌ |
| **Hamming SECDED** | ✅ Correct | ✅ Detect | ❌ | ❌ |
| **BCH** | ✅ Correct | ✅ Correct | ✅ Detect | ✅ Correct |
| **Reed-Solomon** | ✅ Correct | ✅ Correct | ✅ Correct | ✅ Correct |
| **CRC** | ✅ Detect | ✅ Detect | ✅ Detect | ✅ Detect |
| **Golay** | ✅ Correct | ✅ Correct | ✅ Detect | ✅ Correct |
| **LDPC** | ✅ Correct | ✅ Correct | ✅ Correct | ✅ Correct |
| **Turbo** | ✅ Correct | ✅ Correct | ✅ Correct | ✅ Correct |
| **Convolutional** | ✅ Correct | ✅ Correct | ✅ Correct | ✅ Correct |
| **Polar** | ✅ Correct | ✅ Correct | ✅ Correct | ✅ Correct |

#### **Performance Trade-offs**

| ECC Type | Speed | Reliability | Efficiency | Implementation |
|----------|-------|-------------|------------|----------------|
| **Parity** | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Repetition** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Hamming** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **BCH** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **Reed-Solomon** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **CRC** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Golay** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **LDPC** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Turbo** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Convolutional** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **Polar** | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ |

#### **Application Recommendations**

| Application Domain | Recommended ECC | Reasoning |
|-------------------|-----------------|-----------|
| **Memory Systems** | Hamming SECDED | Good balance of reliability and complexity |
| **Storage Systems** | BCH, Reed-Solomon | Excellent burst error handling |
| **Communication** | LDPC, Turbo, Polar | Near-optimal performance for noisy channels |
| **Embedded Systems** | Parity, CRC | Low complexity, high efficiency |
| **High-Reliability** | Golay, LDPC | Maximum error correction capability |
| **High-Speed** | Parity, CRC | Minimal latency and overhead |
| **Wireless** | Convolutional, Turbo | Excellent for fading channels |
| **5G/6G** | Polar | Capacity-achieving codes |
| **Data Integrity** | CRC | Fast detection with minimal overhead |
| **Aerospace** | Golay, Reed-Solomon | High reliability requirements |

### 📊 **Advanced Analysis**
- **Statistical Analysis**: Performance rankings, trend analysis, statistical significance testing
- **Visualization**: Comprehensive charts and heatmaps showing performance across different configurations
- **Scenario-based Recommendations**: Best ECC for different use cases (high reliability, high efficiency, high speed, etc.)

### 🔧 **Hardware Verification**
- **Synthesis Support**: Yosys integration for hardware cost analysis
- **Testbench Validation**: Verilator integration for functional verification
- **Conditional Reporting**: Only shows hardware results when tools are available

### 📈 **Enhanced Reporting**
- **Data-Driven Reports**: Reports based on actual benchmark results
- **Conditional Sections**: Only includes sections when data is available
- **Multiple Formats**: JSON, CSV, and Markdown outputs

### ⚡ **Parallel Processing**
- **Threading**: I/O-bound operations with shared memory
- **Multiprocessing**: CPU-intensive operations with true parallelism
- **Chunked Processing**: Memory-efficient processing for large datasets
- **Auto-detection**: Optimal worker count based on system resources

## Quick Start

### 1. Basic Usage

Run the complete analysis pipeline:

```bash
# Run full analysis (default)
./run_all.sh

# Run only theoretical analysis
./run_all.sh -m theoretical

# Run only hardware implementation
./run_all.sh -m hardware

# Run hardware implementation without report generation
./run_all.sh -m hardware -s

# Run with verbose output
./run_all.sh -v -m full
```

### 2. Python Framework Usage

For direct Python framework usage:

```bash
cd src
python run_analysis.py
```

This will:
- Run benchmarks on all available ECC types
- Perform hardware verification (if tools are available)
- Generate comprehensive analysis and visualizations
- Create a detailed report

### 3. Custom Configuration

Create a custom configuration file (see `example_config.json`):

```json
{
  "ecc_types": ["ParityECC", "HammingSECDEDECC", "BCHECC"],
  "word_lengths": [8, 16],
  "error_patterns": ["single", "double"],
  "trials_per_config": 10000
}
```

Run with custom configuration:

```bash
python run_analysis.py --config ../example_config.json
```

### 4. Selective Execution

Run only specific parts of the pipeline:

```bash
# Run only benchmarking
python run_analysis.py --benchmark-only

# Run only hardware verification
python run_analysis.py --hardware-only

# Generate report from existing data
python run_analysis.py --report-only

# Skip hardware verification
python run_analysis.py --skip-hardware
```

### 5. Parallel Processing Options

The framework supports multiple parallel processing modes for optimal performance:

```bash
# Use multiprocessing for true parallelism (CPU-intensive workloads)
python run_analysis.py --use-processes --workers 8

# Use chunked processing for memory management
python run_analysis.py --chunked --workers 4

# Auto-detect optimal settings
python run_analysis.py --use-processes

# Specify exact number of workers
python run_analysis.py --workers 16

# Performance test different modes
python performance_test.py
```

### 6. Performance Testing and Demonstration

Test and demonstrate the parallel processing capabilities:

```bash
# Quick performance test (fast)
python quick_test.py

# Concurrent execution demo (visual)
python concurrent_demo.py

# Comprehensive performance analysis
python performance_test.py

# Scalability testing
python performance_test.py --scalability
```

### 7. Shell Script Integration

The `run_all.sh` script provides unified access to all framework features:

```bash
# Parallel processing examples
./run_all.sh --use-processes --workers 8
./run_all.sh --chunked --workers 4
./run_all.sh -p auto
./run_all.sh -m benchmark --use-processes

# Performance testing examples
./run_all.sh --performance-test
./run_all.sh --quick-test
./run_all.sh --concurrent-demo
./run_all.sh -m performance

# Analysis and reporting
./run_all.sh -m analysis
./run_all.sh -m benchmark
```

## Setup

### Linux/macOS
1. **Clone the repo**
2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   # or for advanced ECCs:
   pip install bchlib reedsolo pandas pytest pyldpc commpy seaborn matplotlib scipy psutil
   ```
3. **Install Verilator** (for hardware simulation):
   ```bash
   sudo apt-get install verilator
   ```
4. **Install Yosys** (for synthesis):
   ```bash
   sudo apt-get install yosys
   ```

### Windows (with WSL)
1. **Clone the repo**
2. **Run the Windows setup script:**
   - Double-click `run_windows.bat` or
   - Run `run_windows.ps1` in PowerShell

   This script will:
   - Check if WSL is installed
   - Create a Python virtual environment in WSL
   - Install required dependencies
   - Run the full ECC simulation and analysis

### Hardware Requirements

#### Optional Tools
- **Yosys**: For synthesis and area analysis
- **Verilator**: For testbench simulation and verification

#### Installation
```bash
# Ubuntu/Debian
sudo apt-get install yosys verilator

# macOS
brew install yosys verilator

# Windows
# Download from official websites or use WSL
```

## Usage Guide

### Execution Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `theoretical` | Python simulation + report generation | Algorithm development, performance comparison |
| `hardware` | Verilog synthesis + Verilator simulation + report | Hardware implementation verification |
| `full` | All modes (theoretical + hardware + report) | Complete framework validation |
| `performance` | Performance testing and parallel processing demo | Performance optimization |
| `benchmark` | ECC benchmarking only | Focused benchmarking |
| `analysis` | Analysis and report generation only | Report generation from existing data |
| `quick-test` | Quick performance test | Framework validation |
| `concurrent-demo` | Concurrent execution demonstration | Educational demonstration |

### Command Line Options

#### Shell Script Options (`run_all.sh`)

| Option | Long Form | Description |
|--------|-----------|-------------|
| `-m MODE` | `--mode MODE` | Execution mode: `theoretical`, `hardware`, `full`, `performance`, `benchmark`, `analysis`, `quick-test`, `concurrent-demo` |
| `-v` | `--verbose` | Enable verbose output |
| `-s` | `--skip-report` | Skip report generation (only applicable to hardware mode) |
| `-p MODE` | `--parallel MODE` | Parallel processing mode: `auto`, `threads`, `processes`, `chunked` |
| `-w N` | `--workers N` | Number of workers (auto-detect if not specified) |
| `--use-processes` | | Use multiprocessing for true parallelism |
| `--chunked` | | Use chunked processing for memory management |
| `--performance-test` | | Run performance testing and parallel processing demo |
| `--quick-test` | | Run quick performance test |
| `--concurrent-demo` | | Run concurrent execution demonstration |
| `-h` | `--help` | Show help message |

#### Python Script Options (`run_analysis.py`)

| Option | Description |
|--------|-------------|
| `--benchmark-only` | Run only benchmarking |
| `--hardware-only` | Run only hardware verification |
| `--report-only` | Generate report from existing data |
| `--skip-hardware` | Skip hardware verification |
| `--config FILE` | Use custom configuration file |
| `--output DIR` | Output directory for results |
| `--use-processes` | Use ProcessPoolExecutor instead of ThreadPoolExecutor |
| `--workers N` | Number of workers (auto-detect if not specified) |
| `--chunked` | Use chunked processing to manage memory better |
| `--memory-limit FLOAT` | Memory usage limit as fraction of total RAM |

### Configuration Options

#### Benchmark Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ecc_types` | List[str] | All available | ECC classes to test |
| `word_lengths` | List[int] | [4, 8, 16, 32] | Data word lengths to test |
| `error_patterns` | List[str] | ["single", "double", "burst", "random"] | Error injection patterns |
| `trials_per_config` | int | 10000 | Number of trials per configuration |
| `burst_length` | int | 3 | Length of burst errors |
| `random_error_prob` | float | 0.01 | Probability for random errors |
| `measure_timing` | bool | True | Enable timing measurements |
| `max_workers` | int | 4 | Number of parallel workers |

#### Error Patterns

- **`single`**: Single bit errors
- **`double`**: Double bit errors
- **`burst`**: Consecutive bit errors
- **`random`**: Random bit errors with specified probability

## Output Files

### Benchmark Results
- `benchmark_results.json`: Detailed benchmark data
- `benchmark_summary.json`: Summary statistics
- `benchmark_results.csv`: CSV format for external analysis

### Analysis Visualizations
- `ecc_performance_analysis.png`: Overall performance comparison
- `ecc_performance_heatmap.png`: Performance heatmap by error pattern
- `ecc_word_length_trends.png`: Performance trends vs word length

### Hardware Verification
- `hardware_verification.json`: Synthesis and testbench results

### Final Report
- `ecc_analysis_report.md`: Comprehensive analysis report

### Logs
- `results/run.log`: Complete execution log
- `results/*/simulation.log`: Individual testbench logs (hardware mode)

### Individual Testbench Execution
```bash
# List available testbenches
python3 src/verilate_single.py --list

# Run specific testbench
python3 src/verilate_single.py <testbench_name>
```

### Execution Plan and Logging

The shell script provides comprehensive execution planning and logging:

- **Execution Plan**: Shows mode, verbose settings, parallel processing options, and worker configuration
- **Section Headers**: Clear visual separation of different execution phases
- **Progress Tracking**: Real-time progress updates during execution
- **Comprehensive Logging**: All output is logged to `results/run.log`
- **Completion Summary**: Detailed summary of what was executed and where results are located
- **Debugging Information**: Individual testbench logs and debugging commands

## Performance Metrics

### Primary Metrics
- **Success Rate**: Percentage of successful error handling
- **Correction Rate**: Percentage of errors corrected
- **Detection Rate**: Percentage of errors detected
- **Code Rate**: Data efficiency (data bits / total bits)
- **Overhead Ratio**: Redundancy overhead

### Timing Metrics
- **Encode Time**: Time to encode data
- **Decode Time**: Time to decode and correct
- **Total Time**: Combined encoding and decoding time

### Hardware Metrics
- **Area (Cells)**: Synthesis area in logic cells
- **Relative Cost**: Cost relative to smallest implementation
- **Power Estimate**: Estimated power consumption

## Framework Architecture

### Core Modules

#### 1. **Benchmark Suite** (`benchmark_suite.py`)
- **Purpose**: Comprehensive ECC performance testing
- **Features**: 
  - Multi-threaded and multi-processed execution
  - Configurable test parameters
  - Multiple error injection patterns
  - Performance timing measurements

#### 2. **Enhanced Analysis** (`enhanced_analysis.py`)
- **Purpose**: Statistical analysis and visualization
- **Features**:
  - Performance rankings
  - Trend analysis
  - Statistical significance testing
  - Automated chart generation

#### 3. **Parallel Processing** (`run_analysis.py`)
- **Purpose**: High-performance execution with multiple parallel modes
- **Features**:
  - **Threading**: I/O-bound operations with shared memory
  - **Multiprocessing**: CPU-intensive operations with true parallelism
  - **Chunked Processing**: Memory-efficient processing for large datasets
  - **Auto-detection**: Optimal worker count based on system resources
  - **Progress Tracking**: Real-time progress monitoring

#### 4. **Hardware Verification** (`hardware_verification.py`)
- **Purpose**: Hardware implementation validation
- **Features**:
  - Yosys synthesis integration
  - Verilator testbench validation
  - Tool availability detection
  - Conditional result reporting

#### 5. **Report Generator** (`report_generator.py`)
- **Purpose**: Comprehensive report generation
- **Features**:
  - Data-driven content
  - Conditional sections
  - Multiple visualization formats
  - Professional formatting

#### 6. **Main Orchestrator** (`run_analysis.py`)
- **Purpose**: Pipeline coordination and CLI interface
- **Features**:
  - Command-line argument parsing
  - Pipeline orchestration
  - Error handling and recovery
  - Progress reporting

### Data Flow

```
1. Configuration → 2. Benchmarking → 3. Analysis → 4. Hardware Verification → 5. Report Generation
     ↓                    ↓              ↓              ↓                        ↓
   JSON Config    Benchmark Results   Analysis    Hardware Results        Final Report
                                    Results
```

## Advanced Usage

### Comprehensive Shell Script Examples

The `run_all.sh` script provides a unified interface for all framework operations:

```bash
# Basic operations
./run_all.sh                                    # Full analysis (default)
./run_all.sh -m theoretical                     # Theoretical analysis only
./run_all.sh -m hardware                        # Hardware analysis only
./run_all.sh -m hardware -s                     # Hardware without report

# Parallel processing
./run_all.sh --use-processes --workers 8        # Multiprocessing with 8 workers
./run_all.sh --chunked --workers 4              # Chunked processing
./run_all.sh -p auto                            # Auto-detect optimal settings
./run_all.sh -m benchmark --use-processes       # Benchmark with multiprocessing

# Performance testing
./run_all.sh --quick-test                       # Quick framework validation
./run_all.sh --concurrent-demo                  # Visual concurrent execution demo
./run_all.sh -m performance                     # Comprehensive performance analysis

# Analysis and reporting
./run_all.sh -m analysis                        # Generate report from existing data
./run_all.sh -m benchmark                       # Run benchmarks only

# Verbose and debugging
./run_all.sh -v -m full                         # Verbose full analysis
./run_all.sh --help                             # Show all options
```

### Custom ECC Implementation

To add a new ECC type:

1. Create a new ECC class inheriting from `ECCBase`:
```python
from .base_ecc import ECCBase
from typing import Tuple

class MyCustomECC(ECCBase):
    def encode(self, data: int) -> int:
        # Implementation
        pass
    
    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        # Implementation
        pass
```

2. Add to configuration:
```json
{
  "ecc_types": ["MyCustomECC"]
}
```

### Custom Analysis

Extend the analysis framework:

```python
from enhanced_analysis import ECCAnalyzer

analyzer = ECCAnalyzer(benchmark_results)
custom_analysis = analyzer.analyze_performance_rankings()
```

### Batch Processing

Process multiple configurations:

```bash
# Test different word lengths
for length in 8 16 32; do
    python run_analysis.py --config config_${length}.json --output results_${length}
done
```

## Use Cases by Mode

### Theoretical Mode
- Algorithm development and testing
- Performance comparison of different ECC codes
- Educational purposes
- Quick validation of ECC parameters

### Hardware Mode
- Hardware implementation verification
- Synthesis optimization
- Area and timing analysis
- FPGA/ASIC design validation

### Full Mode
- Complete ECC framework validation
- Research publications
- Comprehensive performance analysis
- Documentation generation

### Performance Mode
- Performance optimization
- Scalability testing
- Parallel processing evaluation
- System resource analysis

### Quick Test Mode
- Framework validation
- Quick functionality verification
- Development testing
- CI/CD integration

### Concurrent Demo Mode
- Educational demonstrations
- Parallel processing visualization
- Framework showcase
- Training and tutorials

## Performance Considerations

- **Theoretical mode**: Fastest execution, suitable for algorithm development
- **Hardware mode**: Moderate execution time, includes synthesis and simulation
- **Full mode**: Longest execution time, comprehensive analysis
- **Parallel processing**: Significantly faster execution for large datasets
- **Quick test mode**: Very fast execution for framework validation
- **Concurrent demo mode**: Fast execution with visual feedback

## Troubleshooting

### Common Issues

1. **Import Errors**
   - Ensure you're running from the `src` directory
   - Check that all ECC implementation files exist

2. **Missing Hardware Tools**
   - Framework will continue without hardware verification
   - Reports will indicate missing hardware data

3. **Memory Issues**
   - Reduce `trials_per_config` for large configurations
   - Use fewer `max_workers` for limited memory
   - Use `--chunked` option for memory management

4. **Long Execution Times**
   - Reduce number of ECC types or word lengths
   - Increase `max_workers` for faster execution
   - Use `--use-processes` for CPU-intensive workloads

5. **Shell Script Issues**
   - Ensure `run_all.sh` has execute permissions: `chmod +x run_all.sh`
   - Check that virtual environment is properly set up
   - Verify all Python dependencies are installed

### Verilator Not Found
If you see warnings about Verilator simulation being skipped:
```bash
# Install Verilator (Ubuntu/Debian)
sudo apt-get install verilator

# Install Verilator (macOS)
brew install verilator

# Install Verilator (Windows with WSL)
sudo apt-get install verilator
```

### Yosys Not Found
If synthesis fails:
```bash
# Install Yosys (Ubuntu/Debian)
sudo apt-get install yosys

# Install Yosys (macOS)
brew install yosys
```

### Debug Mode

Enable verbose output:

```bash
# Python script verbose mode
python run_analysis.py --debug

# Shell script verbose mode
./run_all.sh -v -m full
```

## Contributing

### Adding New ECC Types
1. Implement the ECC class following the `ECCBase` interface
2. Add appropriate parameters in `benchmark_suite.py`
3. Update documentation and examples

### Extending Analysis
1. Add new analysis methods to `ECCAnalyzer`
2. Update visualization functions
3. Extend report generation

### Improving Hardware Support
1. Add new synthesis tool integrations
2. Extend testbench validation
3. Improve error handling and reporting

## Results Interpretation
- Simulation and benchmark results are saved in `results/` as Markdown and plots.
- Compare error correction/detection rates and hardware cost for each ECC.
- Use the Markdown tables for publication or reporting.

## License

This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

You are free to:
- **Share** — copy and redistribute the material in any medium or format
- **Adapt** — remix, transform, and build upon the material for any purpose, even commercially

Under the following terms:
- **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made.

This framework is provided for educational and research purposes. Please ensure compliance with any applicable licenses for included ECC implementations and tools.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review the example configurations
3. Examine the source code documentation
4. Run with `--debug` for detailed error information

---

*ECC Analysis Framework v1.0 - Comprehensive benchmarking and analysis for Error Correction Codes*