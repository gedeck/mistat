'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest
from pathlib import Path

import numpy as np
import pandas as pd

from mistat.qcc.qualityControlChart import QualityControlChart, qcc_groups
from mistat.qcc.rules import run_length_encoding


class TestRules(unittest.TestCase):
    def test_shewhartRules(self):
        #         qcc = QualityControlChart(load_data('JANDEFECT'), qcc_type='np', sizes=100)
        #         print(qcc.violations)

        out = [idx - 1 for idx in [9, 10, 30, 35, 45, 64, 65, 74, 75, 85, 99, 100]]
        pistonrings = pd.read_csv(Path(__file__).parent / 'data' / 'pistonrings.csv')
        pistonrings = pistonrings.drop(pistonrings.index[out])
        diameter = qcc_groups(pistonrings['diameter'], pistonrings['sample'])
        _ = QualityControlChart(diameter, qcc_type='xbar', center=74, std_dev=0.0098)

    def test_run_length_encoding(self):
        assert run_length_encoding('abbccc') == [(1, 'a'), (2, 'b'), (3, 'c')]
        assert run_length_encoding('abbcccaaaaa') == [(1, 'a'), (2, 'b'), (3, 'c'), (5, 'a')]
        assert run_length_encoding([]) == []
        np.testing.assert_array_equal(run_length_encoding('abbccc', as_list=True), [1, 2, 2, 3, 3, 3])
