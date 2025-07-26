from typing import Tuple
from base_ecc import ECCBase

class TurboECC(ECCBase):
    """Turbo ECC using commpy for prototyping (stub)."""
    def __init__(self) -> None:
        try:
            import commpy
            self.commpy = commpy
        except ImportError:
            self.commpy = None

    def encode(self, data: int) -> int:
        """
        Turbo code encoding (not implemented).
        """
        raise NotImplementedError("Turbo code encoding requires commpy and is non-trivial.")

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Turbo code decoding (not implemented).
        """
        raise NotImplementedError("Turbo code decoding requires commpy and is non-trivial.")

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