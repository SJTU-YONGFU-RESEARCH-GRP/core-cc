from typing import Tuple
from base_ecc import ECCBase

class HammingSECDEDECC(ECCBase):
    """Hamming SECDED (Single Error Correction, Double Error Detection) ECC implementation for 8-bit data."""
    
    def __init__(self):
        """Initialize Hamming SECDED ECC."""
        # Parity check masks for 12-bit Hamming SECDED
        self.parity_masks = [
            0b101010101010,  # P1: bits 0,2,4,6,8,10
            0b011001100110,  # P2: bits 1,2,5,6,9,10
            0b000111100001,  # P3: bits 3,4,5,6,11
            0b000000011111   # P4: bits 7,8,9,10,11
        ]
    
    def _extract_data(self, codeword: int) -> int:
        """
        Extract data bits from Hamming codeword.
        
        Args:
            codeword: The 12-bit codeword
            
        Returns:
            The 8-bit data
        """
        # Extract data bits (positions 4-11, excluding parity bits)
        data = 0
        data_positions = [4, 5, 6, 7, 8, 9, 10, 11]  # Data bit positions
        for i, pos in enumerate(data_positions):
            bit = (codeword >> pos) & 1
            data |= (bit << i)
        return data

    def encode(self, data: int) -> int:
        """
        Encode 8-bit data into 12-bit Hamming SECDED codeword.

        Args:
            data (int): The input data to encode (8 bits).

        Returns:
            int: The 12-bit codeword.
        """
        d = [(data >> i) & 1 for i in range(8)]
        p = [0] * 4
        p[0] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6]
        p[1] = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6]
        p[2] = d[1] ^ d[2] ^ d[3] ^ d[7]
        p[3] = d[4] ^ d[5] ^ d[6] ^ d[7]
        code = 0
        for i, bit in enumerate([p[3], p[2], p[1], p[0]] + d[::-1]):
            code |= (bit << (11 - i))
        return code

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a Hamming SECDED codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Calculate syndrome
        syndrome = 0
        for i, mask in enumerate(self.parity_masks):
            if bin(codeword & mask).count('1') % 2 == 1:
                syndrome |= (1 << i)
        
        if syndrome == 0:
            # No error detected
            return self._extract_data(codeword), 'corrected'
        elif syndrome <= len(self.parity_masks):
            # Single bit error detected and corrected
            error_bit = syndrome - 1
            corrected_codeword = codeword ^ (1 << error_bit)
            return self._extract_data(corrected_codeword), 'corrected'
        else:
            # Double bit error detected but not corrected
            return self._extract_data(codeword), 'detected'

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