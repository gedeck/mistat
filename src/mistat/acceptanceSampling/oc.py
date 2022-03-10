'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
from mistat.acceptanceSampling.distributions import OCtype, getDistribution

OC_TYPES = ['binomial', 'hypergeom', 'poisson']


# TODO valdate default handling
class OperatingCharacteristics2c:
    def __init__(self, sample_sizes, acceptance_numbers, rejection_numbers=None,
                 oc_type='binomial', **kwargs):
        if oc_type.lower() not in OC_TYPES:
            raise ValueError(f'Unknown type {oc_type}')
        self.oc_type = oc_type.lower()
        if isinstance(sample_sizes, int):
            sample_sizes = [sample_sizes]
        if isinstance(acceptance_numbers, int):
            acceptance_numbers = [acceptance_numbers]

        self.samples = sample_sizes
        self.acceptance = acceptance_numbers
        self.rejection = rejection_numbers

        nacceptance = len(self.acceptance)
        if self.rejection is None and nacceptance <= 2:
            self.rejection = [1 + self.acceptance[-1]] * nacceptance
        elif isinstance(self.rejection, int):
            self.rejection = [self.rejection]

        self.nstages = len(self.samples)
        if any([len(self.rejection) != self.nstages, len(self.acceptance) != self.nstages]):
            raise ValueError('Inconsistent length of arguments sample_sizes, acceptance_numbers and rejection_numbers')

        if self.acceptance[-1] + 1 != self.rejection[-1]:
            raise ValueError('Decision from last sample cannot be made: r != c+1')

        if self.oc_type == 'binomial':
            self.distribution = getDistribution(self.samples, self.acceptance,
                                                OCtype.binomial, r=self.rejection, **kwargs)
        elif self.oc_type == 'hypergeom':
            self.distribution = getDistribution(self.samples, self.acceptance,
                                                OCtype.hypergeom, r=self.rejection, **kwargs)

    @property
    def pd(self):
        return self.distribution.pd

    @property
    def paccept(self):
        return self.distribution.paccept
