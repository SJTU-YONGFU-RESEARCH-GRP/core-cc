import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from hamming_secded_ecc import HammingSECDEDECC
from extended_hamming_ecc import ExtendedHammingECC
import random

def test_hamming_widths():
    widths = [4, 8, 16, 32, 64, 128]
    print("Testing HammingSECDEDECC and ExtendedHammingECC across all widths...")
    
    passed = True
    
    for width in widths:
        print(f"\nTesting width: {width} bits")
        
        # Test HammingSECDEDECC
        try:
            ecc = HammingSECDEDECC(word_length=width)
            data = random.getrandbits(width)
            encoded = ecc.encode(data)
            decoded, status = ecc.decode(encoded)
            
            if decoded != data:
                print(f"❌ HammingSECDEDECC FAILED at {width} bits")
                print(f"  Data: {bin(data)}")
                print(f"  Decoded: {bin(decoded)}")
                passed = False
            else:
                print(f"✅ HammingSECDEDECC passed {width} bits")
                
            # Test Single Error Correction
            error_pos = random.randint(0, ecc.n - 1)
            corrupted = encoded ^ (1 << error_pos)
            decoded_err, status_err = ecc.decode(corrupted)
            if decoded_err != data:
                 print(f"❌ HammingSECDEDECC Single Error Correction FAILED at {width} bits")
                 passed = False
            else:
                 print(f"✅ HammingSECDEDECC Single Error Correction passed {width} bits")

        except Exception as e:
            print(f"❌ HammingSECDEDECC Exception at {width} bits: {e}")
            passed = False

        # Test ExtendedHammingECC
        try:
            ecc = ExtendedHammingECC(word_length=width)
            data = random.getrandbits(width)
            encoded = ecc.encode(data)
            decoded, status = ecc.decode(encoded)
            
            if decoded != data:
                print(f"❌ ExtendedHammingECC FAILED at {width} bits")
                passed = False
            else:
                print(f"✅ ExtendedHammingECC passed {width} bits")

            # Test Single Error Correction
            error_pos = random.randint(0, ecc.n - 1)
            corrupted = encoded ^ (1 << error_pos)
            decoded_err, status_err = ecc.decode(corrupted)
            if decoded_err != data:
                 print(f"❌ ExtendedHammingECC Single Error Correction FAILED at {width} bits")
                 passed = False
            else:
                 print(f"✅ ExtendedHammingECC Single Error Correction passed {width} bits")

        except Exception as e:
            print(f"❌ ExtendedHammingECC Exception at {width} bits: {e}")
            passed = False
            
    if passed:
        print("\n🎉 All Hamming width tests PASSED!")
        sys.exit(0)
    else:
        print("\n💥 Some tests FAILED.")
        sys.exit(1)

if __name__ == "__main__":
    test_hamming_widths()
