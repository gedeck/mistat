'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
'''
import unittest
from mistat.pistonSimulation import repeat_elements, PistonSimulator


class TestPistonSimulation(unittest.TestCase):
    def test_repeat_elements(self):
        assert list(repeat_elements(1, 10)) == [1] * 10
        assert list(repeat_elements([1], 10)) == [1] * 10
        assert list(repeat_elements([1, 2], 10)) == [*([1] * 10), *([2] * 10)]
        assert list(repeat_elements([1, 2, 3], 10)) == [*([1] * 10), *([2] * 10), *([3] * 10)]

    def test_PistonSimulator(self):
        simulator = PistonSimulator(seed=1)
