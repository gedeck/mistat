'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import numpy as np
import pandas as pd
import pytest

from mistat.data import load_data
from mistat.qcc.qualityControlChart import (QualityControlChart, qcc_groups,
                                            qcc_overdispersion_test)
from mistat.simulation.mistatSimulation import simulationGroup
from mistat.simulation.pistonSimulation import PistonSimulator


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

    def test_p_chart(self):
        abc = load_data('ABC')
        equipment = ['q6', 'q7', 'q8', 'q9']
        support = ['q12', 'q13', 'q14', 'q15', 'q16']
        top5counts = (abc[equipment + support] == 5).sum()
        _ = QualityControlChart(top5counts[equipment], qcc_type='np', sizes=len(abc))

    def test_np_chart(self):
        data = pd.Series([18, 14,  9, 25, 27, 18, 21, 16, 18, 24, 20, 19, 22, 22, 20,
                          38, 29, 35, 24, 20, 23, 17, 20, 19, 17, 16, 10,  8, 10,  9])
        qcc = QualityControlChart(data, qcc_type='np', sizes=1000)
        assert qcc.center == 19.6
        assert qcc.std_dev == pytest.approx(4.383588)
        assert qcc.limits.LCL[0] == pytest.approx(6.449237)
        assert qcc.limits.UCL[0] == pytest.approx(32.750763)

        # 1/0
