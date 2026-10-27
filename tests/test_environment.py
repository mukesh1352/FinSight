import sys

import numpy as np
import pandas as pd


def test_python_version():
    """Verify the project runs on Python 3.12."""
    assert sys.version_info.major == 3
    assert sys.version_info.minor == 12


def test_pandas_dataframe_creation():
    """Verify pandas can create and process transaction data."""
    transactions = pd.DataFrame(
        {
            "transaction_id": ["T001", "T002"],
            "amount": [250.0, 180.0],
        }
    )

    assert len(transactions) == 2
    assert transactions["amount"].sum() == 430.0


def test_numpy_sum():
    """Verify NumPy numerical operations work."""
    amounts = np.array([250.0, 180.0, 60.0])

    assert amounts.sum() == 490.0
