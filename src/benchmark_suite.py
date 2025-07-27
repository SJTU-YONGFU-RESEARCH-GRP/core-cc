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
        
    def set_overwrite_existing(self, overwrite: bool = True) -> None:
        """Set whether to overwrite existing benchmark results."""
        self._overwrite_existing = overwrite
        
    def _check_existing_results(self, output_dir: str = "results") -> Dict[str, bool]:
        """
        Check which benchmark configurations already have results.
        
        Args:
            output_dir: Directory to check for existing results
            
        Returns:
            Dictionary mapping (ecc_type, word_length, error_pattern) to existence status
        """
        existing_results = {}
        results_file = Path(output_dir) / "benchmark_results.json"
        
        if not results_file.exists():
            # No existing results, all configurations need to be run
            for ecc_type in self.config.ecc_types:
                for word_length in self.config.word_lengths:
                    for error_pattern in self.config.error_patterns:
                        key = (ecc_type.__name__, word_length, error_pattern)
                        existing_results[key] = False
            return existing_results
        
        try:
            # Load existing results
            with open(results_file, 'r') as f:
                data = json.load(f)
            
            # Handle both list format and object format
            results_list = []
            if isinstance(data, list):
                results_list = data
            elif isinstance(data, dict):
                results_list = data.get('results', [])
            
            # Create set of existing configurations
            existing_configs = set()
            for result in results_list:
                if isinstance(result, dict):
                    config_key = (
                        result.get('ecc_type', ''),
                        result.get('word_length', 0),
                        result.get('error_pattern', '')
                    )
                    existing_configs.add(config_key)
            
            # Check which configurations need to be run
            for ecc_type in self.config.ecc_types:
                for word_length in self.config.word_lengths:
                    for error_pattern in self.config.error_patterns:
                        key = (ecc_type.__name__, word_length, error_pattern)
                        existing_results[key] = key in existing_configs
            
        except (json.JSONDecodeError, KeyError, FileNotFoundError):
            # If there's an error reading existing results, assume none exist
            for ecc_type in self.config.ecc_types:
                for word_length in self.config.word_lengths:
                    for error_pattern in self.config.error_patterns:
                        key = (ecc_type.__name__, word_length, error_pattern)
                        existing_results[key] = False
        
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
            # Turbo code parameters - TurboECC doesn't accept n/k parameters
            return TurboECC()
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
        if self._run_benchmarks_with_processes:
            print(f"🔄 Using ProcessPoolExecutor with {self.config.max_workers} workers")
            results = self._run_benchmarks_with_processes_parallel(configs)
        elif self._use_chunked_processing:
            print(f"📦 Using chunked processing with {self.config.max_workers} workers")
            results = self._run_benchmarks_chunked(configs)
        else:
            print(f"🧵 Using ThreadPoolExecutor with {self.config.max_workers} workers")
            results = self._run_benchmarks_with_threads(configs)
        
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
    
    def _run_benchmarks_with_threads(self, configs: List[Tuple]) -> List[BenchmarkResult]:
        """Run benchmarks using ThreadPoolExecutor."""
        results = []
        with ThreadPoolExecutor(max_workers=self.config.max_workers) as executor:
            # Submit all tasks
            future_to_config = {
                executor.submit(self._benchmark_single_config, ecc_type, word_length, error_pattern): 
                (ecc_type.__name__, word_length, error_pattern)
                for ecc_type, word_length, error_pattern in configs
            }
            
            # Collect results with progress tracking
            completed = 0
            for future in as_completed(future_to_config):
                config = future_to_config[future]
                try:
                    result = future.result()
                    results.append(result)
                    completed += 1
                    progress = (completed / len(configs)) * 100
                    print(f"Progress: {progress:.1f}% - Completed: {config[0]} ({config[1]} bits, {config[2]} errors)")
                except Exception as e:
                    print(f"Error in benchmark {config}: {e}")
        
        return results
    
    def _run_benchmarks_with_processes_parallel(self, configs: List[Tuple]) -> List[BenchmarkResult]:
        """Run benchmarks using ProcessPoolExecutor for true parallelism."""
        # For multiprocessing, we need to serialize the work
        # Create work packages that can be pickled
        work_packages = []
        for i, (ecc_type, word_length, error_pattern) in enumerate(configs):
            work_packages.append({
                'id': i,
                'ecc_type_name': ecc_type.__name__,
                'word_length': word_length,
                'error_pattern': error_pattern,
                'trials_per_config': self.config.trials_per_config,
                'burst_length': self.config.burst_length,
                'random_error_prob': self.config.random_error_prob
            })
        
        results = []
        with ProcessPoolExecutor(max_workers=self.config.max_workers) as executor:
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
    
    def _run_benchmarks_chunked(self, configs: List[Tuple]) -> List[BenchmarkResult]:
        """Run benchmarks in chunks to manage memory better."""
        chunk_size = max(1, len(configs) // self.config.max_workers)
        results = []
        
        print(f"Processing {len(configs)} configurations in chunks of {chunk_size}")
        
        for i in range(0, len(configs), chunk_size):
            chunk = configs[i:i + chunk_size]
            print(f"Processing chunk {i//chunk_size + 1}/{(len(configs) + chunk_size - 1)//chunk_size}")
            
            with ThreadPoolExecutor(max_workers=min(self.config.max_workers, len(chunk))) as executor:
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
                'ConvolutionalECC': 'convolutional_ecc'
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
            # Turbo uses default constructor
            ecc = ecc_type()
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
            # These use default constructor
            ecc = ecc_type()
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
        
        return BenchmarkResult(
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
            PolarECC
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
    """Run the ECC benchmark suite."""
    config = create_default_config()
    suite = ECCBenchmarkSuite(config)
    
    print("ECC Benchmark Suite")
    print("==================")
    print(f"ECC Types: {len(config.ecc_types)}")
    print(f"Word Lengths: {config.word_lengths}")
    print(f"Error Patterns: {config.error_patterns}")
    print(f"Trials per config: {config.trials_per_config}")
    print(f"Total configurations: {len(config.ecc_types) * len(config.word_lengths) * len(config.error_patterns)}")
    print()
    
    results = suite.run_benchmarks()
    suite.save_results()
    
    # Print summary
    summary = suite.generate_summary()
    print("\nBenchmark Summary:")
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