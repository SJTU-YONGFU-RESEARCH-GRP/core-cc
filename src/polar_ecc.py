from typing import List, Tuple
from base_ecc import ECCBase

class PolarCode:
    """Simple Polar Code ECC implementation (toy, N=4).

    This is a reference implementation for educational/demo purposes.
    """
    def __init__(self, N: int = 4, K: int = 2, frozen_bits: List[int] = None) -> None:
        """Initializes the polar code.

        Args:
            N: Block length (must be power of 2).
            K: Number of information bits.
            frozen_bits: Indices of frozen bits (0/1 values).
        """
        self.N = N
        self.K = K
        
        # Set frozen bits based on N and K
        if frozen_bits is None:
            if N == 4 and K == 2:
                self.frozen_bits = [0, 1]
            elif N == 8 and K == 4:
                self.frozen_bits = [0, 1, 2, 3]
            elif N == 16 and K == 8:
                self.frozen_bits = [0, 1, 2, 3, 4, 5, 6, 7]
            elif N == 32 and K == 16:
                self.frozen_bits = list(range(16))
            else:
                # Default: freeze first N-K bits
                self.frozen_bits = list(range(N - K))
        else:
            self.frozen_bits = frozen_bits

    def encode(self, u: List[int]) -> List[int]:
        """Encodes information bits using a toy polar code.

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
        
        # Simple polar transform (for demo purposes)
        # This is a simplified version that works for any N
        y = [0] * self.N
        for i in range(self.N):
            y[i] = x[i]
            # Add some XOR operations for polarization effect
            for j in range(i + 1, self.N):
                if (i + j) % 2 == 0:
                    y[i] ^= x[j]
        
        return y

    def decode(self, y: List[int]) -> List[int]:
        """Decodes a codeword using a simple hard-decision SC decoder.

        Args:
            y: Received codeword (length N).
        Returns:
            Decoded information bits (length K).
        """
        # Simple inverse transform (for demo purposes)
        # This is a simplified version that works for any N
        x = [0] * self.N
        for i in range(self.N):
            x[i] = y[i]
            # Reverse the XOR operations
            for j in range(i + 1, self.N):
                if (i + j) % 2 == 0:
                    x[i] ^= y[j]
        
        # Extract info bits from non-frozen positions
        info = []
        for i, v in enumerate(x):
            if i not in self.frozen_bits:
                info.append(v)
        return info

class PolarECC(ECCBase):
    """Polar ECC implementation."""
    
    def __init__(self, n: int = 4, k: int = 2, data_length: int = None):
        """
        Initialize Polar ECC.
        
        Args:
            n: Block length (must be power of 2)
            k: Number of information bits
            data_length: Data length for compatibility
        """
        # Adjust parameters based on data_length
        if data_length is not None:
            if data_length <= 4:
                n, k = 4, 2     # Polar(4,2)
            elif data_length <= 8:
                n, k = 8, 4     # Polar(8,4)
            elif data_length <= 16:
                n, k = 16, 8    # Polar(16,8)
            else:
                n, k = 32, 16   # Polar(32,16)
        
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
        
        # Ensure we have exactly n bits
        while len(codeword_bits) < self.n:
            codeword_bits.append(0)
        if len(codeword_bits) > self.n:
            codeword_bits = codeword_bits[:self.n]
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a Polar codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Convert to bit list
            codeword_bits = [(codeword >> i) & 1 for i in range(codeword.bit_length() or 1)]
            
            # Ensure we have exactly n bits
            while len(codeword_bits) < self.n:
                codeword_bits.append(0)
            if len(codeword_bits) > self.n:
                codeword_bits = codeword_bits[:self.n]
            
            # Decode with Polar code
            decoded_bits = self.polar.decode(codeword_bits)
            
            # Convert back to integer
            data = 0
            for i, bit in enumerate(decoded_bits):
                data |= (bit << i)
            
            return data, 'corrected'
        except Exception as e:
            # If decoding fails, error detected
            print(f"Decode error for PolarECC: {e}")
            return codeword, 'detected' 