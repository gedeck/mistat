# pylint: disable=too-many-arguments,too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass
from typing import List, Optional

import matplotlib.pyplot as plt
import numpy as np


@dataclass
class AcceptanceSamplingPlan:
    p: List[float]
    OC: List[float]
    AOQ: List[float]
    ASN: Optional[List[float]] = None
    ATI: Optional[List[float]] = None
    n: Optional[List[float]] = None
    Pa1: Optional[List[float]] = None
    Pa2: Optional[List[float]] = None

    def plot(self, axes=None):
        if axes is None:
            _, axes = plt.subplots(nrows=2, ncols=2, figsize=[8, 8])

        samplePlan = self

        ax = axes[0, 0]
        ax.plot(self.p, samplePlan.OC)
        ax.set_xlabel('Fraction Nonconforming p')
        ax.set_ylabel('Probability of Acceptance')
        ax.set_title('OC Curve')

        ax = axes[0, 1]
        if self.ASN is not None:
            ax.plot(self.p, samplePlan.ASN)
            ax.set_xlabel('Fraction Nonconforming p')
            ax.set_ylabel('Average sample size')
            ax.set_title(f'maximum ASN = {max(samplePlan.ASN):.0f}')

        if self.n is not None:
            ax.plot(self.p, self.n)
            ax.set_xlabel('Fraction Nonconforming p')
            ax.set_ylabel('Uncurtailed sample size')

        ax = axes[1, 0]
        ax.plot(self.p, samplePlan.AOQ)
        ax.set_xlabel('Fraction Nonconforming p')
        ax.set_ylabel('AOQ')
        ax.set_title(f'AOQL = {max(samplePlan.AOQ):.4g}')

        if self.ATI is not None:
            ax = axes[1, 1]
            ax.plot(self.p, self.ATI)
            ax.set_xlabel('Fraction Nonconforming p')
            ax.set_ylabel('ATI')
        else:
            axes[1, 1].set_axis_off()


@dataclass
class SequentialSamplePlan:
    # R: dodge.SeqDesignBinomial
    AQL: float  # Acceptable quality level
    alpha: float  # alpha producer’s risk
    LQL: float  # LQL Limiting quality level
    beta: float  # beta consumers’ risk

    h1: float
    h2: float
    s: float
    h: List[float]
    p: List[float]

    k: List[int]
    accept: List[float]
    reject: List[float]

    N: Optional[int] = None  # lot size, required for hypergeometric
    oc_type: str = 'binomial'

    def __post_init__(self):
        k1 = ((1 - self.beta) / self.alpha) ** self.h
        k2 = (self.beta / (1 - self.alpha)) ** self.h
        self.OC = (k1 - 1) / (k1 - k2)
        self.AOQ = self.p * self.OC

        k5 = self.OC * np.log(self.beta / (1 - self.alpha))
        k3 = k5 + (1 - self.OC) * np.log((1 - self.beta) / self.alpha)
        k4 = self.p * np.log(self.LQL / self.AQL) + (1 - self.p) * np.log((1 - self.LQL) / (1 - self.AQL))
        self.ASN = k3 / k4

        self.ATI = self.N and k5 / k4 + (1 - self.OC) * self.N

    def plot(self):
        asp = AcceptanceSamplingPlan(p=self.p, OC=self.OC, ASN=self.ASN, AOQ=self.AOQ, ATI=self.ATI, n=None)
        asp.plot()

    def acceptanceChart(self, ax=None):
        if ax is None:
            _, ax = plt.subplots(figsize=[5, 5])
        ax.plot(self.k, self.accept, color='C0')
        ax.plot(self.k, self.reject, color='C0')
        ax.grid(linestyle='--', color='lightgrey')

        ax.set_ylim(min(self.accept), max(self.reject))
        ax.set_xlabel('k')
        ax.set_ylabel(r'$d_k$')
        ax.set_title('Sequential Acceptance Chart')

        x = np.median(self.k)
        common = {'horizontalalignment': 'center', 'verticalalignment': 'center'}
        ax.text(x, 0.5 * (np.min(self.accept) + np.mean(self.accept)), "ACCEPT", **common)
        ax.text(x, 0.5 * (np.max(self.reject) + np.mean(self.reject)), "REJECT", **common)
        ax.text(x, max(self.accept), "CONTINUE", **common)
