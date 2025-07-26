from typing import TYPE_CHECKING
import pytest
from src.bch_ecc import BCH_ECC, BCHConfig

if TYPE_CHECKING:
    from _pytest.capture import CaptureFixture
    from _pytest.fixtures import FixtureRequest
    from _pytest.logging import LogCaptureFixture
    from _pytest.monkeypatch import MonkeyPatch
    from pytest_mock.plugin import MockerFixture

bchlib_installed = False
try:
    import bchlib
    bchlib_installed = True
except ImportError:
    pass

@pytest.mark.skipif(not bchlib_installed, reason="bchlib not installed")
def test_bch_ecc_encode_decode() -> None:
    """Test BCH_ECC encodes and decodes data correctly (if bchlib is installed)."""
    config = BCHConfig(n=15, k=7, t=2)
    ecc = BCH_ECC(config)
    data = 0x5A
    codeword = ecc.encode(data)
    decoded, detected, corrected = ecc.decode(codeword)
    assert decoded == data

@pytest.mark.skipif(not bchlib_installed, reason="bchlib not installed")
def test_bch_ecc_single_bit_error() -> None:
    """Test BCH_ECC detects and corrects a single-bit error."""
    config = BCHConfig(n=15, k=7, t=2)
    ecc = BCH_ECC(config)
    data = 0x33
    codeword = ecc.encode(data)
    for bit in range(15):
        corrupted = ecc.inject_error(codeword, bit)
        decoded, detected, corrected = ecc.decode(corrupted)
        assert detected
        assert corrected
        assert decoded == data 