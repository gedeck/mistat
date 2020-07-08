'''
Created on Jun 22, 2020

@author: petergedeck
'''
import unittest

from scipy import stats
import pytest

from mistat.qcc.cusum import cusumArl, cusumPfaCed
from mistat.qcc.ewmaChart import ewmaSmooth
import mistat
import numpy as np


class TestCusum(unittest.TestCase):
    def test_ewmaSmooth(self):
        smoothed = ewmaSmooth([1, 2, 3, 4])
        np.testing.assert_array_almost_equal(smoothed['y'], [1.000, 1.200, 1.560, 2.048])

        smoothed = ewmaSmooth([1, 2, 3, 4], x=[2, 3, 4, 1])
        np.testing.assert_array_almost_equal(smoothed['x'], [1, 2, 3, 4])
        np.testing.assert_array_almost_equal(smoothed['y'], [4, 3.4, 3.12, 3.096])

        smoothed = ewmaSmooth([1, 2, 3, 4], smooth=0.8)
        np.testing.assert_array_almost_equal(smoothed['y'], [1, 1.8, 2.76, 3.752])

        smoothed = ewmaSmooth([1, 2, 3, 4], start=10)
        np.testing.assert_array_almost_equal(smoothed['y'], [8.2, 6.96, 6.168, 5.7344])
