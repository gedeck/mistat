import unittest

from mistat.design.doeUtilities import (_reduceTreatment, aliasesInSubgroup,
                                        subgroupOfDefining)


class TestDoeUtilities(unittest.TestCase):
    def test_subgroupOfDefining(self):
        expected = ['']
        assert subgroupOfDefining(['']) == sorted(expected)
        expected = ['', 'ABCH', 'ABEFG', 'CEFGH']
        assert subgroupOfDefining(['ABCH', 'ABEFG']) == sorted(expected)
        expected = [*expected, 'BDEFH', 'ACDEF', 'ADGH', 'BCDG']
        assert subgroupOfDefining(['ABCH', 'ABEFG', 'BDEFH']) == sorted(expected)

        expected = ['(1)', 'ABCH', 'ABEFG', 'CEFGH']
        assert subgroupOfDefining(['ABCH', 'ABEFG'], noTreatment='(1)') == sorted(expected)

    def test_reduceTreatment(self):
        assert _reduceTreatment('') == ''
        assert _reduceTreatment('A') == 'A'
        assert _reduceTreatment('AB') == 'AB'
        assert _reduceTreatment('ABA') == 'B'
        assert _reduceTreatment('BAAA') == 'AB'
        assert _reduceTreatment('BAAACA') == 'BC'

    def test_aliasesInSubgroup(self):
        expected = sorted({'BCH', 'BEFG', 'ACEFGH', 'ABDEFH', 'CDEF', 'DGH', 'ABCDG',
                           'ABCEFH', 'EF', 'CGH', 'ABG', 'ACD', 'BDH', 'BCDEFG', 'ADEFGH'})
        assert aliasesInSubgroup('A', ['ABCH', 'ABEFG', 'BDEFH', 'BCEFH']) == expected

        assert aliasesInSubgroup('A', ['AB']) == ['B']
