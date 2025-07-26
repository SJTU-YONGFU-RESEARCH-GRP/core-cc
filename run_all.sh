#!/bin/bash
set -e

# Default values
MODE="full"
VERBOSE=false
SKIP_REPORT=false
PARALLEL_MODE="auto"
WORKERS=""
USE_PROCESSES=false
CHUNKED=false
PERFORMANCE_TEST=false
OVERWRITE=false

# Function to display usage information
show_usage() {
    cat << EOF
ECC Framework Execution Script

Usage: $0 [OPTIONS]

OPTIONS:
    -m, --mode MODE          Execution mode (default: full)
                            Available modes:
                              theoretical  - Python simulation + report generation
                              hardware     - Verilog synthesis + Verilator simulation + report
                              full         - All modes (theoretical + hardware + report)
                              performance  - Performance testing and parallel processing demo
                              benchmark    - ECC benchmarking only
                              analysis     - Analysis and report generation only
    
    -v, --verbose           Enable verbose output
    -s, --skip-report       Skip report generation (only for hardware mode)
    
    Parallel Processing Options:
    -p, --parallel MODE     Parallel processing mode (default: auto)
                            Available modes:
                              auto         - Auto-detect optimal settings
                              threads      - Use ThreadPoolExecutor
                              processes    - Use ProcessPoolExecutor
                              chunked      - Use chunked processing
    -w, --workers N         Number of workers (auto-detect if not specified)
    --use-processes         Use multiprocessing for true parallelism
    --chunked               Use chunked processing for memory management
    
    Performance Testing:
    --performance-test      Run performance testing and parallel processing demo
    --quick-test           Run quick performance test
    --concurrent-demo      Run concurrent execution demonstration
    --overwrite            Overwrite existing benchmark results (default: skip existing)
    
    -h, --help              Show this help message

EXAMPLES:
    $0                                    # Run full analysis (default)
    $0 -m theoretical                     # Run only Python simulation and report
    $0 --mode hardware                    # Run only hardware implementation and report
    $0 -m hardware -s                     # Run hardware implementation without report
    $0 -v -m full                         # Run full analysis with verbose output
    
    Parallel Processing Examples:
    $0 --use-processes --workers 8        # Use multiprocessing with 8 workers
    $0 --chunked --workers 4              # Use chunked processing with 4 workers
    $0 -p auto                            # Auto-detect optimal parallel settings
    $0 -m benchmark --use-processes       # Benchmark with multiprocessing
    
    Performance Testing Examples:
    $0 --performance-test                 # Run comprehensive performance testing
    $0 --quick-test                       # Run quick performance test
    $0 --concurrent-demo                  # Run concurrent execution demo
    $0 -m performance                     # Run performance testing mode
    
    Overwrite Examples:
    $0 --overwrite                        # Overwrite existing benchmark results
    $0 -m theoretical --overwrite         # Run theoretical analysis with overwrite
    $0 --use-processes --overwrite        # Use multiprocessing and overwrite results

EOF
}

# Function to print section headers
print_section() {
    local section_name="$1"
    printf '\n===== %s =====\n' "$section_name"
}

# Function to run Python ECC simulation and analysis
run_theoretical_analysis() {
    print_section "Running Python ECC Simulation & Analysis (Theoretical)"
    echo "Starting Python ECC simulation with enhanced parallel processing..."
    
    # Build command with parallel processing options
    local cmd="python3 src/run_analysis.py --benchmark-only"
    
    if [ "$USE_PROCESSES" = true ]; then
        cmd="$cmd --use-processes"
    fi
    
    if [ "$CHUNKED" = true ]; then
        cmd="$cmd --chunked"
    fi
    
    if [ -n "$WORKERS" ]; then
        cmd="$cmd --workers $WORKERS"
    fi
    
    if [ "$OVERWRITE" = true ]; then
        cmd="$cmd --overwrite"
    fi
    
    echo "Executing: $cmd"
    eval $cmd
    echo "Python ECC simulation completed."
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

# Function to generate comprehensive ECC analysis report
generate_report() {
    print_section "Generating ECC Analysis Report"
    echo "Generating comprehensive analysis report..."
    python3 src/run_analysis.py --report-only
    echo "Analysis report generated."
}

# Function to run ECC benchmarking only
run_benchmarking() {
    print_section "Running ECC Benchmarking"
    echo "Starting ECC benchmarking with enhanced parallel processing..."
    
    # Build command with parallel processing options
    local cmd="python3 src/run_analysis.py --benchmark-only"
    
    if [ "$USE_PROCESSES" = true ]; then
        cmd="$cmd --use-processes"
    fi
    
    if [ "$CHUNKED" = true ]; then
        cmd="$cmd --chunked"
    fi
    
    if [ -n "$WORKERS" ]; then
        cmd="$cmd --workers $WORKERS"
    fi
    
    if [ "$OVERWRITE" = true ]; then
        cmd="$cmd --overwrite"
    fi
    
    echo "Executing: $cmd"
    eval $cmd
    echo "ECC benchmarking completed."
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
    
    if [ "$SKIP_REPORT" = false ] && [ "$MODE" != "benchmark" ] && [ "$MODE" != "performance" ] && [ "$MODE" != "quick-test" ] && [ "$MODE" != "concurrent-demo" ]; then
        printf 'Report generated: results/ecc_analysis_report.md\n'
    fi
    
    printf 'Detailed logs available in: results/run.log\n'
    
    if [ "$MODE" = "hardware" ] || [ "$MODE" = "full" ]; then
        printf 'Individual testbench logs available in: results/*/simulation.log\n'
        printf '\nFor debugging individual ECC implementations:\n'
        printf '  python3 src/verilate_single.py --list                    # List available testbenches\n'
        printf '  python3 src/verilate_single.py <testbench_name>          # Run specific testbench\n'
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
            PARALLEL_MODE="$2"
            shift 2
            ;;
        -w|--workers)
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
            MODE="quick-test"
            shift
            ;;
        --concurrent-demo)
            MODE="concurrent-demo"
            shift
            ;;
        --overwrite)
            OVERWRITE=true
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
    theoretical|hardware|full|performance|benchmark|analysis|quick-test|concurrent-demo)
        ;;
    *)
        echo "Error: Invalid mode '$MODE'. Valid modes are: theoretical, hardware, full, performance, benchmark, analysis, quick-test, concurrent-demo"
        exit 1
        ;;
esac

# Validate skip-report option
if [ "$SKIP_REPORT" = true ] && [ "$MODE" = "theoretical" ]; then
    echo "Warning: --skip-report is not applicable for theoretical mode. Ignoring."
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
echo "Workers: ${WORKERS:-auto-detect}"
echo "Use Processes: $USE_PROCESSES"
echo "Chunked Processing: $CHUNKED"
echo "Performance Test: $PERFORMANCE_TEST"
echo "Overwrite: $OVERWRITE"
echo ""

# Run selected mode and tee output to results/run.log
{
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
            run_benchmarking
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
    esac
    
    print_completion
} 2>&1 | tee results/run.log