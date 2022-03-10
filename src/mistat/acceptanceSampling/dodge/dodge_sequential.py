'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numpy as np

from .dodge_base import SequentialSamplePlan


def sequentialDesign(AQL, alpha, LQL, beta, oc_type='binomial', N=None):
    """ Create a sequential sampling plan

    Selects the appropriate sequential sampling plan from the given inputs
    """
    # R: dodge.SeqDesignBinomial
    a = np.log((1 - beta) / alpha)
    b = np.log((1 - alpha) / beta)
    g1 = np.log(LQL / AQL)
    g2 = np.log((1 - AQL) / (1 - LQL))
    G = g1 + g2
    h1 = b / G
    h2 = a / G
    s = g2 / G

    h = np.arange(-4 * h1, 5 * h2, 0.01)

    f1 = (1 - LQL) / (1 - AQL)
    f2 = LQL / AQL
    p = (1 - f1 ** h) / ((f2 ** h) - (f1 ** h))
    L = int(round(2 * h1 / s))
    k = list(range(1, L + 1))
    accept = s * np.array(k) - h1
    reject = s * np.array(k) + h2

    return SequentialSamplePlan(AQL=AQL, alpha=alpha, LQL=LQL, beta=beta, N=N, oc_type=oc_type, h1=h1, h2=h2, s=s,
                                h=h, k=k, accept=accept, reject=reject, p=p)
