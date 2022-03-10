'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from collections import namedtuple

import numpy as np
from scipy import stats


def runsTest(sequence, cutoff=None, alternative=None, verbose=False):
    if alternative is None:
        alternative = 'two.sided'

    if alternative not in ['two.sided', 'less', 'greater']:
        raise ValueError("specify alternative as 'two.sided', 'less', or 'greater'")
    # convert sequence to binary if cutoff is given
    x = np.array(sequence)
    if cutoff is not None:
        x = np.array([0 if xi < cutoff else 1 for xi in x])

    if len(set(x)) != 2:
        raise ValueError('sequence must contain only two values or must be converted to binary sequence using cutoff')
    if cutoff is None:
        cutoff = np.mean([np.min(x), np.max(x)])

    n1 = np.sum(np.min(x) == x)
    n2 = np.sum(np.max(x) == x)
    runs = 1 + np.sum(x[1:] != x[:-1])

    runs_exp = 1 + (2 * n1 * n2) / (n1 + n2)
    std = np.sqrt(2 * n1 * n2 * (2 * n1 * n2 - n1 - n2) /
                  ((n1 + n2)**2 * (n1 + n2 - 1)))

    Z = (runs - runs_exp) / std

    if alternative == 'two.sided':
        pval = 2 * stats.norm.cdf(-abs(Z))
    elif alternative == 'less':
        pval = stats.norm.cdf(Z)
    elif alternative == 'greater':
        pval = stats.norm.cdf(-Z)

    Result = namedtuple('Result', 'statistic,pval,method,alternative')
    result = Result(Z, pval, 'Runs Test', alternative)
    if verbose:
        print(f"""
{result.method}

Standard Normal = {result.statistic:.4f}, p-value = {result.pval:.4f}
alternative hypothesis: {result.alternative}""")
    return result
