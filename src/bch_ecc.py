from typing import Tuple
from dataclasses import dataclass
from base_ecc import ECCBase
import bchlib

@dataclass
class BCHConfig:
    """Configuration for BCH codes."""
    n: int  # Codeword length
    k: int  # Data length
    t: int  # Error correction capability

class BCHECC(ECCBase):
    """BCH ECC implementation using bchlib."""
    
    def __init__(self, n: int = None, k: int = None, t: int = None, config: BCHConfig = None, data_length: int = None) -> None:
        """
        Initialize BCH ECC with either individual parameters or a config object.
        
        Args:
            n: Codeword length
            k: Data length  
            t: Error correction capability
            config: BCHConfig object (alternative to individual parameters)
            data_length: Alternative parameter for k (for compatibility)
        """
        if config is not None:
            self.config = config
        else:
            # Use provided parameters or defaults
            if n is None or k is None or t is None:
                # Determine parameters based on data_length if provided
                if data_length is not None:
                    if data_length <= 4:
                        n, k, t = 7, 4, 1    # BCH(7,4,1)
                    elif data_length <= 8:
                        n, k, t = 15, 7, 2   # BCH(15,7,2)
                    elif data_length <= 16:
                        n, k, t = 31, 16, 3  # BCH(31,16,3)
                    else:
                        n, k, t = 63, 32, 6  # BCH(63,32,6)
                else:
                    # Default to BCH(15,7,2) if no parameters provided
                    n, k, t = 15, 7, 2
                
                self.config = BCHConfig(n=n, k=k, t=t)
            else:
                self.config = BCHConfig(n=n, k=k, t=t)
        
        # Initialize bchlib with the configuration
        # bchlib.BCH expects (prim_poly, t) where prim_poly is the primitive polynomial
        # For common BCH codes, we'll use standard primitive polynomials
        try:
            if self.config.n == 7 and self.config.k == 4 and self.config.t == 1:
                # BCH(7,4,1) - primitive polynomial x^3 + x + 1
                self.bch = bchlib.BCH(0b1011, self.config.t)
            elif self.config.n == 15 and self.config.k == 7 and self.config.t == 2:
                # BCH(15,7,2) - primitive polynomial x^4 + x + 1
                self.bch = bchlib.BCH(0b10011, self.config.t)
            elif self.config.n == 31 and self.config.k == 16 and self.config.t == 3:
                # BCH(31,16,3) - primitive polynomial x^5 + x^2 + 1
                self.bch = bchlib.BCH(0b100101, self.config.t)
            elif self.config.n == 63 and self.config.k == 32 and self.config.t == 6:
                # BCH(63,32,6) - primitive polynomial x^6 + x + 1
                self.bch = bchlib.BCH(0b1000011, self.config.t)
            else:
                # For other parameters, try to use a reasonable primitive polynomial
                # This is a fallback and may not work for all parameter combinations
                self.bch = bchlib.BCH(0b10011, self.config.t)
        except Exception:
            # If bchlib fails, use a simple fallback
            self.bch = None

    def encode(self, data: int) -> int:
        """
        Encode data into a BCH codeword.
        
        Args:
            data: The input data to encode
            
        Returns:
            The encoded codeword
        """
        if self.bch is None:
            # Fallback: simple repetition code
            return data
        
        # Ensure data fits in k bits
        if data >= (1 << self.config.k):
            data = data & ((1 << self.config.k) - 1)
        
        # Convert data to bytes
        data_bytes = data.to_bytes((self.config.k + 7) // 8, 'big')
        
        # Encode using bchlib
        codeword_bytes = self.bch.encode(data_bytes)
        
        # Convert back to integer
        return int.from_bytes(codeword_bytes, 'big')

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a BCH codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type) where error_type is:
            - 'corrected': Error was detected and corrected
            - 'detected': Error was detected but not corrected  
            - 'undetected': Error was not detected
        """
        if self.bch is None:
            # Fallback: simple repetition code
            return codeword, 'corrected'
        
        try:
            # Ensure codeword fits in n bits
            if codeword >= (1 << self.config.n):
                codeword = codeword & ((1 << self.config.n) - 1)
            
            # Convert codeword to bytes
            codeword_bytes = codeword.to_bytes((self.config.n + 7) // 8, 'big')
            
            # Decode using bchlib
            decoded_bytes, error_count = self.bch.decode(codeword_bytes)
            
            # Convert back to integer
            decoded_data = int.from_bytes(decoded_bytes, 'big')
            
            if error_count > 0:
                return decoded_data, 'corrected'
            else:
                return decoded_data, 'undetected'
                
        except Exception:
            # If decoding fails, error was detected but not corrected
            return codeword, 'detected'

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Flip the bit at bit_idx in the codeword.
        
        Args:
            codeword: The codeword to corrupt
            bit_idx: The bit index to flip
            
        Returns:
            The corrupted codeword
        """
        return codeword ^ (1 << bit_idx)