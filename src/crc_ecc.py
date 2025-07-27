from typing import List, Tuple
from base_ecc import ECCBase

class CRC8:
    """CRC-8 ECC implementation (polynomial x^8 + x^2 + x + 1, 0x07).

    Provides encode (append CRC) and check (verify CRC) methods.
    """
    def __init__(self, poly: int = 0x07, init: int = 0x00) -> None:
        """Initializes the CRC-8 code.

        Args:
            poly: Generator polynomial (default 0x07).
            init: Initial value (default 0x00).
        """
        self.poly = poly
        self.init = init

    def compute(self, data: List[int]) -> int:
        """Computes the CRC-8 value for the given data bits.

        Args:
            data: List of 0/1 bits.
        Returns:
            CRC-8 value as integer (8 bits).
        """
        crc = self.init
        for bit in data:
            crc ^= (bit << 7)
            for _ in range(8):
                if crc & 0x80:
                    crc = ((crc << 1) ^ self.poly) & 0xFF
                else:
                    crc = (crc << 1) & 0xFF
        return crc

    def encode(self, data: List[int]) -> List[int]:
        """Appends CRC-8 to the data bits.

        Args:
            data: List of 0/1 bits.
        Returns:
            List of bits with CRC-8 appended (data + 8 bits).
        """
        crc = self.compute(data)
        crc_bits = [(crc >> i) & 1 for i in reversed(range(8))]
        return data + crc_bits

    def check(self, codeword: List[int]) -> bool:
        """Checks if the codeword has a valid CRC-8.

        Args:
            codeword: List of bits (data + 8 CRC bits).
        Returns:
            True if CRC matches, False otherwise.
        """
        if len(codeword) < 8:
            return False
        data = codeword[:-8]
        crc_bits = codeword[-8:]
        crc = self.compute(data)
        crc_check = [(crc >> i) & 1 for i in reversed(range(8))]
        return crc_bits == crc_check 

class CRCECC(ECCBase):
    """CRC-based ECC implementation."""
    
    def __init__(self, polynomial: int = 0x11):
        """
        Initialize CRC ECC.
        
        Args:
            polynomial: CRC polynomial (default 0x11 for CRC-4)
        """
        self.polynomial = polynomial
        self.crc = CRC8(poly=polynomial)
        self.crc_bits = 8  # CRC-8 uses 8 bits
    
    def encode(self, data: int) -> int:
        """
        Encode data with CRC.
        
        Args:
            data: Input data
            
        Returns:
            Codeword with CRC appended
        """
        # Convert data to bit list
        data_bits = [(data >> i) & 1 for i in range(data.bit_length() or 1)]
        
        # Encode with CRC
        codeword_bits = self.crc.encode(data_bits)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def _calculate_crc(self, data: int) -> int:
        """
        Calculate CRC for given data.
        
        Args:
            data: Input data
            
        Returns:
            CRC value
        """
        # Convert data to bit list
        data_bits = [(data >> i) & 1 for i in range(data.bit_length() or 1)]
        
        # Calculate CRC
        return self.crc.compute(data_bits)
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a CRC codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Extract data and CRC
        data_bits = codeword >> self.crc_bits
        crc_received = codeword & ((1 << self.crc_bits) - 1)
        
        # Calculate expected CRC
        crc_expected = self._calculate_crc(data_bits)
        
        if crc_received == crc_expected:
            return data_bits, 'corrected'  # No error
        else:
            return data_bits, 'detected'   # Error detected 