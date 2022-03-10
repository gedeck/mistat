'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numpy as np
import pytest


def assertQCC(qcc, center, std_dev, limits):
    assert qcc.center == pytest.approx(center)
    assert qcc.std_dev == pytest.approx(std_dev)
    if qcc.limits.shape == (1, 2):
        np.testing.assert_allclose(qcc.limits, [limits], rtol=1e-5)
    else:
        np.testing.assert_allclose(qcc.limits[:len(limits)], limits, rtol=1e-5)


def assertQCCviolations(qcc, beyondLimits=None, violatingRuns=None):
    if beyondLimits is None:
        assert len(qcc.violations['beyondLimits']['UCL']) == 0
        assert len(qcc.violations['beyondLimits']['LCL']) == 0
    else:
        np.testing.assert_array_equal(qcc.violations['beyondLimits']['UCL'], beyondLimits['UCL'])
        np.testing.assert_array_equal(qcc.violations['beyondLimits']['LCL'], beyondLimits['LCL'])

    if violatingRuns is None:
        assert len(qcc.violations['violatingRuns']) == 0


def assertNewQCC(qcc, center, std_dev, limits):
    pass
