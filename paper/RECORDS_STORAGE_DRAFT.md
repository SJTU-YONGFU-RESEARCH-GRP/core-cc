# Records and Storage

The ECC Analysis Framework dataset and codebase are organized to maximize transparency, reproducibility, and ease of reuse. The project directory contains all source code, hardware descriptions, testbenches, configuration files, results, and documentation required for comprehensive error correction code (ECC) benchmarking and analysis. This section details the structure, content, and interrelationships of all files and directories, enabling users to efficiently navigate and utilize the resource.

## Overall Directory Structure and Rationale

The project is structured as shown in Table 1.

**Source code and hardware descriptions** are separated into `src/` (Python) and `verilogs/` (Verilog) to clearly distinguish between software and hardware implementations. `testbenches/` contains C programs for automated hardware verification, ensuring that all hardware modules are systematically tested against reference software models.

**Results and output data** are consolidated in the `results/` directory, which includes all benchmark outputs, logs, and analysis artifacts. This separation ensures that raw data, processed results, and logs are easily accessible and do not interfere with source code or configuration files.

**Documentation** is provided in the `docs/` directory and the `README.md` file, offering comprehensive guidance for users, including tutorials, background information, and references to relevant literature.

**Configuration and reproducibility** are supported by the `example_config.json` file, which serves as a template for specifying test parameters, ECC types, and benchmarking options. The `requirements.txt` file lists all Python dependencies, ensuring that the software environment can be easily recreated. The `run_all.sh` script automates the entire workflow, from data generation to analysis, supporting full reproducibility.

**Table 1: Top-Level File and Folder Inventory for the ECC Analysis Framework**

| File/Folder | Description | Type | Role | File Format(s) |
| :--- | :--- | :--- | :--- | :--- |
| `src/` | Python ECC algorithms, analysis scripts, and utilities for data generation and processing. | Directory | Core software for ECC simulation and benchmarking. | `.py` |
| `verilogs/` | Verilog hardware ECC modules for synthesis and hardware verification. | Directory | Enables hardware-level testing and comparison. | `.v` |
| `testbenches/` | C testbenches for automated hardware verification using Verilator. | Directory | Ensures hardware correctness and consistency with software models. | `.cpp` |
| `results/` | All output data, logs, and analysis results from framework runs. | Directory | Central repository for all generated data and results. | `.json`, `.csv`, `.png`, `.md` |
| `docs/` | Documentation, tutorials, and background references. | Directory | Supports user onboarding and reproducibility. | `.md` |
| `example_config.json` | Example configuration file for specifying test parameters. | JSON | Template for reproducible experiments. | `.json` |
| `requirements.txt` | Python dependency list for environment setup. | TXT | Ensures consistent software environment. | `.txt` |
| `run_all.sh` | Master script to automate all tests and analyses. | Bash | Enables full reproducibility of results. | Shell Script |
| `README.md` | Project overview, usage instructions, and support information. | Markdown | Entry point for new users and reviewers. | `.md` |

## Results Directory: Structure and Content

The `results/` directory is the central repository for all output data, organized to facilitate both human inspection and programmatic access. Key files and subdirectories include:

```
results/
├── benchmark_results.json           # Comprehensive benchmark data (JSON)
├── benchmark_results.csv            # Tabular benchmark data (CSV)
├── hardware_verification_results.json # Hardware verification results (JSON)
├── run.log                         # Execution log (TXT)
├── analysis_results.json            # Analysis and visualization data (JSON)
├── [various *_synthesis.ys]         # Yosys synthesis scripts (text)
├── benchmarks/                      # Individual benchmark files (JSON)
├── [various *_tb/]                  # Testbench outputs (directories)
└── *.png, *.md                      # Visualizations, reports
```

**Benchmark results** are provided in both JSON and CSV formats for flexibility. The JSON file (`benchmark_results.json`) contains structured records for each ECC type, word length, and error pattern, while the CSV file (`benchmark_results.csv`) enables easy import into external analysis tools.

**Hardware verification results** (`hardware_verification_results.json`) document the outcome of automated hardware tests, including pass/fail status for each ECC module and error pattern.

**Logs and analysis outputs** (`run.log`, `analysis_results.json`, PNG/MD files) provide detailed records of all test runs, error messages, and performance visualizations, supporting both debugging and in-depth analysis.

**Testbench outputs** and **Yosys synthesis scripts** are included for users interested in hardware synthesis and low-level verification.
