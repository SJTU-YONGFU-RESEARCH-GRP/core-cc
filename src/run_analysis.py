#!/usr/bin/env python3
"""
ECC Analysis Framework - Main Orchestrator

This script runs the complete ECC analysis pipeline including:
1. Benchmarking different ECC types across various configurations
2. Hardware verification (synthesis and testbench validation)
3. Comprehensive analysis and visualization
4. Report generation

Usage:
    python run_analysis.py [options]

Options:
    --benchmark-only    Run only benchmarking
    --hardware-only     Run only hardware verification
    --report-only       Generate report from existing data
    --skip-benchmark    Skip benchmarking (use existing data)
    --skip-hardware     Skip hardware verification
    --config FILE       Use custom benchmark configuration
    --output DIR        Output directory for results
"""

import argparse
import sys
import multiprocessing
import os
from pathlib import Path
from typing import Optional, List
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor, as_completed
import psutil

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_suite import ECCBenchmarkSuite, create_default_config, BenchmarkConfig, BenchmarkResult
from enhanced_analysis import ECCAnalyzer, load_benchmark_results, save_benchmark_results
from hardware_verification import HardwareVerifier, load_verification_results
from report_generator import ECCReportGenerator
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


def get_optimal_workers() -> int:
    """
    Determine optimal number of workers based on system resources.
    
    Returns:
        Optimal number of workers
    """
    cpu_count = multiprocessing.cpu_count()
    memory_gb = psutil.virtual_memory().total / (1024**3)
    
    # Conservative approach: use 75% of CPU cores, but not more than memory allows
    optimal_workers = min(
        max(1, int(cpu_count * 0.75)),
        max(1, int(memory_gb * 2))  # Assume ~2GB per worker
    )
    
    return optimal_workers

def run_benchmarks(
    output_dir: str = "results",
    use_processes: bool = False,
    max_workers: Optional[int] = None,
    overwrite: bool = False
) -> List[BenchmarkResult]:
    """
    Run comprehensive ECC benchmarking with enhanced parallel processing.
    
    Args:
        output_dir: Directory to store results
        use_processes: Use ProcessPoolExecutor instead of ThreadPoolExecutor
        max_workers: Maximum number of worker processes/threads
        overwrite: Whether to overwrite existing benchmark results
        
    Returns:
        List of benchmark results
    """
    # Create output directory
    Path(output_dir).mkdir(exist_ok=True)
    
    # Auto-detect optimal worker count if not specified
    if max_workers is None:
        max_workers = get_optimal_workers()
    
    # Print system information
    cpu_count = multiprocessing.cpu_count()
    memory_gb = psutil.virtual_memory().total / (1024**3)
    print(f"Auto-detected optimal workers: {max_workers}")
    print(f"System: {cpu_count} CPU cores, {memory_gb:.1f} GB RAM")
    print(f"Parallel mode: {'Processes' if use_processes else 'Threads'}")
    
    # Configure benchmark suite with ALL 21 ECC types
    config = BenchmarkConfig(
        ecc_types=[
            # Basic ECC Codes (3 types)
            ParityECC, HammingSECDEDECC, RepetitionECC,
            
            # Advanced ECC Codes (4 types)
            BCHECC, ReedSolomonECC, CRCECC, GolayECC,
            
            # Modern ECC Codes (4 types)
            LDPCECC, TurboECC, ConvolutionalECC, PolarECC,
            
            # Advanced Composite ECC Codes (10 types)
            ExtendedHammingECC, ProductCodeECC, ConcatenatedECC, ReedMullerECC,
            FireCodeECC, SpatiallyCoupledLDPCECC, NonBinaryLDPCECC, RaptorCodeECC,
            CompositeECC, SystemECC,
            
            # New Advanced ECC Codes (6 types)
            AdaptiveECC, ThreeDMemoryECC, PrimarySecondaryECC, CyclicECC, BurstErrorECC
        ],
        word_lengths=[4, 8, 16, 32],
        error_patterns=['single', 'double', 'burst', 'random'],
        trials_per_config=1000,
        max_workers=max_workers,
        burst_length=3,
        random_error_prob=0.1
    )
    
    suite = ECCBenchmarkSuite(config)
    suite._run_benchmarks_with_processes = use_processes
    suite._use_chunked_processing = False  # Can be enabled for memory-constrained systems
    suite.set_overwrite_existing(overwrite)
    
    # Run benchmarks
    results = suite.run_benchmarks()
    
    # Save results
    save_benchmark_results(results, output_dir)
    
    return results


def run_hardware_verification(output_dir: str = "results") -> bool:
    """
    Run hardware verification.
    
    Args:
        output_dir: Output directory for results
        
    Returns:
        True if verification completed successfully
    """
    print("=" * 60)
    print("HARDWARE VERIFICATION")
    print("=" * 60)
    
    try:
        verifier = HardwareVerifier(results_dir=output_dir)
        results = verifier.verify_all_hardware()
        verifier.save_verification_results(results)
        
        print(f"\nHardware verification completed!")
        print(f"Results saved to: {output_dir}")
        print(f"Overall status: {results.overall_status}")
        
        return True
        
    except Exception as e:
        print(f"Error during hardware verification: {e}")
        return False


def run_analysis(output_dir: str = "results", use_cache: bool = True) -> bool:
    """
    Run ECC analysis on benchmark results.
    
    Args:
        output_dir: Output directory for results
        
    Returns:
        True if analysis completed successfully
    """
    print("=" * 60)
    print("ECC ANALYSIS")
    print("=" * 60)
    
    try:
        # Load benchmark results
        results = load_benchmark_results(output_dir)
        
        if not results:
            print("No benchmark results found. Please run benchmarks first.")
            return False
        
        # Run analysis
        analyzer = ECCAnalyzer(results)
        analysis_result = analyzer.run_complete_analysis(use_cache=use_cache)
        
        print(f"\nAnalysis completed successfully!")
        print(f"ECC types analyzed: {len(analysis_result.metrics_summary)}")
        print(f"Visualizations saved to: {output_dir}")
        
        return True
        
    except Exception as e:
        print(f"Error during analysis: {e}")
        return False


def generate_report(output_dir: str = "results", use_cache: bool = True) -> bool:
    """
    Generate comprehensive ECC analysis report.
    
    Args:
        output_dir: Output directory for results
        
    Returns:
        True if report generation completed successfully
    """
    print("=" * 60)
    print("REPORT GENERATION")
    print("=" * 60)
    
    try:
        generator = ECCReportGenerator(results_dir=output_dir, use_cache=use_cache)
        generator.save_report()
        
        print(f"\nReport generation completed successfully!")
        print(f"Report saved to: {output_dir}/ecc_analysis_report.md")
        
        return True
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        print(f"Error during report generation: {e}")
        print("Report generation failed!")
        sys.exit(1)


def load_custom_config(config_file: str) -> Optional[BenchmarkConfig]:
    """
    Load custom benchmark configuration from file.
    
    Args:
        config_file: Path to configuration file
        
    Returns:
        Benchmark configuration or None if loading failed
    """
    try:
        import json
        with open(config_file, 'r') as f:
            data = json.load(f)
        
        # Import ECC types dynamically
        from base_ecc import ECCBase
        ecc_types = []
        
        for ecc_name in data.get('ecc_types', []):
            try:
                # Try to import the ECC class
                module_name = f"{ecc_name.lower()}_ecc"
                class_name = ecc_name
                
                module = __import__(module_name, fromlist=[class_name])
                ecc_class = getattr(module, class_name)
                
                if issubclass(ecc_class, ECCBase):
                    ecc_types.append(ecc_class)
                else:
                    print(f"Warning: {ecc_name} is not a valid ECC class")
                    
            except (ImportError, AttributeError) as e:
                print(f"Warning: Could not import {ecc_name}: {e}")
        
        return BenchmarkConfig(
            ecc_types=ecc_types,
            word_lengths=data.get('word_lengths', [4, 8, 16, 32]),
            error_patterns=data.get('error_patterns', ['single', 'double', 'burst', 'random']),
            trials_per_config=data.get('trials_per_config', 10000),
            burst_length=data.get('burst_length', 3),
            random_error_prob=data.get('random_error_prob', 0.01),
            measure_timing=data.get('measure_timing', True),
            max_workers=data.get('max_workers', 4)
        )
        
    except Exception as e:
        print(f"Error loading custom configuration: {e}")
        return None


def main():
    """Main entry point for the ECC analysis framework."""
    parser = argparse.ArgumentParser(
        description="Enhanced ECC Analysis Framework",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python run_analysis.py                    # Run complete analysis
  python run_analysis.py --benchmark-only   # Run only benchmarking
  python run_analysis.py --hardware-only    # Run only hardware verification
  python run_analysis.py --report-only      # Generate report from existing data
  python run_analysis.py --config my_config.json  # Use custom configuration
  
Parallel Processing Options:
  python run_analysis.py --use-processes    # Use multiprocessing for true parallelism
  python run_analysis.py --workers 8        # Specify number of workers
  python run_analysis.py --chunked          # Use chunked processing for memory management
  python run_analysis.py --use-processes --workers 16  # High-performance mode
        """
    )
    
    parser.add_argument('--benchmark-only', action='store_true',
                       help='Run only benchmarking (skip hardware verification, analysis, and report generation)')
    parser.add_argument('--analysis-only', action='store_true',
                       help='Run only analysis (skip benchmarking and hardware verification)')
    parser.add_argument('--report-only', action='store_true',
                       help='Run only report generation (skip benchmarking, hardware verification, and analysis)')
    parser.add_argument('--skip-benchmark', action='store_true',
                       help='Skip benchmarking step')
    parser.add_argument('--skip-hardware', action='store_true',
                       help='Skip hardware verification step')
    parser.add_argument('--skip-analysis', action='store_true',
                       help='Skip analysis step')
    parser.add_argument('--skip-report', action='store_true',
                       help='Skip report generation step')
    parser.add_argument('--overwrite', action='store_true',
                       help='Overwrite existing benchmark results (default: skip existing)')
    parser.add_argument('--config', type=str,
                       help='Path to custom benchmark configuration file')
    parser.add_argument('--output', type=str, default='results',
                       help='Output directory for results (default: results)')
    parser.add_argument('--use-processes', action='store_true',
                       help='Use ProcessPoolExecutor instead of ThreadPoolExecutor for true parallelism')
    parser.add_argument('--workers', type=int,
                       help='Number of workers (auto-detect if not specified)')
    parser.add_argument('--chunked', action='store_true',
                       help='Use chunked processing to manage memory better')
    parser.add_argument('--memory-limit', type=float, default=0.75,
                       help='Memory usage limit as fraction of total RAM (default: 0.75)')
    parser.add_argument('--no-cache', action='store_true',
                       help='Disable usage of cached verification results')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Enable verbose output')
    
    args = parser.parse_args()
    
    # Create output directory
    output_dir = Path(args.output)
    output_dir.mkdir(exist_ok=True)
    
    print("ECC Analysis Framework")
    print("====================================")
    print(f"Output directory: {output_dir.absolute()}")
    print()
    
    # Load custom configuration if specified
    config = None
    if args.config:
        print(f"Loading custom configuration from: {args.config}")
        config = load_custom_config(args.config)
        if config is None:
            print("Failed to load custom configuration. Using default.")
            config = create_default_config()
    
    success = True
    
    # Handle different execution modes
    if args.benchmark_only:
        results = run_benchmarks(
            str(output_dir), 
            use_processes=args.use_processes,
            max_workers=args.workers,
            overwrite=args.overwrite
        )
        print(f"\nBenchmarking completed successfully!")
        print(f"Results saved to: {output_dir}")
        print(f"Total configurations tested: {len(results)}")
        return 0
    
    if args.analysis_only:
        print("===== Running Analysis Only =====")
        success = run_analysis(str(output_dir), use_cache=not args.no_cache)
        if not success:
            print("Analysis failed!")
            return 1
        print("Analysis completed successfully!")
        return 0
    
    if args.report_only:
        print("===== Running Report Generation Only =====")
        success = generate_report(str(output_dir), use_cache=not args.no_cache)
        if not success:
            print("Report generation failed!")
            return 1
        print("Report generation completed successfully!")
        return 0
    
    # Step 1: Run benchmarks
    if not args.skip_benchmark:
        results = run_benchmarks(
            str(output_dir),
            use_processes=args.use_processes,
            max_workers=args.workers,
            overwrite=args.overwrite
        )
        print(f"Benchmarking completed: {len(results)} configurations")
    else:
        print("Skipping benchmarks, loading existing results...")
        results = load_benchmark_results(str(output_dir))
        if not results:
            print("No existing benchmark results found!")
            return
        
    # Step 2: Run hardware verification
    if not args.skip_hardware:
        success = run_hardware_verification(str(output_dir))
        if not success:
            print("Hardware verification failed, but continuing with analysis...")
    else:
        print("Skipping hardware verification...")
    
    # Step 3: Run analysis
    if not args.skip_analysis:
        success = run_analysis(str(output_dir), use_cache=not args.no_cache)
        if not success:
            print("Analysis failed, but continuing with report generation...")
    else:
        print("Skipping analysis...")
    
    # Step 4: Generate report
    if not args.skip_report:
        success = generate_report(str(output_dir), use_cache=not args.no_cache)
        if not success:
            print("Report generation failed!")
            return 1
    else:
        print("Skipping report generation...")
    
    print("\n" + "=" * 60)
    print("ECC ANALYSIS PIPELINE COMPLETED")
    print("=" * 60)
    print(f"Results available in: {output_dir}")
    print(f"Main report: {output_dir}/ecc_analysis_report.md")
    print(f"Performance charts: {output_dir}/ecc_performance_charts.png")
    
    return 0


if __name__ == "__main__":
    sys.exit(main()) 