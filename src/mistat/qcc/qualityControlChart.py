'''
Created on Jun 20, 2020

@author: petergedeck
'''
from numbers import Number

from mistat.qcc.qccStatistics import QCCtype, QCC_statistic, GroupMeans
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


# qcc <- function(data, type = c("xbar", "R", "S", "xbar.one", "p", "np", "c", "u", "g"), sizes,
#                 center, std.dev, limits, data.name, labels, newdata, newsizes, newdata.name,
#                 newlabels, nsigmas = 3, confidence.level, rules = shewhart.rules, plot = TRUE, ...)
class QualityControlChart:
    def __init__(self, data, qcc_type=QCCtype.xbar, labels=None,
                 center=None, std_dev=None, sizes=None,
                 nsigmas=3, confidence_level=None):
        self.statistic = QCC_statistic.get_for_type(qcc_type)
        self.qcc_type = self.statistic.qcc_type

        self.data = data
        if len(data.shape) == 1:
            self.data = pd.DataFrame({'data': self.data})
        self.sizes = sizes or self.statistic.getSizes(data)

        if labels is None:
            labels = list(range(len(data)))
        self.labels = labels

        if isinstance(self.sizes, Number):
            self.stats = GroupMeans((self.data.values / self.sizes).flatten(), np.mean(self.data))
            self.sizes = [self.sizes] * len(self.data)
        else:
            self.stats = self.statistic.stats(self.data, self.sizes)
        self.center = center or self.stats.center

        self.std_dev = self.statistic.sd(self.data, std_dev)

        if confidence_level is None:
            self.nsigmas = nsigmas
            conf = nsigmas
        else:
            self.confidence_level = confidence_level
            conf = confidence_level
        self.limits = self.statistic.limits(self.center, self.std_dev, self.sizes, conf)

        # TODO violations

    def plot(self, title=None, ax=None):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))
        df = pd.DataFrame({'x': self.labels, 'y': self.stats.statistics})
        ax = df.plot.line(x='x', y='y', style='-o', color='lightgrey',
                          marker='o', markerfacecolor='black', ax=ax)
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

        fig = ax.get_figure()
        fig.subplots_adjust(bottom=0.2)
        fig.text(0.1, 0.1, f'Number of groups = {len(self.labels)}', fontsize=12)
        fig.text(0.1, 0.06, f'Center = {self.center:.5g}', fontsize=12)
        fig.text(0.1, 0.02, f'StdDev = {self.std_dev:.5g}', fontsize=12)
        if len(self.limits) == 1:
            fig.text(0.4, 0.06, f'UCL = {self.limits.UCL[0]:.5g}', fontsize=12)
            fig.text(0.4, 0.02, f'LCL = {self.limits.LCL[0]:.5g}', fontsize=12)
        fig.text(0.6, 0.06, f'Number beyond limits = TODO', fontsize=12)
        fig.text(0.6, 0.02, f'Number violating runs = TODO', fontsize=12)

        fig_title = [f'{self.qcc_type.name} Chart']
        if title is not None:
            fig_title.append(title)
        fig.suptitle('\n'.join(fig_title), fontsize=14)
        return ax


def qcc_groups(data, groups):
    grouped = pd.Series(data).groupby(groups)

    max_size = max(grouped.size())

    result = np.empty((len(grouped), max_size))
    result[:] = np.NaN
    for idx, group in grouped:
        result[idx - 1, :len(group.values)] = group.values
    return result
