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

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a composite codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Decode with inner code first
            inner_decoded, inner_error = self.inner_code.decode(codeword)
            
            # Then decode with outer code
            outer_decoded, outer_error = self.outer_code.decode(inner_decoded)
            
            # Determine overall error type
            if outer_error == 'corrected' and inner_error == 'corrected':
                return outer_decoded, 'corrected'
            elif outer_error == 'detected' or inner_error == 'detected':
                return outer_decoded, 'detected'
            else:
                return outer_decoded, 'undetected'
        except Exception:
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