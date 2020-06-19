'''
Created on Jun 19, 2020

@author: petergedeck
'''
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

    B = pg.compute_bootci(sampleLabels, func=apply_func, n_boot=n_boot,
                          confidence=0.95, seed=seed, return_dist=True)
    Bt0 = apply_func(sampleLabels)

    if printSummary:
        # include the original stat in the quantile calculation
        orgPosition = sum(B[1] < Bt0) + 1
        quantile = 100 * orgPosition / (n_boot + 1)
        print(f'Original stat is at quantile {orgPosition} of {n_boot + 1} ' +
              f'({quantile:.2f}%)')
        print(f'Original stat is {Bt0:.6f}')
    return [*B[1], Bt0]
