from typing import List, Tuple
from base_ecc import ECCBase

class CompositeECC(ECCBase):
    """Composite ECC that applies multiple ECCs in sequence (encode) and reverse (decode)."""
    def __init__(self, ecc_chain: List[ECCBase]) -> None:
        """
        Args:
            ecc_chain (List[ECCBase]): List of ECC modules to apply in order.
        """
        self.ecc_chain = ecc_chain

    def encode(self, data: int) -> int:
        """
        Apply all ECC encoders in sequence.

        Args:
            data (int): The input data to encode.

        Returns:
            int: The encoded codeword after all ECCs.
        """
        for ecc in self.ecc_chain:
            data = ecc.encode(data)
        return data

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Apply all ECC decoders in reverse sequence.

        Args:
            codeword (int): The codeword to decode.

        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        error_detected = False
        error_corrected = False
        for ecc in reversed(self.ecc_chain):
            data, detected, corrected = ecc.decode(codeword)
            error_detected = error_detected or detected
            error_corrected = error_corrected or corrected
            codeword = data
        return codeword, error_detected, error_corrected

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