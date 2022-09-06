'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest

import mistat
from mistat import runStatistics, runsTest


class TestRunsTest(unittest.TestCase):

    def test_runsTest(self):
        x = mistat.load_data('RNORM10')
        x = [0 if xi < 10 else 1 for xi in x]

        assert runsTest(x, alternative='less').statistic == pytest.approx(-0.35956, rel=1e-5)
        assert runsTest(x, alternative='less').pval == pytest.approx(0.3596, rel=1e-4)
        assert runsTest(x).pval == pytest.approx(0.7192, rel=1e-4)
        assert runsTest(x, alternative='greater').pval == pytest.approx(0.6404, rel=1e-4)

    def test_runStatistics(self):
        x = [-1.00, -0.75, -0.50, 1.00, .050, -0.25, 0.00, 0.25, -0.25, 1.00, 0.50, 0.25, -0.75]
        result = runStatistics(x)
        runCount = result['count']
        assert runCount['mu_R'] == pytest.approx(7.46153846, rel=1e-4)
        assert runCount['sigma_R'] == pytest.approx(1.71488436, rel=1e-4)
        assert runCount['observed'] == 7
        runDirection = result['direction']
        assert runDirection['mu_Rstar'] == pytest.approx(8.3333, rel=1e-4)
        assert runDirection['sigma_Rstar'] == pytest.approx(1.41027, rel=1e-4)
        assert runDirection['up'] == 3
        assert runDirection['down'] == 3
        assert runDirection['Rstar'] == 6

        data = mistat.load_data('YARNSTRG')
        result = runStatistics(data)
        runCount = result['count']
        assert runCount['mu_R'] == pytest.approx(50.92, rel=1e-4)
        assert runCount['sigma_R'] == pytest.approx(4.96664266823, rel=1e-4)
        assert runCount['observed'] == 49
        runDirection = result['direction']
        assert runDirection['mu_Rstar'] == pytest.approx(66.33, rel=1e-4)
        assert runDirection['sigma_Rstar'] == pytest.approx(4.1779846)
        assert runDirection['alpha'][0] == pytest.approx(0.2883, rel=1e-3)
