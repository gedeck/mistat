'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest

import mistat
from mistat import runsTest


class TestRunsTest(unittest.TestCase):

    def test_runsTest(self):
        x = mistat.load_data('RNORM10')
        x = [0 if xi < 10 else 1 for xi in x]

        assert runsTest(x, alternative='less').statistic == pytest.approx(-0.35956, rel=1e-5)
        assert runsTest(x, alternative='less').pval == pytest.approx(0.3596, rel=1e-4)
        assert runsTest(x).pval == pytest.approx(0.7192, rel=1e-4)
        assert runsTest(x, alternative='greater').pval == pytest.approx(0.6404, rel=1e-4)
