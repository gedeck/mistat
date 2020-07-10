'''
Created on Jun 20, 2020

@author: petergedeck
'''
from scipy import linalg

from mistat.mqcc.statistics import mqccStatistics
from mistat.qcc.rules import shewhartRules
import matplotlib.pyplot as plt
import pandas as pd


class MultivariateQualityControlChart:
    def __init__(self, data, qcc_type=mqccStatistics.default,
                 center=None, cov=None,
                 limits=True, pred_limits=False, rules=None,
                 data_name=None, labels=None,
                 newdata=None, newlabels=None,
                 confidence_level=None):
        self.statistic = mqccStatistics.get(qcc_type)
        self.qcc_type = self.statistic.qcc_type

        self.sizes = self.statistic.get_sizes(data)
        num_samples, sample_sizes, p = self.sizes
        if isinstance(num_samples, list):
            raise ValueError('varying number of samples (rows)')
        if isinstance(sample_sizes, list):
            raise ValueError('varying sample size (columns)')
        if sample_sizes == 1:
            self.statistic = mqccStatistics.get('T2single')
            self.qcc_type = self.statistic.qcc_type

        if confidence_level is None:
            confidence_level = (1 - 0.0027) ** p
        if not (0 < confidence_level < 1):
            raise ValueError('confidence.level must be a numeric value in the range (0,1)')

        if labels is None:
            labels = list(range(len(data)))
        self.labels = labels

        self.stats = self.statistic.stats(data, center=center, cov=cov)

        if newdata is not None:
            raise NotImplementedError()
            # gives self.newdata, self.newstats, self.newsizes
        else:
            self.newdata = None
            self.newstats = None
            self.newsizes = None

        if isinstance(limits, bool):
            if limits:
                limits = self.statistic.limits(num_samples, sample_sizes, p, confidence_level)
                self.limits = limits['control']
            else:
                self.limits = None
        else:
            self.limits = limits

        if isinstance(pred_limits, bool):
            if pred_limits:
                pred_limits = self.statistic.limits(num_samples, sample_sizes, p, confidence_level)
                self.pred_limits = pred_limits['prediction']
            else:
                self.pred_limits = None
        else:
            self.pred_limits = pred_limits

        self.violations = shewhartRules(self, run_length=0)
        self.violations['beyondPredLimits'] = shewhartRules(
            self, run_length=0, limits=self.pred_limits)['beyondLimits']

    def plot(self, title=None, ax=None):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))
        beyondLimits = [*self.violations['beyondLimits']['LCL'], *self.violations['beyondLimits']['UCL']]
        violatingRuns = self.violations['violatingRuns']
        df = pd.DataFrame({'x': self.labels, 'y': self.stats.statistics})
        ax = df.plot.line(x='x', y='y', style='-o', color='lightgrey',
                          marker='o', markerfacecolor='black', ax=ax)
        ax.plot(df.iloc[beyondLimits]['x'], df.iloc[beyondLimits]['y'], linestyle='None',
                marker='s', markerfacecolor='red', markeredgecolor='red')
        ax.plot(df.iloc[violatingRuns]['x'], df.iloc[violatingRuns]['y'],
                linestyle='None', marker='s', markerfacecolor='red', markeredgecolor='red')
        ax.legend().remove()
        ax.set_xlabel('Group')
        ax.set_ylabel('Group summary statistics')

        if len(self.limits) == 1:
            ax.axhline(self.limits.LCL[0], color='black', linestyle='--')
            ax.axhline(self.limits.UCL[0], color='black', linestyle='--')
            ax2 = ax.twinx()
            ax2.set_ylim(*ax.get_ylim())
            ax2.yaxis.tick_right()
            ax2.set_yticks([self.limits.LCL[0], self.limits.UCL[0]])
            ax2.set_yticklabels(['LCL', 'UCL'])

        fig = ax.get_figure()
        fig.subplots_adjust(bottom=0.2)
        fig.text(0.1, 0.1, f'Number of groups = {len(self.labels)}', fontsize=12)
        fig.text(0.1, 0.06, f'Sample size = {self.sizes.samples_sizes}', fontsize=12)
        fig.text(0.1, 0.02, f'|S| = {linalg.det(self.stats.cov):.5g}', fontsize=12)
        if len(self.limits) == 1:
            fig.text(0.4, 0.06, f'LCL = {self.limits.LCL[0]:.5g}', fontsize=12)
            fig.text(0.4, 0.02, f'UCL = {self.limits.UCL[0]:.5g}', fontsize=12)
        fig.text(0.6, 0.06, f'Number beyond limits = {len(beyondLimits)}', fontsize=12)

        fig_title = [f'{self.statistic.qcc_type} Chart']
        if title is not None:
            fig_title.append(title)
        fig.suptitle('\n'.join(fig_title), fontsize=14)
        return ax
