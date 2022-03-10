# pylint: disable=too-many-arguments
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import random

import pandas as pd
import pingouin as pg


def randomizationTest(a, b, sample_stat, aggregate_stats=None, n_boot=500, seed=None,
                      printSummary=True):
    sample_values = pd.Series([*a, *b])
    sampleLabels = [*['a'] * len(a), *['b'] * len(b)]

    def apply_func(labels):
        stats = list(sample_values.groupby(labels).apply(sample_stat))
        if aggregate_stats is not None:
            stats = aggregate_stats(stats)
        return stats
    Bt0 = apply_func(sampleLabels)

    def apply_func_RSWOR(labels):
        # replace bootstrapped sample with RSWOR
        labels = random.sample(sampleLabels, len(sampleLabels))

        stats = list(sample_values.groupby(labels).apply(sample_stat))
        if aggregate_stats is not None:
            stats = aggregate_stats(stats)
        return stats
    random.seed(seed)
    B = pg.compute_bootci(sampleLabels, func=apply_func_RSWOR, n_boot=n_boot,
                          confidence=0.95, seed=seed, return_dist=True)

    if printSummary:
        # include the original stat in the quantile calculation
        orgPosition = sum(B[1] < Bt0) + 1
        quantile = 100 * orgPosition / (n_boot + 1)
        print(f'Original stat is {Bt0:.6f}')
        print(f'Original stat is at quantile {orgPosition} of {n_boot + 1} ' +
              f'({quantile:.2f}%)')
        dist = pd.Series(B[1]).describe()
        print('Distribution of bootstrap samples:')
        print(f" min: {dist['min']:.2f}, median: {dist['50%']:.2f},  max: {dist['max']:.2f}")
    return [*B[1], Bt0]
