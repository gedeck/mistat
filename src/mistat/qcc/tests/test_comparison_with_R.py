# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest
from pathlib import Path

import numpy as np
import pandas as pd

from mistat.qcc.qualityControlChart import QualityControlChart, qcc_groups
from mistat.qcc.statistics import QCCStatistics, SD_estimator
from mistat.qcc.tests.utilities import assertQCC, assertQCCviolations


class TestComparisonWithR(unittest.TestCase):
    def test_pistonrings(self):
        pistonrings = pd.read_csv(Path(__file__).parent / 'data' / 'pistonrings.csv')
        diameter = qcc_groups(pistonrings['diameter'], pistonrings['sample'])
        data = diameter[:25, ]
        # newdata = diameter[25:, ]

        qcc = QualityControlChart(data, qcc_type='xbar')
        assertQCC(qcc, 74.00118, 0.009785039, [73.98805, 74.0143])
        assertQCCviolations(qcc)
        # qcc(diameter[1:25,], type="xbar", newdata=newdata)
        # assertNewQCC(qcc, 74.00118, 0.009785039, [73.98805, 74.0143])
        qcc = QualityControlChart(data, qcc_type='xbar', nsigmas=2)
        assertQCC(qcc, 74.00118, 0.009785039, [73.99242, 74.00993])
        assertQCCviolations(qcc, beyondLimits={'UCL': [0], 'LCL': [13]})
        # qcc(diameter[1:25,], type="xbar", newdata=newdata)
        # assertNewQCC(qcc, 74.00118, 0.009785039, [73.98805, 74.0143])

        qcc = QualityControlChart(data, qcc_type='R')
        assertQCC(qcc, 0.02276, 0.009785039, [0, 0.04812533])

        qcc = QualityControlChart(data, qcc_type='S')
        assertQCC(qcc, 0.009240037, 0.009829977, [0, 0.019302416])

    def test_pistonrings_variable_control_limits(self):
        """
        # variable control limits
        out <- c(9, 10, 30, 35, 45, 64, 65, 74, 75, 85, 99, 100)
        diameter <- qcc.groups(pistonrings$diameter[-out], sample[-out])
        r <- qcc(diameter[1:25,], type="xbar")
        r$center
        r$std.dev
        r$limits
        r <- qcc(diameter[1:25,], type="R")
        qcc(diameter[1:25,], type="S")
        qcc(diameter[1:25,], type="xbar", newdata=diameter[26:40,])
        qcc(diameter[1:25,], type="R", newdata=diameter[26:40,])
        qcc(diameter[1:25,], type="S", newdata=diameter[26:40,])
        """
        out = [idx - 1 for idx in [9, 10, 30, 35, 45, 64, 65, 74, 75, 85, 99, 100]]
        pistonrings = pd.read_csv(Path(__file__).parent / 'data' / 'pistonrings.csv')
        pistonrings = pistonrings.drop(pistonrings.index[out])
        diameter = qcc_groups(pistonrings['diameter'], pistonrings['sample'])
        data = diameter[:25, ]
        # newdata = diameter[25:, ]

        qcc = QualityControlChart(data, qcc_type='xbar')
        assertQCC(qcc, 74.00075, 0.009856701, [[73.98753, 74.01398], [73.98368, 74.01782], [73.98753, 74.01398]])
        assertQCCviolations(qcc)
        qcc = QualityControlChart(data, qcc_type='xbar', nsigmas=2)
        assertQCC(qcc, 74.00075, 0.009856701, [[73.99194, 74.00957], [73.98937, 74.01213], [73.99194, 74.00957]])
        assertQCCviolations(qcc, beyondLimits={'UCL': [0], 'LCL': [13]})

        qcc = QualityControlChart(data, qcc_type='R')
        assertQCC(qcc, 0.02230088, 0.009856701, [[0, 0.04785198], [0, 0.04857007], [0, 0.04785198]])

        qcc = QualityControlChart(data, qcc_type='S')
        assertQCC(qcc, 0.00938731, 0.009930923, [[0, 0.01955302], [0, 0.02318885], [0, 0.01955302]])

    def test_orangejuice(self):
        """
        data(orangejuice)
        attach(orangejuice)
        r <- qcc(D[trial], sizes=size[trial], type="p")

        # remove out-of-control points (see help(orangejuice) for the reasons)
        inc <- setdiff(which(trial), c(15,23))
        q1 <- qcc(D[inc], sizes=size[inc], type="p")

        r <- qcc(D[inc], sizes=size[inc], type="p", newdata=D[!trial], newsizes=size[!trial])
        r$center
        r$std.dev
        r$limits
        detach(orangejuice)
        """
        oj = pd.read_csv(Path(__file__).parent / 'data' / 'orangejuice.csv')
        data = oj[oj['trial']]
        # newdata = oj[~oj['trial']]

        qcc = QualityControlChart(data['D'], sizes=data['size'], qcc_type='p')
        assertQCC(qcc, 0.2313333, 0.421685, [0.05242755, 0.4102391])
        assertQCCviolations(qcc, beyondLimits={'UCL': [14, 22], 'LCL': []})

        dataRed = data.drop(data.index[qcc.violations['beyondLimits']['UCL']])
        qcc = QualityControlChart(dataRed['D'], sizes=dataRed['size'], qcc_type='p')
        assertQCC(qcc, 0.215, 0.4108223, [0.04070284, 0.3892972])
        assertQCCviolations(qcc, beyondLimits={'UCL': [19], 'LCL': []})

        # qcc = QualityControlChart(dataRed['D'], newdata=newdata, sizes=dataRed['size'], qcc_type='p')
        # assertQCC(qcc, 0.215, 0.4108223, [0.04070284, 0.3892972])

    def test_orangejuice2(self):
        """
        data(orangejuice2)
        attach(orangejuice2)
        names(D) <- sample
        r = qcc(D[trial], sizes=size[trial], type="p")
        q2 <- qcc(D[trial], sizes=size[trial], type="p", newdata=D[!trial], newsizes=size[!trial])
        detach(orangejuice2)
        """
        oj = pd.read_csv(Path(__file__).parent / 'data' / 'orangejuice2.csv')
        data = oj[oj['trial']]
        # newdata = oj[~oj['trial']]

        qcc = QualityControlChart(data['D'], sizes=data['size'], qcc_type='p')
        assertQCC(qcc, 0.1108333, 0.3139256, [0, 0.2440207])
        assertQCCviolations(qcc)

        # qcc = QualityControlChart(dataRed['D'], newdata=newdata, sizes=dataRed['size'], qcc_type='p')
        # assertQCC(qcc, 0.215, 0.4108223, [0.04070284, 0.3892972])

    def test_xbar_one(self):
        # viscosity data (Montgomery, pag. 242)
        x = [33.75, 33.05, 34, 33.81, 33.46, 34.02, 33.68, 33.27, 33.49, 33.20, 33.62, 33.00, 33.54, 33.12, 33.84]
        qcc = QualityControlChart(x, qcc_type="xbarone")
        assertQCC(qcc, 33.52333, 0.4261651, [32.24484, 34.80183])

        qcc = QualityControlChart(x, qcc_type="xbarone", std_dev=SD_estimator.sd)
        assertQCC(qcc, 33.52333, 0.3415928, [32.49855, 34.54811])

        #  Water content of antifreeze data (Wetherill and Brown, 1991, p. 120)
        x = [2.23, 2.53, 2.62, 2.63, 2.58, 2.44, 2.49, 2.34, 2.95, 2.54, 2.60, 2.45, 2.17, 2.58, 2.57, 2.44, 2.38,
             2.23, 2.23, 2.54, 2.66, 2.84, 2.81, 2.39, 2.56, 2.70, 3.00, 2.81, 2.77, 2.89, 2.54, 2.98, 2.35, 2.53]
        qcc = QualityControlChart(x, qcc_type="xbarone")
        assertQCC(qcc, 2.569706, 0.1794541, [2.031344, 3.108068])
        assertQCCviolations(qcc)

        qcc = QualityControlChart(x, qcc_type="xbarone", std_dev='SD')
        assertQCC(qcc, 2.569706, 0.2216795, [1.904667, 3.234744])
        assertQCCviolations(qcc)

        expected = [0.1794541, 0.1897519, 0.1955224, 0.2019203, 0.2022154, 0.2041948, 0.2072357, 0.2121212, 0.2126056, 0.2143082, 0.2172579,
                    0.2189612, 0.2183180, 0.2178859, 0.2181558, 0.2172365, 0.2168714, 0.2151667, 0.2138331, 0.2128866, 0.2122988, 0.2108173,
                    0.2095927]
        XbarOne = QCCStatistics().get('xbarone')
        np.testing.assert_allclose([XbarOne.sd(x, k=k) for k in range(2, 25)], expected, rtol=1e-5)
