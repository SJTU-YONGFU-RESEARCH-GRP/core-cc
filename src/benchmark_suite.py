"""
Enhanced ECC Benchmarking Suite

This module provides comprehensive benchmarking capabilities for different ECC schemes,
testing various word lengths, error patterns, and performance metrics.
"""

import random
import time
import statistics
import multiprocessing
import os
from typing import Dict, List, Tuple, Any, Type, Optional
from dataclasses import dataclass
from pathlib import Path
import json
import numpy as np
import pandas as pd
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor, as_completed
import psutil

from base_ecc import ECCBase
from parity_ecc import ParityECC
from hamming_secded_ecc import HammingSECDEDECC
from bch_ecc import BCHECC
from reed_solomon_ecc import ReedSolomonECC
from crc_ecc import CRCECC
from golay_ecc import GolayECC
from polar_ecc import PolarECC
from repetition_ecc import RepetitionECC
from ldpc_ecc import LDPCECC
from turbo_ecc import TurboECC
from convolutional_ecc import ConvolutionalECC
from extended_hamming_ecc import ExtendedHammingECC
from product_code_ecc import ProductCodeECC
from concatenated_ecc import ConcatenatedECC
from reed_muller_ecc import ReedMullerECC
from fire_code_ecc import FireCodeECC
from spatially_coupled_ldpc_ecc import SpatiallyCoupledLDPCECC
from non_binary_ldpc_ecc import NonBinaryLDPCECC
from raptor_code_ecc import RaptorCodeECC
from composite_ecc import CompositeECC
from system_ecc import SystemECC
from adaptive_ecc import AdaptiveECC
from three_d_memory_ecc import ThreeDMemoryECC
from primary_secondary_ecc import PrimarySecondaryECC
from cyclic_ecc import CyclicECC
from burst_error_ecc import BurstErrorECC


@dataclass
class BenchmarkConfig:
    """Configuration for ECC benchmarking."""
    
    # ECC types to test
    ecc_types: List[Type[ECCBase]]
    
    # Word lengths to test (in bits)
    word_lengths: List[int]
    
    # Error injection patterns
    error_patterns: List[str]  # 'single', 'double', 'burst', 'random'
    
    # Number of trials per configuration
    trials_per_config: int = 10000
    
    # Burst error length (for burst error testing)
    burst_length: int = 3
    
    # Random error probability (for random error testing)
    random_error_prob: float = 0.01
    
    # Performance measurement settings
    measure_timing: bool = True
    measure_memory: bool = False
    
    # Parallel execution
    max_workers: int = 4


@dataclass
class BenchmarkResult:
    """Results from a single benchmark run."""
    
    ecc_type: str
    word_length: int
    error_pattern: str
    trials: int
    
    # Error handling metrics
    correctable_errors: int
    detected_errors: int
    undetected_errors: int
    
    # Performance metrics
    encode_time_avg: float
    decode_time_avg: float
    total_time_avg: float
    
    # Efficiency metrics
    code_rate: float  # data_bits / total_bits
    overhead_ratio: float  # redundant_bits / data_bits
    
    # Additional metrics
    correction_rate: float
    detection_rate: float
    success_rate: float
    
    # Error distribution
    error_distribution: Dict[str, int]


class ECCBenchmarkSuite:
    """Comprehensive ECC benchmarking suite."""
    
    def __init__(self, config: BenchmarkConfig):
        """
        Initialize the benchmarking suite.
        
        Args:
            config: Benchmark configuration
        """
        self.config = config
        self.results: List[BenchmarkResult] = []
        self._run_benchmarks_with_processes = False
        self._use_chunked_processing = False
        self._overwrite_existing = False
        self._parallel_method = "auto"  # auto, threads, processes, chunked
        self._adaptive_workers = True
        
    def set_overwrite_existing(self, overwrite: bool = True) -> None:
        """Set whether to overwrite existing benchmark results."""
        self._overwrite_existing = overwrite
    
    def set_parallel_method(self, method: str = "auto") -> None:
        """Set the parallel processing method."""
        self._parallel_method = method
    
    def set_adaptive_workers(self, adaptive: bool = True) -> None:
        """Set whether to use adaptive worker count based on system resources."""
        self._adaptive_workers = adaptive
    
    def _select_optimal_parallel_method(self) -> str:
        """Select the optimal parallel processing method based on system capabilities."""
        cpu_count = multiprocessing.cpu_count()
        memory_gb = psutil.virtual_memory().total / (1024**3)
        
        # Use processes for CPU-intensive tasks if we have enough cores and memory
        if cpu_count >= 4 and memory_gb >= 4:
            return "processes"
        elif cpu_count >= 2:
            return "threads"
        else:
            return "chunked"
    
    def _calculate_optimal_workers(self) -> int:
        """Calculate optimal number of workers based on system resources."""
        cpu_count = multiprocessing.cpu_count()
        memory_gb = psutil.virtual_memory().total / (1024**3)
        
        if self._adaptive_workers:
            # Adaptive worker calculation
            if memory_gb >= 8:
                return min(cpu_count, 12)  # More workers for high memory
            elif memory_gb >= 4:
                return min(cpu_count, 8)   # Moderate workers
            else:
                return min(cpu_count, 4)   # Conservative workers
        else:
            return self.config.max_workers
        
    def _check_existing_results(self, output_dir: str = "results") -> Dict[str, bool]:
        """
        Check which benchmark configurations already have results from individual files.
        
        Args:
            output_dir: Directory to check for existing results
            
        Returns:
            Dictionary mapping (ecc_type, word_length, error_pattern) to existence status
        """
        existing_results = {}
        benchmarks_dir = Path(output_dir) / "benchmarks"
        
        if not benchmarks_dir.exists():
            # No existing results, all configurations need to be run
            for ecc_type in self.config.ecc_types:
                for word_length in self.config.word_lengths:
                    for error_pattern in self.config.error_patterns:
                        key = (ecc_type.__name__, word_length, error_pattern)
                        existing_results[key] = False
            return existing_results
        
        # Check individual result files
        existing_configs = set()
        for result_file in benchmarks_dir.glob("*.json"):
            try:
                with open(result_file, 'r') as f:
                    result_data = json.load(f)
                    config_key = (
                        result_data.get('ecc_type', ''),
                        result_data.get('word_length', 0),
                        result_data.get('error_pattern', '')
                    )
                    existing_configs.add(config_key)
            except (json.JSONDecodeError, FileNotFoundError):
                continue
        
        # Check which configurations need to be run
        for ecc_type in self.config.ecc_types:
            for word_length in self.config.word_lengths:
                for error_pattern in self.config.error_patterns:
                    key = (ecc_type.__name__, word_length, error_pattern)
                    existing_results[key] = key in existing_configs
        
        return existing_results
        
    def _load_existing_results(self) -> List[BenchmarkResult]:
        """Load existing benchmark results from file."""
        results_file = Path("results") / "benchmark_results.json"
        if not results_file.exists():
            return []
        
        try:
            with open(results_file, 'r') as f:
                data = json.load(f)
            
            # Handle both list format and object format
            results_list = []
            if isinstance(data, list):
                results_list = data
            elif isinstance(data, dict):
                results_list = data.get('results', [])
            
            results = []
            for result_data in results_list:
                if isinstance(result_data, dict):
                    result = BenchmarkResult(
                        ecc_type=result_data['ecc_type'],
                        word_length=result_data['word_length'],
                        error_pattern=result_data['error_pattern'],
                        trials=result_data['trials'],
                        correctable_errors=result_data['correctable_errors'],
                        detected_errors=result_data['detected_errors'],
                        undetected_errors=result_data['undetected_errors'],
                        encode_time_avg=result_data['encode_time_avg'],
                        decode_time_avg=result_data['decode_time_avg'],
                        total_time_avg=result_data['total_time_avg'],
                        code_rate=result_data['code_rate'],
                        overhead_ratio=result_data['overhead_ratio'],
                        correction_rate=result_data['correction_rate'],
                        detection_rate=result_data['detection_rate'],
                        success_rate=result_data['success_rate'],
                        error_distribution=result_data['error_distribution']
                    )
                    results.append(result)
            
            return results
            
        except (json.JSONDecodeError, KeyError, FileNotFoundError) as e:
            print(f"Warning: Could not load existing results: {e}")
            return []
    
    def _create_ecc_instance(self, ecc_type: Type[ECCBase], word_length: int) -> ECCBase:
        """
        Create an ECC instance with appropriate parameters.
        
        Args:
            ecc_type: ECC class to instantiate
            word_length: Data word length in bits
            
        Returns:
            ECC instance
        """
        # Handle different ECC types that may need specific parameters
        if ecc_type == BCHECC:
            # BCH needs specific parameters based on word length
            if word_length <= 4:
                return BCHECC(n=7, k=4, t=1)  # BCH(7,4,1)
            elif word_length <= 8:
                return BCHECC(n=15, k=7, t=2)  # BCH(15,7,2)
            else:
                return BCHECC(n=31, k=16, t=3)  # BCH(31,16,3)
        elif ecc_type == ReedSolomonECC:
            # Reed-Solomon parameters
            if word_length <= 4:
                return ReedSolomonECC(n=7, k=4)
            elif word_length <= 8:
                return ReedSolomonECC(n=15, k=8)
            else:
                return ReedSolomonECC(n=31, k=16)
        elif ecc_type == LDPCECC:
            # LDPC parameters - only n is needed, k is determined by the generator matrix
            return LDPCECC(n=word_length * 2)
        elif ecc_type == TurboECC:
            # Turbo code parameters - pass data_length
            return TurboECC(data_length=word_length)
        elif ecc_type == ConvolutionalECC:
            # Convolutional code parameters
            return ConvolutionalECC(n=word_length * 2, k=word_length)
        elif ecc_type == PolarECC:
            # Polar code parameters
            return PolarECC(n=word_length * 2, k=word_length)
        elif ecc_type == RepetitionECC:
            # Repetition code with 3x repetition
            return RepetitionECC(repetition_factor=3)
        elif ecc_type == CRCECC:
            # CRC with appropriate polynomial
            return CRCECC(polynomial=0x11)  # CRC-4
        elif ecc_type == GolayECC:
            # Golay code is fixed size
            return GolayECC()
        elif ecc_type == ExtendedHammingECC:
            # Extended Hamming with word length
            return ExtendedHammingECC(data_length=word_length)
        elif ecc_type == ProductCodeECC:
            # Product Code with word length
            return ProductCodeECC(data_length=word_length)
        elif ecc_type == ConcatenatedECC:
            # Concatenated ECC with word length
            return ConcatenatedECC(data_length=word_length)
        elif ecc_type == ReedMullerECC:
            # Reed-Muller ECC with word length
            return ReedMullerECC(data_length=word_length)
        elif ecc_type == FireCodeECC:
            # Fire Code ECC with word length
            return FireCodeECC(data_length=word_length)
        elif ecc_type == SpatiallyCoupledLDPCECC:
            # Spatially Coupled LDPC with word length
            return SpatiallyCoupledLDPCECC(data_length=word_length)
        elif ecc_type == NonBinaryLDPCECC:
            # Non-Binary LDPC with word length
            return NonBinaryLDPCECC(data_length=word_length)
        elif ecc_type == RaptorCodeECC:
            # Raptor Code ECC with word length
            return RaptorCodeECC(data_length=word_length)
        elif ecc_type == CompositeECC:
            # Composite ECC with word length
            return CompositeECC(data_length=word_length)
        elif ecc_type == SystemECC:
            # System ECC with word length
            return SystemECC(data_length=word_length)
        elif ecc_type == AdaptiveECC:
            # Adaptive ECC with word length
            return AdaptiveECC(data_length=word_length)
        elif ecc_type == ThreeDMemoryECC:
            # 3D Memory ECC with word length
            return ThreeDMemoryECC(data_length=word_length)
        elif ecc_type == PrimarySecondaryECC:
            # Primary/Secondary ECC with word length
            return PrimarySecondaryECC(data_length=word_length)
        elif ecc_type == CyclicECC:
            # Cyclic ECC with word length
            return CyclicECC(n=word_length*2, k=word_length, data_length=word_length)
        elif ecc_type == BurstErrorECC:
            # Burst Error ECC with word length
            return BurstErrorECC(data_length=word_length)
        else:
            # Default instantiation for simple ECC types
            return ecc_type()
    
    def _inject_errors(self, codeword: int, error_pattern: str, word_length: int) -> int:
        """
        Inject errors according to the specified pattern.
        
        Args:
            codeword: Original codeword
            error_pattern: Type of error pattern
            word_length: Length of data word
            
        Returns:
            Corrupted codeword
        """
        codeword_length = codeword.bit_length()
        if codeword_length == 0:
            codeword_length = 1
            
        if error_pattern == "single":
            # Single bit error
            bit_idx = random.randint(0, codeword_length - 1)
            return codeword ^ (1 << bit_idx)
            
        elif error_pattern == "double":
            # Double bit errors
            bit1 = random.randint(0, codeword_length - 1)
            bit2 = random.randint(0, codeword_length - 1)
            while bit2 == bit1:
                bit2 = random.randint(0, codeword_length - 1)
            return codeword ^ (1 << bit1) ^ (1 << bit2)
            
        elif error_pattern == "burst":
            # Burst errors
            start_bit = random.randint(0, max(0, codeword_length - self.config.burst_length))
            corrupted = codeword
            for i in range(self.config.burst_length):
                if start_bit + i < codeword_length:
                    corrupted ^= (1 << (start_bit + i))
            return corrupted
            
        elif error_pattern == "random":
            # Random errors with specified probability
            corrupted = codeword
            for i in range(codeword_length):
                if random.random() < self.config.random_error_prob:
                    corrupted ^= (1 << i)
            return corrupted
            
        else:
            # No error
            return codeword
    
    def _benchmark_single_config(self, ecc_type: Type[ECCBase], word_length: int, 
                                error_pattern: str) -> BenchmarkResult:
        """
        Run benchmark for a single configuration.
        
        Args:
            ecc_type: ECC class to test
            word_length: Data word length
            error_pattern: Error injection pattern
            
        Returns:
            Benchmark result
        """
        ecc = self._create_ecc_instance(ecc_type, word_length)
        
        # Initialize counters
        correctable = 0
        detected = 0
        undetected = 0
        encode_times = []
        decode_times = []
        total_times = []
        error_distribution = {"single": 0, "double": 0, "burst": 0, "random": 0}
        
        for _ in range(self.config.trials_per_config):
            # Generate random data
            data = random.getrandbits(word_length)
            
            # Measure encoding time
            start_time = time.perf_counter()
            codeword = ecc.encode(data)
            encode_time = time.perf_counter() - start_time
            encode_times.append(encode_time)
            
            # Inject errors
            corrupted = self._inject_errors(codeword, error_pattern, word_length)
            
            # Measure decoding time
            start_time = time.perf_counter()
            decoded, error_type = ecc.decode(corrupted)
            decode_time = time.perf_counter() - start_time
            decode_times.append(decode_time)
            
            total_times.append(encode_time + decode_time)
            
            # Count error types
            error_distribution[error_pattern] += 1
            
            # Update statistics based on error_type
            if error_type == 'corrected':
                correctable += 1
            elif error_type == 'detected':
                detected += 1
            elif error_type == 'undetected':
                undetected += 1
        
        # Calculate metrics
        total_trials = self.config.trials_per_config
        correction_rate = (correctable / total_trials) * 100
        detection_rate = ((correctable + detected) / total_trials) * 100
        success_rate = ((correctable + detected) / total_trials) * 100
        
        # Calculate code rate and overhead
        sample_codeword = ecc.encode(random.getrandbits(word_length))
        total_bits = sample_codeword.bit_length()
        if total_bits == 0:
            total_bits = 1
        code_rate = word_length / total_bits
        overhead_ratio = (total_bits - word_length) / word_length
        
        return BenchmarkResult(
            ecc_type=ecc_type.__name__,
            word_length=word_length,
            error_pattern=error_pattern,
            trials=total_trials,
            correctable_errors=correctable,
            detected_errors=detected,
            undetected_errors=undetected,
            encode_time_avg=statistics.mean(encode_times),
            decode_time_avg=statistics.mean(decode_times),
            total_time_avg=statistics.mean(total_times),
            code_rate=code_rate,
            overhead_ratio=overhead_ratio,
            correction_rate=correction_rate,
            detection_rate=detection_rate,
            success_rate=success_rate,
            error_distribution=error_distribution
        )
    
    def run_benchmarks(self) -> List[BenchmarkResult]:
        """
        Run all configured benchmarks with enhanced parallel processing.
        
        Returns:
            List of benchmark results
        """
        # Generate all configurations
        configs = []
        for ecc_type in self.config.ecc_types:
            for word_length in self.config.word_lengths:
                for error_pattern in self.config.error_patterns:
                    configs.append((ecc_type, word_length, error_pattern))
        
        print(f"📋 Total configurations to test: {len(configs)}")
        print(f"🔧 ECC Types: {[ecc.__name__ for ecc in self.config.ecc_types]}")
        print(f"📏 Word Lengths: {self.config.word_lengths}")
        print(f"⚠️  Error Patterns: {self.config.error_patterns}")
        print(f"🔄 Trials per configuration: {self.config.trials_per_config}")
        print()
        
        # Check for existing results
        existing_results_status = self._check_existing_results()
        
        # Filter out configurations that already have results unless overwrite is requested
        if not self._overwrite_existing:
            configs_to_run = []
            skipped_count = 0
            for ecc_type, word_length, error_pattern in configs:
                if existing_results_status[(ecc_type.__name__, word_length, error_pattern)]:
                    print(f"⏭️  Skipping {ecc_type.__name__} ({word_length} bits, {error_pattern} errors) - already exists")
                    skipped_count += 1
                else:
                    configs_to_run.append((ecc_type, word_length, error_pattern))
            configs = configs_to_run
            
            if skipped_count > 0:
                print(f"📋 Skipped {skipped_count} existing configurations. Use --overwrite to re-run all.")
                print(f"🎯 Remaining configurations to run: {len(configs)}")
                print()
        
        # If no configurations to run, load existing results
        if not configs:
            print("✅ All configurations already have results. Loading existing data...")
            self._load_existing_results()
            return self.results
        
        print(f"🚀 Starting benchmark execution...")
        print(f"⏱️  Estimated time: ~{len(configs) * 2} minutes (2 min per config)")
        print()
        
        # Choose execution method based on configuration
        if self._parallel_method == "auto":
            self._parallel_method = self._select_optimal_parallel_method()
        
        optimal_workers = self._calculate_optimal_workers()
        
        if self._parallel_method == "processes":
            print(f"🔄 Using ProcessPoolExecutor with {optimal_workers} workers")
            results = self._run_benchmarks_with_processes_parallel(configs, optimal_workers)
        elif self._parallel_method == "chunked":
            print(f"📦 Using chunked processing with {optimal_workers} workers")
            results = self._run_benchmarks_chunked(configs, optimal_workers)
        else:
            print(f"🧵 Using ThreadPoolExecutor with {optimal_workers} workers")
            results = self._run_benchmarks_with_threads(configs, optimal_workers)
        
        # Merge with existing results if not overwriting
        if not self._overwrite_existing:
            existing_results = self._load_existing_results()
            # Create a set of new result keys to avoid duplicates
            new_result_keys = {(r.ecc_type, r.word_length, r.error_pattern) for r in results}
            # Keep existing results that weren't re-run
            for existing_result in existing_results:
                key = (existing_result.ecc_type, existing_result.word_length, existing_result.error_pattern)
                if key not in new_result_keys:
                    results.append(existing_result)
        
        print(f"\n✅ Benchmarking completed!")
        print(f"📊 Total results: {len(results)}")
        print(f"🎯 Successful configurations: {len([r for r in results if r.success_rate > 0])}")
        
        self.results = results
        return results
    
    def _run_benchmarks_with_threads(self, configs: List[Tuple], max_workers: int = None) -> List[BenchmarkResult]:
        """Run benchmarks using ThreadPoolExecutor with enhanced parallel processing."""
        if max_workers is None:
            max_workers = self.config.max_workers
        
        results = []
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all tasks
            future_to_config = {
                executor.submit(self._benchmark_single_config, ecc_type, word_length, error_pattern): 
                (ecc_type.__name__, word_length, error_pattern)
                for ecc_type, word_length, error_pattern in configs
            }
            
            # Collect results with enhanced progress tracking and performance monitoring
            completed = 0
            start_time = time.time()
            last_progress_time = start_time
            
            for future in as_completed(future_to_config):
                config = future_to_config[future]
                try:
                    result = future.result()
                    results.append(result)
                    completed += 1
                    progress = (completed / len(configs)) * 100
                    current_time = time.time()
                    elapsed_time = current_time - start_time
                    
                    # Enhanced progress reporting with timing estimates
                    if completed % max(1, len(configs) // 10) == 0 or completed == len(configs):  # Report every 10% or final
                        if completed > 0:
                            avg_time_per_config = elapsed_time / completed
                            remaining_configs = len(configs) - completed
                            estimated_remaining = avg_time_per_config * remaining_configs
                            
                            print(f"Progress: {progress:.1f}% - Completed: {config[0]} ({config[1]} bits, {config[2]} errors)")
                            print(f"  Elapsed: {elapsed_time:.1f}s, ETA: {estimated_remaining:.1f}s")
                        else:
                            print(f"Progress: {progress:.1f}% - Completed: {config[0]} ({config[1]} bits, {config[2]} errors)")
                    
                    last_progress_time = current_time
                    print(f"Progress: {progress:.1f}% - Completed: {config[0]} ({config[1]} bits, {config[2]} errors)")
                except Exception as e:
                    print(f"Error in benchmark {config}: {e}")
        
        return results
    
    def _run_benchmarks_with_processes_parallel(self, configs: List[Tuple], max_workers: int = None) -> List[BenchmarkResult]:
        """Run benchmarks using ProcessPoolExecutor for true parallelism with enhanced performance."""
        if max_workers is None:
            max_workers = self.config.max_workers
        
        # For multiprocessing, we need to serialize the work
        # Create work packages that can be pickled with enhanced configuration
        work_packages = []
        for i, (ecc_type, word_length, error_pattern) in enumerate(configs):
            work_packages.append({
                'id': i,
                'ecc_type_name': ecc_type.__name__,
                'word_length': word_length,
                'error_pattern': error_pattern,
                'trials_per_config': self.config.trials_per_config,
                'burst_length': self.config.burst_length,
                'random_error_prob': self.config.random_error_prob,
                'output_dir': 'results',  # Add output directory for incremental saving
                'measure_timing': self.config.measure_timing,
                'measure_memory': self.config.measure_memory
            })
        
        results = []
        with ProcessPoolExecutor(max_workers=max_workers) as executor:
            # Submit work packages
            future_to_work = {
                executor.submit(self._benchmark_worker, work_package): work_package
                for work_package in work_packages
            }
            
            # Collect results with progress tracking
            completed = 0
            for future in as_completed(future_to_work):
                work_package = future_to_work[future]
                try:
                    result = future.result()
                    results.append(result)
                    completed += 1
                    progress = (completed / len(work_packages)) * 100
                    print(f"Progress: {progress:.1f}% - Completed: {work_package['ecc_type_name']} ({work_package['word_length']} bits, {work_package['error_pattern']} errors)")
                except Exception as e:
                    print(f"Error in benchmark {work_package}: {e}")
        
        return results
    
    def _run_benchmarks_chunked(self, configs: List[Tuple], max_workers: int = None) -> List[BenchmarkResult]:
        """Run benchmarks in chunks to manage memory better with enhanced chunking."""
        if max_workers is None:
            max_workers = self.config.max_workers
        
        # Adaptive chunk size based on system resources
        memory_gb = psutil.virtual_memory().total / (1024**3)
        if memory_gb >= 8:
            chunk_size = max(1, len(configs) // (max_workers * 2))  # Smaller chunks for high memory
        else:
            chunk_size = max(1, len(configs) // max_workers)  # Standard chunking
        
        results = []
        
        print(f"Processing {len(configs)} configurations in chunks of {chunk_size}")
        
        for i in range(0, len(configs), chunk_size):
            chunk = configs[i:i + chunk_size]
            print(f"Processing chunk {i//chunk_size + 1}/{(len(configs) + chunk_size - 1)//chunk_size}")
            
            with ThreadPoolExecutor(max_workers=min(max_workers, len(chunk))) as executor:
                future_to_config = {
                    executor.submit(self._benchmark_single_config, ecc_type, word_length, error_pattern): 
                    (ecc_type.__name__, word_length, error_pattern)
                    for ecc_type, word_length, error_pattern in chunk
                }
                
                for future in as_completed(future_to_config):
                    config = future_to_config[future]
                    try:
                        result = future.result()
                        results.append(result)
                        print(f"Completed: {config[0]} ({config[1]} bits, {config[2]} errors)")
                    except Exception as e:
                        print(f"Error in benchmark {config}: {e}")
        
        return results
    
    @staticmethod
    def _benchmark_worker(work_package: Dict) -> BenchmarkResult:
        """Worker function for multiprocessing benchmarks."""
        # This function needs to be static and handle all the work itself
        # Import necessary modules in the worker process
        import random
        import time
        import statistics
        import sys
        from pathlib import Path
        
        # Add the src directory to the Python path for imports
        src_path = Path(__file__).parent
        if str(src_path) not in sys.path:
            sys.path.insert(0, str(src_path))
        
        from base_ecc import ECCBase
        
        # Log start of processing
        ecc_type_name = work_package['ecc_type_name']
        word_length = work_package['word_length']
        error_pattern = work_package['error_pattern']
        trials = work_package['trials_per_config']
        
        print(f"🔄 Worker starting: {ecc_type_name} ({word_length} bits, {error_pattern} errors) - {trials} trials")
        
        # Import ECC classes dynamically
        try:
            # Map ECC class names to their module names
            module_mapping = {
                'ParityECC': 'parity_ecc',
                'HammingSECDEDECC': 'hamming_secded_ecc',
                'BCHECC': 'bch_ecc',
                'ReedSolomonECC': 'reed_solomon_ecc',
                'CRCECC': 'crc_ecc',
                'GolayECC': 'golay_ecc',
                'PolarECC': 'polar_ecc',
                'RepetitionECC': 'repetition_ecc',
                'LDPCECC': 'ldpc_ecc',
                'TurboECC': 'turbo_ecc',
                'ConvolutionalECC': 'convolutional_ecc',
                'ExtendedHammingECC': 'extended_hamming_ecc',
                'ProductCodeECC': 'product_code_ecc',
                'ConcatenatedECC': 'concatenated_ecc',
                'ReedMullerECC': 'reed_muller_ecc',
                'FireCodeECC': 'fire_code_ecc',
                'SpatiallyCoupledLDPCECC': 'spatially_coupled_ldpc_ecc',
                'NonBinaryLDPCECC': 'non_binary_ldpc_ecc',
                'RaptorCodeECC': 'raptor_code_ecc',
                'CompositeECC': 'composite_ecc',
                'BurstErrorECC': 'burst_error_ecc',
                'SystemECC': 'system_ecc',
                'AdaptiveECC': 'adaptive_ecc',
                'ThreeDMemoryECC': 'three_d_memory_ecc',
                'PrimarySecondaryECC': 'primary_secondary_ecc',
                'CyclicECC': 'cyclic_ecc'
            }
            
            if ecc_type_name not in module_mapping:
                raise ValueError(f"Unknown ECC type: {ecc_type_name}")
            
            module_name = module_mapping[ecc_type_name]
            module = __import__(module_name, fromlist=[ecc_type_name])
            ecc_type = getattr(module, ecc_type_name)
        except (ImportError, AttributeError) as e:
            raise ValueError(f"Cannot import {ecc_type_name}: {e}")
        
        # Create ECC instance
        word_length = work_package['word_length']
        if ecc_type_name == 'BCHECC':
            # BCH only supports BCH(15,7,2) in this implementation
            from bch_ecc import BCHConfig
            ecc = ecc_type(BCHConfig(n=15, k=7, t=2))
        elif ecc_type_name == 'ReedSolomonECC':
            # Reed-Solomon needs a config parameter
            from reed_solomon_ecc import RSConfig
            if word_length <= 4: config = RSConfig(n=7, k=4)
            elif word_length <= 8: config = RSConfig(n=15, k=8)
            else: config = RSConfig(n=31, k=16)
            ecc = ecc_type(config)
        elif ecc_type_name == 'LDPCECC': 
            # LDPC uses default constructor
            ecc = ecc_type()
        elif ecc_type_name == 'TurboECC': 
            # Turbo needs data_length parameter
            ecc = ecc_type(data_length=word_length)
        elif ecc_type_name == 'ConvolutionalECC': 
            # Convolutional uses default constructor
            ecc = ecc_type()
        elif ecc_type_name == 'PolarECC': 
            # Polar only supports N=4, K=2 in this demo
            ecc = ecc_type(n=4, k=2)
        elif ecc_type_name == 'RepetitionECC': 
            # Repetition needs repetition factor
            if word_length <= 4: ecc = ecc_type(repetition_factor=3)
            elif word_length <= 8: ecc = ecc_type(repetition_factor=3)
            else: ecc = ecc_type(repetition_factor=3)
        elif ecc_type_name == 'CRCECC': 
            # CRC needs polynomial
            if word_length <= 4: ecc = ecc_type(polynomial=0x11)
            elif word_length <= 8: ecc = ecc_type(polynomial=0x11)
            else: ecc = ecc_type(polynomial=0x11)
        elif ecc_type_name == 'GolayECC': 
            # Golay uses default constructor
            ecc = ecc_type()
        elif ecc_type_name == 'ParityECC' or ecc_type_name == 'HammingSECDEDECC':
            # These use default constructor but can accept word_length
            ecc = ecc_type(word_length=word_length)
        elif ecc_type_name in ['ExtendedHammingECC', 'ProductCodeECC', 'ConcatenatedECC', 
                              'ReedMullerECC', 'SpatiallyCoupledLDPCECC', 
                              'NonBinaryLDPCECC', 'RaptorCodeECC', 'CompositeECC', 
                              'BurstErrorECC', 'SystemECC', 'AdaptiveECC', 
                              'PrimarySecondaryECC']:
            # These use default constructor but can accept word_length
            ecc = ecc_type(word_length=word_length)
        elif ecc_type_name == 'FireCodeECC':
            # FireCodeECC expects data_length parameter
            ecc = ecc_type(data_length=word_length)
        elif ecc_type_name == 'ThreeDMemoryECC':
            # ThreeDMemoryECC expects data_length parameter
            ecc = ecc_type(data_length=word_length)
        elif ecc_type_name == 'CyclicECC':
            # CyclicECC expects data_length parameter
            ecc = ecc_type(n=word_length*2, k=word_length, data_length=word_length)
        else: 
            # Fallback for unknown types
            ecc = ecc_type()
        
        # Run benchmark
        trials_per_config = work_package['trials_per_config']
        burst_length = work_package['burst_length']
        random_error_prob = work_package['random_error_prob']
        
        # Initialize counters
        correctable_errors = 0
        detected_errors = 0
        undetected_errors = 0
        encode_times = []
        decode_times = []
        
        for _ in range(trials_per_config):
            # Generate random data with appropriate size for each ECC type
            if ecc_type_name == 'BCHECC':
                # BCH(15,7,2) expects 7-bit data
                data = random.getrandbits(7)
            elif ecc_type_name == 'ReedSolomonECC':
                # Reed-Solomon may have specific data size requirements
                data = random.getrandbits(min(word_length, 8))
            elif ecc_type_name == 'LDPCECC':
                # LDPC data size depends on k parameter
                if word_length <= 4: data = random.getrandbits(4)
                elif word_length <= 8: data = random.getrandbits(8)
                else: data = random.getrandbits(16)
            elif ecc_type_name == 'TurboECC':
                # Turbo data size depends on k parameter
                if word_length <= 4: data = random.getrandbits(4)
                elif word_length <= 8: data = random.getrandbits(8)
                else: data = random.getrandbits(16)
            elif ecc_type_name == 'ConvolutionalECC':
                # Convolutional data size depends on k parameter
                if word_length <= 4: data = random.getrandbits(4)
                elif word_length <= 8: data = random.getrandbits(8)
                else: data = random.getrandbits(16)
            elif ecc_type_name == 'PolarECC':
                # Polar data size depends on k parameter
                if word_length <= 4: data = random.getrandbits(4)
                elif word_length <= 8: data = random.getrandbits(8)
                else: data = random.getrandbits(16)
            else:
                # For other ECC types, use the word_length as specified
                data = random.getrandbits(word_length)
            
            # Encode
            start_time = time.time()
            try:
                encoded = ecc.encode(data)
                encode_time = time.time() - start_time
                encode_times.append(encode_time)
            except Exception as e:
                print(f"Encode error for {ecc_type_name}: {e}")
                continue
            
            # Convert encoded to integer if it's not already
            if not isinstance(encoded, int):
                try:
                    encoded = int(encoded)
                except (ValueError, TypeError):
                    print(f"Could not convert encoded data to int for {ecc_type_name}")
                    continue
            
            # Get the bit length of the encoded data
            encoded_bits = encoded.bit_length()
            if encoded_bits == 0:
                encoded_bits = 1  # Handle case where encoded is 0
            
            # Inject errors based on pattern
            if error_pattern == 'single':
                # Inject single bit error
                bit_pos = random.randint(0, encoded_bits - 1)
                encoded = encoded ^ (1 << bit_pos)
            elif error_pattern == 'double':
                # Inject double bit errors
                for _ in range(2):
                    bit_pos = random.randint(0, encoded_bits - 1)
                    encoded = encoded ^ (1 << bit_pos)
            elif error_pattern == 'burst':
                # Inject burst errors
                start_pos = random.randint(0, max(0, encoded_bits - burst_length))
                for i in range(burst_length):
                    if start_pos + i < encoded_bits:
                        encoded = encoded ^ (1 << (start_pos + i))
            elif error_pattern == 'random':
                # Inject random errors with probability
                for i in range(encoded_bits):
                    if random.random() < random_error_prob:
                        encoded = encoded ^ (1 << i)
            
            # Decode
            start_time = time.time()
            try:
                decoded, error_type = ecc.decode(encoded)
                decode_time = time.time() - start_time
                decode_times.append(decode_time)
                
                # Count error types
                if error_type == 'corrected':
                    correctable_errors += 1
                elif error_type == 'detected':
                    detected_errors += 1
                elif error_type == 'undetected':
                    undetected_errors += 1
                    
            except Exception as e:
                print(f"Decode error for {ecc_type_name}: {e}")
                undetected_errors += 1
                continue
        
        # Calculate metrics
        total_trials = len(encode_times)
        if total_trials == 0:
            # Return empty result if no successful trials
            return BenchmarkResult(
                ecc_type=ecc_type_name,
                word_length=word_length,
                error_pattern=error_pattern,
                trials=0,
                correctable_errors=0,
                detected_errors=0,
                undetected_errors=0,
                encode_time_avg=0.0,
                decode_time_avg=0.0,
                total_time_avg=0.0,
                code_rate=0.0,
                overhead_ratio=0.0,
                correction_rate=0.0,
                detection_rate=0.0,
                success_rate=0.0,
                error_distribution={'corrected': 0, 'detected': 0, 'undetected': 0}
            )
        
        # Calculate averages
        encode_time_avg = statistics.mean(encode_times) if encode_times else 0.0
        decode_time_avg = statistics.mean(decode_times) if decode_times else 0.0
        total_time_avg = encode_time_avg + decode_time_avg
        
        # Calculate rates
        correction_rate = correctable_errors / total_trials
        detection_rate = (correctable_errors + detected_errors) / total_trials
        success_rate = (correctable_errors + detected_errors) / total_trials
        
        # Calculate code rate and overhead (simplified)
        try:
            original_size = word_length
            # Use the bit length of the encoded data
            encoded_size = encoded_bits if 'encoded_bits' in locals() else word_length
            code_rate = original_size / encoded_size
            overhead_ratio = (encoded_size - original_size) / original_size
        except:
            code_rate = 1.0
            overhead_ratio = 0.0
        
        # Create error distribution
        error_distribution = {
            'corrected': correctable_errors,
            'detected': detected_errors,
            'undetected': undetected_errors
        }
        
        result = BenchmarkResult(
            ecc_type=ecc_type_name,
            word_length=word_length,
            error_pattern=error_pattern,
            trials=total_trials,
            correctable_errors=correctable_errors,
            detected_errors=detected_errors,
            undetected_errors=undetected_errors,
            encode_time_avg=encode_time_avg,
            decode_time_avg=decode_time_avg,
            total_time_avg=total_time_avg,
            code_rate=code_rate,
            overhead_ratio=overhead_ratio,
            correction_rate=correction_rate,
            detection_rate=detection_rate,
            success_rate=success_rate,
            error_distribution=error_distribution
        )
        
        # Save result incrementally if output directory is provided
        output_dir = work_package.get('output_dir')
        if output_dir:
            try:
                # Import necessary modules for saving
                import json
                import pandas as pd
                from pathlib import Path
                
                output_path = Path(output_dir)
                output_path.mkdir(exist_ok=True)
                
                # Create benchmarks subdirectory for individual files
                benchmarks_dir = output_path / "benchmarks"
                try:
                    benchmarks_dir.mkdir(parents=True, exist_ok=True)
                except Exception as e:
                    print(f"Could not create benchmarks directory: {benchmarks_dir} ({e})")
                
                # Create individual result file name
                filename = f"{result.ecc_type}_{result.word_length}_{result.error_pattern}.json"
                individual_file = benchmarks_dir / filename
                
                # Convert result to dictionary
                result_dict = {
                    "ecc_type": result.ecc_type,
                    "word_length": result.word_length,
                    "error_pattern": result.error_pattern,
                    "trials": result.trials,
                    "correctable_errors": result.correctable_errors,
                    "detected_errors": result.detected_errors,
                    "undetected_errors": result.undetected_errors,
                    "encode_time_avg": result.encode_time_avg,
                    "decode_time_avg": result.decode_time_avg,
                    "total_time_avg": result.total_time_avg,
                    "code_rate": result.code_rate,
                    "overhead_ratio": result.overhead_ratio,
                    "correction_rate": result.correction_rate,
                    "detection_rate": result.detection_rate,
                    "success_rate": result.success_rate,
                    "error_distribution": result.error_distribution
                }
                
                # Save individual result
                with open(individual_file, 'w') as f:
                    json.dump(result_dict, f, indent=2)
                
                # Update aggregated results file
                aggregated_file = output_path / "benchmark_results.json"
                results_data = []
                for result_file in benchmarks_dir.glob("*.json"):
                    try:
                        with open(result_file, 'r') as f:
                            data = json.load(f)
                            results_data.append(data)
                    except (json.JSONDecodeError, FileNotFoundError):
                        continue
                
                with open(aggregated_file, 'w') as f:
                    json.dump(results_data, f, indent=2)
                
                # Update CSV file
                df = pd.DataFrame(results_data)
                df.to_csv(output_path / "benchmark_results.csv", index=False)
                
            except Exception as e:
                print(f"Warning: Could not save incremental result for {ecc_type_name}: {e}")
        
        return result
    
    def generate_summary(self) -> Dict[str, Any]:
        """
        Generate a summary of all benchmark results.
        
        Returns:
            Summary dictionary
        """
        if not self.results:
            return {}
        
        # Group results by ECC type
        ecc_summaries = {}
        for result in self.results:
            if result.ecc_type not in ecc_summaries:
                ecc_summaries[result.ecc_type] = []
            ecc_summaries[result.ecc_type].append(result)
        
        # Calculate overall statistics for each ECC type
        summary = {}
        for ecc_type, results in ecc_summaries.items():
            # Average performance across all configurations
            avg_correction_rate = statistics.mean([r.correction_rate for r in results])
            avg_detection_rate = statistics.mean([r.detection_rate for r in results])
            avg_success_rate = statistics.mean([r.success_rate for r in results])
            avg_code_rate = statistics.mean([r.code_rate for r in results])
            avg_overhead = statistics.mean([r.overhead_ratio for r in results])
            avg_encode_time = statistics.mean([r.encode_time_avg for r in results])
            avg_decode_time = statistics.mean([r.decode_time_avg for r in results])
            
            summary[ecc_type] = {
                "avg_correction_rate": avg_correction_rate,
                "avg_detection_rate": avg_detection_rate,
                "avg_success_rate": avg_success_rate,
                "avg_code_rate": avg_code_rate,
                "avg_overhead": avg_overhead,
                "avg_encode_time": avg_encode_time,
                "avg_decode_time": avg_decode_time,
                "configurations_tested": len(results)
            }
        
        return summary
    
    def save_results(self, output_dir: str = "results") -> None:
        """
        Save benchmark results to files.
        
        Args:
            output_dir: Directory to save results
        """
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        # Save detailed results as JSON
        results_data = []
        for result in self.results:
            results_data.append({
                "ecc_type": result.ecc_type,
                "word_length": result.word_length,
                "error_pattern": result.error_pattern,
                "trials": result.trials,
                "correctable_errors": result.correctable_errors,
                "detected_errors": result.detected_errors,
                "undetected_errors": result.undetected_errors,
                "encode_time_avg": result.encode_time_avg,
                "decode_time_avg": result.decode_time_avg,
                "total_time_avg": result.total_time_avg,
                "code_rate": result.code_rate,
                "overhead_ratio": result.overhead_ratio,
                "correction_rate": result.correction_rate,
                "detection_rate": result.detection_rate,
                "success_rate": result.success_rate,
                "error_distribution": result.error_distribution
            })
        
        with open(output_path / "benchmark_results.json", "w") as f:
            json.dump(results_data, f, indent=2)
        
        # Save summary
        summary = self.generate_summary()
        with open(output_path / "benchmark_summary.json", "w") as f:
            json.dump(summary, f, indent=2)
        
        # Save as CSV for easy analysis
        df = pd.DataFrame(results_data)
        df.to_csv(output_path / "benchmark_results.csv", index=False)
        
        print(f"Benchmark results saved to {output_path}")

    def save_incremental_result(self, result: BenchmarkResult, output_dir: str = "results") -> None:
        """
        Save a single benchmark result incrementally to individual JSON file.
        
        Args:
            result: Single benchmark result to save
            output_dir: Directory to save results
        """
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        # Create benchmarks subdirectory for individual files
        benchmarks_dir = output_path / "benchmarks"
        benchmarks_dir.mkdir(exist_ok=True)
        
        # Create individual result file name
        filename = f"{result.ecc_type}_{result.word_length}_{result.error_pattern}.json"
        individual_file = benchmarks_dir / filename
        
        # Convert result to dictionary
        result_dict = {
            "ecc_type": result.ecc_type,
            "word_length": result.word_length,
            "error_pattern": result.error_pattern,
            "trials": result.trials,
            "correctable_errors": result.correctable_errors,
            "detected_errors": result.detected_errors,
            "undetected_errors": result.undetected_errors,
            "encode_time_avg": result.encode_time_avg,
            "decode_time_avg": result.decode_time_avg,
            "total_time_avg": result.total_time_avg,
            "code_rate": result.code_rate,
            "overhead_ratio": result.overhead_ratio,
            "correction_rate": result.correction_rate,
            "detection_rate": result.detection_rate,
            "success_rate": result.success_rate,
            "error_distribution": result.error_distribution
        }
        
        # Save individual result
        with open(individual_file, 'w') as f:
            json.dump(result_dict, f, indent=2)
        
        # Update aggregated results file
        self._update_aggregated_results(output_path)
        
        # Update CSV file
        self._update_csv_file(output_path)
        
        # Update summary
        self._update_summary_incremental(output_path)

    def _update_aggregated_results(self, output_path: Path) -> None:
        """
        Update the aggregated benchmark_results.json file from individual files.
        
        Args:
            output_path: Output directory path
        """
        benchmarks_dir = output_path / "benchmarks"
        aggregated_file = output_path / "benchmark_results.json"
        
        if not benchmarks_dir.exists():
            return
        
        # Collect all individual result files
        results_data = []
        for result_file in benchmarks_dir.glob("*.json"):
            try:
                with open(result_file, 'r') as f:
                    result_data = json.load(f)
                    results_data.append(result_data)
            except (json.JSONDecodeError, FileNotFoundError) as e:
                print(f"Warning: Could not read {result_file}: {e}")
        
        # Save aggregated results
        with open(aggregated_file, 'w') as f:
            json.dump(results_data, f, indent=2)

    def _update_csv_file(self, output_path: Path) -> None:
        """
        Update the CSV file from individual JSON files.
        
        Args:
            output_path: Output directory path
        """
        benchmarks_dir = output_path / "benchmarks"
        csv_file = output_path / "benchmark_results.csv"
        
        if not benchmarks_dir.exists():
            return
        
        # Collect all individual result files
        results_data = []
        for result_file in benchmarks_dir.glob("*.json"):
            try:
                with open(result_file, 'r') as f:
                    result_data = json.load(f)
                    results_data.append(result_data)
            except (json.JSONDecodeError, FileNotFoundError) as e:
                print(f"Warning: Could not read {result_file}: {e}")
        
        # Save as CSV
        df = pd.DataFrame(results_data)
        df.to_csv(csv_file, index=False)

    def _update_summary_incremental(self, output_path: Path) -> None:
        """
        Update summary file incrementally from individual JSON files.
        
        Args:
            output_path: Output directory path
        """
        benchmarks_dir = output_path / "benchmarks"
        summary_file = output_path / "benchmark_summary.json"
        
        if not benchmarks_dir.exists():
            return
        
        # Collect all individual result files
        results_data = []
        for result_file in benchmarks_dir.glob("*.json"):
            try:
                with open(result_file, 'r') as f:
                    result_data = json.load(f)
                    results_data.append(result_data)
            except (json.JSONDecodeError, FileNotFoundError) as e:
                print(f"Warning: Could not read {result_file}: {e}")
        
        # Convert to BenchmarkResult objects for summary generation
        results = []
        for result_data in results_data:
            result = BenchmarkResult(
                ecc_type=result_data['ecc_type'],
                word_length=result_data['word_length'],
                error_pattern=result_data['error_pattern'],
                trials=result_data['trials'],
                correctable_errors=result_data['correctable_errors'],
                detected_errors=result_data['detected_errors'],
                undetected_errors=result_data['undetected_errors'],
                encode_time_avg=result_data['encode_time_avg'],
                decode_time_avg=result_data['decode_time_avg'],
                total_time_avg=result_data['total_time_avg'],
                code_rate=result_data['code_rate'],
                overhead_ratio=result_data['overhead_ratio'],
                correction_rate=result_data['correction_rate'],
                detection_rate=result_data['detection_rate'],
                success_rate=result_data['success_rate'],
                error_distribution=result_data['error_distribution']
            )
            results.append(result)
        
        # Temporarily set results to generate summary
        original_results = self.results
        self.results = results
        
        # Generate and save summary
        summary = self.generate_summary()
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)
        
        # Restore original results
        self.results = original_results

    def get_completion_status(self, output_dir: str = "results") -> Dict[str, Any]:
        """
        Get the completion status of benchmark configurations from individual files.
        
        Args:
            output_dir: Directory containing results
            
        Returns:
            Dictionary with completion statistics
        """
        output_path = Path(output_dir)
        benchmarks_dir = output_path / "benchmarks"
        
        if not benchmarks_dir.exists():
            return {
                "total_configs": len(self.config.ecc_types) * len(self.config.word_lengths) * len(self.config.error_patterns),
                "completed_configs": 0,
                "completion_percentage": 0.0,
                "missing_configs": []
            }
        
        # Count individual result files
        completed_configs = set()
        for result_file in benchmarks_dir.glob("*.json"):
            try:
                with open(result_file, 'r') as f:
                    result_data = json.load(f)
                    config_key = (
                        result_data.get('ecc_type', ''),
                        result_data.get('word_length', 0),
                        result_data.get('error_pattern', '')
                    )
                    completed_configs.add(config_key)
            except (json.JSONDecodeError, FileNotFoundError):
                continue
        
        total_configs = len(self.config.ecc_types) * len(self.config.word_lengths) * len(self.config.error_patterns)
        completed_count = len(completed_configs)
        
        # Find missing configurations
        missing_configs = []
        for ecc_type in self.config.ecc_types:
            for word_length in self.config.word_lengths:
                for error_pattern in self.config.error_patterns:
                    config_key = (ecc_type.__name__, word_length, error_pattern)
                    if config_key not in completed_configs:
                        missing_configs.append(f"{ecc_type.__name__} ({word_length} bits, {error_pattern} errors)")
        
        return {
            "total_configs": total_configs,
            "completed_configs": completed_count,
            "completion_percentage": (completed_count / total_configs) * 100.0,
            "missing_configs": missing_configs
        }

    def _load_existing_results(self) -> List[BenchmarkResult]:
        """Load existing benchmark results from individual JSON files."""
        output_path = Path("results")
        benchmarks_dir = output_path / "benchmarks"
        
        if not benchmarks_dir.exists():
            return []
        
        results = []
        for result_file in benchmarks_dir.glob("*.json"):
            try:
                with open(result_file, 'r') as f:
                    result_data = json.load(f)
                    
                    result = BenchmarkResult(
                        ecc_type=result_data['ecc_type'],
                        word_length=result_data['word_length'],
                        error_pattern=result_data['error_pattern'],
                        trials=result_data['trials'],
                        correctable_errors=result_data['correctable_errors'],
                        detected_errors=result_data['detected_errors'],
                        undetected_errors=result_data['undetected_errors'],
                        encode_time_avg=result_data['encode_time_avg'],
                        decode_time_avg=result_data['decode_time_avg'],
                        total_time_avg=result_data['total_time_avg'],
                        code_rate=result_data['code_rate'],
                        overhead_ratio=result_data['overhead_ratio'],
                        correction_rate=result_data['correction_rate'],
                        detection_rate=result_data['detection_rate'],
                        success_rate=result_data['success_rate'],
                        error_distribution=result_data['error_distribution']
                    )
                    results.append(result)
            except (json.JSONDecodeError, FileNotFoundError) as e:
                print(f"Warning: Could not load {result_file}: {e}")
        
        return results


def create_default_config() -> BenchmarkConfig:
    """
    Create a default benchmark configuration.
    
    Returns:
        Default benchmark configuration
    """
    return BenchmarkConfig(
        ecc_types=[
            ParityECC,
            HammingSECDEDECC,
            BCHECC,
            ReedSolomonECC,
            CRCECC,
            GolayECC,
            RepetitionECC,
            LDPCECC,
            TurboECC,
            ConvolutionalECC,
            PolarECC,
            ExtendedHammingECC,
            ProductCodeECC,
            ConcatenatedECC,
            ReedMullerECC,
            FireCodeECC,
            SpatiallyCoupledLDPCECC,
            NonBinaryLDPCECC,
            RaptorCodeECC
        ],
        word_lengths=[4, 8, 16, 32],
        error_patterns=["single", "double", "burst", "random"],
        trials_per_config=10000,
        burst_length=3,
        random_error_prob=0.01,
        measure_timing=True,
        max_workers=4
    )


def main() -> None:
    """Run the ECC benchmark suite with enhanced parallel processing."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Enhanced ECC Benchmark Suite")
    parser.add_argument("--parallel-method", choices=["auto", "threads", "processes", "chunked"], 
                       default="auto", help="Parallel processing method")
    parser.add_argument("--workers", type=int, help="Number of worker processes")
    parser.add_argument("--adaptive", action="store_true", default=True, help="Use adaptive worker count")
    parser.add_argument("--overwrite", action="store_true", help="Overwrite existing results")
    parser.add_argument("--trials", type=int, default=10000, help="Trials per configuration")
    
    args = parser.parse_args()
    
    config = create_default_config()
    config.trials_per_config = args.trials
    
    suite = ECCBenchmarkSuite(config)
    suite.set_parallel_method(args.parallel_method)
    suite.set_adaptive_workers(args.adaptive)
    suite.set_overwrite_existing(args.overwrite)
    
    print("🚀 Enhanced ECC Benchmark Suite with Parallel Processing")
    print("=" * 60)
    print(f"📊 ECC Types: {len(config.ecc_types)}")
    print(f"📏 Word Lengths: {config.word_lengths}")
    print(f"⚠️  Error Patterns: {config.error_patterns}")
    print(f"🔄 Trials per config: {config.trials_per_config}")
    print(f"🎯 Total configurations: {len(config.ecc_types) * len(config.word_lengths) * len(config.error_patterns)}")
    print(f"⚡ Parallel method: {args.parallel_method}")
    print(f"🔧 Adaptive workers: {args.adaptive}")
    print()
    
    # Show system capabilities
    cpu_count = multiprocessing.cpu_count()
    memory_gb = psutil.virtual_memory().total / (1024**3)
    print(f"💻 System: {cpu_count} CPUs, {memory_gb:.1f} GB RAM")
    
    results = suite.run_benchmarks()
    suite.save_results()
    
    # Print enhanced summary
    summary = suite.generate_summary()
    print("\n📊 Enhanced Benchmark Summary:")
    print("==================")
    for ecc_type, stats in summary.items():
        print(f"{ecc_type}:")
        print(f"  Avg Correction Rate: {stats['avg_correction_rate']:.2f}%")
        print(f"  Avg Detection Rate: {stats['avg_detection_rate']:.2f}%")
        print(f"  Avg Success Rate: {stats['avg_success_rate']:.2f}%")
        print(f"  Avg Code Rate: {stats['avg_code_rate']:.3f}")
        print(f"  Avg Overhead: {stats['avg_overhead']:.3f}")
        print(f"  Avg Encode Time: {stats['avg_encode_time']*1000:.3f} ms")
        print(f"  Avg Decode Time: {stats['avg_decode_time']*1000:.3f} ms")
        print()


if __name__ == "__main__":
    main() 