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


def runStatistics(data):
    """ determine expected and observed number of run directions """

    # number of runs
    mean_ct = np.mean(data)
    runs = [1 if ct > mean_ct else 0 for ct in data]
    obs_R = 0
    current = None
    for r in runs:
        if r != current:
            obs_R += 1
            current = r

    m1 = sum(data > mean_ct)
    m2 = sum(data <= mean_ct)
    n = m1 + m2
    resultRuns = {
        'count': {
            'mu_R': 1 + 2 * m1 * m2 / (m1 + m2),
            'sigma_R': np.sqrt(2 * m1 * m2 * (2*m1*m2-n)/(n*n*(n-1))),
            'observed': obs_R,
        }
    }

    # determine direction of change up (1) or down (-1)
    n = len(data)
    directions = [1 if xi < xip1 else -1 for xi, xip1 in zip(data[:-1], data[1:])]
    mu_Rstar = (2*n-1)/3
    sigma_Rstar = np.sqrt((16*n-29)/90)

    # count number of up and down runs
    up = 0
    down = 0
    current = None
    for direction in directions:
        if direction == current:  # no change of direction
            continue
        if direction < 0:
            down += 1
        else:
            up += 1
        current = direction
    Rstar = up + down
    alpha = stats.norm.cdf((Rstar - mu_Rstar) / sigma_Rstar)
    return {
        **resultRuns,
        'direction': {
            'mu_Rstar': mu_Rstar,
            'sigma_Rstar': sigma_Rstar,
            'up': up,
            'down': down,
            'Rstar': Rstar,
            'alpha': sorted([alpha, 1 - alpha])
        }
    }
