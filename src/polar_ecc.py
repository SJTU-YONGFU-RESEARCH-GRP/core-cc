
from typing import List, Tuple
from base_ecc import ECCBase
import math

class PolarCodeRecursive:
    """
    Polar Code with Recursive Encoding and SC Decoding.
    """
    def __init__(self, N: int, K: int):
        self.N = N
        self.K = K
        self.n = int(math.log2(N))
        
        # Frozen Bit Construction based on reliability
        # Simple heuristic: bit-reversed indices have higher reliability in SC decoding order?
        # Actually, standard Bhattacharyya bounds or Gaussian Approximation is better.
        # For simplicity and hardware alignment, let's use a fixed reliability sequence 
        # based on 5G or similar standard sequences if possible, or population count.
        
        indices = list(range(N))
        # Sort by population count (Hamming weight) as a simple reliability proxy
        self.channel_reliability = sorted([(i, bin(i).count('1'), i) for i in indices], key=lambda x: (x[1], x[2]))
        
        # Info indices (Best K)
        self.info_indices = set([x[0] for x in self.channel_reliability[-K:]])
        self.frozen_indices = set([x[0] for x in self.channel_reliability[:-K]])

    def encode(self, u_data: int) -> int:
        """
        Encode K-bit integer into N-bit codeword.
        """
        # 1. Map Data to U vector
        u_vec = [0] * self.N
        info_count = 0
        for i in range(self.N):
            if i in self.info_indices:
                bit = (u_data >> info_count) & 1
                u_vec[i] = bit
                info_count += 1
            else:
                u_vec[i] = 0
                
        # 2. Polar Transform: x = u * G_N
        # Recursive implementation
        x = self._polar_transform_recursive(u_vec)
        
        # Convert to int
        codeword = 0
        for i, val in enumerate(x):
            if val: codeword |= (1 << i)
        return codeword

    def _polar_transform_recursive(self, u: List[int]) -> List[int]:
        n = len(u)
        if n == 1:
            return u
        
        half = n // 2
        u_top = u[:half]
        u_bot = u[half:]
        
        # Recursive calls
        x_top = self._polar_transform_recursive(u_top)
        x_bot = self._polar_transform_recursive(u_bot)
        
        # Combine
        x = [0] * n
        for i in range(half):
            x[i] = (x_top[i] + x_bot[i]) % 2
            x[i + half] = x_bot[i]
            
        return x

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        SC Decode.
        """
        # Initialize LLRs
        # 0 -> +4.0 (strong 0), 1 -> -4.0 (strong 1)
        llrs = [0.0] * self.N
        for i in range(self.N):
            bit = (codeword >> i) & 1
            if bit == 0: llrs[i] = 4.0
            else: llrs[i] = -4.0
            
        # Recursive SC Decoding
        decoded_u = self._sc_decode_recursive(llrs)
        
        # Extract data
        data = 0
        info_count = 0
        for i in range(self.N):
            if i in self.info_indices:
                if decoded_u[i]: data |= (1 << info_count)
                info_count += 1
                
        return data, "corrected"

    def _sc_decode_recursive(self, llrs: List[float]) -> List[int]:
        n = len(llrs)
        if n == 1:
            # Leaf node: This logic only happens if N=1, which is base case.
            # But SC decoding visits bits one by one.
            # We need to know if this bit is frozen or information.
            # This simple recursive structure doesn't track global index easily without passing it.
            # Let's switch to an implementation that tracks global indices.
            raise NotImplementedError("Use _sc_decode_recursive_indexed instead")

        return self._sc_decode_recursive_indexed(llrs, 0)

    def _sc_decode_recursive_indexed(self, llrs: List[float], base_idx: int) -> List[int]:
        n = len(llrs)
        if n == 1:
            # Decision
            if base_idx in self.frozen_indices:
                return [0]
            else:
                if llrs[0] >= 0: return [0]
                else: return [1]
        
        half = n // 2
        
        # 1. Compute Left (Top) LLRs: f(LLR_top, LLR_bot)
        # f(a, b) = sign(a)*sign(b)*min(|a|, |b|)
        llrs_top = []
        for i in range(half):
            a = llrs[i]
            b = llrs[i + half]
            # Min-sum approximation
            val = (1 if a < 0 else 0) ^ (1 if b < 0 else 0)
            mag = min(abs(a), abs(b))
            llrs_top.append(-mag if val else mag)
            
        # 2. Decode Left half
        u_top = self._sc_decode_recursive_indexed(llrs_top, base_idx)
        
        # Re-encode u_top to get partial sums (x_top) for cancellation
        # The g function requires the encoded bits, not the raw info bits
        x_top = self._polar_transform_recursive(u_top)
        
        # 3. Compute Right (Bot) LLRs: g(LLR_top, LLR_bot, x_top)
        # g(a, b, u) = b + (1-2u)a = b + a if u=0 else b - a
        llrs_bot = []
        for i in range(half):
            a = llrs[i]
            b = llrs[i + half]
            u = x_top[i]
            if u == 0:
                llrs_bot.append(b + a)
            else:
                llrs_bot.append(b - a)
                
        # 4. Decode Right half
        u_bot = self._sc_decode_recursive_indexed(llrs_bot, base_idx + half)
        
        # 5. Combine u (partial sums)
        # u_final = [u_top + u_bot, u_bot] ? No.
        # u vector is just concatenation of decisions ? Yes, u_top and u_bot are the decisions u_0..u_N-1.
        # But wait, the standard Polar transform combines them: x = [u_top+u_bot, u_bot].
        # The decoder returns u itself (the decisions).
        # Yes, we just concatenate.
        
        return u_top + u_bot

class PolarECC(ECCBase):
    def __init__(self, n: int = None, k: int = None, data_length: int = None):
        if data_length is not None:
            self.k_width = data_length
        else:
            self.k_width = k if k else 8
            
        self.N_width = 2 * self.k_width # Rate 1/2 (Simplification)
        
        # Ensure N is power of 2
        p = 1
        while p < self.N_width:
            p *= 2
        self.N_width = p
        
        self.polar = PolarCodeRecursive(self.N_width, self.k_width)
        
        # Expose standard params
        self.n = self.N_width
        self.k = self.k_width
        
    def encode(self, data: int) -> int:
        return self.polar.encode(data)
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        return self.polar.decode(codeword)
        
    def inject_error(self, codeword: int, bit_idx: int) -> int:
        return codeword ^ (1 << bit_idx)
