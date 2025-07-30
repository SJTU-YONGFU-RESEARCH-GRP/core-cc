"""Unit tests for crc_ecc module."""

from typing import TYPE_CHECKING

import pytest

from src.crc_ecc import CRC8

if TYPE_CHECKING:
    from _pytest.fixtures import FixtureRequest


class TestCRC8:
    """Test cases for CRC8 class."""

    def test_init_default(self) -> None:
        """Test initialization with default parameters."""
        crc = CRC8()
        assert crc.poly == 0x07
        assert crc.init == 0x00

    def test_init_custom(self) -> None:
        """Test initialization with custom parameters."""
        crc = CRC8(poly=0x1D, init=0xFF)
        assert crc.poly == 0x1D
        assert crc.init == 0xFF

    def test_compute_empty_data(self) -> None:
        """Test computing CRC for empty data."""
        crc = CRC8()
        result = crc.compute([])
        assert result == 0x00

    def test_compute_single_bit(self) -> None:
        """Test computing CRC for single bit."""
        crc = CRC8()
        result = crc.compute([1])
        # CRC-8 calculation for single bit 1
        assert result == 0x07

    def test_compute_multiple_bits(self) -> None:
        """Test computing CRC for multiple bits."""
        crc = CRC8()
        result = crc.compute([1, 0, 1, 0])
        # CRC-8 calculation for 1010
        assert result == 0x0E

    def test_compute_all_zeros(self) -> None:
        """Test computing CRC for all zeros."""
        crc = CRC8()
        result = crc.compute([0, 0, 0, 0])
        assert result == 0x00

    def test_compute_all_ones(self) -> None:
        """Test computing CRC for all ones."""
        crc = CRC8()
        result = crc.compute([1, 1, 1, 1])
        # CRC-8 calculation for 1111
        assert result == 0x0F

    def test_encode_empty_data(self) -> None:
        """Test encoding empty data."""
        crc = CRC8()
        result = crc.encode([])
        assert result == [0, 0, 0, 0, 0, 0, 0, 0]  # 8 zero CRC bits

    def test_encode_single_bit(self) -> None:
        """Test encoding single bit."""
        crc = CRC8()
        result = crc.encode([1])
        assert len(result) == 9  # 1 data bit + 8 CRC bits
        assert result[0] == 1  # Data bit
        assert result[1:] == [0, 0, 0, 0, 0, 1, 1, 1]  # CRC bits

    def test_encode_multiple_bits(self) -> None:
        """Test encoding multiple bits."""
        crc = CRC8()
        result = crc.encode([1, 0, 1, 0])
        assert len(result) == 12  # 4 data bits + 8 CRC bits
        assert result[:4] == [1, 0, 1, 0]  # Data bits
        # CRC bits for 1010
        assert result[4:] == [0, 0, 0, 0, 1, 1, 1, 0]

    def test_check_valid_codeword(self) -> None:
        """Test checking valid codeword."""
        crc = CRC8()
        data = [1, 0, 1, 0]
        encoded = crc.encode(data)
        assert crc.check(encoded) is True

    def test_check_invalid_codeword(self) -> None:
        """Test checking invalid codeword."""
        crc = CRC8()
        data = [1, 0, 1, 0]
        encoded = crc.encode(data)
        # Flip a bit to make it invalid
        encoded[0] = 1 - encoded[0]
        assert crc.check(encoded) is False

    def test_check_too_short(self) -> None:
        """Test checking codeword that's too short."""
        crc = CRC8()
        assert crc.check([1, 0, 1]) is False  # Only 3 bits, need at least 8

    def test_check_empty(self) -> None:
        """Test checking empty codeword."""
        crc = CRC8()
        assert crc.check([]) is False

    def test_encode_check_roundtrip(self) -> None:
        """Test that encode followed by check returns True."""
        crc = CRC8()
        data = [1, 0, 1, 0, 1, 0, 1, 0]
        encoded = crc.encode(data)
        assert crc.check(encoded) is True

    def test_encode_check_roundtrip_empty(self) -> None:
        """Test encode/check roundtrip with empty data."""
        crc = CRC8()
        data = []
        encoded = crc.encode(data)
        assert crc.check(encoded) is True

    def test_encode_check_roundtrip_all_zeros(self) -> None:
        """Test encode/check roundtrip with all zeros."""
        crc = CRC8()
        data = [0, 0, 0, 0]
        encoded = crc.encode(data)
        assert crc.check(encoded) is True

    def test_encode_check_roundtrip_all_ones(self) -> None:
        """Test encode/check roundtrip with all ones."""
        crc = CRC8()
        data = [1, 1, 1, 1]
        encoded = crc.encode(data)
        assert crc.check(encoded) is True

    def test_custom_polynomial(self) -> None:
        """Test with custom polynomial."""
        crc = CRC8(poly=0x1D)  # Different polynomial
        data = [1, 0, 1, 0]
        encoded = crc.encode(data)
        assert crc.check(encoded) is True

    def test_custom_initial_value(self) -> None:
        """Test with custom initial value."""
        crc = CRC8(init=0xFF)  # Different initial value
        data = [1, 0, 1, 0]
        encoded = crc.encode(data)
        assert crc.check(encoded) is True

    def test_error_detection_single_bit(self) -> None:
        """Test error detection for single bit flip."""
        crc = CRC8()
        data = [1, 0, 1, 0, 1, 0, 1, 0]
        encoded = crc.encode(data)
        # Flip each bit and verify error is detected
        for i in range(len(encoded)):
            corrupted = encoded.copy()
            corrupted[i] = 1 - corrupted[i]
            assert crc.check(corrupted) is False

    def test_crc_bits_extraction(self) -> None:
        """Test that CRC bits are correctly extracted and computed."""
        crc = CRC8()
        data = [1, 0, 1, 0]
        encoded = crc.encode(data)
        # Extract data and CRC bits
        data_bits = encoded[:-8]
        crc_bits = encoded[-8:]
        # Recompute CRC and compare
        computed_crc = crc.compute(data_bits)
        expected_crc_bits = [(computed_crc >> i) & 1 for i in reversed(range(8))]
        assert crc_bits == expected_crc_bits 