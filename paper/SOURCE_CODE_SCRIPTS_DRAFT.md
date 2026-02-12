# Source Code and Scripts

## Draft for IEEE Data Descriptor Paper

---

All Verilog source code, testbenches, and analysis scripts are publicly available on GitHub at [https://github.com/SJTU-YONGFU-RESEARCH-GRP/core-cc](https://github.com/SJTU-YONGFU-RESEARCH-GRP/core-cc). The repository's `verilogs/` directory houses the Verilog hardware modules (`.v`), while the corresponding C++ testbenches (`_tb.cpp`) are located in the `testbenches/` directory. The root directory contains a master shell script, `run_all.sh`, and a `src/` directory containing the Python scripts that automate the data processing workflows.

The `run_all.sh` script orchestrates the entire workflow. It triggers `src/benchmark_suite.py` for functional benchmarking and `src/enhanced_analysis.py` for statistical analysis and reporting. Hardware validation is automated by `src/hardware_verification_runner.py`, which co-simulates Verilog modules against Python references using Verilator. Finally, `src/synthesize_all.py` employs Yosys to extract hardware metrics like gate counts.

The development and validation process relied on specific versions of third-party software to ensure reproducibility. The hardware simulation and synthesis were performed using Verilator 5.020 and Yosys 0.57+148, respectively. The C++ testbenches were compiled using GCC 13.3.0, and the automation scripts were executed with Python 3.12.3. Version control was managed using Git 2.43.0.
