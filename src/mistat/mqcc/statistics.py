'''
Created on Jul 9, 2020

@author: petergedeck
'''
from collections import namedtuple
from string import ascii_uppercase

from scipy import linalg
from scipy import stats

from mistat.qcc.statistics import QCCStatistics
import numpy as np
import pandas as pd


GroupStatistics = namedtuple('GroupStatistics', 'statistics,means,center,cov')
DataSizes = namedtuple('DataSizes', 'num_samples,samples_sizes,num_variables')


class MQCCStatistics(QCCStatistics):

    def __init__(self):
        self.default = None
        self.statistics = {}
        self.register(T2_statistic, default=True)
        self.register(T2single_statistic)


class T2_statistic:
    """ Statistics used in computing and drawing a Shewhart xbar chart """
    qcc_type = 't2'
    description = ('T2', 'Hotelling T^2 chart for subgrouped data')

    def get_sizes(self, data):
        shapes = {k: v.shape for k, v in data.items()}
        num_samples = [v[0] for v in shapes.values()]  # m
        if len(set(num_samples)) == 1:
            num_samples = num_samples[0]
        sample_sizes = [v[1] for v in shapes.values()]  # n
        if len(set(sample_sizes)) == 1:
            sample_sizes = sample_sizes[0]
        p = len(data)  # number of variables
        return DataSizes(num_samples, sample_sizes, p)

    def stats(self, data, center=None, cov=None):
        num_samples, sample_sizes, p = self.get_sizes(data)

        # within sample means
        means = pd.DataFrame({k: np.nanmean(v, axis=1) for k, v in data.items()})
        # overall mean
        if center is None:
            center = pd.DataFrame([{k: np.nanmean(v) for k, v in data.items()}])
        else:
            center = pd.DataFrame(center)
        x = means.sub(center.values, axis=1)

        if cov is None:
            cov = np.zeros([p, p])
            for i in range(num_samples):
                sampleMean = means.iloc[i, :].values
                d = np.transpose(np.array([v[i] for k, v in data.items()]))
                d = d - sampleMean
                d = np.transpose(d) @ d
                cov += d / (sample_sizes - 1)
            cov = cov / num_samples
        cov_inv = linalg.inv(cov)

        T2 = sample_sizes * x.apply(lambda x: x @ cov_inv @ x, axis=1)
        return GroupStatistics(statistics=T2, means=means, center=center, cov=cov)

    def limits(self, ngroups, size, nvars, conf):
        m = ngroups  # num. of samples
        n = size  # samples sizes
        p = nvars  # num. of variables

        upper = p * (n - 1) / (m * n - m - p + 1) * stats.f(p, m * n - m - p + 1).ppf(conf)

        # Phase 1 control limits
        ucl = (m - 1) * upper
        lcl = 0
        control = pd.DataFrame([{'LCL': lcl, 'UCL': ucl}])

        # Phase 2 prediction limits
        ucl = (m + 1) * upper
        lcl = 0
        prediction = pd.DataFrame([{'LPL': lcl, 'UPL': ucl}])

        return {'control': control, 'prediction': prediction}


class T2single_statistic:
    """ Statistics used in computing and drawing a Shewhart xbar chart """
    qcc_type = 't2single'
    description = ('T2 single', 'Hotelling T^2 chart for individual observations')

    def get_sizes(self, data):
        return DataSizes(data.shape[0], 1, data.shape[1])

    def stats(self, data, center=None, cov=None):
        data = pd.DataFrame(data)
        m, _, _ = self.get_sizes(data)

        if center is None:
            center = np.mean(data, axis=0)
        else:
            center = pd.DataFrame(center)
        x = data.sub(center.values.flatten(), axis=1)
        if cov is None:
            cov = np.transpose(x) @ x
            cov = cov / (m - 1)
        cov_inv = linalg.inv(cov)
        T2 = x.apply(lambda x: x @ cov_inv @ x, axis=1)
        return GroupStatistics(statistics=T2, means=data, center=center, cov=cov)

    def limits(self, ngroups, size, nvars, conf):
        m = ngroups  # num. of samples
        n = size  # samples sizes # @UnusedVariable
        p = nvars  # num. of variables

        # Phase 1 control limits
        ucl = (m - 1)**2 / m * stats.beta(p / 2, (m - p - 1) / 2).ppf(conf)
        lcl = 0
        control = pd.DataFrame([{'LCL': lcl, 'UCL': ucl}])

        # Phase 2 prediction limits
        ucl = p * (m + 1) * (m - 1) / (m * (m - p)) * stats.f(p, m - p).ppf(conf)
        lcl = 0
        prediction = pd.DataFrame([{'LPL': lcl, 'UPL': ucl}])

        return {'control': control, 'prediction': prediction}


mqccStatistics = MQCCStatistics()
