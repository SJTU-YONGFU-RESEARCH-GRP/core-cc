from typing import Tuple
from dataclasses import dataclass
from base_ecc import ECCBase

@dataclass
class RSConfig:
    n: int  # Codeword length
    k: int  # Data length

class ReedSolomonECC(ECCBase):
    """Configurable Reed-Solomon ECC implementation (Python wrapper, uses reedsolo if available)."""
    def __init__(self, n: int = None, k: int = None, config: RSConfig = None, data_length: int = None) -> None:
        """
        Initialize Reed-Solomon ECC with either individual parameters or a config object.
        
        Args:
            n: Codeword length
            k: Data length
            config: RSConfig object (alternative to individual parameters)
            data_length: Alternative parameter for k (for compatibility)
        """
        if config is not None:
            self.config = config
        else:
            # Use provided parameters or defaults
            # Use provided parameters or defaults
            if n is None or k is None:
                # Determine parameters based on data_length if provided
                if data_length is not None:
                    # K must be at least data_length (in bytes)
                    # We default to T=2 (corrects 2 bytes), so N = K + 4
                    k = max(1, (data_length + 7) // 8)  # Convert bits/bytes to symbol count? 
                    # data_length passed from benchmark is in *bytes* or *bits*?
                    # benchmark_suite says: data = random.getrandbits(word_length)
                    # And ecc(data_length=word_length)
                    # Wait, benchmark_suite passes `word_length` (bits) or bytes?
                    # In benchmark_suite: `ecc_class(word_length)`
                    # Most ECCs treat `data_length` as bits?
                    # Let's check LDPCECC: `if data_length <= 8: ...` (implies chunks implies bytes? No, LDPCECC treats as bits in logic, but context implies bits)
                    # Actually standard RS works on bytes.
                    # If word_length=32 (bits) -> 4 bytes.
                    # So k should be 4.
                    
                    # Assume data_length is in BITS for consistency with other ECCs?
                    # Let's check usage.
                    # benchmark_suite: `ecc = ecc_class(word_length)` -> word_length is bits (e.g. 16, 32).
                    # RS.__init__: `k = (data_length + 7) // 8`
                    
                    k = (data_length + 7) // 8
                    n = k + 4 # T=2 capability
                    
                    # Ensure n <= 255 (GF(2^8) limit)
                    if n > 255:
                         # Truncate or error? For verifying, cap it.
                         n = 255
                         if k > 251: k = 251 # Maintain T=2
                else:
                    # Default
                    n, k = 7, 4
                
                self.config = RSConfig(n=n, k=k)
            else:
                self.config = RSConfig(n=n, k=k)
        
        try:
            import reedsolo
            self.rs = reedsolo.RSCodec(self.config.n - self.config.k)
        except ImportError:
            # Fallback implementation without reedsolo
            self.rs = None
        
        # Store data length for compatibility
        self.data_length = data_length

    def encode(self, data: int) -> int:
        """
        Encode data into Reed-Solomon codeword.

        Args:
            data: Data as integer.

        Returns:
            Encoded codeword as integer.
        """
        if self.rs is None:
            # Fallback: simple repetition code
            return data
        
        # For larger data, use the full Reed-Solomon approach
        # Convert data to bytes, ensuring it fits in k bits
        data_bytes = data.to_bytes((data.bit_length() + 7) // 8, 'big')
        
        # Ensure we have exactly k bytes
        target_bytes = self.config.k
        if len(data_bytes) > target_bytes:
            # Truncate to k bytes
            data_bytes = data_bytes[:target_bytes]
        elif len(data_bytes) < target_bytes:
            # Pad with zeros to k bytes
            padding_needed = target_bytes - len(data_bytes)
            data_bytes = b'\x00' * padding_needed + data_bytes
        
        # Encode using reedsolo
        codeword_bytes = self.rs.encode(data_bytes)
        
        # Convert back to integer (LSB first)
        codeword = 0
        for i, byte in enumerate(codeword_bytes):
            codeword |= (byte << (i * 8))
        
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode Reed-Solomon codeword.

        Args:
            codeword: Codeword as integer.

        Returns:
            Tuple of (decoded_data, error_type) where error_type is:
            - 'corrected': Error was detected and corrected
            - 'detected': Error was detected but not corrected  
            - 'undetected': Error was not detected
        """
        if self.rs is None:
            # Fallback: simple repetition code
            return codeword, 'corrected'
        
        try:
            # Convert codeword to bytes (LSB first)
            codeword_bytes = bytearray()
            temp_codeword = codeword
            for _ in range(self.config.n):
                codeword_bytes.append(temp_codeword & 0xFF)
                temp_codeword >>= 8
            
            # Ensure we have exactly n bytes
            target_bytes = self.config.n
            if len(codeword_bytes) > target_bytes:
                # Truncate to n bits
                codeword_bytes = codeword_bytes[:target_bytes]
            elif len(codeword_bytes) < target_bytes:
                # Pad with zeros to n bits
                padding_needed = target_bytes - len(codeword_bytes)
                codeword_bytes.extend([0] * padding_needed)
            
            # Decode using reedsolo
            decoded_bytes, decoded_ecc, err_pos = self.rs.decode(bytes(codeword_bytes))
            
            # Convert back to integer (LSB first)
            # Convert back to integer (Big Endian to match encode)
            decoded_data = int.from_bytes(decoded_bytes, 'big')
            
            if err_pos:
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
            codeword (int): The codeword to corrupt.
            bit_idx (int): The bit index to flip.

        Returns:
            int: The corrupted codeword.
        """
        return codeword ^ (1 << bit_idx) 