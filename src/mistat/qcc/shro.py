# pylint: disable=too-many-arguments
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck

ARL, PFA and CED of Shiryayev-Roberts procedure
'''
import numpy as np
import pandas as pd
from scipy import stats


def shroArlPfaCedNorm(mean0=0, mean1=None, sd=1, n=10, delta=1, tau=None,
                      N=100, limit=10000, seed=None, w=19, verbose=True):
    np.random.seed(seed)

    if delta is None:
        delta = (mean1 - mean0) / sd
    if mean1 is None:
        mean1 = mean0 + delta * sd

    randFunc0 = stats.norm(loc=mean0, scale=sd / np.sqrt(n))
    randFunc1 = stats.norm(loc=mean1, scale=sd / np.sqrt(n))

    rls = []
    for _ in range(N):
        if tau is None:
            x = randFunc0.rvs(limit)
        else:
            x = np.concatenate([randFunc0.rvs(tau), randFunc1.rvs(limit - tau)])
        rls.append(runLengthShroNorm(x, mean0, sd, n, delta, w)['rl'])
    result = {'rls': rls}

    rls = np.ma.masked_invalid(rls)
    result['statistic'] = {
        'ARL': np.mean(rls),
        'Std. Error': np.sqrt((np.mean(rls ** 2) - np.mean(rls) ** 2) / N),
    }
    if tau is not None:
        pfa = np.mean(rls < tau)
        ced = np.mean(rls[rls >= tau]) - tau
        se = np.sqrt(
            (np.sum(rls[rls >= tau] ** 2) / (N - np.sum(rls < tau)) - ced ** 2)
            /
            (N - np.sum(rls < tau)))
        result['statistic']['PFA'] = pfa
        result['statistic']['CED'] = ced
        result['statistic']['CED-Std. Error'] = se

    if verbose:
        print(pd.Series(result['statistic']))
    return result


def runLengthShroNorm(x, mean, sigma, n, delta, ubd):
    limit = len(x)

    wm = 0
    wmv = [None]
    m = 1

    e1 = n * delta / sigma ** 2
    e2 = e1 * delta / 2
    while m < limit and wm < ubd:
        s1 = 0
        wm = 0
        for i in range(0, m):
            s1 = s1 + x[m - i] - mean
            wm = wm + np.exp(s1 * e1 - (i + 1) * e2)
        wmv.append(wm)
        m += 1
    return {'rl': m, 'w': wmv}


def runLengthShroPois(x, rho, delta, ubd):
    limit = len(x)

    wm = 0
    wmv = [None]
    m = 1

    e1 = np.log(rho)
    while m < limit and wm < ubd:
        s1 = 0
        wm = 0
        for i in range(0, m):
            s1 = s1 + x[m - i]
            wm = wm + np.exp(s1 * e1 - (i + 1) * delta)
        wmv.append(wm)
        m += 1
    if m == limit:
        m = np.inf
    return {'rl': m, 'w': wmv}


def shroArlPfaCedPois(lambda0=10, lambda1=None, delta=1, tau=None,
                      N=100, limit=10000, seed=None, w=19, verbose=True):
    np.random.seed(seed)

    if delta is None:
        delta = lambda1 - lambda0
    if lambda1 is None:
        lambda1 = lambda0 + delta

    rho = (lambda0 + delta) / lambda0

    rls = []
    for _ in range(N):
        if tau is None:
            x = stats.poisson(lambda0).rvs(limit)
        else:
            x = np.concatenate([
                stats.poisson(lambda0).rvs(tau),
                stats.poisson(lambda1).rvs(limit - tau),
            ])
        rls.append(runLengthShroPois(x, rho, delta, w)['rl'])
    result = {'rls': rls}

    rls = np.ma.masked_invalid(rls)
    result['statistic'] = {
        'ARL': np.mean(rls),
        'Std. Error': np.sqrt((np.mean(rls ** 2) - np.mean(rls) ** 2) / N),
    }
    if tau is not None:
        pfa = np.mean(rls < tau)
        ced = np.mean(rls[rls >= tau]) - tau
        se = np.sqrt(
            (np.sum(rls[rls >= tau] ** 2) / (N - np.sum(rls < tau)) - ced ** 2)
            /
            (N - np.sum(rls < tau)))
        result['statistic']['PFA'] = pfa
        result['statistic']['CED'] = ced
        result['statistic']['CED-Std. Error'] = se

    if verbose:
        print(pd.Series(result['statistic']))
    return result
