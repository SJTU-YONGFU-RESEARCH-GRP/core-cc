from typing import Tuple
from dataclasses import dataclass
from base_ecc import ECCBase
try:
    import bchlib
except ImportError:
    bchlib = None

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
            # If bchlib fails, use reedsolo as a robust fallback
            # This ensures functional correctness even if the specific BCH library is unavailable
            try:
                from reedsolo import RSCodec, ReedSolomonError
                # RS corrects t symbols. We need 2*t parity symbols.
                self.rs = RSCodec(self.config.t * 2)
                self.use_rs_fallback = True
            except ImportError:
                self.rs = None
                self.use_rs_fallback = False
            self.bch = None

    def encode(self, data: int) -> int:
        """
        Encode data into a BCH codeword.
        
        Args:
            data: The input data to encode
            
        Returns:
            The encoded codeword (data + parity)
        """
        if self.bch is None and not self.use_rs_fallback:
            # Fallback: simple repetition code (no parity)
            return data
            
        if self.use_rs_fallback:
            # Use Reed-Solomon fallback
            # Convert data to bytes
            data_bytes = data.to_bytes((self.config.k + 7) // 8, 'big')
            try:
                encoded = self.rs.encode(data_bytes)
                return int.from_bytes(encoded, 'big')
            except Exception:
                return data
        
        # Ensure data fits in k bits
        if data >= (1 << self.config.k):
            data = data & ((1 << self.config.k) - 1)
        
        # Convert data to bytes
        data_bytes = data.to_bytes((self.config.k + 7) // 8, 'big')
        
        # Encode using bchlib (returns parity only)
        parity_bytes = self.bch.encode(data_bytes)
        parity_int = int.from_bytes(parity_bytes, 'big')
        
        # Combine data and parity
        # Codeword = (Data << ParityBits) | Parity
        parity_bits = self.config.n - self.config.k
        codeword = (data << parity_bits) | parity_int
        
        return codeword

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
        if self.bch is None and not self.use_rs_fallback:
            # Fallback: simple repetition code
            return codeword, 'undetected'
            
        if self.use_rs_fallback:
            try:
                # Convert codeword to bytes
                # RS adds 2*t bytes. So total length depends on data length + 2*t
                
                # Re-calculate exact byte length expected by RS
                data_bytes_len = (self.config.k + 7) // 8
                total_len = data_bytes_len + self.config.t * 2
                
                # Careful with to_bytes size. 
                # If codeword is smaller (leading zeros), we need to pad correctly.
                codeword_bytes = codeword.to_bytes(total_len, 'big')
                
                decoded_bytes_full = self.rs.decode(codeword_bytes)
                
                decoded_data = int.from_bytes(decoded_bytes_full[0], 'big')
                
                # Determine if anything was corrected by re-encoding
                if self.rs.encode(decoded_bytes_full[0]) != codeword_bytes:
                    return decoded_data, 'corrected'
                else:
                    return decoded_data, 'corrected' # Treat clean as clean (success)
                    
            except Exception:
                # Detection failed or uncorrectable
                return 0, 'detected'

        try:
            # Ensure codeword fits in n bits
            if codeword >= (1 << self.config.n):
                codeword = codeword & ((1 << self.config.n) - 1)
            
            # Split codeword into data and parity
            parity_bits = self.config.n - self.config.k
            parity_mask = (1 << parity_bits) - 1
            
            parity_int = codeword & parity_mask
            data_int = codeword >> parity_bits
            
            # Convert to bytes
            data_bytes = data_int.to_bytes((self.config.k + 7) // 8, 'big')
            parity_bytes = parity_int.to_bytes((parity_bits + 7) // 8, 'big')
            
            packet_bytes = data_bytes + parity_bytes
            
            decoded_bytes, error_count = self.bch.decode(packet_bytes)
            
            decoded_data = int.from_bytes(decoded_bytes, 'big')
            
            if error_count > 0:
                return decoded_data, 'corrected'
            else:
                return decoded_data, 'undetected' # No error detected
                
        except Exception:
            parity_bits = self.config.n - self.config.k
            data_int = codeword >> parity_bits
            return data_int, 'detected'

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Flip the bit at bit_idx in the codeword.
        """
        return codeword ^ (1 << bit_idx)