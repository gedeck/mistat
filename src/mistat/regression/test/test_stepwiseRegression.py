'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

from mistat import load_data
from mistat.regression import stepwise_regression


class TestBayes(unittest.TestCase):

    def test_stepwise_regression(self):
        gasol = load_data('GASOL')
        gasol = gasol.rename(columns={'yield': 'Yield'})

        outcome = 'Yield'
        all_vars = set(gasol.columns)
        all_vars.remove(outcome)

        include, _ = stepwise_regression(outcome, all_vars, gasol, verbose=False)

        formula = ' + '.join(sorted(include))
        formula = f'{outcome} ~ 1 + {formula}'
        assert formula == 'Yield ~ 1 + astm + endPt + x1'
