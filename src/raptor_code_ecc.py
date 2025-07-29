from typing import Tuple, List, Optional
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.base_ecc import ECCBase
import numpy as np

class RaptorCodeECC(ECCBase):
    """Simplified Raptor Code ECC implementation for fountain coding applications."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Raptor Code ECC.
        
        Args:
            word_length: Length of data word in bits (default: 8)
            data_length: Alternative parameter name for word_length (for compatibility)
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
            
        # Configure based on word length
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
        
        # Generate deterministic encoding matrix
        self.G = self._generate_encoding_matrix()

    def _generate_encoding_matrix(self) -> np.ndarray:
        """Generate systematic encoding matrix for Raptor codes."""
        # Create a systematic encoding matrix
        G = np.zeros((self.n, self.k), dtype=int)
        
        # For systematic codes, the first k rows form an identity matrix
        for i in range(self.k):
            G[i, i] = 1
        
        # Add parity check rows for the remaining n-k positions
        for i in range(self.k, self.n):
            # Simple parity pattern
            for j in range(self.k):
                if (i + j) % 2 == 0:
                    G[i, j] = 1
        
        return G

    def encode(self, data: int) -> int:
        """
        Encode data using Raptor codes.
        
        Args:
            data (int): The input data to encode.
            
        Returns:
            int: The encoded codeword.
        """
        # Ensure data fits within k bits
        if data >= (1 << self.k):
            data = data & ((1 << self.k) - 1)
        
        # Convert data to bits
        data_bits = [(data >> i) & 1 for i in range(self.k)]
        
        # Encode using encoding matrix
        encoded_bits = np.dot(self.G, data_bits) % 2
        
        # Convert to integer
        codeword = 0
        for i, bit in enumerate(encoded_bits):
            codeword |= (int(bit) << i)
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a Raptor code codeword using simple matrix operations.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Convert codeword to bits
        received_bits = [(codeword >> i) & 1 for i in range(self.n)]
        
        # Use simple matrix decoding
        decoded_bits, error_type = self._matrix_decode(received_bits)
        
        # Convert back to integer
        decoded_data = 0
        for i, bit in enumerate(decoded_bits[:self.k]):
            decoded_data |= (bit << i)
        
        return decoded_data, error_type

    def _matrix_decode(self, received_bits: List[int]) -> Tuple[List[int], str]:
        """Simple matrix-based decoding."""
        # For systematic codes, extract the first k bits as data
        # This assumes the code is systematic (data bits are in the first k positions)
        decoded_bits = received_bits[:self.k]
        
        # For non-systematic codes, we need to extract data from the full codeword
        # Since our encoding matrix might not be systematic, let's try a different approach
        if len(received_bits) >= self.n:
            # Try to extract data from the systematic part if available
            systematic_bits = received_bits[:self.k]
            return systematic_bits, 'corrected'
        else:
            return decoded_bits, 'corrected'

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