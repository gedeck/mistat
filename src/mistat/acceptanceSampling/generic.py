'''
Created on Jun 28, 2020

@author: petergedeck
'''
from collections import namedtuple

from mistat.acceptanceSampling.distributions import OChypergeom
from mistat.acceptanceSampling.oc import OC_TYPES
import numpy as np


RiskPoint = namedtuple('RiskPoint', 'pdefect,paccept')
Plan = namedtuple('Plan', 'n,c,r')


def findPlan(PRP, CRP, oc_type='binomial', N=None, s_type='known'):
    """ Find the sampling plan with the smallest sample size, which meets a prespecified 
    Producer and Consumer Risk Points.

    The convention used here, as in many books, is to use equality for the Producer Risk 
    Point rather than the consumer risk point.

    No consideration is given to "cost functions
    """
    oc_type = oc_type.lower()
    if oc_type not in OC_TYPES:
        raise ValueError(f'Unknown type {oc_type}')
    PRP = checkRiskPoint(PRP, 'Producer risk point', oc_type)
    CRP = checkRiskPoint(CRP, 'Consumer risk point', oc_type)
    if np.any(PRP[0] >= CRP[0]):
        raise ValueError('Consumer Risk Point quality must be greater than Producer Risk Point quality')

    if oc_type == 'binomial':
        raise NotImplementedError
    elif oc_type == 'hypergeom':
        if N is None:
            raise ValueError('N must be supplied for the hypergeometric distribution.')
        c = np.array([0])
        n = c + 1
        while True:
            if OChypergeom(n=n, c=c, r=c + 1, N=N, D=CRP[0] * N).paccept > CRP[1]:
                n += 1
            elif OChypergeom(n=n, c=c, r=c + 1, N=N, D=PRP[0] * N).paccept < PRP[1]:
                c += 1
            else:
                break
        return Plan(n[0], c[0], (c + 1)[0])


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


"""
find.plan <- function(PRP, CRP,
                      type=c("binomial","hypergeom","poisson","normal"),
                      N,
                      s.type=c("known", "unknown"))
{
 
  else if(CRP[1] <= PRP[1])
    stop("Consumer Risk Point quality must be greater than Producer Risk Point quality")

  ## Attributes Sampling Plan - Binomial distribution
  if (type == "binomial") {
    c <- 0
    n <- c+1
    repeat {
      if (calc.OCbinomial(n=n,c=c,r=c+1,pd=CRP[1]) > CRP[2])
        n <- n + 1
      else if (calc.OCbinomial(n=n,c=c,r=c+1,pd=PRP[1]) < PRP[2])
        c <- c + 1
      else
        break
    }
    return(list(n=n, c=c, r=c+1))
  }
  ## Attributes Sampling Plan - Hypergeometric distribution
  if (type == "hypergeom") {
    c <- 0
    n <- c+1
    repeat {
      if (calc.OChypergeom(n=n,c=c,r=c+1,N=N,D=CRP[1]*N) > CRP[2])
        n <- n + 1
      else if (calc.OChypergeom(n=n,c=c,r=c+1,N=N,D=PRP[1]*N) < PRP[2])
        c <- c + 1
      else
        break
    }
    return(list(n=n, c=c, r=c+1))
  }
  ## Attributes Sampling Plan - Poisson distribution
  if (type == "poisson") {
    c <- 0
    n <- c+1
    repeat {
      if (calc.OCpoisson(n=n,c=c,r=c+1,pd=CRP[1]) > CRP[2])
        n <- n + 1
      else if (calc.OCpoisson(n=n,c=c,r=c+1,pd=PRP[1]) < PRP[2])
        c <- c + 1
      else
        break
    }
    return(list(n=n, c=c, r=c+1))
  }
  ## Variables Sampling Plan - Normal distribution
  else if (type=="normal") {
    ## With known standard deviation
    if (s.type=="known") {
      n <- ceiling( ((qnorm(1-PRP[2]) + qnorm(CRP[2]))/
                     (qnorm(CRP[1])-qnorm(PRP[1])) )^2)
      k <- qnorm(1-PRP[2])/sqrt(n) - qnorm(PRP[1])
      return(list(n=n, k=k, s.type=s.type))
    }
    ## With unknown standard deviation
    else if (s.type=="unknown") {
      n <- 2 ## Need a minimum of 1 degree of freedom (=n-1) for the NC t-dist
      k <- find.k(n, PRP[1], PRP[2], interval=c(0,1000))
      pa <- 1- pt(k*sqrt(n), df=n-1, ncp=-qnorm(CRP[1])*sqrt(n))
      while(pa > CRP[2]){
        n <- n+1
        k <- find.k(n, PRP[1], PRP[2])
        pa <- 1-pt(k*sqrt(n), df=n-1, ncp=-qnorm(CRP[1])*sqrt(n))
      }
      return(list(n=n, k=k, s.type=s.type))
    }
  }
}
"""