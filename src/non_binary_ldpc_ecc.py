from typing import Tuple, List
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.base_ecc import ECCBase
import numpy as np

class NonBinaryLDPCECC(ECCBase):
    """Non-Binary LDPC ECC implementation for high-reliability applications."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Non-Binary LDPC ECC.
        
        Args:
            word_length: Length of data word in bits (default: 8)
            data_length: Alternative parameter name for word_length (for compatibility)
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
        
        # Configure LDPC parameters based on word length
        if self.word_length <= 4:
            self.k = 4
            self.n = 8
        elif self.word_length <= 8:
            self.k = 8
            self.n = 16
        elif self.word_length <= 16:
            self.k = 16
            self.n = 32
        else:
            self.k = 32
            self.n = 64
        
        # Define data and parity positions
        self.data_positions = list(range(self.k))
        self.parity_positions = list(range(self.k, self.n))

    def _extract_data(self, codeword: int) -> int:
        """Extract data bits from codeword."""
        data = 0
        for i, pos in enumerate(self.data_positions):
            bit = (codeword >> pos) & 1
            data |= (bit << i)
        return data

    def _insert_data(self, data: int) -> int:
        """Insert data bits into codeword positions."""
        codeword = 0
        for i, pos in enumerate(self.data_positions):
            bit = (data >> i) & 1
            codeword |= (bit << pos)
        return codeword

    def _calculate_parity(self, codeword: int) -> int:
        """Calculate parity bits for the codeword."""
        parity = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate parity for this parity bit based on data bits only
            p = 0
            for j in self.data_positions:
                if ((codeword >> j) & 1):
                    # Simple parity calculation
                    if (j + pos) % 3 == 0:
                        p ^= 1
            parity |= (p << pos)
        return parity

    def encode(self, data: int) -> int:
        """
        Encode data using non-binary LDPC.
        
        Args:
            data (int): The input data to encode.
            
        Returns:
            int: The encoded codeword.
        """
        # Ensure data fits within word_length bits
        if data >= (1 << self.word_length):
            data = data & ((1 << self.word_length) - 1)
        
        # Insert data bits into codeword
        codeword = self._insert_data(data)
        
        # Calculate and insert parity bits
        parity = self._calculate_parity(codeword)
        codeword |= parity
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a non-binary LDPC codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Calculate syndrome
        syndrome = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate expected parity based on data bits only
            expected_parity = 0
            for j in self.data_positions:
                if ((codeword >> j) & 1):
                    # Simple parity calculation
                    if (j + pos) % 3 == 0:
                        expected_parity ^= 1
            
            # Compare with actual parity
            actual_parity = (codeword >> pos) & 1
            if expected_parity != actual_parity:
                syndrome |= (1 << i)
        
        if syndrome == 0:
            # No error detected
            return self._extract_data(codeword), 'corrected'
        else:
            # Try to correct single bit errors
            for bit_pos in range(self.n):
                # Try flipping this bit
                test_codeword = codeword ^ (1 << bit_pos)
                
                # Check if this fixes the syndrome
                test_syndrome = 0
                for i, pos in enumerate(self.parity_positions):
                    expected_parity = 0
                    for j in self.data_positions:
                        if ((test_codeword >> j) & 1):
                            if (j + pos) % 3 == 0:
                                expected_parity ^= 1
                    
                    actual_parity = (test_codeword >> pos) & 1
                    if expected_parity != actual_parity:
                        test_syndrome |= (1 << i)
                
                if test_syndrome == 0:
                    # Error corrected
                    return self._extract_data(test_codeword), 'corrected'
            
            # Error detected but not corrected
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
        return codeword ^ (1 << bit_idx)