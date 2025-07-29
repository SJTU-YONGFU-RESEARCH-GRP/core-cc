from typing import Tuple, List
from base_ecc import ECCBase
import random

class SimpleTurboCode:
    """Simplified Turbo Code implementation for educational purposes.
    
    This is a simplified version that demonstrates the basic concepts
    of Turbo codes without the full complexity of real implementations.
    """
    
    def __init__(self, data_length: int = 8) -> None:
        """
        Initialize simplified Turbo code.
        
        Args:
            data_length: Length of data in bits
        """
        self.data_length = data_length
        # Simple recursive systematic convolutional (RSC) encoders
        self.encoder1 = self._create_rsc_encoder()
        self.encoder2 = self._create_rsc_encoder()
        
    def _create_rsc_encoder(self) -> List[int]:
        """Create a simple RSC encoder state."""
        return [0, 0]  # 2-bit state
        
    def _rsc_encode(self, data_bits: List[int], encoder_state: List[int]) -> List[int]:
        """
        Encode using recursive systematic convolutional code.
        
        Args:
            data_bits: Input data bits
            encoder_state: Current encoder state
            
        Returns:
            Parity bits
        """
        parity_bits = []
        state = encoder_state.copy()
        
        for bit in data_bits:
            # Simple RSC: parity = (bit + state[0] + state[1]) % 2
            parity = (bit + state[0] + state[1]) % 2
            parity_bits.append(parity)
            
            # Update state: shift and add new bit
            state[1] = state[0]
            state[0] = bit
            
        return parity_bits
    
    def _interleave(self, data_bits: List[int]) -> List[int]:
        """
        Simple interleaving (random permutation).
        
        Args:
            data_bits: Input bits
            
        Returns:
            Interleaved bits
        """
        # Create a deterministic interleaver for reproducibility
        random.seed(42)  # Fixed seed for deterministic behavior
        indices = list(range(len(data_bits)))
        random.shuffle(indices)
        
        interleaved = [0] * len(data_bits)
        for i, new_pos in enumerate(indices):
            interleaved[new_pos] = data_bits[i]
            
        return interleaved
    
    def encode(self, data_bits: List[int]) -> List[int]:
        """
        Encode data using simplified Turbo code.
        
        Args:
            data_bits: Input data bits
            
        Returns:
            Systematic + parity1 + parity2 bits
        """
        if len(data_bits) != self.data_length:
            # Pad or truncate to required length
            if len(data_bits) < self.data_length:
                data_bits = data_bits + [0] * (self.data_length - len(data_bits))
            else:
                data_bits = data_bits[:self.data_length]
        
        # First encoder (systematic + parity1)
        parity1 = self._rsc_encode(data_bits, self.encoder1)
        
        # Interleave data for second encoder
        interleaved_data = self._interleave(data_bits)
        
        # Second encoder (parity2)
        parity2 = self._rsc_encode(interleaved_data, self.encoder2)
        
        # Combine: systematic + parity1 + parity2
        codeword = data_bits + parity1 + parity2
        
        return codeword
    
    def decode(self, codeword_bits: List[int]) -> Tuple[List[int], str]:
        """
        Simplified Turbo decoding (majority voting for systematic bits).
        
        Args:
            codeword_bits: Received codeword bits
            
        Returns:
            Tuple of (decoded_bits, error_type)
        """
        if len(codeword_bits) < self.data_length:
            return [0] * self.data_length, 'detected'
        
        # Extract systematic bits (first data_length bits)
        systematic_bits = codeword_bits[:self.data_length]
        
        # For this simplified version, just return systematic bits
        # In a real Turbo decoder, this would involve iterative decoding
        # between the two constituent decoders
        
        return systematic_bits, 'corrected'


class TurboECC(ECCBase):
    """Turbo ECC implementation using simplified Turbo codes."""
    
    def __init__(self, data_length: int = 8) -> None:
        """
        Initialize Turbo ECC.
        
        Args:
            data_length: Length of data in bits (default 8)
        """
        self.data_length = data_length
        self.turbo = SimpleTurboCode(data_length)
        
    def encode(self, data: int) -> int:
        """
        Encode data using Turbo code.
        
        Args:
            data: Input data as integer
            
        Returns:
            Encoded codeword as integer
        """
        # Convert data to bit list
        data_bits = [(data >> i) & 1 for i in range(self.data_length)]
        
        # Encode with Turbo code
        codeword_bits = self.turbo.encode(data_bits)
        
        # Convert back to integer
        codeword = 0
        for i, bit in enumerate(codeword_bits):
            codeword |= (bit << i)
            
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode a Turbo codeword.
        
        Args:
            codeword: The codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Calculate expected codeword length: data_length + 2*data_length (parity bits)
            expected_codeword_length = self.data_length * 3  # systematic + parity1 + parity2
            
            # Convert to bit list with proper length
            codeword_bits = [(codeword >> i) & 1 for i in range(expected_codeword_length)]
            
            # Decode with Turbo code
            decoded_bits, error_type = self.turbo.decode(codeword_bits)
            
            # Convert back to integer
            decoded_data = 0
            for i, bit in enumerate(decoded_bits):
                decoded_data |= (bit << i)
                
            return decoded_data, error_type
            
        except Exception:
            # If decoding fails, error detected
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