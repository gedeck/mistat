# mypy: disallow_untyped_defs,disallow_untyped_calls
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from typing import List, Union

import numpy as np

from .dodge_base import AcceptanceSamplingPlan

# Chain Sampling Plans for the binomial and Poisson distributions.
# #'
# #'
# #' @aliases ChainSamplingPlans ChainBinomial ChainPoisson
# #' @param N the lot size
# #' @param n the sample size
# #' @param i the number of preceding lots that are free from nonconforming units
# #' for the lot to be accepted
# #' @param p a vector of values for the possible fraction of product that is
# #' nonconforming
# #' @param Plots logical to request generation of the four plots
# #' @return A matrix containing the argument \code{p} as supplied and the
# #' calculated OC, ATI and ???
# #' @author Raj Govindaraju with minor editing by Jonathan Godfrey
# #' @references Dodge, H.F. (1955) \dQuote{Chain Sampling Inspection Plan},
# #' \emph{Industrial Quality Control} \bold{11}(4), pp10-13.


def ChainPlanBinomial(N: int, n: int, i: int, p: Union[List[float], np.ndarray] = None) -> AcceptanceSamplingPlan:
    if p is None:
        p = np.arange(0, 0.301, 0.001)
    p = np.array(p)

    OC = (1 - p)**n + n * p * (1 - p)**(n + n * i - 1)
    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=list(p), OC=list(OC), n=[n] * len(p), AOQ=list(AOQ), ATI=list(ATI), ASN=None)


def ChainPlanPoisson(N: int, n: int, i: int, p: Union[List[float], np.ndarray] = None) -> AcceptanceSamplingPlan:
    p = p if p is not None else np.arange(0, 0.3, 0.001)
    p = np.array(p)

    OC = np.exp(-n * p) + n * p * np.exp(-n * p * (i + 1))
    AOQ = (N - n) * p * OC / N
    ATI = n * OC + N * (1 - OC)
    return AcceptanceSamplingPlan(p=list(p), OC=list(OC), n=[n] * len(p), AOQ=list(AOQ), ATI=list(ATI), ASN=None)
