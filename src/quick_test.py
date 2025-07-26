#!/usr/bin/env python3
"""
Quick Test Script for Enhanced ECC Analysis Framework

This script runs a very small benchmark to quickly demonstrate parallel processing capabilities.
"""

import time
import multiprocessing
import psutil
from pathlib import Path
import sys

# Add current directory to path
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_suite import create_default_config, ECCBenchmarkSuite


def quick_performance_test():
    """Run a quick performance test with minimal configuration."""
    print("Quick ECC Performance Test")
    print("=" * 40)
    
    # System information
    cpu_count = multiprocessing.cpu_count()
    memory_gb = psutil.virtual_memory().total / (1024**3)
    print(f"System: {cpu_count} CPU cores, {memory_gb:.1f} GB RAM")
    print()
    
    # Create minimal config for quick testing
    config = create_default_config()
    config.ecc_types = config.ecc_types[:2]  # Only 2 ECC types
    config.word_lengths = [4]  # Only 1 word length
    config.error_patterns = ['single']  # Only 1 error pattern
    config.trials_per_config = 100  # Very few trials
    
    total_configs = len(config.ecc_types) * len(config.word_lengths) * len(config.error_patterns)
    print(f"Quick test: {total_configs} configurations with {config.trials_per_config} trials each")
    print()
    
    # Test configurations
    test_configs = [
        {
            'name': 'Single-threaded',
            'max_workers': 1,
            'use_processes': False,
            'use_chunked': False
        },
        {
            'name': 'Multi-threaded',
            'max_workers': min(2, cpu_count),
            'use_processes': False,
            'use_chunked': False
        }
    ]
    
    # Run tests concurrently
    results = {}
    
    print("Running tests concurrently...")
    
    def run_quick_test(test_config):
        """Run a single quick performance test."""
        name = test_config['name']
        
        # Create config copy
        test_config_copy = create_default_config()
        test_config_copy.ecc_types = config.ecc_types
        test_config_copy.word_lengths = config.word_lengths
        test_config_copy.error_patterns = config.error_patterns
        test_config_copy.trials_per_config = config.trials_per_config
        test_config_copy.max_workers = test_config['max_workers']
        
        suite = ECCBenchmarkSuite(test_config_copy)
        suite._run_benchmarks_with_processes = test_config['use_processes']
        suite._use_chunked_processing = test_config['use_chunked']
        
        try:
            start_time = time.time()
            suite.run_benchmarks()
            execution_time = time.time() - start_time
            print(f"  ✓ {name} completed in {execution_time:.3f}s")
            return name, execution_time, None
        except Exception as e:
            print(f"  ✗ {name} failed: {e}")
            return name, None, str(e)
    
    # Run tests concurrently
    from concurrent.futures import ThreadPoolExecutor, as_completed
    
    with ThreadPoolExecutor(max_workers=len(test_configs)) as executor:
        future_to_test = {
            executor.submit(run_quick_test, test_config): test_config['name']
            for test_config in test_configs
        }
        
        for future in as_completed(future_to_test):
            test_name = future_to_test[future]
            try:
                name, execution_time, error = future.result()
                if error:
                    results[name] = {'time': None, 'error': error}
                else:
                    results[name] = {'time': execution_time, 'error': None}
            except Exception as e:
                results[test_name] = {'time': None, 'error': str(e)}
    
    print()
    print("Quick Test Results:")
    print("-" * 40)
    
    baseline_time = None
    for name, result in results.items():
        if result['error']:
            print(f"{name:15} FAILED: {result['error']}")
        else:
            time_taken = result['time']
            print(f"{name:15} {time_taken:.3f}s", end="")
            if 'Single-threaded' in name:
                baseline_time = time_taken
                print(" (baseline)")
            elif baseline_time and baseline_time > 0:
                speedup = baseline_time / time_taken
                print(f" ({speedup:.1f}x speedup)")
            else:
                print()
    
    print()
    print("Framework is ready for full testing!")
    print("Run 'python performance_test.py' for comprehensive analysis.")


def main():
    """Main entry point."""
    quick_performance_test()


if __name__ == "__main__":
    main() 