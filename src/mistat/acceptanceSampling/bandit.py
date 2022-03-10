# pylint: disable=too-many-arguments,too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from collections import namedtuple
from functools import lru_cache

import numpy as np
from scipy import stats

# N = 10
# p = 0.95
# al = 0.5
# k = 10
# gam = 0.95
# Ns = 1000

Stats = namedtuple('Stats', 'mean,std')
SimulateOABResult = namedtuple('SimulateOABResult', 'mgamma,reward')
OptimalOABResult = namedtuple('OptimalOABResult', 'max_reward,rewards')

# Use a cache to save results of call to the beta.cdf function
# to speed up calculations


@lru_cache(maxsize=500)
def cachedBetaCDF(al, a, b):
    return stats.beta.cdf(al, a, b)


def simulateOAB(N, p, al, k, gam, Ns, seed=None):
    if seed is not None:
        np.random.seed(seed)
    res = []
    for _ in range(Ns):
        n = k
        X = stats.binom.rvs(k, p)
        for n in range(k, N + 1):
            prob = cachedBetaCDF(al, X + 1, n + 1 - X)
            if prob > gam:
                break
            X = X + stats.binom.rvs(1, p)
        res.append([n, X + (N - n) * al])
    res = np.array(res)
    means = np.mean(res, axis=0)
    std = np.std(res, axis=0)
    return SimulateOABResult(Stats(means[0], std[0]), Stats(means[1], std[1]))


def optimalOAB(N, al):
    '''
    N= Number of trials; al= Known probability of success in arm A.
    Output: Table of maximal predicted rewards
    '''
    reward = np.zeros([N, N + 1])
    for X in range(N + 1):
        if X < al * (N + 1) - 1:
            reward[0, X] = al
        else:
            reward[0, X] = (X + 1) / (N + 1)
    for j in range(1, N):
        n = N + 1 - (j + 1)
        for i in range(1, n + 2):
            X = i - 1
            cr1 = (X + 1) * reward[j - 1, X + 1] / (N - j + 1)
            cr2 = (N - j - X) * reward[j - 1, X] / (N - j + 1)
            cr3 = (X + 1) / (N - j + 1)
            cr = cr1 + cr2 + cr3
            if cr < al * (j + 1):
                reward[j, i - 1] = al * (j + 1)
            else:
                reward[j, i - 1] = cr

    return OptimalOABResult((reward[N - 1, 0] + reward[N - 1, 1]) / 2, reward)


def optimalOAB2(N, lambda_):
    ''' vectorized version of optimalOAB2 '''
    reward = np.zeros([N, N + 1])
    maxreward = lambda_
    X = np.arange(0, N + 1)
    rho = (X + 1) / (N + 1)
    rho = np.maximum(maxreward, rho)
    reward[0, :] = rho
    for n in range(1, N):
        # calculate the components of rho
        maxreward = lambda_ * (n + 1)
        cr1 = (X[:-1] + 1) / (N - n + 1) * rho[1:]
        cr2 = (N - n - X[:-1]) / (N - n + 1) * rho[:-1]
        cr3 = (X[:-1] + 1) / (N - n + 1)
        # calculate the new rho
        rho = np.maximum(maxreward, cr1 + cr2 + cr3)
        reward[n, :len(rho)] = rho
        # for next iteration, shorten vector X
        X = X[:-1]
    return OptimalOABResult((reward[N - 1, 0] + reward[N - 1, 1]) / 2, reward)
