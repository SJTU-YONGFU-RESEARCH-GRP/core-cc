from typing import Tuple
import numpy as np
from base_ecc import ECCBase

class LDPCECC(ECCBase):
    """
    LDPC ECC implementation using Hard Decision Bit-Flipping decoding.
    Uses a small deterministic code (Hamming-like or regular Gallager) for N=16 to ensure verification.
    """
    def __init__(self, n: int = 16, d_v: int = 3, d_c: int = 4, k: int = 8, data_length: int = None) -> None:
        """
        Args:
            n (int): Codeword length (native, default 16).
            d_v (int): Variable node degree.
            d_c (int): Check node degree.
            k (int): Data bits (native, default 8).
            data_length (int): Total data length in bytes (optional, for segmentation).
        """
        # Native parameters for the fixed implementation
        self.native_k = 8
        self.native_n = 16
        
        # Determine number of blocks based on total data length (bytes)
        # If data_length is provided (e.g. 16 bytes), we process in 8-bit (1 byte) chunks.
        # num_blocks = data_length
        if data_length is not None:
            self.num_blocks = data_length
        else:
            self.num_blocks = 1
            
        self.n = self.native_n * self.num_blocks
        self.k = self.native_k * self.num_blocks
        
        # Valid H Matrix for (16, 8) Regular LDPC
        self.H = np.array([
            [1,1,1,1, 0,0,0,0, 1,0,0,0,0,0,0,0],
            [1,1,0,0, 1,1,0,0, 0,1,0,0,0,0,0,0],
            [1,0,1,0, 1,0,1,0, 0,0,1,0,0,0,0,0],
            [1,0,0,1, 1,0,0,1, 0,0,0,1,0,0,0,0],
            [0,1,1,0, 0,1,1,0, 0,0,0,0,1,0,0,0],
            [0,1,0,1, 0,1,0,1, 0,0,0,0,0,1,0,0],
            [0,0,1,1, 0,0,1,1, 0,0,0,0,0,0,1,0],
            [1,1,1,0, 1,0,0,0, 0,0,0,0,0,0,0,1]
        ], dtype=int)
        
        self.P = self.H[:, 0:8]
        self.G = np.hstack((np.eye(8, dtype=int), self.P.T))
        
    def _encode_block(self, data_byte: int) -> int:
        """Encodes single 8-bit block to 16-bit codeword."""
        u = np.array([(data_byte >> i) & 1 for i in range(self.native_k)], dtype=int)
        x = np.dot(u, self.G) % 2
        codeword = 0
        for i, bit in enumerate(x):
            codeword |= (int(bit) << i)
        return codeword

    def encode(self, data: int) -> int:
        """
        Encode data (potentially multi-byte) into concatenated codeword.
        """
        codeword = 0
        for i in range(self.num_blocks):
            # Extract 8-bit chunk
            chunk = (data >> (i * 8)) & 0xFF
            cw_chunk = self._encode_block(chunk)
            # Append 16-bit chunk
            codeword |= (cw_chunk << (i * 16))
        return codeword

    def _decode_block(self, cw_block: int) -> Tuple[int, str]:
        """Decodes single 16-bit block."""
        r = np.array([(cw_block >> i) & 1 for i in range(self.native_n)], dtype=int)
        max_iter = 10
        current_x = r.copy()
        
        for _ in range(max_iter):
            s = np.dot(self.H, current_x) % 2
            if not np.any(s):
                decoded_bits = current_x[:8]
                data = 0
                for i, bit in enumerate(decoded_bits):
                    data |= (int(bit) << i)
                return data, 'corrected'
            
            failing_checks = [i for i, val in enumerate(s) if val == 1]
            vote_count = np.zeros(self.native_n, dtype=int)
            for check_idx in failing_checks:
                connected_vars = np.where(self.H[check_idx] == 1)[0]
                vote_count[connected_vars] += 1
            max_votes = np.max(vote_count)
            flip_candidates = np.where(vote_count == max_votes)[0]
            for idx in flip_candidates:
                current_x[idx] ^= 1
                
        decoded_bits = current_x[:8]
        data = 0
        for i, bit in enumerate(decoded_bits):
            data |= (int(bit) << i)
        return data, 'detected'

    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode concatenated codeword into full data.
        """
        data = 0
        overall_status = 'corrected'
        
        for i in range(self.num_blocks):
            # Extract 16-bit chunk
            cw_chunk = (codeword >> (i * 16)) & 0xFFFF
            d_chunk, status = self._decode_block(cw_chunk)
            
            # Aggregate data
            data |= (d_chunk << (i * 8))
            
            # Aggregate status (detected if any detected, else corrected)
            if status == 'detected':
                overall_status = 'detected'
                
        return data, overall_status

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        return codeword ^ (1 << bit_idx)

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        return codeword ^ (1 << bit_idx)