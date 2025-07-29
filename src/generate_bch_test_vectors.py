#!/usr/bin/env python3
"""
Generate BCH test vectors for Verilog testbenches.
This script generates expected codewords and error patterns for different BCH configurations.
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from typing import List, Tuple, Dict
from bch_ecc import BCHECC, BCHConfig
import json

def generate_bch_test_vectors() -> Dict:
    """
    Generate test vectors for different BCH configurations.
    
    Returns:
        Dictionary containing test vectors for each BCH configuration
    """
    test_vectors = {}
    
    # BCH(7,4,1) test vectors
    bch74 = BCHECC(n=7, k=4, t=1)
    test_vectors['bch74'] = {
        'config': {'n': 7, 'k': 4, 't': 1},
        'test_cases': []
    }
    
    for i in range(16):  # Test all 4-bit inputs
        data = i
        codeword = bch74.encode(data)
        decoded_data, error_type = bch74.decode(codeword)
        
        test_vectors['bch74']['test_cases'].append({
            'input_data': data,
            'expected_codeword': codeword,
            'expected_decoded': decoded_data,
            'error_type': error_type
        })
    
    # BCH(15,7,2) test vectors
    bch1572 = BCHECC(n=15, k=7, t=2)
    test_vectors['bch1572'] = {
        'config': {'n': 15, 'k': 7, 't': 2},
        'test_cases': []
    }
    
    for i in range(128):  # Test all 7-bit inputs
        data = i
        codeword = bch1572.encode(data)
        decoded_data, error_type = bch1572.decode(codeword)
        
        test_vectors['bch1572']['test_cases'].append({
            'input_data': data,
            'expected_codeword': codeword,
            'expected_decoded': decoded_data,
            'error_type': error_type
        })
    
    # BCH(31,16,3) test vectors (subset due to size)
    bch31163 = BCHECC(n=31, k=16, t=3)
    test_vectors['bch31163'] = {
        'config': {'n': 31, 'k': 16, 't': 3},
        'test_cases': []
    }
    
    # Test a subset of 16-bit inputs
    test_inputs = [0, 1, 0xFFFF, 0xABCD, 0x1234, 0x5678, 0x9ABC, 0xDEF0]
    for data in test_inputs:
        codeword = bch31163.encode(data)
        decoded_data, error_type = bch31163.decode(codeword)
        
        test_vectors['bch31163']['test_cases'].append({
            'input_data': data,
            'expected_codeword': codeword,
            'expected_decoded': decoded_data,
            'error_type': error_type
        })
    
    # BCH(63,32,6) test vectors (subset due to size)
    bch63326 = BCHECC(n=63, k=32, t=6)
    test_vectors['bch63326'] = {
        'config': {'n': 63, 'k': 32, 't': 6},
        'test_cases': []
    }
    
    # Test a subset of 32-bit inputs
    test_inputs = [0, 1, 0xFFFFFFFF, 0x12345678, 0xABCDEF01, 0x87654321]
    for data in test_inputs:
        codeword = bch63326.encode(data)
        decoded_data, error_type = bch63326.decode(codeword)
        
        test_vectors['bch63326']['test_cases'].append({
            'input_data': data,
            'expected_codeword': codeword,
            'expected_decoded': decoded_data,
            'error_type': error_type
        })
    
    return test_vectors

def generate_error_patterns(test_vectors: Dict) -> Dict:
    """
    Generate error patterns for testing error detection and correction.
    
    Args:
        test_vectors: Dictionary containing test vectors
        
    Returns:
        Dictionary containing error patterns for each BCH configuration
    """
    error_patterns = {}
    
    for config_name, config_data in test_vectors.items():
        error_patterns[config_name] = {
            'single_bit_errors': [],
            'double_bit_errors': [],
            'burst_errors': []
        }
        
        # Use first test case for error pattern generation
        test_case = config_data['test_cases'][0]
        codeword = test_case['expected_codeword']
        n = config_data['config']['n']
        
        # Generate single bit errors
        for i in range(min(n, 20)):  # Limit to first 20 bits for large codes
            error_codeword = codeword ^ (1 << i)
            error_patterns[config_name]['single_bit_errors'].append({
                'original_codeword': codeword,
                'error_position': i,
                'error_codeword': error_codeword
            })
        
        # Generate double bit errors (for codes that can correct 2+ errors)
        if config_data['config']['t'] >= 2:
            for i in range(min(n-1, 10)):
                for j in range(i+1, min(n, i+10)):
                    error_codeword = codeword ^ (1 << i) ^ (1 << j)
                    error_patterns[config_name]['double_bit_errors'].append({
                        'original_codeword': codeword,
                        'error_positions': [i, j],
                        'error_codeword': error_codeword
                    })
        
        # Generate burst errors (3 consecutive bits)
        for i in range(min(n-2, 10)):
            error_codeword = codeword ^ (1 << i) ^ (1 << (i+1)) ^ (1 << (i+2))
            error_patterns[config_name]['burst_errors'].append({
                'original_codeword': codeword,
                'burst_start': i,
                'error_codeword': error_codeword
            })
    
    return error_patterns

def write_verilog_test_vectors(test_vectors: Dict, error_patterns: Dict, output_file: str) -> None:
    """
    Write test vectors in Verilog format.
    
    Args:
        test_vectors: Dictionary containing test vectors
        error_patterns: Dictionary containing error patterns
        output_file: Output file path
    """
    with open(output_file, 'w') as f:
        f.write("// Auto-generated BCH test vectors\n")
        f.write("// Generated from Python BCH implementation\n\n")
        
        for config_name, config_data in test_vectors.items():
            f.write(f"// {config_name.upper()} Test Vectors\n")
            f.write(f"// Config: n={config_data['config']['n']}, k={config_data['config']['k']}, t={config_data['config']['t']}\n\n")
            
            # Write test cases
            f.write(f"// Test cases for {config_name}\n")
            for i, test_case in enumerate(config_data['test_cases'][:10]):  # Limit to first 10
                f.write(f"// Test {i}: Input={test_case['input_data']}, Expected={test_case['expected_codeword']}\n")
            
            f.write("\n")
            
            # Write error patterns
            if config_name in error_patterns:
                f.write(f"// Error patterns for {config_name}\n")
                error_data = error_patterns[config_name]
                
                f.write("// Single bit errors\n")
                for i, error in enumerate(error_data['single_bit_errors'][:5]):  # Limit to first 5
                    f.write(f"// Error {i}: Position={error['error_position']}, Codeword={error['error_codeword']}\n")
                
                if error_data['double_bit_errors']:
                    f.write("// Double bit errors\n")
                    for i, error in enumerate(error_data['double_bit_errors'][:3]):  # Limit to first 3
                        f.write(f"// Error {i}: Positions={error['error_positions']}, Codeword={error['error_codeword']}\n")
                
                f.write("\n")

def main() -> None:
    """Generate BCH test vectors and write them to files."""
    print("Generating BCH test vectors...")
    
    # Generate test vectors
    test_vectors = generate_bch_test_vectors()
    error_patterns = generate_error_patterns(test_vectors)
    
    # Write JSON file
    with open('bch_test_vectors.json', 'w') as f:
        json.dump({
            'test_vectors': test_vectors,
            'error_patterns': error_patterns
        }, f, indent=2)
    
    # Write Verilog format
    write_verilog_test_vectors(test_vectors, error_patterns, 'bch_test_vectors.v')
    
    print("Generated test vectors:")
    print("- bch_test_vectors.json (JSON format)")
    print("- bch_test_vectors.v (Verilog format)")
    
    # Print summary
    for config_name, config_data in test_vectors.items():
        print(f"{config_name}: {len(config_data['test_cases'])} test cases")

if __name__ == "__main__":
    main()