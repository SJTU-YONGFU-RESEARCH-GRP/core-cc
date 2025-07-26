import sys
from pathlib import Path

# Add src directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from yosys_runner import run_yosys

def main() -> None:
    """
    Run Yosys synthesis for all Verilog ECC modules in /verilogs.
    """
    VERILOG_DIR = Path(__file__).parent.parent / "verilogs"
    OUTPUT_DIR = Path(__file__).parent.parent / "results"
    OUTPUT_DIR.mkdir(exist_ok=True)

    results = {}
    for vfile in VERILOG_DIR.glob("*.v"):
        top_module = vfile.stem
        print(f"Synthesizing {vfile.name} (top: {top_module})...")
        res = run_yosys(str(vfile), top_module, str(OUTPUT_DIR))
        results[vfile.name] = res["area"]
        print(f"  Area (Number of cells): {res['area']}")
    
    print("\nSummary:")
    for name, area in results.items():
        print(f"{name}: {area} cells")

if __name__ == "__main__":
    main() 