from typing import Tuple
from dataclasses import dataclass
from base_ecc import ECCBase

@dataclass
class RSConfig:
    n: int  # Codeword length
    k: int  # Data length

class ReedSolomonECC(ECCBase):
    """Configurable Reed-Solomon ECC implementation (Python wrapper, uses reedsolo if available)."""
    def __init__(self, config: RSConfig) -> None:
        """
        Args:
            config (RSConfig): Reed-Solomon code parameters.
        """
        self.config = config
        try:
            import reedsolo
            self.rs = reedsolo.RSCodec(self.config.n - self.config.k)
        except ImportError:
            self.rs = None

    def encode(self, data: int) -> int:
        """
        Encode data into Reed-Solomon codeword.

        Args:
            data (int): Data as integer.

        Returns:
            int: Encoded codeword as integer.
        """
        if self.rs is None:
            raise NotImplementedError("reedsolo is required for Reed-Solomon ECC encoding.")
        data_bytes = data.to_bytes((self.config.k + 7) // 8, 'big')
        codeword_bytes = self.rs.encode(data_bytes)
        return int.from_bytes(codeword_bytes, 'big')

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode Reed-Solomon codeword.

        Args:
            codeword (int): Codeword as integer.

        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        if self.rs is None:
            raise NotImplementedError("reedsolo is required for Reed-Solomon ECC decoding.")
        # Compute the minimum number of bytes needed to represent codeword
        min_bytes = (codeword.bit_length() + 7) // 8 or 1
        total_bytes = max((self.config.n + 7) // 8, min_bytes)
        codeword_bytes = codeword.to_bytes(total_bytes, 'big')
        try:
            decoded_bytes, _, _ = self.rs.decode(codeword_bytes)
            decoded = int.from_bytes(decoded_bytes, 'big')
            return decoded, False, False  # No error detected
        except Exception:
            # If decode fails, error detected
            return 0, True, False

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