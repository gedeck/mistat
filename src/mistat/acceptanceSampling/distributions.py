'''
Created on Jun 16, 2020

@author: petergedeck
'''
from dataclasses import dataclass, field
from enum import Enum
from typing import List

from scipy.stats import binom

import numpy as np
import pandas as pd


class OCtype(Enum):
    binomial = 'binomial'


def getDistribution(n, c, distribution, r=None, pd=None):
    if not isinstance(n, list):
        n = [n]
    if not isinstance(c, list):
        c = [c]
    if distribution == OCtype.binomial:
        return OCbinomial(n=n, c=c, pd=pd)
    else:
        raise NotImplementedError(f'Distribution {distribution} not implemented')


@dataclass
class OCdistribution:
    n: List[int]
    c: List[int]
    pd: List[float] = field(default_factory=list)

    r: List[int] = field(init=False)
    distribution: OCtype = field(init=False)
    paccept: List[float] = field(default_factory=list, init=False)

    def __post_init__(self):
        if len(self.c) <= 2:
            self.r = [1 + self.c[-1]] * len(self.c)
        else:
            self.r = None
        self.c = np.array(self.c)
        self.r = np.array(self.r)
        if self.pd is None:
            self.pd = np.linspace(0, 1, 101)


@dataclass
class OCbinomial(OCdistribution):
    def __post_init__(self):
        super().__post_init__()
        self.distribution = OCtype.binomial

        self.paccept = self.calcBinomial(self.pd, self.n, self.c, self.r)

    def calcBinomial(self, p_d, n, c, r):
        # For each stage, find out all the possibilities which could
        # lead to still not having made a decision and then calculate
        # the appropriate probabilities.
        for k in range(len(n)):
            if k == 0:
                p_acc = binom.cdf(c[0], n[0], p_d)
            elif k == 1:
                # Two sampling stages. Needs to be handled separately
                # from more stages due to matrix dimensions
                for x in range(c[0] + 1, r[0] - 1):
                    p_acc += self.probAcc((x, c[1] - x), n, p_d)
            else:
                raise NotImplementedError(f'Implement binomial code for stage {k + 1}')

        return p_acc
    # More than two sampling stages.
    # Things are more tricky.
# k = 3
# c = c(1,4,8)
# r = c(4,5, 10)
#   X1 X2 X.last
# 1  2  3      3
# 2  2  2      4
# 3  3  2      3
# 4  3  1      4
#
# c = c(1,4,9)
# r = c(4,5, 10)
#   X1 X2 X.last
# 1  2  3      4
# 2  2  2      5
# 3  3  2      4
# 4  3  1      5
#
# c = c(1,3,9)
# r = c(4,7,14)
#   X1 X2 X.last
# 1  2  2      5
# 2  2  3      4
# 3  2  4      3
# 4  3  1      5
# 5  3  2      4
# 6  3  3      3
# > c = c(1,3,9)
# > r = c(5,8,14)
#    X1 X2 X.last
# 1   2  2      5
# 2   2  3      4
# 3   2  4      3
# 4   2  5      2
# 5   3  1      5
# 6   3  2      4
# 7   3  3      3
# 8   3  4      2
# 9   4  0      5
# 10  4  1      4
# 11  4  2      3
# 12  4  3      2
# > c = c(1,3,9)
# > r = c(5,9,14)
#    X1 X2 X.last
# 1   2  2      5
# 2   2  3      4
# 3   2  4      3
# 4   2  5      2
# 5   2  6      1
# 6   3  1      5
# 7   3  2      4
# 8   3  3      3
# 9   3  4      2
# 10  3  5      1
# 11  4  0      5
# 12  4  1      4
# 13  4  2      3
# 14  4  3      2
# 15  4  4      1
# > c = c(1,3,9)
# > r = c(6,9,14)
#    X1 X2 X.last
# 1   2  2      5
# 2   2  3      4
# 3   2  4      3
# 4   2  5      2
# 5   2  6      1
# 6   3  1      5
# 7   3  2      4
# 8   3  3      3
# 9   3  4      2
# 10  3  5      1
# 11  4  0      5
# 12  4  1      4
# 13  4  2      3
# 14  4  3      2
# 15  4  4      1
# 16  5 -1      5
# 17  5  0      4
# 18  5  1      3
# 19  5  2      2
# 20  5  3      1

#     c.s <- c+1 ## Use to calculate limits
#     r.s <- r-1 ## Use to calculate limits
#
#     expand.call <- "expand.grid(c.s[k-1]:r.s[k-1]"
#     for(i in 2:(k-1)){
#       expand.call <- paste(expand.call,paste("c.s[k-",i,"]:r.s[k-",i,"]",sep=""),sep=",")
#     }
#     expand.call <- paste(expand.call,")",sep="")
#     x <- eval(parse(text=expand.call)[[1]])
#     x <- x[,(k-1):1]
#     names(x) <- paste("X",1:(k-1),sep="")
#
#     for(i in ncol(x):2){
#       x[,i] <- x[,i]-x[,i-1]
#     }
#     x <- cbind(x, X.last=c[k] - rowSums(x[,1:(k-1)]))
#     p.acc <- p.acc + sum(apply(x, 1, FUN=prob.acc, n=n, p=pd))

    @staticmethod
    def probAcc(x, n, p):
        f = binom.cdf(x[-1], n[-1], p)
        for i in range(len(x) - 1):
            f *= binom.pmf(x[i], n[i], p)
        return f

# OC2c <- function(n,c,r=if (length(c)<=2) rep(1+c[length(c)], length(c)) else NULL,
#                type=c("binomial","hypergeom", "poisson"), ...){
#   ## Decide on what 'type' to use
#   type <- match.arg(type)
#   OCtype <- paste("OC",type,sep="")
#
#   ## Create a new object of that type
#   obj <- new(OCtype, n=n, c=c, r=r, type=type, ...)
#
#   ## Evaluate the probability of acceptance for this type and given
#   ## pd.
#   ## First get the generic calculation function
# ##   OCtype <- get(paste("calc.",OCtype,sep=""))
#   OCtype <- getFromNamespace(paste("calc.",OCtype,sep=""),
#                 ns="AcceptanceSampling")
#
#   ## now, based on the type, decide on what to pass to the function
#   ## Only need to check for existing type since new() would have stuffed up
#   ## if we don't have a class for the type.
#   if (type =="binomial")
#     obj@paccept <- OCtype(n=obj@n, c=obj@c, r=obj@r, pd=obj@pd)
#   if (type =="hypergeom")
#     obj@paccept <- OCtype(n=obj@n, c=obj@c, r=obj@r, N=obj@N, D=obj@pd*obj@N)
#   if (type =="poisson")
#     obj@paccept <- OCtype(n=obj@n, c=obj@c, r=obj@r, pd=obj@pd)
#
#   obj
# }
#
#
#
#
# calc.OCbinomial <- function(n,c,r,pd)
# {
#   p.acc <- sapply(pd, FUN=calc.OCbinomial.pdi, n=n, c=c, r=r)
#   p.acc
# }
#
# calc.OCbinomial.pdi <- function(pd,n,c,r)
# {
#   ## This is really a helper function - it does all the work for each
#   ## value of pd.
#   k.s <- length(n) ## number of stages in this sampling
#
# prob.acc <- function(x, n, p){
#   k <- length(x)
#   k1 <- k-1
#   prod(dbinom(x[1:k1], n[1:k1], p))*pbinom(x[k], n[k], p)
# }
#
#
#   for (k in 1:k.s) {
#     ## For each stage, find out all the possibilities which could
#     ## lead to still not having made a decision and then calculate
#     ## the appropriate probabilities.
#
#     if(k==1) {
#       ## Only a single sampling stage to do - this is simple
#       p.acc <- sapply(pd, FUN=function(el){
#         pbinom(q=c[1],size=n[1],prob=el)})
#       ## p.acc now exists and can be used in the following stages.
#     }
#     else if (k==2) {
#       ## Two sampling stages. Needs to be handled separately from
#       ## more stages due to matrix dimensions
#       c.s <- c+1 ## Use to calculate limits
#       r.s <- r-1 ## Use to calculate limits
#
#       ## The possibilities which lead to a decision to be made at
#       ## the second stage
#       x <- data.frame(X1=seq(c.s[1], r.s[1], by=1),
#                       X.last=c[2]-seq(c.s[1], r.s[1], by=1))
#       p.acc <- p.acc + sum(apply(x, 1, FUN=prob.acc, n=n, p=pd))
#     }
#     else {
#       ## More than two sampling stages.
#       ## Things are more tricky.
#       c.s <- c+1 ## Use to calculate limits
#       r.s <- r-1 ## Use to calculate limits
#
#       expand.call <- "expand.grid(c.s[k-1]:r.s[k-1]"
#       for(i in 2:(k-1)){
#         expand.call <- paste(expand.call,paste("c.s[k-",i,"]:r.s[k-",i,"]",sep=""),sep=",")
#       }
#       expand.call <- paste(expand.call,")",sep="")
#       x <- eval(parse(text=expand.call)[[1]])
#       x <- x[,(k-1):1]
#       names(x) <- paste("X",1:(k-1),sep="")
#
#       for(i in ncol(x):2){
#         x[,i] <- x[,i]-x[,i-1]
#       }
#       x <- cbind(x, X.last=c[k] - rowSums(x[,1:(k-1)]))
#       p.acc <- p.acc + sum(apply(x, 1, FUN=prob.acc, n=n, p=pd))
#     }
#   }
#   return(p.acc)
# }
