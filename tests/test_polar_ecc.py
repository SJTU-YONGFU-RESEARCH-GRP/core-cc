"""Unit tests for polar_ecc module."""

from typing import TYPE_CHECKING

import pytest

from src.polar_ecc import PolarCode

if TYPE_CHECKING:
    from _pytest.fixtures import FixtureRequest


class TestPolarCode:
    """Test cases for PolarCode class."""

    def test_init_default(self) -> None:
        """Test initialization with default parameters."""
        code = PolarCode()
        assert code.N == 4
        assert code.K == 2
        assert code.frozen_bits == [0, 1]

    def test_init_custom(self) -> None:
        """Test initialization with custom parameters."""
        code = PolarCode(N=4, K=2, frozen_bits=[0, 2])
        assert code.N == 4
        assert code.K == 2
        assert code.frozen_bits == [0, 2]

    def test_init_unsupported_parameters(self) -> None:
        """Test initialization with unsupported parameters raises AssertionError."""
        with pytest.raises(AssertionError, match="This demo only supports N=4, K=2"):
            PolarCode(N=8, K=4)

    def test_encode_simple_case(self) -> None:
        """Test encoding with simple input."""
        code = PolarCode()
        result = code.encode([1, 0])
        # x = [0, 0, 1, 0] (frozen bits at 0,1 are 0, info bits at 2,3 are 1,0)
        # y0 = 0^0^1^0 = 1
        # y1 = 1^0 = 1
        # y2 = 0^0 = 0
        # y3 = 0
        assert result == [1, 1, 0, 0]

    def test_encode_all_zeros(self) -> None:
        """Test encoding with all zero information bits."""
        code = PolarCode()
        result = code.encode([0, 0])
        # x = [0, 0, 0, 0]
        # y0 = 0^0^0^0 = 0
        # y1 = 0^0 = 0
        # y2 = 0^0 = 0
        # y3 = 0
        assert result == [0, 0, 0, 0]

    def test_encode_all_ones(self) -> None:
        """Test encoding with all one information bits."""
        code = PolarCode()
        result = code.encode([1, 1])
        # x = [0, 0, 1, 1]
        # y0 = 0^0^1^1 = 0
        # y1 = 1^1 = 0
        # y2 = 0^1 = 1
        # y3 = 1
        assert result == [0, 0, 1, 1]

    def test_encode_mixed_bits(self) -> None:
        """Test encoding with mixed information bits."""
        code = PolarCode()
        result = code.encode([0, 1])
        # x = [0, 0, 0, 1]
        # y0 = 0^0^0^1 = 1
        # y1 = 0^1 = 1
        # y2 = 0^1 = 1
        # y3 = 1
        assert result == [1, 1, 1, 1]

    def test_decode_simple_case(self) -> None:
        """Test decoding with simple input."""
        code = PolarCode()
        result = code.decode([1, 1, 0, 0])
        # x3 = 0, x2 = 1^0 = 1, x1 = 0^0 = 0, x0 = 1^1^0^0 = 0
        # Extract info bits from positions 2,3: [1, 0]
        assert result == [1, 0]

    def test_decode_all_zeros(self) -> None:
        """Test decoding with all zero codeword."""
        code = PolarCode()
        result = code.decode([0, 0, 0, 0])
        # x3 = 0, x2 = 0^0 = 0, x1 = 0^0 = 0, x0 = 0^0^0^0 = 0
        # Extract info bits from positions 2,3: [0, 0]
        assert result == [0, 0]

    def test_decode_all_ones(self) -> None:
        """Test decoding with all one codeword."""
        code = PolarCode()
        result = code.decode([0, 0, 1, 1])
        # x3 = 1, x2 = 0^1 = 1, x1 = 0^1 = 1, x0 = 0^1^1^1 = 1
        # Extract info bits from positions 2,3: [1, 1]
        assert result == [1, 1]

    def test_decode_mixed_bits(self) -> None:
        """Test decoding with mixed codeword."""
        code = PolarCode()
        result = code.decode([1, 1, 1, 1])
        # x3 = 1, x2 = 1^1 = 0, x1 = 1^1 = 0, x0 = 1^0^0^1 = 0
        # Extract info bits from positions 2,3: [0, 1]
        assert result == [0, 1]

    def test_encode_decode_roundtrip(self) -> None:
        """Test that encode followed by decode returns original data."""
        code = PolarCode()
        original = [1, 0]
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_all_zeros(self) -> None:
        """Test encode/decode roundtrip with all zeros."""
        code = PolarCode()
        original = [0, 0]
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_all_ones(self) -> None:
        """Test encode/decode roundtrip with all ones."""
        code = PolarCode()
        original = [1, 1]
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_encode_decode_roundtrip_mixed(self) -> None:
        """Test encode/decode roundtrip with mixed bits."""
        code = PolarCode()
        original = [0, 1]
        encoded = code.encode(original)
        decoded = code.decode(encoded)
        assert decoded == original

    def test_custom_frozen_bits(self) -> None:
        """Test with custom frozen bit positions."""
        code = PolarCode(frozen_bits=[0, 2])
        result = code.encode([1, 0])
        # x = [0, 1, 0, 0] (frozen bits at 0,2 are 0, info bits at 1,3 are 1,0)
        # y0 = 0^1^0^0 = 1
        # y1 = 0^0 = 0
        # y2 = 1^0 = 1
        # y3 = 0
        assert result == [1, 0, 1, 0]
        
        decoded = code.decode([1, 0, 1, 0])
        # Extract info bits from positions 1,3: [1, 0]
        assert decoded == [1, 0] 