from typing import Tuple, List, Dict
from base_ecc import ECCBase
import numpy as np

class ThreeDMemoryECC(ECCBase):
    """
    3D Memory ECC implementation for stacked memory architectures.
    Handles errors across multiple memory layers and dimensions.
    """
    
    def __init__(self, data_length: int = 8, layers: int = 4, bits_per_layer: int = 2):
        """
        Initialize 3D Memory ECC.
        
        Args:
            data_length: Length of data word in bits
            layers: Number of memory layers (default: 4)
            bits_per_layer: Bits per memory layer (default: 2)
        """
        self.data_length = data_length
        self.layers = layers
        self.bits_per_layer = bits_per_layer
        
        # Calculate 3D memory parameters
        self.total_bits = layers * bits_per_layer
        self.parity_bits = layers + bits_per_layer + 1  # Layer parity + bit parity + overall parity
        self.n = self.total_bits + self.parity_bits
        
        # Import base ECC for layer-level protection
        from hamming_secded_ecc import HammingSECDEDECC
        self.layer_ecc = HammingSECDEDECC(data_length=bits_per_layer)
    
    def _distribute_data_3d(self, data: int) -> List[List[int]]:
        """
        Distribute data across 3D memory layers.
        
        Args:
            data: Input data
            
        Returns:
            3D array of bits [layer][bit_position]
        """
        # Create 3D memory structure
        memory_3d = [[0 for _ in range(self.bits_per_layer)] for _ in range(self.layers)]
        
        # Distribute data bits across layers
        bit_pos = 0
        for layer in range(self.layers):
            for bit in range(self.bits_per_layer):
                if bit_pos < self.data_length:
                    memory_3d[layer][bit] = (data >> bit_pos) & 1
                    bit_pos += 1
        
        return memory_3d
    
    def _calculate_layer_parity(self, memory_3d: List[List[int]]) -> List[int]:
        """Calculate parity for each layer."""
        layer_parity = []
        for layer in range(self.layers):
            parity = sum(memory_3d[layer]) % 2
            layer_parity.append(parity)
        return layer_parity
    
    def _calculate_bit_parity(self, memory_3d: List[List[int]]) -> List[int]:
        """Calculate parity for each bit position across layers."""
        bit_parity = []
        for bit in range(self.bits_per_layer):
            parity = sum(memory_3d[layer][bit] for layer in range(self.layers)) % 2
            bit_parity.append(parity)
        return bit_parity
    
    def _calculate_overall_parity(self, memory_3d: List[List[int]]) -> int:
        """Calculate overall parity for the entire 3D memory."""
        total_ones = sum(sum(layer) for layer in memory_3d)
        return total_ones % 2
    
    def encode(self, data: int) -> int:
        """
        Encode data for 3D memory with multi-dimensional parity.
        
        Args:
            data: Input data to encode
            
        Returns:
            Encoded codeword with 3D parity
        """
        # Ensure data fits within data_length
        if data >= (1 << self.data_length):
            data = data & ((1 << self.data_length) - 1)
        
        # Distribute data across 3D memory
        memory_3d = self._distribute_data_3d(data)
        
        # Calculate multi-dimensional parity
        layer_parity = self._calculate_layer_parity(memory_3d)
        bit_parity = self._calculate_bit_parity(memory_3d)
        overall_parity = self._calculate_overall_parity(memory_3d)
        
        # Pack into codeword
        codeword = 0
        bit_pos = 0
        
        # Pack data bits
        for layer in range(self.layers):
            for bit in range(self.bits_per_layer):
                codeword |= (memory_3d[layer][bit] << bit_pos)
                bit_pos += 1
        
        # Pack layer parity bits
        for parity in layer_parity:
            codeword |= (parity << bit_pos)
            bit_pos += 1
        
        # Pack bit parity bits
        for parity in bit_parity:
            codeword |= (parity << bit_pos)
            bit_pos += 1
        
        # Pack overall parity bit
        codeword |= (overall_parity << bit_pos)
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode 3D memory codeword with error detection and correction.
        
        Args:
            codeword: Codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Extract data and parity bits
            data_bits = []
            for layer in range(self.layers):
                for bit in range(self.bits_per_layer):
                    data_bits.append((codeword >> (layer * self.bits_per_layer + bit)) & 1)
            
            # Extract parity bits
            parity_start = self.total_bits
            layer_parity = []
            for i in range(self.layers):
                layer_parity.append((codeword >> (parity_start + i)) & 1)
            
            bit_parity = []
            for i in range(self.bits_per_layer):
                bit_parity.append((codeword >> (parity_start + self.layers + i)) & 1)
            
            overall_parity = (codeword >> (parity_start + self.layers + self.bits_per_layer)) & 1
            
            # Reconstruct 3D memory
            memory_3d = []
            for layer in range(self.layers):
                layer_bits = []
                for bit in range(self.bits_per_layer):
                    layer_bits.append(data_bits[layer * self.bits_per_layer + bit])
                memory_3d.append(layer_bits)
            
            # Check for errors
            expected_layer_parity = self._calculate_layer_parity(memory_3d)
            expected_bit_parity = self._calculate_bit_parity(memory_3d)
            expected_overall_parity = self._calculate_overall_parity(memory_3d)
            
            # Detect errors
            layer_errors = [i for i in range(self.layers) if layer_parity[i] != expected_layer_parity[i]]
            bit_errors = [i for i in range(self.bits_per_layer) if bit_parity[i] != expected_bit_parity[i]]
            overall_error = overall_parity != expected_overall_parity
            
            # Error correction logic
            if len(layer_errors) == 1 and len(bit_errors) == 1:
                # Single bit error detected
                layer_idx = layer_errors[0]
                bit_idx = bit_errors[0]
                memory_3d[layer_idx][bit_idx] ^= 1  # Flip the bit
                print(f"🔧 3D Memory: Corrected bit at layer {layer_idx}, position {bit_idx}")
            
            # Extract corrected data
            corrected_data = 0
            bit_pos = 0
            for layer in range(self.layers):
                for bit in range(self.bits_per_layer):
                    if bit_pos < self.data_length:
                        corrected_data |= (memory_3d[layer][bit] << bit_pos)
                        bit_pos += 1
            
            # Determine error type
            if len(layer_errors) == 0 and len(bit_errors) == 0 and not overall_error:
                return corrected_data, 'corrected'
            elif len(layer_errors) <= 1 and len(bit_errors) <= 1:
                return corrected_data, 'corrected'
            else:
                return corrected_data, 'detected'
                
        except Exception as e:
            return codeword, 'detected'
    
    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Inject error into 3D memory codeword.
        
        Args:
            codeword: Original codeword
            bit_idx: Bit index to flip
            
        Returns:
            Corrupted codeword
        """
        return codeword ^ (1 << bit_idx)
    
    def get_3d_info(self) -> Dict[str, any]:
        """Get 3D memory configuration information."""
        return {
            'layers': self.layers,
            'bits_per_layer': self.bits_per_layer,
            'total_bits': self.total_bits,
            'parity_bits': self.parity_bits,
            'code_length': self.n,
            'data_length': self.data_length
        }