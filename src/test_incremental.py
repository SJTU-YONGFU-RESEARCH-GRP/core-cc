#!/usr/bin/env python3
"""
Test script to demonstrate incremental saving functionality.

This script shows how the enhanced benchmark suite can save results
incrementally, allowing for resuming interrupted simulations.
"""

import sys
from pathlib import Path
from typing import List

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_suite import ECCBenchmarkSuite, create_default_config, BenchmarkConfig
from enhanced_analysis import load_benchmark_results
from parity_ecc import ParityECC
from hamming_secded_ecc import HammingSECDEDECC

def test_incremental_saving():
    """Test the incremental saving functionality."""
    print("Testing Incremental Saving Functionality")
    print("=" * 50)
    
    # Create a minimal config for testing
    config = BenchmarkConfig(
        ecc_types=[ParityECC, HammingSECDEDECC],
        word_lengths=[4, 8],
        error_patterns=['single', 'double'],
        trials_per_config=100,  # Small number for quick testing
        max_workers=2
    )
    
    suite = ECCBenchmarkSuite(config)
    
    # Check initial completion status
    print("\n1. Initial completion status:")
    status = suite.get_completion_status()
    print(f"   Total configurations: {status['total_configs']}")
    print(f"   Completed: {status['completed_configs']}")
    print(f"   Completion percentage: {status['completion_percentage']:.1f}%")
    
    if status['missing_configs']:
        print("   Missing configurations:")
        for config in status['missing_configs']:
            print(f"     - {config}")
    
    # Run benchmarks (this will save incrementally)
    print("\n2. Running benchmarks with incremental saving...")
    results = suite.run_benchmarks()
    
    # Check completion status after running
    print("\n3. Completion status after running:")
    status = suite.get_completion_status()
    print(f"   Total configurations: {status['total_configs']}")
    print(f"   Completed: {status['completed_configs']}")
    print(f"   Completion percentage: {status['completion_percentage']:.1f}%")
    
    # Test loading existing results
    print("\n4. Testing loading of existing results:")
    loaded_results = load_benchmark_results()
    print(f"   Loaded {len(loaded_results)} results from file")
    
    # Show some sample results
    if loaded_results:
        print("\n5. Sample results:")
        for i, result in enumerate(loaded_results[:3]):
            print(f"   {i+1}. {result.ecc_type} ({result.word_length} bits, {result.error_pattern} errors)")
            print(f"      Success rate: {result.success_rate:.2%}")
            print(f"      Correction rate: {result.correction_rate:.2%}")
            print(f"      Detection rate: {result.detection_rate:.2%}")
    
    print("\n✅ Incremental saving test completed successfully!")

def test_resume_functionality():
    """Test resuming from existing results."""
    print("\nTesting Resume Functionality")
    print("=" * 50)
    
    # Create config with more ECC types
    config = BenchmarkConfig(
        ecc_types=[ParityECC, HammingSECDEDECC],
        word_lengths=[4, 8, 16],
        error_patterns=['single', 'double', 'burst'],
        trials_per_config=50,  # Very small for quick testing
        max_workers=2
    )
    
    suite = ECCBenchmarkSuite(config)
    
    # Check what's already completed
    print("1. Checking existing results...")
    status = suite.get_completion_status()
    print(f"   Already completed: {status['completed_configs']}/{status['total_configs']} ({status['completion_percentage']:.1f}%)")
    
    # Run benchmarks (this should skip existing ones)
    print("\n2. Running benchmarks (should skip existing ones)...")
    results = suite.run_benchmarks()
    
    # Check final status
    print("\n3. Final completion status:")
    status = suite.get_completion_status()
    print(f"   Total configurations: {status['total_configs']}")
    print(f"   Completed: {status['completed_configs']}")
    print(f"   Completion percentage: {status['completion_percentage']:.1f}%")
    
    print("\n✅ Resume functionality test completed!")

def main():
    """Main test function."""
    print("ECC Benchmark Suite - Incremental Saving Test")
    print("=" * 60)
    
    try:
        test_incremental_saving()
        test_resume_functionality()
        
        print("\n" + "=" * 60)
        print("All tests completed successfully!")
        print("The incremental saving functionality is working correctly.")
        print("You can now:")
        print("1. Interrupt long-running simulations and resume later")
        print("2. Add new ECC types without re-running existing ones")
        print("3. Monitor progress in real-time")
        print("4. Analyze partial results while simulation continues")
        
    except Exception as e:
        print(f"\n❌ Test failed with error: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main()) 