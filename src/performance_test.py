#!/usr/bin/env python3
"""
Performance Test Script for Enhanced ECC Analysis Framework

This script demonstrates the performance benefits of different parallel processing modes.
"""

import time
import multiprocessing
import psutil
from pathlib import Path
import sys

# Add current directory to path
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_suite import create_default_config, ECCBenchmarkSuite


def test_performance_modes():
    """Test different performance modes concurrently and compare execution times."""
    from concurrent.futures import ThreadPoolExecutor, as_completed
    
    print("Enhanced ECC Analysis Framework - Performance Test")
    print("=" * 60)
    
    # System information
    cpu_count = multiprocessing.cpu_count()
    memory_gb = psutil.virtual_memory().total / (1024**3)
    print(f"System: {cpu_count} CPU cores, {memory_gb:.1f} GB RAM")
    print()
    
    # Create a smaller config for testing
    config = create_default_config()
    config.ecc_types = config.ecc_types[:2]  # Test only first 2 ECC types
    config.word_lengths = [4]  # Test only 1 word length
    config.error_patterns = ['single']  # Test only 1 error pattern
    config.trials_per_config = 500  # Reduced trials for faster testing
    
    total_configs = len(config.ecc_types) * len(config.word_lengths) * len(config.error_patterns)
    print(f"Testing {total_configs} configurations with {config.trials_per_config} trials each")
    print("Running all performance tests concurrently...")
    print()
    
    # Define test configurations
    test_configs = [
        {
            'name': 'Single-threaded',
            'max_workers': 1,
            'use_processes': False,
            'use_chunked': False
        },
        {
            'name': 'Multi-threaded',
            'max_workers': min(4, cpu_count),
            'use_processes': False,
            'use_chunked': False
        },
        {
            'name': 'Multi-processed',
            'max_workers': min(4, cpu_count),
            'use_processes': True,
            'use_chunked': False
        },
        {
            'name': 'Chunked processing',
            'max_workers': min(4, cpu_count),
            'use_processes': False,
            'use_chunked': True
        }
    ]
    
    # Run all tests concurrently using ThreadPoolExecutor
    results = {}
    
    def run_single_test(test_config):
        """Run a single performance test."""
        name = test_config['name']
        print(f"🚀 Starting {name} test...")
        
        # Create a copy of config for this test
        test_config_copy = create_default_config()
        test_config_copy.ecc_types = config.ecc_types
        test_config_copy.word_lengths = config.word_lengths
        test_config_copy.error_patterns = config.error_patterns
        test_config_copy.trials_per_config = config.trials_per_config
        test_config_copy.max_workers = test_config['max_workers']
        
        suite = ECCBenchmarkSuite(test_config_copy)
        suite._run_benchmarks_with_processes = test_config['use_processes']
        suite._use_chunked_processing = test_config['use_chunked']
        
        # Suppress the internal progress output from benchmark suite
        import io
        import sys
        old_stdout = sys.stdout
        sys.stdout = io.StringIO()
        
        try:
            start_time = time.time()
            suite.run_benchmarks()
            execution_time = time.time() - start_time
            print(f"✅ {name} completed in {execution_time:.2f}s")
            return name, execution_time, None
        except Exception as e:
            print(f"❌ {name} failed: {e}")
            return name, None, str(e)
        finally:
            sys.stdout = old_stdout
    
    # Run tests concurrently
    with ThreadPoolExecutor(max_workers=len(test_configs)) as executor:
        # Submit all tests
        future_to_test = {
            executor.submit(run_single_test, test_config): test_config['name']
            for test_config in test_configs
        }
        
        # Collect results as they complete
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
    
    print("\n" + "=" * 60)
    print("Performance Test Results")
    print("=" * 60)
    
    # Find the baseline (single-threaded)
    baseline_time = None
    for name, result in results.items():
        if 'Single-threaded' in name and result['time'] is not None:
            baseline_time = result['time']
            break
    
    # Display results
    for name, result in results.items():
        if result['error']:
            print(f"{name:20} FAILED: {result['error']}")
        else:
            time_taken = result['time']
            print(f"{name:20} {time_taken:.2f}s", end="")
            if baseline_time and baseline_time > 0:
                speedup = baseline_time / time_taken
                print(f" ({speedup:.1f}x speedup)")
            else:
                print()
    
    print()
    
    # Performance comparison
    if baseline_time:
        print("Performance Comparison")
        print("=" * 60)
        print(f"Baseline (Single-threaded): {baseline_time:.2f}s")
        print()
        
        for name, result in results.items():
            if result['time'] and 'Single-threaded' not in name:
                speedup = baseline_time / result['time']
                print(f"{name:20} {speedup:.1f}x speedup")
    
    print()
    
    # Memory usage comparison
    print("Memory Usage Analysis")
    print("=" * 60)
    process = psutil.Process()
    memory_mb = process.memory_info().rss / (1024 * 1024)
    print(f"Current memory usage: {memory_mb:.1f} MB")
    print()
    
    # Recommendations
    print("Recommendations")
    print("=" * 60)
    
    # Find best performing method
    best_method = None
    best_time = float('inf')
    
    for name, result in results.items():
        if result['time'] and result['time'] < best_time:
            best_time = result['time']
            best_method = name
    
    if best_method:
        print(f"✓ Best performing method: {best_method}")
    
    if cpu_count >= 4:
        print("✓ Multi-threading recommended for I/O-bound operations")
        if any('Multi-processed' in name and results[name]['time'] for name in results):
            print("✓ Multi-processing recommended for CPU-intensive operations")
    else:
        print("⚠ Limited CPU cores - single-threaded may be optimal")
    
    if memory_gb < 4:
        print("⚠ Limited memory - consider using --chunked option")
    else:
        print("✓ Sufficient memory for parallel processing")
    
    print()
    print("For production use:")
    print("- Use --use-processes for CPU-intensive workloads")
    print("- Use --workers N to specify optimal worker count")
    print("- Use --chunked for memory-constrained environments")


def test_scalability():
    """Test scalability with different worker counts."""
    print("Scalability Test")
    print("=" * 60)
    
    # Create a small config
    config = create_default_config()
    config.ecc_types = config.ecc_types[:2]
    config.word_lengths = [4]
    config.error_patterns = ['single']
    config.trials_per_config = 500
    
    cpu_count = multiprocessing.cpu_count()
    worker_counts = [1, 2, 4, min(8, cpu_count)]
    
    print(f"Testing scalability with {len(config.ecc_types)} ECC types")
    print(f"Worker counts to test: {worker_counts}")
    print()
    
    results = {}
    
    for workers in worker_counts:
        print(f"Testing with {workers} workers...")
        config.max_workers = workers
        suite = ECCBenchmarkSuite(config)
        
        start_time = time.time()
        suite.run_benchmarks()
        execution_time = time.time() - start_time
        
        results[workers] = execution_time
        print(f"  Time: {execution_time:.2f}s")
    
    print()
    print("Scalability Results:")
    print("-" * 40)
    baseline = results[1]
    for workers, time_taken in results.items():
        speedup = baseline / time_taken
        efficiency = speedup / workers * 100
        print(f"{workers} workers: {time_taken:.2f}s ({speedup:.1f}x speedup, {efficiency:.0f}% efficiency)")


def main():
    """Main entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Performance test for ECC analysis framework")
    parser.add_argument('--scalability', action='store_true',
                       help='Run scalability test')
    
    args = parser.parse_args()
    
    if args.scalability:
        test_scalability()
    else:
        test_performance_modes()


if __name__ == "__main__":
    main() 