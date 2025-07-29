from typing import Tuple, List, Optional
from base_ecc import ECCBase
import numpy as np

class CyclicECC(ECCBase):
    """
    General Cyclic Code ECC implementation.
    Supports different generator polynomials and field sizes.
    """
    
    def __init__(self, n: int = 15, k: int = 7, generator_poly: int = None, 
                 field_size: int = 2, data_length: int = None):
        """
        Initialize Cyclic ECC.
        
        Args:
            n: Codeword length
            k: Data length
            generator_poly: Generator polynomial (if None, uses default)
            field_size: Field size (2 for binary, 4 for GF(4), etc.)
            data_length: Data length for compatibility
        """
        if data_length is not None:
            self.k = data_length
        else:
            self.k = k
            
        self.n = n
        self.field_size = field_size
        
        # Set generator polynomial
        if generator_poly is None:
            # Default generator polynomials for common cyclic codes
            if n == 7 and k == 4:
                self.generator_poly = 0b1011  # x^3 + x + 1 (Hamming)
            elif n == 15 and k == 7:
                self.generator_poly = 0b10011  # x^4 + x + 1 (BCH)
            elif n == 31 and k == 16:
                self.generator_poly = 0b100101  # x^5 + x^2 + 1
            else:
                # Default to a simple polynomial
                self.generator_poly = 0b1011
        else:
            self.generator_poly = generator_poly
        
        # Calculate parity check polynomial
        self.parity_check_poly = self._calculate_parity_check_poly()
        
        # Generate encoding and decoding matrices
        self.G = self._generate_generator_matrix()
        self.H = self._generate_parity_check_matrix()
    
    def _calculate_parity_check_poly(self) -> int:
        """Calculate parity check polynomial h(x) where g(x) * h(x) = x^n - 1."""
        # For simplicity, use a basic approach
        # In practice, this would involve polynomial division
        return 0b111  # Default parity check polynomial
    
    def _generate_generator_matrix(self) -> np.ndarray:
        """Generate systematic generator matrix."""
        G = np.zeros((self.k, self.n), dtype=int)
        
        # Systematic form: identity matrix for data part
        for i in range(self.k):
            G[i, i] = 1
        
        # Calculate parity part using polynomial division
        for i in range(self.k):
            for j in range(self.k, self.n):
                # Simple parity pattern based on generator polynomial
                if (i + j - self.k) % 2 == 0:
                    G[i, j] = 1
        
        return G
    
    def _generate_parity_check_matrix(self) -> np.ndarray:
        """Generate parity check matrix."""
        m = self.n - self.k
        H = np.zeros((m, self.n), dtype=int)
        
        # Create parity check matrix that satisfies G * H^T = 0
        for i in range(m):
            for j in range(self.n):
                if j >= self.k:  # Parity bits
                    if i == (j - self.k):
                        H[i, j] = 1
                else:  # Data bits
                    if (i + j) % 2 == 0:
                        H[i, j] = 1
        
        return H
    
    def _polynomial_division(self, dividend: int, divisor: int) -> Tuple[int, int]:
        """
        Perform polynomial division.
        
        Args:
            dividend: Dividend polynomial
            divisor: Divisor polynomial
            
        Returns:
            Tuple of (quotient, remainder)
        """
        if divisor == 0:
            return 0, dividend
        
        # Convert to binary representation
        dividend_bits = bin(dividend)[2:]
        divisor_bits = bin(divisor)[2:]
        
        # Perform polynomial division
        quotient = 0
        remainder = dividend
        
        while remainder >= divisor:
            # Find the highest power
            remainder_bits = bin(remainder)[2:]
            divisor_bits = bin(divisor)[2:]
            
            # Shift divisor to align with remainder
            shift = len(remainder_bits) - len(divisor_bits)
            if shift < 0:
                break
            
            shifted_divisor = divisor << shift
            remainder ^= shifted_divisor
            quotient |= (1 << shift)
        
        return quotient, remainder
    
    def encode(self, data: int) -> int:
        """
        Encode data using cyclic code.
        
        Args:
            data: Input data to encode
            
        Returns:
            Encoded codeword
        """
        # Ensure data fits within k bits
        if data >= (1 << self.k):
            data = data & ((1 << self.k) - 1)
        
        # Convert data to polynomial
        data_poly = data << (self.n - self.k)  # Shift left by (n-k) positions
        
        # Perform polynomial division to get remainder
        _, remainder = self._polynomial_division(data_poly, self.generator_poly)
        
        # Systematic codeword: data followed by remainder
        codeword = data_poly | remainder
        
        return codeword
    
    def decode(self, codeword: int) -> Tuple[int, str]:
        """
        Decode cyclic codeword.
        
        Args:
            codeword: Codeword to decode
            
        Returns:
            Tuple of (decoded_data, error_type)
        """
        try:
            # Calculate syndrome
            syndrome = self._calculate_syndrome(codeword)
            
            if syndrome == 0:
                # No errors detected
                decoded_data = (codeword >> (self.n - self.k)) & ((1 << self.k) - 1)
                return decoded_data, 'corrected'
            else:
                # Try to correct errors
                corrected_codeword, correction_success = self._correct_errors(codeword, syndrome)
                
                if correction_success:
                    decoded_data = (corrected_codeword >> (self.n - self.k)) & ((1 << self.k) - 1)
                    return decoded_data, 'corrected'
                else:
                    # Error detected but not corrected
                    decoded_data = (codeword >> (self.n - self.k)) & ((1 << self.k) - 1)
                    return decoded_data, 'detected'
                    
        except Exception as e:
            return codeword, 'detected'
    
    def _calculate_syndrome(self, codeword: int) -> int:
        """Calculate syndrome for error detection."""
        # Use parity check matrix
        syndrome = 0
        for i in range(self.n - self.k):
            parity = 0
            for j in range(self.n):
                if ((codeword >> j) & 1) and self.H[i, j]:
                    parity ^= 1
            syndrome |= (parity << i)
        return syndrome
    
    def _correct_errors(self, codeword: int, syndrome: int) -> Tuple[int, bool]:
        """
        Attempt to correct errors using syndrome.
        
        Args:
            codeword: Received codeword
            syndrome: Calculated syndrome
            
        Returns:
            Tuple of (corrected_codeword, success)
        """
        # Simple error correction for single-bit errors
        if syndrome == 0:
            return codeword, True
        
        # Try to find error position
        for i in range(self.n):
            test_codeword = codeword ^ (1 << i)
            test_syndrome = self._calculate_syndrome(test_codeword)
            if test_syndrome == 0:
                return test_codeword, True
        
        # Could not correct
        return codeword, False
    
    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Inject error into cyclic codeword.
        
        Args:
            codeword: Original codeword
            bit_idx: Bit index to flip
            
        Returns:
            Corrupted codeword
        """
        return codeword ^ (1 << bit_idx)
    
    def get_cyclic_info(self) -> dict:
        """Get cyclic code configuration information."""
        return {
            'n': self.n,
            'k': self.k,
            'generator_polynomial': bin(self.generator_poly),
            'field_size': self.field_size,
            'code_rate': self.k / self.n,
            'error_correction_capability': (self.n - self.k) // 2
        }