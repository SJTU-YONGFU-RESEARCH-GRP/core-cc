from typing import Tuple
import numpy as np
from base_ecc import ECCBase

class LDPCECC(ECCBase):
    """
    LDPC ECC implementation using Hard Decision Bit-Flipping decoding.
    Generates regular (3,6) H matrices for arbitrary widths derived from a random construction.
    """
    def __init__(self, data_length: int = 8, n: int = None, k: int = None) -> None:
        """
        Args:
            data_length (int): Data bits (k).
            n (int): Codeword length. If None, defaults to 2*k (Rate 1/2).
            k (int): Optional override for data bits.
        """
        # Determine k
        if k is not None:
            self.k = k
        else:
            self.k = data_length
            
        # Determine n (Rate 1/2 default)
        if n is None:
            self.n = self.k * 2
        else:
            self.n = n
            
        # Target column weight (dv) and row weight (dc) for Regular LDPC
        self.d_v = 3
        # dc = dv * (n / m) where m = n - k
        # For Rate 1/2, m = k = n/2. So n/m = 2. dc = 3 * 2 = 6.
        self.d_c = 6
        
        # Build H and G matrices
        self.H, self.G = self._build_matrices(self.n, self.k)
        
    def _build_matrices(self, n, k):
        """Builds H and G matrices using robust Dual-Diagonal construction."""
        # Dual-Diagonal construction guarantees invertibility of the parity submatrix.
        # H = [H_d | H_p]
        # H_d: Random sparse matrix (m x k)
        # H_p: Dual-diagonal matrix (m x m)
        
        m = n - k
        
        # 1. Generate H_d (Data part)
        # Randomly fill columns with weight dv=3
        H_d = np.zeros((m, k), dtype=int)
        for j in range(k):
            # Pick 3 random rows for this column
            rows = np.random.choice(m, min(3, m), replace=False)
            H_d[rows, j] = 1
            
        # 2. Generate H_p (Parity part) - Dual Diagonal
        # [1 0 0 ... ]
        # [1 1 0 ... ]
        # [0 1 1 ... ]
        H_p = np.zeros((m, m), dtype=int)
        np.fill_diagonal(H_p, 1) # Main diagonal
        np.fill_diagonal(H_p[1:], 1) # Sub-diagonal
        
        # 3. Concatenate H = [H_d | H_p]
        H = np.hstack((H_d, H_p))
        
        # 4. Convert to Systematic G
        # Since H_p is lower triangular with diagonal 1s, it is full rank.
        # Gaussian elimination will absolutely succeed (no fallback needed).
        H_syst, P, success = self._gaussian_elimination_systematic(H)
        
        if success:
            I_k = np.eye(k, dtype=int)
            G = np.hstack((I_k, P.T))
            return H_syst, G
        else:
            # Should theoretically never happen with Dual-Diagonal
            print(f"Critical Error: LDPC Dual-Diagonal generation failed for n={n}, k={k}.")
            # Fallback
            return np.zeros((m, n), dtype=int), np.hstack((np.eye(k, dtype=int), np.zeros((k, m), dtype=int)))

    def _generate_random_H(self, n, m, dv, dc):
        # Deprecated by robust construction above
        pass
        
    def _gaussian_elimination_systematic(self, H_in):
        """
        Converts H to [P | I] form.
        Returns H_syst, P, success.
        H is (m, n). We want last m columns to be I.
        """
        H = H_in.copy()
        m, n = H.shape
        k = n - m
        
        # We focus on the rightmost m columns (indices k to n-1)
        # We want this block to become Identity.
        
        col_order = np.arange(n)
        
        # Gaussian elimination on the right block
        pivot_row = 0
        for j in range(k, n):
            # Find a row with 1 in this column (at or below pivot_row)
            rows_with_one = np.where(H[pivot_row:, j] == 1)[0]
            if len(rows_with_one) == 0:
                # Singular submatrix
                return None, None, False
            
            target_row = rows_with_one[0] + pivot_row
            
            # Swap rows
            if target_row != pivot_row:
                H[[pivot_row, target_row]] = H[[target_row, pivot_row]]
                
            # Eliminate other rows
            for r in range(m):
                if r != pivot_row and H[r, j] == 1:
                    H[r] ^= H[pivot_row]
            
            pivot_row += 1
            
        # Now the right block is I (maybe permuted? No, we processed cols in order).
        # H is [P | I].
        # Extract P (first k columns)
        P = H[:, :k]
        return H, P, True

    def encode(self, data: int) -> int:
        """Encode data into LDPC codeword."""
        # Convert data to bit array
        u = np.array([(data >> i) & 1 for i in range(self.k)], dtype=int)
        
        # G is (k, n)
        # x = u * G
        x = np.dot(u, self.G) % 2
        
        codeword = 0
        for i, bit in enumerate(x):
            codeword |= (int(bit) << i)
        return codeword

    def decode(self, codeword: int) -> Tuple[int, str]:
        """Decode LDPC codeword using Bit-Flipping."""
        # Extract bits
        r = np.array([(codeword >> i) & 1 for i in range(self.n)], dtype=int)
        
        max_iter = 20 # Increased for larger codes
        current_x = r.copy()
        
        for _ in range(max_iter):
            # Calculate syndrome s = H * x.T
            s = np.dot(self.H, current_x) % 2
            
            if not np.any(s):
                # Valid codeword found. Extract data.
                # Since H is systematic [P | I], and G is [I | P.T],
                # The first k bits of a valid codeword are the message bits?
                # G = [I | P.T]. u * G = [u * I | u * P.T] = [u | parity].
                # Yes, first k bits are systematic data bits.
                decoded_bits = current_x[:self.k]
                data = 0
                for i, bit in enumerate(decoded_bits):
                    data |= (int(bit) << i)
                return data, 'corrected'
            
            # Identify bits involved in unsatisfied checks
            # Simple Bit Flipping: Flip bit involved in MOST unsatisfied checks
            
            # Vote count: for each variable node, how many unsatisfied checks is it connected to?
            unsatisfied_checks = np.where(s == 1)[0]
            
            # Sum rows of H corresponding to unsatisfied checks
            # broadcast over unsatisfied rows
            vote_count = np.sum(self.H[unsatisfied_checks], axis=0)
            
            max_votes = np.max(vote_count)
            # Threshold? Standard BF matches max votes.
            
            if max_votes == 0:
                # Should not happen if syndrome is non-zero
                break
                
            # Flip candidates
            flip_candidates = np.where(vote_count == max_votes)[0]
            
            # Simple BF: flip one? or all? 
            # Flipping all might oscillate. Flipping one is safer.
            current_x[flip_candidates[0]] ^= 1
            
        # Failed to converge
        # Return naive systematic bits
        decoded_bits = r[:self.k]
        data = 0
        for i, bit in enumerate(decoded_bits):
            data |= (int(bit) << i)
        return data, 'detected'

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        return codeword ^ (1 << bit_idx)