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
    
    def __init__(self, data_length: int = 8):
        """
        Initialize Convolutional ECC.
        
        Args:
            data_length: Data length in bits
        """
        self.data_length = data_length
        self.conv = ConvolutionalCode()
    
    def encode(self, data: int) -> int:
        """
        Encode data with convolutional code.
        
        Args:
            data: Input data
            
        Returns:
            Codeword
        """
        # Convert data to bit list with proper length
        data_bits = [(data >> i) & 1 for i in range(self.data_length)]
        
        # Encode with convolutional code
        codeword_bits = self.conv.encode(data_bits)
        
        # Ensure even length
        if len(codeword_bits) % 2 != 0:
            codeword_bits.append(0)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a convolutional codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Calculate expected codeword length: data_length * 2 (rate 1/2)
            expected_codeword_length = self.data_length * 2
            
            # Convert to bit list with proper length
            codeword_bits = [(codeword >> i) & 1 for i in range(expected_codeword_length)]
            
            # Decode with convolutional code
            decoded_bits = self.conv.viterbi_decode(codeword_bits)
            
            # Convert back to integer
            decoded_data = 0
            for i, bit in enumerate(decoded_bits):
                decoded_data |= (bit << i)
                
            return decoded_data, 'corrected'
            
        except Exception:
            # If decoding fails, error detected
            return codeword, 'detected' 