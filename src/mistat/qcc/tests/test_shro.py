# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import numpy as np
import pytest

from mistat.qcc.shro import (runLengthShroNorm, runLengthShroPois,
                             shroArlPfaCedNorm, shroArlPfaCedPois)


class TestCusum(unittest.TestCase):
    def test_shroArlPfaCedNorm(self):
        x = [-1.0080707,  1.3549394, -0.4689749,  1.4681936,  0.4425564, 0.1462031,  0.1715031,
             0.5925072,  2.7647493, 0.6192188, 0.3945324, -1.6215868, -0.9459741, -0.9978776]

        res = runLengthShroNorm(x, 1, 1, 10, 1, 19)
        assert res['rl'] == 9
        assert len(res['w']) == 9
        assert res['w'][0] is None
        for e1, e2 in zip(res['w'][1:], [2.344282e-01, 3.469896e-09, 7.275562e-01, 4.415837e-05, 1.319939e-06, 1.699855e-06, 1.145011e-04, 3.110184e+05]):
            assert e1 == pytest.approx(e2)

        res = runLengthShroPois(x, 1.001, 1, 0.58)
        assert res['rl'] == 7
        assert len(res['w']) == 7
        assert res['w'][0] is None
        for e1, e2 in zip(res['w'][1:], [0.3683780, 0.5031622, 0.5537946, 0.5718620, 0.5783402, 0.5807385]):
            assert e1 == pytest.approx(e2)

        res = runLengthShroPois(x, 1.001, 0.9, 0.58)
        assert res['rl'] == 4
        assert len(res['w']) == 4
        assert res['w'][0] is None
        for e1, e2 in zip(res['w'][1:], [0.4071206, 0.5718245, 0.6399946]):
            assert e1 == pytest.approx(e2)

        res = runLengthShroPois(x, 11 / 6, 1, 19)
        assert res['rl'] == np.inf
        assert len(res['w']) == 14
        assert res['w'][0] is None
        for e1, e2 in zip(res['w'][1:], [0.8363378, 0.5083987, 1.3511733, 1.1310696, 0.8566233, 0.7578374, 0.9260974, 3.7859976, 2.5626072,  1.6646799, 0.3668443, 0.2834033, 0.25786117291]):
            assert e1 == pytest.approx(e2)

        res = shroArlPfaCedNorm(seed=1, N=10, verbose=False)['statistic']
        assert res['ARL'] == pytest.approx(135.0)
        assert res['Std. Error'] == pytest.approx(40.54873)

        res = shroArlPfaCedNorm(seed=1, N=10, mean0=10, tau=10, verbose=False)['statistic']
        assert res['ARL'] == pytest.approx(10.7)
        assert res['Std. Error'] == pytest.approx(0.51088159)
        assert res['PFA'] == pytest.approx(0.1)
        assert res['CED'] == pytest.approx(1.22222222)
        assert res['CED-Std. Error'] == pytest.approx(3.72107039)

    def test_shroArlPfaCedPois(self):
        x = [12, 8, 15, 13, 11, 10, 8, 10, 17, 16,
             89, 85, 120, 98, 109, 110, 93, 85, 98, 109]
        res = runLengthShroPois(x, 1.1, 1, 19)
        assert res['rl'] == 10

        x = [7, 7, 6, 22, 16, 11, 11, 16, 9, 12,
             112, 121, 95, 98, 114, 103, 99, 97, 86, 105]
        res = runLengthShroPois(x, 1.1, 1, 19)
        assert res['rl'] == 8

        res = shroArlPfaCedPois(seed=1, verbose=False)['statistic']
        assert res['ARL'] == pytest.approx(24.79)
        assert res['Std. Error'] == pytest.approx(1.570178)

        res = shroArlPfaCedPois(seed=1, tau=10, lambda1=100, verbose=False)['statistic']
        assert res['ARL'] == pytest.approx(10.89)
        assert res['Std. Error'] == pytest.approx(0.044486, abs=0.0001)
        assert res['PFA'] == pytest.approx(0.03)
        assert res['CED'] == pytest.approx(0.958763)
        assert res['CED-Std. Error'] == pytest.approx(1.108611)
