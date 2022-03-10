'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from collections import namedtuple

import numpy as np
from scipy import stats
from scipy.linalg import inv, toeplitz
from statsmodels.tsa.stattools import acf


def optimalLinearPredictor(x, n, nlags=10):
    ns = len(x)
    res = np.array(x)
    for i in range(n + 1, ns + 1):
        xs = x[:i]
        ak = acf(xs, nlags=nlags, fft=True)
        R = toeplitz(ak[:nlags])
        r = ak[1:]
        b = np.matmul(inv(R), r)
        res[i - 1] = np.sum(x[(i - 2):(i - nlags - 2):-1] * b)
    return res


def quadraticPredictor(x, n, s):
    ns = len(x)
    res = np.array(x)
    nx = np.arange(0, -n, -1)
    A = np.column_stack([[1] * n, nx, nx**2])
    invAA = inv(np.matmul(A.transpose(), A))
    invAAA = np.matmul(invAA, A.transpose())
    ts = np.array([1, s, s**2])
    for i in range(n, ns - s + 1):
        xs = x[i - n:i]
        xs = xs[::-1]
        b = np.matmul(invAAA, xs)
        pred = np.sum(b * ts)
        res[i + s - 1] = pred
    return res


def masPredictor(x, m, s):
    n = len(x)
    wm = np.arange(-m, m + 1)
    res = np.array(x)
    for i in range(m, n - m - s):
        xtm = x[i - m:i + m + 1]
        b0m = np.mean(xtm)
        b1m = 3 * np.sum(xtm * wm) / (m * (m + 1) * (2 * m + 1))
        res[i + m + s] = b0m + (m + s) * b1m
    return res


def normRandomWalk(n, v, w, c, seed=None):
    np.random.seed(seed)
    s1 = np.sqrt(v)
    s2 = np.sqrt(w)
    X = np.zeros(n)
    Tet = np.zeros(n)
    cf = np.zeros(n)
    Mt = np.zeros(n)
    cf[0] = (c + w) * v / (c + w + v)
    Tet[0] = s2 * stats.norm.rvs()
    X[0] = Tet[0] + s1 * stats.norm.rvs()
    for i in range(1, n):
        Tet[i] = Tet[i - 1] + s2 * stats.norm.rvs()
        X[i] = Tet[i] + s1 * stats.norm.rvs()
        cf[i] = (cf[i - 1] + w) * v / (cf[i - 1] + w + v)
        at = (cf[i] + w) / (cf[i] + w + v)
        Mt[i] = (1 - at) * Mt[i - 1] + at * X[i]
    nvrmResult = namedtuple('nvrmResult', 't,X,predicted')
    return nvrmResult(np.arange(n), X, Mt)


def dlmLinearGrowth(X, C0, v, W, M0):
    n = len(X)
    pred = np.ones(n)
    for i in range(n):
        at = np.array([1.0, i + 1]).transpose()
        pred[i] = np.matmul(at.transpose(), M0)
        ut = v + np.matmul(at.transpose(), np.matmul(C0 + W, at))
        ei = X[i] - np.matmul(at.transpose(), M0)
        ev = np.array([ei / ut, (i + 1) * ei / ut]).transpose()
        M0 = M0 + np.matmul((C0 + W), ev)
        B = np.array([[1 / ut, (i + 1) / ut], [(i + 1) / ut, (i + 1)**2 / ut]])
        C0 = (C0 + W) - np.matmul(C0 + W, np.matmul(B, (C0 + W)))
    return pred


def simulateARMA(n, a, b, seed=None):
    np.random.seed(seed)
    p = len(a)
    q = len(b)
    pm = max(p, q)
    ns = n + pm

    X = np.zeros(ns)
    X[0] = stats.norm.rvs()
    for i in range(1, pm):
        X[i] = X[i - 1] + stats.norm.rvs()
    E = stats.norm.rvs(size=ns)

    for i in range(pm, ns):
        X[i] = np.sum(X[i - p:i][::-1] * a)
        E[i] = np.sum(E[i - q:i][::-1] * b) + E[i]
    X = X + E
    return X


def predictARMA(X, a):
    n = len(X)
    p = len(a)
    pred = np.zeros(n)
    pred[:p] = X[:p]
    for i in range(p, n):
        pred[i] = np.sum(X[i - p:i][::-1] * a)
    return pred
