from typing import Tuple, List
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.base_ecc import ECCBase

class FireCodeECC(ECCBase):
    """Fire Code ECC implementation for burst error correction."""
    
    def __init__(self, burst_length: int = 3, data_length: int = None):
        """
        Initialize Fire Code ECC.
        
        Args:
            burst_length: Maximum burst length to correct (default: 3)
            data_length: Data length for compatibility
        """
        self.burst_length = burst_length
        
        # Adjust parameters based on data_length
        if data_length is not None:
            if data_length <= 4:
                self.burst_length = 2
            elif data_length <= 8:
                self.burst_length = 3
            elif data_length <= 16:
                self.burst_length = 4
            else:
                self.burst_length = 5
        
        # Calculate code parameters
        self.data_length = data_length or 8
        self.parity_length = 2 * self.burst_length
        self.n = self.data_length + self.parity_length
        self.k = self.data_length

    def encode(self, data: int) -> int:
        """
        Encode data using Fire code.
        
        Args:
            data (int): The input data to encode.
            
        Returns:
            int: The encoded codeword.
        """
        # Ensure data fits within k bits
        if data >= (1 << self.k):
            data = data & ((1 << self.k) - 1)
        
        # Create a simple systematic code
        # Data bits followed by parity bits
        codeword = data << self.parity_length
        
        # Calculate parity bits using a simple polynomial
        # This is a simplified version - real Fire codes use specific polynomials
        parity = 0
        for i in range(self.k):
            if (data >> i) & 1:
                # Add contribution to parity
                parity ^= (1 << (i % self.parity_length))
        
        # Add parity bits
        codeword |= parity
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a Fire code codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Extract data and parity
        data = (codeword >> self.parity_length) & ((1 << self.k) - 1)
        received_parity = codeword & ((1 << self.parity_length) - 1)
        
        # Calculate expected parity
        expected_parity = 0
        for i in range(self.k):
            if (data >> i) & 1:
                expected_parity ^= (1 << (i % self.parity_length))
        
        # Check for errors
        syndrome = received_parity ^ expected_parity
        
        if syndrome == 0:
            # No errors
            return data, 'corrected'
        else:
            # Try to correct burst errors
            corrected_data, correction_success = self._correct_burst_errors(data, syndrome)
            
            if correction_success:
                return corrected_data, 'corrected'
            else:
                return data, 'detected'

    def _correct_burst_errors(self, data: int, syndrome: int) -> Tuple[int, bool]:
        """Attempt to correct burst errors using syndrome."""
        # This is a simplified burst error correction
        # Real Fire codes use more sophisticated algorithms
        
        # Try different burst positions
        for start_pos in range(self.n):
            # Try to correct a burst starting at start_pos
            error_pattern = 0
            for i in range(self.burst_length):
                if start_pos + i < self.parity_length:
                    error_pattern |= (1 << (start_pos + i))
            
            # Check if this error pattern matches the syndrome
            if (error_pattern & ((1 << self.parity_length) - 1)) == syndrome:
                # Found matching error pattern
                corrected_data = data
                for i in range(self.burst_length):
                    if start_pos + i >= self.parity_length:
                        bit_pos = start_pos + i - self.parity_length
                        if bit_pos < self.k:
                            corrected_data ^= (1 << bit_pos)
                return corrected_data, True
        
        return data, False

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