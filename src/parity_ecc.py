from typing import Tuple
from base_ecc import ECCBase

class ParityECC(ECCBase):
    """Parity bit ECC implementation."""
    def encode(self, data: int) -> int:
        """
        Encode data with even parity.

        Args:
            data (int): The input data to encode (8 bits).

        Returns:
            int: The codeword (data concatenated with parity bit as LSB).
        """
        bits = [(data >> i) & 1 for i in range(8)]
        parity = sum(bits) % 2
        return (data << 1) | parity

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode codeword and check for single-bit error.

        Args:
            codeword (int): The codeword (data + parity bit as LSB).

        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        data = codeword >> 1
        parity = codeword & 1
        bits = [(data >> i) & 1 for i in range(8)]
        error_detected = (sum(bits) % 2) != parity
        # Parity can only detect, not correct
        return data, error_detected, False

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