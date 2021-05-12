'''
Created on Jun 16, 2020

@author: petergedeck
'''
from dataclasses import dataclass, field
from enum import Enum
from itertools import product
from typing import List

from scipy.stats import binom, hypergeom, poisson

import numpy as np
import pandas as pd
from math import floor


class OCtype(Enum):
    binomial = 'binomial'
    hypergeom = 'hypergeom'
    poisson = 'poisson'


def getDistribution(n, c, distribution, r=None, pd=None, N=None, D=None):
    if not isinstance(n, list):
        n = [n]
    if not isinstance(c, list):
        c = [c]
    if distribution == OCtype.binomial:
        return OCbinomial(n=n, c=c, r=r, pd=pd)
    elif distribution == OCtype.hypergeom:
        return OChypergeom(n=n, c=c, r=r, N=N, pd=pd, D=D)
    elif distribution == OCtype.poisson:
        return OCpoisson(n=n, c=c, r=r, pd=pd)
    else:
        raise NotImplementedError(f'Distribution {distribution} not implemented')


@dataclass
class OCdistribution:
    n: List[int]
    c: List[int]
    r: List[int] = field(default_factory=list)

    distribution: OCtype = field(init=False)
    paccept: List[float] = field(default_factory=list, init=False)

    def __post_init__(self):
        if self.r is None:
            if len(self.c) <= 2:
                self.r = [1 + self.c[-1]] * len(self.c)
            else:
                self.r = None

        self.c = np.array(self.c)
        self.r = np.array(self.r)


@dataclass
class OCbinomial(OCdistribution):
    pd: List[float] = field(default_factory=list)

    def __post_init__(self):
        super().__post_init__()
        self.distribution = OCtype.binomial

        if self.pd is None:
            self.pd = np.linspace(0, 1, 101)

        self.paccept = np.array([self.calcBinomial(pdi, self.n, self.c, self.r) for pdi in self.pd])

    def calcBinomial(self, p_d, n, c, r):
        # For each stage, find out all the possibilities which could
        # lead to still not having made a decision and then calculate
        # the appropriate probabilities.
        p_acc = 0.0
        for k in range(len(n)):
            # Determine combinations
            comb = [list(range(c[i] + 1, r[i])) for i in range(k)]
            x = pd.DataFrame(list(product(*comb)))
            # Calculate change from previous
            x.iloc[:, 1:] = x.iloc[:, 1:].values - x.iloc[:, :-1].values

            x[k] = c[k] - np.sum(x, axis=1)
            for _, xi in x.iterrows():
                p_acc += self.probAcc(xi.values, n, p_d)
        return p_acc

    @staticmethod
    def probAcc(x, n, p):
        k = len(x) - 1
        f = binom.cdf(x[k], n[k], p)
        for i in range(k):
            f *= binom.pmf(x[i], n[i], p)
        return f


@dataclass
class OChypergeom(OCdistribution):
    N: int = None
    pd: List[float] = field(default_factory=list)
    D: List[int] = field(default_factory=list)

    def __post_init__(self):
        super().__post_init__()
        self.distribution = OCtype.hypergeom
        if not self.D:
            self.D = [round(pdi * self.N) for pdi in self.pd]

        self.paccept = np.array([self.calcHypergeom(Di, self.n, self.c, self.r, self.N) for Di in self.D])

    def calcHypergeom(self, D, n, c, r, N):
        # For each stage, find out all the possibilities which could
        # lead to still not having made a decision and then calculate
        # the appropriate probabilities.
        p_acc = 0.0
        for k in range(len(c)):
            # Determine combinations
            comb = [list(range(c[i] + 1, r[i])) for i in range(k)]
            x = pd.DataFrame(list(product(*comb)))
            # Calculate change from previous
            x.iloc[:, 1:] = x.iloc[:, 1:].values - x.iloc[:, :-1].values

            x[k] = c[k] - np.sum(x, axis=1)
            for _, xi in x.iterrows():
                p_acc += self.probAcc(xi.values, n, N, D)
        return p_acc

    @staticmethod
    def probAcc(x, n, N, D):
        k = len(x)
        k1 = k - 1
        x_cumsum = np.cumsum(x)[0:k]
        n_cumsum = np.cumsum(n)
        D_cum = D - np.array([0, *x_cumsum[0:k1]])
        N_cum = N - np.array([0, *n_cumsum[0:k1]])
        f = hypergeom(N_cum[-1], max(0, D_cum[-1]), n[k1]).cdf(x[-1])
        for i in range(len(x) - 1):
            f *= hypergeom(N_cum[i], max(0, D_cum[i]), n[i]).pmf(x[i])
        return f


@dataclass
class OCpoisson(OCdistribution):
    pd: List[float] = field(default_factory=list)

    def __post_init__(self):
        super().__post_init__()
        self.distribution = OCtype.poisson

        if self.pd is None:
            self.pd = np.linspace(0, 1, 101)

        self.paccept = np.array([self.calcPoisson(pdi, self.n, self.c, self.r) for pdi in self.pd])

    def calcPoisson(self, p_d, n, c, r):
        # For each stage, find out all the possibilities which could
        # lead to still not having made a decision and then calculate
        # the appropriate probabilities.
        p_acc = 0.0
        for k in range(len(n)):
            # Determine combinations
            comb = [list(range(c[i] + 1, r[i])) for i in range(k)]
            x = pd.DataFrame(list(product(*comb)))
            # Calculate change from previous
            x.iloc[:, 1:] = x.iloc[:, 1:].values - x.iloc[:, :-1].values

            x[k] = c[k] - np.sum(x, axis=1)
            for _, xi in x.iterrows():
                p_acc += self.probAcc(xi.values, n, p_d)
                print(x, p_acc)
        return p_acc

    @staticmethod
    def probAcc(x, n, p):
        k = len(x) - 1
        f = poisson.cdf(x[k], np.floor(n[k] * p + 0.5))
        for i in range(k):
            f *= poisson.pmf(x[i], n[i] * p)
        return f
