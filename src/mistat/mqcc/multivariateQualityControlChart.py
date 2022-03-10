# pylint: disable=too-many-arguments,too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import matplotlib.pyplot as plt
import pandas as pd
from scipy import linalg

from mistat.mqcc.statistics import mqccStatistics
from mistat.qcc.rules import shewhartRules


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
        if not 0 < confidence_level < 1:
            raise ValueError('confidence.level must be a numeric value in the range (0,1)')

        if labels is None:
            labels = list(range(len(data)))
        self.labels = labels

        self.stats = self.statistic.stats(data, center=center, cov=cov)

        if newdata is not None:
            self.newdata = newdata
            self.newsizes = self.statistic.get_sizes(newdata)
            self.newstats = self.statistic.stats(newdata, center=self.stats.center, cov=self.stats.cov)
            self.newlabels = newlabels
            if newlabels is None:
                self.newlabels = list(range(len(data), len(data) + len(newdata)))
            # gives self.newdata, self.newstats, self.newsizes
            pred_limits = True
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
            self, run_length=0, limits=self.limits)['beyondLimits']

    def plot(self, title=None, ax=None, show_legend=True):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))
        beyondLimits = [*self.violations['beyondLimits']['LCL'], *self.violations['beyondLimits']['UCL']]
        violatingRuns = self.violations['violatingRuns']
        df = pd.DataFrame({'x': self.labels, 'y': self.stats.statistics})
        ax = df.plot.line(x='x', y='y', style='-', color='lightgrey',
                          marker='o', markerfacecolor='black', ax=ax)
        if self.newdata is not None:
            new_df = pd.DataFrame({'x': self.newlabels, 'y': self.newstats.statistics})
            ax = new_df.plot.line(x='x', y='y', style='-', color='lightgrey',
                                  marker='o', markerfacecolor='black', ax=ax)
            df = pd.concat([df, new_df])
            ax.axvline(0.5 * (self.newlabels[0] + self.labels[-1]), color='black', linestyle='--')

        ax.plot(df.iloc[beyondLimits]['x'], df.iloc[beyondLimits]['y'], linestyle='None',
                marker='s', markerfacecolor='red', markeredgecolor='red')
        ax.plot(df.iloc[violatingRuns]['x'], df.iloc[violatingRuns]['y'],
                linestyle='None', marker='s', markerfacecolor='red', markeredgecolor='red')

        ax.legend().remove()
        ax.set_xlabel('Group')
        ax.set_ylabel('Group summary statistics')

        yticks = {'ticks': [], 'labels': []}
        if self.limits is not None and len(self.limits) == 1:
            ax.axhline(self.limits.LCL[0], color='black', linestyle='--')
            ax.axhline(self.limits.UCL[0], color='black', linestyle='--')

            yticks['ticks'].extend([self.limits.LCL[0], self.limits.UCL[0]])
            yticks['labels'].extend(['LCL', 'UCL'])

        if self.pred_limits is not None and len(self.pred_limits) == 1:
            ax.axhline(self.pred_limits.LPL[0], color='black', linestyle=':')
            ax.axhline(self.pred_limits.UPL[0], color='black', linestyle=':')

            if yticks['ticks'] and yticks['ticks'][0] == self.pred_limits.LPL[0]:
                yticks['labels'][0] = 'LCL/LPL'
            else:
                yticks['labels'].append('LPL')
                yticks['ticks'].append(self.pred_limits.LPL[0])

            yticks['labels'].append('UPL')
            yticks['ticks'].append(self.pred_limits.UPL[0])

        if yticks['ticks']:
            ax2 = ax.twinx()
            ax2.set_ylim(*ax.get_ylim())
            ax2.yaxis.tick_right()
            ax2.set_yticks(yticks['ticks'])
            ax2.set_yticklabels(yticks['labels'])

        fig = ax.get_figure()
        if show_legend:
            fig.subplots_adjust(bottom=0.2)
            fig.text(0.1, 0.1, f'Number of groups = {len(self.labels)}', fontsize=12)
            fig.text(0.1, 0.06, f'Sample size = {self.sizes.samples_sizes}', fontsize=12)
            fig.text(0.1, 0.02, f'|S| = {linalg.det(self.stats.cov):.5g}', fontsize=12)
            if self.limits is not None and len(self.limits) == 1:
                fig.text(0.4, 0.1, f'LCL = {self.limits.LCL[0]:.5g}', fontsize=12)
                fig.text(0.4, 0.06, f'UCL = {self.limits.UCL[0]:.5g}', fontsize=12)
            if self.pred_limits is not None and len(self.pred_limits) == 1:
                fig.text(0.6, 0.1, f'LPL = {self.pred_limits.LPL[0]:.5g}', fontsize=12)
                fig.text(0.6, 0.06, f'UPL = {self.pred_limits.UPL[0]:.5g}', fontsize=12)
            fig.text(0.4, 0.02, f'Number beyond limits = {len(beyondLimits)}', fontsize=12)

        if self.newdata is not None:
            ymax = max(*self.stats.statistics, *self.newstats.statistics)
            ymin = min(*self.stats.statistics, *self.newstats.statistics)
            ymax = 1.05 * ymax - 0.05 * ymin
            xcalibration = 0.5 * (self.labels[0] + self.labels[-1])
            xnewdata = 0.5 * (self.newlabels[0] + self.newlabels[-1])
            ax.text(xcalibration, ymax, 'Calibration data', ha='center', va='top')
            ax.text(xnewdata, ymax, 'New data', ha='center', va='top')

        fig_title = [f'{self.statistic.qcc_type} Chart']
        if title is not None:
            fig_title.append(title)
        fig.suptitle('\n'.join(fig_title), fontsize=14)
        return ax
