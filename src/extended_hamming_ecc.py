from typing import Tuple
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.base_ecc import ECCBase

class ExtendedHammingECC(ECCBase):
    """Extended Hamming SECDED ECC implementation with additional parity bit."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Extended Hamming SECDED ECC.
        
        Args:
            word_length: Length of data word in bits (default: 8)
            data_length: Alternative parameter name for word_length (for compatibility)
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
            
        # Configure Extended Hamming code based on word length
        if self.word_length <= 4:
            # Extended Hamming(8,4) - 4 data bits, 4 parity bits (3 Hamming + 1 extended)
            self.n = 8
            self.k = 4
            self.parity_positions = [0, 1, 3]  # Hamming parity bit positions
            self.data_positions = [2, 4, 5, 6]  # Data bit positions
            self.extended_parity_position = 7  # Extended parity bit position
        elif self.word_length <= 8:
            # Extended Hamming(13,8) - 8 data bits, 5 parity bits (4 Hamming + 1 extended)
            self.n = 13
            self.k = 8
            self.parity_positions = [0, 1, 3, 7]  # Hamming parity bit positions
            self.data_positions = [2, 4, 5, 6, 8, 9, 10, 11]  # Data bit positions
            self.extended_parity_position = 12  # Extended parity bit position
        elif self.word_length <= 16:
            # Extended Hamming(22,16) - 16 data bits, 6 parity bits (5 Hamming + 1 extended)
            self.n = 22
            self.k = 16
            self.parity_positions = [0, 1, 3, 7, 15]  # Hamming parity bit positions
            self.data_positions = [2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20]  # Data bit positions
            self.extended_parity_position = 21  # Extended parity bit position
        else:
            # Extended Hamming(39,32) - 32 data bits, 7 parity bits (6 Hamming + 1 extended)
            self.n = 39
            self.k = 32
            # Hamming parity positions (powers of 2, 0-based): 0,1,3,7,15,31
            self.parity_positions = [0, 1, 3, 7, 15, 31]
            # Data positions: all positions from 0 to 37 except parity positions
            self.data_positions = [i for i in range(38) if i not in self.parity_positions]
            self.extended_parity_position = 38  # Extended parity bit position

    def encode(self, data: int) -> int:
        """
        Encode data with Extended Hamming SECDED.

        Args:
            data (int): The input data to encode.

        Returns:
            int: The encoded codeword with extended parity.
        """
        # Ensure data fits within word_length
        if data >= (1 << self.word_length):
            raise ValueError(f"Data {data} exceeds word length {self.word_length} bits")
        
        # First, create standard Hamming codeword
        hamming_codeword = self._encode_hamming(data)
        
        # Add extended parity bit (even parity over all bits)
        total_ones = bin(hamming_codeword).count('1')
        extended_parity = total_ones % 2
        
        # Combine Hamming codeword with extended parity
        codeword = hamming_codeword | (extended_parity << self.extended_parity_position)
        
        return codeword

    def _encode_hamming(self, data: int) -> int:
        """Encode data using standard Hamming SECDED."""
        codeword = 0
        
        # Place data bits in their positions
        data_bit_idx = 0
        for pos in self.data_positions:
            if data_bit_idx < self.k:
                bit = (data >> data_bit_idx) & 1
                codeword |= (bit << pos)
                data_bit_idx += 1
        
        # Calculate Hamming parity bits
        for i, parity_pos in enumerate(self.parity_positions):
            parity = 0
            for j in range(self.n):
                if j != parity_pos and ((codeword >> j) & 1):
                    # Check if this bit position is covered by this parity bit
                    if (j + 1) & (1 << i):
                        parity ^= 1
            codeword |= (parity << parity_pos)
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode an Extended Hamming SECDED codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Extract Hamming codeword (without extended parity)
        hamming_codeword = codeword & ~(1 << self.extended_parity_position)
        extended_parity = (codeword >> self.extended_parity_position) & 1
        
        # Calculate expected extended parity
        total_ones = bin(hamming_codeword).count('1')
        expected_extended_parity = total_ones % 2
        
        # Check extended parity
        extended_parity_error = (extended_parity != expected_extended_parity)
        
        # Decode Hamming part
        decoded_data, hamming_error_type = self._decode_hamming(hamming_codeword)
        
        # Determine overall error type
        if extended_parity_error and hamming_error_type == 'corrected':
            # Extended parity error but Hamming corrected - likely double-bit error
            return decoded_data, 'detected'
        elif extended_parity_error and hamming_error_type == 'undetected':
            # Extended parity error but no Hamming error - extended parity bit error
            return decoded_data, 'corrected'
        elif not extended_parity_error and hamming_error_type == 'detected':
            # No extended parity error but Hamming detected - single-bit error in extended parity
            return decoded_data, 'corrected'
        else:
            # Normal Hamming error handling
            return decoded_data, hamming_error_type

    def _decode_hamming(self, hamming_codeword: int) -> Tuple[int, str]:
        """Decode standard Hamming SECDED codeword."""
        # Calculate syndrome
        syndrome = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate expected parity
            expected_parity = 0
            for j in range(self.n):
                if j != pos and ((hamming_codeword >> j) & 1):
                    # Check if this bit position is covered by this parity bit
                    if (j + 1) & (1 << i):
                        expected_parity ^= 1
            
            # Compare with actual parity
            actual_parity = (hamming_codeword >> pos) & 1
            if expected_parity != actual_parity:
                syndrome |= (1 << i)
        
        if syndrome == 0:
            # No error detected
            return self._extract_data(hamming_codeword), 'corrected'
        elif syndrome <= self.n:
            # Single bit error detected and corrected
            error_bit = syndrome - 1
            corrected_codeword = hamming_codeword ^ (1 << error_bit)
            return self._extract_data(corrected_codeword), 'corrected'
        else:
            # Double bit error detected but not corrected
            return self._extract_data(hamming_codeword), 'detected'

    def _extract_data(self, codeword: int) -> int:
        """Extract data bits from codeword."""
        data = 0
        data_bit_idx = 0
        for pos in sorted(self.data_positions):
            if data_bit_idx < self.k:
                bit = (codeword >> pos) & 1
                data |= (bit << data_bit_idx)
                data_bit_idx += 1
        return data

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