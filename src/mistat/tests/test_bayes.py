'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest

from mistat import bayes


class TestBayes(unittest.TestCase):

    def test_updateBetaMixture(self):
        betaMixture = bayes.Mixture(
            probabilities=[0.5, 0.5],
            distributions=[
                bayes.BetaDistribution(a=1, b=1),
                bayes.BetaDistribution(a=15, b=2),
            ]
        )
        data = [10, 2]
        result = bayes.updateBetaMixture(betaMixture, data)
        assert result.probabilities[0] == pytest.approx(0.2845528)
        assert result.probabilities[1] == pytest.approx(0.7154472)
        assert result.distributions[0] == bayes.BetaDistribution(a=11, b=3)
        assert result.distributions[1] == bayes.BetaDistribution(a=25, b=4)
        assert result.distributions[0].theta() == pytest.approx(0.7857142)
        assert result.distributions[1].theta() == pytest.approx(0.86206896)

        betaMixture = bayes.Mixture(
            probabilities=[0.5, 0.25, 0.25],
            distributions=[
                bayes.BetaDistribution(a=1, b=1),
                bayes.BetaDistribution(a=15, b=2),
                bayes.BetaDistribution(a=2, b=22),
            ]
        )
        result = bayes.updateBetaMixture(betaMixture, data)
        assert result.probabilities[0] == pytest.approx(0.4430337)
        assert result.probabilities[1] == pytest.approx(0.5569567)
        assert result.probabilities[2] == pytest.approx(0.0000096, abs=1e-6)

    def test_updateGammaMixture(self):
        mixture = bayes.Mixture(
            probabilities=[0.5, 0.5],
            distributions=[
                bayes.GammaDistribution(shape=1, rate=1),
                bayes.GammaDistribution(shape=15, rate=2),
            ]
        )
        data = {'y': [5], 't': [1]}
        result = bayes.updateGammaMixture(mixture, data)
        assert result.distributions[0] == bayes.GammaDistribution(shape=6, rate=2)
        assert result.distributions[1] == bayes.GammaDistribution(shape=20, rate=3)
        assert result.probabilities[0] == pytest.approx(0.1250978)
        assert result.probabilities[1] == pytest.approx(0.8749022)

        data = {'y': [5, 3], 't': [1, 2]}
        result = bayes.updateGammaMixture(mixture, data)
        assert result.distributions[0] == bayes.GammaDistribution(shape=9, rate=4)
        assert result.distributions[1] == bayes.GammaDistribution(shape=23, rate=5)
        assert result.probabilities[0] == pytest.approx(0.8127316)
        assert result.probabilities[1] == pytest.approx(0.1872684)

        mixture = bayes.Mixture(
            probabilities=[0.5, 0.25, 0.25],
            distributions=[
                bayes.GammaDistribution(shape=1, rate=1),
                bayes.GammaDistribution(shape=15, rate=2),
                bayes.GammaDistribution(shape=10, rate=3),
            ]
        )
        result = bayes.updateGammaMixture(mixture, data)
        assert result.probabilities[0] == pytest.approx(0.33694729)
        assert result.probabilities[1] == pytest.approx(0.03881946)
        assert result.probabilities[2] == pytest.approx(0.62423325)
