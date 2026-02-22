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
import concurrent.futures
import shutil

# Import run_verilator at module level for worker
try:
    from verilator_runner import run_verilator
except ImportError:
    run_verilator = None

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
    execution_time: Optional[float] = None
    verilator_time: Optional[float] = None
    synthesis_time: Optional[float] = None
    average_runtime_per_module: Optional[float] = None
    synthesis_multi_width: Optional[Dict[str, Dict[int, float]]] = None


def verify_testbench_worker(
    testbench_file: Path, 
    width: Optional[int], 
    verilog_dir: Path, 
    results_dir: Path, 
    tb_map: Dict[str, List[str]], 
    verilator_available: bool
) -> TestbenchResult:
    """
    Worker function for verifying a testbench.
    Designed to be picklable for multiprocessing.
    """
    testbench_name = testbench_file.stem
    
    if not testbench_file.exists():
        return TestbenchResult(testbench_name=testbench_name, testbench_file=str(testbench_file), testbench_available=False, verilator_available=False, error_message="Testbench file not found")
    
    if not verilator_available:
        return TestbenchResult(testbench_name=testbench_name, testbench_file=str(testbench_file), testbench_available=True, verilator_available=False, error_message="Verilator not available")

    # Try to run the simulation if we have the module mapping
    if testbench_name in tb_map and run_verilator:
        module_files = tb_map[testbench_name]
        
        # The first module in the list is the primary ECC module (top)
        top_module = module_files[0].replace(".v", "")
        
        verilog_files = []
        for mf in module_files:
            vf = verilog_dir / mf
            if vf.exists():
                verilog_files.append(str(vf))
        
        if verilog_files:
            # Create a unique output directory for this width to avoid race conditions
            # If width is None, use default folder
            subdir_name = f"{testbench_name}_w{width}" if width is not None else testbench_name
            output_dir = results_dir / subdir_name
            
            try:
                # Pass width via DATA_WIDTH define if provided
                extra_flags = []
                if width is not None:
                    extra_flags.append(f"-DDATA_WIDTH={width}")
                
                res = run_verilator(str(testbench_file), verilog_files, top_module=top_module, output_dir=str(output_dir), extra_flags=extra_flags)
                log_content = res["stdout"]
                
                # More robust simulation status check (allow optional space)
                simulation_status = "PASS" if re.search(r"RESULT:\s*PASS", log_content) else "FAIL" if re.search(r"RESULT:\s*FAIL", log_content) else "UNKNOWN"
                
                test_cases = {}
                if width is not None:
                    test_cases[f"hardware_verification_w{width}"] = simulation_status
                else:
                    # If no width, could be legacy or unknown
                    test_cases["default_verification"] = simulation_status

                return TestbenchResult(
                    testbench_name=testbench_name,
                    testbench_file=str(testbench_file),
                    testbench_available=True,
                    verilator_available=True,
                    simulation_status=simulation_status,
                    test_cases=test_cases,
                    simulation_log=log_content
                )
            except Exception as e:
                return TestbenchResult(testbench_name=testbench_name, testbench_file=str(testbench_file), testbench_available=True, verilator_available=True, error_message=str(e))

    return TestbenchResult(testbench_name=testbench_name, testbench_file=str(testbench_file), testbench_available=True, verilator_available=True, simulation_status="NOT_RUN", error_message="No module mapping or simulation results found")

def verify_synthesis_worker(
    verilog_files_paths: List[str],
    width: int,
    module_name: str,
    results_dir: Path
) -> SynthesisResult:
    """
    Worker function for verifying synthesis.
    """
    try:
        if not verilog_files_paths:
             return SynthesisResult(module_name=module_name, verilog_file="N/A", synthesis_available=False, error_message="No verilog files")

        # Create a simple Yosys script for synthesis
        files_str = " ".join([f"{f}" for f in verilog_files_paths])
        
        # Use flatten and hierarchy -check to ensure accurate cell counts
        script = f"""
read_verilog -sv {files_str}
chparam -set DATA_WIDTH {width} {module_name}
hierarchy -check -top {module_name}
flatten
synth -top {module_name}
stat
"""
        
        script_path = results_dir / f"{module_name}_w{width}_synthesis.ys"
        with open(script_path, "w") as f:
            f.write(script)
        
        result = subprocess.run(["yosys", "-s", str(script_path)], capture_output=True, text=True, timeout=120)
        
        if result.returncode == 0:
            area_cells = None
            # Parse the FINAL "stat" block
            lines = result.stdout.splitlines()
            last_stat_idx = -1
            for i, line in enumerate(lines):
                if "Printing statistics" in line:
                    last_stat_idx = i
            
            if last_stat_idx >= 0:
                for line in lines[last_stat_idx:]:
                    match = re.match(r'^\s+(\d+)\s+cells\s*$', line)
                    if match:
                        try:
                            area_cells = int(match.group(1))
                            break
                        except (ValueError, IndexError):
                            pass
            
            if area_cells is None:
                area_cells = 0
            
            return SynthesisResult(
                module_name=module_name,
                verilog_file=verilog_files_paths[0],
                synthesis_available=True,
                area_cells=area_cells,
                synthesis_log=result.stdout
            )
        else:
            return SynthesisResult(module_name=module_name, verilog_file=verilog_files_paths[0], synthesis_available=False, error_message=result.stderr)
    except Exception as e:
        return SynthesisResult(module_name=module_name, verilog_file=verilog_files_paths[0], synthesis_available=False, error_message=str(e))


class HardwareVerifier:
    """Hardware verification engine."""
    
    # Mapping of testbenches to their required Verilog modules
    TB_TO_MODULES = {
        "parity_ecc_tb": ["parity_ecc.v", "parity_encoder.v", "parity_decoder.v"],
        "hamming_secded_ecc_tb": ["hamming_secded_ecc.v", "hamming_encoder.v", "hamming_decoder.v"],
        "bch_ecc_tb": ["bch_ecc.v"],
        "reed_solomon_ecc_tb": ["reed_solomon_ecc.v"],
        "crc_ecc_tb": ["crc_ecc.v"],
        "golay_ecc_tb": ["golay_ecc.v"],
        "repetition_ecc_tb": ["repetition_ecc.v"],
        "ldpc_ecc_tb": ["ldpc_ecc.v"],
        "turbo_ecc_tb": ["turbo_ecc.v"],
        "convolutional_ecc_tb": ["convolutional_ecc.v"],
        "polar_ecc_tb": ["polar_ecc.v"],
        "extended_hamming_ecc_tb": ["extended_hamming_ecc.v"],
        "product_code_ecc_tb": ["product_code_ecc.v", "hamming_secded_ecc.v", "parity_ecc.v", "hamming_encoder.v", "hamming_decoder.v", "parity_encoder.v", "parity_decoder.v"],
        "concatenated_ecc_tb": ["concatenated_ecc.v", "hamming_secded_ecc.v"],
        "reed_muller_ecc_tb": ["reed_muller_ecc.v"],
        "fire_code_ecc_tb": ["fire_code_ecc.v"],
        "spatially_coupled_ldpc_ecc_tb": ["spatially_coupled_ldpc_ecc.v"],
        "non_binary_ldpc_ecc_tb": ["non_binary_ldpc_ecc.v"],
        "raptor_code_ecc_tb": ["raptor_code_ecc.v"],
        "composite_ecc_tb": ["composite_ecc.v"],
        "system_ecc_tb": ["system_ecc.v", "hamming_secded_ecc.v", "hamming_encoder.v", "hamming_decoder.v"],
        "adaptive_ecc_tb": ["adaptive_ecc.v", "hamming_secded_ecc.v", "hamming_encoder.v", "hamming_decoder.v"],
        "three_d_memory_ecc_tb": ["three_d_memory_ecc.v"],
        "primary_secondary_ecc_tb": ["primary_secondary_ecc.v"],
        "cyclic_ecc_tb": ["cyclic_ecc.v"],
        "burst_error_ecc_tb": ["burst_error_ecc.v"]
    }
    
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
            read_verilog -sv {verilog_file}
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

    def verify_synthesis_with_width(self, verilog_files: List[str], width: int, module_name: str) -> SynthesisResult:
        """Verify synthesis with a specific DATA_WIDTH parameter."""
        if not verilog_files:
            return SynthesisResult(module_name=module_name, verilog_file="N/A", synthesis_available=False, error_message="No files provided")
            
        yosys_available, _ = self.check_tool_availability()
        if not yosys_available:
            return SynthesisResult(module_name=module_name, verilog_file=verilog_files[0], synthesis_available=False, error_message="Yosys not available")
            
        try:
            # Join files for Yosys read command
            files_str = " ".join(verilog_files)
            script = f"""
            read_verilog -sv {files_str}
            chparam -set DATA_WIDTH {width} {module_name}
            hierarchy -check -top {module_name}
            flatten
            synth -top {module_name}
            stat
            """
            
            script_path = self.results_dir / f"{module_name}_w{width}_synthesis.ys"
            with open(script_path, "w") as f:
                f.write(script)
            
            result = subprocess.run(["yosys", "-s", str(script_path)], capture_output=True, text=True, timeout=120)
            
            if result.returncode == 0:
                area_cells = None
                # Parse the FINAL "stat" block to get accurate total cell count.
                # Yosys prints intermediate "Removed N unused cells" lines that would
                # incorrectly match a naive regex. We need the summary stat block.
                lines = result.stdout.splitlines()
                
                # Find index of the LAST occurrence of "Printing statistics."
                last_stat_idx = -1
                for i, line in enumerate(lines):
                    if "Printing statistics" in line:
                        last_stat_idx = i
                
                if last_stat_idx >= 0:
                    # Scan forward from the last stat block for "N cells"
                    for line in lines[last_stat_idx:]:
                        # Match a line that is just whitespace + number + " cells"
                        # e.g.:  "       99 cells"
                        match = re.match(r'^\s+(\d+)\s+cells\s*$', line)
                        if match:
                            try:
                                area_cells = int(match.group(1))
                                break
                            except (ValueError, IndexError):
                                pass
                
                if area_cells is None:
                    area_cells = 0  # synthesis succeeded but synthesized to nothing (constants)
                
                return SynthesisResult(
                    module_name=module_name,
                    verilog_file=verilog_files[0],
                    synthesis_available=True,
                    area_cells=area_cells,
                    synthesis_log=result.stdout
                )
            else:
                return SynthesisResult(module_name=module_name, verilog_file=verilog_files[0], synthesis_available=False, error_message=result.stderr)
        except Exception as e:
            return SynthesisResult(module_name=module_name, verilog_file=verilog_files[0], synthesis_available=False, error_message=str(e))
    
    def verify_testbench(self, testbench_file: Path, width: Optional[int] = None) -> TestbenchResult:
        """
        Verify testbench for a single testbench file.
        Runs Verilator simulation if tools are available.
        DELEGATES to verify_testbench_worker for consistent logic.
        """
        _, verilator_available = self.check_tool_availability()
        
        return verify_testbench_worker(
            testbench_file=testbench_file,
            width=width,
            verilog_dir=self.verilog_dir,
            results_dir=self.results_dir,
            tb_map=self.TB_TO_MODULES,
            verilator_available=verilator_available
        )
    
    def verify_all_hardware(self, widths: List[int] = [4, 8, 16, 32, 64, 128]) -> HardwareVerificationResult:
        """
        Verify all hardware implementations across multiple widths.
        
        Returns:
            Complete hardware verification results
        """
        print(f"Verifying hardware implementations across widths: {widths}...")
        
        # Check tool availability
        yosys_available, verilator_available = self.check_tool_availability()
        
        # Targeted 26 core ECC modules
        TARGET_MODULES = [
            'adaptive_ecc', 'bch_ecc', 'burst_error_ecc', 'composite_ecc', 'concatenated_ecc',
            'convolutional_ecc', 'crc_ecc', 'cyclic_ecc', 'extended_hamming_ecc', 'fire_code_ecc',
            'golay_ecc', 'hamming_secded_ecc', 'ldpc_ecc', 'non_binary_ldpc_ecc', 'parity_ecc',
            'polar_ecc', 'primary_secondary_ecc', 'product_code_ecc', 'raptor_code_ecc',
            'reed_muller_ecc', 'reed_solomon_ecc', 'repetition_ecc', 'spatially_coupled_ldpc_ecc',
            'system_ecc', 'three_d_memory_ecc', 'turbo_ecc'
        ]

        synthesis_results = {}
        synthesis_multi_width = {} # {module: {width: area}}
        testbench_results = {}
        
        # 1. Functional Verification (Verilator) - Running all together in PARALLEL
        print("\n=== STEP 1: Functional Verification (Verilator) - Parallel Execution ===")
        verilator_start = time.time()
        
        # We need to collect all tasks first
        verification_tasks = []
        
        # Use a ProcessPoolExecutor for parallel execution
        # Verilator compilation is CPU intensive, so we use all available cores
        import os
        max_workers = os.cpu_count()
        print(f"Starting parallel verification with {max_workers} workers...")
        
        with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
            futures_map = {}
            
            for module_name in TARGET_MODULES:
                tb_name = f"{module_name}_tb"
                testbench_file = self.testbench_dir / f"{tb_name}.cpp"
                
                if testbench_file.exists():
                    # We submit a task for each width
                    for w in widths:
                        future = executor.submit(
                            verify_testbench_worker,
                            testbench_file=testbench_file,
                            width=w,
                            verilog_dir=self.verilog_dir,
                            results_dir=self.results_dir,
                            tb_map=self.TB_TO_MODULES,
                            verilator_available=verilator_available
                        )
                        futures_map[future] = (tb_name, w)
                else:
                    pass

            # Collect results as they complete
            total_tasks = len(futures_map)
            completed_tasks = 0
            
            # Temporary storage to aggregate results per module
            module_aggregated_results = {} # {tb_name: TestbenchResult}
            
            for future in concurrent.futures.as_completed(futures_map):
                tb_name, width = futures_map[future]
                completed_tasks += 1
                if completed_tasks % 10 == 0 or completed_tasks == total_tasks:
                     print(f"Progress: {completed_tasks}/{total_tasks} tasks completed...")
                
                try:
                    res = future.result()
                    
                    if tb_name not in module_aggregated_results:
                        # First result for this module, directly use it
                        module_aggregated_results[tb_name] = res
                    else:
                        # Merge this result into existing
                        current = module_aggregated_results[tb_name]
                        # simulation status: if any failed, mark as FAIL/variable
                        if res.simulation_status != "PASS" and current.simulation_status == "PASS":
                             current.simulation_status = res.simulation_status # Demote to FAIL/UNKNOWN
                        
                        # Merge test cases
                        if res.test_cases:
                            if current.test_cases is None: current.test_cases = {}
                            current.test_cases.update(res.test_cases)
                        
                        # Append log? No, keep logs separate or just last one? 
                        # We used separate output dirs so logs are unique on disk. 
                        # In the result object, maybe just keep one or concatenate. 
                        # Legacy expected one log. Let's append if small, or just override.
                        # verify_testbench_worker returns 'simulation_log'.
                except Exception as e:
                    print(f"Task for {tb_name} w{width} generated an exception: {e}")
            
            testbench_results = module_aggregated_results

        verilator_elapsed = time.time() - verilator_start
        print(f"\nVerilator phase completed in {verilator_elapsed:.1f}s")

        # 2. Synthesis (Yosys) - Proceeding after all verifications
        print("\n=== STEP 2: Multi-Width Synthesis (Yosys) ===")
        yosys_start = time.time()
        for module_name in TARGET_MODULES:
            tb_name = f"{module_name}_tb"
            # Get Verilog dependencies from TB_TO_MODULES
            if tb_name in self.TB_TO_MODULES:
                module_files = self.TB_TO_MODULES[tb_name]
                verilog_files = []
                for mf in module_files:
                    vf = self.verilog_dir / mf
                    if vf.exists():
                        verilog_files.append(str(vf))
                
                if verilog_files:
                    print(f"Synthesizing {module_name} across widths...")
                    synthesis_multi_width[module_name] = {}
                    primary_result = None
                    
                    for w in widths:
                        # Check for generated width-specific file (e.g., bch_ecc_w32.v)
                        current_verilog_files = list(verilog_files)
                        gen_file = self.verilog_dir / "generated" / f"{module_name}_w{w}.v"
                        if gen_file.exists():
                            current_verilog_files.append(str(gen_file))
                        
                        result = self.verify_synthesis_with_width(current_verilog_files, w, module_name)
                        synthesis_multi_width[module_name][w] = result.area_cells
                        if w == 32 or primary_result is None: # Use 32-bit as primary if available
                            primary_result = result
                    
                    synthesis_results[module_name] = primary_result
                else:
                    print(f"Warning: No Verilog files found for {module_name}")
            else:
                # Fallback to single file if no mapping
                verilog_file = self.verilog_dir / f"{module_name}.v"
                if verilog_file.exists():
                    print(f"Synthesizing {module_name} (no dependency map)...")
                    synthesis_multi_width[module_name] = {}
                    primary_result = None
                    for w in widths:
                        current_verilog_files = [str(verilog_file)]
                        gen_file = self.verilog_dir / "generated" / f"{module_name}_w{w}.v"
                        if gen_file.exists():
                            current_verilog_files.append(str(gen_file))
                            
                        result = self.verify_synthesis_with_width(current_verilog_files, w, module_name)
                        synthesis_multi_width[module_name][w] = result.area_cells
                        if w == 32 or primary_result is None:
                            primary_result = result
                    synthesis_results[module_name] = primary_result
        yosys_elapsed = time.time() - yosys_start
        total_elapsed = verilator_elapsed + yosys_elapsed
        n_modules = len(TARGET_MODULES)
        print(f"\nYosys synthesis phase completed in {yosys_elapsed:.1f}s")
        print(f"Total hardware verification time: {total_elapsed:.1f}s ({total_elapsed/60:.1f} min)")
        print(f"Average per module: {total_elapsed/n_modules:.1f}s")

        # Initialize empty ECC verification results
        ecc_verification_results = {}
        
        # Determine overall status
        synthesis_available = any(r and r.synthesis_available for r in synthesis_results.values())
        testbench_available = any(r and r.testbench_available for r in testbench_results.values())
        
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
            overall_status=overall_status,
            execution_time=round(total_elapsed, 1),
            verilator_time=round(verilator_elapsed, 1),
            synthesis_time=round(yosys_elapsed, 1),
            average_runtime_per_module=round(total_elapsed / n_modules, 1),
            synthesis_multi_width=synthesis_multi_width
        )
    
    def save_verification_results(self, results: HardwareVerificationResult, 
                                output_file: str = "hardware_verification_results.json") -> None:
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
            "execution_time": results.execution_time,
            "verilator_time": results.verilator_time,
            "synthesis_time": results.synthesis_time,
            "average_runtime_per_module": results.average_runtime_per_module,
            "synthesis_results": {},
            "testbench_results": {},
            "synthesis_multi_width": results.synthesis_multi_width
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
        
        # If multi-width data is available, we return the data for the "primary" width (e.g. 64)
        # for these legacy visualization helpers
        if results.synthesis_multi_width:
            for name, widths in results.synthesis_multi_width.items():
                # JSON keys are always strings; normalize to int for consistent lookup
                widths_int = {int(k): v for k, v in widths.items()}
                if 64 in widths_int and widths_int[64] is not None:
                    synthesis_data[name] = widths_int[64]
                elif widths_int:
                    # Fallback to first available width (sorted ascending)
                    for w in sorted(widths_int.keys()):
                        if widths_int[w] is not None:
                            synthesis_data[name] = widths_int[w]
                            break
            return synthesis_data
            
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
    
    def create_hardware_visualizations(self, results: HardwareVerificationResult, output_dir: str = "results") -> Dict[str, str]:
        """
        Create hardware visualization charts.
        
        Args:
            results: Hardware verification results
            output_dir: Directory to save charts
            
        Returns:
            Dictionary mapping chart name to file path
        """
        try:
            import matplotlib.pyplot as plt
            import numpy as np
        except ImportError:
            print("Matplotlib or NumPy not available for hardware visualizations")
            return {}
            
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        charts = {}
        
        # Get synthesis data
        synthesis_data = self.get_available_synthesis_data(results)
        
        if not synthesis_data:
            return {}
            
        # Prepare data for plotting
        modules = list(synthesis_data.keys())
        cells = list(synthesis_data.values())
        
        # Sort by cell count
        sorted_indices = np.argsort(cells)
        modules = [modules[i] for i in sorted_indices]
        cells = [cells[i] for i in sorted_indices]
        
        # Set style for scientific publication
        plt.rcParams.update({
            'font.family': 'serif',
            'font.serif': ['DejaVu Serif', 'Times New Roman', 'serif'],
            'font.size': 12,
            'font.weight': 'bold',  # Global bold font
            'axes.labelweight': 'bold', # Bold axis labels
            'axes.titleweight': 'bold', # Bold titles
            'axes.labelsize': 12,
            'axes.titlesize': 14,
            'xtick.labelsize': 10,
            'ytick.labelsize': 10,
            'legend.fontsize': 10,
            'figure.titlesize': 16,
            'axes.grid': True,
            'grid.alpha': 0.3,
            'grid.linestyle': '--',
            'axes.edgecolor': 'black',
            'axes.linewidth': 1.0,
            'lines.linewidth': 2.0,
            'figure.dpi': 300,
            'savefig.dpi': 300,
            'savefig.bbox': 'tight'
        })
        
        # Create single-axis bar chart
        fig, ax = plt.subplots(figsize=(14, 8))
        
        x = np.arange(len(modules))
        width = 0.6
        
        # Plot Area (Cells)
        bars = ax.bar(x, cells, width, label='Area (Cells)', color='#0000FF', alpha=0.9, edgecolor='black')
        ax.set_ylabel('Area (Cells)', fontsize=12, fontweight='bold', fontfamily='serif')
        ax.set_xlabel('Module', fontsize=12, fontweight='bold', fontfamily='serif')
        ax.tick_params(axis='y', labelsize=10)
        for label in ax.get_yticklabels():
            label.set_fontweight('bold')
        ax.set_xticks(x)
        ax.set_xticklabels(modules, rotation=45, ha='right', fontsize=10, fontweight='bold', fontfamily='serif')
        ax.set_title('Hardware Cost Comparison: Area (Cells) - 64-bit Data Width', fontsize=16, fontweight='bold', fontfamily='serif', pad=20)
        ax.grid(True, axis='y', alpha=0.3, linestyle='--', color='gray')
        
        # Add value labels on bars
        for bar, cell_count in zip(bars, cells):
            ax.text(bar.get_x() + bar.get_width() / 2., bar.get_height(),
                    f'{cell_count}', ha='center', va='bottom', fontsize=11, fontweight='bold')
        
        plt.tight_layout()
        
        # Save as PNG
        chart_path_png = output_path / "ecc_hardware_cost.png"
        plt.savefig(chart_path_png, dpi=300, bbox_inches='tight')
        charts['hardware_cost'] = str(chart_path_png)
        
        # Save as PDF
        chart_path_pdf = output_path / "ecc_hardware_cost.pdf"
        plt.savefig(chart_path_pdf, bbox_inches='tight')
        
        plt.close()
        
        # Create Scaling Chart if multi-width data exists
        if results.synthesis_multi_width:
            fig, ax = plt.subplots(figsize=(14, 8))
            
            # We'll plot a few representative modules to avoid clutter
            REPRESENTATIVE = ['hamming_secded_ecc', 'bch_ecc', 'reed_solomon_ecc', 'ldpc_ecc', 'polar_ecc', 'turbo_ecc']
            
            for module in REPRESENTATIVE:
                if module in results.synthesis_multi_width:
                    widths_data = results.synthesis_multi_width[module]
                    # Normalize keys to int (JSON stores them as strings)
                    widths_int = {int(k): v for k, v in widths_data.items()}
                    ws = sorted(widths_int.keys())
                    vals = [widths_int[w] for w in ws if widths_int[w] is not None]
                    if vals:
                        ax.plot(ws[:len(vals)], vals, marker='o', label=module, linewidth=3)
            
            ax.set_xlabel('Data Width (bits)', fontsize=12, fontweight='bold')
            ax.set_ylabel('Area (Cells)', fontsize=12, fontweight='bold')
            ax.set_title('Hardware Scaling: Area vs Data Width', fontsize=16, fontweight='bold')
            ax.legend()
            ax.grid(True, which='both', linestyle='--', alpha=0.5)
            
            scaling_path = output_path / "ecc_hardware_scaling.png"
            plt.savefig(scaling_path, dpi=300, bbox_inches='tight')
            charts['hardware_scaling'] = str(scaling_path)
            plt.close()
        
        return charts


def load_verification_results(results_file: str = "results/hardware_verification_results.json") -> Optional[HardwareVerificationResult]:
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
        
        # Handle results from hardware_verification_runner.py (ecc_results format)
        if "ecc_results" in data:
            print(f"DEBUG: Found ecc_results with {len(data['ecc_results'])} entries")
            for name, result_data in data["ecc_results"].items():
                # Construct testbench name
                tb_name = f"{name}_tb"
                
                # Parse test cases
                test_cases_dict = {}
                if "test_results" in result_data:
                    for test in result_data["test_results"]:
                        test_cases_dict[test["test_name"]] = "PASS" if test["passed"] else "FAIL"
                
                # Create TestbenchResult from ECC result
                testbench_results[tb_name] = TestbenchResult(
                    testbench_name=tb_name,
                    testbench_file=f"testbenches/{tb_name}.c",  # Inferred path
                    testbench_available=True,
                    verilator_available=data.get("verilator_available", True),
                    simulation_status=result_data.get("overall_status"),
                    test_cases=test_cases_dict,
                    error_message=None  # Detailed errors are in test_results
                )
        
        # Handle legacy results or direct Verilator runs (testbench_results format)
        elif "testbench_results" in data:
            for name, result_data in data["testbench_results"].items():
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
            ecc_verification_results=data.get("ecc_verification_results", {}),
            yosys_available=data.get("yosys_available", False),
            verilator_available=data.get("verilator_available", True),
            overall_status=data.get("overall_status", "UNKNOWN"),
            execution_time=data.get("execution_time"),
            verilator_time=data.get("verilator_time"),
            synthesis_time=data.get("synthesis_time"),
            average_runtime_per_module=data.get("average_runtime_per_module")
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