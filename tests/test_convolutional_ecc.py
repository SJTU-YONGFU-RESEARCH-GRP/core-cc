"""Unit tests for convolutional_ecc module."""

from typing import TYPE_CHECKING

import pytest

from src.convolutional_ecc import ConvolutionalCode

if TYPE_CHECKING:
    from _pytest.fixtures import FixtureRequest


class TestConvolutionalCode:
    """Test cases for ConvolutionalCode class."""

    def test_init(self) -> None:
        """Test initialization sets correct generator polynomials."""
        code = ConvolutionalCode()
        assert code.g1 == 0b11  # 3 in octal
        assert code.g2 == 0b10  # 2 in octal
        assert code.K == 2

    def test_parity_calculation(self) -> None:
        """Test internal parity calculation."""
        code = ConvolutionalCode()
        assert code._parity(0b101) == 0  # 3 ones, odd
        assert code._parity(0b110) == 0  # 2 ones, even
        assert code._parity(0b111) == 1  # 3 ones, odd
        assert code._parity(0b000) == 0  # 0 ones, even

    def test_encode_single_bit(self) -> None:
        """Test encoding a single bit."""
        code = ConvolutionalCode()
        result = code.encode([1])
        # For input 1, state becomes 01, outputs: parity(01&11)=parity(01)=1, parity(01&10)=parity(00)=0
        assert result == [1, 0]

    def test_encode_multiple_bits(self) -> None:
        """Test encoding multiple bits."""
        code = ConvolutionalCode()
        result = code.encode([1, 0])
        # First bit (1): state 01, outputs [1,0]
        # Second bit (0): state 10, outputs [parity(10&11)=parity(10)=1, parity(10&10)=parity(10)=1]
        assert result == [1, 0, 1, 1]

    def test_encode_empty_list(self) -> None:
        """Test encoding empty list returns empty list."""
        code = ConvolutionalCode()
        result = code.encode([])
        assert result == []

    def test_encode_all_zeros(self) -> None:
        """Test encoding all zeros."""
        code = ConvolutionalCode()
        result = code.encode([0, 0, 0])
        # Each 0 bit with state transitions: 00->00->00
        # Outputs: [parity(00&11)=0, parity(00&10)=0] repeated
        assert result == [0, 0, 0, 0, 0, 0]

    def test_encode_all_ones(self) -> None:
        """Test encoding all ones."""
        code = ConvolutionalCode()
        result = code.encode([1, 1])
        # First 1: state 01, outputs [1,0]
        # Second 1: state 11, outputs [parity(11&11)=parity(11)=1, parity(11&10)=parity(10)=1]
        assert result == [1, 0, 1, 1]

    def test_viterbi_decode_single_bit(self) -> None:
        """Test Viterbi decoding of single encoded bit."""
        code = ConvolutionalCode()
        encoded = [1, 0]  # Encoded version of [1]
        result = code.viterbi_decode(encoded)
        assert result == [1]

    def test_viterbi_decode_multiple_bits(self) -> None:
        """Test Viterbi decoding of multiple encoded bits."""
        code = ConvolutionalCode()
        encoded = [1, 0, 1, 1]  # Encoded version of [1, 0]
        result = code.viterbi_decode(encoded)
        assert result == [1, 0]

    def test_viterbi_decode_invalid_length(self) -> None:
        """Test Viterbi decoding with odd length raises ValueError."""
        code = ConvolutionalCode()
        with pytest.raises(ValueError, match="Codeword length must be even"):
            code.viterbi_decode([1, 0, 1])  # length 3, not even

    def test_encode_decode_roundtrip(self) -> None:
        """Test that encode followed by decode returns original data."""
        code = ConvolutionalCode()
        original = [1, 0, 1, 0, 1]
        encoded = code.encode(original)
        decoded = code.viterbi_decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_zeros(self) -> None:
        """Test encode/decode roundtrip with all zeros."""
        code = ConvolutionalCode()
        original = [0, 0, 0]
        encoded = code.encode(original)
        decoded = code.viterbi_decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_ones(self) -> None:
        """Test encode/decode roundtrip with all ones."""
        code = ConvolutionalCode()
        original = [1, 1, 1]
        encoded = code.encode(original)
        decoded = code.viterbi_decode(encoded)
        assert decoded == original

    def test_viterbi_decode_with_errors(self) -> None:
        """Test Viterbi decoding with some bit errors."""
        code = ConvolutionalCode()
        # Original: [1, 0] -> [1, 0, 1, 1]
        # With errors: [0, 0, 1, 1] (first bit flipped)
        corrupted = [0, 0, 1, 1]
        result = code.viterbi_decode(corrupted)
        # Should still decode correctly due to Viterbi algorithm
        assert result == [1, 0] 