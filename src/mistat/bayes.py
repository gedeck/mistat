# mypy: disallow_untyped_defs,disallow_untyped_calls
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass
from typing import Dict, List, cast

import numpy as np
from scipy import stats


@dataclass
class Distribution:
    pass


@dataclass
class BetaDistribution(Distribution):
    # shape parameters
    a: int
    b: int

    def theta(self) -> float:
        return self.a / (self.a + self.b)


@dataclass
class GammaDistribution(Distribution):
    shape: float
    rate: float  # scale is 1/rate


@ dataclass
class Mixture:
    probabilities: List[float]
    distributions: List[Distribution]


def updateBetaMixture(mixture: Mixture, data: List[int]) -> Mixture:
    """ Update of a mixture of beta distribution given data

    mixture: mixture of beta distribution characterized by
        probabilities: list of probabilities of the beta components of the prior
        distributions: list of beta distribution of the prior
    data: list with number of successes and number of failures

    returns: update mixture of beta distributions
    """
    distributions = cast(List[BetaDistribution], mixture.distributions)
    probabilities = np.array(mixture.probabilities)

    # Add successes and failures to the shape parameter of the beta distribution
    s, f = data
    postBeta = [BetaDistribution(a=bd.a + s, b=bd.b + f)
                for bd in distributions]
    p = np.array([bd.a / (bd.a + bd.b) for bd in postBeta])

    mProb = np.zeros(len(p))
    for i, (pi, bd, postBd) in enumerate(zip(p, distributions, postBeta)):
        mProb[i] = np.exp(stats.binom.logpmf(s, s+f, pi) +
                          stats.beta(a=bd.a, b=bd.b).logpdf(pi) -
                          stats.beta(a=postBd.a, b=postBd.b).logpdf(pi))
    # update the probabilities of the prior
    postProbs = (probabilities * mProb) / np.sum(probabilities * mProb)
    return Mixture(probabilities=list(postProbs), distributions=list(postBeta))


def updateGammaMixture(mixture: Mixture, data: Dict[str, List[float]]) -> Mixture:
    """ Update of a mixture of gamma distribution given data

    mixture: mixture of gamma distribution characterized by
        probabilities: list of probabilities of the gamma components of the prior
        distributions: list of gamma distribution of the prior
    data: dictionary of lists, 'y' = counts, 't' = time intervals

    returns: updated mixture of gamma distributions
    """
    distributions = cast(List[GammaDistribution], mixture.distributions)
    probabilities = np.array(mixture.probabilities)

    y = data['y']
    t = data['t']
    ysum = np.sum(y)
    tsum = np.sum(t)
    postGamma = [GammaDistribution(shape=d.shape + ysum, rate=d.rate+tsum)
                 for d in distributions]
    L = np.array([d.shape / d.rate for d in postGamma])

    loglike = np.zeros(len(L))
    for yi, ti in zip(y, t):
        loglike += stats.poisson.logpmf(yi, L * ti)

    mProb = np.zeros(len(L))
    for i, (Li, bd, postBd) in enumerate(zip(L, distributions, postGamma)):
        mProb[i] = np.exp(loglike[i] +
                          stats.gamma(bd.shape, scale=1/bd.rate).logpdf(Li) -
                          stats.gamma(postBd.shape, scale=1/postBd.rate).logpdf(Li))
    # update the probabilities of the prior
    postProbs = (probabilities * mProb) / np.sum(probabilities * mProb)
    return Mixture(probabilities=list(postProbs), distributions=list(postGamma))
