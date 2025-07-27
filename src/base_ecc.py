from typing import Tuple

class ECCBase:
    """Abstract base class for ECC schemes."""
    def encode(self, data: int) -> int:
        """
        Encode data into a codeword.

        Args:
            data (int): The input data to encode.

        Returns:
            int: The encoded codeword.
        """
        raise NotImplementedError

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a codeword and return the original data.
        
        Args:
            codeword: The encoded codeword
            
        Returns:
            Tuple of (decoded_data, error_type) where error_type is one of:
            - 'corrected': Error was detected and corrected
            - 'detected': Error was detected but not corrected
            - 'undetected': Error was not detected
        """
        raise NotImplementedError("Subclasses must implement decode method")

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