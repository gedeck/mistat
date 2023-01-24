'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass
from typing import NamedTuple, Optional, Tuple, Union

import numpy as np
import pandas as pd
from scipy import stats

from mistat.simulation.mistatSimulation import (MistatSimulation,
                                                SimulationResult,
                                                convert_to_list,
                                                repeat_elements)


class Configuration(NamedTuple):
    default: float
    limits: Union[Tuple[int, int], Tuple[float, float]]
    error: float
    label: str
    unit: str


pistonConfigurations = {
    'm': Configuration(45, (30, 60), 0.1, 'Piston weight m', 'kg'),
    's': Configuration(0.0125, (0.005, 0.02), 0.001, 'Piston surface area s', 'm^2'),
    'k': Configuration(3_000, (1_000, 5_000), 50, 'Value of spring coefficient k', 'N/m'),
    't': Configuration(293, (290, 296), 0.3, 'Value of ambient temperature t', 'K'),
    'p0': Configuration(100_000, (90_000, 110_000), 0.01, 'Value of atmospheric pressure p0', 'N/m^2'),
    'v0': Configuration(0.006, (0.002, 0.01), 0.0005, 'Value of initial gas volume v0', 'm^3'),
    't0': Configuration(350, (340, 360), 0.3, 'Value of filling gas temperature t0', 'K'),
}


@dataclass
class PistonSimulator(MistatSimulation):  # pylint: disable=too-many-instance-attributes
    """ Version 2 of piston simulator code

    Results will differ from JMP and R versions of the simulator
    """
    m: float = pistonConfigurations['m'].default
    s: float = pistonConfigurations['s'].default
    k: float = pistonConfigurations['k'].default
    t: float = pistonConfigurations['t'].default
    p0: float = pistonConfigurations['p0'].default
    v0: float = pistonConfigurations['v0'].default
    t0: float = pistonConfigurations['t0'].default

    parameter: Optional[pd.DataFrame] = None

    n_simulation: int = 50  # desired number of simulations
    n_replicate: int = 1  # number of replicates for each simulated parameter setting
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
            raise ValueError('Number of simulations must be greater 0')

        # If parameter is given, use that to set parameter
        if self.parameter is not None:
            for option in pistonConfigurations:
                if option in self.parameter:
                    setattr(self, option, list(self.parameter[option]))

        # Convert to lists
        maxsize = 0
        for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0'):
            values = convert_to_list(getattr(self, option))
            values = list(np.repeat(values, self.n_replicate))
            maxsize = max(maxsize, len(values))
            setattr(self, option, values)
        if maxsize == self.n_replicate:
            maxsize = self.n_simulation * self.n_replicate

        # Make sure that the vectors are all the same length
        for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0'):
            values = getattr(self, option)
            if maxsize % len(values) != 0:
                raise ValueError(f'Inconsistent length of option {option}')
            values = np.array(list(repeat_elements(values, maxsize // len(values))))
            setattr(self, option, values)

        # Create a simulator specific copy of the errors to allow manipulation before the simulation
        self.errors = {p: configuration.error for p, configuration in pistonConfigurations.items()}

    def validate_configuration(self):
        for parameter, configuration in pistonConfigurations.items():
            values = getattr(self, parameter)
            limits = configuration.limits
            valid = True
            failedValues = []
            if isinstance(values, (tuple, list, pd.core.series.Series, np.ndarray)):
                left = limits[0] - 1e-6
                right = limits[1] + 1e-6
                if not all(left <= v <= right for v in values):
                    failedValues = {v for v in values if v < left or right < v}
                    valid = False
            else:
                if not limits[0] <= values <= limits[1]:
                    valid = False
                    failedValues = {values}
            if not valid:
                failures = f'{", ".join([f"{v}" for v in sorted(failedValues)])}'
                limits = f'{configuration.limits[0]}, {configuration.limits[1]}'
                message = (f'{configuration.label} is out of range, [{limits}] ' +
                           f'{configuration.unit}\n Failures: {failures}')
                raise ValueError(message)

    def with_added_errors(self, parameter):
        values = getattr(self, parameter)
        size = len(values)
        # add random error to values
        return values + stats.norm.rvs(size=size, loc=0, scale=self.errors[parameter])

    def simulate(self):
        # add errors
        m = self.with_added_errors('m')
        s = self.with_added_errors('s')
        v0 = self.with_added_errors('v0')
        k = self.with_added_errors('k')
        p0 = self.with_added_errors('p0')
        t = self.with_added_errors('t')
        t0 = self.with_added_errors('t0')

        A = p0 * s + 2 * m * 9.81 - k * v0 / s
        V = s / (2 * k) * (np.sqrt(A**2 + 4 * k*t*p0 * v0 / t0) - A)
        res = 2 * np.pi * np.sqrt(m / (k + s**2 * p0 * (t / (t0 * V**2))))

        result = {option: getattr(self, option) for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0')}
        result['seconds'] = res
        nrepeats = len(m) // self.n_replicate
        result['group'] = np.repeat(range(1, nrepeats + 1), self.n_replicate)

        # store the actual values
        self.actuals = SimulationResult({
            'm': m,
            's': s,
            'v0': v0,
            'k': k,
            'p0': p0,
            't': t,
            't0': t0,
            'seconds': res,
            'group': np.repeat(range(1, nrepeats + 1), self.n_replicate),
        })
        return SimulationResult(result)

    @ staticmethod
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
