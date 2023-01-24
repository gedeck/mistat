# pylint: disable=too-many-arguments,too-many-instance-attributes
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from collections import namedtuple

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import stats

from .statistics import Base_statistic, qccStatistics


class Cusum:
    def __init__(self, data, center=None, std_dev=None, sizes=None, head_start=0, decision_interval=5,
                 se_shift=1, newdata=None):
        data = pd.DataFrame(data)
        if sizes is None:
            sizes = Base_statistic.getSizes(data)
        elif isinstance(sizes, int):
            sizes = np.array([sizes] * len(data))
        elif len(sizes) != len(data):
            raise ValueError("sizes length doesn't match with data")
        if decision_interval <= 0:
            raise ValueError('decision_interval must be positive')

        if not 0 <= head_start < decision_interval:
            raise ValueError('head_start must be non-negative and less than decision_interval')

        qcc_type = 'xbarone' if any(size == 1 for size in sizes) else 'xbar'
        if len(data.columns) == 1 and any(size > 1 for size in sizes) and std_dev is None:
            raise ValueError('sizes larger than 1 but data appears to be single samples. '
                             'In this case you must provide also the std_dev')

        qccStatistic = qccStatistics.get(qcc_type)
        statistics = qccStatistic.stats(data, sizes)

        if center is None:
            center = statistics.center
        std_dev = qccStatistic.sd(data, std_dev=std_dev, sizes=sizes)

        self.newdata = None
        if newdata is not None:
            raise NotImplementedError()

        z = (statistics.statistics.flatten() - center) / (std_dev / np.sqrt(sizes))
        ldb = -decision_interval
        udb = decision_interval

        z_f = z - se_shift / 2
        cusum_pos = [max(0, head_start + z_f[0])]
        for zfi in z_f[1:]:
            cusum_pos.append(max(0, cusum_pos[-1] + zfi))
        cusum_pos = np.array(cusum_pos)

        z_f = z + se_shift / 2
        cusum_neg = [max(0, head_start - z_f[0])]
        for zfi in z_f[1:]:
            cusum_neg.append(max(0, cusum_neg[-1] - zfi))
        cusum_neg = np.array([-v for v in cusum_neg])

        violations = {'lower': np.where(cusum_neg < ldb)[0],
                      'upper': np.where(cusum_pos > udb)[0]}

        self.data = data
        self.statistics = statistics.statistics
        self.sizes = sizes
        self.center = center
        self.std_dev = std_dev

        self.pos = cusum_pos
        self.neg = cusum_neg
        self.head_start = head_start
        self.decision_interval = decision_interval
        self.se_shift = se_shift
        self.ldb = ldb
        self.udb = udb
        self.violations = violations

    def plot(self, ax=None, title='cusum Chart', xlabel='Group', ylabel='Cumulative Sum'):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))

        if self.newdata is not None:
            raise NotImplementedError()

        statistics = self.statistics
        indices = list(range(len(statistics)))

        if title is not None:
            ax.set_title(title)

        ax.set_xlabel(xlabel)
        ax.set_ylabel(ylabel)

        ax.axhline(0, linewidth=2, color='grey')
        ax.axhline(self.decision_interval, linestyle=':', color='grey')
        ax.axhline(-self.decision_interval, linestyle=':', color='grey')

        indices = np.array(indices)
        for cs, v in [(self.pos, self.violations['upper']), (self.neg, self.violations['lower'])]:
            v = np.array(v)
            ax.plot(indices, cs, color='grey')
            ax.plot(indices[v], cs[v], marker="s", color='red')
            subset = []
            for idx in indices:
                if idx in v:
                    ax.plot(indices[subset], cs[subset], color='black', marker='o', markersize=4)
                    subset = []
                else:
                    subset.append(idx)
            if subset:
                ax.plot(indices[subset], cs[subset], color='black', marker='o', markersize=4)

        ax2 = ax.twinx()
        ax2.set_ylim(*ax.get_ylim())
        ax2.yaxis.tick_right()
        ax2.set_yticks([self.ldb, self.udb])
        ax2.set_yticklabels(['LDB', 'UDB'])

        fig = ax.get_figure()
        fig.subplots_adjust(bottom=0.23)
        fig.text(0.2, 0.1, f'Number of groups = {len(self.statistics)}', fontsize=12)
        fig.text(0.2, 0.06, f'Center = {self.center:.5g}', fontsize=12)
        fig.text(0.2, 0.02, f'StdDev = {self.std_dev:.5g}', fontsize=12)

        fig.text(0.5, 0.1, f'Decision interval (std. err.) = {self.decision_interval}', fontsize=12)
        fig.text(0.5, 0.06, f'Shift detection (std. err.) {self.se_shift}', fontsize=12)
        nrBeyondLimits = len(self.violations['upper']) + len(self.violations['lower'])
        fig.text(0.5, 0.02, f"No. of points beyond limits = {nrBeyondLimits}", fontsize=12)


def cusumArl(*, randFunc=None, N=1000, limit=10_000, seed=None,
             kp=1, km=-1, hp=3, hm=-3,
             side='both', verbose=False):
    side = side.lower()
    if side not in ("both", "upper", "lower"):
        raise ValueError("side = '{side}' is not supported.")
    np.random.seed(seed)

    randFunc = randFunc or stats.norm()

    result = {}
    result['run'] = [runLength(randFunc.rvs(limit), kp, km, hp, hm, side) for _ in range(N)]
    rls = np.array([run.rl for run in result['run']])
    result['rls'] = rls
    # Ignore inf values for statistics calculations
    rls = np.ma.masked_invalid(rls)
    result['statistic'] = {
        'ARL': np.mean(rls),
        'Std. Error': np.sqrt((np.mean(rls ** 2) - np.mean(rls)) / N),
    }
    if verbose:
        statistic = result['statistic']
        print(f"ARL {statistic['ARL']:.5g}  Std. Error {statistic['Std. Error']:.5g}")
    return result


def cusumPfaCed(*, randFunc1=None, randFunc2=None,
                tau=10, N=100, limit=10_000, seed=None,
                kp=1, km=-1, hp=3, hm=-3,
                side='both', verbose=True):
    side = side.lower()
    if side not in ("both", "upper", "lower"):
        raise ValueError("side = '{side}' is not supported.")
    np.random.seed(seed)

    rls = []
    for _ in range(N):
        x = [*randFunc1.rvs(tau), *randFunc2.rvs(limit - tau)]
        rls.append(runLength(x, kp, km, hp, hm, side).rl)
    result = {'rls': rls}

    rls = np.ma.masked_invalid(rls)
    pfa = np.mean(rls < tau)
    ced = np.mean(rls[rls >= tau]) - tau
    se = np.sqrt(
        (np.sum(rls[rls >= tau] ** 2) / (N - np.sum(rls < tau)) - ced ** 2)
        /
        (N - np.sum(rls < tau)))

    result['statistic'] = {
        'PFA': pfa,
        'CED': ced,
        'Std. Error': se
    }
    if verbose:
        statistic = result['statistic']
        print(f"PFA {statistic['PFA']:.5g}  CED {statistic['CED']:.5g}  Std. Error {statistic['Std. Error']:.5g}")
    return result


#
#   res <- list(run = apply(data, MARGIN=1, .runLength, kp=kp, km=km, ubd=hp, lbd=hm, side=side))
#   res$rls <- sapply(res$run, function(x) x$rl)
#
#   pfa <- sum(res$rls < tau)/nrow(data)
#   ced = sum(res$rls[res$rls >= tau])/(nrow(data) - sum(res$rls < tau)) - tau
#   se = sqrt((sum(res$rls[res$rls >= tau]^2)/(nrow(data) - sum(res$rls < tau)) - ced ^ 2) /
#            (nrow(data) - sum(res$rls < tau)))
#
#   res$statistic <- c(pfa, ced, se)
#   names(res$statistic) <- c("PFA", "CED", "Std. Error")
#
#   if(printSummary)
#     print(res$statistic)
#
#   invisible(res)


def runLength(x, kp, km, ubd, lbd, side):
    x = np.array(x)

    if side in ['both', 'upper']:
        cusum = 0
        vUpper = np.inf
        for i, zfi in enumerate(x - kp):
            cusum = max(0, cusum + zfi)
            if cusum > ubd:
                vUpper = i
                break

    if side in ['both', 'lower']:
        cusum = 0
        vLower = np.inf
        for i, zfi in enumerate(x - km):
            cusum = min(0, cusum + zfi)
            if cusum < lbd:
                vLower = i
                break
    Result = namedtuple('RunLength', 'violationsLower,violationsUpper,rl')
    rl = 1
    if side == 'both':
        rl = min(vLower, vUpper)
    elif side == 'upper':
        rl = min(vUpper)
    elif side == 'lower':
        rl = min(vLower)
    return Result(vLower, vUpper, rl)
