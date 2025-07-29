from typing import Tuple, List, Dict, Optional
from base_ecc import ECCBase

class PrimarySecondaryECC(ECCBase):
    """
    Primary/Secondary ECC implementation that uses different protection levels.
    """
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Primary/Secondary ECC.
        
        Args:
            word_length: Length of data word in bits
            data_length: Alternative parameter name for compatibility
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
            
        # Configure parameters based on word length
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
        """Calculate parity bits for primary/secondary protection."""
        parity = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate parity for this parity bit based on data bits only
            p = 0
            for j in self.data_positions:
                if ((codeword >> j) & 1):
                    # Primary/secondary parity calculation
                    if (j + pos) % 2 == 0:
                        p ^= 1
            parity |= (p << pos)
        return parity
    
    def encode(self, data: int) -> int:
        """
        Encode data with primary/secondary protection.
        
        Args:
            data: Input data to encode
            
        Returns:
            Encoded codeword
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
        Decode primary/secondary protected codeword.
        
        Args:
            codeword: Codeword to decode
            
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
                    # Primary/secondary parity calculation
                    if (j + pos) % 2 == 0:
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
                            if (j + pos) % 2 == 0:
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
    
    def get_protection_info(self) -> Dict[str, any]:
        """Get protection configuration information."""
        return {
            'data_length': self.k,
            'codeword_length': self.n,
            'parity_length': self.n - self.k,
            'protection_type': 'primary_secondary'
        }