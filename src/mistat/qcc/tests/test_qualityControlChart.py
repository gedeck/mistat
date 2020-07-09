'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
'''
import unittest

import pytest

from mistat.data import load_data
from mistat.qcc.qualityControlChart import qcc_groups, QualityControlChart,\
    qcc_overdispersion_test
from mistat.simulation.mistatSimulation import simulationGroup
from mistat.simulation.pistonSimulation import PistonSimulator
import numpy as np


def test_qcc_groups(num_regression):
    Ps = PistonSimulator(seed=1).simulate()
    Ps = simulationGroup(Ps, 5)

    result = qcc_groups(Ps['seconds'], Ps['group'])
    num_regression.check({f'row_{i}': r for i, r in enumerate(result)})


def test_qcc_groups_missing_values():
    result = qcc_groups([1, 2, 2, 3, 3, 3, 4, 4, 4, 4], [1, 2, 2, 3, 3, 3, 4, 4, 4, 4])
    expect = np.array([[1.0, np.NaN, np.NaN, np.NaN],
                       [2.0, 2.0, np.NaN, np.NaN],
                       [3.0, 3.0, 3.0, np.NaN],
                       [4.0, 4.0, 4.0, 4.0]])
    np.testing.assert_array_equal(result, expect)


class TestQCCOverdispersionTest(unittest.TestCase):
    def test_exceptions(self):
        with pytest.raises(ValueError):
            qcc_overdispersion_test([1, 2, 3], dist='binomial')
        with pytest.raises(ValueError):
            qcc_overdispersion_test([1, 2, 3], sizes=[1, 2])
        with pytest.raises(ValueError):
            qcc_overdispersion_test([1, 2, 3], sizes=[1, 2, 3], dist='typo')

    def test_results(self):
        # data from Wetherill and Brown (1991) pp. 212--213, 216--218:
        x = [12, 11, 18, 11, 10, 16, 9, 11, 14, 15, 11, 9, 10, 13, 12,
             8, 12, 13, 10, 12, 13, 16, 12, 18, 16, 10, 16, 10, 12, 14]

        sizes = [50] * len(x)
        result = qcc_overdispersion_test(x, sizes)
        assert result['Overdispersion test'] == 'binomial'
        assert result['Obs.Var/Theor.Var'] == pytest.approx(0.7644566)
        assert result['Statistic'] == pytest.approx(22.16924)
        assert result['p-value'] == pytest.approx(0.8131149)

        x = [11, 8, 13, 11, 13, 17, 25, 23, 11, 16, 9, 15, 10, 16, 12,
             8, 9, 15, 4, 12, 12, 12, 15, 17, 14, 17, 12, 12, 7, 16]
        result = qcc_overdispersion_test(x)
        assert result['Overdispersion test'] == 'poisson'
        assert result['Obs.Var/Theor.Var'] == pytest.approx(1.472203)
        assert result['Statistic'] == pytest.approx(42.69388)
        assert result['p-value'] == pytest.approx(0.048579, rel=1e-5)


class TestQualityControlChart(unittest.TestCase):
    def setUp(self):
        Ps = PistonSimulator(seed=1).simulate()
        Ps = simulationGroup(Ps, 5)
        self.cycleTime = qcc_groups(Ps['seconds'], Ps['group'])

    def test_xbar_chart(self):
        _ = QualityControlChart(self.cycleTime)
        _ = QualityControlChart(self.cycleTime, qcc_type='xbar')
        _ = QualityControlChart(self.cycleTime, qcc_type='S')
        _ = QualityControlChart(load_data('JANDEFECT'), qcc_type='p', sizes=100,
                                center=0.048, std_dev=np.sqrt(0.048 * (1 - 0.048)))
        _ = QualityControlChart(load_data('CONTACTLEN'), qcc_type='R')

    def test_S_chart(self):
        _ = QualityControlChart(self.cycleTime, qcc_type='S')
