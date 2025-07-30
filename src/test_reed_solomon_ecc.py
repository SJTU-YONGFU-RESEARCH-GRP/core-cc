from typing import TYPE_CHECKING
import pytest
from src.reed_solomon_ecc import ReedSolomonECC, RSConfig

if TYPE_CHECKING:
    from _pytest.capture import CaptureFixture
    from _pytest.fixtures import FixtureRequest
    from _pytest.logging import LogCaptureFixture
    from _pytest.monkeypatch import MonkeyPatch
    from pytest_mock.plugin import MockerFixture

reedsolo_installed = False
try:
    import reedsolo
    reedsolo_installed = True
except ImportError:
    pass

@pytest.mark.skipif(not reedsolo_installed, reason="reedsolo not installed")
def test_rs_ecc_encode_decode() -> None:
    """Test ReedSolomonECC encodes and decodes data correctly (if reedsolo is installed)."""
    config = RSConfig(n=15, k=11)
    ecc = ReedSolomonECC(config)
    data = 0x3A5
    codeword = ecc.encode(data)
    decoded, detected, corrected = ecc.decode(codeword)
    assert decoded == data 