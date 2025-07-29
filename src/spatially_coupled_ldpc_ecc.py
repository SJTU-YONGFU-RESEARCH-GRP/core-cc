from typing import Tuple, List, Optional
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.base_ecc import ECCBase
import numpy as np

class SpatiallyCoupledLDPCECC(ECCBase):
    """Simplified Spatially-Coupled LDPC ECC implementation for improved performance."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Spatially-Coupled LDPC ECC.
        
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
        
        # Generate deterministic matrices
        self.G = self._generate_generator_matrix()
        self.H = self._generate_parity_check_matrix()

    def _generate_generator_matrix(self) -> np.ndarray:
        """Generate deterministic generator matrix."""
        G = np.zeros((self.k, self.n), dtype=int)
        
        # Systematic form: identity matrix for data part
        for i in range(self.k):
            G[i, i] = 1
        
        # Parity part: deterministic pattern
        for i in range(self.k):
            for j in range(self.k, self.n):
                if (i + j) % 2 == 0:
                    G[i, j] = 1
        
        return G

    def _generate_parity_check_matrix(self) -> np.ndarray:
        """Generate parity check matrix for error detection."""
        m = self.n - self.k
        H = np.zeros((m, self.n), dtype=int)
        
        # Create parity check matrix that satisfies G * H^T = 0
        for i in range(m):
            for j in range(self.n):
                if j >= self.k:  # Parity bits
                    if i == (j - self.k):
                        H[i, j] = 1
                else:  # Data bits
                    if (i + j) % 2 == 0:
                        H[i, j] = 1
        
        return H

    def encode(self, data: int) -> int:
        """
        Encode data using spatially-coupled LDPC.
        
        Args:
            data (int): The input data to encode.
            
        Returns:
            int: The encoded codeword.
        """
        # Ensure data fits within k bits
        if data >= (1 << self.k):
            data = data & ((1 << self.k) - 1)
        
        # Convert data to binary array
        data_bits = [(data >> i) & 1 for i in range(self.k)]
        
        # Encode using generator matrix
        codeword_bits = np.dot(data_bits, self.G) % 2
        
        # Convert to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (int(bit) << i)
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a spatially-coupled LDPC codeword using improved error correction.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Convert codeword to binary array
        codeword_bits = [(codeword >> i) & 1 for i in range(self.n)]
        
        # Check for errors using syndrome
        syndrome = np.dot(self.H, codeword_bits) % 2
        
        if np.sum(syndrome) == 0:
            # No errors detected
            decoded_data = self._extract_data(codeword_bits)
            return decoded_data, 'corrected'
        else:
            # Try to correct single bit errors
            corrected_data, correction_success = self._correct_single_error(codeword_bits, syndrome)
            if correction_success:
                return corrected_data, 'corrected'
            else:
                # Error detected but not corrected
                decoded_data = self._extract_data(codeword_bits)
                return decoded_data, 'detected'

    def _extract_data(self, codeword_bits: List[int]) -> int:
        """Extract data from systematic codeword."""
        decoded_data = 0
        for i in range(min(self.k, len(codeword_bits))):
            decoded_data |= (codeword_bits[i] << i)
        
        # Ensure we only return the original word_length bits
        decoded_data = decoded_data & ((1 << self.word_length) - 1)
        return decoded_data

    def _correct_single_error(self, codeword_bits: List[int], syndrome: np.ndarray) -> Tuple[int, bool]:
        """Attempt to correct single bit errors."""
        # Try flipping each bit and check if syndrome becomes zero
        for bit_pos in range(self.n):
            # Flip the bit
            test_bits = codeword_bits.copy()
            test_bits[bit_pos] = 1 - test_bits[bit_pos]
            
            # Check syndrome
            test_syndrome = np.dot(self.H, test_bits) % 2
            if np.sum(test_syndrome) == 0:
                # Error corrected
                corrected_data = self._extract_data(test_bits)
                return corrected_data, True
        
        return 0, False

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