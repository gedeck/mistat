# pylint: disable=too-many-arguments, too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import stats

from mistat.qcc.qualityControlChart import QualityControlChart


class ProcessCapability:
    """ Computes process capability indices for a qcc object of type 'xbar' """

    def __init__(self, qcc, spec_limits, std_dev=None, target=None, nsigmas=None,
                 confidence_level=0.95):
        if not isinstance(qcc, QualityControlChart):
            raise ValueError('Argument qcc must be a QualityControlChart object')
        if qcc.qcc_type not in ('xbar', 'xbarone'):
            raise ValueError('Process Capability Analysis only available for charts type "xbar" and "xbar.one" charts')

        self.qcc = qcc
        data = self.qcc.data
        self.nobs = np.count_nonzero(~np.isnan(data))
        self.center = qcc.center
        self.std_dev = std_dev or qcc.std_dev

        lsl = spec_limits[0]
        usl = spec_limits[1]
        self.spec_limits = pd.DataFrame({'LSL': [lsl], 'USL': [usl]})

        self.has_target = target is not None
        self.target = target or np.nanmean(self.spec_limits)
        if target is None:
            self.target = np.nanmean(self.spec_limits)
            self.has_target = True

        # validation:
        # - only one of lcl or ucl can be NaN
        # - target must be between self.spec_limits

        self.nsigmas = nsigmas or self.qcc.nsigmas
        if not self.nsigmas:
            raise ValueError('nsigmas not available from qcc object. Provide nsigmas as argument.')

        self.confidence_level = confidence_level
        self.calcPCIndices()

        self.exp_LSL = np.NaN
        if not np.isnan(lsl):
            self.exp_LSL = stats.norm.cdf((lsl - self.center) / self.std_dev) * 100
        self.exp_USL = np.NaN
        if not np.isnan(usl):
            self.exp_USL = (1 - stats.norm.cdf((usl - self.center) / self.std_dev)) * 100
        self.obs_LSL = np.nanmean(data < lsl) * 100
        self.obs_USL = np.nanmean(data > usl) * 100

    def calcPCIndices(self):
        usl = self.spec_limits.values[0, 1]
        lsl = self.spec_limits.values[0, 0]
        nsigmas = self.nsigmas
        std_dev = self.std_dev
        center = self.center
        target = self.target

        self.Cp = (usl - lsl) / (2 * nsigmas * std_dev)
        self.Cp_u = (usl - self.center) / (nsigmas * std_dev)
        self.Cp_l = (self.center - lsl) / (nsigmas * std_dev)
        self.Cp_k = min(self.Cp_u, self.Cp_l)
        self.Cpm = self.Cp / np.sqrt(1 + ((center - target) / std_dev) ** 2)

        alpha = 1 - self.confidence_level
        alphas = [alpha / 2, 1 - alpha / 2]
        n = self.nobs
        self.Cp_limits = [self.Cp * np.sqrt(stats.chi2(n - 1).ppf(a) / (n - 1)) for a in alphas]
        self.Cp_l_limits = [self.Cp_l * (1 + f * stats.norm.ppf(self.confidence_level) *
                                         np.sqrt(1 / (9 * n * self.Cp_l**2) + 1 / (2 * (n - 1))))
                            for f in (-1, 1)]
        self.Cp_u_limits = [self.Cp_u * (1 + f * stats.norm.ppf(self.confidence_level) *
                                         np.sqrt(1 / (9 * n * self.Cp_u**2) + 1 / (2 * (n - 1))))
                            for f in (-1, 1)]
        self.Cp_k_limits = [self.Cp_k * (1 + f * stats.norm.ppf(1 - alpha / 2) *
                                         np.sqrt(1 / (9 * n * self.Cp_k**2) + 1 / (2 * (n - 1))))
                            for f in (-1, 1)]

        ratio = (center - target) / std_dev
        df = n * (1 + ratio**2) / (1 + 2 * ratio**2)
        self.Cpm_limits = [self.Cpm * np.sqrt(stats.chi2(df).ppf(a) / df) for a in alphas]

    def summary(self):
        print('Process Capability Analysis')
        print()
        print(f'Number of obs = {self.nobs:<4d}         Target = {self.target:.2f}')
        print(f'       Center = {self.center:<14.2f}  LSL = {self.spec_limits.values[0, 0]:.2f}')
        print(f'       StdDev = {self.std_dev:<14.6f}  USL = {self.spec_limits.values[0, 1]:.2f}')
        print()
        print('Capability indices:')
        print()
        print('        Value     2.5%   97.5%')
        for key in ('Cp', 'Cp_l', 'Cp_u', 'Cp_k', 'Cpm'):
            print(f'{key:<5s} {getattr(self, key):8.4f}', end='')
            limits = getattr(self, f'{key}_limits')
            print(f'{limits[0]:8.4f}{limits[1]:8.4f}')
        print()
        print(f'Exp<LSL {self.exp_LSL:3.0f}%   Obs<LSL {self.obs_LSL:3.0f}%')
        print(f'Exp>USL {self.exp_USL:3.0f}%   Obs>USL {self.obs_USL:3.0f}%')

    def plot(self, bins='scott', ax=None):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))
        data = self.qcc.data
        if isinstance(data, pd.DataFrame):
            data = data.values
        data = data.flatten()
        data = data[~np.isnan(data)]
        xlim = [min(np.min(data), np.min(self.spec_limits.values), self.target),
                max(np.max(data), np.max(self.spec_limits.values), self.target)]
        xlim = xlim + np.diff(xlim) * [-0.1, 0.1]

        ax.hist(data, bins=bins, density=True, color='lightgrey', edgecolor='grey')
        xx = np.linspace(*xlim, num=250)
        ax.plot(xx, stats.norm(self.center, self.std_dev).pdf(xx), ls='--', color='gray')

        position = [self.spec_limits.LSL[0], self.target, self.spec_limits.USL[0]]
        ax.axvline(position[0], color='red', ls=':')
        ax.axvline(position[1], color='red', ls='--')
        ax.axvline(position[2], color='red', ls=':')

        ax.secondary_xaxis('bottom')
        ax.xaxis.tick_top()
        ax.set_xticks(position)
        ax.set_xticklabels(['LSL', 'Target', 'USL'])
        ax.set_yticks([])

        fig = ax.get_figure()
        fig.subplots_adjust(bottom=0.25)
        options = {'fontsize': 11}
        col = [0.1, 0.35, 0.55, 0.75]
        row = [0.18, 0.14, 0.1, 0.06, 0.02]
        fig.text(col[0], row[0], f'Number of obs = {self.nobs}', **options)
        fig.text(col[0], row[1], f'Center = {self.center:.5g}', **options)
        fig.text(col[0], row[2], f'StdDev = {self.std_dev:.5g}', **options)

        fig.text(col[1], row[0], f'Target = {self.center:.2g}', **options)
        fig.text(col[1], row[1], f'LSL = {self.spec_limits.LSL[0]:.2g}', **options)
        fig.text(col[1], row[2], f'USL = {self.spec_limits.USL[0]:.2g}', **options)

        fig.text(col[2], row[0], f'Cp = {self.Cp:.2g}', **options)
        fig.text(col[2], row[1], f'Cp_l = {self.Cp_l:.2g}', **options)
        fig.text(col[2], row[2], f'Cp_u = {self.Cp_u:.2g}', **options)
        fig.text(col[2], row[3], f'Cp_k = {self.Cp_k:.2g}', **options)
        fig.text(col[2], row[4], f'Cpm = {self.Cpm:.2g}', **options)

        fig.text(col[3], row[0], f'Exp<LSL = {self.exp_LSL:.2g}%', **options)
        fig.text(col[3], row[1], f'Exp>USL = {self.exp_USL:.2g}%', **options)
        fig.text(col[3], row[2], f'Obs<LSL = {self.obs_LSL:.2g}%', **options)
        fig.text(col[3], row[3], f'Obs>USL = {self.obs_USL:.2g}%', **options)
        return ax
