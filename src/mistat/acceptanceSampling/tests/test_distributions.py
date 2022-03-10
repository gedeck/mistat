# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import numpy as np
import pytest

from mistat.acceptanceSampling.distributions import (OCbinomial, OChypergeom,
                                                     OCtype, getDistribution)


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

    def test_binomial_probAcc(self):
        assert OCbinomial.probAcc([1, 2], [10, 12], 0.1) == pytest.approx(0.3444672)
        assert OCbinomial.probAcc([1, 5], [10, 12], 0.25) == pytest.approx(0.1774998)
        np.testing.assert_array_almost_equal(OCbinomial.probAcc([1, 5], [10, 12], np.array([0.1, 0.2])),
                                             np.array([0.3872108, 0.2632264]))


class TestOCHypergeom(unittest.TestCase):
    def test_hypergeom_probAcc(self):
        assert OChypergeom.probAcc([1, 2], [10, 12], 125, 10) == pytest.approx(0.376087)
        assert OChypergeom.probAcc([1, 2, 5], [10, 12, 20], 125, 10) == pytest.approx(0.07371569)
        assert OChypergeom.probAcc([1, 2, 5], [10, 12, 20], 125, 40) == pytest.approx(0.002046853)

    def test_hypergeom_distribution(self):
        oc2c = getDistribution(10, 1, OCtype.hypergeom, N=5000, pd=np.linspace(0, 0.5, 21))
        np.testing.assert_array_almost_equal(oc2c.paccept, [1, 0.975531233150589, 0.914026229653252, 0.83052374109046, 0.736137830133243, 0.638849517510688, 0.544170956192379, 0.455698286327905, 0.375567792473322, 0.304828550133649,
                                                            0.243743408520266, 0.192028907519683, 0.149043566052743, 0.113932903128113, 0.0857385588181598, 0.0634779669660759, 0.0462001915277595, 0.0330227709175732, 0.0231537164209124, 0.0159021785157568, 0.0106807256671937])
        oc2c = getDistribution(10, 1, OCtype.hypergeom, N=5000, pd=np.linspace(0, 0.5, 21))
        np.testing.assert_array_almost_equal(oc2c.paccept, [1, 0.975531233150589, 0.914026229653252, 0.83052374109046, 0.736137830133243, 0.638849517510688, 0.544170956192379, 0.455698286327905, 0.375567792473322, 0.304828550133649, 0.243743408520266,
                                                            0.192028907519683, 0.149043566052743, 0.113932903128113, 0.0857385588181598, 0.0634779669660759, 0.0462001915277595, 0.0330227709175732, 0.0231537164209124, 0.0159021785157568, 0.0106807256671937])
        oc2c = getDistribution([10, 20], [1, 5], OCtype.hypergeom, N=5000, pd=np.linspace(0, 0.5, 21))
        np.testing.assert_array_almost_equal(oc2c.paccept, [1, 0.999946400743018, 0.997806530968874, 0.984699631567982, 0.947920693155973, 0.87999995872212, 0.7833226237847, 0.668187451479102, 0.547781629538997, 0.433676388479504,
                                                            0.333473086092754, 0.250521174426616, 0.184870363976067, 0.134600559996131, 0.0969814990050931, 0.0692468066760604, 0.0489905569778074, 0.034293332185809, 0.0236971539161794, 0.016119864359922, 0.0107620776974874])
        oc2c = getDistribution([10, 20, 30], [1, 5, 15], OCtype.hypergeom, r=[
                               8, 12, 16], N=5000, pd=np.linspace(0, 0.5, 21))
        np.testing.assert_array_almost_equal(oc2c.paccept, [1, 0.999999999992312, 0.999999976469845, 0.999995413222941, 0.99984706553206, 0.998199835839852, 0.989195843370176, 0.959467068211535, 0.892311806740834, 0.779773785315839,
                                                            0.631867264439061, 0.473114786362103, 0.329471194306573, 0.216812392002181, 0.138033839596371, 0.087288443710228, 0.0559728851075519, 0.0366708053931196, 0.0244076567026864, 0.0163054754959801, 0.0108042224096666])


class TestOCPoisson(unittest.TestCase):
    def test_poisson_distribution(self):
        oc2c = getDistribution(20, 3, OCtype.poisson, pd=[0.1, 0.2])
        np.testing.assert_array_almost_equal(oc2c.paccept, [0.857123460498547, 0.433470120366709])

        oc2c = getDistribution([20, 30], [3, 6], OCtype.poisson, pd=[0.1, 0.2])
        np.testing.assert_array_almost_equal(oc2c.paccept, [0.903091232247863, 0.448546932597166])

        oc2c = getDistribution([20, 30, 40], [3, 6, 10], OCtype.poisson, r=[11, 11, 11], pd=[0.1, 0.2])
        np.testing.assert_array_almost_equal(oc2c.paccept, [0.924443754350073, 0.450503223016181])


@pytest.mark.parametrize("n,c", [(20, 4), (10, 2), ])
def test_binomial_single_stage(n, c, num_regression):
    oc2c = getDistribution(n, c, OCtype.binomial)
    num_regression.check({'pd': oc2c.pd, 'paccept': oc2c.paccept})


# @pytest.mark.parametrize("n,c", [([30, 30], [4, 10]), ])
# def test_binomial_double_stage(n, c, num_regression):
#     oc2c = getDistribution(n, c, OCtype.binomial)
#     num_regression.check({'pd': oc2c.pd, 'paccept': oc2c.paccept})
