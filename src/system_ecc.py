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

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a system codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Decode with the system ECC
            decoded_data = self.system_code.decode(codeword)
            return decoded_data, 'corrected'
        except Exception:
            # If decoding fails, error detected
            return codeword, 'detected'

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