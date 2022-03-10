'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numpy as np
import pandas as pd
from scipy import stats

from .dodge_base import AcceptanceSamplingPlan


# ' Single sampling plans for the binomial, hypergeometric and Poisson
# ' distributions.
def SSPlanBinomial(N, n, Ac, p=None):
    p = p if p is not None else np.arange(0, 0.3, 0.001)
    p = np.array(p)

    OC = stats.binom.cdf(Ac, n, p)

    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)


def SSPlanHyper(N, n, Ac, p=None):
    p = p if p is not None else np.arange(0, 0.3, 0.001)
    p = np.array(p)

    OC = stats.hypergeom.cdf(Ac, N, np.round(N*p), n)

    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)


def SSPlanPoisson(N, n, Ac, p=None):
    p = p if p is not None else np.arange(0, 0.3, 0.001)
    p = np.array(p)

    OC = stats.poisson.cdf(Ac, n*p)
    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)


# ' Single Sampling Plan Designs
# '
# ' Design a single sampling plan for given AQL, alpha, LQL, and beta. Currently
# ' there are functions for the binomial and Poisson distributions.
# '
# ' @param AQL Acceptable quality level
# ' @param alpha producer's risk
# ' @param LQL Limiting quality level
# ' @param beta consumers' risk

def SSPDesignBinomial(AQL, alpha, LQL, beta):
    def nl(Ac, LQL, beta):
        n = 1
        while stats.binom(n, LQL).cdf(Ac) >= beta:
            n += 1
        return n

    def nu(Ac, AQL, alpha):
        n = 1
        while stats.binom(n, AQL).cdf(Ac) >= 1 - alpha:
            n += 1
        return n

    Ac = 0
    while nl(Ac, LQL, beta) > nu(Ac, AQL, alpha):
        Ac += 1
    n = nl(Ac, LQL, beta)
    return pd.Series({'n': n, 'Ac': Ac})


def SSPDesignPoisson(AQL, alpha, LQL, beta):
    def nl(Ac, LQL, beta):
        n = 1
        while stats.poisson(n * LQL).cdf(Ac) >= beta:
            n += 1
        return n

    def nu(Ac, AQL, alpha):
        n = 1
        while stats.poisson(n * AQL).cdf(Ac) >= 1 - alpha:
            n += 1
        return n

    Ac = 0
    while nl(Ac, LQL, beta) > nu(Ac, AQL, alpha):
        Ac += 1
    n = nl(Ac, LQL, beta)
    return pd.Series({'n': n, 'Ac': Ac})
