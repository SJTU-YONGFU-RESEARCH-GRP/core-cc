from typing import Tuple, Dict, List, Optional
from base_ecc import ECCBase
import random
import time

class AdaptiveECC(ECCBase):
    """
    Adaptive ECC that dynamically selects the best ECC type based on:
    - Error rate conditions
    - Performance requirements
    - Power constraints
    - Data criticality
    """
    
    def __init__(self, data_length: int = 8, initial_ecc_type: str = "HammingSECDED"):
        """
        Initialize Adaptive ECC.
        
        Args:
            data_length: Length of data word in bits
            initial_ecc_type: Starting ECC type
        """
        self.data_length = data_length
        self.current_ecc_type = initial_ecc_type
        self.error_history = []
        self.performance_metrics = {}
        self.adaptation_threshold = 0.1  # Error rate threshold for adaptation
        
        # Available ECC types with their characteristics
        self.ecc_types = {
            'ParityECC': {
                'complexity': 'low',
                'power': 'low',
                'correction': 'none',
                'detection': 'single',
                'overhead': 0.125
            },
            'HammingSECDEDECC': {
                'complexity': 'medium',
                'power': 'medium',
                'correction': 'single',
                'detection': 'double',
                'overhead': 0.5
            },
            'BCHECC': {
                'complexity': 'high',
                'power': 'high',
                'correction': 'multiple',
                'detection': 'multiple',
                'overhead': 0.8
            },
            'ReedSolomonECC': {
                'complexity': 'high',
                'power': 'high',
                'correction': 'burst',
                'detection': 'burst',
                'overhead': 1.0
            }
        }
        
        # Initialize the current ECC
        self._initialize_ecc()
    
    def _initialize_ecc(self):
        """Initialize the current ECC type."""
        try:
            if self.current_ecc_type == 'ParityECC':
                from parity_ecc import ParityECC
                self.current_ecc = ParityECC(data_length=self.data_length)
            elif self.current_ecc_type == 'HammingSECDEDECC':
                from hamming_secded_ecc import HammingSECDEDECC
                self.current_ecc = HammingSECDEDECC(data_length=self.data_length)
            elif self.current_ecc_type == 'BCHECC':
                from bch_ecc import BCHECC
                self.current_ecc = BCHECC(n=15, k=7, t=2)
            elif self.current_ecc_type == 'ReedSolomonECC':
                from reed_solomon_ecc import ReedSolomonECC
                self.current_ecc = ReedSolomonECC(n=15, k=8)
            else:
                # Default to Hamming
                from hamming_secded_ecc import HammingSECDEDECC
                self.current_ecc = HammingSECDEDECC(data_length=self.data_length)
        except Exception as e:
            print(f"Warning: Could not initialize {self.current_ecc_type}, falling back to Hamming")
            from hamming_secded_ecc import HammingSECDEDECC
            self.current_ecc = HammingSECDEDECC(data_length=self.data_length)
            self.current_ecc_type = 'HammingSECDEDECC'
    
    def _estimate_error_rate(self) -> float:
        """Estimate current error rate based on recent history."""
        if len(self.error_history) < 10:
            return 0.0
        
        recent_errors = self.error_history[-10:]
        return sum(recent_errors) / len(recent_errors)
    
    def _select_optimal_ecc(self, error_rate: float, power_constraint: str = 'medium') -> str:
        """
        Select optimal ECC type based on error rate and constraints.
        
        Args:
            error_rate: Current error rate
            power_constraint: Power constraint ('low', 'medium', 'high')
            
        Returns:
            Optimal ECC type name
        """
        if error_rate < 0.01:  # Very low error rate
            if power_constraint == 'low':
                return 'ParityECC'
            else:
                return 'HammingSECDEDECC'
        elif error_rate < 0.05:  # Low error rate
            return 'HammingSECDEDECC'
        elif error_rate < 0.1:  # Medium error rate
            return 'BCHECC'
        else:  # High error rate
            return 'ReedSolomonECC'
    
    def _adapt_ecc(self, error_rate: float, power_constraint: str = 'medium'):
        """Adapt ECC type based on current conditions."""
        optimal_type = self._select_optimal_ecc(error_rate, power_constraint)
        
        if optimal_type != self.current_ecc_type:
            print(f"🔄 Adapting ECC: {self.current_ecc_type} → {optimal_type} (error_rate: {error_rate:.3f})")
            self.current_ecc_type = optimal_type
            self._initialize_ecc()
    
    def encode(self, data: int) -> int:
        """
        Encode data using current adaptive ECC.
        
        Args:
            data: Input data to encode
            
        Returns:
            Encoded codeword
        """
        # Adapt ECC if needed
        error_rate = self._estimate_error_rate()
        self._adapt_ecc(error_rate)
        
        # Encode with current ECC
        return self.current_ecc.encode(data)
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode codeword using current adaptive ECC.
        
        Args:
            codeword: Codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        # Decode with current ECC
        decoded_data, error_type = self.current_ecc.decode(codeword)
        
        # Update error history
        error_detected = error_type in ['detected', 'undetected']
        self.error_history.append(1 if error_detected else 0)
        
        # Keep only recent history (last 100 entries)
        if len(self.error_history) > 100:
            self.error_history = self.error_history[-100:]
        
        return decoded_data, error_type
    
    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Inject error into codeword.
        
        Args:
            codeword: Original codeword
            bit_idx: Bit index to flip
            
        Returns:
            Corrupted codeword
        """
        return codeword ^ (1 << bit_idx)
    
    def get_adaptation_info(self) -> Dict[str, any]:
        """Get current adaptation information."""
        return {
            'current_ecc_type': self.current_ecc_type,
            'error_rate': self._estimate_error_rate(),
            'error_history_length': len(self.error_history),
            'ecc_characteristics': self.ecc_types.get(self.current_ecc_type, {})
        }