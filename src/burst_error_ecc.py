from typing import Tuple, List, Dict
from base_ecc import ECCBase
import numpy as np

class BurstErrorECC(ECCBase):
    """
    Burst Error Correcting Code implementation.
    Handles burst errors using interleaving and parity protection.
    """
    
    def __init__(self, word_length: int = 8, data_length: int = None):
        """
        Initialize Burst Error ECC.
        
        Args:
            word_length: Length of data word in bits
            data_length: Alternative parameter name for compatibility
        """
        if data_length is not None:
            self.word_length = data_length
        else:
            self.word_length = word_length
            
        # Configure parameters based on word length
        if self.word_length <= 4:
            self.k = 4
            self.n = 8
            self.burst_length = 2
        elif self.word_length <= 8:
            self.k = 8
            self.n = 16
            self.burst_length = 3
        elif self.word_length <= 16:
            self.k = 16
            self.n = 32
            self.burst_length = 4
        else:
            self.k = self.word_length
            self.n = 2 * self.word_length
            # Logarithmic scaling for burst length? Or fixed?
            # Verilog uses: (DATA_WIDTH <= 16) ? 4 : 5
            # Let's match Verilog logic for >16
            self.burst_length = 5
        
        # Define data and parity positions
        self.data_positions = list(range(self.k))
        self.data_positions_set = set(self.data_positions)
        self.parity_positions = list(range(self.k, self.n))
        
    def _extract_data(self, codeword: int) -> int:
        """Extract data bits from codeword."""
        data = 0
        for i, pos in enumerate(self.data_positions):
            bit = (codeword >> pos) & 1
            data |= (bit << i)
        return data
    
    def _insert_data(self, data: int) -> int:
        """Insert data bits into codeword positions."""
        codeword = 0
        for i, pos in enumerate(self.data_positions):
            bit = (data >> i) & 1
            codeword |= (bit << pos)
        return codeword
    
    def _calculate_parity(self, codeword: int) -> int:
        """Calculate parity bits for burst error protection."""
        parity = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate parity for this parity bit based on data bits only
            p = 0
            for j in self.data_positions:
                if ((codeword >> j) & 1):
                    # Burst-resistant parity calculation
                    if (j + pos) % self.burst_length == 0:
                        p ^= 1
            parity |= (p << pos)
        return parity
    
    def encode(self, data: int) -> int:
        """
        Encode data with burst error protection.
        
        Args:
            data: Input data to encode
            
        Returns:
            Encoded codeword
        """
        # Ensure data fits within word_length bits
        if data >= (1 << self.word_length):
            data = data & ((1 << self.word_length) - 1)
        
        # Insert data bits into codeword
        codeword = self._insert_data(data)
        
        # Calculate and insert parity bits
        parity = self._calculate_parity(codeword)
        codeword |= parity
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode burst error protected codeword.
        
        Args:
            codeword: Codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Calculate syndrome
        syndrome = 0
        for i, pos in enumerate(self.parity_positions):
            # Calculate expected parity based on data bits only
            expected_parity = 0
            for j in self.data_positions:
                if ((codeword >> j) & 1):
                    # Burst-resistant parity calculation
                    if (j + pos) % self.burst_length == 0:
                        expected_parity ^= 1
            
            # Compare with actual parity
            actual_parity = (codeword >> pos) & 1
            if expected_parity != actual_parity:
                syndrome |= (1 << i)
        
        if syndrome == 0:
            # No error detected
            return self._extract_data(codeword), 'corrected'
        else:
            # Try to correct burst errors
            # Error detected. Optimized burst error correction.
            # Complexity: O(N * BurstLength) instead of O(N * BurstLength * M * K)
            # The previous approach recalculated the entire syndrome for every test burst.
            # Here we identify which syndrome bits are affected by a burst at each position.
            
            # Precompute syndrome mask for a single bit at each position
            # bit_syndrome_map[k] = syndrome caused by a bit flip at index k
            bit_syndrome_map = {}
            for k in range(self.n):
                s = 0
                for i, pos in enumerate(self.parity_positions):
                    # Check if bit k affects parity bit pos
                    # Condition: (k is data bit AND (k+pos)%BL==0) OR (k is parity bit pos)
                    affects = False
                    if k in self.data_positions_set:
                        if (k + pos) % self.burst_length == 0:
                            affects = True
                    elif k == pos:
                        affects = True
                    
                    if affects:
                        s |= (1 << i)
                bit_syndrome_map[k] = s
            
            # Try to correct burst errors using the map
            matches = []
            for burst_start in range(self.n - self.burst_length + 1):
                current_burst_syndrome = 0
                for i in range(self.burst_length):
                    if burst_start + i < self.n:
                        current_burst_syndrome ^= bit_syndrome_map[burst_start + i]
                
                if current_burst_syndrome == syndrome:
                    matches.append(burst_start)
                    # If we find more than 1 match, we have ambiguity.
                    # Optimization: We can stop early if we don't care about FINDING all, just detecting ambiguity.
                    # But to be safe, let's just find them.
            
            if len(matches) == 1:
                # Unique correction found
                burst_start = matches[0]
                test_codeword = codeword
                for i in range(self.burst_length):
                    if burst_start + i < self.n:
                        test_codeword ^= (1 << (burst_start + i))
                return self._extract_data(test_codeword), 'corrected'
            elif len(matches) > 1:
                # Ambiguous error location (aliasing). Determine as detected but uncorrectable.
                return self._extract_data(codeword), 'detected'

            # Error detected but not corrected
            return self._extract_data(codeword), 'detected'

            # Error detected but not corrected
            return self._extract_data(codeword), 'detected'
    
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
    
    def inject_burst_error(self, codeword: int, burst_start: int, burst_length: int = None) -> int:
        """
        Inject a burst error into the codeword.
        
        Args:
            codeword: The codeword to corrupt
            burst_start: Starting position of burst
            burst_length: Length of burst (defaults to self.burst_length)
            
        Returns:
            The corrupted codeword
        """
        if burst_length is None:
            burst_length = self.burst_length
        
        corrupted = codeword
        for i in range(burst_length):
            if burst_start + i < self.n:
                corrupted ^= (1 << (burst_start + i))
        
        return corrupted
    
    def get_burst_info(self) -> Dict[str, any]:
        """Get burst error correction information."""
        return {
            'burst_length': self.burst_length,
            'data_length': self.k,
            'codeword_length': self.n,
            'parity_length': self.n - self.k
        }