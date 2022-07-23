'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass
from typing import Optional, NamedTuple, Tuple

import numpy as np
import pandas as pd
from scipy import stats
from scipy.stats import norm

from mistat.simulation.mistatSimulation import SimulationResult

from mistat.simulation.mistatSimulation import (MistatSimulation, convert_to_list,
                                                repeat_elements)


class Configuration(NamedTuple):
    default: float
    limits: list[float]
    error: float
    label: str
    unit: str


configurations = {
    'm': Configuration(45, (30, 60), 0.1, 'Piston weight m', 'kg'),
    's': Configuration(0.0125, (0.005, 0.02), 0.001, 'Piston surface area s', 'm^2'),
    'k': Configuration(3_000, (1_000, 5_000), 50, 'Value of initial gas volume v0', 'm^3'),
    't': Configuration(293, (290, 296), 0.3, 'Value of spring coefficient k', 'N/m'),
    'p0': Configuration(100_000, (90_000, 110_000), 0.01, 'Value of atmospheric pressure p0', 'N/m^2'),
    'v0': Configuration(0.006, (0.002, 0.01), 0.0005, 'Value of filling gas temperature t0', 'K'),
    't0': Configuration(350, (340, 360), 0.3, 'Value of ambient temperature t', 'K'),
}


@dataclass
class PistonSimulator(MistatSimulation):  # pylint: disable=too-many-instance-attributes
    m: float = configurations['m'].default
    s: float = configurations['s'].default
    k: float = configurations['k'].default
    t: float = configurations['t'].default
    p0: float = configurations['p0'].default
    v0: float = configurations['v0'].default
    t0: float = configurations['t0'].default

    n_simulation: int = 50  # desired number of simulations
    seed: Optional[float] = None
    check: bool = True
    actuals: Optional[SimulationResult] = None

    def __post_init__(self):
        # Check arguments
        if self.seed is not None:
            np.random.seed(seed=self.seed)
        if self.check:
            self.validate_configuration()
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

        self.errors = {p: configuration.error for p, configuration in configurations.items()}

    def validate_configuration(self):
        for parameter, configuration in configurations.items():
            values = getattr(self, parameter)
            limits = configuration.limits
            valid = True
            if isinstance(values, (tuple, list, pd.core.series.Series, np.ndarray)):
                left = limits[0] - 1e-6
                right = limits[1] + 1e-6
                if not all(left <= v <= right for v in values):
                    valid = False
            else:
                if not limits[0] <= values <= limits[1]:
                    valid = False
            if not valid:
                limits = f'{configuration.limits[0]}, {configuration.limits[1]}'
                message = f'{configuration.label} is out of range, [{limits}] {configuration.unit}'
                raise ValueError(message)

    def with_added_errors(self, parameter):
        configuration = configurations[parameter]
        values = getattr(self, parameter)
        size = len(values)
        # add random error to values
        error = configuration.error
        values = values + norm.rvs(size=size, loc=0, scale=error)
        # restrict values to fall within limits +/- 3 error
        lower = configuration.limits[0] - 3 * error
        upper = configuration.limits[1] + 3 * error
        values[values < lower] = lower
        values[values > upper] = upper
        return values

    def simulate(self):
        size = len(self.m)

        # add errors
        errors = self.errors
        m = self.with_added_errors('m')
        s = self.with_added_errors('s')
        v0 = self.with_added_errors('v0')
        k = self.with_added_errors('k')
        p0 = self.with_added_errors('p0')
        t = self.with_added_errors('t')
        t0 = self.with_added_errors('t0')

        A = p0 * s + 2 * m * 9.81 - k * v0 / s
        V = s / (2 * k) * (np.sqrt(A**2 + 4 * k*t*p0 * v0 / t0) - A)
        self.A = A
        self.V = V
        res = 2 * np.pi * np.sqrt(m / (k + s**2 * p0 * (t / (t0 * V**2))))

        result = {option: getattr(self, option) for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0')}
        result['seconds'] = res
        self.actuals = SimulationResult({
            'm': m,
            's': s,
            'v0': v0,
            'k': k,
            'p0': p0,
            't': t,
            't0': t0,
            'seconds': res,
        })
        return SimulationResult(result)

    @staticmethod
    def cycleTime(m, s, v0, k, p0, t, t0):  # pylint: disable=too-many-arguments
        A = p0 * s + 2 * m * 9.81 - k * v0 / s
        V = s / (2 * k) * (np.sqrt(A**2 + 4 * k*t*p0 * v0 / t0) - A)
        return 2 * np.pi * np.sqrt(m / (k + s**2 * p0 * (t / (t0 * V**2))))


def uniformSumDistribution(size=1, k=6, left=0, right=1):
    """ return size random numbers from the uniform sum distribution [left, right] based on k sums """
    if right <= left or size < 1 or k < 1:
        raise ValueError('Invalid arguments')
    factor = (right - left) / k
    return np.array([np.sum(stats.uniform.rvs(size=k)) * factor + left for _ in range(size)])
