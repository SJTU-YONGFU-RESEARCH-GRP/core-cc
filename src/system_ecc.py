from typing import Tuple
from base_ecc import ECCBase

class SystemECC(ECCBase):
    """System-level Hamming SECDED ECC implementation for 8-bit data (example system ECC)."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize System ECC.
        
        Args:
            word_length: Length of data word in bits (default: 8)
            data_length: Alternative parameter name for word_length (for compatibility)
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
            
        # Import Hamming SECDED for the base implementation
        from hamming_secded_ecc import HammingSECDEDECC
        self.hamming = HammingSECDEDECC(data_length=self.word_length)
    
    def encode(self, data: int) -> int:
        """
        Encode data into system-level codeword (adds an extra system-level parity bit).

        Args:
            data (int): The input data to encode.

        Returns:
            int: The codeword with system-level parity.
        """
        # Use Hamming SECDED for base encoding
        code = self.hamming.encode(data)
        
        # Compute system-level parity (even parity over all bits)
        parity = bin(code).count('1') % 2
        
        # Add system parity bit as MSB
        return (parity << code.bit_length()) | code

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a system codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Extract system parity bit (MSB)
            codeword_bits = codeword.bit_length()
            system_parity = (codeword >> (codeword_bits - 1)) & 1
            
            # Extract base codeword (all bits except system parity)
            base_codeword = codeword & ((1 << (codeword_bits - 1)) - 1)
            
            # Check system parity
            computed_parity = bin(base_codeword).count('1') % 2
            if system_parity != computed_parity:
                return base_codeword, 'detected'
            
            # Decode with base Hamming SECDED
            decoded_data, error_type = self.hamming.decode(base_codeword)
            return decoded_data, error_type
            
        except Exception:
            # If decoding fails, error detected
            return codeword, 'detected'

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Flip the bit at bit_idx in the codeword.

        Args:
            codeword (int): The codeword to corrupt.
            bit_idx (int): The bit index to flip.

        Returns:
            int: The corrupted codeword.
        """
        return codeword ^ (1 << bit_idx) 