from typing import List, Tuple
from base_ecc import ECCBase

class PolarCode:
    """Simple Polar Code ECC implementation (toy, N=4).

    This is a reference implementation for educational/demo purposes.
    """
    def __init__(self, N: int = 4, K: int = 2, frozen_bits: List[int] = [0, 1]) -> None:
        """Initializes the polar code.

        Args:
            N: Block length (must be power of 2).
            K: Number of information bits.
            frozen_bits: Indices of frozen bits (0/1 values).
        """
        assert N == 4 and K == 2, "This demo only supports N=4, K=2."
        self.N = N
        self.K = K
        self.frozen_bits = frozen_bits

    def encode(self, u: List[int]) -> List[int]:
        """Encodes information bits using a toy polar code (N=4, K=2).

        Args:
            u: List of K information bits.
        Returns:
            Encoded codeword of length N.
        """
        # Place info bits in non-frozen positions
        x = [0] * self.N
        info_idx = 0
        for i in range(self.N):
            if i in self.frozen_bits:
                x[i] = 0  # frozen to 0
            else:
                x[i] = u[info_idx]
                info_idx += 1
        # Polar transform (for N=4):
        # x0 x1 x2 x3 -> y0 = x0^x1^x2^x3, y1 = x2^x3, y2 = x1^x3, y3 = x3
        y = [0]*4
        y[0] = x[0] ^ x[1] ^ x[2] ^ x[3]
        y[1] = x[2] ^ x[3]
        y[2] = x[1] ^ x[3]
        y[3] = x[3]
        return y

    def decode(self, y: List[int]) -> List[int]:
        """Decodes a codeword using a simple hard-decision SC decoder (N=4, K=2).

        Args:
            y: Received codeword (length N).
        Returns:
            Decoded information bits (length K).
        """
        # Invert the encoding for N=4
        # y3 = x3
        # y2 = x1 ^ x3 => x1 = y2 ^ y3
        # y1 = x2 ^ x3 => x2 = y1 ^ y3
        # y0 = x0 ^ x1 ^ x2 ^ x3 => x0 = y0 ^ x1 ^ x2 ^ x3
        x3 = y[3]
        x2 = y[1] ^ x3
        x1 = y[2] ^ x3
        x0 = y[0] ^ x1 ^ x2 ^ x3
        # Extract info bits from non-frozen positions
        info = []
        for i, v in enumerate([x0, x1, x2, x3]):
            if i not in self.frozen_bits:
                info.append(v)
        return info

class PolarECC(ECCBase):
    """Polar ECC implementation."""
    
    def __init__(self, n: int = 4, k: int = 2):
        """
        Initialize Polar ECC.
        
        Args:
            n: Block length (must be power of 2)
            k: Number of information bits
        """
        self.n = n
        self.k = k
        self.polar = PolarCode(N=n, K=k)
    
    def encode(self, data: int) -> int:
        """
        Encode data with Polar code.
        
        Args:
            data: Input data (k bits max)
            
        Returns:
            Codeword (n bits)
        """
        # Convert data to bit list
        data_bits = [(data >> i) & 1 for i in range(min(self.k, data.bit_length() or 1))]
        
        # Pad to k bits if needed
        while len(data_bits) < self.k:
            data_bits.insert(0, 0)
        
        # Encode with Polar
        codeword_bits = self.polar.encode(data_bits)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode codeword with Polar code.
        
        Args:
            codeword: Input codeword (n bits)
            
        Returns:
            Tuple of (decoded_data, error_detected, error_corrected)
        """
        # Convert codeword to bit list
        codeword_bits = [(codeword >> i) & 1 for i in range(min(self.n, codeword.bit_length() or 1))]
        
        # Pad to n bits if needed
        while len(codeword_bits) < self.n:
            codeword_bits.insert(0, 0)
        
        # Decode with Polar
        decoded_bits = self.polar.decode(codeword_bits)
        
        # Convert back to integer
        data = 0
        for i, bit in enumerate(decoded_bits):
            data |= (bit << i)
        
        # For this demo implementation, assume no errors detected/corrected
        return data, False, False 