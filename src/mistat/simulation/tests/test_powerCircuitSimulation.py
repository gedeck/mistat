'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
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
