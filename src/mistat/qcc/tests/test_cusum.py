'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest
from scipy import stats

from mistat.qcc.cusum import cusumArl, cusumPfaCed


class TestCusum(unittest.TestCase):
    def test_cusumArl(self):
        arl = cusumArl(randFunc=stats.norm(), N=100, limit=10000, seed=1, verbose=False)
        assert arl['statistic']['ARL'] == pytest.approx(1013.86)
        assert arl['statistic']['Std. Error'] == pytest.approx(148.36833)

        arl = cusumArl(randFunc=stats.norm(loc=0.5), N=100, limit=10000, seed=1, verbose=False)
        assert arl['statistic']['ARL'] == pytest.approx(101.88)
        assert arl['statistic']['Std. Error'] == pytest.approx(13.180037)

        arl = cusumArl(randFunc=stats.norm(loc=1.0), N=100, limit=10000, seed=1, verbose=False)
        assert arl['statistic']['ARL'] == pytest.approx(16.91)
        assert arl['statistic']['Std. Error'] == pytest.approx(2.171727)

        arl = cusumArl(randFunc=stats.norm(loc=1.5), N=100, limit=10000, seed=1, verbose=False)
        assert arl['statistic']['ARL'] == pytest.approx(5.82)
        assert arl['statistic']['Std. Error'] == pytest.approx(0.6506919)

    def test_cusumArl_inf(self):
        arl = cusumArl(randFunc=stats.binom(n=100, p=0.05), N=100, limit=2000, seed=3,
                       kp=5.95, km=3.92, hp=12.87, hm=-8.66, verbose=False)
        assert arl['statistic']['ARL'] == pytest.approx(414.16161)
        assert arl['statistic']['Std. Error'] == pytest.approx(58.66780)

    def test_cusumPfaCed(self):
        cusumPfaCed(randFunc1=stats.norm(), randFunc2=stats.norm(loc=1),
                    tau=100, N=100, limit=1_000, seed=1, verbose=False)
        # TODO:  write asserts
