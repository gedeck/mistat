# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest

from mistat.simulation import PistonSimulator, simulationGroup
from mistat.simulation.mistatSimulation import repeat_elements


class TestPistonSimulation(unittest.TestCase):
    def test_repeat_elements(self):
        assert list(repeat_elements(1, 10)) == [1] * 10
        assert list(repeat_elements([1], 10)) == [1] * 10
        assert list(repeat_elements([1, 2], 10)) == [*([1] * 10), *([2] * 10)]
        assert list(repeat_elements([1, 2, 3], 10)) == [*([1] * 10), *([2] * 10), *([3] * 10)]

    def test_simulationGroup(self):
        simulator = PistonSimulator(seed=1)

        with pytest.raises(ValueError):
            simulationGroup(simulator, 10)

        simulation_result = simulator.simulate()
        assert simulation_result.shape == (50, 9)
        assert 'group' in simulation_result

        for group_size, expected_length in (7, 49), (2, 50), (3, 48), (25, 50), (40, 40), (1, 50):
            grouped = simulationGroup(simulation_result, group_size, quiet=True)
            assert grouped.shape == (expected_length, 9)
            assert 'group' in grouped
            group_values = grouped['group'].value_counts()
            assert set(group_values.index) == set(range(1, expected_length // group_size + 1))
            assert all(count == group_size for count in group_values)
