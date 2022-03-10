'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib import colors  # type: ignore
from matplotlib.patches import Rectangle


class ParetoChart:
    def __init__(self, data, title=None, labels=None):
        self.title = title
        if labels is None:
            self.labels = data.index
        else:
            self.labels = labels
        self.data = pd.DataFrame({
            'Labels': self.labels,
            'Frequency': np.array(data).flatten()
        })
        self.data = self.data.sort_values(by='Frequency', ascending=False)
        self.data['Cum.Freq.'] = np.cumsum(self.data['Frequency'])
        total = np.sum(self.data['Frequency'])
        self.data['Percentage'] = 100 * self.data['Frequency'] / total
        self.data['Cum.Percent.'] = 100 * self.data['Cum.Freq.'] / total

    def print(self):
        if self.title is None:
            print('Pareto chart analysis')
        else:
            print(f'Pareto chart analysis: {self.title}')
        print(self.data)

    def plot(self, ax=None, rotation=None, ha='center'):
        if ax is None:
            _, ax = plt.subplots(figsize=(8, 6))

        nlevels = len(self.data)
        cumfreq = self.data['Cum.Freq.']
        cumperc = [0, 25, 50, 75, 100]
        q = [perc / 100 * max(cumfreq) for perc in cumperc]

        ax.plot(range(0, nlevels), self.data['Cum.Freq.'],
                marker='o', markerfacecolor='black', color='grey')
        ax.bar(range(0, nlevels), self.data['Frequency'])
        greys = plt.get_cmap('gray')(np.linspace(0, 1, nlevels + 3))[2:-1]
        bars = [child for child in ax.get_children() if isinstance(child, Rectangle)]
        for barObj, color in zip(bars, greys):
            barObj.set_color(colors.to_hex(color))
            barObj.set_edgecolor('black')

        ax.set_xticks(range(0, nlevels))
        ax.set_xticklabels(self.data['Labels'], rotation=rotation, ha=ha)
        xlim = ax.get_xlim()
        ax.hlines(q, *ax.get_xlim(), linestyle='dotted', color='grey')
        ax.set_xlim(*xlim)

        ax.set_ylim(0, max(cumfreq) * 1.05)
        secax = ax.secondary_yaxis('right')
        secax.yaxis.tick_right()
        secax.set_ylabel('Frequency')
        ax.set_ylabel('Cumulative Percentage')
        ax.set_yticks(q)
        ax.set_yticklabels(f'{p} %' for p in cumperc)

        ax.get_figure().suptitle(self.title or 'Pareto chart analysis', fontsize=14)
        return ax
