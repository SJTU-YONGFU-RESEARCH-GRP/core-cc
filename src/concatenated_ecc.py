from typing import Tuple, List
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.base_ecc import ECCBase

class ConcatenatedECC(ECCBase):
    """Concatenated ECC that chains multiple ECCs in sequence."""
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Concatenated ECC.
        
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
            self.inner_word_length = 2
        elif self.word_length <= 8:
            self.inner_word_length = 4
        elif self.word_length <= 16:
            self.inner_word_length = 4  # Use 4-bit sub-words for 16-bit data
        else:
            self.inner_word_length = 4  # Use 4-bit sub-words for 32-bit data
        
        # Import ECCs with correct paths
        from src.parity_ecc import ParityECC
        from src.hamming_secded_ecc import HammingSECDEDECC
        
        self.inner_ecc = ParityECC(data_length=self.inner_word_length)
        self.outer_ecc = HammingSECDEDECC(data_length=5)  # ParityECC outputs 5 bits

    def _pack_data(self, data: int) -> List[int]:
        """Pack data into sub-words for concatenated encoding."""
        sub_words = []
        mask = (1 << self.inner_word_length) - 1
        
        for i in range(0, self.word_length, self.inner_word_length):
            sub_word = (data >> i) & mask
            sub_words.append(sub_word)
        
        return sub_words

    def _unpack_data(self, sub_words: List[int]) -> int:
        """Unpack sub-words back to original data."""
        data = 0
        for i, sub_word in enumerate(sub_words):
            data |= (sub_word << (i * self.inner_word_length))
        return data

    def encode(self, data: int) -> int:
        """
        Encode data using concatenated ECC structure.
        
        Args:
            data (int): The input data to encode.
            
        Returns:
            int: The encoded concatenated codeword.
        """
        # Ensure data fits within word length
        if data >= (1 << self.word_length):
            data = data & ((1 << self.word_length) - 1)
        
        # Pack data into sub-words that fit the inner ECC capacity
        # For 8-bit data with 4-bit inner ECC, we need 2 sub-words
        sub_words = []
        for i in range(0, self.word_length, self.inner_word_length):
            sub_word = (data >> i) & ((1 << self.inner_word_length) - 1)
            sub_words.append(sub_word)
        
        # Encode each sub-word with inner ECC first
        inner_encoded_words = []
        for sub_word in sub_words:
            inner_encoded = self.inner_ecc.encode(sub_word)
            inner_encoded_words.append(inner_encoded)
        
        # Encode each inner codeword with outer ECC
        outer_encoded_words = []
        for inner_encoded in inner_encoded_words:
            outer_encoded = self.outer_ecc.encode(inner_encoded)
            outer_encoded_words.append(outer_encoded)
        
        # Pack encoded words into a single codeword
        codeword = 0
        bit_pos = 0
        
        for word in outer_encoded_words:
            word_bits = self.outer_ecc.n if hasattr(self.outer_ecc, 'n') else 13
            codeword |= (word << bit_pos)
            bit_pos += word_bits
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a concatenated codeword with robust bit-unpacking.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Calculate how many sub-words we have
        num_sub_words = (self.word_length + self.inner_word_length - 1) // self.inner_word_length
        
        # Extract outer encoded words
        outer_encoded_words = []
        bit_pos = 0
        
        for i in range(num_sub_words):
            word_bits = self.outer_ecc.n if hasattr(self.outer_ecc, 'n') else 13
            word = (codeword >> bit_pos) & ((1 << word_bits) - 1)
            outer_encoded_words.append(word)
            bit_pos += word_bits
        
        # Decode each sub-word
        decoded_sub_words = []
        error_detected = False
        
        for outer_encoded in outer_encoded_words:
            # Decode outer ECC first
            inner_encoded, outer_error = self.outer_ecc.decode(outer_encoded)
            
            # Decode inner ECC
            decoded_sub_word, inner_error = self.inner_ecc.decode(inner_encoded)
            
            decoded_sub_words.append(decoded_sub_word)
            
            # Track errors
            if outer_error == 'detected' or inner_error == 'detected':
                error_detected = True
        
        # Unpack decoded sub-words back to original data
        decoded_data = 0
        for i, sub_word in enumerate(decoded_sub_words):
            # Ensure sub_word fits within inner_word_length bits
            sub_word = sub_word & ((1 << self.inner_word_length) - 1)
            decoded_data |= (sub_word << (i * self.inner_word_length))
        
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