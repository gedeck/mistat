'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest
from pathlib import Path

import pandas as pd
import pytest

import mistat
from mistat.data import DATA_DIR, get_description_file


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

    def _test_data_description_exists(self):
        for name in Path(DATA_DIR).glob('*.Rd'):
            data_file = name.with_suffix('.csv.gz')
            assert data_file.exists()
        for name in Path(DATA_DIR).glob('*.csv.gz'):
            description_file = get_description_file(name.name)
            assert description_file.exists()

    def _test_describe_data(self):
        with pytest.raises(ValueError):
            mistat.describe_data('unknown data file')

        for name in ('CYCLT.csv.gz', 'CYCLT.csv', 'CYCLT'):
            text = mistat.describe_data(name)
            assert isinstance(text, str)
            assert 'Description' in text

        for name in Path(DATA_DIR).glob('*.csv.gz'):
            text = mistat.describe_data(name.name)
            assert isinstance(text, str)
            assert 'Description' in text

    def _test_prepare_Rd_HTML(self):
        for name in Path(DATA_DIR / 'Rd').glob('*.Rd'):
            name = name.with_suffix('').name
            print(f'Rd2HTML(file("{name}.Rd"), "{name}.html")')
        for name in Path(DATA_DIR / 'Rd').glob('*.Rd'):
            name = name.with_suffix('').name
            print(f'pandoc {name}.html -t rst -o {name}.rst')
        for name in Path(DATA_DIR / 'Rd').glob('*.Rd'):
            name = name.with_suffix('').name
            print(f'pandoc {name}.rst -t markdown -o {name}.md')

    def test_specialDatasets(self):
        data = mistat.load_data('PROCESS_SEGMENT')
        assert len(data['X']) == 1897
        assert len(data['Z']) == 1002
