#!/usr/bin/env python3
"""
Single ECC Verilator Runner

This script allows running Verilator simulation on a specific ECC testbench
for easier debugging and development.
"""

import sys
import argparse
from pathlib import Path
from typing import Optional

# Add src directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from verilator_runner import run_verilator


def get_available_testbenches() -> dict[str, list[str]]:
    """
    Get available testbenches and their required module files.
    
    Returns:
        dict: Mapping of testbench names to their required Verilog modules.
    """
    return {
        "parity_tb": ["parity_encoder.v", "parity_decoder.v"],
        "hamming_tb": ["hamming_encoder.v", "hamming_decoder.v"],
        "hamming_simple_tb": ["hamming_encoder.v"],
        "hamming_inline_tb": [],  # No external modules needed
        "hamming_direct_tb": [],  # No external modules needed
        "composite_tb": ["composite_ecc.v", "system_ecc.v", "parity_encoder.v", "parity_decoder.v", "hamming_encoder.v", "hamming_decoder.v"],
        "system_tb": ["system_ecc.v", "hamming_encoder.v", "hamming_decoder.v"],
        "simple_tb": [],  # No external modules needed
        "basic_tb": ["simple_encoder.v"],
        "constant_tb": ["constant_encoder.v"],
        "direct_tb": ["constant_encoder.v"],
        "bch74_tb": ["bch74_ecc.v"],
        "rs15_11_tb": ["rs15_11_ecc.v"],
        "test_tb": ["test_encoder.v"]
    }


def list_available_testbenches() -> None:
    """List all available testbenches with their descriptions."""
    tb_mapping = get_available_testbenches()
    
    print("Available ECC testbenches:")
    print("=" * 50)
    
    for tb_name, modules in tb_mapping.items():
        print(f"📋 {tb_name}")
        print(f"   Modules: {', '.join(modules)}")
        print()


def run_single_testbench(tb_name: str, verbose: bool = False, output_dir: Optional[str] = None) -> bool:
    """
    Run Verilator simulation for a specific testbench.
    
    Args:
        tb_name: Name of the testbench to run (without .v extension)
        verbose: Whether to show detailed output
        output_dir: Custom output directory (optional)
        
    Returns:
        bool: True if simulation passed, False otherwise
    """
    tb_mapping = get_available_testbenches()
    
    if tb_name not in tb_mapping:
        print(f"❌ Error: Testbench '{tb_name}' not found.")
        print("Available testbenches:")
        for name in tb_mapping.keys():
            print(f"  - {name}")
        return False
    
    # Setup paths
    project_root = Path(__file__).parent.parent
    tb_file = project_root / "testbenches" / f"{tb_name}.v"
    verilog_dir = project_root / "verilogs"
    
    if not tb_file.exists():
        print(f"❌ Error: Testbench file not found: {tb_file}")
        return False
    
    # Determine output directory
    if output_dir is None:
        output_dir = project_root / "results" / tb_name
    else:
        output_dir = Path(output_dir)
    
    # Get required modules
    required_modules = tb_mapping[tb_name]
    verilog_files = []
    
    print(f"🔍 Running Verilator for testbench: {tb_name}")
    print(f"📁 Testbench file: {tb_file}")
    print(f"📂 Output directory: {output_dir}")
    print(f"📋 Required modules: {required_modules}")
    print()
    
    # Check if all required modules exist
    for module in required_modules:
        module_path = verilog_dir / module
        if module_path.exists():
            verilog_files.append(str(module_path))
            print(f"✅ Found: {module}")
        else:
            print(f"❌ Missing: {module} (expected at {module_path})")
    
    # Allow testbenches that don't require external modules
    if not verilog_files and required_modules:
        print("❌ Error: No valid module files found.")
        return False
    
    print()
    print("🚀 Starting Verilator simulation...")
    print("-" * 50)
    
    try:
        result = run_verilator(
            str(tb_file),
            verilog_files,
            top_module=tb_name,
            output_dir=str(output_dir)
        )
        
        print("-" * 50)
        print("📊 Simulation Results:")
        print("-" * 50)
        
        # Show simulation output
        if result["stdout"].strip():
            print("📄 Simulation Output:")
            for line in result["stdout"].strip().split('\n'):
                if line.strip():
                    print(f"  {line}")
            print()
        
        # Show warnings/errors
        if result["stderr"].strip():
            print("⚠️  Warnings/Errors:")
            for line in result["stderr"].strip().split('\n'):
                if line.strip():
                    print(f"  {line}")
            print()
        
        # Determine result
        if "RESULT:PASS" in result["stdout"]:
            print("✅ RESULT: PASS")
            return True
        elif "RESULT:FAIL" in result["stdout"]:
            print("❌ RESULT: FAIL")
            return False
        else:
            print("❓ RESULT: UNKNOWN")
            return False
            
    except Exception as e:
        print(f"💥 Error running Verilator: {e}")
        return False


def main() -> None:
    """Main function to handle command line arguments and run simulation."""
    parser = argparse.ArgumentParser(
        description="Run Verilator simulation on a specific ECC testbench",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python src/verilate_single.py --list                    # List all available testbenches
  python src/verilate_single.py hamming_tb                # Run hamming testbench
  python src/verilate_single.py bch74_tb --verbose        # Run BCH testbench with verbose output
  python src/verilate_single.py parity_tb --output debug  # Run parity testbench with custom output dir
        """
    )
    
    parser.add_argument(
        "testbench",
        nargs="?",
        help="Name of the testbench to run (without .v extension)"
    )
    
    parser.add_argument(
        "--list", "-l",
        action="store_true",
        help="List all available testbenches"
    )
    
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Show detailed output"
    )
    
    parser.add_argument(
        "--output", "-o",
        help="Custom output directory for simulation results"
    )
    
    args = parser.parse_args()
    
    # List available testbenches if requested
    if args.list:
        list_available_testbenches()
        return
    
    # Check if testbench name is provided
    if not args.testbench:
        print("❌ Error: Please specify a testbench name or use --list to see available options.")
        print("Usage: python src/verilate_single.py <testbench_name>")
        print("Use --help for more information.")
        return
    
    # Run the specified testbench
    success = run_single_testbench(args.testbench, args.verbose, args.output)
    
    if success:
        print("\n🎉 Simulation completed successfully!")
    else:
        print("\n💥 Simulation failed or had issues.")
        sys.exit(1)


if __name__ == "__main__":
    main() 