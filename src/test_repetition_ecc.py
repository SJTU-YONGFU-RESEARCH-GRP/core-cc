"""Unit tests for repetition_ecc module."""

from typing import TYPE_CHECKING

import pytest

from src.repetition_ecc import RepetitionCode

if TYPE_CHECKING:
    from _pytest.fixtures import FixtureRequest


class TestRepetitionCode:
    """Test cases for RepetitionCode class."""

    def test_init_valid_odd_number(self) -> None:
        """Test initialization with valid odd number."""
        code = RepetitionCode(n=3)
        assert code.n == 3

    def test_init_invalid_even_number(self) -> None:
        """Test initialization with invalid even number raises ValueError."""
        with pytest.raises(ValueError, match="n must be an odd positive integer"):
            RepetitionCode(n=2)

    def test_init_invalid_zero(self) -> None:
        """Test initialization with zero raises ValueError."""
        with pytest.raises(ValueError, match="n must be an odd positive integer"):
            RepetitionCode(n=0)

    def test_init_invalid_negative(self) -> None:
        """Test initialization with negative number raises ValueError."""
        with pytest.raises(ValueError, match="n must be an odd positive integer"):
            RepetitionCode(n=-1)

    def test_encode_single_bit(self) -> None:
        """Test encoding a single bit."""
        code = RepetitionCode(n=3)
        result = code.encode([1])
        assert result == [1, 1, 1]

    def test_encode_multiple_bits(self) -> None:
        """Test encoding multiple bits."""
        code = RepetitionCode(n=3)
        result = code.encode([1, 0, 1])
        assert result == [1, 1, 1, 0, 0, 0, 1, 1, 1]

    def test_encode_empty_list(self) -> None:
        """Test encoding empty list returns empty list."""
        code = RepetitionCode(n=3)
        result = code.encode([])
        assert result == []

    def test_decode_single_bit(self) -> None:
        """Test decoding a single repeated bit."""
        code = RepetitionCode(n=3)
        result = code.decode([1, 1, 1])
        assert result == [1]

    def test_decode_multiple_bits(self) -> None:
        """Test decoding multiple repeated bits."""
        code = RepetitionCode(n=3)
        result = code.decode([1, 1, 1, 0, 0, 0, 1, 1, 1])
        assert result == [1, 0, 1]

    def test_decode_with_errors(self) -> None:
        """Test decoding with some bit errors (majority voting)."""
        code = RepetitionCode(n=3)
        # 1,1,0 -> majority is 1
        # 0,1,0 -> majority is 0
        result = code.decode([1, 1, 0, 0, 1, 0])
        assert result == [1, 0]

    def test_decode_invalid_length(self) -> None:
        """Test decoding with invalid length raises ValueError."""
        code = RepetitionCode(n=3)
        with pytest.raises(ValueError, match="Codeword length must be a multiple of n"):
            code.decode([1, 1])  # length 2, not multiple of 3

    def test_encode_decode_roundtrip(self) -> None:
        """Test that encode followed by decode returns original data."""
        code = RepetitionCode(n=5)
        original = [1, 0, 1, 0, 1]
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_n5_encoding(self) -> None:
        """Test encoding with n=5."""
        code = RepetitionCode(n=5)
        result = code.encode([1, 0])
        assert result == [1, 1, 1, 1, 1, 0, 0, 0, 0, 0]

    def test_n5_decoding(self) -> None:
        """Test decoding with n=5."""
        code = RepetitionCode(n=5)
        result = code.decode([1, 1, 1, 1, 1, 0, 0, 0, 0, 0])
        assert result == [1, 0]

    def test_n5_error_correction(self) -> None:
        """Test error correction with n=5 (can correct up to 2 errors)."""
        code = RepetitionCode(n=5)
        # 1,1,1,0,0 -> majority is 1 (2 errors corrected)
        # 0,0,1,0,0 -> majority is 0 (1 error corrected)
        result = code.decode([1, 1, 1, 0, 0, 0, 0, 1, 0, 0])
        assert result == [1, 0] 