#!/usr/bin/env python3
"""
Cleanup script to reorganize build directories under results folder.

This script moves build artifacts from the root directory to results/build
for better organization and easier maintenance.
"""

import shutil
from pathlib import Path
from typing import List, Optional


def cleanup_build_directories() -> None:
    """
    Clean up and reorganize build directories.
    
    Moves build artifacts from root directory to results/build for better organization.
    """
    print("🧹 Cleaning up build directories...")
    
    # Create results/build directory
    results_build = Path("results/build")
    results_build.mkdir(exist_ok=True, parents=True)
    
    # Directories to move from root to results/build
    root_dirs_to_move = ["obj_dir", "build"]
    
    for dir_name in root_dirs_to_move:
        root_dir = Path(dir_name)
        if root_dir.exists():
            target_dir = results_build / dir_name
            
            print(f"📦 Moving {dir_name} to results/build/{dir_name}")
            
            # If target already exists, merge them
            if target_dir.exists():
                print(f"  ⚠️  Target directory exists, merging contents...")
                for item in root_dir.iterdir():
                    if item.is_dir():
                        if (target_dir / item.name).exists():
                            print(f"    📁 Merging directory: {item.name}")
                            shutil.move(str(item), str(target_dir / item.name))
                        else:
                            print(f"    📁 Moving directory: {item.name}")
                            shutil.move(str(item), str(target_dir))
                    else:
                        print(f"    📄 Moving file: {item.name}")
                        shutil.move(str(item), str(target_dir))
                
                # Remove the now-empty source directory
                root_dir.rmdir()
            else:
                # Simple move if target doesn't exist
                shutil.move(str(root_dir), str(target_dir))
            
            print(f"  ✅ Moved {dir_name} successfully")
        else:
            print(f"  ℹ️  {dir_name} not found in root directory")
    
    print("✅ Build directory cleanup completed!")


def list_build_artifacts() -> None:
    """
    List all build artifacts in the project.
    """
    print("📋 Current build artifacts:")
    
    # Check root directory
    root_artifacts = []
    for item in Path(".").iterdir():
        if item.is_dir() and item.name in ["obj_dir", "build"]:
            root_artifacts.append(item)
    
    if root_artifacts:
        print("  Root directory:")
        for artifact in root_artifacts:
            print(f"    📁 {artifact.name}/")
    else:
        print("  Root directory: No build artifacts found")
    
    # Check results directory
    results_dir = Path("results")
    if results_dir.exists():
        print("  Results directory:")
        for item in results_dir.iterdir():
            if item.is_dir():
                if item.name == "build":
                    print(f"    📁 {item.name}/")
                    # List contents of build directory
                    build_dir = results_dir / "build"
                    if build_dir.exists():
                        for subitem in build_dir.iterdir():
                            if subitem.is_dir():
                                print(f"      📁 {subitem.name}/")
                            else:
                                print(f"      📄 {subitem.name}")
                elif "obj_dir" in str(item):
                    print(f"    📁 {item.name}/")
                elif item.name.endswith("_tb"):
                    print(f"    📁 {item.name}/")
                    # Check for obj_dir in testbench directories
                    tb_obj_dir = item / "obj_dir"
                    if tb_obj_dir.exists():
                        print(f"      📁 obj_dir/")
    
    print()


def main() -> None:
    """
    Main function to run the cleanup process.
    """
    print("=" * 60)
    print("ECC Build Directory Cleanup Tool")
    print("=" * 60)
    
    # List current artifacts
    list_build_artifacts()
    
    # Ask for confirmation
    response = input("Do you want to reorganize build directories under results/build? (y/N): ")
    if response.lower() in ['y', 'yes']:
        cleanup_build_directories()
        print("\n" + "=" * 60)
        print("Cleanup completed! New structure:")
        print("=" * 60)
        list_build_artifacts()
    else:
        print("Cleanup cancelled.")


if __name__ == "__main__":
    main() 