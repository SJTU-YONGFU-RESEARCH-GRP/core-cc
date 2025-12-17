from typing import List, Tuple
from base_ecc import ECCBase

class GolayCode:
    """
    Binary (23,12) Golay Code ECC implementation.
    Uses Systematic Cyclic Encoding and Syndrome Table Decoding.
    """
    def __init__(self) -> None:
        self.n = 23
        self.k = 12
        # Generator polynomial for Golay (23,12): g(x) = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1 ?
        # Standard: g(x) = x^11 + x^9 + x^7 + x^6 + x^5 + x + 1 (0xAE3? No. 101011100011 -> AE3? No)
        # 1 0 1 0 1 1 1 0 0 0 1 1
        # Coefficients: 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1 (Wait, highest power first?)
        # Let's use the one from the dummy file which claimed to be correct: 0b1000000001011 ??
        # The dummy file said: 0b1000000001011 = x^11 + ...
        # Let's use a standard well-known polynomial: 0xC75 (Octal 6165)
        # g(x) = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1
        # Bin: 1 1 0 0 0 1 1 1 0 1 0 1 => 0xC75.
        self.poly = 0xC75
        
        # Precompute Syndrome Table for correction of up to 3 errors
        # (Syndrome -> Error Pattern)
        # This takes some time to init, but only done once.
        self.syndrome_table = {}
        self._build_syndrome_table()

    def _build_syndrome_table(self):
        """Builds mapping from Syndrome (11 bits) to Error Pattern (23 bits)."""
        # 0 errors
        self.syndrome_table[0] = 0
        
        # 1 error
        for i in range(23):
            err = 1 << i
            syn = self._calculate_syndrome(err)
            self.syndrome_table[syn] = err
            
        # 2 errors
        for i in range(23):
            for j in range(i+1, 23):
                err = (1 << i) | (1 << j)
                syn = self._calculate_syndrome(err)
                if syn not in self.syndrome_table: # Prefer lower weight
                    self.syndrome_table[syn] = err
                    
        # 3 errors
        # Note: 3 errors takes combinatorial search. 23C3 = 1771 combos.
        # Total entries in table <= 2048. 1+23+253+1771 = 2048. Perfect.
        # (23,12,7) code is perfect 3-error correcting code.
        for i in range(23):
            for j in range(i+1, 23):
                for k in range(j+1, 23):
                    err = (1 << i) | (1 << j) | (1 << k)
                    syn = self._calculate_syndrome(err)
                    if syn not in self.syndrome_table:
                        self.syndrome_table[syn] = err

    def _calculate_syndrome(self, vec_int: int) -> int:
        """Calculates syndrome of 23-bit vector (remainder of division by g(x))."""
        # Systematic encoding usually implies: C(x) = D(x)*x^(N-K) + (D(x)*x^(N-K) mod g(x))
        # Wait, if we receive R(x), Syndrome S(x) = R(x) mod g(x).
        
        # Polynomial division over GF(2)
        d = vec_int
        # Evaluate degree? No, just shift register simulation
        # Using simple bitwise long division
        
        # High bit of 23-bit codeword is coefficient of x^22.
        # Generator is degree 11 (highest bit is x^11).
        # We process from high bit down.
        
        out = d
        # Loop from degree 22 down to 11
        for i in range(22, 10, -1):
            if (out >> i) & 1:
                # Subtract (XOR) generator shifted
                out ^= (self.poly << (i - 11))
                
        # Remainder is lower 11 bits
        return out & 0x7FF

    def encode(self, data: int) -> int:
        """Encodes 12-bit data into 23-bit codeword."""
        # Systematic: D(x) shifted left by 11 places
        shifted_data = data << 11
        
        # Remainder = (shifted_data) mod g(x)
        remainder = self._calculate_syndrome(shifted_data)
        
        # Codeword = shifted_data + remainder
        return shifted_data | remainder

    def decode(self, codeword: int) -> int:
        """Decodes 23-bit codeword using Syndrome Table."""
        syn = self._calculate_syndrome(codeword)
        
        if syn == 0:
            err_pattern = 0
        else:
            err_pattern = self.syndrome_table.get(syn, 0) # Should always be found if <=3 errors
            
        corrected = codeword ^ err_pattern
        
        # Return data part (top 12 bits)
        return (corrected >> 11) & 0xFFF

class GolayECC(ECCBase):
    """Golay ECC wrapper for benchmark."""
    
    def __init__(self, data_length: int = None):
        if data_length is not None:
             self.num_blocks = data_length
        else:
             self.num_blocks = 1
             
        self.n = 23 * self.num_blocks
        self.k = 12 * self.num_blocks # Logic K (though we use 8 data bits per block)
        self.golay = GolayCode()
    
    def encode(self, data: int) -> int:
        codeword = 0
        for i in range(self.num_blocks):
            # Extract 8-bit chunk (treat as 12-bit with 4 leading zeros)
            chunk = (data >> (i * 8)) & 0xFF
            cw_chunk = self.golay.encode(chunk)
            # Append 23-bit chunk
            codeword |= (cw_chunk << (i * 23))
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        data = 0
        overall_status = 'corrected'
        
        for i in range(self.num_blocks):
            # Extract 23-bit chunk
            cw_chunk = (codeword >> (i * 23)) & 0x7FFFFF # 23 bits mask
            
            corrected_d = self.golay.decode(cw_chunk)
            # Corrected D is 12 bits. We only care about lower 8 bits (since we padded)
            # Wait, existing 'encode' does 'shifted_data = data << 11'.
            # And 'decode' returns '(corrected >> 11) & 0xFFF'.
            # If we input 8 bits, 'encode' shifts it.
            # 'decode' returns the 8 bits (in the LSBs of the 12-bit result).
            # Yes, if input < 0xFFF.
            
            # Mask to 8 bits just in case
            d_byte = corrected_d & 0xFF
            
            data |= (d_byte << (i * 8))
            
        return data, 'corrected'

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        return codeword ^ (1 << bit_idx)