'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import pytest

from mistat.acceptanceSampling.bandit import (optimalOAB, optimalOAB2,
                                              simulateOAB)


class TestBandit(unittest.TestCase):

    def test_simulateOAB(self):
        result = simulateOAB(50, 0.4, 0.5, 10, 0.95, 100, seed=1)
        assert result.reward.mean == 22.215
        assert result.mgamma.mean == 31.57

    def test_optimalOAB(self):
        result = optimalOAB(10, 0.5)
        assert result.rewards[-1, 0] == pytest.approx(5.823719)
        assert result.max_reward == pytest.approx(0.5 * (5.823719 + 10))

        result = optimalOAB(50, 0.5)
        assert result.max_reward == pytest.approx(40.17491)

        result = optimalOAB2(10, 0.5)
        assert result.rewards[-1, 0] == pytest.approx(5.823719)
        assert result.max_reward == pytest.approx(0.5 * (5.823719 + 10))

        result = optimalOAB2(50, 0.5)
        assert result.max_reward == pytest.approx(40.17491)
