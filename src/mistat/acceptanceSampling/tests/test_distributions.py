'''
Created on Jun 16, 2020

@author: petergedeck
'''
import unittest

import pytest

from mistat.acceptanceSampling.distributions import getDistribution, OCtype


class TestData(unittest.TestCase):
    def test_binomial_distribution(self):
        oc2c = getDistribution(20, 3, OCtype.binomial)
        assert oc2c.paccept[oc2c.pd == 0.1] == pytest.approx(0.8670, 1e-3)
        assert oc2c.paccept[oc2c.pd == 0.15] == pytest.approx(0.6477, 1e-3)
        assert oc2c.paccept[oc2c.pd == 0.2] == pytest.approx(0.4114, 1e-3)
        assert oc2c.paccept[oc2c.pd == 0.25] == pytest.approx(0.2252, 1e-3)

        oc2c = getDistribution(20, 4, OCtype.binomial)
        assert oc2c.paccept[oc2c.pd == 0.1] == pytest.approx(0.9568, 1e-3)
        assert oc2c.paccept[oc2c.pd == 0.15] == pytest.approx(0.8298, 1e-3)
        assert oc2c.paccept[oc2c.pd == 0.2] == pytest.approx(0.6296, 1e-3)
        assert oc2c.paccept[oc2c.pd == 0.25] == pytest.approx(0.4148, 1e-3)


@pytest.mark.parametrize("n,c", [(20, 4), (10, 2), ])
def test_binomial_single_stage(n, c, num_regression):
    oc2c = getDistribution(n, c, OCtype.binomial)
    num_regression.check({'pd': oc2c.pd, 'paccept': oc2c.paccept})


# @pytest.mark.parametrize("n,c", [([30, 30], [4, 10]), ])
# def test_binomial_double_stage(n, c, num_regression):
#     oc2c = getDistribution(n, c, OCtype.binomial)
#     num_regression.check({'pd': oc2c.pd, 'paccept': oc2c.paccept})
