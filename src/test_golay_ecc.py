"""Unit tests for golay_ecc module."""

from typing import TYPE_CHECKING

import pytest

from src.golay_ecc import GolayCode

if TYPE_CHECKING:
    from _pytest.fixtures import FixtureRequest


class TestGolayCode:
    """Test cases for GolayCode class."""

    def test_init(self) -> None:
        """Test initialization sets correct parameters."""
        code = GolayCode()
        assert code.n == 23
        assert code.k == 12
        assert code.g == 0b1000000001011

    def test_encode_valid_length(self) -> None:
        """Test encoding with valid 12-bit input."""
        code = GolayCode()
        data = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
        result = code.encode(data)
        assert len(result) == 23
        # Check that first 12 bits match input
        assert result[:12] == data

    def test_encode_invalid_length(self) -> None:
        """Test encoding with invalid length raises ValueError."""
        code = GolayCode()
        with pytest.raises(ValueError, match="Golay code encodes 12 bits"):
            code.encode([1, 0, 1])  # Only 3 bits

    def test_encode_all_zeros(self) -> None:
        """Test encoding all zeros."""
        code = GolayCode()
        data = [0] * 12
        result = code.encode(data)
        assert len(result) == 23
        assert result[:12] == data

    def test_encode_all_ones(self) -> None:
        """Test encoding all ones."""
        code = GolayCode()
        data = [1] * 12
        result = code.encode(data)
        assert len(result) == 23
        assert result[:12] == data

    def test_encode_alternating_bits(self) -> None:
        """Test encoding alternating bits."""
        code = GolayCode()
        data = [1, 0] * 6  # 12 bits alternating
        result = code.encode(data)
        assert len(result) == 23
        assert result[:12] == data

    def test_decode_valid_length(self) -> None:
        """Test decoding with valid 23-bit input."""
        code = GolayCode()
        codeword = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0] + [0] * 11
        result = code.decode(codeword)
        assert len(result) == 12
        assert result == [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]

    def test_decode_invalid_length(self) -> None:
        """Test decoding with invalid length raises ValueError."""
        code = GolayCode()
        with pytest.raises(ValueError, match="Golay codeword must be 23 bits"):
            code.decode([1, 0, 1])  # Only 3 bits

    def test_decode_all_zeros(self) -> None:
        """Test decoding all zeros."""
        code = GolayCode()
        codeword = [0] * 23
        result = code.decode(codeword)
        assert len(result) == 12
        assert result == [0] * 12

    def test_decode_all_ones(self) -> None:
        """Test decoding all ones."""
        code = GolayCode()
        codeword = [1] * 23
        result = code.decode(codeword)
        assert len(result) == 12
        assert result == [1] * 12

    def test_encode_decode_roundtrip(self) -> None:
        """Test that encode followed by decode returns original data."""
        code = GolayCode()
        original = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_all_zeros(self) -> None:
        """Test encode/decode roundtrip with all zeros."""
        code = GolayCode()
        original = [0] * 12
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_all_ones(self) -> None:
        """Test encode/decode roundtrip with all ones."""
        code = GolayCode()
        original = [1] * 12
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_mixed(self) -> None:
        """Test encode/decode roundtrip with mixed bits."""
        code = GolayCode()
        original = [1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1]
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_generator_polynomial(self) -> None:
        """Test that generator polynomial is correct."""
        code = GolayCode()
        # Generator polynomial should be x^11 + x^9 + x^7 + x^6 + x^5 + x + 1
        expected = 0b1000000001011
        assert code.g == expected

    def test_codeword_structure(self) -> None:
        """Test that encoded codeword has correct structure."""
        code = GolayCode()
        data = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
        codeword = code.encode(data)
        # First 12 bits should be the original data
        assert codeword[:12] == data
        # Last 11 bits should be parity bits
        assert len(codeword) == 23 