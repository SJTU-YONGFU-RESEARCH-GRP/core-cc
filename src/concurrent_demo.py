#!/usr/bin/env python3
"""
Concurrent Performance Test Demo

This script demonstrates the concurrent execution of different performance modes
with clear visual indicators showing all tests starting simultaneously.
"""

import time
import multiprocessing
import psutil
from pathlib import Path
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

# Add current directory to path
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_suite import create_default_config, ECCBenchmarkSuite


def concurrent_performance_demo():
    """Demonstrate concurrent execution of different performance modes."""
    print("🚀 Enhanced ECC Analysis Framework - Concurrent Performance Demo")
    print("=" * 70)
    
    # System information
    cpu_count = multiprocessing.cpu_count()
    memory_gb = psutil.virtual_memory().total / (1024**3)
    print(f"💻 System: {cpu_count} CPU cores, {memory_gb:.1f} GB RAM")
    print()
    
    # Create minimal config for quick demonstration
    config = create_default_config()
    config.ecc_types = config.ecc_types[:2]  # Only 2 ECC types
    config.word_lengths = [4]  # Only 1 word length
    config.error_patterns = ['single']  # Only 1 error pattern
    config.trials_per_config = 200  # Very few trials for quick demo
    
    total_configs = len(config.ecc_types) * len(config.word_lengths) * len(config.error_patterns)
    print(f"📊 Demo: {total_configs} configurations with {config.trials_per_config} trials each")
    print()
    
    # Define test configurations with different parallel modes
    test_configs = [
        {
            'name': 'Single-threaded',
            'max_workers': 1,
            'use_processes': False,
            'use_chunked': False,
            'emoji': '🔄'
        },
        {
            'name': 'Multi-threaded',
            'max_workers': min(2, cpu_count),
            'use_processes': False,
            'use_chunked': False,
            'emoji': '🧵'
        },
        {
            'name': 'Chunked processing',
            'max_workers': min(2, cpu_count),
            'use_processes': False,
            'use_chunked': True,
            'emoji': '📦'
        }
    ]
    
    print("🎯 Starting ALL tests concurrently...")
    print("   (You should see all tests start at the same time)")
    print()
    
    # Run all tests concurrently
    results = {}
    
    def run_demo_test(test_config):
        """Run a single demo test with visual indicators."""
        name = test_config['name']
        emoji = test_config['emoji']
        
        print(f"{emoji} {name} test STARTED at {time.strftime('%H:%M:%S')}")
        
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
        
        # Suppress internal progress output
        import io
        import sys
        old_stdout = sys.stdout
        sys.stdout = io.StringIO()
        
        try:
            start_time = time.time()
            suite.run_benchmarks()
            execution_time = time.time() - start_time
            print(f"✅ {name} test COMPLETED at {time.strftime('%H:%M:%S')} in {execution_time:.3f}s")
            return name, execution_time, None
        except Exception as e:
            print(f"❌ {name} test FAILED: {e}")
            return name, None, str(e)
        finally:
            sys.stdout = old_stdout
    
    # Run tests concurrently
    with ThreadPoolExecutor(max_workers=len(test_configs)) as executor:
        # Submit all tests at once
        future_to_test = {
            executor.submit(run_demo_test, test_config): test_config['name']
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
    
    print()
    print("📈 Demo Results Summary:")
    print("=" * 50)
    
    # Find baseline
    baseline_time = None
    for name, result in results.items():
        if 'Single-threaded' in name and result['time'] is not None:
            baseline_time = result['time']
            break
    
    # Display results
    for name, result in results.items():
        if result['error']:
            print(f"❌ {name:20} FAILED: {result['error']}")
        else:
            time_taken = result['time']
            print(f"✅ {name:20} {time_taken:.3f}s", end="")
            if baseline_time and baseline_time > 0 and 'Single-threaded' not in name:
                speedup = baseline_time / time_taken
                print(f" ({speedup:.1f}x speedup)")
            else:
                print(" (baseline)")
    
    print()
    print("🎉 Concurrent execution demonstration completed!")
    print()
    print("💡 Key observations:")
    print("   • All tests started simultaneously")
    print("   • Different parallel modes show different performance")
    print("   • Threading provides speedup for I/O-bound operations")
    print()
    print("🚀 For full analysis, run: python performance_test.py")


def main():
    """Main entry point."""
    concurrent_performance_demo()


if __name__ == "__main__":
    main() 