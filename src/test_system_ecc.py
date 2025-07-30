from typing import TYPE_CHECKING
import pytest
from src.system_ecc import SystemSECDEDECC

if TYPE_CHECKING:
    from _pytest.capture import CaptureFixture
    from _pytest.fixtures import FixtureRequest
    from _pytest.logging import LogCaptureFixture
    from _pytest.monkeypatch import MonkeyPatch
    from pytest_mock.plugin import MockerFixture

def test_system_ecc_encode_decode() -> None:
    """Test that SystemSECDEDECC encodes and decodes 8-bit data correctly with no errors."""
    ecc = SystemSECDEDECC()
    data = 0xA5
    codeword = ecc.encode(data)
    decoded, detected, corrected = ecc.decode(codeword)
    assert decoded == data
    assert not detected
    assert not corrected

def test_system_ecc_single_bit_error() -> None:
    """Test that SystemSECDEDECC detects and corrects a single-bit error."""
    ecc = SystemSECDEDECC()
    data = 0x5A
    codeword = ecc.encode(data)
    # Inject error in one bit
    for bit in range(13):
        corrupted = ecc.inject_error(codeword, bit)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected
        # Only correctable if not system parity bit
        if bit != 12:
            assert corrected
            assert decoded == data
        else:
            # System parity bit error: detected but not correctable
            assert not corrected

def test_system_ecc_double_bit_error() -> None:
    """Test that SystemSECDEDECC detects but does not correct double-bit errors."""
    ecc = SystemSECDEDECC()
    data = 0x3C
    codeword = ecc.encode(data)
    # Flip two bits
    corrupted = ecc.inject_error(codeword, 0)
    corrupted = ecc.inject_error(corrupted, 1)
    decoded, detected, corrected = ecc.decode(corrupted)
    assert detected
    assert not corrected 