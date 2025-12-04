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
from extended_hamming_ecc import ExtendedHammingECC
from cyclic_ecc import CyclicECC
from system_ecc import SystemECC
from reed_muller_ecc import ReedMullerECC
from fire_code_ecc import FireCodeECC
from product_code_ecc import ProductCodeECC
from concatenated_ecc import ConcatenatedECC
from composite_ecc import CompositeECC
from turbo_ecc import TurboECC
from spatially_coupled_ldpc_ecc import SpatiallyCoupledLDPCECC
from non_binary_ldpc_ecc import NonBinaryLDPCECC
from raptor_code_ecc import RaptorCodeECC
from bch_ecc import BCHECC
from reed_solomon_ecc import ReedSolomonECC
from repetition_ecc import RepetitionECC
from crc_ecc import CRCECC
from golay_ecc import GolayECC
from ldpc_ecc import LDPCECC
from polar_ecc import PolarECC
from adaptive_ecc import AdaptiveECC
from burst_error_ecc import BurstErrorECC
from three_d_memory_ecc import ThreeDMemoryECC
from primary_secondary_ecc import PrimarySecondaryECC
from convolutional_ecc import ConvolutionalECC


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
class SynthesisResult:
    """Results from synthesis verification."""
    module_name: str
    verilog_file: str
    synthesis_available: bool
    area_cells: Optional[int] = None
    timing_info: Optional[Dict[str, float]] = None
    power_estimate: Optional[float] = None
    error_message: Optional[str] = None


@dataclass
class HardwareVerificationSummary:
    """Complete hardware verification summary."""
    total_ecc_types: int
    passed_ecc_types: int
    failed_ecc_types: int
    ecc_summaries: Dict[str, ECCTestSummary]
    synthesis_results: Dict[str, SynthesisResult]
    verilator_available: bool
    yosys_available: bool
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
            "extended_hamming_ecc": {
                "verilog_file": "extended_hamming_ecc.v",
                "testbench_file": "extended_hamming_ecc_tb.c",
                "python_class": ExtendedHammingECC,
                "data_width": 8
            },
            "cyclic_ecc": {
                "verilog_file": "cyclic_ecc.v",
                "testbench_file": "cyclic_ecc_tb.c",
                "python_class": CyclicECC,
                "data_width": 8
            },
            "system_ecc": {
                "verilog_file": "system_ecc.v",
                "testbench_file": "system_ecc_tb.c",
                "python_class": SystemECC,
                "data_width": 8
            },
            "reed_muller_ecc": {
                "verilog_file": "reed_muller_ecc.v",
                "testbench_file": "reed_muller_ecc_tb.c",
                "python_class": ReedMullerECC,
                "data_width": 8
            },
            "fire_code_ecc": {
                "verilog_file": "fire_code_ecc.v",
                "testbench_file": "fire_code_ecc_tb.c",
                "python_class": FireCodeECC,
                "data_width": 8
            },
                                        "product_code_ecc": {
                                "verilog_file": "product_code_ecc.v",
                                "testbench_file": "product_code_ecc_tb.c",
                                "python_class": ProductCodeECC,
                                "data_width": 8
                            },
                            "concatenated_ecc": {
                                "verilog_file": "concatenated_ecc.v",
                                "testbench_file": "concatenated_ecc_tb.c",
                                "python_class": ConcatenatedECC,
                                "data_width": 8
                            },
                            "composite_ecc": {
                                "verilog_file": "composite_ecc.v",
                                "testbench_file": "composite_ecc_tb.c",
                                "python_class": CompositeECC,
                                "data_width": 8
                            },
                            "turbo_ecc": {
                                "verilog_file": "turbo_ecc.v",
                                "testbench_file": "turbo_ecc_tb.c",
                                "python_class": TurboECC,
                                "data_width": 8
                            },
                            "spatially_coupled_ldpc_ecc": {
                                "verilog_file": "spatially_coupled_ldpc_ecc.v",
                                "testbench_file": "spatially_coupled_ldpc_ecc_tb.c",
                                "python_class": SpatiallyCoupledLDPCECC,
                                "data_width": 8
                            },
                            "non_binary_ldpc_ecc": {
                                "verilog_file": "non_binary_ldpc_ecc.v",
                                "testbench_file": "non_binary_ldpc_ecc_tb.c",
                                "python_class": NonBinaryLDPCECC,
                                "data_width": 8
                            },
                            "raptor_code_ecc": {
                                "verilog_file": "raptor_code_ecc.v",
                                "testbench_file": "raptor_code_ecc_tb.c",
                                "python_class": RaptorCodeECC,
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
            },
            "adaptive_ecc": {
                "verilog_file": "adaptive_ecc.v",
                "testbench_file": "adaptive_ecc_tb.c",
                "python_class": AdaptiveECC,
                "data_width": 8
            },
            "burst_error_ecc": {
                "verilog_file": "burst_error_ecc.v",
                "testbench_file": "burst_error_ecc_tb.c",
                "python_class": BurstErrorECC,
                "data_width": 8
            },
            "three_d_memory_ecc": {
                "verilog_file": "three_d_memory_ecc.v",
                "testbench_file": "three_d_memory_ecc_tb.c",
                "python_class": ThreeDMemoryECC,
                "data_width": 8
            },
            "primary_secondary_ecc": {
                "verilog_file": "primary_secondary_ecc.v",
                "testbench_file": "primary_secondary_ecc_tb.c",
                "python_class": PrimarySecondaryECC,
                "data_width": 8
            },
            "convolutional_ecc": {
                "verilog_file": "convolutional_ecc.v",
                "testbench_file": "convolutional_ecc_tb.c",
                "python_class": ConvolutionalECC,
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

    def check_yosys(self) -> bool:
        """
        Check if Yosys is installed and available.
        
        Returns:
            bool: True if Yosys is available
        """
        if shutil.which("yosys") is None:
            if self.verbose:
                print("WARNING: Yosys is not installed or not in PATH.")
            return False
        
        if self.verbose:
            version = subprocess.run(["yosys", "--version"], 
                                   capture_output=True, text=True)
            print(f"Yosys found: {version.stdout.strip()}")
        
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

    def run_synthesis(self, ecc_type: str, config: Dict[str, Any]) -> SynthesisResult:
        """
        Run synthesis for a single ECC type using Yosys.
        
        Args:
            ecc_type: Name of the ECC type
            config: Configuration dictionary
            
        Returns:
            SynthesisResult: Synthesis results
        """
        verilog_file = self.verilogs_dir / config["verilog_file"]
        module_name = ecc_type
        
        if not verilog_file.exists():
            return SynthesisResult(
                module_name=module_name,
                verilog_file=str(verilog_file),
                synthesis_available=False,
                error_message="Verilog file not found"
            )
            
        try:
            # Create synthesis script
            script = f"""
            read_verilog {verilog_file}
            synth -top {module_name}
            stat
            """
            
            script_path = self.results_dir / f"{module_name}_synthesis.ys"
            with open(script_path, "w") as f:
                f.write(script)
            
            # Run Yosys
            result = subprocess.run(
                ["yosys", "-s", str(script_path)],
                capture_output=True,
                text=True,
                timeout=60
            )
            
            if result.returncode == 0:
                # Parse synthesis results
                area_cells = None
                timing_info = {}
                
                for line in result.stdout.splitlines():
                    line = line.strip()
                    if line.endswith(" cells"):
                        try:
                            # Format is usually "   27 cells"
                            parts = line.split()
                            if len(parts) >= 2 and parts[-1] == "cells":
                                area_cells = int(parts[-2])
                        except (ValueError, IndexError):
                            pass
                    elif "Critical path delay:" in line:
                        try:
                            delay = float(line.split(":")[1].strip().split()[0])
                            timing_info["critical_path_delay"] = delay
                        except (ValueError, IndexError):
                            pass
                            
                return SynthesisResult(
                    module_name=module_name,
                    verilog_file=str(verilog_file),
                    synthesis_available=True,
                    area_cells=area_cells,
                    timing_info=timing_info if timing_info else None
                )
            else:
                return SynthesisResult(
                    module_name=module_name,
                    verilog_file=str(verilog_file),
                    synthesis_available=False,
                    error_message=f"Synthesis failed: {result.stderr}"
                )
                
        except subprocess.TimeoutExpired:
            return SynthesisResult(
                module_name=module_name,
                verilog_file=str(verilog_file),
                synthesis_available=False,
                error_message="Synthesis timed out"
            )
        except Exception as e:
            return SynthesisResult(
                module_name=module_name,
                verilog_file=str(verilog_file),
                synthesis_available=False,
                error_message=f"Synthesis error: {str(e)}"
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
                synthesis_results={},
                verilator_available=False,
                yosys_available=False,
                execution_time=0.0,
                overall_status="FAIL"
            )
            
        # Check Yosys availability
        yosys_available = self.check_yosys()
        
        start_time = time.time()
        ecc_summaries = {}
        synthesis_results = {}
        passed_ecc_types = 0
        failed_ecc_types = 0
        
        print(f"Testing {len(self.ecc_configs)} ECC types...")
        print()
        
        for i, (ecc_type, config) in enumerate(self.ecc_configs.items(), 1):
            print(f"[{i}/{len(self.ecc_configs)}] Testing {ecc_type}...")
            
            # Run verification test
            summary = self.run_test(ecc_type, config)
            ecc_summaries[ecc_type] = summary
            
            # Run synthesis if available
            if yosys_available:
                if self.verbose:
                    print(f"  Running synthesis for {ecc_type}...")
                synth_result = self.run_synthesis(ecc_type, config)
                synthesis_results[ecc_type] = synth_result
                if self.verbose and synth_result.synthesis_available:
                    print(f"  Synthesis successful: {synth_result.area_cells} cells")
            
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
            synthesis_results=synthesis_results,
            verilator_available=verilator_available,
            yosys_available=yosys_available,
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
            "yosys_available": summary.yosys_available,
            "execution_time": summary.execution_time,
            "overall_status": summary.overall_status,
            "ecc_results": {},
            "synthesis_results": {}
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
            
        for ecc_type, synth_result in summary.synthesis_results.items():
            results["synthesis_results"][ecc_type] = {
                "module_name": synth_result.module_name,
                "verilog_file": synth_result.verilog_file,
                "synthesis_available": synth_result.synthesis_available,
                "area_cells": synth_result.area_cells,
                "timing_info": synth_result.timing_info,
                "power_estimate": synth_result.power_estimate,
                "error_message": synth_result.error_message
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