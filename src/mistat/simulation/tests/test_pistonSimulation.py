# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pandas as pd
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
        assert PistonSimulator.cycleTime(60, 0.02, 0.01, 5000, 110000, 296, 360) == pytest.approx(0.05589640114142739)
        assert PistonSimulator.cycleTime(60, 0.02, 0.01, 5000, 110000, 100000, 360) == pytest.approx(0.06773050714332678)
        assert PistonSimulator.cycleTime(60, 0.02, 0.01, 5000, 110000, 296, 3600) == pytest.approx(0.037228518689142114)
        assert PistonSimulator.cycleTime(70, 0.02, 0.01, 5000, 110000, 296, 360) == pytest.approx(0.057737003491984906)
        assert PistonSimulator.cycleTime(60, 0.2, 0.01, 5000, 110000, 296, 360) == pytest.approx(0.006329772978006459)

    def test_PistonSimulator(self):
        parameter = pd.DataFrame({
            'm': [30, 45, 60],
            's': [0.005, 0.0125, 0.02],
            'k': [1_000, 3_000, 5_000],
            't': [290, 293, 296],
            'p0': [90_000, 100_000, 110_000],
            'v0': [0.002, 0.006, 0.01],
            't0': [340, 350, 360],
        })
        simulator = PistonSimulator(parameter=parameter, seed=1236)
        result = simulator.simulate()
        assert list(result['m']) == [30, 45, 60]
        assert result.shape == (3, 9)

        simulator = PistonSimulator(parameter=parameter, n_replicate=2)
        result = simulator.simulate()
        assert list(result['m']) == [30, 30, 45, 45, 60, 60]
        assert result.shape == (6, 9)

        # we can provide additional parameters
        parameter = pd.DataFrame({
            's': [0.005, 0.0125, 0.02],
            'k': [1_000, 3_000, 5_000],
        })
        simulator = PistonSimulator(parameter=parameter, m=30)
        result = simulator.simulate()
        assert list(result['s']) == list(parameter['s'])
        assert list(result['k']) == list(parameter['k'])
        assert list(result['m']) == [30, 30, 30]
        assert result.shape == (3, 9)
