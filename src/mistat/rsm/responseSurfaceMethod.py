'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numpy as np
import pandas as pd
from scipy.linalg import eig
from scipy.optimize import NonlinearConstraint, minimize


class ResponseSurfaceMethod:
    ''' Class provides information about the response surface defined by a
    second order regression model

     See section on "Canonical representation" in book for mathematical details'''

    def __init__(self, model, codes):
        ''' determine vector b and array B from model '''
        b = np.array([model.params.get(c, 0) for c in codes])
        B = np.zeros([len(codes), len(codes)])
        for i, code_i in enumerate(codes):
            B[i, i] = model.params.get(f'np.power({code_i}, 2)',
                                       model.params.get(f'I({code_i} ** 2)', 0))
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

    def constrainedOptimization(self, start, distances=None, maximize=True, reverse=False):
        if distances is None:
            distances = np.arange(0.5, 5.1, 0.5)
        x0 = start
        if x0 is None:
            x0 = self.stationary_point()
        else:
            x0 = pd.Series(x0, index=self.codes)

        factor = -1 if maximize else 1

        def fun(x):
            df = pd.DataFrame({code: [value] for code, value in zip(self.codes, x)})
            return factor * self.model.predict(df)
        result = {'step': 0, 'distance': 0}
        result.update({c: x0[c] for c in self.codes})
        result['y'] = factor * fun(x0)[0]
        results = [result]
        x = x0
        lastDistance = 0
        for step, distance in enumerate(distances, 1):
            result = {'step': 1, 'distance': distance}
            gradient = self.gradient(x)
            if reverse:
                gradient = -gradient
                reverse = False
            x = x + (distance-lastDistance) * gradient

            def distanceConstraint(x):
                return np.sqrt(np.sum((x-x0)**2)) - distance  # pylint: disable=cell-var-from-loop

            constraints = NonlinearConstraint(distanceConstraint, -0.0001, 0.0001)
            minResult = minimize(fun, x, constraints=constraints)
            x = pd.Series(minResult.x, index=self.codes)
            result = {'step': step, 'distance': distance}
            result.update({c: x[c] for c in self.codes})
            result['y'] = factor * minResult.fun
            results.append(result)
        return pd.DataFrame(results)
