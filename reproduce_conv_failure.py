import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent / "src"))

from convolutional_ecc import ConvolutionalECC
import random

def test_convolutional_ecc(data_length, trials=100):
    print(f"\nTesting ConvolutionalECC with data_length={data_length}")
    ecc = ConvolutionalECC(data_length=data_length)
    successes = 0
    
    for i in range(trials):
        data = random.getrandbits(data_length)
        encoded = ecc.encode(data)
        decoded, status = ecc.decode(encoded)
        
        if data == decoded:
            successes += 1
        else:
            if i < 5: # Print first 5 failures
                print(f"Failure: Data={bin(data)}, Decoded={bin(decoded)}")
                
    print(f"Success rate: {successes}/{trials} ({successes/trials*100:.1f}%)")

if __name__ == "__main__":
    test_convolutional_ecc(4)
    test_convolutional_ecc(8)
    test_convolutional_ecc(16)
    test_convolutional_ecc(32)
