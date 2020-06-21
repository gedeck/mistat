'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
'''
import unittest

from mistat.data import load_data
from mistat.qcc.qualityControlChart import qcc_groups, QualityControlChart
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


class TestQualityControlChart(unittest.TestCase):
    def setUp(self):
        Ps = PistonSimulator(seed=1).simulate()
        Ps = simulationGroup(Ps, 5)
        self.cycleTime = qcc_groups(Ps['seconds'], Ps['group'])

    def test_xbar_chart(self):
        qcc = QualityControlChart(self.cycleTime)
        qcc = QualityControlChart(self.cycleTime, qcc_type='xbar')
        qcc = QualityControlChart(self.cycleTime, qcc_type='S')
        qcc = QualityControlChart(load_data('JANDEFECT'), qcc_type='p', sizes=100,
                                  center=0.048, std_dev=np.sqrt(0.048 * (1 - 0.048)))
        qcc = QualityControlChart(load_data('CONTACTLEN'), qcc_type='R')

    def test_S_chart(self):
        qcc = QualityControlChart(self.cycleTime, qcc_type='S')
