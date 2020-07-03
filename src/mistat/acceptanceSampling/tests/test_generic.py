'''
Created on Jun 26, 2020

@author: petergedeck
'''
import unittest

from mistat.acceptanceSampling.generic import findPlan, Plan
import numpy as np
import pandas as pd


class TestGeneric(unittest.TestCase):
    def test_findPlan(self):
        result = findPlan(PRP=(0.01, 0.05), CRP=(0.08, 0.05), oc_type="hypergeom", N=100)
        assert result == Plan(31, 0, 1)

        p0 = np.array([*[0.01] * 10, *[0.03] * 10])
        pt = np.linspace(0.05, 0.32, 10)
        pt = np.array([*pt, *pt])

        result = []
        for p0i, pti in zip(p0, pt):
            result.append([p0i, pti, *findPlan(PRP=(p0i, 0.05), CRP=(pti, 0.05), oc_type="hypergeom", N=100)])
        result = pd.DataFrame(result, columns=['p0', 'pt', 'n', 'c', 'r'])
        np.testing.assert_array_equal(result['n'], [45, 31, 23, 18, 15, 13, 11, 10, 9, 8] * 2)
        np.testing.assert_array_equal(result['c'], [0] * 20)

        result = []
        for p0i, pti in zip(p0, pt):
            result.append([p0i, pti, *findPlan(PRP=(p0i, 0.1), CRP=(pti, 0.2), oc_type="hypergeom", N=100)])
        result = pd.DataFrame(result, columns=['p0', 'pt', 'n', 'c', 'r'])
        np.testing.assert_array_equal(result['n'], [27, 18, 13, 11, 9, 7, 6, 6, 5, 5] * 2)
        np.testing.assert_array_equal(result['c'], [0] * 20)

        result = []
        for p0i, pti in zip(p0, pt):
            result.append([p0i, pti, *findPlan(PRP=(p0i, 0.5), CRP=(pti, 0.3), oc_type="hypergeom", N=100)])
        result = pd.DataFrame(result, columns=['p0', 'pt', 'n', 'c', 'r'])
        np.testing.assert_array_equal(result['n'], [21, 14, 10, 8, 7, 6, 5, 4, 4, 4, 42, 14, 10, 8, 7, 6, 5, 4, 4, 4])
        np.testing.assert_array_equal(result['c'], [*[0] * 10, 1, *[0] * 9])
