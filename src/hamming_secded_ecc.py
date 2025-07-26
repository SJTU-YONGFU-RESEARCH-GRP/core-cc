from typing import Tuple
from base_ecc import ECCBase

class HammingSECDEDECC(ECCBase):
    """Hamming SECDED (Single Error Correction, Double Error Detection) ECC implementation for 8-bit data."""
    def encode(self, data: int) -> int:
        """
        Encode 8-bit data into 12-bit Hamming SECDED codeword.

        Args:
            data (int): The input data to encode (8 bits).

        Returns:
            int: The 12-bit codeword.
        """
        d = [(data >> i) & 1 for i in range(8)]
        p = [0] * 4
        p[0] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6]
        p[1] = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6]
        p[2] = d[1] ^ d[2] ^ d[3] ^ d[7]
        p[3] = d[4] ^ d[5] ^ d[6] ^ d[7]
        code = 0
        for i, bit in enumerate([p[3], p[2], p[1], p[0]] + d[::-1]):
            code |= (bit << (11 - i))
        return code

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode 12-bit Hamming SECDED codeword.

        Args:
            codeword (int): The 12-bit codeword.

        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        c = [(codeword >> i) & 1 for i in range(12)]
        s = [0] * 4
        s[0] = c[0] ^ c[4] ^ c[5] ^ c[7] ^ c[8] ^ c[10]
        s[1] = c[1] ^ c[4] ^ c[6] ^ c[7] ^ c[9] ^ c[10]
        s[2] = c[2] ^ c[5] ^ c[6] ^ c[7] ^ c[11]
        s[3] = c[3] ^ c[8] ^ c[9] ^ c[10] ^ c[11]
        syndrome = (s[3] << 3) | (s[2] << 2) | (s[1] << 1) | s[0]
        error_detected = syndrome != 0
        error_corrected = False
        c_corr = c.copy()
        if error_detected and 0 < syndrome <= 12:
            c_corr[12 - syndrome] ^= 1
            error_corrected = True
        # Extract data bits
        data = 0
        for i, idx in enumerate([11, 10, 9, 8, 7, 6, 5, 4]):
            data |= (c_corr[idx] << (7 - i))
        return data, error_detected, error_corrected

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