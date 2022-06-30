# pylint: disable=too-many-arguments,too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numpy as np
from scipy import stats

from .dodge_base import AcceptanceSamplingPlan


def DSPlanBinomial(N, n1, n2, Ac1, Re1, Ac2, p=None):
    p = p if p is not None else np.arange(0, 0.255, 0.005)
    p = np.array(p)

    Pa1 = stats.binom.cdf(Ac1, n1, p)
    limits = list(range(Ac1 + 1, Re1))

    Pa2 = np.zeros([len(p), len(limits)])
    for i, d1 in enumerate(limits):
        Pa2[:, i] = stats.binom.pmf(d1, n1, p) * stats.binom.cdf(Ac2-d1, n2, p)
    Pa2 = np.sum(Pa2, axis=1)
    OC = Pa1 + Pa2

    ASN = n1 + n2 * (stats.binom.cdf((Re1 - 1), n1, p) -
                     stats.binom.cdf(Ac1, n1, p))
    AOQ = (p * Pa1 * (N - n1) + p * Pa2 * (N - n1 - n2)) / N
    ATI = n1 * Pa1 + (n1 + n2) * Pa2 + (1 - OC) * N

    return AcceptanceSamplingPlan(p=p, OC=OC, AOQ=AOQ, ATI=ATI, ASN=ASN, Pa1=Pa1, Pa2=Pa2)


def DSPlanPoisson(N, n1, n2, Ac1, Re1, Ac2, p=None):
    p = p if p is not None else np.arange(0, 0.255, 0.005)
    p = np.array(p)

    Pa1 = stats.poisson.cdf(Ac1, n1*p)
    limits = list(range(Ac1 + 1, Re1))

    Pa2 = np.zeros(len(p))
    for d1 in limits:
        Pa2 += stats.poisson.pmf(d1, n1*p) * stats.poisson.cdf(Ac2-d1, n2*p)

    OC = Pa1 + Pa2
    ASN = n1 + n2 * (stats.poisson.cdf((Re1 - 1), n1*p) -
                     stats.poisson.cdf(Ac1, n1*p))
    AOQ = (p * Pa1 * (N - n1) + p * Pa2 * (N - n1 - n2)) / N
    ATI = n1 * Pa1 + (n1 + n2) * Pa2 + (1 - OC) * N
    return AcceptanceSamplingPlan(p=p, OC=OC, AOQ=AOQ, ATI=ATI, ASN=ASN, Pa1=Pa1, Pa2=Pa2)


# Ac1 -> c1, Re1 -> c2, Ac2 -> c3
def DSPlanNormal(N, n1, n2, Ac1, Re1, Ac2, p=None):
    p = p if p is not None else np.arange(0, 0.255, 0.005)
    p = np.array(p)

    dn1 = np.sqrt(n1*p*(1-p)*(1 - n1/N))
    dn2 = np.sqrt(n2*p*(1-p)*(1 - n2/(N*n1)))

    Pa1 = stats.norm.cdf((Ac1 + 0.5 - n1*p) / dn1)

    limits = list(range(Ac1 + 1, Re1))

    Pa2 = np.zeros(len(p))
    for d1 in limits:
        delta = (stats.norm.cdf((d1 + 0.5 - n1*p) / dn1) -
                 stats.norm.cdf((d1 - 0.5 - n1*p) / dn1))
        Pa2 += delta * stats.norm.cdf((Ac2-d1 + 0.5 - n2*p)/dn2)

    OC = Pa1 + Pa2
    ASN = n1 + n2 * (stats.norm.cdf((Re1 - 0.5 - n1*p)/dn1) -
                     stats.norm.cdf((Ac1 + 0.5 - n1*p)/dn1))
    AOQ = (p * Pa1 * (N - n1) + p * Pa2 * (N - n1 - n2)) / N
    ATI = n1 * Pa1 + (n1 + n2) * Pa2 + (1 - OC) * N

    return AcceptanceSamplingPlan(p=p, OC=OC, AOQ=AOQ, ATI=ATI, ASN=ASN, Pa1=Pa1, Pa2=Pa2)


# Ac1 -> c1, Re1 -> c2, Ac2 -> c3
def DSPlanHypergeom(N, n1, n2, Ac1, Re1, Ac2, p=None):
    p = p if p is not None else np.arange(0, 0.255, 0.005)
    p = np.array(p)

    D = np.round(p * N)
    Pa1 = stats.hypergeom.cdf(Ac1, N, D, n1)

    limits = list(range(Ac1 + 1, Re1))
    Pa2 = np.zeros(len(p))
    for d1 in limits:
        Pa2_d1 = stats.hypergeom.pmf(d1, N, D, n1) * stats.hypergeom.cdf(Ac2-d1, N-n1, D - d1, n2)
        Pa2_d1[np.isnan(Pa2_d1)] = 0
        Pa2 += Pa2_d1

    OC = Pa1 + Pa2
    ASN = n1 + n2 * (stats.hypergeom.cdf((Re1 - 1), N, D, n1) -
                     stats.hypergeom.cdf(Ac1, N, D, n1))
    AOQ = (p * Pa1 * (N - n1) + p * Pa2 * (N - n1 - n2)) / N
    ATI = n1 * Pa1 + (n1 + n2) * Pa2 + (1 - OC) * N

    return AcceptanceSamplingPlan(p=p, OC=OC, AOQ=AOQ, ATI=ATI, ASN=ASN, Pa1=Pa1, Pa2=Pa2)
