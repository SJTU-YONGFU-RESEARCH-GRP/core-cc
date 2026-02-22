import subprocess
from pathlib import Path
from typing import Dict, List

def run_verilator(
    tb_file: str,
    verilog_files: List[str],
    top_module: str,
    output_dir: str,
    extra_flags: List[str] = None
) -> Dict[str, str]:
    """
    Compile and run a Verilog testbench using Verilator.

    Args:
        tb_file (str): Path to the testbench Verilog file.
        verilog_files (List[str]): List of Verilog module files.
        top_module (str): Name of the top module (testbench).
        output_dir (str): Directory to store build and output files.

    Returns:
        Dict[str, str]: Dictionary with 'stdout' and 'stderr' from simulation.
    """
    output_dir = Path(output_dir)
    output_dir.mkdir(exist_ok=True, parents=True)
    cpp_dir = output_dir / "obj_dir"
    cpp_dir.mkdir(exist_ok=True, parents=True)  # Ensure obj_dir exists
    exe_name = cpp_dir / f"V{top_module}"

    print(f"    📂 Creating output directory: {output_dir}")
    print(f"    📂 C++ build directory: {cpp_dir}")

    # Detect if tb_file is C++ or Verilog
    is_cpp_tb = Path(tb_file).suffix in ['.cpp', '.cc', '.cxx']
    main_cpp = None

    if not is_cpp_tb:
        # Create a simple C++ main file for Verilator in output_dir
        main_cpp = (output_dir / "main.cpp").absolute()
        with open(main_cpp, "w") as f:
            f.write(f"""
#include "V{top_module}.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char** argv) {{
    Verilated::commandArgs(argc, argv);
    V{top_module}* top = new V{top_module};
    
    // Run simulation until finish
    while (!Verilated::gotFinish()) {{
        top->eval();
    }}
    
    delete top;
    return 0;
}}
""")
        print(f"    📝 Created C++ main file: {main_cpp}")
    else:
        print(f"    📝 Using provided C++ testbench: {tb_file}")

    verilator_cmd = [
        "verilator",
        "--cc",
        "--exe",
        "--build",
        f"--top-module", top_module,
    ]
    
    # Collect -D flags for C++ compiler (CFLAGS) and -G flags for Verilog parameter overrides
    cflags = []
    if extra_flags:
        verilator_cmd.extend(extra_flags)
        for flag in extra_flags:
            if flag.startswith("-D"):
                cflags.append(flag)
                # Also override the Verilog module parameter using -G flag.
                # -DNAME=VALUE sets a preprocessor macro but does NOT override
                # 'parameter NAME = default' in Verilog. We need -GNAME=VALUE for that.
                # Example: -DDATA_WIDTH=16 -> add -GDATA_WIDTH=16
                define_body = flag[2:]  # strip the leading "-D"
                if "=" in define_body:
                    param_name, param_value = define_body.split("=", 1)
                    verilator_cmd.extend([f"-G{param_name}={param_value}"])
    
    # Pass D-flags to the C++ compiler via -CFLAGS so testbench macros work too
    if cflags:
        cflags_str = " ".join(cflags)
        verilator_cmd.extend(["-CFLAGS", cflags_str])
    
    if main_cpp:
        verilator_cmd.append(str(main_cpp))
    
    verilator_cmd.append(str(Path(tb_file).absolute()))
    for v_file in verilog_files:
        verilator_cmd.append(str(Path(v_file).absolute()))
        
    verilator_cmd.extend([
        "--Mdir", str(cpp_dir.absolute()),
        "--trace",
        "-I" + str(Path(tb_file).absolute().parent), # Include testbench directory for headers like ecc_test_utils.h
        "-I" + str(Path("verilogs/generated").absolute()) # Include generated modules for BCH, etc.
    ])
    
    print(f"    🔨 Running Verilator build command...")
    print(f"    📋 Command: {' '.join(verilator_cmd)}")
    
    build = subprocess.run(verilator_cmd, capture_output=True, text=True)
    
    if build.returncode != 0:
        print(f"    ❌ Verilator build failed with return code: {build.returncode}")
        if build.stderr:
            print(f"    📄 Build errors:")
            for line in build.stderr.strip().split('\n'):
                if line.strip():
                    print(f"      {line}")
        return {"stdout": "", "stderr": build.stderr}
    else:
        print(f"    ✅ Verilator build completed successfully")
        if build.stdout:
            print(f"    📄 Build output:")
            for line in build.stdout.strip().split('\n'):
                if line.strip():
                    print(f"      {line}")

    print(f"    🚀 Running simulation executable: {exe_name}")
    
    # Run simulation and capture output
    sim = subprocess.run([str(exe_name)], capture_output=True, text=True)
    
    print(f"    📊 Simulation completed with return code: {sim.returncode}")
    
    # Save simulation output to log file for report parsing
    sim_log = output_dir / "simulation.log"
    with open(sim_log, 'w') as f:
        f.write(f"# Verilator Simulation Log for {top_module}\n")
        f.write(f"# Testbench: {tb_file}\n")
        f.write(f"# Modules: {', '.join(verilog_files)}\n")
        f.write(f"# Return code: {sim.returncode}\n")
        f.write("=" * 50 + "\n\n")
        f.write(sim.stdout)
        if sim.stderr:
            f.write("\n--- STDERR ---\n")
            f.write(sim.stderr)
    
    print(f"    📄 Simulation log saved to: {sim_log}")
    
    return {"stdout": sim.stdout, "stderr": sim.stderr}

def test_hamming_encoder():
    """Test the Hamming encoder in isolation."""
    print("Testing Hamming encoder in isolation...")
    
    result = run_verilator(
        "testbenches/hamming_tb.v",
        ["verilogs/hamming_encoder.v", "verilogs/hamming_decoder.v"],
        "hamming_tb",
        "results/hamming_test"
    )
    
    print("Simulation output:")
    print(result["stdout"])
    if result["stderr"]:
        print("Simulation errors:")
        print(result["stderr"])

if __name__ == "__main__":
    test_hamming_encoder() 