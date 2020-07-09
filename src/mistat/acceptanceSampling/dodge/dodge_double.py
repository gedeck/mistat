'''
Created on Jun 30, 2020

@author: petergedeck
'''
from scipy import stats

import numpy as np
import pandas as pd

from .dodge_base import AcceptanceSamplingPlan


def DSPlanBinomial(N, n1, n2, Ac1, Re1, Ac2, p=None):
    p = p if p is not None else np.arange(0, 0.255, 0.005)
    p = np.array(p)

    _ = np.array([stats.binom.cdf(Ac1, n1, pi) for pi in p])
    limits = list(range(Ac1 + 1, Re1))
    # print(limits)
    # TODO: write specs


#     1.00000000 0.95111013 0.90438208 0.85973044 0.817072
#
#     OC = np.array([stats.binom(n, pi).cdf(Ac) for pi in p])
#
#     AOQ = (N - n) * p * OC / N
#     ATI = n * OC + N * (1 - OC)
#     return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)

# DSPlanBinomial=function(N,n1,n2,Ac1,Re1, Ac2, p=seq(0,0.25,0.005), Plots=TRUE){


def SSPlanHyper(N, n, Ac, p=None):
    p = p if p is not None else np.arange(0, 0.3, 0.001)
    p = np.array(p)

    OC = np.array([stats.hypergeom(N, round(n * pi), n).cdf(Ac) for pi in p])

    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)


def SSPlanPoisson(N, n, Ac, p=None):
    p = p if p is not None else np.arange(0, 0.3, 0.001)
    p = np.array(p)

    OC = np.array([stats.poisson(n * pi).cdf(Ac) for pi in p])

    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)


#' Single Sampling Plan Designs
#'
#' Design a single sampling plan for given AQL, alpha, LQL, and beta. Currently
#' there are functions for the binomial and Poisson distributions.
#'
#' @param AQL Acceptable quality level
#' @param alpha producer's risk
#' @param LQL Limiting quality level
#' @param beta consumers' risk

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
