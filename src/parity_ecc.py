from typing import Tuple
from base_ecc import ECCBase

class ParityECC(ECCBase):
    """Parity bit ECC implementation."""
    
    def __init__(self, word_length: int = 8, data_length: int = None) -> None:
        """
        Initialize Parity ECC.
        
        Args:
            word_length: Length of data word in bits (default: 8)
            data_length: Alternative parameter name for word_length (for compatibility)
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
    
    def encode(self, data: int) -> int:
        """
        Encode data with even parity.

        Args:
            data (int): The input data to encode.

        Returns:
            int: The codeword (data concatenated with parity bit as LSB).
        """
        # Ensure data fits within word_length
        if data >= (1 << self.word_length):
            raise ValueError(f"Data {data} exceeds word length {self.word_length} bits")
        
        # Calculate parity over the data bits
        bits = [(data >> i) & 1 for i in range(self.word_length)]
        parity = sum(bits) % 2
        return (data << 1) | parity

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a parity codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Extract data bits (all except the last bit)
        data_bits = codeword >> 1
        parity_bit = codeword & 1
        
        # Calculate expected parity over the data bits
        bits = [(data_bits >> i) & 1 for i in range(self.word_length)]
        expected_parity = sum(bits) % 2
        
        if parity_bit == expected_parity:
            return data_bits, 'corrected'  # No error or error corrected
        else:
            return data_bits, 'detected'   # Error detected

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Flip the bit at bit_idx in the codeword.

        Args:
            codeword (int): The codeword to corrupt.
            bit_idx (int): The bit index to flip.

        Returns:
            int: The corrupted codeword.
        """
        return super().inject_error(codeword, bit_idx)