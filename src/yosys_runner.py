import subprocess
from pathlib import Path
from typing import Dict

def run_yosys(verilog_file: str, top_module: str, output_dir: str, parameters: Dict[str, int] = None) -> Dict[str, int]:
    """
    Run Yosys synthesis and return area/timing info.

    Args:
        verilog_file (str): Path to the Verilog file.
        top_module (str): Name of the top module.
        output_dir (str): Directory to store Yosys script and logs.
        parameters (Dict[str, int], optional): Dictionary of parameters to set.

    Returns:
        Dict[str, int]: Dictionary with area and Yosys log.
    """
    param_str = ""
    if parameters:
        for name, value in parameters.items():
            param_str += f"chparam -set {name} {value} {top_module}\n    "
    
    # Expand wildcard paths using Python glob since Yosys read_verilog might not support it robustly
    verilog_path = Path(verilog_file)
    verilog_dir = verilog_path.parent
    generated_dir = verilog_dir / "generated"
    
    read_commands = ""
    # Read common files first... careful with duplicates if target file is in common
    # We can exclude target file here and rely on explicit read later, or rely on Yosys handling re-reads.
    # To be safe, let's just read everything except target first.
    
    # Read common modules in verilogs/
    for f in verilog_dir.glob("*.v"):
        if f != verilog_path:
             read_commands += f"read_verilog -sv {f}\n    "
             
    # Read generated modules with heuristic filtering
    # Only include ALL generated files for composite modules that might depend on them.
    # For others, only include files matching the top module name (e.g. bch_ecc -> bch_ecc_w*.v)
    COMPOSITE_MODULES = [] # Was: ['product_code_ecc', ...] - Removed to avoid loading all generated files
    
    if generated_dir.exists():
        if top_module in COMPOSITE_MODULES:
            # Include all for safety
             for f in generated_dir.glob("*.v"):
                  read_commands += f"read_verilog -sv {f}\n    "
        else:
            # Filter by prefix
             for f in generated_dir.glob(f"{top_module}_w*.v"):
                  read_commands += f"read_verilog -sv {f}\n    "
    
    script = f"""
    {read_commands}
    read_verilog -sv {verilog_file}
    {param_str}
    hierarchy -top {top_module}
    synth
    stat
    """
    # Use unique script name to avoid collisions in parallel execution
    width = parameters.get("DATA_WIDTH", "") if parameters else ""
    script_name = f"run_{top_module}_{width}.ys" if width else f"run_{top_module}.ys"
    script_path = Path(output_dir) / script_name
    
    with open(script_path, "w") as f:
        f.write(script)
    result = subprocess.run(
        ["yosys", "-s", str(script_path)],
        capture_output=True, text=True
    )
    area = None
    for line in result.stdout.splitlines():
        line = line.strip()
        if "Number of cells:" in line:
            area = int(line.split(":")[1].strip())
        elif line.endswith("cells") and line.split()[0].isdigit():
             # Format: "   59 cells"
             try:
                area = int(line.split()[0])
             except:
                pass
    return {"area": area, "yosys_log": result.stdout} 