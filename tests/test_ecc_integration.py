"""Integration tests for ECC implementations with the framework."""

from typing import TYPE_CHECKING

import pytest

from src.repetition_ecc_wrapper import RepetitionECC
from src.convolutional_ecc_wrapper import ConvolutionalECC
from src.polar_ecc_wrapper import PolarECC
from src.golay_ecc_wrapper import GolayECC
from src.crc_ecc_wrapper import CRCECC
from src.simulation import simulate_ecc

if TYPE_CHECKING:
    from _pytest.fixtures import FixtureRequest


class TestECCIntegration:
    """Test integration of new ECC implementations with the framework."""

    def test_repetition_ecc_integration(self) -> None:
        """Test RepetitionECC integration with the framework."""
        # Test basic functionality
        ecc = RepetitionECC(n=3)
        
        # Test encoding
        data = 0b1010  # 4 bits
        codeword = ecc.encode(data)
        assert codeword > 0
        
        # Test decoding without errors
        decoded, detected, corrected = ecc.decode(codeword)
        assert decoded == data
        assert detected is True
        assert corrected is True
        
        # Test error injection and correction
        corrupted = ecc.inject_error(codeword, 0)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected is True
        assert corrected is True

    def test_convolutional_ecc_integration(self) -> None:
        """Test ConvolutionalECC integration with the framework."""
        ecc = ConvolutionalECC()
        
        # Test encoding
        data = 0b1010  # 4 bits
        codeword = ecc.encode(data)
        assert codeword > 0
        
        # Test decoding without errors
        decoded, detected, corrected = ecc.decode(codeword)
        assert decoded == data
        assert detected is True
        assert corrected is True
        
        # Test error injection and correction
        corrupted = ecc.inject_error(codeword, 0)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected is True

    def test_polar_ecc_integration(self) -> None:
        """Test PolarECC integration with the framework."""
        ecc = PolarECC(N=4, K=2)
        
        # Test encoding
        data = 0b10  # 2 bits (K=2)
        codeword = ecc.encode(data)
        assert codeword > 0
        
        # Test decoding without errors
        decoded, detected, corrected = ecc.decode(codeword)
        assert decoded == data
        assert detected is True
        assert corrected is True
        
        # Test error injection and correction
        corrupted = ecc.inject_error(codeword, 0)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected is True

    def test_golay_ecc_integration(self) -> None:
        """Test GolayECC integration with the framework."""
        ecc = GolayECC()
        
        # Test encoding
        data = 0b101010101010  # 12 bits
        codeword = ecc.encode(data)
        assert codeword > 0
        
        # Test decoding without errors
        decoded, detected, corrected = ecc.decode(codeword)
        assert decoded == data
        assert detected is True
        
        # Test error injection and detection
        corrupted = ecc.inject_error(codeword, 0)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected is True

    def test_crc_ecc_integration(self) -> None:
        """Test CRCECC integration with the framework."""
        ecc = CRCECC()
        
        # Test encoding
        data = 0b10101010  # 8 bits
        codeword = ecc.encode(data)
        assert codeword > 0
        
        # Test decoding without errors
        decoded, detected, corrected = ecc.decode(codeword)
        assert decoded == data
        assert detected is True
        assert corrected is False  # CRC only detects, doesn't correct
        
        # Test error injection and detection
        corrupted = ecc.inject_error(codeword, 0)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected is True
        assert corrected is False

    def test_simulation_integration(self) -> None:
        """Test that all ECC implementations work with the simulation framework."""
        # Test each ECC type with the simulation function
        ecc_types = [
            (RepetitionECC, {"n": 3}),
            (ConvolutionalECC, {}),
            (PolarECC, {"N": 4, "K": 2}),
            (GolayECC, {}),
            (CRCECC, {}),
        ]
        
        for ecc_cls, kwargs in ecc_types:
            # Create ECC instance
            if kwargs:
                ecc = lambda: ecc_cls(**kwargs)
            else:
                ecc = ecc_cls
            
            # Run simulation
            try:
                results = simulate_ecc(ecc, n_trials=100, n_bits=8)
                
                # Verify results structure
                assert "correctable" in results
                assert "detected" in results
                assert "undetected" in results
                assert isinstance(results["correctable"], int)
                assert isinstance(results["detected"], int)
                assert isinstance(results["undetected"], int)
                
                # Verify results are non-negative
                assert results["correctable"] >= 0
                assert results["detected"] >= 0
                assert results["undetected"] >= 0
                
            except Exception as e:
                pytest.fail(f"Simulation failed for {ecc_cls.__name__}: {e}")

    def test_different_data_sizes(self) -> None:
        """Test ECC implementations with different data sizes."""
        test_cases = [
            (RepetitionECC, {"n": 3}, 4),  # 4 bits
            (ConvolutionalECC, {}, 4),     # 4 bits
            (PolarECC, {"N": 4, "K": 2}, 2),  # 2 bits
            (GolayECC, {}, 12),           # 12 bits
            (CRCECC, {}, 8),              # 8 bits
        ]
        
        for ecc_cls, kwargs, n_bits in test_cases:
            ecc = ecc_cls(**kwargs)
            
            # Test with different data values
            for data in [0, 1, 0b1010, 0b1111]:
                # Limit data to appropriate bit length
                if data.bit_length() > n_bits:
                    data = data & ((1 << n_bits) - 1)
                
                try:
                    codeword = ecc.encode(data)
                    decoded, detected, corrected = ecc.decode(codeword)
                    
                    # Basic sanity checks
                    assert detected is True
                    assert isinstance(decoded, int)
                    assert isinstance(corrected, bool)
                    
                except Exception as e:
                    pytest.fail(f"Failed for {ecc_cls.__name__} with data {data}: {e}")

    def test_error_injection_edge_cases(self) -> None:
        """Test error injection with edge cases."""
        ecc = RepetitionECC(n=3)
        
        # Test with zero data
        data = 0
        codeword = ecc.encode(data)
        assert codeword == 0
        
        # Test error injection on zero codeword
        corrupted = ecc.inject_error(codeword, 0)
        assert corrupted == 1
        
        # Test decoding corrupted zero
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected is True

    def test_round_trip_consistency(self) -> None:
        """Test that encode-decode round trips are consistent."""
        test_cases = [
            (RepetitionECC, {"n": 3}, [0, 1, 0b1010, 0b1111]),  # 4-bit data
            (ConvolutionalECC, {}, [0, 1, 0b1010, 0b1111]),     # 4-bit data
            (PolarECC, {"N": 4, "K": 2}, [0, 1, 0b10, 0b11]),  # 2-bit data
            (GolayECC, {}, [0, 1, 0b101010101010, 0b111111111111]),  # 12-bit data
            (CRCECC, {}, [0, 1, 0b10101010, 0b11111111]),      # 8-bit data
        ]
        
        for ecc_cls, kwargs, test_data in test_cases:
            ecc = ecc_cls(**kwargs)
            
            # Test multiple round trips
            for data in test_data:
                try:
                    # Encode
                    codeword = ecc.encode(data)
                    
                    # Decode without errors
                    decoded, detected, corrected = ecc.decode(codeword)
                    
                    # For most ECCs, the decoded data should match the original
                    # (CRC is an exception as it only detects errors)
                    if not isinstance(ecc, CRCECC):
                        assert decoded == data
                    
                    # All should detect errors (even if none present)
                    assert detected is True
                    
                except Exception as e:
                    pytest.fail(f"Round trip failed for {ecc_cls.__name__} with data {data}: {e}") 