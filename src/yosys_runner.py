import subprocess
from pathlib import Path
from typing import Dict

def run_yosys(verilog_file: str, top_module: str, output_dir: str) -> Dict[str, int]:
    """
    Run Yosys synthesis and return area/timing info.

    Args:
        verilog_file (str): Path to the Verilog file.
        top_module (str): Name of the top module.
        output_dir (str): Directory to store Yosys script and logs.

    Returns:
        Dict[str, int]: Dictionary with area and Yosys log.
    """
    script = f"""
    read_verilog {verilog_file}
    synth -top {top_module}
    stat
    """
    script_path = Path(output_dir) / "run.ys"
    with open(script_path, "w") as f:
        f.write(script)
    result = subprocess.run(
        ["yosys", "-s", str(script_path)],
        capture_output=True, text=True
    )
    area = None
    for line in result.stdout.splitlines():
        if "Number of cells:" in line:
            area = int(line.split(":")[1].strip())
    return {"area": area, "yosys_log": result.stdout} 