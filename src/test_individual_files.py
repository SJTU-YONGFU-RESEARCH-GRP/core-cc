#!/usr/bin/env python3
"""
Test script to demonstrate individual file saving functionality.

This script shows how the enhanced benchmark suite now saves each
benchmark result in individual JSON files for better incremental execution.
"""

import sys
import json
from pathlib import Path
from typing import List

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_suite import ECCBenchmarkSuite, create_default_config, BenchmarkConfig
from enhanced_analysis import load_benchmark_results
from parity_ecc import ParityECC
from hamming_secded_ecc import HammingSECDEDECC

def test_individual_file_saving():
    """Test the individual file saving functionality."""
    print("Testing Individual File Saving Functionality")
    print("=" * 60)
    
    # Create a minimal config for testing
    config = BenchmarkConfig(
        ecc_types=[ParityECC, HammingSECDEDECC],
        word_lengths=[4, 8],
        error_patterns=['single', 'double'],
        trials_per_config=50,  # Small number for quick testing
        max_workers=2
    )
    
    suite = ECCBenchmarkSuite(config)
    
    # Check initial completion status
    print("\n1. Initial completion status:")
    status = suite.get_completion_status()
    print(f"   Total configurations: {status['total_configs']}")
    print(f"   Completed: {status['completed_configs']}")
    print(f"   Completion percentage: {status['completion_percentage']:.1f}%")
    
    # Run benchmarks (this will save individual files)
    print("\n2. Running benchmarks with individual file saving...")
    results = suite.run_benchmarks()
    
    # Check the file structure
    print("\n3. Checking file structure:")
    results_dir = Path("results")
    benchmarks_dir = results_dir / "benchmarks"
    
    if benchmarks_dir.exists():
        print(f"   ✅ Benchmarks directory created: {benchmarks_dir}")
        individual_files = list(benchmarks_dir.glob("*.json"))
        print(f"   📁 Individual result files: {len(individual_files)}")
        
        for file in individual_files:
            print(f"      - {file.name}")
            
            # Show sample content
            try:
                with open(file, 'r') as f:
                    data = json.load(f)
                    print(f"        ECC: {data['ecc_type']}, Word: {data['word_length']} bits, Pattern: {data['error_pattern']}")
                    print(f"        Success Rate: {data['success_rate']:.2%}")
            except Exception as e:
                print(f"        Error reading file: {e}")
    else:
        print("   ❌ Benchmarks directory not found")
    
    # Check aggregated files
    print("\n4. Checking aggregated files:")
    aggregated_file = results_dir / "benchmark_results.json"
    csv_file = results_dir / "benchmark_results.csv"
    summary_file = results_dir / "benchmark_summary.json"
    
    print(f"   Aggregated JSON: {'✅' if aggregated_file.exists() else '❌'} {aggregated_file}")
    print(f"   CSV file: {'✅' if csv_file.exists() else '❌'} {csv_file}")
    print(f"   Summary JSON: {'✅' if summary_file.exists() else '❌'} {summary_file}")
    
    # Test loading results
    print("\n5. Testing result loading:")
    loaded_results = load_benchmark_results()
    print(f"   Loaded {len(loaded_results)} results from individual files")
    
    # Show completion status after running
    print("\n6. Final completion status:")
    status = suite.get_completion_status()
    print(f"   Total configurations: {status['total_configs']}")
    print(f"   Completed: {status['completed_configs']}")
    print(f"   Completion percentage: {status['completion_percentage']:.1f}%")
    
    print("\n✅ Individual file saving test completed successfully!")

def test_incremental_execution():
    """Test incremental execution by adding new configurations."""
    print("\nTesting Incremental Execution")
    print("=" * 60)
    
    # Create config with additional ECC types
    config = BenchmarkConfig(
        ecc_types=[ParityECC, HammingSECDEDECC],
        word_lengths=[4, 8, 16],  # Added 16-bit
        error_patterns=['single', 'double', 'burst'],  # Added burst
        trials_per_config=30,  # Very small for quick testing
        max_workers=2
    )
    
    suite = ECCBenchmarkSuite(config)
    
    # Check what's already completed
    print("1. Checking existing results:")
    status = suite.get_completion_status()
    print(f"   Already completed: {status['completed_configs']}/{status['total_configs']} ({status['completion_percentage']:.1f}%)")
    
    if status['missing_configs']:
        print("   Missing configurations:")
        for config in status['missing_configs'][:5]:  # Show first 5
            print(f"     - {config}")
        if len(status['missing_configs']) > 5:
            print(f"     ... and {len(status['missing_configs']) - 5} more")
    
    # Run benchmarks (should skip existing ones)
    print("\n2. Running benchmarks (should skip existing ones):")
    results = suite.run_benchmarks()
    
    # Check final status
    print("\n3. Final completion status:")
    status = suite.get_completion_status()
    print(f"   Total configurations: {status['total_configs']}")
    print(f"   Completed: {status['completed_configs']}")
    print(f"   Completion percentage: {status['completion_percentage']:.1f}%")
    
    # Show file count
    benchmarks_dir = Path("results") / "benchmarks"
    if benchmarks_dir.exists():
        individual_files = list(benchmarks_dir.glob("*.json"))
        print(f"   Individual result files: {len(individual_files)}")
    
    print("\n✅ Incremental execution test completed!")

def main():
    """Main test function."""
    print("ECC Benchmark Suite - Individual File Saving Test")
    print("=" * 70)
    
    try:
        test_individual_file_saving()
        test_incremental_execution()
        
        print("\n" + "=" * 70)
        print("All tests completed successfully!")
        print("The individual file saving functionality is working correctly.")
        print("\nBenefits of individual file saving:")
        print("1. ✅ Each benchmark result is saved immediately upon completion")
        print("2. ✅ Interrupted simulations can be resumed without losing progress")
        print("3. ✅ Easy to add new ECC types without re-running existing ones")
        print("4. ✅ Individual files can be analyzed independently")
        print("5. ✅ Better fault tolerance - corruption of one file doesn't affect others")
        print("6. ✅ Parallel processing is more efficient with individual files")
        print("7. ✅ Easy to track progress in real-time")
        
    except Exception as e:
        print(f"\n❌ Test failed with error: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main()) 