from typing import Tuple
from dataclasses import dataclass
from base_ecc import ECCBase

@dataclass
class BCHConfig:
    n: int  # Codeword length
    k: int  # Data length
    t: int  # Error correction capability

class BCHECC(ECCBase):
    """Pure Python BCH(15,7,2) ECC implementation. Only supports n=15, k=7, t=2."""
    # Generator polynomial for BCH(15,7,2): x^8 + x^7 + x^6 + x^4 + 1 (0b111010001)
    G = 0b111010001
    n = 15
    k = 7
    t = 2

    def __init__(self, config: BCHConfig) -> None:
        if (config.n, config.k, config.t) != (15, 7, 2):
            raise NotImplementedError("Only BCH(15,7,2) is supported in this pure Python implementation.")
        self.config = config

    def encode(self, data: int) -> int:
        """
        Encode 7-bit data into 15-bit BCH(15,7,2) codeword.
        Args:
            data (int): 7-bit data.
        Returns:
            int: 15-bit codeword.
        """
        if data >= (1 << 7):
            raise ValueError("Data must be 7 bits.")
        # Shift data left by 8 bits (n-k)
        codeword = data << 8
        # Calculate remainder
        for i in range(14, 7, -1):
            if (codeword >> i) & 1:
                codeword ^= BCHECC.G << (i - 8)
        # Append parity to data
        return (data << 8) | (codeword & 0xFF)

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode 15-bit BCH(15,7,2) codeword.
        Args:
            codeword (int): 15-bit codeword.
        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        if codeword >= (1 << 15):
            raise ValueError("Codeword must be 15 bits.")
        # Extract data
        data = (codeword >> 8) & 0x7F
        # Syndrome calculation (brute force for small code)
        # Try all single- and double-bit errors
        if self.encode(data) == codeword:
            return data, False, False  # No error
        # Try all single-bit errors
        for i in range(15):
            test = codeword ^ (1 << i)
            if self.encode((test >> 8) & 0x7F) == test:
                return (test >> 8) & 0x7F, True, True
        # Try all double-bit errors
        for i in range(15):
            for j in range(i+1, 15):
                test = codeword ^ (1 << i) ^ (1 << j)
                if self.encode((test >> 8) & 0x7F) == test:
                    return (test >> 8) & 0x7F, True, True
        # Uncorrectable error
        return data, True, False

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