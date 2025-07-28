from typing import List, Tuple
from base_ecc import ECCBase

class CompositeECC(ECCBase):
    """Composite ECC that applies multiple ECCs in sequence (encode) and reverse (decode)."""
    def __init__(self, ecc_chain: List[ECCBase] = None, data_length: int = None) -> None:
        """
        Args:
            ecc_chain (List[ECCBase]): List of ECC modules to apply in order.
            data_length (int): Data length for compatibility.
        """
        if ecc_chain is None:
            # Default to Parity + Hamming
            from parity_ecc import ParityECC
            from hamming_secded_ecc import HammingSECDEDECC
            self.ecc_chain = [ParityECC(data_length=data_length), HammingSECDEDECC(data_length=data_length)]
        else:
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
            # Apply decoders in reverse order
            decoded = codeword
            for ecc in reversed(self.ecc_chain):
                decoded, error_type = ecc.decode(decoded)
                if error_type == 'detected':
                    return decoded, 'detected'
            
            return decoded, 'corrected'
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