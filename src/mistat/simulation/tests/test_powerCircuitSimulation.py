# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest

from mistat.simulation.powerCircuitSimulation import PowerCircuitSimulation


class TestPowerCircuitSimulation(unittest.TestCase):

    def test_PowerCircuitSimulation(self):
        simulator = PowerCircuitSimulation(seed=1)
        result = simulator.simulate()
        assert result.shape == (50, 14)
        assert result['volts'].mean() == pytest.approx(229.610782)
        assert result['volts'].std() == pytest.approx(3.495034)
