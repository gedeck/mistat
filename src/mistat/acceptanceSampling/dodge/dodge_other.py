# mypy: disallow_untyped_defs,disallow_untyped_calls
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from typing import List, Union

import numpy as np
import pandas as pd
from scipy import stats

from .dodge_base import AcceptanceSamplingPlan

# ' Lot Sensitive Compliance Sampling Plans
# '
# ' The lot sensitive compliance sampling plans for given parameters.
# '
# '
# ' @param N the lot size
# ' @param LTPD the lot tolerance percent defective, also known as the limiting
# ' quality
# ' @param beta consumer risk
# ' @param p fraction nonconforming
# ' @param Plots logical indicating if the four plots are required
# ' @author Raj Govindaraju with minor editing by Jonathan Godfrey
# ' @references Schilling, E.G. (1978) \dQuote{A Lot Sensitive Sampling Plan for
# ' Compliance Testing and Acceptance Inspection}, \emph{Journal of Quality
# ' Technology} \bold{10}(2), pp47-51.


def lotSensitiveComplianceSampPlan(N: int, LTPD: float, beta: float,
                                   p: Union[List[float], np.ndarray] = None) -> AcceptanceSamplingPlan:
    if p is None:
        p = np.arange(0, 0.301, 0.001)
    p = np.array(p)

    f = 1 - (beta**(1 / (LTPD * N)))
    n = round(f * N)
    OC = (1 - f)**(N * p)
    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=list(p), OC=list(OC), n=[n] * len(p), AOQ=list(AOQ),
                                  ATI=list(ATI), ASN=None)


# ' Variable Sampling Plans
# '
# ' Variable sampling plans for known and unknown sigma, evaluated for given
# ' parameters.
# '
# '
# ' @aliases VSPKnown VSPUnknown
# ' @param N the lot size
# ' @param n the sample size
# ' @param k the acceptability constant
# ' @param Pa fraction nonconforming
# ' @param Plots logical indicating whether the four plots are required
# ' @author Raj Govindaraju with minor editing by Jonathan Godfrey
# ' @keywords ~kwd1 ~kwd2
# ' @examples
# '
# ' VSPKnown(1000, 20,1)
# ' VSPUnknown(1000, 20,1)
# '

def variableSampPlanKnown(N: int, n: int, k: float,
                          pa: Union[List[float], np.ndarray] = None) -> AcceptanceSamplingPlan:
    if pa is None:
        pa = np.arange(0, 1.001, 0.001)
    pa = np.array(pa)

    zpa = stats.norm.ppf(pa)
    zp = k + zpa / np.sqrt(n)
    p = 1 - stats.norm.cdf(zp)
    OC = pa
    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)  # type: ignore


def variableSampPlanUnknown(N: int, n: int, k: float,
                            pa: Union[List[float], np.ndarray] = None) -> AcceptanceSamplingPlan:
    if pa is None:
        pa = np.arange(0, 1.001, 0.001)
    pa = np.array(pa)

    zpa = stats.norm.ppf(pa)
    k1 = np.sqrt(1 + k * k / 2)
    zp = k + k1 * zpa / np.sqrt(n)
    p = 1 - stats.norm.cdf(zp)
    OC = pa
    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=p, OC=OC, n=[n] * len(p), AOQ=AOQ, ATI=ATI, ASN=None)  # type: ignore

# ' Variable Sampling Plan Design
# '
# ' Design the variable sampling plan for given AQL, alpha, LQL, and beta.
# '
# '
# ' @param AQL Acceptable quality level
# ' @param alpha producer's risk
# ' @param LQL Limiting quality level
# ' @param beta consumers' risk
# ' @author Raj Govindaraju with minor editing by Jonathan Godfrey
# ' @keywords ~kwd1 ~kwd2
# ' @examples
# '
# ' VSPDesign(AQL=0.01, alpha=0.05, LQL=0.04, beta=0.05)


def VSPDesign(AQL: float, alpha: float, LQL: float, beta: float) -> pd.Series:
    zp1 = stats.norm.ppf(1-AQL)
    zp2 = stats.norm.ppf(1-LQL)
    zpa1 = stats.norm.ppf(1-alpha)
    zpa2 = stats.norm.ppf(1-beta)
    k = (zp2 * zpa1 + zp1 * zpa2) / (zpa1 + zpa2)
    n = (zpa1 + zpa2) / (zp1 - zp2)
    n = n * n
    n = round(n)
    n_unknown = n * (1 + k * k / 2)
    return pd.Series({
        'k': k,
        'n': n,
        'n_unknown': n_unknown,
    })
