from typing import TYPE_CHECKING
import pytest
from src.composite_ecc import CompositeECC
from src.parity_ecc import ParityECC
from src.system_ecc import SystemSECDEDECC

if TYPE_CHECKING:
    from _pytest.capture import CaptureFixture
    from _pytest.fixtures import FixtureRequest
    from _pytest.logging import LogCaptureFixture
    from _pytest.monkeypatch import MonkeyPatch
    from pytest_mock.plugin import MockerFixture

def test_composite_ecc_encode_decode() -> None:
    """Test that CompositeECC (Parity + SystemSECDEDECC) encodes and decodes 8-bit data correctly with no errors."""
    ecc = CompositeECC([ParityECC(), SystemSECDEDECC()])
    data = 0x3C
    codeword = ecc.encode(data)
    decoded, detected, corrected = ecc.decode(codeword)
    assert decoded == data
    assert not detected
    assert not corrected

def test_composite_ecc_single_bit_error() -> None:
    """Test that CompositeECC detects and corrects a single-bit error in the codeword."""
    ecc = CompositeECC([ParityECC(), SystemSECDEDECC()])
    data = 0x7F
    codeword = ecc.encode(data)
    # The codeword length is 14 (1 parity + 12 hamming + 1 system parity)
    for bit in range(14):
        corrupted = ecc.inject_error(codeword, bit)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected
        # Only correctable if not the outermost system parity bit
        if bit != 13:
            assert corrected
            assert decoded == data
        else:
            # System parity bit error: detected but not correctable
            assert not corrected

def test_composite_ecc_double_bit_error() -> None:
    """Test that CompositeECC detects but does not correct double-bit errors."""
    ecc = CompositeECC([ParityECC(), SystemSECDEDECC()])
    data = 0x55
    codeword = ecc.encode(data)
    corrupted = ecc.inject_error(codeword, 0)
    corrupted = ecc.inject_error(corrupted, 1)
    decoded, detected, corrected = ecc.decode(corrupted)
    assert detected
    assert not corrected 