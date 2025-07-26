import sys
import shutil
from pathlib import Path

# Add src directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from verilator_runner import run_verilator

def check_verilator_installed() -> bool:
    """
    Check if Verilator is installed and available in PATH.
    
    Returns:
        bool: True if Verilator is available, False otherwise.
    """
    return shutil.which("verilator") is not None

def main() -> None:
    """
    Run Verilator simulation for all testbenches in /testbenches and aggregate PASS/FAIL results.
    """
    # Check if Verilator is installed
    if not check_verilator_installed():
        print("ERROR: Verilator is not installed or not in PATH.")
        print("To install Verilator:")
        print("  Ubuntu/Debian: sudo apt-get install verilator")
        print("  CentOS/RHEL: sudo yum install verilator")
        print("  macOS: brew install verilator")
        print("  Or download from: https://www.veripool.org/veripool/")
        print("\nSkipping Verilator simulation step.")
        return

    VERILOG_DIR = Path(__file__).parent.parent / "verilogs"
    TB_DIR = Path(__file__).parent.parent / "testbenches"
    OUTPUT_DIR = Path(__file__).parent.parent / "results"
    OUTPUT_DIR.mkdir(exist_ok=True)

    # Define testbench to module file mappings
    tb_to_modules = {
        "parity_tb": ["parity_encoder.v", "parity_decoder.v"],
        "hamming_tb": ["hamming_encoder.v", "hamming_decoder.v"],
        "composite_tb": ["composite_ecc.v", "system_ecc.v", "parity_encoder.v", "parity_decoder.v", "hamming_encoder.v", "hamming_decoder.v"],
        "system_tb": ["system_ecc.v", "hamming_encoder.v", "hamming_decoder.v"],
        "simple_tb": ["simple_encoder.v"],
        "basic_tb": ["simple_encoder.v"],
        "constant_tb": ["constant_encoder.v"],
        "direct_tb": ["constant_encoder.v"],  # Use a dummy module file
        "bch74_tb": ["bch74_ecc.v"],
        "rs15_11_tb": ["rs15_11_ecc.v"],
        "hamming_simple_tb": ["hamming_encoder.v"],
        "test_tb": ["test_encoder.v"]
        # Add other testbenches and their modules here
    }

    print(f"Found {len(list(TB_DIR.glob('*_tb.v')))} testbench files in {TB_DIR}")
    print(f"Verilog modules directory: {VERILOG_DIR}")
    print(f"Output directory: {OUTPUT_DIR}")
    print()

    summary = {}
    total_tests = len(list(TB_DIR.glob("*_tb.v")))
    current_test = 0
    
    for tb_file in TB_DIR.glob("*_tb.v"):
        current_test += 1
        tb_name = tb_file.stem
        
        print(f"[{current_test}/{total_tests}] Processing testbench: {tb_file.name}")
        
        if tb_name not in tb_to_modules:
            print(f"  ⚠️  Warning: No module mapping found for {tb_file}")
            summary[tb_file.name] = "SKIP"
            continue
            
        module_files = tb_to_modules[tb_name]
        verilog_files = []
        
        print(f"  📁 Required modules: {module_files}")
        
        for module_file in module_files:
            vfile = VERILOG_DIR / module_file
            if not vfile.exists():
                print(f"  ❌ Warning: {vfile} not found for {tb_file}")
            else:
                verilog_files.append(str(vfile))
                print(f"  ✅ Found: {module_file}")
        
        if not verilog_files:
            print(f"  ❌ Warning: No valid module files found for {tb_file}")
            summary[tb_file.name] = "SKIP"
            continue
            
        print(f"  🔧 Running Verilator for {tb_file.name}...")
        print(f"  📂 Output directory: {OUTPUT_DIR / tb_file.stem}")
        
        try:
            res = run_verilator(
                str(tb_file),
                verilog_files,
                top_module=tb_file.stem,
                output_dir=OUTPUT_DIR / tb_file.stem
            )
            
            print(f"  📊 Simulation completed for {tb_file.name}")
            
            # Show detailed output
            if res["stdout"].strip():
                print(f"  📄 Simulation output:")
                for line in res["stdout"].strip().split('\n'):
                    if line.strip():
                        print(f"    {line}")
            
            if res["stderr"].strip():
                print(f"  ⚠️  Simulation warnings/errors:")
                for line in res["stderr"].strip().split('\n'):
                    if line.strip():
                        print(f"    {line}")
            
            # Parse PASS/FAIL
            if "RESULT:PASS" in res["stdout"]:
                summary[tb_file.name] = "PASS"
                print(f"  ✅ RESULT: PASS")
            elif "RESULT:FAIL" in res["stdout"]:
                summary[tb_file.name] = "FAIL"
                print(f"  ❌ RESULT: FAIL")
            else:
                summary[tb_file.name] = "UNKNOWN"
                print(f"  ❓ RESULT: UNKNOWN")
                
        except Exception as e:
            print(f"  💥 Error running Verilator for {tb_file.name}: {e}")
            summary[tb_file.name] = "ERROR"
        
        print()  # Empty line for readability

    # Print summary
    print("=" * 60)
    print("VERILATOR SIMULATION SUMMARY")
    print("=" * 60)
    
    pass_count = sum(1 for result in summary.values() if result == "PASS")
    fail_count = sum(1 for result in summary.values() if result == "FAIL")
    error_count = sum(1 for result in summary.values() if result == "ERROR")
    skip_count = sum(1 for result in summary.values() if result == "SKIP")
    unknown_count = sum(1 for result in summary.values() if result == "UNKNOWN")
    
    print(f"Total testbenches: {len(summary)}")
    print(f"✅ PASS: {pass_count}")
    print(f"❌ FAIL: {fail_count}")
    print(f"💥 ERROR: {error_count}")
    print(f"⏭️  SKIP: {skip_count}")
    print(f"❓ UNKNOWN: {unknown_count}")
    print()
    
    for tb, result in summary.items():
        status_icon = {
            "PASS": "✅",
            "FAIL": "❌", 
            "ERROR": "💥",
            "SKIP": "⏭️",
            "UNKNOWN": "❓"
        }.get(result, "❓")
        print(f"{status_icon} {tb}: {result}")
    
    print()
    print("Detailed logs available in:")
    for tb_name in summary.keys():
        log_file = OUTPUT_DIR / tb_name / "simulation.log"
        if log_file.exists():
            print(f"  📄 {log_file}")

if __name__ == "__main__":
    main()