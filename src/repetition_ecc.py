from typing import List, Tuple
from base_ecc import ECCBase

class RepetitionCode:
    """Repetition Code ECC implementation.

    Encodes each bit by repeating it n times. Decoding uses majority voting.
    """
    def __init__(self, n: int = 3) -> None:
        """Initializes the repetition code.

        Args:
            n: Number of repetitions per bit (must be odd).
        """
        if n < 1 or n % 2 == 0:
            raise ValueError("n must be an odd positive integer.")
        self.n = n

    def encode(self, bits: List[int]) -> List[int]:
        """Encodes a list of bits using repetition code.

        Args:
            bits: List of 0/1 bits.
        Returns:
            Encoded list with each bit repeated n times.
        """
        return [b for bit in bits for b in [bit] * self.n]

    def decode(self, codeword: List[int]) -> List[int]:
        """Decodes a repetition codeword using majority voting.

        Args:
            codeword: Encoded list (length must be multiple of n).
        Returns:
            Decoded list of bits.
        """
        if len(codeword) % self.n != 0:
            raise ValueError("Codeword length must be a multiple of n.")
        decoded = []
        for i in range(0, len(codeword), self.n):
            chunk = codeword[i:i+self.n]
            ones = sum(chunk)
            decoded.append(1 if ones > self.n // 2 else 0)
        return decoded

class RepetitionECC(ECCBase):
    """Repetition ECC implementation."""
    
    def __init__(self, repetition_factor: int = 3, data_length: int = None):
        """
        Initialize Repetition ECC.
        
        Args:
            repetition_factor: Number of repetitions per bit (must be odd)
            data_length: Data length for compatibility
        """
        self.repetition_factor = repetition_factor
        self.repetition = RepetitionCode(n=repetition_factor)
    
    def encode(self, data: int) -> int:
        """
        Encode data with repetition code.
        
        Args:
            data: Input data
            
        Returns:
            Codeword with repeated bits
        """
        # Convert data to bit list
        data_bits = [(data >> i) & 1 for i in range(data.bit_length() or 1)]
        
        # Encode with repetition
        codeword_bits = self.repetition.encode(data_bits)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a repetition codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Convert to bit list
        codeword_bits = [(codeword >> i) & 1 for i in range(codeword.bit_length() or 1)]
        
        # Group bits by repetition factor
        groups = [codeword_bits[i:i+self.repetition_factor] for i in range(0, len(codeword_bits), self.repetition_factor)]
        
        # Decode each group by majority vote
        decoded_bits = []
        for group in groups:
            if len(group) == self.repetition_factor:
                # Majority vote
                bit = 1 if sum(group) > len(group) // 2 else 0
                decoded_bits.append(bit)
        
        # Convert back to integer
        data = 0
        for i, bit in enumerate(decoded_bits):
            data |= (bit << i)
        
        return data, 'corrected'  # Assume errors are corrected 