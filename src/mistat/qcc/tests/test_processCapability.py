# pylint: disable=too-many-arguments
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import io
import unittest
from contextlib import redirect_stdout
from pathlib import Path

import numpy as np
import pandas as pd
import pytest

from mistat.qcc.processCapability import ProcessCapability
from mistat.qcc.qualityControlChart import QualityControlChart, qcc_groups
from mistat.qcc.tests.utilities import assertQCC


class TestProcessCapability(unittest.TestCase):
    def test_ProcessCapability(self):
        pistonrings = pd.read_csv(Path(__file__).parent / 'data' / 'pistonrings.csv')
        diameter = qcc_groups(pistonrings['diameter'], pistonrings['sample'])
        data = diameter[:25, ]

        qcc = QualityControlChart(data, qcc_type='xbar')
        assertQCC(qcc, 74.00118, 0.009785039, [73.98805, 74.0143])

        pc = ProcessCapability(qcc, [73.95, 74.05])
        assertPC(pc, 125, 74.00118, 0.009785039, [73.95, 74.05], 3)
        expected = {
            'Cp': (1.703, 1.491, 1.915),
            'Cp_l': (1.743, 1.555, 1.932),
            'Cp_u': (1.663,  1.483, 1.844),
            'Cp_k': (1.663, 1.448, 1.878),
            'Cpm': (1.691, 1.480, 1.902),
        }
        assertPCindices(pc, expected)

        pc = ProcessCapability(qcc, [73.95, 74.05], target=74.02)
        assertPC(pc, 125, 74.00118, 0.009785039, [73.95, 74.05], 3, target=74.02)
        expected = {
            'Cp': (1.703, 1.491, 1.915),
            'Cp_l': (1.743, 1.555, 1.932),
            'Cp_u': (1.663,  1.483, 1.844),
            'Cp_k': (1.663, 1.448, 1.878),
            'Cpm': (0.7856, 0.6556, 0.9154),
        }
        assertPCindices(pc, expected)
        assert pc.exp_LSL == pytest.approx(0, abs=1e-4)
        assert pc.exp_USL == pytest.approx(0, abs=1e-4)
        assert pc.obs_LSL == pytest.approx(0, abs=1e-4)
        assert pc.obs_USL == pytest.approx(0, abs=1e-4)

        pc = ProcessCapability(qcc, [73.99, 74.01])
        assertPC(pc, 125, 74.00118, 0.009785039, [73.99, 74.01], 3)
        expected = {
            'Cp': (0.3407, 0.2983, 0.3830),
            'Cp_l': (0.3807, 0.3176, 0.4439),
            'Cp_u': (0.3006, 0.2424, 0.3588),
            'Cp_k': (0.3006, 0.2312, 0.3700),
            'Cpm': (0.3382, 0.2960, 0.3804),
        }
        assertPCindices(pc, expected)
        assert pc.exp_LSL == pytest.approx(13, abs=0.5)
        assert pc.exp_USL == pytest.approx(18, abs=0.5)
        assert pc.obs_LSL == pytest.approx(12, abs=0.5)
        assert pc.obs_USL == pytest.approx(16, abs=0.5)

        pc = ProcessCapability(qcc, [73.99, 74.1])
        assertPC(pc, 125, 74.00118, 0.009785039, [73.99, 74.1], 3)
        expected = {
            'Cp': (1.8736,  1.6406, 2.1063),
            'Cp_l': (0.3807, 0.3176,  0.4439),
            'Cp_u': (3.3665, 3.0115,  3.7215),
            'Cp_k': (0.3807,  0.3055,  0.4559),
            'Cpm': (0.4083,  0.3377, 0.4788),
        }
        assertPCindices(pc, expected)
        assert pc.exp_LSL == pytest.approx(13, abs=0.5)
        assert pc.exp_USL == pytest.approx(0, abs=0.5)
        assert pc.obs_LSL == pytest.approx(12, abs=0.5)
        assert pc.obs_USL == pytest.approx(0, abs=0.5)

    def test_ProcessCapability_summary(self):
        pistonrings = pd.read_csv(Path(__file__).parent / 'data' / 'pistonrings.csv')
        diameter = qcc_groups(pistonrings['diameter'], pistonrings['sample'])
        data = diameter[:25, ]

        qcc = QualityControlChart(data, qcc_type='xbar')
        assertQCC(qcc, 74.00118, 0.009785039, [73.98805, 74.0143])

        pc = ProcessCapability(qcc, [73.99, 74.01])
        f = io.StringIO()
        with redirect_stdout(f):
            pc.summary()
        s = f.getvalue()
        assert 'Exp<LSL' in s
        assert '18%' in s
        assert 'Capability indices:' in s
        assert 'Target =' in s
        assert '74.00' in s


def assertPC(pc, nobs, center, std_dev, limits, nsigmas, target=None):
    assert pc.nobs == nobs
    assert pc.center == pytest.approx(center)
    assert pc.std_dev == pytest.approx(std_dev)
    np.testing.assert_allclose(pc.spec_limits, [limits], rtol=1e-5)
    assert pc.target == (target or np.mean(limits))
    assert pc.nsigmas == nsigmas


def assertPCindices(pc, expected):
    for key in expected:
        assert getattr(pc, key) == pytest.approx(expected[key][0], rel=5e-4), key
        k = f'{key}_limits'
        np.testing.assert_allclose(getattr(pc, k),
                                   expected[key][1:], rtol=5e-4, err_msg=k)
