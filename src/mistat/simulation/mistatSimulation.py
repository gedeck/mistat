'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from dataclasses import dataclass

import pandas as pd


@dataclass
class MistatSimulation:
    def simulate(self):
        raise NotImplementedError('Simulation must implement method simulate')


class SimulationResult(pd.DataFrame):
    pass


def simulationGroup(simulation_result, group_size, quiet=False):
    if not isinstance(simulation_result, SimulationResult):
        raise ValueError('Simulator must be of type MistatSimulation')

    ngroups = len(simulation_result) // group_size
    group_labels = list(repeat_elements(list(range(1, ngroups + 1)), group_size))

    if len(group_labels) < len(simulation_result):
        ndiscard = len(simulation_result) - len(group_labels)
        if not quiet:
            print(f'discarded first {ndiscard} observations because the number of '
                  'observations is not a multiple of group_size')
        simulation_result = simulation_result.iloc[ndiscard:, :].copy()
    simulation_result['group'] = group_labels
    return simulation_result


def convert_to_list(value):
    if isinstance(value, (list, tuple)):
        return value
    return [value]


def repeat_elements(values, nrepeat):
    for value in convert_to_list(values):
        yield from [value] * nrepeat
