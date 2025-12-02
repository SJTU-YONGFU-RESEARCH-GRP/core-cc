from typing import List, Tuple
from base_ecc import ECCBase

class ConvolutionalCode:
    """Simple (2,1,2) Convolutional Code ECC implementation.

    Uses a rate 1/2, constraint length 2 code with generator polynomials (3, 2) in octal.
    """
    def __init__(self) -> None:
        self.g1 = 0b11  # Generator 1: 3 (octal)
        self.g2 = 0b10  # Generator 2: 2 (octal)
        self.K = 2      # Constraint length

    def encode(self, bits: List[int]) -> List[int]:
        """Encodes a list of bits using the convolutional code.

        Args:
            bits: List of 0/1 bits.
        Returns:
            Encoded list of bits (rate 1/2).
        """
        state = 0
        out = []
        for bit in bits:
            state = ((state << 1) | bit) & ((1 << self.K) - 1)
            o1 = self._parity(state & self.g1)
            o2 = self._parity(state & self.g2)
            out.extend([o1, o2])
        return out

    def _parity(self, x: int) -> int:
        return bin(x).count('1') % 2

    def viterbi_decode(self, codeword: List[int]) -> List[int]:
        """Decodes a codeword using Viterbi algorithm.

        Args:
            codeword: Encoded list of bits (length must be even).
        Returns:
            Decoded list of bits.
        """
        if len(codeword) % 2 != 0:
            raise ValueError("Codeword length must be even.")
        n = len(codeword) // 2
        
        # Viterbi algorithm implementation
        num_states = 1 << self.K
        trellis = [[float('inf')] * num_states for _ in range(n + 1)]
        backpointer = [[0] * num_states for _ in range(n + 1)]
        
        # Initialize start state
        trellis[0][0] = 0
        
        # Forward pass
        for t in range(n):
            for state in range(num_states):
                if trellis[t][state] == float('inf'):
                    continue
                
                # Try both possible input bits
                for input_bit in [0, 1]:
                    # Calculate next state
                    next_state = ((state << 1) | input_bit) & ((1 << self.K) - 1)
                    
                    # Calculate expected output
                    o1 = self._parity(next_state & self.g1)
                    o2 = self._parity(next_state & self.g2)
                    expected_output = [o1, o2]
                    
                    # Calculate received output
                    received_output = codeword[2*t:2*t+2]
                    
                    # Calculate branch metric (Hamming distance)
                    branch_metric = sum(1 for a, b in zip(expected_output, received_output) if a != b)
                    
                    # Update trellis
                    new_cost = trellis[t][state] + branch_metric
                    if new_cost < trellis[t + 1][next_state]:
                        trellis[t + 1][next_state] = new_cost
                        backpointer[t + 1][next_state] = state
        
        # Backward pass to find best path
        # Prefer state 0 if costs are equal, or just pick min
        best_state = min(range(num_states), key=lambda s: trellis[n][s])
        decoded_bits = []
        
        for t in range(n, 0, -1):
            prev_state = backpointer[t][best_state]
            # Extract input bit from state transition
            # State is ((prev_state << 1) | input_bit) & mask
            # So input_bit is the LSB of best_state
            input_bit = best_state & 1
            decoded_bits.append(input_bit)
            best_state = prev_state
        
        # Reverse to get correct order
        return decoded_bits[::-1]

class ConvolutionalECC(ECCBase):
    """Convolutional ECC implementation."""
    
    def __init__(self, data_length: int = 8):
        """
        Initialize Convolutional ECC.
        
        Args:
            data_length: Data length in bits
        """
        self.data_length = data_length
        self.conv = ConvolutionalCode()
    
    def encode(self, data: int) -> int:
        """
        Encode data with convolutional code.
        
        Args:
            data: Input data
            
        Returns:
            Codeword
        """
        # Convert data to bit list with proper length
        data_bits = [(data >> i) & 1 for i in range(self.data_length)]
        
        # Add tail bits to flush encoder to state 0 (K=2, so 2 bits)
        data_bits.extend([0, 0])
        
        # Encode with convolutional code
        codeword_bits = self.conv.encode(data_bits)
        
        # Ensure even length
        if len(codeword_bits) % 2 != 0:
            codeword_bits.append(0)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a convolutional codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Calculate expected codeword length: (data_length + 2) * 2
            expected_codeword_length = (self.data_length + 2) * 2
            
            # Convert to bit list with proper length
            codeword_bits = [(codeword >> i) & 1 for i in range(expected_codeword_length)]
            
            # Decode with convolutional code
            decoded_bits = self.conv.viterbi_decode(codeword_bits)
            
            # Remove tail bits
            if len(decoded_bits) >= 2:
                decoded_bits = decoded_bits[:-2]
            
            # Convert back to integer
            decoded_data = 0
            for i, bit in enumerate(decoded_bits):
                decoded_data |= (bit << i)
                
            return decoded_data, 'corrected'
            
        except Exception:
            # If decoding fails, error detected
            return codeword, 'detected' 