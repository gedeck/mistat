'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numpy as np
import pandas as pd


def plotECDF(data, ax=None):
    n = len(data)
    ecdf = pd.DataFrame({
        'x': np.sort(data),
        'Fn(x)': range(1, n + 1),
    })
    ecdf['Fn(x)'] = ecdf['Fn(x)'] / n
    ax = ecdf.plot(x='x', y='Fn(x)', color='black', drawstyle='steps-post', legend=False, ax=ax)
    ax.axhline(y=0, color='grey', linestyle='--')
    ax.axhline(y=1, color='grey', linestyle='--')
    ax.set_ylabel('Fn(x)')
    return ax
