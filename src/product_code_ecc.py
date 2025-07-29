from typing import Tuple, List
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.base_ecc import ECCBase

class ProductCodeECC(ECCBase):
    """Product Code ECC that combines two ECCs in a 2D product structure."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Product Code ECC.
        
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
            self.sub_word_length = 2
        elif self.word_length <= 8:
            self.sub_word_length = 4
        elif self.word_length <= 16:
            self.sub_word_length = 8
        else:
            self.sub_word_length = 16
        
        # Import ECCs with correct paths
        from src.hamming_secded_ecc import HammingSECDEDECC
        from src.parity_ecc import ParityECC
        
        self.row_ecc = HammingSECDEDECC(data_length=self.sub_word_length)
        self.col_ecc = ParityECC(data_length=self.sub_word_length)

    def _pack_data(self, data: int) -> List[int]:
        """Pack data into sub-words for product code encoding."""
        sub_words = []
        mask = (1 << self.sub_word_length) - 1
        
        for i in range(0, self.word_length, self.sub_word_length):
            sub_word = (data >> i) & mask
            sub_words.append(sub_word)
        
        return sub_words

    def _unpack_data(self, sub_words: List[int]) -> int:
        """Unpack sub-words back to original data."""
        data = 0
        for i, sub_word in enumerate(sub_words):
            data |= (sub_word << (i * self.sub_word_length))
        return data

    def encode(self, data: int) -> int:
        """
        Encode data using product code structure with robust bit-packing.
        
        Args:
            data (int): The input data to encode.
            
        Returns:
            int: The encoded product codeword.
        """
        # Ensure data fits within word length
        if data >= (1 << self.word_length):
            data = data & ((1 << self.word_length) - 1)
        
        # Pack data into sub-words
        sub_words = self._pack_data(data)
        
        # Encode each sub-word with row ECC
        row_encoded_words = []
        for sub_word in sub_words:
            row_encoded = self.row_ecc.encode(sub_word)
            row_encoded_words.append(row_encoded)
        
        # Encode each sub-word with column ECC
        col_encoded_words = []
        for sub_word in sub_words:
            col_encoded = self.col_ecc.encode(sub_word)
            col_encoded_words.append(col_encoded)
        
        # Pack encoded words into a single codeword
        # Use a simple concatenation approach
        codeword = 0
        bit_pos = 0
        
        # Pack row encoded words
        for word in row_encoded_words:
            word_bits = self.row_ecc.n if hasattr(self.row_ecc, 'n') else 12
            codeword |= (word << bit_pos)
            bit_pos += word_bits
        
        # Pack column encoded words
        for word in col_encoded_words:
            word_bits = self.col_ecc.n if hasattr(self.col_ecc, 'n') else 9
            codeword |= (word << bit_pos)
            bit_pos += word_bits
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a product codeword with robust bit-unpacking.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Extract row and column encoded words
        row_encoded_words = []
        col_encoded_words = []
        
        bit_pos = 0
        
        # Extract row encoded words
        for i in range(len(self._pack_data(0))):  # Use dummy data to get count
            word_bits = self.row_ecc.n if hasattr(self.row_ecc, 'n') else 12
            word = (codeword >> bit_pos) & ((1 << word_bits) - 1)
            row_encoded_words.append(word)
            bit_pos += word_bits
        
        # Extract column encoded words
        for i in range(len(self._pack_data(0))):  # Use dummy data to get count
            word_bits = self.col_ecc.n if hasattr(self.col_ecc, 'n') else 9
            word = (codeword >> bit_pos) & ((1 << word_bits) - 1)
            col_encoded_words.append(word)
            bit_pos += word_bits
        
        # Decode each sub-word
        decoded_sub_words = []
        error_detected = False
        
        for i in range(len(row_encoded_words)):
            # Decode row
            row_decoded, row_error = self.row_ecc.decode(row_encoded_words[i])
            
            # Decode column
            col_decoded, col_error = self.col_ecc.decode(col_encoded_words[i])
            
            # Use row result as primary (both should decode to same data)
            decoded_sub_words.append(row_decoded)
            
            # Track errors
            if row_error == 'detected' or col_error == 'detected':
                error_detected = True
        
        # Unpack decoded sub-words
        decoded_data = self._unpack_data(decoded_sub_words)
        
        # Determine error type
        if error_detected:
            return decoded_data, 'detected'
        else:
            return decoded_data, 'corrected'

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