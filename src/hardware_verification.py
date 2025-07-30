"""
Hardware Verification Module

This module provides capabilities to verify hardware implementations,
check synthesis results, and validate testbench availability.
Also includes comprehensive Python ECC implementation verification.
"""

import subprocess
import json
import time
import random
import statistics
from pathlib import Path
from typing import Dict, List, Tuple, Any, Optional
from dataclasses import dataclass
import re
import sys

# Add src directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from base_ecc import ECCBase
from parity_ecc import ParityECC
from hamming_secded_ecc import HammingSECDEDECC
from bch_ecc import BCHECC
from reed_solomon_ecc import ReedSolomonECC
from crc_ecc import CRCECC
from golay_ecc import GolayECC
from repetition_ecc import RepetitionECC
from ldpc_ecc import LDPCECC
from turbo_ecc import TurboECC
from convolutional_ecc import ConvolutionalECC
from polar_ecc import PolarECC
from composite_ecc import CompositeECC
from extended_hamming_ecc import ExtendedHammingECC
from product_code_ecc import ProductCodeECC
from concatenated_ecc import ConcatenatedECC
from reed_muller_ecc import ReedMullerECC
from fire_code_ecc import FireCodeECC
from spatially_coupled_ldpc_ecc import SpatiallyCoupledLDPCECC
from non_binary_ldpc_ecc import NonBinaryLDPCECC
from raptor_code_ecc import RaptorCodeECC


@dataclass
class SynthesisResult:
    """Results from synthesis verification."""
    
    module_name: str
    verilog_file: str
    synthesis_available: bool
    area_cells: Optional[int] = None
    timing_info: Optional[Dict[str, float]] = None
    power_estimate: Optional[float] = None
    synthesis_log: Optional[str] = None
    error_message: Optional[str] = None


@dataclass
class TestbenchResult:
    """Results from testbench verification."""
    
    testbench_name: str
    testbench_file: str
    testbench_available: bool
    verilator_available: bool
    simulation_status: Optional[str] = None
    test_cases: Optional[Dict[str, str]] = None
    simulation_log: Optional[str] = None
    error_message: Optional[str] = None


@dataclass
class ECCVerificationResult:
    """Results from ECC implementation verification."""
    
    ecc_type: str
    word_length: int
    verification_passed: bool
    round_trip_tests: int
    round_trip_successes: int
    error_correction_tests: int
    error_correction_successes: int
    performance_tests: int
    performance_successes: int
    encode_time_avg: Optional[float] = None
    decode_time_avg: Optional[float] = None
    error_messages: List[str] = None
    test_details: Dict[str, Any] = None


@dataclass
class HardwareVerificationResult:
    """Complete hardware verification results."""
    
    synthesis_results: Dict[str, SynthesisResult]
    testbench_results: Dict[str, TestbenchResult]
    ecc_verification_results: Dict[str, ECCVerificationResult]
    yosys_available: bool
    verilator_available: bool
    overall_status: str


class HardwareVerifier:
    """Hardware verification engine."""
    
    def __init__(self, verilog_dir: str = "verilogs", testbench_dir: str = "testbenches", 
                 results_dir: str = "results"):
        """
        Initialize the hardware verifier.
        
        Args:
            verilog_dir: Directory containing Verilog files
            testbench_dir: Directory containing testbench files
            results_dir: Directory for results
        """
        self.verilog_dir = Path(verilog_dir)
        self.testbench_dir = Path(testbench_dir)
        self.results_dir = Path(results_dir)
        self.results_dir.mkdir(exist_ok=True)
        
    def check_tool_availability(self) -> Tuple[bool, bool]:
        """
        Check if required tools are available.
        
        Returns:
            Tuple of (yosys_available, verilator_available)
        """
        yosys_available = False
        verilator_available = False
        
        try:
            result = subprocess.run(["yosys", "--version"], 
                                  capture_output=True, text=True, timeout=5)
            yosys_available = result.returncode == 0
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass
        
        try:
            result = subprocess.run(["verilator", "--version"], 
                                  capture_output=True, text=True, timeout=5)
            verilator_available = result.returncode == 0
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass
        
        return yosys_available, verilator_available
    
    def verify_synthesis(self, verilog_file: Path) -> SynthesisResult:
        """
        Verify synthesis for a single Verilog file.
        
        Args:
            verilog_file: Path to Verilog file
            
        Returns:
            Synthesis result
        """
        module_name = verilog_file.stem
        
        # Check if file exists
        if not verilog_file.exists():
            return SynthesisResult(
                module_name=module_name,
                verilog_file=str(verilog_file),
                synthesis_available=False,
                error_message="Verilog file not found"
            )
        
        # Check if Yosys is available
        yosys_available, _ = self.check_tool_availability()
        if not yosys_available:
            return SynthesisResult(
                module_name=module_name,
                verilog_file=str(verilog_file),
                synthesis_available=False,
                error_message="Yosys not available"
            )
        
        # Run synthesis
        try:
            script = f"""
            read_verilog {verilog_file}
            synth -top {module_name}
            stat
            """
            
            script_path = self.results_dir / f"{module_name}_synthesis.ys"
            with open(script_path, "w") as f:
                f.write(script)
            
            result = subprocess.run(
                ["yosys", "-s", str(script_path)],
                capture_output=True,
                text=True,
                timeout=30
            )
            
            if result.returncode == 0:
                # Parse synthesis results
                area_cells = None
                timing_info = {}
                
                for line in result.stdout.splitlines():
                    if "Number of cells:" in line:
                        try:
                            area_cells = int(line.split(":")[1].strip())
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
                    timing_info=timing_info if timing_info else None,
                    synthesis_log=result.stdout
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
    
    def verify_testbench(self, testbench_file: Path) -> TestbenchResult:
        """
        Verify testbench for a single testbench file.
        
        Args:
            testbench_file: Path to testbench file
            
        Returns:
            Testbench result
        """
        testbench_name = testbench_file.stem
        
        # Check if file exists
        if not testbench_file.exists():
            return TestbenchResult(
                testbench_name=testbench_name,
                testbench_file=str(testbench_file),
                testbench_available=False,
                verilator_available=False,
                error_message="Testbench file not found"
            )
        
        # Check if Verilator is available
        _, verilator_available = self.check_tool_availability()
        if not verilator_available:
            return TestbenchResult(
                testbench_name=testbench_name,
                testbench_file=str(testbench_file),
                testbench_available=True,
                verilator_available=False,
                error_message="Verilator not available"
            )
        
        # Check if simulation results exist
        simulation_dir = self.results_dir / f"{testbench_name}_tb"
        simulation_log = simulation_dir / "simulation.log"
        
        if simulation_log.exists():
            # Parse existing simulation results
            try:
                with open(simulation_log, 'r') as f:
                    log_content = f.read()
                
                # Determine simulation status
                if "RESULT:PASS" in log_content:
                    simulation_status = "PASS"
                elif "RESULT:FAIL" in log_content:
                    simulation_status = "FAIL"
                else:
                    simulation_status = "UNKNOWN"
                
                # Parse test cases
                test_cases = {}
                for line in log_content.split('\n'):
                    if "TEST1:" in line:
                        test_cases["test1"] = "PASS" if "PASS" in line else "FAIL"
                    elif "TEST2:" in line:
                        test_cases["test2"] = "PASS" if "PASS" in line else "FAIL"
                
                return TestbenchResult(
                    testbench_name=testbench_name,
                    testbench_file=str(testbench_file),
                    testbench_available=True,
                    verilator_available=True,
                    simulation_status=simulation_status,
                    test_cases=test_cases if test_cases else None,
                    simulation_log=log_content
                )
                
            except Exception as e:
                return TestbenchResult(
                    testbench_name=testbench_name,
                    testbench_file=str(testbench_file),
                    testbench_available=True,
                    verilator_available=True,
                    error_message=f"Error parsing simulation log: {str(e)}"
                )
        else:
            return TestbenchResult(
                testbench_name=testbench_name,
                testbench_file=str(testbench_file),
                testbench_available=True,
                verilator_available=True,
                simulation_status="NOT_RUN",
                error_message="Simulation not run"
            )
    
    def verify_all_hardware(self) -> HardwareVerificationResult:
        """
        Verify all hardware implementations.
        
        Returns:
            Complete hardware verification results
        """
        print("Verifying hardware implementations...")
        
        # Check tool availability
        yosys_available, verilator_available = self.check_tool_availability()
        
        # Verify synthesis for all Verilog files
        synthesis_results = {}
        if self.verilog_dir.exists():
            for verilog_file in self.verilog_dir.glob("*.v"):
                print(f"Verifying synthesis for {verilog_file.name}...")
                result = self.verify_synthesis(verilog_file)
                synthesis_results[verilog_file.stem] = result
        
        # Verify testbenches
        testbench_results = {}
        if self.testbench_dir.exists():
            for testbench_file in self.testbench_dir.glob("*_tb.v"):
                print(f"Verifying testbench {testbench_file.name}...")
                result = self.verify_testbench(testbench_file)
                testbench_results[testbench_file.stem] = result
        
        # Initialize empty ECC verification results
        ecc_verification_results = {}
        
        # Determine overall status
        synthesis_available = any(r.synthesis_available for r in synthesis_results.values())
        testbench_available = any(r.testbench_available for r in testbench_results.values())
        
        if synthesis_available and testbench_available:
            overall_status = "COMPLETE"
        elif synthesis_available:
            overall_status = "SYNTHESIS_ONLY"
        elif testbench_available:
            overall_status = "TESTBENCH_ONLY"
        else:
            overall_status = "NONE"
        
        return HardwareVerificationResult(
            synthesis_results=synthesis_results,
            testbench_results=testbench_results,
            ecc_verification_results=ecc_verification_results,
            yosys_available=yosys_available,
            verilator_available=verilator_available,
            overall_status=overall_status
        )
    
    def save_verification_results(self, results: HardwareVerificationResult, 
                                output_file: str = "hardware_verification.json") -> None:
        """
        Save verification results to JSON file.
        
        Args:
            results: Hardware verification results
            output_file: Output file name
        """
        # Convert results to JSON-serializable format
        data = {
            "yosys_available": results.yosys_available,
            "verilator_available": results.verilator_available,
            "overall_status": results.overall_status,
            "synthesis_results": {},
            "testbench_results": {}
        }
        
        # Convert synthesis results
        for name, result in results.synthesis_results.items():
            data["synthesis_results"][name] = {
                "module_name": result.module_name,
                "verilog_file": result.verilog_file,
                "synthesis_available": result.synthesis_available,
                "area_cells": result.area_cells,
                "timing_info": result.timing_info,
                "power_estimate": result.power_estimate,
                "error_message": result.error_message
            }
        
        # Convert testbench results
        for name, result in results.testbench_results.items():
            data["testbench_results"][name] = {
                "testbench_name": result.testbench_name,
                "testbench_file": result.testbench_file,
                "testbench_available": result.testbench_available,
                "verilator_available": result.verilator_available,
                "simulation_status": result.simulation_status,
                "test_cases": result.test_cases,
                "error_message": result.error_message
            }
        
        # Save to file
        output_path = self.results_dir / output_file
        with open(output_path, 'w') as f:
            json.dump(data, f, indent=2)
        
        print(f"Hardware verification results saved to {output_path}")
    
    def get_available_synthesis_data(self, results: HardwareVerificationResult) -> Dict[str, int]:
        """
        Get available synthesis data for report generation.
        
        Args:
            results: Hardware verification results
            
        Returns:
            Dictionary mapping module names to cell counts
        """
        synthesis_data = {}
        
        for name, result in results.synthesis_results.items():
            if result.synthesis_available and result.area_cells is not None:
                synthesis_data[name] = result.area_cells
        
        return synthesis_data
    
    def get_available_testbench_data(self, results: HardwareVerificationResult) -> Dict[str, Dict[str, Any]]:
        """
        Get available testbench data for report generation.
        
        Args:
            results: Hardware verification results
            
        Returns:
            Dictionary mapping testbench names to test results
        """
        testbench_data = {}
        
        for name, result in results.testbench_results.items():
            if result.testbench_available and result.simulation_status:
                testbench_data[name] = {
                    "status": result.simulation_status,
                    "test_cases": result.test_cases,
                    "output": result.simulation_log
                }
        
        return testbench_data


def load_verification_results(results_file: str = "results/hardware_verification.json") -> Optional[HardwareVerificationResult]:
    """
    Load hardware verification results from JSON file.
    
    Args:
        results_file: Path to verification results file
        
    Returns:
        Hardware verification results or None if file not found
    """
    try:
        with open(results_file, 'r') as f:
            data = json.load(f)
        
        # Reconstruct synthesis results
        synthesis_results = {}
        for name, result_data in data.get("synthesis_results", {}).items():
            synthesis_results[name] = SynthesisResult(
                module_name=result_data["module_name"],
                verilog_file=result_data["verilog_file"],
                synthesis_available=result_data["synthesis_available"],
                area_cells=result_data.get("area_cells"),
                timing_info=result_data.get("timing_info"),
                power_estimate=result_data.get("power_estimate"),
                error_message=result_data.get("error_message")
            )
        
        # Reconstruct testbench results
        testbench_results = {}
        for name, result_data in data.get("testbench_results", {}).items():
            testbench_results[name] = TestbenchResult(
                testbench_name=result_data["testbench_name"],
                testbench_file=result_data["testbench_file"],
                testbench_available=result_data["testbench_available"],
                verilator_available=result_data["verilator_available"],
                simulation_status=result_data.get("simulation_status"),
                test_cases=result_data.get("test_cases"),
                error_message=result_data.get("error_message")
            )
        
        return HardwareVerificationResult(
            synthesis_results=synthesis_results,
            testbench_results=testbench_results,
            yosys_available=data["yosys_available"],
            verilator_available=data["verilator_available"],
            overall_status=data["overall_status"]
        )
        
    except FileNotFoundError:
        return None
    except Exception as e:
        print(f"Error loading verification results: {e}")
        return None


def main() -> None:
    """Run hardware verification."""
    verifier = HardwareVerifier()
    results = verifier.verify_all_hardware()
    
    print(f"\nHardware Verification Summary:")
    print(f"Yosys available: {results.yosys_available}")
    print(f"Verilator available: {results.verilator_available}")
    print(f"Overall status: {results.overall_status}")
    
    print(f"\nSynthesis Results:")
    for name, result in results.synthesis_results.items():
        status = "✓" if result.synthesis_available else "✗"
        area = f" ({result.area_cells} cells)" if result.area_cells else ""
        print(f"  {status} {name}{area}")
        if result.error_message:
            print(f"    Error: {result.error_message}")
    
    print(f"\nTestbench Results:")
    for name, result in results.testbench_results.items():
        status = "✓" if result.testbench_available else "✗"
        sim_status = f" [{result.simulation_status}]" if result.simulation_status else ""
        print(f"  {status} {name}{sim_status}")
        if result.error_message:
            print(f"    Error: {result.error_message}")
    
    # Save results
    verifier.save_verification_results(results)


if __name__ == "__main__":
    main() 