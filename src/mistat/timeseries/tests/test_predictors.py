'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import numpy as np

from mistat import load_data
from mistat.timeseries.predictors import (dlmLinearGrowth, masPredictor,
                                          normRandomWalk,
                                          optimalLinearPredictor, predictARMA,
                                          quadraticPredictor, simulateARMA)


class TestPredictors(unittest.TestCase):
    def test_optimalLinearPredictor(self):
        res = optimalLinearPredictor([1.1, 2.1, 3.1, 1.2, 2.2, 3.2, 1.3, 2.3, 3.3], 5, nlags=3)
        np.testing.assert_allclose(res, np.array(
            [1.1000000, 2.1000000, 3.1000000, 1.2000000, 2.2000000, 0.0849863,
             -2.5097180, -2.0452979, 0.5629472]), rtol=1e-4)

        dow1941 = load_data('DOW1941.csv')
        _ = optimalLinearPredictor(dow1941, 20, nlags=10)

    def test_quadraticPredictor(self):
        res = quadraticPredictor([1.1, 2.1, 3.1, 1.2, 2.2, 3.2, 1.3, 2.3, 3.3], 5, 1)
        np.testing.assert_allclose(res, np.array(
            [1.1,  2.1, 3.1,  1.2,  2.2,  0.88, 4.2,  1.72, 0.98]), rtol=1e-4)
        dow1941 = load_data('DOW1941.csv')
        _ = optimalLinearPredictor(dow1941, 20, 1)

    def test_masPredictor(self):
        res = masPredictor([1.1, 2.1, 3.1, 1.2, 2.2, 3.2, 1.3, 2.3, 3.3, 1.4, 2.4, 3.4], 4, 1)
        np.testing.assert_allclose(res, np.array(
            [1.1, 2.1, 3.1, 1.2, 2.2, 3.2, 1.3, 2.3, 3.3, 2.85, 2.158333, 2.191667]), rtol=1e-4)

    def test_normRandomWalk(self):
        res = normRandomWalk(4, 3, 1, 0, seed=1)
        np.testing.assert_allclose(res.X, np.array(
            [0.564752, -0.762263, -2.024801,  2.387944]), rtol=1e-4)
        np.testing.assert_allclose(res.predicted, np.array(
            [0., -0.314335, -1.044987,  0.437968]), rtol=1e-4)

    def test_dlmLinearGrowth(self):
        C0 = np.array([[0.22325, -0.00668], [-0.00668, 0.00032]])
        W = np.array([[0.3191, -0.0095], [-0.0095, 0.0004]])
        M0 = np.array([134.234, -0.3115])

        X = list(range(1, 10))
        res = dlmLinearGrowth(X, C0, 3, W, M0)
        np.testing.assert_allclose(res, np.array(
            [133.92250, 114.85984, 94.59632,  76.92095,  62.98001,
             52.58327,  45.10165,  39.87351,  36.33951]), rtol=1e-4)

    def test_predictARMA(self):
        a = [0.5, 0.3, 0.1]
        b = [0.3, 0.5]

        ts = simulateARMA(10, a, b, seed=1)
        np.testing.assert_allclose(np.array(ts), np.array(
            [0.551377,  1.877997, -1.817121,  2.195474, -0.865066,  1.184173,
             - 0.263695,  2.029245, -1.534557,  0.27871, -1.02427,  1.006496,
             - 1.27203]), rtol=1e-4)
        prediction = predictARMA(ts, a)
        np.testing.assert_allclose(np.array(prediction), np.array(
            [0.551377,  1.877997, -1.817121, -0.290024,  0.7404,  0.044397,
             0.552114,  0.136897,  1.053931, -0.184875, -0.118088, -0.581978,
             0.223838]), rtol=1e-4)
