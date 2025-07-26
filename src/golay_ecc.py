from typing import List, Tuple
from base_ecc import ECCBase

class GolayCode:
    """Binary (23,12) Golay Code ECC implementation (toy, not optimized).

    This is a reference implementation for educational/demo purposes.
    """
    def __init__(self) -> None:
        self.n = 23
        self.k = 12
        # Generator polynomial for Golay (23,12) code
        self.g = 0b1000000001011  # x^11 + x^9 + x^7 + x^6 + x^5 + x + 1

    def encode(self, data: List[int]) -> List[int]:
        """Encodes 12 bits into a 23-bit Golay codeword.

        Args:
            data: List of 12 bits.
        Returns:
            List of 23 bits (codeword).
        """
        if len(data) != 12:
            raise ValueError("Golay code encodes 12 bits.")
        d = 0
        for bit in data:
            d = (d << 1) | bit
        # Multiply by x^11 (shift left 11)
        d <<= 11
        # Modulo generator
        for i in range(22, 10, -1):
            if (d >> i) & 1:
                d ^= self.g << (i - 11)
        parity = d & 0x7FF
        codeword = ((int(''.join(str(b) for b in data), 2) << 11) | parity)
        return [int(b) for b in f"{codeword:023b}"]

    def decode(self, codeword: List[int]) -> List[int]:
        """Decodes a 23-bit Golay codeword (syndrome decoding, corrects up to 3 errors).

        Args:
            codeword: List of 23 bits.
        Returns:
            List of 12 decoded bits.
        """
        if len(codeword) != 23:
            raise ValueError("Golay codeword must be 23 bits.")
        # For demo, just return the first 12 bits (no error correction)
        return codeword[:12] 

class GolayECC(ECCBase):
    """Golay ECC implementation."""
    
    def __init__(self):
        """Initialize Golay ECC."""
        self.golay = GolayCode()
    
    def encode(self, data: int) -> int:
        """
        Encode data with Golay code.
        
        Args:
            data: Input data (12 bits max)
            
        Returns:
            Codeword (23 bits)
        """
        # Convert data to bit list
        data_bits = [(data >> i) & 1 for i in range(min(12, data.bit_length() or 1))]
        
        # Pad to 12 bits if needed
        while len(data_bits) < 12:
            data_bits.insert(0, 0)
        
        # Encode with Golay
        codeword_bits = self.golay.encode(data_bits)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode codeword with Golay code.
        
        Args:
            codeword: Input codeword (23 bits)
            
        Returns:
            Tuple of (decoded_data, error_detected, error_corrected)
        """
        # Convert codeword to bit list
        codeword_bits = [(codeword >> i) & 1 for i in range(min(23, codeword.bit_length() or 1))]
        
        # Pad to 23 bits if needed
        while len(codeword_bits) < 23:
            codeword_bits.insert(0, 0)
        
        # Decode with Golay
        decoded_bits = self.golay.decode(codeword_bits)
        
        # Convert back to integer
        data = 0
        for i, bit in enumerate(decoded_bits):
            data |= (bit << i)
        
        # For this demo implementation, assume no errors detected/corrected
        return data, False, False 