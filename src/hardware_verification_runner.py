"""
Hardware Verification Runner

This module provides comprehensive hardware verification capabilities including:
- C testbench compilation with Verilator
- ECC algorithm verification against Python implementations
- PASS/FAIL result reporting
- Integration with the main ECC framework
"""

import subprocess
import sys
import os
import json
import time
from pathlib import Path
from typing import Dict, List, Tuple, Optional, Any
from dataclasses import dataclass
import shutil

# Add src directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from base_ecc import ECCBase
from parity_ecc import ParityECC
from hamming_secded_ecc import HammingSECDEDECC
from bch_ecc import BCHECC
from reed_solomon_ecc import ReedSolomonECC
from repetition_ecc import RepetitionECC
from crc_ecc import CRCECC
from golay_ecc import GolayECC
from ldpc_ecc import LDPCECC
from polar_ecc import PolarECC


@dataclass
class TestResult:
    """Results from a single ECC test."""
    ecc_type: str
    test_name: str
    passed: bool
    expected: Any
    actual: Any
    error_message: Optional[str] = None
    execution_time: Optional[float] = None


@dataclass
class ECCTestSummary:
    """Summary of tests for a single ECC type."""
    ecc_type: str
    total_tests: int
    passed_tests: int
    failed_tests: int
    test_results: List[TestResult]
    overall_status: str  # "PASS" or "FAIL"


@dataclass
class HardwareVerificationSummary:
    """Complete hardware verification summary."""
    total_ecc_types: int
    passed_ecc_types: int
    failed_ecc_types: int
    ecc_summaries: Dict[str, ECCTestSummary]
    verilator_available: bool
    execution_time: float
    overall_status: str  # "PASS" or "FAIL"


class HardwareVerificationRunner:
    """Main class for running hardware verification tests."""
    
    def __init__(self, verbose: bool = False):
        """
        Initialize the hardware verification runner.
        
        Args:
            verbose: Enable verbose output
        """
        self.verbose = verbose
        self.verilogs_dir = Path(__file__).parent.parent / "verilogs"
        self.testbenches_dir = Path(__file__).parent.parent / "testbenches"
        self.results_dir = Path(__file__).parent.parent / "results"
        self.results_dir.mkdir(exist_ok=True)
        
        # Define ECC configurations
        self.ecc_configs = {
            "parity_ecc": {
                "verilog_file": "parity_ecc.v",
                "testbench_file": "parity_ecc_tb.c",
                "python_class": ParityECC,
                "data_width": 8
            },
            "hamming_secded_ecc": {
                "verilog_file": "hamming_secded_ecc.v",
                "testbench_file": "hamming_secded_ecc_tb.c",
                "python_class": HammingSECDEDECC,
                "data_width": 8
            },
            "bch_ecc": {
                "verilog_file": "bch_ecc.v",
                "testbench_file": "bch_ecc_tb.c",
                "python_class": BCHECC,
                "data_width": 8
            },
            "reed_solomon_ecc": {
                "verilog_file": "reed_solomon_ecc.v",
                "testbench_file": "reed_solomon_ecc_tb.c",
                "python_class": ReedSolomonECC,
                "data_width": 8
            },
            "repetition_ecc": {
                "verilog_file": "repetition_ecc.v",
                "testbench_file": "repetition_ecc_tb.c",
                "python_class": RepetitionECC,
                "data_width": 8
            },
            "crc_ecc": {
                "verilog_file": "crc_ecc.v",
                "testbench_file": "crc_ecc_tb.c",
                "python_class": CRCECC,
                "data_width": 8
            },
            "golay_ecc": {
                "verilog_file": "golay_ecc.v",
                "testbench_file": "golay_ecc_tb.c",
                "python_class": GolayECC,
                "data_width": 8
            },
            "ldpc_ecc": {
                "verilog_file": "ldpc_ecc.v",
                "testbench_file": "ldpc_ecc_tb.c",
                "python_class": LDPCECC,
                "data_width": 8
            },
            "polar_ecc": {
                "verilog_file": "polar_ecc.v",
                "testbench_file": "polar_ecc_tb.c",
                "python_class": PolarECC,
                "data_width": 8
            }
        }
    
    def check_verilator(self) -> bool:
        """
        Check if Verilator is installed and available.
        
        Returns:
            bool: True if Verilator is available
        """
        if shutil.which("verilator") is None:
            print("ERROR: Verilator is not installed or not in PATH.")
            print("To install Verilator:")
            print("  Ubuntu/Debian: sudo apt-get install verilator")
            print("  macOS: brew install verilator")
            print("  Windows (WSL): sudo apt-get install verilator")
            return False
        
        if self.verbose:
            version = subprocess.run(["verilator", "--version"], 
                                   capture_output=True, text=True)
            print(f"Verilator found: {version.stdout.strip()}")
        
        return True
    
    def compile_test(self, ecc_type: str, config: Dict[str, Any]) -> bool:
        """
        Compile a single ECC test with Verilator.
        
        Args:
            ecc_type: Name of the ECC type
            config: Configuration dictionary
            
        Returns:
            bool: True if compilation successful
        """
        verilog_file = self.verilogs_dir / config["verilog_file"]
        testbench_file = self.testbenches_dir / config["testbench_file"]
        
        if not verilog_file.exists():
            print(f"ERROR: Verilog file not found: {verilog_file}")
            return False
        
        if not testbench_file.exists():
            print(f"ERROR: Testbench file not found: {testbench_file}")
            return False
        
        # Create build directory under results
        build_dir = Path("results/build")
        build_dir.mkdir(exist_ok=True, parents=True)
        
        # Compile with Verilator
        cmd = [
            "verilator", "--cc", "--exe", "--build", "-j", "0",
            "-CFLAGS", "-I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd",
            str(verilog_file), str(testbench_file),
            "-o", ecc_type,
            "--Mdir", str(build_dir / "obj_dir")
        ]
        
        if self.verbose:
            print(f"Compiling {ecc_type}...")
            print(f"Command: {' '.join(cmd)}")
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
            
            if result.returncode != 0:
                print(f"Compilation failed for {ecc_type}:")
                print(result.stderr)
                return False
            
            if self.verbose:
                print(f"Compilation successful for {ecc_type}")
            
            return True
            
        except subprocess.TimeoutExpired:
            print(f"Compilation timeout for {ecc_type}")
            return False
        except Exception as e:
            print(f"Compilation error for {ecc_type}: {e}")
            return False
    
    def run_test(self, ecc_type: str, config: Dict[str, Any]) -> ECCTestSummary:
        """
        Run tests for a single ECC type.
        
        Args:
            ecc_type: Name of the ECC type
            config: Configuration dictionary
            
        Returns:
            ECCTestSummary: Test results summary
        """
        test_results = []
        total_tests = 0
        passed_tests = 0
        failed_tests = 0
        
        # First compile the test
        if not self.compile_test(ecc_type, config):
            return ECCTestSummary(
                ecc_type=ecc_type,
                total_tests=0,
                passed_tests=0,
                failed_tests=1,
                test_results=[],
                overall_status="FAIL"
            )
        
        # Run the compiled test
        executable = Path("results/build/obj_dir") / ecc_type
        
        if not executable.exists():
            print(f"ERROR: Executable not found: {executable}")
            return ECCTestSummary(
                ecc_type=ecc_type,
                total_tests=0,
                passed_tests=0,
                failed_tests=1,
                test_results=[],
                overall_status="FAIL"
            )
        
        try:
            start_time = time.time()
            result = subprocess.run([str(executable)], capture_output=True, text=True, timeout=30)
            execution_time = time.time() - start_time
            
            # Parse the output to determine PASS/FAIL
            output = result.stdout + result.stderr
            
            if "RESULT: PASS" in output:
                overall_status = "PASS"
                passed_tests = 1
                total_tests = 1
            elif "RESULT: FAIL" in output:
                overall_status = "FAIL"
                failed_tests = 1
                total_tests = 1
            else:
                overall_status = "FAIL"
                failed_tests = 1
                total_tests = 1
            
            test_results.append(TestResult(
                ecc_type=ecc_type,
                test_name="hardware_verification",
                passed=(overall_status == "PASS"),
                expected="PASS",
                actual=overall_status,
                execution_time=execution_time
            ))
            
            if self.verbose:
                print(f"Test output for {ecc_type}:")
                print(output)
            
        except subprocess.TimeoutExpired:
            print(f"Test timeout for {ecc_type}")
            overall_status = "FAIL"
            failed_tests = 1
            total_tests = 1
            test_results.append(TestResult(
                ecc_type=ecc_type,
                test_name="hardware_verification",
                passed=False,
                expected="PASS",
                actual="TIMEOUT",
                error_message="Test execution timeout"
            ))
        except Exception as e:
            print(f"Test error for {ecc_type}: {e}")
            overall_status = "FAIL"
            failed_tests = 1
            total_tests = 1
            test_results.append(TestResult(
                ecc_type=ecc_type,
                test_name="hardware_verification",
                passed=False,
                expected="PASS",
                actual="ERROR",
                error_message=str(e)
            ))
        
        return ECCTestSummary(
            ecc_type=ecc_type,
            total_tests=total_tests,
            passed_tests=passed_tests,
            failed_tests=failed_tests,
            test_results=test_results,
            overall_status=overall_status
        )
    
    def run_all_tests(self) -> HardwareVerificationSummary:
        """
        Run all hardware verification tests.
        
        Returns:
            HardwareVerificationSummary: Complete test summary
        """
        print("=== ECC Hardware Verification Test Suite ===")
        
        # Check Verilator availability
        verilator_available = self.check_verilator()
        if not verilator_available:
            return HardwareVerificationSummary(
                total_ecc_types=0,
                passed_ecc_types=0,
                failed_ecc_types=1,
                ecc_summaries={},
                verilator_available=False,
                execution_time=0.0,
                overall_status="FAIL"
            )
        
        start_time = time.time()
        ecc_summaries = {}
        passed_ecc_types = 0
        failed_ecc_types = 0
        
        print(f"Testing {len(self.ecc_configs)} ECC types...")
        print()
        
        for i, (ecc_type, config) in enumerate(self.ecc_configs.items(), 1):
            print(f"[{i}/{len(self.ecc_configs)}] Testing {ecc_type}...")
            
            summary = self.run_test(ecc_type, config)
            ecc_summaries[ecc_type] = summary
            
            if summary.overall_status == "PASS":
                passed_ecc_types += 1
                print(f"  ✅ {ecc_type}: PASS")
            else:
                failed_ecc_types += 1
                print(f"  ❌ {ecc_type}: FAIL")
            
            print()
        
        execution_time = time.time() - start_time
        
        # Print summary
        print("=== Test Summary ===")
        print(f"Total ECC types: {len(self.ecc_configs)}")
        print(f"Passed: {passed_ecc_types}")
        print(f"Failed: {failed_ecc_types}")
        
        overall_status = "PASS" if failed_ecc_types == 0 else "FAIL"
        
        if overall_status == "PASS":
            print("RESULT: ALL TESTS PASSED")
        else:
            print("RESULT: SOME TESTS FAILED")
        
        return HardwareVerificationSummary(
            total_ecc_types=len(self.ecc_configs),
            passed_ecc_types=passed_ecc_types,
            failed_ecc_types=failed_ecc_types,
            ecc_summaries=ecc_summaries,
            verilator_available=verilator_available,
            execution_time=execution_time,
            overall_status=overall_status
        )
    
    def save_results(self, summary: HardwareVerificationSummary, 
                    output_file: str = "hardware_verification_results.json") -> None:
        """
        Save verification results to JSON file.
        
        Args:
            summary: Hardware verification summary
            output_file: Output file name
        """
        output_path = self.results_dir / output_file
        
        # Convert to JSON-serializable format
        results = {
            "timestamp": time.time(),
            "total_ecc_types": summary.total_ecc_types,
            "passed_ecc_types": summary.passed_ecc_types,
            "failed_ecc_types": summary.failed_ecc_types,
            "verilator_available": summary.verilator_available,
            "execution_time": summary.execution_time,
            "overall_status": summary.overall_status,
            "ecc_results": {}
        }
        
        for ecc_type, ecc_summary in summary.ecc_summaries.items():
            results["ecc_results"][ecc_type] = {
                "total_tests": ecc_summary.total_tests,
                "passed_tests": ecc_summary.passed_tests,
                "failed_tests": ecc_summary.failed_tests,
                "overall_status": ecc_summary.overall_status,
                "test_results": [
                    {
                        "test_name": tr.test_name,
                        "passed": tr.passed,
                        "expected": str(tr.expected),
                        "actual": str(tr.actual),
                        "error_message": tr.error_message,
                        "execution_time": tr.execution_time
                    }
                    for tr in ecc_summary.test_results
                ]
            }
        
        with open(output_path, 'w') as f:
            json.dump(results, f, indent=2)
        
        print(f"Results saved to: {output_path}")


def main(verbose: bool = False) -> int:
    """
    Main function to run hardware verification tests.
    
    Args:
        verbose: Enable verbose output
        
    Returns:
        int: Exit code (0 for success, 1 for failure)
    """
    runner = HardwareVerificationRunner(verbose=verbose)
    summary = runner.run_all_tests()
    
    # Save results
    runner.save_results(summary)
    
    # Return appropriate exit code
    return 0 if summary.overall_status == "PASS" else 1


if __name__ == "__main__":
    verbose = "--verbose" in sys.argv or "-v" in sys.argv
    exit_code = main(verbose=verbose)
    sys.exit(exit_code) 