'''
Created on Jul 8, 2020

@author: petergedeck
'''
"""
ARL, PFA and CED of Shiryayev-Roberts procedure
"""

from scipy import stats

import numpy as np
import pandas as pd

# TODO: shroArlPfaCedPois


def shroArlPfaCedNorm(mean0=0, mean1=None, sd=1, n=10, delta=1, tau=None,
                      N=100, limit=10000, seed=None, w=19, verbose=True):
    np.random.seed(seed)

    if delta is None:
        delta = (mean1 - mean0) / sd
    if mean1 is None:
        mean1 = mean0 + delta * sd

    randFunc0 = stats.norm(loc=mean0, scale=sd / np.sqrt(n))
    randFunc1 = stats.norm(loc=mean1, scale=sd / np.sqrt(n))

    rls = []
    for _ in range(N):
        if tau is None:
            x = randFunc0.rvs(limit)
        else:
            x = np.concatenate([randFunc0.rvs(tau), randFunc1.rvs(limit - tau)])
        rls.append(runLengthShroNorm(x, mean0, sd, n, delta, w)['rl'])
    result = {'rls': rls}

    rls = np.ma.masked_invalid(rls)
    result['statistic'] = {
        'ARL': np.mean(rls),
        'Std. Error': np.sqrt((np.mean(rls ** 2) - np.mean(rls) ** 2) / N),
    }
    if tau is not None:
        pfa = np.mean(rls < tau)
        ced = np.mean(rls[rls >= tau]) - tau
        se = np.sqrt(
            (np.sum(rls[rls >= tau] ** 2) / (N - np.sum(rls < tau)) - ced ** 2)
            /
            (N - np.sum(rls < tau)))
        result['statistic']['PFA'] = pfa
        result['statistic']['CED'] = ced
        result['statistic']['CED-Std. Error'] = se

    if verbose:
        print(pd.Series(result['statistic']))
    return result


def runLengthShroNorm(x, mean, sigma, n, delta, ubd):
    limit = len(x)

    wm = 0
    wmv = [None]
    m = 1

    e1 = n * delta / sigma ** 2
    e2 = e1 * delta / 2
    while m < limit and wm < ubd:
        s1 = 0
        wm = 0
        for i in range(0, m):
            s1 = s1 + x[m - i] - mean
            wm = wm + np.exp(s1 * e1 - (i + 1) * e2)
        wmv.append(wm)
        m += 1
    return {'rl': m, 'w': wmv}


def runLengthShroPois(x, rho, delta, ubd):
    limit = len(x)

    wm = 0
    wmv = [None]
    m = 1

    e1 = np.log(rho)
    while m < limit and wm < ubd:
        s1 = 0
        wm = 0
        for i in range(0, m):
            s1 = s1 + x[m - i]
            wm = wm + np.exp(s1 * e1 - (i + 1) * delta)
        wmv.append(wm)
        m += 1
    if m == limit:
        m = np.inf
    return {'rl': m, 'w': wmv}

#
# .runLengthShroPois <- function(x, rho, delta, ubd){
#
#   limit <- length(x)
#
#   m = 2
#   wm = 0
#   wmv<- rep(NA, limit)
#
#   while(m < limit && wm < ubd){
#     s1 = 0
#     wm = 0
#
#     for(i in 1:(m - 1)){
#       s1 = s1 + x[m - i + 1]
#       wm = wm + exp(-i * delta + s1 * log(rho))
#     }
#
#     wmv[m] <- wm
#
#     if(wm > ubd || (m+1) == limit){
#       res <- vector("list", 0)
#       if(wm > ubd){
#         res$rl <- m
#         res$w <- wmv[1:m]
#       } else {
#         res$rl <- Inf
#         res$w <- wmv
#       }
#     }
#     m = m + 1
#   }
#   return(res)
# }
#
#
# shroArlPfaCedPois <- function (lambda0=10, lambda1=NA,
#                                delta=1,
#                                tau=NA,
#                                N=100, limit=10000, seed=NA,
#                                w=19,
#                                printSummary=TRUE)
# {
#   if(is.na(delta))
#     delta <- (lambda1 - lambda0)
#
#   if(is.na(lambda1))
#     lambda1 <- lambda0 + delta
#
#   rho <- (lambda0 + delta)/lambda0
#
#   if(!is.na(seed))
#     set.seed(seed)
#
#   if(is.na(tau)){
#     data <- matrix(rpois(n=limit*N, lambda0), nrow=N)
#   } else {
#     data <- matrix(rnorm(n=(tau)*N, lambda0), nrow=N)
#     data <- cbind(data, matrix(rnorm(n=(limit-tau)*N, lambda1), nrow=N))
#   }
#
#   res <- list(run=apply(data, MARGIN=1, .runLengthShroPois, rho=rho, delta=delta, ubd=w))
#   res$rls <- sapply(res$run, function(x) x$rl)
#
#   if(is.na(tau)){
#     res$statistic <- c(mean(res$rls),
#              sqrt((mean(res$rls^2) - mean(res$rls)^2)/N))
#     names(res$statistic) <- c("ARL", "Std. Error")
#   } else {
#     pfa <- sum(res$rls < tau)/nrow(data)
#     ced = sum(res$rls[res$rls >= tau])/(nrow(data) - sum(res$rls < tau)) - tau
#     se = sqrt((sum(res$rls[res$rls >= tau]^2)/(nrow(data) - sum(res$rls < tau)) - ced ^ 2) / (nrow(data) - sum(res$rls < tau)))
#     res$statistic <- c(mean(res$rls),
#              sqrt((mean(res$rls^2) - mean(res$rls)^2)/N),
#              pfa, ced, se)
#     names(res$statistic) <- c("ARL", "Std. Error", "PFA", "CED", "CED-Std. Error")
#   }
#
#   if(printSummary)
#     print(res$statistic)
#
#   invisible(res)
# }
