#!/bin/bash
set -e

# Default values
MODE="full"
VERBOSE=false
SKIP_REPORT=false
PARALLEL_MODE="auto"
WORKERS="auto"
USE_PROCESSES=false
CHUNKED=false
PERFORMANCE_TEST=false
OVERWRITE=false
CLEANUP_BUILD=false

# Function to display usage information
show_usage() {
    echo "ECC Analysis Framework v1.0"
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Modes:"
    echo "  -m, --mode MODE          Execution mode (theoretical|hardware|hardware-verify|full|benchmark|analysis|performance|quick-test|concurrent-demo|design-exploration)"
    echo ""
    echo "Options:"
    echo "  -v, --verbose            Enable verbose output"
    echo "  -s, --skip-report        Skip report generation"
    echo "  -p, --parallel           Enable parallel processing (threads)"
    echo "  --workers N              Number of worker threads/processes (default: auto-detect)"
    echo "  --use-processes          Use multiprocessing instead of threading"
    echo "  --chunked                Enable chunked processing for memory efficiency"
    echo "  --performance-test       Run performance comparison tests"
    echo "  --quick-test             Run quick performance test"
    echo "  --concurrent-demo        Run concurrent execution demo"
    echo "  --overwrite              Overwrite existing benchmark results"
    echo "  --with-report            Generate report after benchmark"
    echo "  --cleanup-build          Clean up and reorganize build directories"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -m theoretical                    # Run theoretical analysis"
    echo "  $0 -m benchmark --overwrite          # Run benchmarks, overwrite existing results"
    echo "  $0 -m benchmark --with-report        # Run benchmarks with report generation"
    echo "  $0 -m theoretical -p --workers 8     # Run with 8 worker threads"
    echo "  $0 -m theoretical --use-processes    # Use multiprocessing"
    echo "  $0 --quick-test                      # Quick performance test"
    echo "  $0 --concurrent-demo                 # Concurrent execution demo"
    echo "  $0 -m design-exploration             # Run design space exploration"
    echo "  $0 -m hardware-verify               # Run hardware verification tests"
    echo "  $0 --cleanup-build                  # Clean up build directories"
    echo ""
    echo "Parallel Processing Examples:"
    echo "  $0 -m theoretical -p                 # Auto-detected optimal parallel processing"
    echo "  $0 -m theoretical --use-processes    # Process-based parallel processing"
    echo "  $0 -m theoretical --chunked          # Memory-efficient chunked processing"
    echo "  $0 -m benchmark --use-processes      # Enhanced benchmark with multiprocessing"
    echo "  $0 -m benchmark --with-report        # Benchmark with automatic report generation"
    echo ""
    echo "Performance Testing:"
    echo "  $0 --performance-test                # Comprehensive performance analysis"
    echo "  $0 --quick-test                      # Quick performance verification"
    echo "  $0 --concurrent-demo                 # Visual concurrent execution demo"
    echo ""
    echo "Design Space Exploration:"
    echo "  $0 -m design-exploration             # Explore primary/secondary ECC combinations"
    echo "  $0 -m design-exploration --use-processes  # Use multiprocessing for exploration"
}

# Function to print section headers
print_section() {
    local section_name="$1"
    printf '\n===== %s =====\n' "$section_name"
}

# Function to run Python ECC simulation and analysis
run_theoretical_analysis() {
    echo "===== Running Python ECC Simulation & Analysis (Theoretical) ====="
    echo "Starting Python ECC simulation with enhanced parallel processing..."
    
    local parallel_args=""
    if [ "$USE_PROCESSES" = true ]; then
        parallel_args="--parallel-method processes"
    elif [ "$CHUNKED" = true ]; then
        parallel_args="--parallel-method chunked"
    else
        parallel_args="--parallel-method auto"
    fi
    
    if [ "$WORKERS" != "auto" ]; then
        parallel_args="$parallel_args --workers $WORKERS"
    fi
    if [ "$OVERWRITE" = true ]; then
        parallel_args="$parallel_args --overwrite"
    fi
    
    if [ "$VERBOSE" = true ]; then
        echo "Executing: python3 src/benchmark_suite.py $parallel_args"
    fi
    
    # Run benchmarks using enhanced benchmark suite
    python3 src/benchmark_suite.py $parallel_args
    
    # Run analysis using enhanced analysis framework
    echo "===== Running Enhanced ECC Analysis ====="
    python3 src/enhanced_analysis.py --mode analysis
}

# Function to run hardware implementation
run_hardware_implementation() {
    print_section "Running Hardware Implementation Analysis"
    
    # Run Yosys synthesis for all Verilog ECC modules
    echo "Starting Yosys synthesis for hardware area analysis..."
    python3 src/synthesize_all.py
    echo "Yosys synthesis completed."

    # Run Verilator simulation for all testbenches
    echo "Starting Verilator simulation for hardware verification..."
    echo "This will test all ECC implementations with detailed logging..."
    python3 src/verilate_all.py
    echo "Verilator simulation completed."
}

# Function to run hardware verification tests
run_hardware_verification_tests() {
    print_section "Running Hardware Verification Tests"
    
    # Check if required directories exist
    if [ ! -d "verilogs" ]; then
        echo "Error: verilogs directory not found"
        return 1
    fi
    
    if [ ! -d "testbenches" ]; then
        echo "Error: testbenches directory not found"
        return 1
    fi
    
    # Run the hardware verification tests using Python
    echo "Starting hardware verification tests..."
    echo "This will test all ECC Verilog implementations against Python logic..."
    
    local verbose_flag=""
    if [ "$VERBOSE" = true ]; then
        verbose_flag="--verbose"
    fi
    
    python3 src/hardware_verification_runner.py $verbose_flag
    
    # Check the exit code
    if [ $? -eq 0 ]; then
        echo "Hardware verification tests completed successfully."
    else
        echo "Hardware verification tests failed."
        return 1
    fi
}

# Function to generate comprehensive ECC analysis report
generate_report() {
    print_section "Generating ECC Analysis Report"
    echo "Generating comprehensive analysis report..."
    python3 src/run_analysis.py --report-only
    echo "Analysis report generated."
}

# Function to run ECC benchmarking only (updated to pass overwrite)
run_benchmarking() {
    echo "===== Running ECC Benchmarking Only ====="
    
    local parallel_args=""
    if [ "$USE_PROCESSES" = true ]; then
        parallel_args="--parallel-method processes"
    elif [ "$CHUNKED" = true ]; then
        parallel_args="--parallel-method chunked"
    else
        parallel_args="--parallel-method auto"
    fi
    
    if [ "$WORKERS" != "auto" ]; then
        parallel_args="$parallel_args --workers $WORKERS"
    fi
    if [ "$OVERWRITE" = true ]; then
        parallel_args="$parallel_args --overwrite"
    fi
    
    # Use the enhanced benchmark suite directly
    python3 src/benchmark_suite.py $parallel_args
}

# Function to run ECC benchmarking with report generation
run_benchmarking_with_report() {
    echo "===== Running ECC Benchmarking with Report Generation ====="
    
    local parallel_args=""
    if [ "$USE_PROCESSES" = true ]; then
        parallel_args="--parallel-method processes"
    elif [ "$CHUNKED" = true ]; then
        parallel_args="--parallel-method chunked"
    else
        parallel_args="--parallel-method auto"
    fi
    
    if [ "$WORKERS" != "auto" ]; then
        parallel_args="$parallel_args --workers $WORKERS"
    fi
    if [ "$OVERWRITE" = true ]; then
        parallel_args="$parallel_args --overwrite"
    fi
    
    # Run benchmarks first using enhanced benchmark suite
    python3 src/benchmark_suite.py $parallel_args
    
    # Then generate report using enhanced analysis
    echo "===== Generating Report from Benchmark Results ====="
    python3 src/enhanced_analysis.py --mode analysis
}

# Function to run analysis and report generation
run_analysis() {
    print_section "Running ECC Analysis and Report Generation"
    echo "Starting ECC analysis and report generation..."
    python3 src/run_analysis.py --report-only
    echo "ECC analysis and report generation completed."
}

# Function to run performance testing
run_performance_testing() {
    print_section "Running Performance Testing and Parallel Processing Demo"
    echo "Starting performance testing and parallel processing demonstration..."
    
    if [ "$PERFORMANCE_TEST" = true ]; then
        echo "Running comprehensive performance test..."
        python3 src/performance_test.py
    else
        echo "Running concurrent execution demo..."
        python3 src/concurrent_demo.py
    fi
    
    echo "Performance testing completed."
}

# Function to run quick performance test
run_quick_test() {
    print_section "Running Quick Performance Test"
    echo "Starting quick performance test..."
    python3 src/quick_test.py
    echo "Quick performance test completed."
}

# Function to run concurrent execution demo
run_concurrent_demo() {
    print_section "Running Concurrent Execution Demo"
    echo "Starting concurrent execution demonstration..."
    python3 src/concurrent_demo.py
    echo "Concurrent execution demo completed."
}

# Function to run design space exploration
run_design_exploration() {
    print_section "Running Design Space Exploration for Primary/Secondary ECC"
    echo "Starting comprehensive design space exploration..."
    echo "This will evaluate all possible primary/secondary ECC combinations."
    
    local parallel_args=""
    if [ "$USE_PROCESSES" = true ]; then
        parallel_args="--use-processes"
    fi
    if [ "$WORKERS" != "auto" ]; then
        parallel_args="$parallel_args --workers $WORKERS"
    fi
    
    # Run design space exploration
    python3 src/run_design_exploration.py $parallel_args
    
    echo "Design space exploration completed."
    echo "Results saved to: ecc_design_exploration_results.json"
    echo "Visualizations saved to: ecc_design_results/"
    echo "Analysis report saved to: design_space_analysis.json"
}

# Function to cleanup and reorganize build directories
run_build_cleanup() {
    print_section "Cleaning Up Build Directories"
    echo "Reorganizing build directories under results/build for better organization..."
    
    # Run the cleanup script
    python3 src/cleanup_build_dirs.py
    
    echo "Build directory cleanup completed."
    echo "All build artifacts are now organized under results/build/"
    echo "This improves project organization and makes maintenance easier."
}

# Function to print completion message
print_completion() {
    printf '\n===== ECC Framework Execution Completed =====\n'
    printf 'Mode executed: %s\n' "$MODE"
    
    if [ "$MODE" = "theoretical" ] || [ "$MODE" = "full" ]; then
        printf 'Theoretical analysis completed.\n'
    fi
    
    if [ "$MODE" = "hardware" ] || [ "$MODE" = "full" ]; then
        printf 'Hardware implementation analysis completed.\n'
        printf 'Note: If Verilator simulation was skipped, install Verilator to enable hardware verification.\n'
    fi
    
    if [ "$MODE" = "hardware-verify" ]; then
        printf 'Hardware verification tests completed.\n'
        printf 'All ECC Verilog implementations verified against Python logic.\n'
        printf 'Test results: PASS/FAIL for each ECC type.\n'
        printf 'Results saved to: results/hardware_verification_results.json\n'
    fi
    
    if [ "$MODE" = "performance" ] || [ "$MODE" = "quick-test" ] || [ "$MODE" = "concurrent-demo" ]; then
        printf 'Performance testing completed.\n'
        printf 'For more detailed analysis, run: python3 src/performance_test.py\n'
    fi
    
    if [ "$MODE" = "benchmark" ]; then
        printf 'ECC benchmarking completed.\n'
        printf 'Benchmark results saved to: results/benchmark_results.json\n'
    fi
    
    if [ "$MODE" = "analysis" ]; then
        printf 'ECC analysis and report generation completed.\n'
    fi
    
    if [ "$MODE" = "design-exploration" ]; then
        printf 'Design space exploration completed.\n'
        printf 'Results saved to: ecc_design_exploration_results.json\n'
        printf 'Visualizations saved to: ecc_design_results/\n'
        printf 'Analysis report saved to: design_space_analysis.json\n'
        printf '\nTop recommendations available in the analysis report.\n'
    fi
    
    if [ "$CLEANUP_BUILD" = true ]; then
        printf 'Build directory cleanup completed.\n'
        printf 'All build artifacts organized under results/build/\n'
        printf 'Project structure is now cleaner and easier to maintain.\n'
    fi
    
    if [ "$SKIP_REPORT" = false ] && [ "$MODE" != "benchmark" ] && [ "$MODE" != "performance" ] && [ "$MODE" != "quick-test" ] && [ "$MODE" != "concurrent-demo" ] && [ "$MODE" != "design-exploration" ]; then
        printf 'Report generated: results/ecc_analysis_report.md\n'
    fi
    
    printf 'Detailed logs available in: results/run.log\n'
    
    if [ "$MODE" = "hardware" ] || [ "$MODE" = "full" ]; then
        printf 'Individual testbench logs available in: results/*/simulation.log\n'
        printf '\nFor debugging individual ECC implementations:\n'
        printf '  python3 src/verilate_single.py --list                    # List available testbenches\n'
        printf '  python3 src/verilate_single.py <testbench_name>          # Run specific testbench\n'
    fi
    
    if [ "$MODE" = "hardware-verify" ]; then
        printf '\nFor running individual hardware verification tests:\n'
        printf '  python3 src/hardware_verification_runner.py --verbose     # Run with verbose output\n'
        printf '  verilator --cc --exe --build verilogs/<ecc>.v testbenches/<ecc>_tb.c -o <ecc>_test\n'
    fi
    
    if [ "$USE_PROCESSES" = true ] || [ "$CHUNKED" = true ] || [ -n "$WORKERS" ]; then
        printf '\nParallel processing options used:\n'
        if [ "$USE_PROCESSES" = true ]; then
            printf '  - Multiprocessing enabled\n'
        fi
        if [ "$CHUNKED" = true ]; then
            printf '  - Chunked processing enabled\n'
        fi
        if [ -n "$WORKERS" ]; then
            printf '  - Workers: %s\n' "$WORKERS"
        fi
    fi
}

# Parse command line arguments
WITH_REPORT=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -s|--skip-report)
            SKIP_REPORT=true
            shift
            ;;
        -p|--parallel)
            PARALLEL_MODE=true
            shift
            ;;
        --workers)
            WORKERS="$2"
            shift 2
            ;;
        --use-processes)
            USE_PROCESSES=true
            shift
            ;;
        --chunked)
            CHUNKED=true
            shift
            ;;
        --performance-test)
            PERFORMANCE_TEST=true
            shift
            ;;
        --quick-test)
            QUICK_TEST=true
            shift
            ;;
        --concurrent-demo)
            CONCURRENT_DEMO=true
            shift
            ;;
        --overwrite)
            OVERWRITE=true
            shift
            ;;
        --with-report)
            WITH_REPORT=true
            shift
            ;;
        --cleanup-build)
            CLEANUP_BUILD=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate mode
case $MODE in
    theoretical|hardware|hardware-verify|full|performance|benchmark|analysis|quick-test|concurrent-demo|design-exploration)
        ;;
    *)
        echo "Error: Invalid mode '$MODE'. Valid modes are: theoretical, hardware, hardware-verify, full, performance, benchmark, analysis, quick-test, concurrent-demo, design-exploration"
        exit 1
        ;;
esac

# Validate skip-report option
if [ "$SKIP_REPORT" = true ] && [ "$MODE" = "theoretical" ]; then
    echo "Warning: --skip-report is not applicable for theoretical mode. Ignoring."
    SKIP_REPORT=false
fi

# Validate skip-report option for hardware-verify mode
if [ "$SKIP_REPORT" = true ] && [ "$MODE" = "hardware-verify" ]; then
    echo "Warning: --skip-report is not applicable for hardware-verify mode. Ignoring."
    SKIP_REPORT=false
fi

# Create results directory
mkdir -p results

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    echo "Activating virtual environment..."
    source venv/bin/activate
fi

# Display execution plan
echo "ECC Framework Execution Plan:"
echo "Mode: $MODE"
echo "Verbose: $VERBOSE"
echo "Skip Report: $SKIP_REPORT"
echo "Parallel Mode: $PARALLEL_MODE"
echo "Workers: $WORKERS"
echo "Use Processes: $USE_PROCESSES"
echo "Chunked Processing: $CHUNKED"
echo "Performance Test: $PERFORMANCE_TEST"
echo "Overwrite: $OVERWRITE"
echo ""

# Run selected mode and tee output to results/run.log
{
    # Handle cleanup mode
    if [ "$CLEANUP_BUILD" = true ]; then
        run_build_cleanup
    else
        case $MODE in
            theoretical)
                run_theoretical_analysis
                if [ "$SKIP_REPORT" = false ]; then
                    generate_report
                fi
                ;;
            hardware)
                run_hardware_implementation
                if [ "$SKIP_REPORT" = false ]; then
                    generate_report
                fi
                ;;
            hardware-verify)
                run_hardware_verification_tests
                if [ "$SKIP_REPORT" = false ]; then
                    generate_report
                fi
                ;;
            full)
                run_theoretical_analysis
                run_hardware_implementation
                if [ "$SKIP_REPORT" = false ]; then
                    generate_report
                fi
                ;;
            performance)
                run_performance_testing
                ;;
            benchmark)
                if [ "$WITH_REPORT" = true ]; then
                    run_benchmarking_with_report
                else
                    run_benchmarking
                fi
                ;;
            analysis)
                run_analysis
                ;;
            quick-test)
                run_quick_test
                ;;
            concurrent-demo)
                run_concurrent_demo
                ;;
            design-exploration)
                run_design_exploration
                ;;
        esac
    fi
    
    print_completion
} 2>&1 | tee results/run.log