# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest

from mistat.simulation.pistonSimulation import (PistonSimulator,
                                                uniformSumDistribution)


class TestPistonSimulation(unittest.TestCase):
    def test_uniformSumDistribution(self):
        for size in range(1, 10):
            rvs = uniformSumDistribution(size=size)
            assert len(rvs) == size
            assert all(0 <= rv <= 1 for rv in rvs)

        for size in range(1, 10):
            rvs = uniformSumDistribution(size=size, left=-3, right=0)
            assert len(rvs) == size
            assert all(-3 <= rv <= 0 for rv in rvs)

    def test_cycleTime(self):
        assert PistonSimulator.cycleTime(60, 0.02, 0.01, 5000, 110000, 296, 360) == pytest.approx(0.3859461)
        assert PistonSimulator.cycleTime(60, 0.02, 0.01, 5000, 110000, 100000, 360) == pytest.approx(0.4813737)
        assert PistonSimulator.cycleTime(60, 0.02, 0.01, 5000, 110000, 296, 3600) == pytest.approx(0.2260668)
        assert PistonSimulator.cycleTime(70, 0.02, 0.01, 5000, 110000, 296, 360) == pytest.approx(0.4168694)
        assert PistonSimulator.cycleTime(60, 0.2, 0.01, 5000, 110000, 296, 360) == pytest.approx(0.06090253)
        assert PistonSimulator.cycleTime(60, 0.2, 0.01, 5000, 110000, 296, 360) == pytest.approx(0.06090253)

    def test_PistonSimulator(self):
        s = [0.005] * 100
        s.extend([0.01] * 100)
        s.extend([0.02] * 100)

        simulator = PistonSimulator(seed=1, s=s)

        result = simulator.simulate()
        return result
#         plt.scatter(x=result.index, y=result.seconds)
#         plt.show()
#
#         np.random.seed(0)
#         t = [296] * 35
#         t.extend([296 * np.power(1.1, k) for k in range(1, 66)])
#         simulator = PistonSimulator(t=t, check=False, seed=1236)
#         result = simulator.simulate()
#         print(result)
#
#         plt.scatter(x=result.index, y=result.seconds)
#         plt.show()
