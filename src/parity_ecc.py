from typing import Tuple
from base_ecc import ECCBase

class ParityECC(ECCBase):
    """Parity bit ECC implementation."""
    def encode(self, data: int) -> int:
        """
        Encode data with even parity.

        Args:
            data (int): The input data to encode (8 bits).

        Returns:
            int: The codeword (data concatenated with parity bit as LSB).
        """
        bits = [(data >> i) & 1 for i in range(8)]
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
        
        # Calculate expected parity
        expected_parity = bin(data_bits).count('1') % 2
        
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