'''
Created on Jul 6, 2020

@author: petergedeck
'''
from scipy import stats

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from .statistics import qccStatistics, Base_statistic


class Cusum:
    def __init__(self, data, center=None, std_dev=None, sizes=None, head_start=0, decision_interval=5,
                 se_shift=1, newdata=None):
        data = pd.DataFrame(data)
        if sizes is None:
            sizes = Base_statistic.getSizes(data)
        elif isinstance(sizes, int):
            sizes = np.array([sizes] * len(data))
        elif len(sizes) != len(data):
            raise ValueError('sizes length doesn'' match with data')
        if decision_interval <= 0:
            raise ValueError('decision_interval must be positive')

        if not (0 <= head_start < decision_interval):
            raise ValueError('head_start must be non-negative and less than decision_interval')

        qcc_type = 'xbarone' if any(size == 1 for size in sizes) else 'xbar'
        if len(data.columns) == 1 and any(size > 1 for size in sizes) and std_dev is None:
            raise ValueError('sizes larger than 1 but data appears to be single samples. '
                             'In this case you must provide also the std_dev')

        qccStatistic = qccStatistics.get(qcc_type)
        statistics = qccStatistic.stats(data, sizes)
        center = center
        if center is None:
            center = statistics.center
        std_dev = qccStatistic.sd(data, std_dev, sizes=sizes)

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
        self.violations = violations

    def plot(self, ax=None, title=None, xlabel='Group', ylabel='Cumulative Sum'):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))
#         n_beyond_bounds = sum([len(self.violations['lower']), len(self.violations['upper'])])

        if self.newdata is not None:
            raise NotImplementedError()
        else:
            statistics = self.statistics
            indices = list(range(len(statistics)))

        if title is not None:
            ax.set_title(title)

#         ax.plot(indices, statistics)
#         ax.set_ylim(np.min([*self.pos, *self.neg, self.decision_interval, -self.decision_interval]),
#                     np.max([*self.pos, *self.neg, self.decision_interval, -self.decision_interval]))
        ax.set_xlabel(xlabel)
        ax.set_ylabel(ylabel)

        ax.axhline(0, linewidth=2)
        ax.axhline(self.decision_interval, linestyle=':')
        ax.axhline(-self.decision_interval, linestyle=':')

        ax.plot(indices, self.pos[indices], marker="o")
        ax.plot(indices, self.neg[indices], marker="o")

        raise NotImplementedError()


def cusumArl(*, randFunc=None, N=100, limit=10_000, seed=None,
             kp=1, km=-1, hp=3, hm=-3,
             side='both', verbose=True):
    side = side.lower()
    if side not in ("both", "upper", "lower"):
        raise ValueError("side = '{side}' is not supported.")
    np.random.seed(seed)

    randFunc = randFunc or stats.norm()

    data = pd.DataFrame(randFunc.rvs(N) for _ in range(limit))
    print(data.shape)

    n = limit


#
#   data <- matrix(randFunc(n=limit*N, ...), nrow=N)
#   n <- ncol(data)
#
#   res <- list(run=apply(data, MARGIN=1, .runLength, kp=kp, km=km, ubd=hp, lbd=hm, side=side))
#   res$rls <- sapply(res$run, function(x) x$rl)
#
#   res$statistic <- c(mean(res$rls), sqrt((mean(res$rls^2) - mean(res$rls))/N))
#   names(res$statistic) <- c("ARL", "Std. Error")
#
#   if(printSummary)
#     print(res$statistic)
#
#   invisible(res)
# }
