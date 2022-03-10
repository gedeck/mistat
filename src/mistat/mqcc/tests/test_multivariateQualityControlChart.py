'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
'''
import unittest

import pytest

from mistat.data import load_data
from mistat.mqcc.multivariateQualityControlChart import \
    MultivariateQualityControlChart


class TestMultivariateQualityControlChart(unittest.TestCase):
    def test_T2single_chart(self):
        almpin = load_data('ALMPIN')
        base = almpin.iloc[:30, ]
        almpinSubset = almpin.iloc[30:, ]

        center = base.mean()
        cov = base.cov()

        mqcc = MultivariateQualityControlChart(almpinSubset, qcc_type='T2single',
                                               center=center, cov=cov)
