# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import numpy as np
import pandas as pd

from mistat.mqcc.statistics import (MQCCStatistics, T2_statistic,
                                    T2single_statistic)


class Test_mqccStatistics(unittest.TestCase):
    array_1 = np.array([[1, 2, 3], [1, 2, np.NaN]])
    array_2 = np.array([[1, 2, 3], [1, 2, 7]])

    def setUp(self):
        self.mqccStatistics = MQCCStatistics()
        unittest.TestCase.setUp(self)

    def test_default_statistic(self):
        assert self.mqccStatistics.default == 't2'

        for statistic in self.mqccStatistics:
            assert hasattr(statistic, 'description'), statistic.qcc_type

    def test_T2_statistic(self):
        data = {
            'X1': np.array([[72, 56, 55, 44, 97, 83, 47, 88, 57, 26, 46, 49, 71, 71, 67, 55, 49, 72, 61, 35],
                            [84, 87, 73, 80, 26, 89, 66, 50, 47, 39, 27, 62, 63, 58, 69, 63, 51, 80, 74, 38],
                            [79, 33, 22, 54, 48, 91, 53, 84, 41, 52, 63, 78, 82, 69, 70, 72, 55, 61, 62, 41],
                            [49, 42, 60, 74, 58, 62, 58, 69, 46, 48, 34, 87, 55, 70, 94, 49, 76, 59, 57, 46]]),
            'X2': np.array([[23, 14, 13, 9, 36, 30, 12, 31, 14, 7, 10, 11, 22, 21, 18, 15, 13, 22, 19, 10],
                            [30, 31, 22, 28, 10, 35, 18, 11, 10, 11, 8, 20, 16, 19, 19, 16, 14, 28, 20, 11],
                            [28, 8, 6, 15, 14, 36, 14, 30, 8, 35, 19, 27, 31, 17, 18, 20, 16, 18, 16, 13],
                            [10, 9, 16, 25, 15, 18, 16, 19, 10, 30, 9, 31, 15, 20, 35, 12, 26, 17, 14, 16]]),
        }
        data = {k: np.transpose(v) for k, v in data.items()}

        T2 = self.mqccStatistics.get('T2')
        assert isinstance(T2, T2_statistic)
        assert T2.qcc_type == 't2'

        result = T2.stats(data)
        np.testing.assert_array_almost_equal(result.statistics[:3],  [2.2416049, 0.6526961, 1.2721838])
        np.testing.assert_array_almost_equal(result.center.values[0], [60.375, 18.4875])
        np.testing.assert_array_almost_equal(result.cov, [[222.033333, 103.116667], [103.116667, 56.579167]])

        result = T2.limits(20, 4, 2, (1 - 0.0027) ** 2)
        np.testing.assert_array_almost_equal(result['control'].values[0],  [0, 11.03975666295])
        np.testing.assert_array_almost_equal(result['prediction'].values[0],  [0, 12.201836])

    def test_T2single_statistic(self):
        data = pd.DataFrame({
            't1': [507, 512, 520, 520, 530, 528, 522, 527, 533, 530, 530, 527, 529, 522, 532, 531, 535, 516, 514, 536, 522, 520, 526, 527, 529],
            't2': [516, 513, 512, 514, 515, 516, 513, 509, 514, 512, 512, 513, 514, 509, 515, 514, 514, 515, 510, 512, 514, 514, 517, 514, 518],
            't3': [527, 533, 537, 538, 542, 541, 537, 537, 528, 538, 541, 541, 542, 539, 545, 543, 542, 537, 532, 540, 540, 540, 546, 543, 544],
            't4': [516, 518, 518, 516, 525, 524, 518, 521, 529, 524, 525, 523, 525, 518, 528, 525, 530, 515, 512, 526, 518, 518, 522, 523, 525],
            't5': [499, 502, 503, 504, 504, 505, 503, 504, 508, 507, 507, 506, 506, 501, 507, 507, 509, 501, 497, 509, 497, 501, 502, 502, 504],
            't6': [512, 510, 512, 517, 512, 514, 512, 508, 512, 512, 511, 512, 512, 510, 511, 511, 511, 516, 512, 512, 514, 514, 516, 512, 516],
            't7': [472, 476, 480, 480, 481, 482, 479, 478, 482, 482, 482, 481, 481, 476, 481, 482, 483, 476, 471, 482, 475, 475, 477, 475, 479],
            't8': [477, 475, 477, 479, 477, 480, 477, 472, 477, 477, 476, 476, 477, 475, 478, 477, 477, 481, 476, 477, 478, 478, 480, 476, 481]
        })

        T2 = self.mqccStatistics.get('T2single')
        assert isinstance(T2, T2single_statistic)
        assert T2.qcc_type == 't2single'

        result = T2.stats(data)
        np.testing.assert_array_equal(result.means, data)
        np.testing.assert_array_almost_equal(
            result.center, [525.00, 513.56, 538.92, 521.68, 503.80, 512.44, 478.72, 477.24])
        np.testing.assert_array_almost_equal(result.statistics[:3], [13.963962, 9.779084, 5.472671])

        result = T2.limits(len(data), 1, 8, 0.999)
        np.testing.assert_array_almost_equal(result['control'].values[0],  [0, 17.417047])
        np.testing.assert_array_almost_equal(result['prediction'].values[0],  [0, 70.029432])
