# pylint: disable=too-many-arguments, too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from numbers import Number

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import stats

from mistat.qcc.rules import shewhartRules
from mistat.qcc.statistics import GroupMeans, qccStatistics


# qcc <- function(data, type = c("xbar", "R", "S", "xbar.one", "p", "np", "c", "u", "g"), sizes,
#                 center, std.dev, limits, data.name, labels, newdata, newsizes, newdata.name,
#                 newlabels, nsigmas = 3, confidence.level, rules = shewhart.rules, plot = TRUE, ...)
class QualityControlChart:
    def __init__(self, data, qcc_type=qccStatistics.default, labels=None,
                 center=None, std_dev=None, limits=None, sizes=None,
                 nsigmas=3, confidence_level=None,
                 newdata=None):
        self.statistic = qccStatistics.get(qcc_type)
        self.qcc_type = self.statistic.qcc_type

        self.data = np.array(data)
        if len(self.data.shape) == 1:
            self.data = pd.DataFrame({'data': self.data})
        self.sizes = sizes
        if self.sizes is None:
            self.sizes = self.statistic.getSizes(data)

        if labels is None:
            labels = list(range(len(data)))
        self.labels = labels

        if isinstance(self.sizes, Number):
            # self.stats = GroupMeans((self.data.values / self.sizes).flatten(), self.data.mean())
            self.stats = GroupMeans((self.data.values).flatten(), self.data.mean())
            self.sizes = [self.sizes] * len(self.data)
        else:
            self.stats = self.statistic.stats(self.data, self.sizes)
        self.center = float(center or self.stats.center)
        self.std_dev = self.statistic.sd(self.data, std_dev=std_dev, sizes=self.sizes)

        if confidence_level is None:
            self.nsigmas = nsigmas
            conf = nsigmas
        else:
            self.confidence_level = confidence_level
            conf = confidence_level
        if limits is None:
            self.limits = self.statistic.limits(self.center, self.std_dev, self.sizes, conf)
        else:
            self.limits = limits

        if newdata is not None:
            pass
#             raise NotImplementedError()
            # gives self.newdata, self.newstats, self.newsizes
        else:
            self.newdata = None
            self.newstats = None
            self.newsizes = None

        # TODO violations
        self.violations = shewhartRules(self)

    def plot(self, title=None, ax=None):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))
        beyondLimits = [*self.violations['beyondLimits']['LCL'], *self.violations['beyondLimits']['UCL']]
        violatingRuns = self.violations['violatingRuns']
        df = pd.DataFrame({'x': self.labels, 'y': self.stats.statistics})
        ax = df.plot.line(x='x', y='y', style='-', color='lightgrey',
                          marker='o', markerfacecolor='black', ax=ax)
        ax.plot(df.iloc[beyondLimits]['x'], df.iloc[beyondLimits]['y'], linestyle='None',
                marker='s', markerfacecolor='red', markeredgecolor='red')
        ax.plot(df.iloc[violatingRuns]['x'], df.iloc[violatingRuns]['y'],
                linestyle='None', marker='s', markerfacecolor='red', markeredgecolor='red')
        ax.legend().remove()
        ax.set_xlabel('Group')
        ax.set_ylabel('Group summary statistics')

        ax.axhline(self.center, color='black')
        secax = ax.secondary_yaxis('right')
        secax.yaxis.tick_right()
        if len(self.limits) == 1:
            ax.axhline(self.limits.LCL[0], color='black', linestyle='--')
            ax.axhline(self.limits.UCL[0], color='black', linestyle='--')
            ax.set_yticks([self.limits.LCL[0], self.limits.UCL[0], self.center])
            ax.set_yticklabels(['LCL', 'UCL', 'CL'])
        else:
            # calculate mid-points for steps
            delta = (df.x.values[1:] - df.x.values[:-1]) / 2
            delta = [delta[0], *delta, delta[-1]]
            lcl = [[], []]
            ucl = [[], []]
            last = None
            for xleft, xright, l, u in zip(df.x.values - delta[:-1], df.x.values + delta[1:],
                                           self.limits.LCL, self.limits.UCL):
                if last:
                    lcl[0].extend([xleft, xleft])
                    lcl[1].extend([last, l])
                    ucl[0].extend([xleft, xleft])
                    ucl[1].extend([last, u])
                lcl[0].extend([xleft, xright])
                lcl[1].extend([l, l])
                ucl[0].extend([xleft, xright])
                ucl[1].extend([u, u])
            ax.plot(*lcl, color='black', linestyle='--')
            ax.plot(*ucl, color='black', linestyle='--')

        fig = ax.get_figure()
        fig.subplots_adjust(bottom=0.2)
        fig.text(0.1, 0.1, f'Number of groups = {len(self.labels)}', fontsize=12)
        fig.text(0.1, 0.06, f'Center = {self.center:.5g}', fontsize=12)
        fig.text(0.1, 0.02, f'StdDev = {self.std_dev:.5g}', fontsize=12)
        if len(self.limits) == 1:
            fig.text(0.4, 0.06, f'LCL = {self.limits.LCL[0]:.5g}', fontsize=12)
            fig.text(0.4, 0.02, f'UCL = {self.limits.UCL[0]:.5g}', fontsize=12)
        fig.text(0.6, 0.06, f'Number beyond limits = {len(beyondLimits)}', fontsize=12)
        fig.text(0.6, 0.02, f'Number violating runs = {len(violatingRuns)}', fontsize=12)

        fig_title = [f'{self.statistic.qcc_type} Chart']
        if title is not None:
            fig_title.append(title)
        fig.suptitle('\n'.join(fig_title), fontsize=14)
        return ax

    def oc_curves(self, nsigmas=None, ax=None):
        if self.qcc_type in ['p' or 'np']:
            return oc_curves_p(self, ax=ax)

        raise NotImplementedError()


def oc_curves_p(qcc, ax=None):
    if qcc.qcc_type not in ['p', 'np']:
        raise ValueError("not a qcc object of type 'p', or 'np'.")

    size = set(qcc.sizes)
    if len(size) > 1:
        raise ValueError('Operating characteristic curves available only for equal sample sizes!')
    if qcc.limits is None:
        raise ValueError("the `qcc' object does not have control limits!")

    if ax is None:
        _, ax = plt.subplots(figsize=(8, 6))

    limits = qcc.limits
    size = qcc.sizes[0]
    p = np.linspace(0, 1, 101)

    if qcc.qcc_type == 'p':
        UCL = min(np.floor(size * limits.UCL[0]), size)
        LCL = max(np.floor(size * limits.LCL[0]), 0)
    else:
        UCL = min(np.floor(limits.UCL[0]), size)
        LCL = max(np.floor(limits.LCL[0]), 0)
    beta = pd.Series(stats.binom(size, p).cdf(UCL) - stats.binom(size, p).cdf(LCL - 1),
                     index=p)

    beta.plot(ax=ax, color='black')
    ax.set_xlim(-0.05, 1.05)
    ax.set_ylim(-0.05, 1.05)
    ax.set_xlabel(r'$p$')
    ax.set_ylabel('Prob. type II error')
    ax.set_title(f'OC curves for {qcc.qcc_type} Chart')

    p_max = beta.idxmax()
    ax.plot([p_max, p_max], [0, beta.max()], color='grey', linestyle='--')


def qcc_groups(data, groups):
    grouped = pd.Series(data).groupby(groups)

    max_size = max(grouped.size())

    result = np.empty((len(grouped), max_size))
    result[:] = np.NaN
    for idx, group in grouped:
        result[idx - 1, :len(group.values)] = group.values
    return result


def qcc_overdispersion_test(x, sizes=None, dist=None):
    if dist is None:
        dist = 'poisson' if sizes is None else 'binomial'
    dist = dist.lower()
    if dist == 'binomial' and sizes is None:
        raise ValueError("binomial data require argument 'size'")
    if sizes is not None and len(x) != len(sizes):
        raise ValueError("arguments 'x' and 'sizes' must have same length")

    if dist == 'binomial':
        p = np.sum(x) / np.sum(sizes)
        theor_var = np.mean(sizes) * p * (1 - p)
    elif dist == 'poisson':
        theor_var = np.mean(x)
    else:
        raise ValueError(f"invalid distribution '{dist}'")
    n = len(x)
    obs_var = np.var(x, ddof=1)

    D = (n - 1) * obs_var / theor_var
    p_value = 1 - stats.chi2(n - 1).cdf(D)

    return pd.Series({
        'Overdispersion test': dist,
        'Obs.Var/Theor.Var': obs_var / theor_var,
        'Statistic': D,
        'p-value': p_value,
    })
