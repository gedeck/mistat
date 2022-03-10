'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass, fields
from typing import Optional

import numpy as np
import pandas as pd
from scipy import stats

from mistat.simulation.mistatSimulation import SimulationResult

from .mistatSimulation import (MistatSimulation, convert_to_list,
                               repeat_elements)

errors = {
    'm': 0.1,
    's': 0.01,
    'v0': 0.00025,
    'k': 50,
    'p0': 0.01,
    't': 0.13,
    't0': 0.13
}


@dataclass
class PowerCircuitSimulation(MistatSimulation):  # pylint: disable=too-many-instance-attributes
    rsA: float = 8_200
    rsB: float = 220_000
    rsC: float = 1_000
    rsD: float = 33_000
    rsE: float = 56_000
    rsF: float = 5_600
    rsG: float = 3_300
    rsH: float = 58.5
    rsI: float = 1_000
    rsJ: float = 120
    trK: float = 130
    trL: float = 100
    trM: float = 130
    tlA: float = 5
    tlB: float = 10
    tlC: float = 10
    tlD: float = 5
    tlE: float = 5
    tlF: float = 5
    tlG: float = 10
    tlH: float = 5
    tlI: float = 5
    tlJ: float = 5
    tlK: float = 5
    tlL: float = 10
    tlM: float = 5

    n_simulation: int = 50  # desired number of simulations
    seed: Optional[float] = None
    check: bool = True

    def __post_init__(self):
        if self.seed is not None:
            np.random.seed(seed=self.seed)

        self.resistors = [field.name for field in fields(self)
                          if field.name.startswith('rs')]
        self.transistors = [field.name for field in fields(self)
                            if field.name.startswith('tr')]
        self.tolerances = [field.name for field in fields(self)
                           if field.name.startswith('tl')]
        self.options = [*self.resistors, *self.transistors, *self.tolerances]

        for option in self.options:
            validate_range(getattr(self, option), 0, f'{option} must be greater than 0')

        if self.n_simulation < 1:
            raise ValueError('Number of simulations must be greater 1')

        # Convert to lists
        maxsize = 0
        for option in self.options:
            values = convert_to_list(getattr(self, option))
            maxsize = max(maxsize, len(values))
            setattr(self, option, values)
        if maxsize == 1:
            maxsize = self.n_simulation

        # Make sure that the vectors are all the same length
        for option in self.options:
            values = getattr(self, option)
            if maxsize % len(values) != 0:
                raise ValueError(f'Inconsistent length of option {option}')
            values = np.array(list(repeat_elements(values, maxsize // len(values))))
            setattr(self, option, values)

        self.df = pd.DataFrame({option: getattr(self, option) for option in self.options})

    def simulate(self):
        size = len(self.rsA)

        # add errors
        data = {}
        for option in self.options:
            if option.startswith('tl'):
                element = f'rs{option[2]}' if hasattr(self, f'rs{option[2]}') else f'tr{option[2]}'
                rv = stats.norm.rvs(size=size)
                rv = rv * 2 * getattr(self, option) * getattr(self, element) / 600
                data[element] = data[element] + rv
            else:
                data[option] = getattr(self, option)

        # calculate resulting voltage
        data['volts'] = self.vCircuit(**data)

        # copy specified values into results
        for option in self.resistors:
            data[option] = getattr(self, option)
        for option in self.transistors:
            data[option] = getattr(self, option)
        return SimulationResult(data)

    @staticmethod
    def vCircuit(rsA, rsB, rsC, rsD, rsE, rsF, rsG, rsH, rsI, rsJ, trK, trL, trM):  # pylint: disable=too-many-arguments
        a = rsB / (rsA + rsB)
        b = (rsA * rsB / (rsA + rsB) + rsC) / (trL * trM) + rsI
        c = rsE + 0.5 * rsG
        d = rsA * rsB * trK / (rsA + rsB)
        e = rsF + 0.5 * rsG
        f = (c + e) * (1 + trK) * rsH + c * e
        g = rsH + 0.6
        h = 1.2

        aden = 1 + d * e / f + b * (1 / rsJ + 0.006 * (1 + 13.67 / rsJ)) + a * 0.1367 * 0.6
        anum = (a + b / rsJ) * (138 - 1.33) + d * (c + e) * g / f - h

        return anum / aden


def validate_range(value, left, message):
    left = left - 1e-6
    if isinstance(value, (tuple, list, pd.core.series.Series, np.ndarray)):
        if not all(left <= v for v in value):
            raise ValueError(message)
    else:
        if not left <= value:
            raise ValueError(message)
