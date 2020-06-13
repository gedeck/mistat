'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
'''
from pathlib import Path
import unittest

import pytest

from mistat.data import DATA_DIR, get_description_file, convert_R_description
import mistat
import pandas as pd


class TestData(unittest.TestCase):
    def test_load_data(self):
        with pytest.raises(ValueError):
            mistat.load_data('unknown data file')

        for name in ('CYCLT.csv.gz', 'CYCLT.csv', 'CYCLT'):
            data = mistat.load_data(name)
            assert isinstance(data, pd.Series)

    def test_load_data_all(self):
        for name in Path(DATA_DIR).glob('*.csv.gz'):
            data = mistat.load_data(name.name)
            assert isinstance(data, (pd.Series, pd.DataFrame))
            assert len(data.shape) <= 2
            if len(data.shape) == 1:
                assert isinstance(data, pd.Series)
            else:
                assert isinstance(data, pd.DataFrame)
                assert data.shape[1] > 1

    def test_data_description_exists(self):
        for name in Path(DATA_DIR).glob('*.Rd'):
            data_file = name.with_suffix('.csv.gz')
            assert data_file.exists()
        for name in Path(DATA_DIR).glob('*.csv.gz'):
            description_file = get_description_file(name.name)
            assert description_file.exists()

    def test_convert_R_description(self):
        for name in Path(DATA_DIR).glob('*.Rd'):
            convert_R_description(name.name)
            break
