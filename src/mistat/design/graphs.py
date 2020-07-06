'''
Created on Jul 4, 2020

@author: petergedeck
'''
from itertools import product

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


def mainEffectsPlot(df, response, factors=None, col_wrap=None, aspect=0.4, continuous=False):
    factors = factors or [c for c in df.columns if c != response]
    col_wrap = col_wrap or len(factors)
    mainEffects = []
    for column in factors:
        for level, g in sorted(df[response].groupby(df[column])):
            mainEffects.append({'factor': column, 'level': level, 'mean': g.mean()})
    mainEffects = pd.DataFrame(mainEffects)

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

    g = sns.FacetGrid(mainEffects, col='factor', col_wrap=col_wrap,
                      sharex=False, aspect=aspect, despine=True, ylim=ylim)
    g.map(effectPlot, 'level', 'mean', meanEffect=meanEffect).set_titles('')
    g.fig.subplots_adjust(wspace=.02)
    for idx, column in enumerate(factors):
        g.axes[idx].set_xlabel(column)


def interactionPlot(df, response, factors=None):
    factors = factors or [c for c in df.columns if c != response]
    interactions = []
    for f1, f2 in product(factors, factors):
        for (l1, l2), g in df[response].groupby([df[f1], df[f2]]):
            interactions.append({'f1': f1, 'l1': l1, 'f2': f2, 'l2': l2, 'mean': g.mean()})
    interactions = pd.DataFrame(interactions)

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
