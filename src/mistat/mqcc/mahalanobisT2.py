'''
Created on Jul 9, 2020

@author: petergedeck
'''
from string import ascii_uppercase

from matplotlib.gridspec import GridSpec
from scipy import linalg, optimize
from scipy import stats

import matplotlib.patches as patches
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf


class MahalanobisT2:
    def __init__(self, x, factor_name, response_names=None, conf_level=0.95, compare_to=None):
        if response_names is None:
            response_names = [c for c in x.columns if c != factor_name]
        x = x[[factor_name, *response_names]]
        x = x.rename(columns={factor_name: 'factor'})
        D = x.groupby('factor').mean()
        self.groupmeans = D
        nfactors = len(D)
        # self.total_cov = x.cov()
        # self.total_cov_inv = linalg.inv(self.total_cov)
        cov = None
        for _, subset in x.groupby('factor'):
            if cov is None:
                cov = subset[response_names].cov()
            else:
                cov = cov + subset[response_names].cov()
        cov = cov / nfactors
        self.cov = cov

        N = np.unique(x.groupby('factor').apply(lambda x: len(x)))
        if len(N) > 1:
            print(f'different number of measures by factor, using n={N[0]}')
        N = N[0]
        p = D.shape[1]
        K = N**2 / (2 * N) * (2 * N - p - 1) / ((2 * N - 2) * p)
        Qf = stats.f(p, 2 * N - p - 1).ppf(conf_level)
        self.Qf = Qf
        self.K = K
        D2 = D.iloc[0] - D.iloc[1]
        self.D2 = D2
        D3 = pd.DataFrame([[0] * p, D.iloc[0] - D.iloc[1]], columns=list(ascii_uppercase[:p]))
        lm = smf.ols(formula=f"A ~ {'+'.join(D3.columns[1:])} - 1", data=D3).fit()

        def fun(x, cov_inv):
            x = pd.DataFrame(x, columns=list(ascii_uppercase[1:p]))
            D4 = np.array([lm.predict(x), *x.values]).flatten()
            delta = D4 - D2
            return abs(K * np.transpose(delta) @ cov_inv @ delta - Qf)
        cov_inv = linalg.inv(cov)
        opt_result = optimize.minimize(fun, [0] * (D3.shape[1] - 1), args=(cov_inv, ), method='Nelder-Mead')

        res = pd.DataFrame(opt_result.x, columns=list(ascii_uppercase[1:p]))
        res = np.array([lm.predict(res), *res.values]).flatten()
        res = np.array([res, D2.values, (2 * D2 - res).values])
        res = res[res[:, 1].argsort()[::-1]]
        res = pd.DataFrame(res, columns=response_names, index=('LCR', 'Center', 'UCR'))

        self.coord = res
        self.mahalanobis = res.apply(lambda x: np.sqrt(x @ cov_inv @ x), axis=1)
        self.mahalanobis_compare = None
        if compare_to is not None:
            self.mahalanobis_compare = np.sqrt(compare_to @ cov_inv @ compare_to)
#             x = pd.DataFrame([self.mahalanobis_compare], columns=list(ascii_uppercase[1:p]))
#             self.mahalanobis_compare_coord = [self.mahalanobis_compare, lm.predict(x)]
#
#             def fun(x, cov_inv):
#                 x = pd.DataFrame(x, columns=list(ascii_uppercase[1:p]))
#             opt_result = optimize.minimize(fun, [0] * (D3.shape[1] - 1), args=(cov_inv, ), method='Nelder-Mead')
#             res = pd.DataFrame(opt_result.x, columns=list(ascii_uppercase[1:p]))
#             res = np.array([lm.predict(res), *res.values]).flatten()
#             self.mahalanobis_compare_coord = res

    def summary(self):
        print('Coordinates')
        print(self.coord)
        print()
        print('Mahalanobis')
        print(self.mahalanobis)
        print()
        if self.mahalanobis_compare is not None:
            print(f' comparison: {self.mahalanobis_compare:.5g}')

    def plot(self):
        if len(self.coord.columns) > 2:
            raise ValueError('Plot only supported for two dimensions')
        fig = plt.figure(figsize=[4, 5])
        gs = GridSpec(2, 1, height_ratios=[3, 2])
        ax1 = fig.add_subplot(gs[0])
        ax2 = fig.add_subplot(gs[1])
        col1, col2 = self.coord.columns
        ax1.plot([0, self.coord[col1][0]], [0, self.coord[col2][0]], color='black')
        ax1.plot(0, 0, marker='o', markeredgecolor='black', markerfacecolor='white')
        ax1.plot(self.coord[col1], self.coord[col2], color='red',
                 marker='o', markeredgecolor='black', markerfacecolor='black')
        ax1.set_xlabel(f'difference {col1}')
        ax1.set_ylabel(f'difference {col2}')

        left = 0.5
        if self.mahalanobis_compare:
            left = 0.35
        ax2.set_xlim(0, 2)
        mmin = min(*self.mahalanobis, self.mahalanobis_compare)
        mmax = max(*self.mahalanobis, self.mahalanobis_compare)
        mdelta = mmax - mmin
        ax2.set_ylim(mmin - 0.15 * mdelta, mmax + 0.15 * mdelta)
        for direction in ('top', 'bottom', 'right'):
            ax2.spines[direction].set_visible(False)
        ax2.get_xaxis().set_visible(False)
        mmin = min(self.mahalanobis)
        mmax = max(self.mahalanobis)
        ax2.add_patch(patches.Rectangle((left, mmin), 1, mmax - mmin, facecolor="red", edgecolor="black"))
        y = self.mahalanobis[1]
        ax2.plot((left, left + 1), (y, y), color='black', linewidth=2)
        if self.mahalanobis_compare is not None:
            y = self.mahalanobis_compare
            ax2.plot((left - 0.1, left + 1.1), (y, y), linewidth=2)
            ax2.text(left + 1.15, y, 'Comparison', verticalalignment='center')

        ax2.set_ylabel(r'Mahalanobis $T^2$')
        plt.tight_layout()
