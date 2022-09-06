'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numbers
from collections import namedtuple
from enum import Enum

import numpy as np
import pandas as pd
from scipy import stats
from scipy.special import gammaln  # pylint: disable=no-name-in-module

GroupMeans = namedtuple('GroupMeans', 'statistics,center')


class QCCStatistics:

    def __init__(self):
        self.default = None
        self.statistics = {}
        self.register(Xbar_statistic, default=True)
        self.register(Xbar_one_statistic)
        self.register(R_statistic)
        self.register(S_statistic)
        self.register(P_statistic)
        self.register(NP_statistic)

    def get(self, name):
        if name is None and self.default is None:
            raise ValueError('you need give a name as default is not defined')
        if name.lower() not in self.statistics:
            raise ValueError(f'unknown statistic {name}')
        return self.statistics[name.lower()]()

    def register(self, statistic, default=False):
        name = statistic.qcc_type
        if name.lower() in self.statistics:
            raise ValueError(f'duplicate definition of statistics {name}')
        if default and self.default is not None:
            raise ValueError(f'duplicate definition of default statistics {name} and {default}')
        name = name.lower()
        if default:
            self.default = name
        self.statistics[name] = statistic

    def __iter__(self):
        if self.default is not None:
            yield self.statistics[self.default]
        for statistic in self.statistics.values():
            if statistic.qcc_type.lower() == self.default:
                continue
            yield statistic


class SD_estimator(Enum):
    # UnWeighted AVErage of subgroup estimates based on subgroup Ranges
    uwave_r = 'UWAVE-R'
    # UnWeighted AVErage of subgroup estimates based on subgroup Standard Deviations
    uwave_sd = 'UWAVE-SD'
    # Minimum Variance Linear Unbiased Estimator computed as a weighted average of subgroups
    # estimates based on subgroup Ranges
    mvlue_r = 'MVLUE-R'
    # Minimum Variance Linear Unbiased Estimator computed as a weighted average of subgroup
    # estimates based on subgroup Standard Deviations
    mvlue_sd = 'MVLUE-SD'
    # Root-Mean-Square estimator computed as a weighted average of subgroup estimates based
    # on subgroup Standard Deviations
    rmsdf = 'RMSDF'
    mr = 'MR'
    sd = 'SD'

    @classmethod
    def get(cls, name, default):
        if name is None:
            name = default
        if isinstance(name, cls):
            return name
        if not isinstance(name, str):
            raise ValueError(f'name of estimator must be string or SD_estimator, found: {name}')
        name = name.upper()
        for estimator in cls:
            if estimator.value == name:
                return estimator
        raise ValueError(f'unknown SD estimator {name}')


# exp.R.unscaled a vector specifying, for each sample size, the expected value of the relative range
# (i.e. R/σ) for a normal distribution. This appears as d2 on most tables containing factors for
# the construction of control charts.
_exp_R_unscaled = [np.NaN, np.NaN, 1.128, 1.693, 2.059, 2.326, 2.534, 2.704, 2.847, 2.970, 3.078, 3.173,
                   3.258, 3.336, 3.407, 3.472, 3.532, 3.588, 3.640, 3.689, 3.735, 3.778, 3.819, 3.858, 3.895, 3.931]
# se.R.unscaled a vector specifying, for each sample size, the standard error of the relative range
# (i.e. R/σ) for a normal distribution. This appears as d3 on most tables containing factors for
# the construction of control charts.
_se_R_unscaled = [np.NaN, np.NaN, 0.8525033, 0.8883697, 0.8798108, 0.8640855, 0.8480442, 0.8332108, 0.8198378,
                  0.8078413, 0.7970584, 0.7873230, 0.7784873, 0.7704257, 0.7630330, 0.7562217, 0.7499188, 0.7440627,
                  0.7386021, 0.7334929, 0.7286980, 0.7241851, 0.7199267, 0.7158987, 0.7120802, 0.7084528, 0.7050004,
                  0.7017086, 0.6985648, 0.6955576, 0.6926770, 0.6899137, 0.6872596, 0.6847074, 0.6822502, 0.6798821,
                  0.6775973, 0.6753910, 0.6732584, 0.6711952, 0.6691976, 0.6672619, 0.6653848, 0.6635632, 0.6617943,
                  0.6600754, 0.6584041, 0.6567780, 0.6551950, 0.6536532, 0.6521506]


class Base_statistic:
    @staticmethod
    def getSizes(data):
        return [int(n) for n in (~np.isnan(data)).sum(1)]

    def stats(self, data, sizes=None):
        raise NotImplementedError()

    def sd(self, data, *, std_dev=None, sizes=None):
        raise NotImplementedError()

    def limits(self, center, std_dev, sizes, conf):
        raise NotImplementedError()


class Xbar_statistic(Base_statistic):
    """ Statistics used in computing and drawing a Shewhart xbar chart """
    qcc_type = 'xbar'
    description = ('mean', 'means of a continuous process variable')

    def stats(self, data, sizes=None):
        return GroupMeans(np.nanmean(data, axis=1), np.nanmean(data))

    def sd(self, data, *, std_dev=None, sizes=None):
        if isinstance(std_dev, numbers.Number):
            return std_dev

        if sizes is None:
            sizes = self.getSizes(data)

        # set default method if std_dev is None
        if std_dev is None:
            std_dev = SD_estimator.uwave_r
            if max(sizes) > 25:
                std_dev = SD_estimator.rmsdf

        if std_dev == SD_estimator.uwave_r:
            r = np.nanmax(data, axis=1) - np.nanmin(data, axis=1)
            d2 = [_exp_R_unscaled[size] for size in sizes]
            return np.mean(r / d2)
        if std_dev == SD_estimator.uwave_sd:
            s = np.nanstd(data, axis=1, ddof=1)
            c4 = np.array([qcc_c4(size) for size in sizes])
            return np.mean(s / c4)
        if std_dev == SD_estimator.mvlue_r:
            r = np.nanmax(data, axis=1) - np.nanmin(data, axis=1)
            d2 = np.array([_exp_R_unscaled[size] for size in sizes])
            d3 = np.array([_se_R_unscaled[size] for size in sizes])
            w = (d2 / d3) ** 2
            return np.sum(w * r / d2) / np.sum(w)
        if std_dev == SD_estimator.mvlue_sd:
            s = np.nanstd(data, axis=1, ddof=1)
            c4 = np.array([qcc_c4(size) for size in sizes])
            w = c4 ** 2 / (1 - c4**2)
            return np.sum(w * s / c4) / np.sum(w)
        if std_dev == SD_estimator.rmsdf:
            s = np.nanstd(data, axis=1, ddof=1)
            w = np.array([size - 1 for size in sizes])
            return np.sqrt(np.sum(w * s**2) / np.sum(w)) / qcc_c4(np.sum(w) + 1)

        raise NotImplementedError()

    def limits(self, center, std_dev, sizes, conf):
        if conf < 0:
            raise ValueError(f'invalid conf argument {conf}')

        if all(size == sizes[0] for size in sizes):
            sizes = [sizes[0]]

        se_stats = std_dev / np.sqrt(sizes)
        if conf >= 1:
            lcl = center - conf * se_stats
            ucl = center + conf * se_stats
        else:
            sigmas = stats.norm.ppf(1 - (1 - conf) / 2)
            lcl = center - sigmas * se_stats
            ucl = center + sigmas * se_stats
        return pd.DataFrame({'LCL': lcl, 'UCL': ucl})


class Xbar_one_statistic(Base_statistic):
    """ Statistics used in xbar-one charts """
    qcc_type = 'xbarone'
    description = ('mean', 'one-at-time data of a continuous process variable')

    @staticmethod
    def getSizes(data):
        return [1 for _ in data]

    def stats(self, data, sizes=None):
        if isinstance(data, (pd.Series, pd.DataFrame)):
            data = data.values
        return GroupMeans(np.array(data).flatten(), np.mean(data))

    def sd(self, data, *, std_dev=None, sizes=None, k=2):  # pylint: disable=unused-import, arguments-differ
        if isinstance(std_dev, numbers.Number):
            return std_dev

        if isinstance(data, (pd.Series, pd.DataFrame)):
            data = data.values

        # set default method if std_dev is None
        std_dev = SD_estimator.get(std_dev, SD_estimator.mr)
        std_dev = std_dev or SD_estimator.mr
        if isinstance(std_dev, str):
            std_dev = std_dev.upper()

        if std_dev == SD_estimator.mr:
            d = 0
            for i in range(len(data) - (k - 1)):
                group = data[i:i + k]
                d += np.max(group) - np.min(group)
            return d / ((len(data) - k + 1) * _exp_R_unscaled[k])

        if std_dev == SD_estimator.sd:
            return np.std(data, ddof=1) / qcc_c4(len(data))

        raise NotImplementedError(f'estimator {std_dev}')

    def limits(self, center, std_dev, sizes, conf):
        if conf < 0:
            raise ValueError(f'invalid conf argument {conf}')
        se_stats = std_dev
        if conf >= 1:
            lcl = center - conf * se_stats
            ucl = center + conf * se_stats
        else:
            sigmas = stats.norm.ppf(1 - (1 - conf) / 2)
            lcl = center - sigmas * se_stats
            ucl = center + sigmas * se_stats
        if isinstance(lcl, numbers.Number):
            lcl = [lcl]
            ucl = [ucl]
        return pd.DataFrame({'LCL': lcl, 'UCL': ucl})


class R_statistic(Base_statistic):
    """ Statistics used in computing and drawing a Shewhart R chart """
    qcc_type = 'R'
    description = ('range', ' ranges of a continuous process variable')

    def stats(self, data, sizes=None):
        if sizes is None:
            sizes = self.getSizes(data)
        by_group = np.nanmax(data, axis=1) - np.nanmin(data, axis=1)
        return GroupMeans(by_group, sum(sizes * by_group) / sum(sizes))

    def sd(self, data, *, std_dev=None, sizes=None):
        if isinstance(std_dev, numbers.Number):
            return std_dev

        if std_dev is None:
            std_dev = SD_estimator.uwave_r

        if std_dev not in (SD_estimator.uwave_r, SD_estimator.mvlue_r):
            raise ValueError(f'invalid std_dev method {std_dev}')
        return Xbar_statistic().sd(data, std_dev=std_dev, sizes=sizes)

    def limits(self, center, std_dev, sizes, conf):
        if conf < 0:
            raise ValueError(f'invalid conf argument {conf}')

        if all(size == sizes[0] for size in sizes):
            sizes = [sizes[0]]
        sizes = np.array(sizes)

        Rtab = len(_se_R_unscaled)

        if conf >= 1:
            if any(size > Rtab for size in sizes):
                raise ValueError(f'group size must be less than {Rtab + 1} when giving nsigmas')
            seR = std_dev * np.array([_se_R_unscaled[size] for size in sizes])
            lcl = center - conf * seR
            ucl = center + conf * seR
        else:
            # ucl <- qtukey(1 - (1 - conf)/2, sizes, 1e100) * std.dev
            # lcl <- qtukey((1 - conf)/2, sizes, 1e100) * std.dev
            raise NotImplementedError(
                'Tukey studentized range distribution not available from scipy. Use nsigmas instead')
        lcl[lcl < 0] = 0
        return pd.DataFrame({'LCL': lcl, 'UCL': ucl})


class S_statistic(Base_statistic):
    """ Statistics used in computing and drawing a Shewhart S chart """
    qcc_type = 'S'
    description = ('standard deviation', 'standard deviations of a continuous variable')

    def stats(self, data, sizes=None):
        if sizes is None:
            sizes = self.getSizes(data)
        by_group = np.nanstd(data, ddof=1, axis=1)
        return GroupMeans(by_group, sum(sizes * by_group) / sum(sizes))

    def sd(self, data, *, std_dev=None, sizes=None):
        if isinstance(std_dev, numbers.Number):
            return std_dev

        if std_dev is None:
            std_dev = SD_estimator.uwave_sd

        if std_dev not in (SD_estimator.uwave_sd, SD_estimator.mvlue_sd, SD_estimator.rmsdf):
            raise ValueError(f'invalid std_dev method {std_dev}')
        return Xbar_statistic().sd(data, std_dev=std_dev, sizes=sizes)

    def limits(self, center, std_dev, sizes, conf):
        if conf < 0:
            raise ValueError(f'invalid conf argument {conf}')

        if all(size == sizes[0] for size in sizes):
            sizes = [sizes[0]]
        sizes = np.array(sizes)

        c4 = np.array([qcc_c4(size) for size in sizes])
        se_stats = std_dev * np.sqrt(1 - c4**2)
        if conf >= 1:
            lcl = center - conf * se_stats
            ucl = center + conf * se_stats
        else:
            p = (1 - conf) / 2
            chi2 = [stats.chi2(size - 1).ppf(p) for size in sizes]
            lcl = std_dev * np.sqrt(chi2 / (sizes - 1))

            chi2 = [stats.chi2(size - 1).ppf(1 - p) for size in sizes]
            ucl = std_dev * np.sqrt(chi2 / (sizes - 1))
        lcl[lcl < 0] = 0
        return pd.DataFrame({'LCL': lcl, 'UCL': ucl})


class P_statistic(Base_statistic):
    """ Statistics used in computing and drawing a Shewhart p chart """
    qcc_type = 'p'
    description = ('proportion', 'proportion of nonconforming units')

    @staticmethod
    def getSizes(data):
        raise ValueError('p-charts require argument sizes to be provided')

    def stats(self, data, sizes=None):
        if sizes is None:
            raise ValueError('p-charts require argument sizes to be provided')
        if isinstance(sizes, numbers.Number):
            sizes = np.array([sizes] * len(data))
        elif isinstance(sizes, (pd.Series, pd.DataFrame)):
            sizes = sizes.values
        if isinstance(data, (pd.Series, pd.DataFrame)):
            data = data.values
        data = data.flatten()
        sizes = sizes.flatten()
        return GroupMeans(data / sizes, sum(data) / sum(sizes))

    def sd(self, data, *, std_dev=None, sizes=None):
        if isinstance(std_dev, numbers.Number):
            return std_dev
        if isinstance(sizes, numbers.Number):
            sizes = np.array([sizes] * len(data))
        else:
            sizes = np.array(sizes)
        if isinstance(data, (pd.Series, pd.DataFrame)):
            data = data.values
        pbar = np.sum(data) / np.sum(sizes)
        return np.sqrt(pbar * (1 - pbar))

    def limits(self, center, std_dev, sizes, conf):
        if all(size == sizes[0] for size in sizes):
            sizes = [sizes[0]]
        sizes = np.array(sizes)
        limits = NP_statistic().limits(center * sizes, std_dev, sizes, conf)

        if all(size == sizes[0] for size in sizes):
            sizes = [sizes[0]]
        sizes = np.array(sizes)

        limits['LCL'] = limits['LCL'] / sizes
        limits['UCL'] = limits['UCL'] / sizes
        return limits


class NP_statistic(Base_statistic):
    """ Statistics used in computing and drawing a Shewhart np chart """
    qcc_type = 'np'
    description = ('count', 'number of nonconforming units')

    def stats(self, data, sizes=None):
        if sizes is None:
            raise ValueError('np-charts require argument sizes to be provided')
        if isinstance(sizes, numbers.Number):
            sizes = np.array([sizes] * len(data))
        pbar = np.sum(data) / np.sum(sizes)
        center = sizes * pbar
        if all(c == center[0] for c in center):
            center = center[0]
        return GroupMeans(data, center)

    def sd(self, data, *, std_dev=None, sizes=None):
        if isinstance(std_dev, numbers.Number):
            return std_dev
        if isinstance(sizes, numbers.Number):
            sizes = np.array([sizes] * len(data))
        else:
            sizes = np.array(sizes)
        if isinstance(data, (pd.Series, pd.DataFrame)):
            data = data.values

        pbar = np.sum(data) / np.sum(sizes)
        std_dev = np.sqrt(sizes * pbar * (1 - pbar))
        if all(c == std_dev[0] for c in std_dev):
            std_dev = std_dev[0]
        return std_dev

    def limits(self, center, std_dev, sizes, conf):
        if conf < 0:
            raise ValueError(f'invalid conf argument {conf}')

        if all(size == sizes[0] for size in sizes):
            sizes = [sizes[0]]
        sizes = np.array(sizes)

        pbar = np.mean(center / sizes)
        if conf >= 1:
            tol = conf * np.sqrt(pbar * (1 - pbar) * sizes)
            lcl = center - tol
            ucl = center + tol
        else:
            p = (1 - conf) / 2
            lcl = np.array([stats.binom(size, p).ppf(pbar) for size in sizes])
            ucl = np.array([stats.binom(size, p).isf(pbar) for size in sizes])
        lcl[lcl < 0] = 0
        ucl[ucl > sizes] = sizes[ucl > sizes]
        return pd.DataFrame({'LCL': lcl, 'UCL': ucl})

# # c Chart
#
# stats.c <- function(data, sizes)
# {
#   data <- as.vector(data)
#   sizes <- as.vector(sizes)
#   if (length(unique(sizes)) != 1)
#      stop("all sizes must be be equal for a c chart")
#   statistics <- data
#   center <- mean(statistics)
#   list(statistics = statistics, center = center)
# }
#
# sd.c <- function(data, sizes, ...)
# {
#   data <- as.vector(data)
#   std.dev <- sqrt(mean(data))
#   return(std.dev)
# }
#
# limits.c <- function(center, std.dev, sizes, conf)
# {
#   if (conf >= 1)
#      { lcl <- center - conf * sqrt(center)
#        lcl[lcl < 0] <- 0
#        ucl <- center + conf * sqrt(center)
#      }
#   else
#      { if (conf > 0 & conf < 1)
#           { ucl <- qpois(1 - (1 - conf)/2, center)
#             lcl <- qpois((1 - conf)/2, center)
#           }
#        else stop("invalid conf argument. See help.")
#      }
#   limits <- matrix(c(lcl, ucl), ncol = 2)
#   rownames(limits) <- rep("", length = nrow(limits))
#   colnames(limits) <- c("LCL", "UCL")
#   return(limits)
# }
#
# # u Chart
#
# stats.u <- function(data, sizes)
# {
#   data <- as.vector(data)
#   sizes <- as.vector(sizes)
#   statistics <- data/sizes
#   center <- sum(sizes * statistics)/sum(sizes)
#   list(statistics = statistics, center = center)
# }
#
# sd.u <- function(data, sizes, ...)
# {
#   data <- as.vector(data)
#   sizes <- as.vector(sizes)
#   std.dev <- sqrt(sum(data)/sum(sizes))
#   return(std.dev)
# }
#
# limits.u <- function(center, std.dev, sizes, conf)
# {
#   sizes <- as.vector(sizes)
#   if (length(unique(sizes))==1)
#      sizes <- sizes[1]
#   limits.c(center * sizes, std.dev, sizes, conf) / sizes
# }


def qcc_c4(n):
    return np.sqrt(2 / (n - 1)) * np.exp(gammaln(n / 2) - gammaln((n - 1) / 2))


qccStatistics = QCCStatistics()
