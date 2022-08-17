# mypy: disallow_untyped_defs,disallow_untyped_calls
# pylint: disable=too-many-arguments
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass, field
from enum import Enum
from itertools import product
from typing import List, Optional, Union, cast

import numpy as np
import pandas as pd
from scipy.stats import binom, hypergeom, poisson


class OCtype(Enum):
    binomial = 'binomial'
    hypergeom = 'hypergeom'
    poisson = 'poisson'


IntOrListInt = Union[int, List[int]]
Probabilities = Optional[Union[List[float], np.ndarray]]


def getDistribution(n: IntOrListInt, c: IntOrListInt, distribution: OCtype,
                    r: List[int] = None, pd: Probabilities = None,   # pylint: disable=redefined-outer-name
                    N: int = None, D: List[int] = None) -> 'OCdistribution':
    if not isinstance(n, list):
        n = [n]
    if not isinstance(c, list):
        c = [c]
    if distribution == OCtype.binomial:
        return OCbinomial(n=n, c=c, r=r, pd=pd)
    if distribution == OCtype.hypergeom:
        return OChypergeom(n=n, c=c, r=r, N=N, pd=pd, D=D)
    if distribution == OCtype.poisson:
        return OCpoisson(n=n, c=c, r=r, pd=pd)

    raise NotImplementedError(f'Distribution {distribution} not implemented')


@dataclass
class OCdistribution:
    n: List[int]
    c: List[int]
    r: Optional[List[int]] = None

    distribution: OCtype = field(init=False)
    paccept: Optional[np.ndarray] = None

    def __post_init__(self) -> None:
        if self.r is None:
            if len(self.c) <= 2:
                self.r = [1 + self.c[-1]] * len(self.c)
            else:
                self.r = None

        self.c = np.array(self.c)  # type: ignore
        self.r = np.array(self.r)  # type: ignore


@dataclass
class OCbinomial(OCdistribution):
    pd: Probabilities = None

    def __post_init__(self) -> None:
        super().__post_init__()
        self.distribution = OCtype.binomial
        if self.r is None:
            raise ValueError('r must be provided in class initialization')

        if self.pd is None:
            self.pd = np.linspace(0, 1, 101)

        self.paccept = np.array([self.calcBinomial(pdi, self.n, self.c, self.r) for pdi in self.pd])

    def calcBinomial(self, p_d: float, n: List[int], c: List[int], r: List[int]) -> float:
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

            x[k] = c[k] - np.sum(cast(np.ndarray, x), axis=1)
            for _, xi in x.iterrows():
                p_acc += self.probAcc(xi.values, n, p_d)
        return p_acc

    @staticmethod
    def probAcc(x: np.ndarray, n: List[int], p: float) -> float:
        k = len(x) - 1
        f = cast(float, binom.cdf(x[k], n[k], p))
        for i in range(k):
            f *= binom.pmf(x[i], n[i], p)
        return f


@dataclass
class OChypergeom(OCdistribution):
    N: Optional[int] = None
    pd: Probabilities = None
    D: Optional[List[int]] = None

    def __post_init__(self) -> None:
        super().__post_init__()
        if self.N is None:
            raise ValueError('N must be provided in class initialization')
        if self.r is None:
            raise ValueError('r must be provided in class initialization')
        if self.pd is None and self.D is None:
            raise ValueError('One of D or pd must be provided in class initialization')

        self.distribution = OCtype.hypergeom
        if not self.D:
            assert self.pd is not None
            self.D = [round(pdi * self.N) for pdi in self.pd]

        self.paccept = np.array([self.calcHypergeom(Di, self.n, self.c, self.r, self.N) for Di in self.D])

    def calcHypergeom(self, D: int, n: List[int], c: List[int], r: List[int], N: int) -> float:
        # For each stage, find out all the possibilities which could
        # lead to still not having made a decision and then calculate
        # the appropriate probabilities.
        p_acc = 0.0
        for k, c_k in enumerate(c):
            # Determine combinations
            comb = [list(range(c[i] + 1, r[i])) for i in range(k)]
            x = pd.DataFrame(list(product(*comb)))
            # Calculate change from previous
            x.iloc[:, 1:] = x.iloc[:, 1:].values - x.iloc[:, :-1].values

            x[k] = c_k - np.sum(cast(np.ndarray, x), axis=1)
            for _, xi in x.iterrows():
                p_acc += self.probAcc(xi.values, n, N, D)
        return p_acc

    @staticmethod
    def probAcc(x: np.ndarray, n: List[int], N: int, D: int) -> float:
        k = len(x)
        k1 = k - 1
        x_cumsum = np.cumsum(x)[0:k]
        n_cumsum = np.cumsum(n)
        D_cum = D - np.array([0, *x_cumsum[0:k1]])
        N_cum = N - np.array([0, *n_cumsum[0:k1]])
        f = cast(float, hypergeom(N_cum[-1], round(max(0, D_cum[-1])), n[k1]).cdf(x[-1]))
        for i in range(len(x) - 1):
            f *= hypergeom(N_cum[i], round(max(0, D_cum[i])), n[i]).pmf(x[i])
        return f


@ dataclass
class OCpoisson(OCdistribution):
    pd: Probabilities = None

    def __post_init__(self) -> None:
        super().__post_init__()
        self.distribution = OCtype.poisson
        if self.r is None:
            raise ValueError('r must be provided in class initialization')

        if self.pd is None:
            self.pd = np.linspace(0, 1, 101)

        self.paccept = np.array([self.calcPoisson(pdi, self.n, self.c, self.r) for pdi in self.pd])

    def calcPoisson(self, p_d: float, n: List[int], c: List[int], r: List[int]) -> float:
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
            x[k] = c[k] - np.sum(cast(np.ndarray, x), axis=1)
            for _, xi in x.iterrows():
                p_acc += self.probAcc(xi.values, n, p_d)
        return p_acc

    @ staticmethod
    def probAcc(x: np.ndarray, n: List[int], p: float) -> float:
        k = len(x) - 1
        f = cast(float, poisson.cdf(x[k], np.floor(n[k] * p + 0.5)))
        for i in range(k):
            f *= poisson.pmf(x[i], n[i] * p)
        return f
