from typing import List, Tuple
from base_ecc import ECCBase

class ConvolutionalCode:
    """Simple (2,1,2) Convolutional Code ECC implementation.

    Uses a rate 1/2, constraint length 2 code with generator polynomials (3, 2) in octal.
    """
    def __init__(self) -> None:
        self.g1 = 0b11  # Generator 1: 3 (octal)
        self.g2 = 0b10  # Generator 2: 2 (octal)
        self.K = 2      # Constraint length

    def encode(self, bits: List[int]) -> List[int]:
        """Encodes a list of bits using the convolutional code.

        Args:
            bits: List of 0/1 bits.
        Returns:
            Encoded list of bits (rate 1/2).
        """
        state = 0
        out = []
        for bit in bits:
            state = ((state << 1) | bit) & ((1 << self.K) - 1)
            o1 = self._parity(state & self.g1)
            o2 = self._parity(state & self.g2)
            out.extend([o1, o2])
        return out

    def _parity(self, x: int) -> int:
        return bin(x).count('1') % 2

    def viterbi_decode(self, codeword: List[int]) -> List[int]:
        """Decodes a codeword using a simple approach.

        Args:
            codeword: Encoded list of bits (length must be even).
        Returns:
            Decoded list of bits.
        """
        if len(codeword) % 2 != 0:
            raise ValueError("Codeword length must be even.")
        n = len(codeword) // 2
        
        # For small codes, use brute force search
        best_input = None
        best_distance = float('inf')
        
        # Try all possible input sequences
        for i in range(2**n):
            test_input = [(i >> j) & 1 for j in range(n)]
            test_output = self.encode(test_input)
            
            # Calculate Hamming distance
            distance = sum(1 for a, b in zip(test_output, codeword) if a != b)
            
            if distance < best_distance:
                best_distance = distance
                best_input = test_input
        
        return best_input

class ConvolutionalECC(ECCBase):
    """Convolutional ECC implementation."""
    
    def __init__(self, n: int = 2, k: int = 1):
        """
        Initialize Convolutional ECC.
        
        Args:
            n: Output bits per input bit
            k: Input bits per block
        """
        self.n = n
        self.k = k
        self.conv = ConvolutionalCode()
    
    def encode(self, data: int) -> int:
        """
        Encode data with convolutional code.
        
        Args:
            data: Input data
            
        Returns:
            Codeword
        """
        # Convert data to bit list
        data_bits = [(data >> i) & 1 for i in range(data.bit_length() or 1)]
        
        # Encode with convolutional code
        codeword_bits = self.conv.encode(data_bits)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode codeword with convolutional code.
        
        Args:
            codeword: Input codeword
            
        Returns:
            Tuple of (decoded_data, error_detected, error_corrected)
        """
        # Convert codeword to bit list
        codeword_bits = [(codeword >> i) & 1 for i in range(codeword.bit_length() or 1)]
        
        # Decode with convolutional code
        decoded_bits = self.conv.viterbi_decode(codeword_bits)
        
        # Convert back to integer
        data = 0
        for i, bit in enumerate(decoded_bits):
            data |= (bit << i)
        
        # For this demo implementation, assume no errors detected/corrected
        return data, False, False 