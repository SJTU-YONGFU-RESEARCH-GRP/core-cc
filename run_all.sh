#!/bin/bash

# CORE-CC Dataset Generation and Verification Workflow Orchestrator
# Enhanced version - Unified Python-driven pipeline

set -e # Exit on error

# Default settings
MODE="full"
PARALLEL=false
OVERWRITE=false
USE_PROCESSES=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================================================${NC}"
    echo -e "${BLUE}        CORE-CC ECC DATASET WORKFLOW ORCHESTRATOR               ${NC}"
    echo -e "${BLUE}================================================================${NC}"
}

print_usage() {
    echo "Usage: ./run_all.sh [options]"
    echo ""
    echo "Options:"
    echo "  -m, --mode [mode]      Execution mode: full, benchmark, hardware, analysis, report"
    echo "                         (default: full)"
    echo "  -p, --parallel         Enable parallel processing (processes)"
    echo "  -o, --overwrite        Overwrite existing benchmark results"
    echo "  --performance-test     Run comprehensive performance comparison"
    echo "  --quick-test           Run quick verification test"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./run_all.sh --full -p        # Run entire pipeline in parallel"
    echo "  ./run_all.sh -m hardware      # Run hardware synthesis and simulation only"
    echo "  ./run_all.sh --quick-test     # Fast verification of all ECC types"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -p|--parallel)
            PARALLEL=true
            USE_PROCESSES=true
            shift
            ;;
        -o|--overwrite)
            OVERWRITE=true
            shift
            ;;
        --full)
            MODE="full"
            shift
            ;;
        --performance-test)
            MODE="performance-test"
            shift
            ;;
        --quick-test)
            MODE="quick-test"
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

print_header

# Check for Python
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: python3 is not installed.${NC}"
    exit 1
fi

# Construct Python command
PY_CMD="python3 src/run_analysis.py"

case $MODE in
    full)
        PY_CMD="$PY_CMD --full"
        ;;
    benchmark)
        PY_CMD="$PY_CMD --benchmark-only"
        ;;
    hardware)
        PY_CMD="$PY_CMD --hardware-only"
        ;;
    analysis)
        PY_CMD="$PY_CMD --analysis-only"
        ;;
    report)
        PY_CMD="$PY_CMD --report-only"
        ;;
    performance-test)
        PY_CMD="$PY_CMD --performance-test"
        ;;
    quick-test)
        PY_CMD="$PY_CMD --quick-test"
        ;;
    *)
        echo -e "${RED}Error: Invalid mode '$MODE'${NC}"
        exit 1
        ;;
esac

if [ "$PARALLEL" = true ]; then
    PY_CMD="$PY_CMD --use-processes"
fi

if [ "$OVERWRITE" = true ]; then
    PY_CMD="$PY_CMD --overwrite"
fi

# Execute the command
echo -e "${GREEN}Running: $PY_CMD${NC}"
$PY_CMD

echo -e "${GREEN}CORE-CC process completed successfully!${NC}"