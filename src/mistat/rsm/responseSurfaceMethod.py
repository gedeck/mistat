'''
Created on May 3, 2021

@author: petergedeck
'''
import numpy as np
import pandas as pd
from scipy.linalg import eig


class ResponseSurfaceMethod:
    ''' Class provides information about the response surface defined by a 
    second order regression model

     See section on "Canonical representation" in book for mathematical details'''

    def __init__(self, model, codes):
        ''' determine vector b and array B from model '''
        b = np.array([model.params.get(c, 0) for c in codes])
        B = np.zeros([len(codes), len(codes)])
        for i, code_i in enumerate(codes):
            B[i, i] = model.params.get(f'np.power({code_i}, 2)', 0)
            for j, code_j in enumerate(codes[i + 1:], i + 1):
                B[i, j] = model.params.get(f'{code_i}:{code_j}', 0) / 2
                B[j, i] = B[i, j]
        self.model = model
        self.codes = codes
        self.b = b
        self.B = B

    def f(self, x):
        ''' calculate function value at position x '''
        exog = pd.Series(x, index=self.codes)
        return self.model.predict(exog=exog)[0]

    def gradient(self, x):
        ''' calculate gradient at position x '''
        gradient = pd.Series(self.b + np.matmul(self.B, x), index=self.codes)
        return gradient / np.linalg.norm(gradient)

    def stationary_point(self):
        return pd.Series(- 0.5 * np.matmul(np.linalg.inv(self.B), self.b), index=self.codes)

    def _eigen(self):
        ev, evec = eig(self.B)
        return {'eval': ev, 'evec': evec}

    def eigen(self):
        ev, evec = eig(self.B)
        indx = ev.real.argsort()[::-1]
        return {'eval': ev.real[indx], 'evec': evec[:, indx]}
