from typing import Tuple
from base_ecc import ECCBase

class LDPCECC(ECCBase):
    """LDPC ECC using pyldpc for prototyping. Uses default SNR=10 for encoding."""
    def __init__(self, n: int = 16, d_v: int = 2, d_c: int = 4) -> None:
        """
        Args:
            n (int): Codeword length.
            d_v (int): Variable node degree.
            d_c (int): Check node degree.
        """
        try:
            import pyldpc
            self.pyldpc = pyldpc
            self.H, self.G = pyldpc.make_ldpc(n, d_v, d_c, systematic=True, sparse=True)
        except ImportError:
            self.pyldpc = None

    def encode(self, data: int, snr: float = 10.0) -> int:
        """
        Encode data using LDPC.

        Args:
            data (int): Data as integer.
            snr (float): Signal-to-noise ratio for pyldpc.encode (default 10.0).

        Returns:
            int: Encoded codeword as integer.
        """
        if self.pyldpc is None:
            raise NotImplementedError("pyldpc is required for LDPC ECC.")
        import numpy as np
        k = self.G.shape[1]
        data_bits = np.array([int(x) for x in f"{data:0{k}b}"], dtype=int)
        codeword = self.pyldpc.encode(self.G, data_bits, snr)
        # Threshold to get binary (0 or 1)
        binary_codeword = [int(x > 0) for x in codeword]
        return int("".join(str(b) for b in binary_codeword), 2)

    def decode(self, codeword: int) -> Tuple[int, bool, bool]:
        """
        Decode LDPC codeword.

        Args:
            codeword (int): Codeword as integer.

        Returns:
            Tuple[int, bool, bool]: (decoded_data, error_detected, error_corrected)
        """
        if self.pyldpc is None:
            raise NotImplementedError("pyldpc is required for LDPC ECC.")
        import numpy as np
        n = self.H.shape[1]
        y = np.array([int(x) for x in f"{codeword:0{n}b}"], dtype=int)
        decoded = self.pyldpc.decode(self.H, y, snr=10.0, maxiter=10)
        data = int("".join(str(int(x)) for x in decoded), 2)
        return data, True, True

    def inject_error(self, codeword: int, bit_idx: int) -> int:
        """
        Flip the bit at bit_idx in the codeword.

        Args:
            codeword (int): The codeword to corrupt.
            bit_idx (int): The bit index to flip.

        Returns:
            int: The corrupted codeword.
        """
        return codeword ^ (1 << bit_idx) 