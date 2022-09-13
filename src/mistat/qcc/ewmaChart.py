# pylint: disable=too-many-arguments,too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from mistat.qcc.statistics import Base_statistic, qccStatistics


def ewmaSmooth(y, x=None, smooth=0.20, start=None):
    """
    Exponential-Weighted Moving Average

    Return smooth values based on

    z_t = smooth*y_t + (1-smooth)*z_t-1

    where 0<= smooth <=1 is the parameter which controls the weights applied
    to the data, and start is the starting value.

    Returns a list with elements:
    x = ordered x-values
    y = smoothed fitted values of y

    if x is provided, y values will be reordered
    """
    if not 0 <= abs(smooth) <= 1:
        raise ValueError('smooth parameter must be between 0 and 1')
    if x is None:
        x = list(range(len(y)))
    else:
        if len(x) != len(y):
            raise ValueError('x and y must have the same length')
        x, y = zip(*sorted(zip(x, y)))

    last = start if start is not None else y[0]
    z = []
    for yi in y:
        last = smooth * yi + (1 - smooth) * last
        z.append(last)
    return {
        'x': np.array(x),
        'y': np.array(z),
        'smooth': smooth,
        'start': start,
    }


class EWMA:
    def __init__(self, data, sizes=None, center=None, std_dev=None, smooth=0.2, nsigmas=3, newdata=None):
        if sizes is None:
            sizes = Base_statistic.getSizes(data)
        elif isinstance(sizes, int):
            sizes = [sizes] * len(data)
        else:
            if len(sizes) != len(data):
                raise ValueError('sizes and data must have the same length')
        qcc_type = 'xbarone' if set(sizes) == {1} else 'xbar'

        qccStatistic = qccStatistics.get(qcc_type)
        statistics = qccStatistic.stats(data, sizes)

        if center is None:
            center = statistics.center
        std_dev = qccStatistic.sd(data, std_dev=std_dev, sizes=sizes)

        self.data = data
        self.statistics = statistics.statistics
        self.sizes = np.array(sizes)
        self.center = center
        self.std_dev = std_dev

        if newdata is not None:
            raise NotImplementedError('requires implementation')

        self.ewma = ewmaSmooth(self.statistics, smooth=smooth, start=center)
        self.x = self.ewma['x']
        self.y = self.ewma['y']
        self.smooth = smooth

        L1 = smooth / (2 - smooth)
        f = 2 * np.arange(1, len(self.statistics) + 1)
        L2 = 1 - (1 - smooth) ** f

        sigma2 = std_dev ** 2 / self.sizes * L1 * L2
        self.sigma = np.sqrt(sigma2)
        self.nsigmas = nsigmas
        self.ucl = center + nsigmas * np.sqrt(sigma2)
        self.lcl = center - nsigmas * np.sqrt(sigma2)
        self.violations = list(np.where(self.y < self.lcl)[0])
        self.violations.extend(np.where(self.y > self.ucl)[0])
        self.violations = np.array(sorted(self.violations))

    def plot(self, ax=None):
        if ax is None:
            _, ax = plt.subplots(figsize=(7, 6))

        pd.Series(self.statistics).plot(marker='+', linestyle='None', color='grey', ax=ax)
        v = np.array(self.violations)
        ax.plot(self.x, self.y, color='black')
        if v.size > 0:
            ax.plot(self.x[v], self.y[v], linestyle='None', marker='s', color='red')
            ax.plot(np.delete(self.x, v), np.delete(self.y, v), linestyle='None',
                    marker='o', color='black', markersize=4)
        ax.axhline(self.center, color='grey')
        ax.plot(self.x, self.ucl, color='black', linestyle='--')
        ax.plot(self.x, self.lcl, color='black', linestyle='--')

        ax2 = ax.twinx()
        ax2.set_ylim(*ax.get_ylim())
        ax2.yaxis.tick_right()
        ax2.set_yticks([self.lcl[-1], self.ucl[-1], self.center])
        ax2.set_yticklabels(['LCL', 'UCL', 'CL'])

        ax.set_title('EWMA Chart')
        ax.set_xlabel('Group')
        ax.set_ylabel('Group summary statistics')

        fig = ax.get_figure()
        fig.subplots_adjust(bottom=0.23)
        fig.text(0.1, 0.1, f'Number of groups = {len(self.statistics)}', fontsize=12)
        fig.text(0.1, 0.06, f'Center = {self.center:.5g}', fontsize=12)
        fig.text(0.1, 0.02, f'StdDev = {self.std_dev:.5g}', fontsize=12)

        fig.text(0.5, 0.1, f'Smoothing parameter = {self.smooth}', fontsize=12)
        fig.text(0.5, 0.06, f'Control limits at {self.nsigmas}*sigma', fontsize=12)
        fig.text(0.5, 0.02, f'No. of points beyond limits = {len(self.violations)}', fontsize=12)

        return ax
