'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import random

import numpy as np
import pandas as pd
import pingouin as pg


def availabilityEBD(ttf, ttr, n, seed=None, printSummary=True):
    ''' given TTF and TTR, determines the availbility EBD and calculates asymptotic availability '''
    if seed is not None:
        np.random.seed(seed)
    ttf = np.array(ttf)
    ttr = np.array(ttr)

    _, asf = pg.compute_bootci(ttf, func='mean', n_boot=1000, return_dist=True)
    _, asr = pg.compute_bootci(ttr, func='mean', n_boot=1000, return_dist=True)
    bootavail = pd.Series(asf / (asf + asr), name='availability EBD')
    if printSummary:
        avf = np.mean(asf)
        avr = np.mean(asr)
        avail = avf / (avf + avr)
        print(f'The estimated MTTF from ttf is {avf:.2f}')
        print(f'The estimated MTTR from ttr is {avr:.2f}')
        print(f'The estimated asymptotic availability is {avail:.4f}')
        print()
        print(bootavail.describe())
    return bootavail


def renewalEBD(ttf, ttr, time, n, seed=None, printSummary=True):
    ''' given TTF and TTR, determines the EBD of the number of renewals '''
    if seed is not None:
        random.seed(seed)
    ttf = np.array(ttf)
    ttr = np.array(ttr)

    result = []
    for _ in range(n):
        tt = 0
        it = 1
        while tt < time:
            tt += random.choice(ttf)
            tt += random.choice(ttr)
            it += 1
        result.append(it)

    result = pd.Series(result, name='number of renewals EBD')
    if printSummary:
        print(f'The estimated MEAN NUMBER Of RENEWALS is {np.mean(result):.2f}')
        print(result.describe())
    return result
