'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import math
from collections import namedtuple

import numpy as np
from scipy import stats
from scipy.optimize import root_scalar

from mistat.acceptanceSampling.distributions import OChypergeom
from mistat.acceptanceSampling.oc import OC_TYPES

RiskPoint = namedtuple('RiskPoint', 'pdefect,paccept')
Plan = namedtuple('Plan', 'n,c,r')
PlanNormal = namedtuple('PlanNormal', 'n,k,s_type')


def findPlan(PRP, CRP, oc_type='binomial', N=None, s_type='known'):
    """ Find the sampling plan with the smallest sample size, which meets a prespecified
    Producer and Consumer Risk Points.

    The convention used here, as in many books, is to use equality for the Producer Risk
    Point rather than the consumer risk point.

    No consideration is given to "cost functions
    """
    oc_type = oc_type.lower()
    if oc_type not in [*OC_TYPES, 'normal']:
        raise ValueError(f'Unknown type {oc_type}')
    PRP = checkRiskPoint(PRP, 'Producer risk point', oc_type)
    CRP = checkRiskPoint(CRP, 'Consumer risk point', oc_type)
    if np.any(PRP[0] >= CRP[0]):
        raise ValueError('Consumer Risk Point quality must be greater than Producer Risk Point quality')

    if oc_type == 'binomial':
        raise NotImplementedError
        # c <- 0
        # n <- c+1
        # repeat {
        #   if (calc.OCbinomial(n=n,c=c,r=c+1,pd=CRP[1]) > CRP[2])
        #     n <- n + 1
        #   else if (calc.OCbinomial(n=n,c=c,r=c+1,pd=PRP[1]) < PRP[2])
        #     c <- c + 1
        #   else
        #     break
        # }
        # return(list(n=n, c=c, r=c+1))

    if oc_type == 'hypergeom':
        if N is None:
            raise ValueError('N must be supplied for the hypergeometric distribution.')
        c = np.array([0])
        n = c + 1
        while True:
            p1 = OChypergeom(n=n, c=c, r=c + 1, N=N, D=CRP[0] * N).paccept
            if p1 > CRP[1]:
                n += 1
                continue
            p2 = OChypergeom(n=n, c=c, r=c + 1, N=N, D=PRP[0] * N).paccept
            if p2 < PRP[1]:
                c += 1
            else:
                break
        return Plan(n[0], c[0], (c + 1)[0])

    if oc_type == 'poisson':
        raise NotImplementedError
        # c = 0
        # n = c + 1
        # while True:
        #     if OCpoisson(n=[n], c=[c], r=[c + 1], pd=CRP[0]).paccept > CRP[1]:
        #         print(n, c, OCpoisson(n=[n], c=[c], r=[c + 1], pd=CRP[0]).paccept)
        #         n += 1
        #     elif OCpoisson(n=[n], c=[c], r=[c + 1], pd=PRP[0]).paccept < PRP[1]:
        #         print(n, c, OCpoisson(n=[n], c=[c], r=[c + 1], pd=PRP[0]).paccept)
        #         c += 1
        #     else:
        #         break
        #     break
        # return Plan(n, c, c + 1)

    if oc_type == 'normal':
        s_type = s_type.lower()
        if s_type not in ['known', 'unknown']:
            raise ValueError(f'Unknown s_type {s_type}')
        # With known standard deviation
        if s_type == 'known':
            n = stats.norm.ppf(1 - PRP[1])[0] + stats.norm.ppf(CRP[1])[0]
            n = n / (stats.norm.ppf(CRP[0])[0] - stats.norm.ppf(PRP[0])[0])
            n = int(np.ceil(n * n))
            k = stats.norm.ppf(1 - PRP[1])[0] / np.sqrt(n) - stats.norm.ppf(PRP[0])[0]
            return PlanNormal(n, k, s_type)
        if s_type == 'unknown':
            n = 2
            k = find_k(n, PRP[0], PRP[1], interval=[0, 1000])
            nc = - stats.norm.ppf(CRP[0])[0] * np.sqrt(n)
            pa = 1 - stats.nct.cdf(k * np.sqrt(n), df=n - 1, nc=nc)
            while pa > CRP[1]:
                n = n + 1
                k = find_k(n, PRP[0], PRP[1], interval=[0, 1000])
                nc = - stats.norm.ppf(CRP[0])[0] * np.sqrt(n)
                pa = 1 - stats.nct.cdf(k * np.sqrt(n), df=n - 1, nc=nc)
            return PlanNormal(n, k, s_type)
    raise NotImplementedError


def findPlanApprox(PRP, CRP, N):
    """ Calculate single-stage sampling plan using approximation of hypergeometric distribution """
    alpha = (1 - PRP[1])
    beta = CRP[1]
    p0 = PRP[0]
    pt = CRP[0]

    za_pq0 = stats.norm.ppf(1 - alpha) * np.sqrt(p0 * (1 - p0))
    zb_pqt = stats.norm.ppf(1 - beta) * np.sqrt(pt * (1 - pt))

    # calculate approximation of n
    n0 = ((za_pq0 + zb_pqt) / (pt - p0)) ** 2
    nstar = int(round(n0 / (1 + n0 / N)))

    # calculate approximation of c
    cstar = int(round(nstar * p0 - 0.5 + za_pq0 * np.sqrt(nstar * (1 - nstar / N))))
    return Plan(nstar, cstar, cstar + 1)


def checkRiskPoint(RP, info, oc_type):
    if not isinstance(RP, list) and len(RP) != 2:
        raise ValueError(f'{info} must be a list with two elements (pdefect, paccept)')
    pdefect, paccept = RP
    if not isinstance(pdefect, list):
        pdefect = [pdefect]
    if not isinstance(paccept, list):
        paccept = [paccept]
    pdefect = np.array(pdefect)
    paccept = np.array(paccept)
    if oc_type == 'poisson':
        if not np.all(0 < pdefect):
            raise ValueError(f'{info}: all quality values of must be larger than 0')
        if not np.all(0 < paccept):
            raise ValueError(f'{info}: all paccept values of must be larger than 0')
    else:
        if not np.all(0 < pdefect < 1):
            raise ValueError(f'{info}: all values of pdefect must fall within [0, 1]')
        if not np.all(0 < paccept < 1):
            raise ValueError(f'{info}: all values of paccept must fall within [0, 1]')

    return RiskPoint(pdefect, paccept)


def find_k(n, pd, pa, interval=None):
    """ find k for a given n """
    if interval is None:
        interval = [0, 5]
    df = n - 1
    sqrt_n = np.sqrt(n)
    nc = - stats.norm.ppf(pd) * sqrt_n
    pa = 1 - pa

    def f(x):
        return stats.nct.cdf(x * sqrt_n, df=df, nc=nc) - pa
    return root_scalar(f, bracket=interval, method='brentq').root


# """
# find.plan <- function(PRP, CRP,
#                       type=c("binomial","hypergeom","poisson","normal"),
#                       N,
#                       s.type=c("known", "unknown"))
# {

#   else if(CRP[1] <= PRP[1])
#     stop("Consumer Risk Point quality must be greater than Producer Risk Point quality")

#   ## Attributes Sampling Plan - Binomial distribution
#   if (type == "binomial") {
#     c <- 0
#     n <- c+1
#     repeat {
#       if (calc.OCbinomial(n=n,c=c,r=c+1,pd=CRP[1]) > CRP[2])
#         n <- n + 1
#       else if (calc.OCbinomial(n=n,c=c,r=c+1,pd=PRP[1]) < PRP[2])
#         c <- c + 1
#       else
#         break
#     }
#     return(list(n=n, c=c, r=c+1))
#   }
#   ## Attributes Sampling Plan - Hypergeometric distribution
#   if (type == "hypergeom") {
#     c <- 0
#     n <- c+1
#     repeat {
#       if (calc.OChypergeom(n=n,c=c,r=c+1,N=N,D=CRP[1]*N) > CRP[2])
#         n <- n + 1
#       else if (calc.OChypergeom(n=n,c=c,r=c+1,N=N,D=PRP[1]*N) < PRP[2])
#         c <- c + 1
#       else
#         break
#     }
#     return(list(n=n, c=c, r=c+1))
#   }
#   ## Attributes Sampling Plan - Poisson distribution
#   if (type == "poisson") {
#     c <- 0
#     n <- c+1
#     repeat {
#       if (calc.OCpoisson(n=n,c=c,r=c+1,pd=CRP[1]) > CRP[2])
#         n <- n + 1
#       else if (calc.OCpoisson(n=n,c=c,r=c+1,pd=PRP[1]) < PRP[2])
#         c <- c + 1
#       else
#         break
#     }
#     return(list(n=n, c=c, r=c+1))
#   }
#   ## Variables Sampling Plan - Normal distribution
#   else if (type=="normal") {
#     ## With known standard deviation
#     if (s.type=="known") {
#       n <- ceiling( ((qnorm(1-PRP[2]) + qnorm(CRP[2]))/
#                      (qnorm(CRP[1])-qnorm(PRP[1])) )^2)
#       k <- qnorm(1-PRP[2])/sqrt(n) - qnorm(PRP[1])
#       return(list(n=n, k=k, s.type=s.type))
#     }
#     ## With unknown standard deviation
#     else if (s.type=="unknown") {
#       n <- 2 ## Need a minimum of 1 degree of freedom (=n-1) for the NC t-dist
#       k <- find.k(n, PRP[1], PRP[2], interval=c(0,1000))
#       pa <- 1- pt(k*sqrt(n), df=n-1, ncp=-qnorm(CRP[1])*sqrt(n))
#       while(pa > CRP[2]){
#         n <- n+1
#         k <- find.k(n, PRP[1], PRP[2])
#         pa <- 1-pt(k*sqrt(n), df=n-1, ncp=-qnorm(CRP[1])*sqrt(n))
#       }
#       return(list(n=n, k=k, s.type=s.type))
#     }
#   }
# }
# """


def normalApproximationOfH(j, M, n, N):
    P = N / M
    Q = 1 - P
    return stats.norm.cdf((j + 0.5 - n * P) / math.sqrt(n * P * Q * (1 - n / M)))
