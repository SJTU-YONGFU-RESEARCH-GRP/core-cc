import sys
from pathlib import Path
import json

# Add src directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from yosys_runner import run_yosys

def main() -> None:
    """
    Run Yosys synthesis for all Verilog ECC modules across multiple widths.
    Validates physical implementation feasibility (Phase 4).
    """
    VERILOG_DIR = Path(__file__).parent.parent / "verilogs"
    OUTPUT_DIR = Path(__file__).parent.parent / "results"
    OUTPUT_DIR.mkdir(exist_ok=True)


    import argparse
    parser = argparse.ArgumentParser(description="Synthesize ECC modules")
    parser.add_argument("--modules", type=str, help="Comma-separated list of modules to synthesize (e.g. ldpc_ecc)")
    args = parser.parse_args()

    widths = [4, 8, 16, 32, 64, 128]
    results = {}

    all_files = sorted(list(VERILOG_DIR.glob("*.v")))
    
    if args.modules:
        targets = [m.strip() for m in args.modules.split(",")]
        verilog_files = [f for f in all_files if f.stem in targets]
        if not verilog_files:
            print(f"Error: No matching modules found for {targets}")
            return
    else:
        # Filter to only the 26 core ECC modules to avoid synthesizing helpers/variants
        TARGET_MODULES = [
            'adaptive_ecc', 'bch_ecc', 'burst_error_ecc', 'composite_ecc', 'concatenated_ecc',
            'convolutional_ecc', 'crc_ecc', 'cyclic_ecc', 'extended_hamming_ecc', 'fire_code_ecc',
            'golay_ecc', 'hamming_secded_ecc', 'ldpc_ecc', 'non_binary_ldpc_ecc', 'parity_ecc',
            'polar_ecc', 'primary_secondary_ecc', 'product_code_ecc', 'raptor_code_ecc',
            'reed_muller_ecc', 'reed_solomon_ecc', 'repetition_ecc', 'spatially_coupled_ldpc_ecc',
            'system_ecc', 'three_d_memory_ecc', 'turbo_ecc'
        ]
        verilog_files = [f for f in all_files if f.stem in TARGET_MODULES]
    
    
    # Run in parallel using multiprocessing
    from multiprocessing import Pool, cpu_count
    
    tasks = []
    for vfile in verilog_files:
        top_module = vfile.stem
        for w in widths:
            tasks.append((vfile, top_module, w, OUTPUT_DIR))
            
    MAX_WORKERS = 2 # Conservative for stability
    print(f"Synthesizing {len(verilog_files)} modules x {len(widths)} widths = {len(tasks)} tasks...")
    print(f"Using {MAX_WORKERS} parallel workers.")
    
    with Pool(MAX_WORKERS) as p:
        # map_async matches tasks to results order
        results_list = p.map(process_module_width, tasks)
        
    # Aggregate results
    # results_list contains (top_module, width, area_or_None)
    for top_module, width, area in results_list:
        if top_module not in results:
            results[top_module] = {}
        results[top_module][width] = area

    # Save results
    json_path = OUTPUT_DIR / "synthesis_results.json"
    with open(json_path, "w") as f:
        json.dump(results, f, indent=2)
    
    print(f"\nSynthesis complete. Results saved to {json_path}")

def process_module_width(args):
    """Worker function for parallel synthesis."""
    vfile, top_module, w, output_dir = args
    try:
        # print(f"Synthesizing {top_module} w{w}...", flush=True) # avoiding too much spam
        res = run_yosys(str(vfile), top_module, str(output_dir), {"DATA_WIDTH": w})
        area = res["area"]
        if area is not None:
             # print(f"  {top_module} w{w}: {area} cells")
             return (top_module, w, area)
        else:
             print(f"FAIL: {top_module} w{w}")
             log = res.get('yosys_log', '')
             if log:
                 print(f"Log end: {log[-500:]}")
             return (top_module, w, None)
    except Exception as e:
        print(f"ERROR: {top_module} w{w}: {e}")
        return (top_module, w, None)

if __name__ == "__main__":
    main()