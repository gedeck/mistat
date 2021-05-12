'''
Created on Jul 4, 2020

@author: petergedeck
'''
from itertools import combinations
from itertools import product

from scipy import stats
import patsy

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns


def calculateMainEffects(df, response, factors=None):
    if response not in df.columns:
        raise ValueError(f'Response {response} not found in data')
    factors = factors or [c for c in df.columns if c != response]
    mainEffects = []
    for column in factors:
        for level, g in sorted(df[response].groupby(df[column])):
            mainEffects.append({'factor': column, 'level': level, 'mean': g.mean()})
    return pd.DataFrame(mainEffects)


def calculateInteractions(df, response, factors=None):
    factors = factors or [c for c in df.columns if c != response]
    interactions = []
    for f1, f2 in product(factors, factors):
        for (l1, l2), g in df[response].groupby([df[f1], df[f2]]):
            interactions.append({'f1': f1, 'l1': l1, 'f2': f2, 'l2': l2, 'mean': g.mean()})
    return pd.DataFrame(interactions)


def mainEffectsPlot(df, response, factors=None, col_wrap=None, aspect=0.4, height=3, continuous=False):
    factors = factors or [c for c in df.columns if c != response]
    mainEffects = calculateMainEffects(df, response, factors)
    col_wrap = col_wrap or len(factors)

    def effectPlot(x, y, **kwargs):
        ax = plt.gca()
        ax.plot(x, y, marker='s')
        ax.axhline(kwargs['meanEffect'], color='grey', linestyle=':')
        x = sorted(x)
        d = 0.35 * (x[-1] - x[0])
        ax.set_xlim(x[0] - d, x[-1] + d)
        if not continuous:
            ax.set_xticks(x)

    dy = 0.15 * (mainEffects['mean'].max() - mainEffects['mean'].min())
    ylim = [mainEffects['mean'].min() - dy, mainEffects['mean'].max() + dy]
    meanEffect = df[response].mean()

    g = sns.FacetGrid(mainEffects, col='factor', col_wrap=col_wrap, height=height,
                      sharex=False, aspect=aspect, despine=True, ylim=ylim)
    g.map(effectPlot, 'level', 'mean', meanEffect=meanEffect).set_titles('')
    g.fig.subplots_adjust(wspace=.02)
    for idx, column in enumerate(factors):
        g.axes[idx].set_xlabel(column)


def interactionPlot(df, response, factors=None):
    factors = factors or [c for c in df.columns if c != response]
    interactions = calculateInteractions(df, response, factors)

    def setLimits(set_lim, values, f):
        v = sorted(set(values))
        d = f * (v[-1] - v[0])
        set_lim(v[0] - d, v[-1] + d)

    def effectPlot(x1, x2, y, **kwargs):
        x2values = sorted(set(x2), reverse=True)
        linestyle = ['-', '--', ':']
        color = ['black', 'red', 'blue']
        marker = ['s', '^', 'o']

        ax = plt.gca()
        setLimits(ax.set_xlim, x1, 0.35)
        ax.set_xticks(sorted(set(x1)))
        if len(x1) == len(set(x1)):
            for idx, x2i in enumerate(x2values):
                yi = (idx + 1) / (len(x2values) + 1)
                i = idx % len(linestyle)
                ax.text(0.2, yi, f'{x2i:.4g}', transform=ax.transAxes, verticalalignment='center')
                ax.plot(0.1, yi, marker=marker[i], color=color[i], linestyle=linestyle[i], transform=ax.transAxes)
            return
        for x2i, group in pd.DataFrame({'x1': x1, 'x2': x2, 'y': y}).groupby('x2'):
            i = x2values.index(x2i) % len(linestyle)
            group.plot.line(x='x1', y='y', ax=ax,
                            marker=marker[i], color=color[i], linestyle=linestyle[i])

    dy = 0.15 * (interactions['mean'].max() - interactions['mean'].min())
    ylim = [interactions['mean'].min() - dy, interactions['mean'].max() + dy]

    g = sns.FacetGrid(interactions, col='f1', row='f2', sharex=False, despine=True, ylim=ylim, height=1.5)
    g.map(effectPlot, 'l1', 'l2', 'mean').set_titles('')
    g.fig.subplots_adjust(wspace=.05, hspace=.05)
    for idx, column in enumerate(factors):
        g.axes[-1][idx].set_xlabel(column)
        g.axes[idx][0].set_ylabel('')
        ax = g.axes[idx][idx]
        ax.text(0.9, 0.5, column, transform=ax.transAxes, verticalalignment='center', horizontalalignment='right')
    return ax


def getModelMatrix(design, mod=0, maxscale=1):
    ''' Convert design to model matrix. Will rescale design to code values '''
    design = design - design.mean()
    design = maxscale * design / design.max()

    kvar = design.shape[1]
    names = [f'x{i + 1}' for i in range(kvar)]
    design.columns = names

    formula = list(names)
    if mod >= 1:
        formula.extend(f'{f1}:{f2}' for f1, f2 in combinations(names, 2))
    if mod == 2:
        formula.extend(f'np.power({f1}, 2)' for f1 in names)

    dm = patsy.dmatrix(f'~ {"+".join(formula)}', data=design, return_type='dataframe')  # @UndefinedVariable

    def cleanColumnName(c):
        if not c.startswith('np.power'):
            return c
        c = c.split('(')[1].split(',')[0]
        return f'{c}**2'
    dm.columns = [cleanColumnName(c) for c in dm.columns]
    return dm


def FDS_Plot(design, mod=0, ax=None, plotkw=None, label='y', maxscale=1):
    ''' Fraction of design space plot '''
    dm = getModelMatrix(design, mod=mod, maxscale=maxscale)
#     design = design - design.mean()
#     design = maxscale * design / design.max()
#     kvar = design.shape[1]
#     if not (1 < kvar < 8):
#         raise ValueError('The design matrix must have between 2 and 7 variables')
#     names = [f'x{i + 1}' for i in range(kvar)]
#     design.columns = names
#
#     formula = list(names)
#     if mod >= 1:
#         formula.extend(f'{f1}:{f2}' for f1, f2 in combinations(names, 2))
#     if mod == 2:
#         formula.extend(f'np.power({f1}, 2)' for f1 in names)
#
#     dm = patsy.dmatrix(f'~ {"+".join(formula)}', data=design, return_type='dataframe')  # @UndefinedVariable

    terms = dm.columns
    kvar = design.shape[1]
    names = [f'x{i + 1}' for i in range(kvar)]

    XtX = np.matmul(np.transpose(dm).values, dm.values)
    XtXI = pd.DataFrame(np.linalg.inv(XtX),
                        index=terms, columns=terms)

    fX = {'Int': [1] * 5000}
    fX.update({f: stats.uniform.rvs(loc=-1, scale=2, size=5000) for f in names})
    if mod >= 1:
        for f1, f2 in combinations(names, 2):
            fX[f'{f1}:{f2}'] = fX[f1] * fX[f2]
    if mod == 2:
        for f in names:
            fX[f'np.power({f}, 2)'] = fX[f] * fX[f]
    fX = pd.DataFrame(fX)
    p1 = np.matmul(fX, XtXI)
    v = np.diag(np.matmul(p1.values, np.transpose(fX.values)))
    vi = np.sort(v)

    # calculate fraction of design space
    fs = np.arange(1, len(vi) + 1) / len(vi)
    plotkw = plotkw or {}
    plotkw['color'] = plotkw.get('color', 'black')
    # plotkw['legend'] = False
    ax = pd.DataFrame({'x': fs, label: vi}).plot(x='x', y=label, ax=ax, **plotkw)
    ax.axvline(0.5, linestyle=':', color='grey')
    ax.axhline((vi[2499] + vi[2500]) / 2, linestyle=':', color='grey')
    ax.set_xlabel('Fraction of Space')
    ax.set_ylabel('Relative Prediction Variance')
    return ax
