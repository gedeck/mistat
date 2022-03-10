'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import itertools
from itertools import groupby
from numbers import Number

import numpy as np
import pandas as pd

RUN_LENGTH = 7


# Functions used to signal points out of control

def shewhartRules(qcc, **kwargs):
    return {
        **beyondLimits(qcc, **kwargs),
        **violatingRuns(qcc, **kwargs),
    }


def beyondLimits(qcc, limits=None, **kwargs):
    limits = qcc.limits if limits is None else limits
    statistics = list(qcc.stats.statistics)
    if qcc.newstats:
        statistics.extend(qcc.newstats.statistics)
    if isinstance(statistics, pd.Series):
        statistics = statistics.values
    statistics = np.array(statistics).flatten()

    if len(limits['UCL']) == 1:
        return {'beyondLimits': {'UCL': np.nonzero(statistics > limits['UCL'][0])[0],
                                 'LCL': np.nonzero(statistics < limits['LCL'][0])[0]}}
    return {'beyondLimits': {'UCL': np.nonzero(statistics.ravel() > limits['UCL'].ravel())[0],
                             'LCL': np.nonzero(statistics.ravel() < limits['LCL'].ravel())[0]}}


def violatingRuns(qcc, run_length=7, **kwargs):
    if run_length == 0:
        return {'violatingRuns': []}
    center = qcc.center
    statistics = list(qcc.stats.statistics)
    if qcc.newstats:
        statistics.extend(qcc.newstats.statistics)
    if isinstance(statistics, pd.Series):
        statistics = statistics.values
    statistics = np.array(statistics).flatten()
    if isinstance(center, Number) or len(center.shape) == 0:
        diffs = statistics - center
    elif center.shape[0] == 1:
        diffs = statistics - center[0]
    else:
        raise NotImplementedError()
    diffs[diffs > 0] = 1
    diffs[diffs < 0] = -1
    runs = run_length_encoding(diffs, as_list=True)
    violating = runs >= run_length
    violating_above = violating & (diffs > 0)
    violating_below = violating & (diffs < 0)

    violators = []
    for violating in (violating_above, violating_below):
        current = 0
        for length, violates in run_length_encoding(violating):
            if violates:
                violators.extend(range(current + run_length - 1, current + length))
            current += length
    return {'violatingRuns': violators}


def run_length_encoding(sequence, as_list=False):
    rle = [(len(list(g)), k) for k, g in groupby(sequence)]
    if as_list:
        def flatten(x):
            return itertools.chain(*x)
        rle = np.array(list(flatten([count] * count for count, _ in rle)))
    return rle
