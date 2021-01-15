'''
Created on Jan 10, 2021

@author: petergedeck
'''
import pandas as pd
import numpy as np


def plotECDF(data):
    n = len(data)
    ecdf = pd.DataFrame({
        'x': np.sort(data),
        'Fn(x)': range(1, n + 1),
    })
    ecdf['Fn(x)'] = ecdf['Fn(x)'] / n
    ax = ecdf.plot(x='x', y='Fn(x)', color='black', drawstyle='steps-post', legend=False)
    ax.axhline(y=0, color='grey', linestyle='--')
    ax.axhline(y=1, color='grey', linestyle='--')
    ax.set_ylabel('Fn(x)')
    return ax
