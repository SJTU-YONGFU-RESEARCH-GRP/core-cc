from typing import Tuple
from base_ecc import ECCBase

class HammingSECDEDECC(ECCBase):
    """Hamming SECDED (Single Error Correction, Double Error Detection) ECC implementation."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Hamming SECDED ECC.
        
        Args:
            word_length: Length of data word in bits (default: 8)
            data_length: Alternative parameter name for word_length (for compatibility)
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
            
        # Configure Hamming code based on word length
        if self.word_length <= 4:
            # Hamming(7,4) - 4 data bits, 3 parity bits
            self.n = 7
            self.k = 4
            self.parity_positions = [0, 1, 3]  # Parity bit positions
            self.data_positions = [2, 4, 5, 6]  # Data bit positions
        elif self.word_length <= 8:
            # Hamming(12,8) - 8 data bits, 4 parity bits
            self.n = 12
            self.k = 8
            self.parity_positions = [0, 1, 3, 7]  # Parity bit positions
            self.data_positions = [2, 4, 5, 6, 8, 9, 10, 11]  # Data bit positions
        elif self.word_length <= 16:
            # Hamming(21,16) - 16 data bits, 5 parity bits
            self.n = 21
            self.k = 16
            self.parity_positions = [0, 1, 3, 7, 15]  # Parity bit positions
            self.data_positions = [2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20]  # Data bit positions
        elif self.word_length <= 32:
            # Hamming(38,32) - 32 data bits, 6 parity bits
            self.n = 38
            self.k = 32
            self.parity_positions = [0, 1, 3, 7, 15, 31]  # Parity bit positions
            # Data positions: all positions except parity positions
            self.data_positions = []
            for i in range(self.n):
                if i not in self.parity_positions:
                    self.data_positions.append(i)
        else:
            raise ValueError(f"Word length {self.word_length} not supported")
    
    def _extract_data(self, codeword: int) -> int:
        """
        Extract data bits from Hamming codeword.
        
        Args:
            codeword: The codeword
            
        Returns:
            The data bits
        """
        data = 0
        for i, pos in enumerate(self.data_positions):
            bit = (codeword >> pos) & 1
            data |= (bit << i)
        return data

    def _insert_data(self, data: int) -> int:
        """
        Insert data bits into codeword positions.
        
        Args:
            data: The data to insert
            
        Returns:
            Codeword with data bits in position
        """
        codeword = 0
        for i, pos in enumerate(self.data_positions):
            bit = (data >> i) & 1
            codeword |= (bit << pos)
        return codeword

    def _calculate_parity(self, codeword: int) -> int:
        """
        Calculate parity bits for the codeword.
        
        Args:
            codeword: Codeword with data bits in position
            
        Returns:
            Parity bits
        """
        parity = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate parity for this parity bit
            p = 0
            for j in range(self.n):
                if j != pos and ((codeword >> j) & 1):
                    # Check if this bit position is covered by this parity bit
                    if (j + 1) & (1 << i):
                        p ^= 1
            parity |= (p << pos)
        return parity

    def encode(self, data: int) -> int:
        """
        Encode data into Hamming SECDED codeword.

        Args:
            data (int): The input data to encode.

        Returns:
            int: The codeword.
        """
        # Ensure data fits within word_length
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
        Decode a Hamming SECDED codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Calculate syndrome
        syndrome = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate expected parity
            expected_parity = 0
            for j in range(self.n):
                if j != pos and ((codeword >> j) & 1):
                    # Check if this bit position is covered by this parity bit
                    if (j + 1) & (1 << i):
                        expected_parity ^= 1
            
            # Compare with actual parity
            actual_parity = (codeword >> pos) & 1
            if expected_parity != actual_parity:
                syndrome |= (1 << i)
        
        if syndrome == 0:
            # No error detected
            return self._extract_data(codeword), 'corrected'
        elif syndrome <= self.n:
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