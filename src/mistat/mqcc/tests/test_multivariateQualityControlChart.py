'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

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

        _ = MultivariateQualityControlChart(almpinSubset, qcc_type='T2single',
                                            center=center, cov=cov)
