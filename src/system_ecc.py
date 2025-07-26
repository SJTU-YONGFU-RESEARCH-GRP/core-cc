from typing import Tuple
from base_ecc import ECCBase

class SystemSECDEDECC(ECCBase):
    """System-level Hamming SECDED ECC implementation for 8-bit data (example system ECC)."""
    def encode(self, data: int) -> int:
        """
        Encode 8-bit data into 13-bit codeword (adds an extra system-level parity bit).

        Args:
            data (int): The input data to encode (8 bits).

        Returns:
            int: The 13-bit codeword (12 bits Hamming SECDED + 1 system parity).
        """
        # Use Hamming SECDED for 8 bits, then add a system-level parity bit
        # (Reuse logic from HammingSECDEDECC, but add a parity bit as MSB)
        from hamming_secded_ecc import HammingSECDEDECC
        hamming = HammingSECDEDECC()
        code12 = hamming.encode(data)
        # Compute system-level parity (even parity over all 12 bits)
        parity = bin(code12).count('1') % 2
        return (parity << 12) | code12

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode 13-bit codeword (system-level SECDED).

        Args:
            codeword (int): The 13-bit codeword.

        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        from hamming_secded_ecc import HammingSECDEDECC
        hamming = HammingSECDEDECC()
        parity = (codeword >> 12) & 1
        code12 = codeword & 0xFFF
        # Check system-level parity
        expected_parity = bin(code12).count('1') % 2
        parity_error = (parity != expected_parity)
        data, detected, corrected = hamming.decode(code12)
        error_detected = detected or parity_error
        # If only system parity error, cannot correct
        error_corrected = corrected
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
        return codeword ^ (1 << bit_idx) 