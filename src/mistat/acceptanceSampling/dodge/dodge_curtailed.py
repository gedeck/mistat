'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass
from typing import List

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import stats

# R: dodge.CurtBinomial


def curtailedBinomial(n, Ac, p=None):
    """ The ASN Function for Curtailed Single Sampling by Attributes
    Anders Hald and Uffe Msller
    Technometrics, Vol. 18, No. 3(Aug., 1976), pp. 307-312
    """
    p = p if p is not None else np.arange(0, 0.5, 0.01)
    p = np.array(p)

    # handle the edge cases of p = 0, 1
    mask0 = np.where(p == 0)
    mask1 = np.where(p == 1)
    p[mask0] = 1e-6
    p[mask1] = 0.999999999
    q = 1-p
    t1 = stats.binom.cdf(Ac, n+1, p) * (n - Ac) / (n * q)
    t2 = (1 - stats.binom.cdf(Ac+1, n+1, p)) * (Ac + 1) / (n * p)
    t1[mask0] = (n - Ac) / n
    t1[mask1] = 0
    t2[mask0] = 0
    t2[mask1] = (Ac + 1) / n
    ASNfull = n * (t1 + t2)

    p[mask0] = 0
    t1 = stats.binom.cdf(Ac, n, p)
    ASNsemi = n * (t1 + t2)

    return CurtailedSamplePlan(ASNsemi=ASNsemi, ASNfull=ASNfull, p=p, n=n)


@dataclass
class CurtailedSamplePlan:
    p: List[float]
    ASNsemi: List[float]
    ASNfull: List[float]
    n: int

    oc_type: str = 'binomial'

    def __repr__(self):
        return str(pd.DataFrame({
            'p': self.p,
            'ASNsemi': self.ASNsemi,
            'ASNfull': self.ASNfull,
        }))

    def plot(self, ax=None):
        if ax is None:
            _, ax = plt.subplots()
        ax.plot(self.p, self.ASNfull, linestyle='--', color='C1', label='Fully curtailed ASN')
        ax.plot(self.p, self.ASNsemi, color='C0', label='Semi-curtailed ASN')

        ax.set_ylim(1, 1.1 * self.n)
        ax.set_xlabel(r'$p$')
        ax.set_ylabel('ASN')
        return ax
