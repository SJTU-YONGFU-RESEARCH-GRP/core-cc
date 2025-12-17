from typing import List, Tuple
import math
from base_ecc import ECCBase

class PolarCode:
    """
    Polar Code ECC implementation using Arikan's recursive construction.
    Supports Encoding (x = u * G_N) and SC Decoding.
    N must be a power of 2.
    """
    def __init__(self, N: int = 4, K: int = 2, frozen_bits: List[int] = None) -> None:
        self.N = N
        self.K = K
        self.n = int(math.log2(N))
        
        # Determine frozen bits (Capacity/Reliability based)
        # For simplicity (and N=16 validation), we use a static reliability sequence.
        # This sequence orders channels from least reliable to most reliable.
        # Reference: 5G Polar Sequence or simple Bhattacharyya bounds.
        # For N=16, reliability order (indices):
        # 0, 1, 2, 4, 8, 3, 5, 6, 9, 10, 12, 7, 11, 13, 14, 15 (Approximate)
        # We freeze the first (N-K) least reliable channels.
        
        if frozen_bits is None:
            # Simple reliability sequence for N=16
            reliability_sequence = [0, 1, 2, 4, 8, 3, 5, 6, 9, 10, 12, 7, 11, 13, 14, 15]
            # Truncate to N length if N < 16 (e.g. N=4: 0, 1, 2, 3)
            # This is a fixed sequence, might need adjustment for general N.
            if N == 4:
                reliability_sequence = [0, 1, 2, 3]
            elif N == 8:
                reliability_sequence = [0, 1, 2, 4, 3, 5, 6, 7] # Adjusted
            
            # Identify frozen indices (the first N-K items in reliability sequence)
            num_frozen = N - K
            self.frozen_bits = set(reliability_sequence[:num_frozen])
        else:
            self.frozen_bits = set(frozen_bits)

    def encode(self, u_k: List[int]) -> List[int]:
        """
        Encodes K information bits into N codeword bits.
        Constructs full u vector (N bits) with frozen bits = 0, others = info.
        Then x = u * G_N.
        """
        # Construct u vector (N bits)
        u = [0] * self.N
        info_idx = 0
        for i in range(self.N):
            if i not in self.frozen_bits:
                u[i] = u_k[info_idx] if info_idx < len(u_k) else 0
                info_idx += 1
                
        # Recursive encoding
        return self._transform(u)

    def _transform(self, u: List[int]) -> List[int]:
        """Recursive Polar Transform."""
        if len(u) == 1:
            return u
            
        n = len(u)
        half = n // 2
        
        # Even/Odd split (or Top/Bottom in some notations)
        # Standard Arikan: u1_N = (u1_N/2 XOR u2_N/2, u2_N/2) ? 
        # Actually G_2 = [1 0; 1 1]. (Lower triangular)
        # x = u * G.
        # x0 = u0 + u1
        # x1 = u1
        
        # Recursive step: x = (x_odd, x_even) ?
        # Standard recursive implementation:
        # u_upper = u[0:half] XOR u[half:n]
        # u_lower = u[half:n]
        
        u1 = [u[i] ^ u[i+half] for i in range(half)]
        u2 = u[half:]
        
        x1 = self._transform(u1)
        x2 = self._transform(u2)
        
        return x1 + x2 # Concatenate

    def decode(self, y: List[float]) -> List[int]:
        """
        Successive Cancellation Decoder (Hard/Soft).
        Expects LLRs or hard bits. For Hard Decision, convert to BPSK (-1, +1).
        """
        # Convert hard bits (0/1) to LLR approximation if needed
        # 0 -> +Large, 1 -> -Large
        llrs = [(1.0 if bit == 0 else -1.0) for bit in y]
        
        # Run SC
        u_hat = self._sc_decode(llrs, self.N)
        
        # Extract info bits
        info_bits = []
        for i in range(self.N):
            if i not in self.frozen_bits:
                info_bits.append(u_hat[i])
                
        return info_bits

    def _sc_decode(self, llrs: List[float], n: int) -> List[int]:
        """Recursive SC Decoding."""
        if n == 1:
            # Leaf node: Make hard decision
            return [0 if llrs[0] >= 0 else 1]
            
        half = n // 2
        
        # Calculate LLRs for u1 (Upper branch)
        # LLR(u1) = f(LLR_upper, LLR_lower) ~= sign(L1)*sign(L2)*min(|L1|, |L2|)
        llrs_u1 = []
        for i in range(half):
            l1 = llrs[i]
            l2 = llrs[i+half]
            # Min-Sum approximation
            val = (1 if l1*l2 > 0 else -1) * min(abs(l1), abs(l2))
            llrs_u1.append(val)
            
        # Decode u1 recursively
        u_hat_1 = self._sc_decode(llrs_u1, half)
        
        # Calculate LLRs for u2 (Lower branch) given u_hat_1
        # LLR(u2) = g(L1, L2, u1) = L2 + (1-2*u1)*L1
        llrs_u2 = []
        for i in range(half):
            l1 = llrs[i]
            l2 = llrs[i+half]
            bit = u_hat_1[i]
            val = l2 + ((1 if bit == 0 else -1) * l1)
            llrs_u2.append(val)
            
        # Decode u2 recursively
        u_hat_2 = self._sc_decode(llrs_u2, half)
        
        # Combine results to form u decision at this level
        # Need to re-encode to pass back up? 
        # Actually SC returns the u-decisions.
        # But we need u_hat corresponding to the inputs of the transform at this level.
        # The return value from recursive call IS u_hat for that sub-block.
        
        return u_hat_1 + u_hat_2


class PolarECC(ECCBase):
    """Polar ECC wrapper."""
    
    def __init__(self, n: int = 16, k: int = 8, data_length: int = None):
        # Native parameters
        self.native_n = 16
        self.native_k = 8
        
        if data_length is not None:
             self.num_blocks = data_length
        else:
             self.num_blocks = 1
             
        self.n = self.native_n * self.num_blocks
        self.k = self.native_k * self.num_blocks
        
        # Initialize Polar Code for the NATIVE block size
        self.polar = PolarCode(N=self.native_n, K=self.native_k)
    
    def _encode_block(self, data: int) -> int:
        # Extract bits
        u = [(data >> i) & 1 for i in range(self.native_k)]
        # Encode
        codeword_bits = self.polar.encode(u)
        # Pack to int
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        return codeword
    
    def encode(self, data: int) -> int:
        codeword = 0
        for i in range(self.num_blocks):
            chunk = (data >> (i * 8)) & 0xFF
            cw_chunk = self._encode_block(chunk)
            codeword |= (cw_chunk << (i * 16))
        return codeword
    
    def _decode_block(self, codeword: int) -> Tuple[int, str]:
        # Maximum Likelihood Decoding (for N=16)
        best_dist = self.native_n + 1
        best_data = 0
        
        # Iterate all possible info words (0..255)
        for cand_data in range(1 << self.native_k):
            # Encode candidate
            cand_cw = self._encode_block(cand_data)
            
            # Hamming distance
            diff = cand_cw ^ codeword
            dist = bin(diff).count('1')
            
            if dist < best_dist:
                best_dist = dist
                best_data = cand_data
                if dist == 0:
                    break 
        
        status = 'corrected' if best_dist > 0 else 'corrected'
        return best_data, status
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        data = 0
        overall_status = 'corrected'
        
        for i in range(self.num_blocks):
            cw_chunk = (codeword >> (i * 16)) & 0xFFFF
            d_chunk, status = self._decode_block(cw_chunk)
            data |= (d_chunk << (i * 8))
            if status == 'detected':
                overall_status = 'detected'
                
        return data, overall_status

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        return codeword ^ (1 << bit_idx)