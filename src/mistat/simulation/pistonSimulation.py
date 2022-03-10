'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass
from typing import Optional

import numpy as np
import pandas as pd
from scipy import stats
from scipy.stats import norm

from mistat.simulation.mistatSimulation import SimulationResult

from .mistatSimulation import (MistatSimulation, convert_to_list,
                               repeat_elements)

default_errors = {
    'm': 0.1,
    's': 0.01,
    'v0': 0.00025,
    'k': 50,
    'p0': 0.01,
    't': 0.13,
    't0': 0.13
}


@dataclass
class PistonSimulator(MistatSimulation):  # pylint: disable=too-many-instance-attributes
    m: float = 60
    s: float = 0.02
    v0: float = 0.01
    k: float = 5_000
    p0: float = 110_000
    t: float = 296
    t0: float = 360

    n_simulation: int = 50  # desired number of simulations
    seed: Optional[float] = None
    check: bool = True

    def __post_init__(self):
        if self.seed is not None:
            np.random.seed(seed=self.seed)

        if self.check:
            validate_range(self.m, 30, 60, 'Piston weight m is out of range, [30, 60] kg')
            validate_range(self.s, 0.005, 0.02, "Piston surface area s is out of range, [0.005, 0.020] m^2")
            validate_range(self.v0, 0.002, 0.01, "Value of initial gas volume v0 is out of range, [0.002, 0.010] m^3")
            validate_range(self.k, 1000, 5000, "Value of spring coefficient k is out of range, [1000, 5000] N/m")
            validate_range(self.p0, 90_000, 110_000,
                           "Value of atmospheric pressure p0 is out of range, [90000, 110000] N/m^2")
            validate_range(self.t, 290, 296, "Value of ambient temperature t is out of range, [290, 296] K")
            validate_range(self.t0, 340, 360, "Value of filling gas temperature t0 is out of range, [340, 360] K")

        if self.n_simulation < 1:
            raise ValueError('Number of simulations must be greater 1')

        # Convert to lists
        maxsize = 0
        for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0'):
            values = convert_to_list(getattr(self, option))
            maxsize = max(maxsize, len(values))
            setattr(self, option, values)
        if maxsize == 1:
            maxsize = self.n_simulation

        # Make sure that the vectors are all the same length
        for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0'):
            values = getattr(self, option)
            if maxsize % len(values) != 0:
                raise ValueError(f'Inconsistent length of option {option}')
            values = np.array(list(repeat_elements(values, maxsize // len(values))))
            setattr(self, option, values)

        self.errors = dict(default_errors)

    def simulate(self):
        size = len(self.m)

        # add errors
        errors = self.errors
        m_s = self.m + norm.rvs(size=size, loc=0, scale=errors['m'])
        s_s = self.s + norm.rvs(size=size, loc=0, scale=errors['s'])
        s_s[s_s < 0.00001] = 0.00001
        v0_s = self.v0 + norm.rvs(size=size, loc=0, scale=errors['v0'])
        v0_s[v0_s < 0] = 0.001
        k_s = self.k + norm.rvs(size=size, loc=0, scale=errors['k'])
        p0_s = self.p0 + norm.rvs(size=size, loc=0, scale=errors['p0'])
        p0_s[p0_s < 0] = 0.001
        t_s = self.t + norm.rvs(size=size, loc=0, scale=errors['t'])
        t0_s = self.t0 + norm.rvs(size=size, loc=0, scale=errors['t0'])

        Mg = 0.2 * k_s
        A = p0_s * s_s + 2 * Mg - k_s * v0_s / s_s
        V = s_s * (np.sqrt(A**2 + 4 * k_s * p0_s * v0_s * t_s / t0_s) - A) / (2 * k_s)
        res = 2 * np.pi * np.sqrt(m_s / (k_s + ((s_s**2) * p0_s * v0_s * t_s) / (t0_s * V * V)))

        result = {option: getattr(self, option) for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0')}
        result['seconds'] = res
        return SimulationResult(result)

    @staticmethod
    def cycleTime(m, s, v0, k, p0, t, t0):  # pylint: disable=too-many-arguments
        Mg = 0.2 * k
        A = p0 * s + 2 * Mg - k * v0 / s
        V = s * (np.sqrt(A**2 + 4 * k * p0 * v0 * t / t0) - A) / (2 * k)
        return 2 * np.pi * np.sqrt(m / (k + ((s**2) * p0 * v0 * t) / (t0 * V * V)))


def validate_range(value, left, right, message):
    if isinstance(value, (tuple, list, pd.core.series.Series, np.ndarray)):
        left = left - 1e-6
        right = right + 1e-6
        if not all(left <= v <= right for v in value):
            raise ValueError(message)
    else:
        if not left <= value <= right:
            raise ValueError(message)


def uniformSumDistribution(size=1, k=6, left=0, right=1):
    """ return size random numbers from the uniform sum distribution [left, right] based on k sums """
    if right <= left or size < 1 or k < 1:
        raise ValueError('Invalid arguments')
    factor = (right - left) / k
    return np.array([np.sum(stats.uniform.rvs(size=k)) * factor + left for _ in range(size)])
