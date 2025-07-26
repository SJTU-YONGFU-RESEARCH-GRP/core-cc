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

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode a codeword.

        Args:
            codeword (int): The codeword to decode.

        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        raise NotImplementedError

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