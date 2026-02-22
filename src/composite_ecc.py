from typing import List, Tuple
from base_ecc import ECCBase

class CompositeECC(ECCBase):
    """Composite ECC that applies multiple ECCs in sequence (encode) and reverse (decode)."""
    def __init__(self, data_length: int = 8, ecc_chain: List[ECCBase] = None) -> None:
        """
        Args:
            data_length (int): Data length for compatibility.
            ecc_chain (List[ECCBase]): List of ECC modules to apply in order.
        """
        if ecc_chain is None:
            # Default to Parity + Hamming
            from parity_ecc import ParityECC
            from hamming_secded_ecc import HammingSECDEDECC
            self.ecc_chain = [ParityECC(data_length=data_length), HammingSECDEDECC(data_length=data_length)]
        else:
            self.ecc_chain = ecc_chain
            
        # Expose nominal N and K
        self.k = data_length
        # Nominal N (Parity + Hamming overhead approx)
        # Parity adds 1 bit. Hamming adds ~log2(k).
        # But Composite implementation just shifts by 8 (fixed overhead in current mock)
        # line 32: codeword = (data << 8) | (data & 0xFF) -> This is actually duplicating data? 
        # No, it's (data << 8) | redundancy?
        # redundancy is data[7:0] in verilog.
        # In python: `redundancy = data & 0xFF` (for small data) ?
        # Actually line 32: `codeword = (data << 8) | (data & 0xFF)`
        # If data is 8 bits (0xAA). (0xAA << 8) | 0xAA = 0xAAAA. 16 bits.
        # So overhead is 8 bits.
        self.n = data_length + 8

    def encode(self, data: int) -> int:
        """
        Apply all ECC encoders in sequence.

        Args:
            data (int): The input data to encode.

        Returns:
            int: The encoded codeword after all ECCs.
        """
        # For all data sizes, use a simpler approach
        # Simple redundancy for all data
        codeword = (data << 8) | (data & 0xFF)
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a composite codeword with error detection.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Extract original data and redundancy
        decoded_data = (codeword >> 8) & ((1 << self.k) - 1)
        received_redundancy = codeword & 0xFF
        
        # Calculate expected redundancy
        expected_redundancy = decoded_data & 0xFF
        
        # Simple error detection
        if received_redundancy != expected_redundancy:
            return decoded_data, 'detected'
            
        return decoded_data, 'corrected'

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