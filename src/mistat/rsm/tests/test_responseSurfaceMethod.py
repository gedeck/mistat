'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest
from pathlib import Path

import numpy as np
import pandas as pd
import pytest
import statsmodels.formula.api as smf

from mistat.rsm.responseSurfaceMethod import ResponseSurfaceMethod


class TestResponseSurfaceMethod(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data1 = loadModel('simulationData1.csv')
        cls.data2 = loadModel('simulationData2.csv')

    def test_function(self):
        model = self.data1['model']
        codes = self.data1['codes']
        rsm = ResponseSurfaceMethod(model, codes)
        assert rsm.f([0, 0, 0, 0]) == pytest.approx(0.559, abs=0.001)
        assert rsm.f([1.260, -1.244, 0.870, 0.318]) == pytest.approx(0.415, abs=0.001)

        model = self.data2['model']
        codes = self.data2['codes']
        rsm = ResponseSurfaceMethod(model, codes)
        assert rsm.f([0, 0, 0, 0]) == pytest.approx(0.586, abs=0.001)
        assert rsm.f([1.808, -0.167, 0.449, -0.705]) == pytest.approx(0.406, abs=0.001)

    def test_stationary(self):
        model = self.data1['model']
        codes = self.data1['codes']
        rsm = ResponseSurfaceMethod(model, codes)
        np.testing.assert_allclose(rsm.stationary_point(), np.array(
            [-10.642838, 2.957658, 3.660820, -2.299632]), rtol=1e-4)

        model = self.data2['model']
        codes = self.data2['codes']
        rsm = ResponseSurfaceMethod(model, codes)
        np.testing.assert_allclose(rsm.stationary_point(), np.array(
            [-1.1969668, 0.9320400, 2.2297196, 0.4233004]), rtol=1e-4)

    def test_eigen(self):
        model = self.data1['model']
        codes = self.data1['codes']
        rsm = ResponseSurfaceMethod(model, codes)

        # first test the complex eigenvalues
        eigen = rsm._eigen()  # pylint: disable=protected-access
        ev = sorted(eigen['eval'].real, reverse=True)
        np.testing.assert_allclose(ev, np.array(
            [0.034424442, 0.008661927, 0.003316576, -0.001943580]), rtol=1e-4)
        ev = sorted(ev.imag for ev in eigen['eval'])
        np.testing.assert_allclose(ev, np.zeros(4), rtol=1e-4)

        # nowtest the sorted real eigenvalues/vectors
        eigen = rsm.eigen()
        np.testing.assert_allclose(eigen['eval'], np.array(
            [0.034424442, 0.008661927, 0.003316576, -0.001943580]), rtol=1e-4)
        evec1 = eigen['evec'][:, 0]
        if evec1[0] < 0:
            evec1 = -evec1
        np.testing.assert_allclose(evec1, np.array(
            [0.2722108, 0.2597354, 0.9261707, 0.0254271]), rtol=1e-4)


def loadModel(filename):
    factors = {
        's': [0.01, 0.015],
        'v0': [0.00625, 0.00875],
        'k': [2000, 4000],
        't0': [345, 355],
    }
    result = pd.read_csv(Path(__file__).parent / filename)
    # calculate mean and std of response by group
    result = result.groupby(by='group')
    result = result.agg({'s': 'mean', 'v0': 'mean', 'k': 'mean',
                         't0': 'mean', 'seconds': ['mean', 'std']})
    result.columns = ['s', 'v0', 'k', 't0', 'Ymean', 'Ystd']

    # transformation between factors and code levels
    factor2x = {factor: f'x{i}' for i, factor in enumerate(factors, 1)}
    x2factor = {f'x{i}': factor for i, factor in enumerate(factors, 1)}
    center = {factor: 0.5 * (max(values) + min(values)) for factor, values in factors.items()}
    unit = {factor: 0.5 * (max(values) - min(values)) for factor, values in factors.items()}

    # # define helper function to convert code co-ordinates to factor co-ordinates
    # def toFactor(code, codeValue):
    #     ''' convert code to factor co-ordinates '''
    #     factor = x2factor[code]
    #     return center[factor] + codeValue * unit[factor]

    # add code levels to table
    for c in factors:
        result[factor2x[c]] = (result[c] - center[c]) / unit[c]
    formula = ('Ymean ~ (x1+x2+x3+x4)**2 + ' +
               'np.power(x1,2) + np.power(x2,2) + np.power(x3,2) + np.power(x4,2)')
    return {'codes': list(x2factor), 'model': smf.ols(formula, data=result).fit()}


class TestRSMpackage(unittest.TestCase):
    def test_RidgeRisingSituation(self):
        data = pd.DataFrame({
            'x1': [-1, 1, -1, 1, -1, 1, 0, 0, 0, 0, 0],
            'x2': [-1, -1, 1, 1, 0, 0, -1, 1, 0, 0, 0],
            'Response': [52.3, 5.3, 46.7, 44.2, 58.5, 33.5, 32.8, 49.2, 49.3, 50.2, 51.6],
        })
        codes = ['x1', 'x2']
        model = smf.ols('Response ~ (x1 + x2)**2 + np.power(x1,2) + np.power(x2,2)', data=data).fit()
        rsm = ResponseSurfaceMethod(model, codes)
        np.testing.assert_allclose(rsm.stationary_point(),
                                   np.array([-5.176505, -2.706733]), rtol=1e-4)
        eigen = rsm.eigen()
        np.testing.assert_allclose(eigen['eval'],
                                   np.array([-0.509419, -12.706370]), rtol=1e-4)
        np.testing.assert_allclose(eigen['evec'][:, 0],
                                   np.array([0.8396245, 0.5431673]), rtol=1e-4)
        np.testing.assert_allclose(eigen['evec'][:, 1],
                                   np.array([-0.5431673, 0.8396245]), rtol=1e-4)

        path = rsm.constrainedOptimization(start=(0, 0), distances=(0.5, 1))
        np.testing.assert_allclose(path['y'],
                                   np.array([50.263158, 55.556944, 58.742308]), rtol=1e-4)
