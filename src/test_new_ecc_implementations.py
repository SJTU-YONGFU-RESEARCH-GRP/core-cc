#!/usr/bin/env python3
"""
Test script to verify all new ECC implementations work correctly.
"""

import sys
from pathlib import Path

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from base_ecc import ECCBase
from adaptive_ecc import AdaptiveECC
from three_d_memory_ecc import ThreeDMemoryECC
from primary_secondary_ecc import PrimarySecondaryECC
from cyclic_ecc import CyclicECC
from burst_error_ecc import BurstErrorECC

def test_ecc_implementation(ecc_class, name: str, **kwargs):
    """Test a single ECC implementation."""
    print(f"\n🔍 Testing {name}...")
    print("-" * 50)
    
    try:
        # Create ECC instance
        ecc = ecc_class(**kwargs)
        print(f"✅ {name} instantiated successfully")
        
        # Test data
        test_data = 0xAA  # 8-bit test data
        
        # Test encoding
        encoded = ecc.encode(test_data)
        print(f"✅ {name} encoding successful: {test_data} → {encoded}")
        
        # Test decoding (no errors)
        decoded, error_type = ecc.decode(encoded)
        print(f"✅ {name} decoding successful: {encoded} → {decoded} ({error_type})")
        
        # Test error injection and correction
        corrupted = ecc.inject_error(encoded, 2)  # Flip bit 2
        decoded_corrupted, error_type_corrupted = ecc.decode(corrupted)
        print(f"✅ {name} error handling: {error_type_corrupted}")
        
        # Verify round-trip
        if decoded == test_data:
            print(f"✅ {name} round-trip test PASSED")
            return True
        else:
            print(f"❌ {name} round-trip test FAILED: {test_data} != {decoded}")
            return False
            
    except Exception as e:
        print(f"❌ {name} test FAILED: {str(e)}")
        return False

def test_adaptive_ecc():
    """Test Adaptive ECC with different scenarios."""
    print("\n🔄 Testing Adaptive ECC scenarios...")
    
    # Test with different initial ECC types
    test_cases = [
        ("AdaptiveECC (Hamming)", AdaptiveECC, {"data_length": 8, "initial_ecc_type": "HammingSECDED"}),
        ("AdaptiveECC (Parity)", AdaptiveECC, {"data_length": 8, "initial_ecc_type": "ParityECC"}),
    ]
    
    results = []
    for name, ecc_class, kwargs in test_cases:
        result = test_ecc_implementation(ecc_class, name, **kwargs)
        results.append(result)
    
    return all(results)

def test_3d_memory_ecc():
    """Test 3D Memory ECC with different configurations."""
    print("\n🏗️  Testing 3D Memory ECC configurations...")
    
    test_cases = [
        ("ThreeDMemoryECC (4 layers)", ThreeDMemoryECC, {"data_length": 8, "layers": 4, "bits_per_layer": 2}),
        ("ThreeDMemoryECC (8 layers)", ThreeDMemoryECC, {"data_length": 8, "layers": 8, "bits_per_layer": 1}),
    ]
    
    results = []
    for name, ecc_class, kwargs in test_cases:
        result = test_ecc_implementation(ecc_class, name, **kwargs)
        results.append(result)
    
    return all(results)

def test_primary_secondary_ecc():
    """Test Primary/Secondary ECC with different combinations."""
    print("\n🛡️  Testing Primary/Secondary ECC combinations...")
    
    test_cases = [
        ("PrimarySecondaryECC (Hamming+Parity)", PrimarySecondaryECC, 
         {"data_length": 8, "primary_ecc": "HammingSECDED", "secondary_ecc": "ParityECC"}),
        ("PrimarySecondaryECC (BCH+Repetition)", PrimarySecondaryECC, 
         {"data_length": 8, "primary_ecc": "BCHECC", "secondary_ecc": "RepetitionECC"}),
    ]
    
    results = []
    for name, ecc_class, kwargs in test_cases:
        result = test_ecc_implementation(ecc_class, name, **kwargs)
        results.append(result)
    
    return all(results)

def test_cyclic_ecc():
    """Test Cyclic ECC with different parameters."""
    print("\n🔄 Testing Cyclic ECC parameters...")
    
    test_cases = [
        ("CyclicECC (15,7)", CyclicECC, {"n": 15, "k": 7, "data_length": 7}),
        ("CyclicECC (31,16)", CyclicECC, {"n": 31, "k": 16, "data_length": 16}),
    ]
    
    results = []
    for name, ecc_class, kwargs in test_cases:
        result = test_ecc_implementation(ecc_class, name, **kwargs)
        results.append(result)
    
    return all(results)

def test_burst_error_ecc():
    """Test Burst Error ECC with different burst lengths."""
    print("\n💥 Testing Burst Error ECC configurations...")
    
    test_cases = [
        ("BurstErrorECC (burst=3)", BurstErrorECC, {"data_length": 8, "burst_length": 3, "interleaving_depth": 4}),
        ("BurstErrorECC (burst=5)", BurstErrorECC, {"data_length": 8, "burst_length": 5, "interleaving_depth": 2}),
    ]
    
    results = []
    for name, ecc_class, kwargs in test_cases:
        result = test_ecc_implementation(ecc_class, name, **kwargs)
        results.append(result)
    
    return all(results)

def test_special_features():
    """Test special features of the new ECC implementations."""
    print("\n🌟 Testing special features...")
    
    try:
        # Test Adaptive ECC adaptation
        adaptive = AdaptiveECC(data_length=8)
        info = adaptive.get_adaptation_info()
        print(f"✅ Adaptive ECC info: {info}")
        
        # Test 3D Memory ECC info
        memory_3d = ThreeDMemoryECC(data_length=8)
        info = memory_3d.get_3d_info()
        print(f"✅ 3D Memory ECC info: {info}")
        
        # Test Primary/Secondary ECC info
        primary_secondary = PrimarySecondaryECC(data_length=8)
        info = primary_secondary.get_protection_info()
        print(f"✅ Primary/Secondary ECC info: {info}")
        
        # Test Cyclic ECC info
        cyclic = CyclicECC(n=15, k=7)
        info = cyclic.get_cyclic_info()
        print(f"✅ Cyclic ECC info: {info}")
        
        # Test Burst Error ECC info
        burst = BurstErrorECC(data_length=8)
        info = burst.get_burst_info()
        print(f"✅ Burst Error ECC info: {info}")
        
        return True
        
    except Exception as e:
        print(f"❌ Special features test FAILED: {str(e)}")
        return False

def main():
    """Run all tests for new ECC implementations."""
    print("🚀 Testing New ECC Implementations")
    print("=" * 60)
    
    # Test all new ECC types
    test_results = []
    
    # Test Adaptive ECC
    test_results.append(test_adaptive_ecc())
    
    # Test 3D Memory ECC
    test_results.append(test_3d_memory_ecc())
    
    # Test Primary/Secondary ECC
    test_results.append(test_primary_secondary_ecc())
    
    # Test Cyclic ECC
    test_results.append(test_cyclic_ecc())
    
    # Test Burst Error ECC
    test_results.append(test_burst_error_ecc())
    
    # Test special features
    test_results.append(test_special_features())
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 TEST SUMMARY")
    print("=" * 60)
    
    passed = sum(test_results)
    total = len(test_results)
    
    print(f"✅ Passed: {passed}/{total}")
    print(f"❌ Failed: {total - passed}/{total}")
    
    if all(test_results):
        print("\n🎉 ALL TESTS PASSED! New ECC implementations are ready for benchmarking.")
        print("\nTo run benchmarks with all ECC types:")
        print("  ./run_all.sh -m benchmark --with-report --use-processes --overwrite")
    else:
        print("\n⚠️  Some tests failed. Please check the errors above.")
    
    return all(test_results)

if __name__ == "__main__":
    main()