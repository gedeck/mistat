'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import numpy as np
import pytest
from scipy.special import gammaln  # pylint: disable=no-name-in-module

from mistat.data import load_data
from mistat.qcc import statistics
from mistat.qcc.statistics import QCCStatistics, SD_estimator, qcc_c4


class Test_qccStatistics(unittest.TestCase):
    array_1 = np.array([[1, 2, 3], [1, 2, np.NaN]])
    array_2 = np.array([[1, 2, 3], [1, 2, 7]])

    def setUp(self):
        self.qccStatistics = QCCStatistics()
        unittest.TestCase.setUp(self)

    def test_default_statistic(self):
        assert self.qccStatistics.default == 'xbar'

        for statistic in self.qccStatistics:
            assert hasattr(statistic, 'description'), statistic.qcc_type

    def test_SD_estimator(self):
        assert SD_estimator.get(None, SD_estimator.mr) == SD_estimator.mr
        assert SD_estimator.get(SD_estimator.sd, SD_estimator.mr) == SD_estimator.sd
        assert SD_estimator.get('sd', SD_estimator.mr) == SD_estimator.sd
        assert SD_estimator.get('SD', SD_estimator.mr) == SD_estimator.sd
        with pytest.raises(ValueError):
            SD_estimator.get(123, SD_estimator.mr)
        with pytest.raises(ValueError):
            SD_estimator.get('unknown estimator', SD_estimator.mr)

    def test_Xbar_statistic(self):
        xbar = self.qccStatistics.get('xbar')
        assert isinstance(xbar, statistics.Xbar_statistic)
        assert xbar.qcc_type == 'xbar'

        assert xbar.getSizes(self.array_1) == [3, 2]
        stats = xbar.stats(self.array_1)
        np.testing.assert_array_equal(stats.statistics, [2, 1.5])
        assert stats.center == 1.8

        assert xbar.sd(self.array_1, std_dev=12345) == 12345
        assert xbar.sd(self.array_1) == pytest.approx(1.03393)
        assert xbar.sd(self.array_1, std_dev=SD_estimator.uwave_r) == pytest.approx(1.03393)
        assert xbar.sd(self.array_1, std_dev=SD_estimator.uwave_sd) == pytest.approx(1.007303)
        assert xbar.sd(self.array_1, std_dev=SD_estimator.mvlue_r) == pytest.approx(1.085444)
        assert xbar.sd(self.array_1, std_dev=SD_estimator.mvlue_sd) == pytest.approx(1.049987)
        assert xbar.sd(self.array_1, std_dev=SD_estimator.rmsdf) == pytest.approx(0.9908318)

        sd = xbar.sd(self.array_1)
        sizes = xbar.getSizes(self.array_1)
        conf_limits = xbar.limits(stats.center, sd, sizes, 2.0)
        np.testing.assert_allclose(conf_limits, np.array([[0.6061206, 2.993879], [0.3378024, 3.262198]]), rtol=1e-4)

        conf_limits = xbar.limits(stats.center, sd, sizes, 0.95)
        np.testing.assert_allclose(conf_limits, np.array([[0.6300197, 2.969980], [0.3670726, 3.232927]]), rtol=1e-4)

        sizes = [3, 3]
        conf_limits = xbar.limits(stats.center, sd, sizes, 2.0)
        np.testing.assert_allclose(conf_limits, np.array([[0.6061206, 2.993879]]), rtol=1e-4)

        conf_limits = xbar.limits(stats.center, sd, sizes, 0.95)
        np.testing.assert_allclose(conf_limits, np.array([[0.6300197, 2.969980]]), rtol=1e-4)

    def test_S_statistic(self):
        S = self.qccStatistics.get('S')
        assert isinstance(S, statistics.S_statistic)
        assert S.qcc_type == 'S'

        assert S.getSizes(self.array_1) == [3, 2]
        stats = S.stats(self.array_1)
        assert stats.center == pytest.approx(0.8828427)
        np.testing.assert_allclose(stats.statistics, [1.0000000, 0.7071068], rtol=1e-5)

        assert S.sd(self.array_1, std_dev=12345) == 12345
        assert S.sd(self.array_1) == pytest.approx(1.007303)
        assert S.sd(self.array_1, std_dev=SD_estimator.uwave_sd) == pytest.approx(1.007303)
        assert S.sd(self.array_1, std_dev=SD_estimator.mvlue_sd) == pytest.approx(1.049987)
        assert S.sd(self.array_1, std_dev=SD_estimator.rmsdf) == pytest.approx(0.9908318)

        sd = S.sd(self.array_1)
        sizes = S.getSizes(self.array_1)
        conf_limits = S.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 2.28274627669134], [0, 2.70448059144019]]), rtol=1e-4)
        conf_limits = S.limits(stats.center, sd, sizes, 0.9)
        np.testing.assert_allclose(conf_limits, np.array(
            [[0.228134225169997, 1.74345862934255], [0.063164728444235, 1.97427769221479]]), rtol=1e-4)

        stats = S.stats(self.array_2)
        sd = S.sd(self.array_2)
        sizes = S.getSizes(self.array_2)
        conf_limits = S.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 5.41184]]), rtol=1e-4)

        conf_limits = S.limits(stats.center, sd, sizes, 0.9)
        np.testing.assert_allclose(conf_limits, np.array([[0.5385259, 4.115549]]), rtol=1e-4)

    def test_P_statistic(self):
        p = self.qccStatistics.get('p')
        assert isinstance(p, statistics.P_statistic)
        assert p.qcc_type == 'p'

        data = load_data('JANDEFECT')
        sizes = 100
        with pytest.raises(ValueError):
            p.stats(data)
        stats = p.stats(data, sizes)
        assert stats.center == pytest.approx(0.05387097)
        assert stats.statistics[0] == 0.06

        assert p.sd(data, std_dev=12345) == 12345
        assert p.sd(data, sizes=100) == pytest.approx(0.2257629)
        assert p.sd(data, sizes=[100] * len(data)) == pytest.approx(0.2257629)

        sd = p.sd(data, sizes=100)
        sizes = [100] * len(data)
        conf_limits = p.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 0.1215998]]), rtol=1e-4)

        conf_limits = p.limits(stats.center, sd, sizes, 0.9)
        np.testing.assert_allclose(conf_limits, np.array([[0.02, 0.09]]), rtol=1e-4)

        data = np.array([45, 72, 25, 25, 33, 35, 42, 35, 50, 55, 26, 22])
        sizes = np.array([7920, 6660, 6480, 4500, 5840, 7020, 6840, 8460, 7020, 9900, 9180, 7200])
        stats = p.stats(data, sizes)
        assert stats.center == pytest.approx(0.005343599)
        sd = p.sd(data, sizes=sizes)
        assert sd == pytest.approx(0.07290436)
        limits = p.limits(stats.center, sd, sizes, 3.0)
        assert limits.shape == (12, 2)
        assert limits.loc[0, 'LCL'] == pytest.approx(0.002885994)
        assert limits.loc[1, 'UCL'] == pytest.approx(0.008023617)
        assert limits.loc[10, 'LCL'] == pytest.approx(0.003060875)
        assert limits.loc[11, 'UCL'] == pytest.approx(0.007921157)

# x$limits
#          LCL         UCL
#  0.002885994 0.007801205
#  0.002663582 0.008023617
#  0.002626614 0.008060584
#  0.002083217 0.008603981
#  0.002481608 0.008205590
#  0.002733204 0.007953994
#  0.002699080 0.007988118
#  0.002965721 0.007721477
#  0.002733204 0.007953994
#  0.003145450 0.007541748
#  0.003060875 0.007626323
#  0.002766041 0.007921157

    def test_NP_statistic(self):
        NP = self.qccStatistics.get('np')
        assert isinstance(NP, statistics.NP_statistic)
        assert NP.qcc_type == 'np'

        data = load_data('JANDEFECT')
        sizes = 100
        with pytest.raises(ValueError):
            NP.stats(data)
        stats = NP.stats(data, sizes)
        assert stats.center == pytest.approx(5.387097)
        assert stats.statistics[0] == 6

        assert NP.sd(data, std_dev=12345) == 12345
        assert NP.sd(data, sizes=100) == pytest.approx(2.257629)
        assert NP.sd(data, sizes=[100] * len(data)) == pytest.approx(2.257629)
#
        sd = NP.sd(data, sizes=100)
        sizes = [100] * len(data)
        conf_limits = NP.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 12.15998]]), rtol=1e-4)

        conf_limits = NP.limits(stats.center, sd, sizes, 0.9)
        np.testing.assert_allclose(conf_limits, np.array([[2, 9]]), rtol=1e-4)

    def test_R_statistic(self):
        R = self.qccStatistics.get('R')
        assert isinstance(R, statistics.R_statistic)
        assert R.qcc_type == 'R'

        data = load_data('CONTACTLEN').values
        assert R.getSizes(data) == [5] * 20

        stats = R.stats(data)
        assert stats.center == pytest.approx(0.23665)
        assert stats.statistics[0] == 0.119

        assert R.sd(data, std_dev=12345) == 12345
        assert R.sd(data) == pytest.approx(0.1017412)

        sd = R.sd(data)
        sizes = R.getSizes(data)
        conf_limits = R.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 0.5003893]]), rtol=1e-4)

        # conf_limits = R.limits(stats.center, sd, sizes, 0.9)
        # np.testing.assert_allclose(conf_limits, np.array([[0.1047873, 0.3924825]]), rtol=1e-4)

    def test_Xbar_one_statistic(self):
        data = [2.23, 2.53, 2.62, 2.63, 2.58, 2.44, 2.49, 2.34, 2.95, 2.54, 2.60, 2.45, 2.17, 2.58,
                2.57, 2.44, 2.38, 2.23, 2.23, 2.54, 2.66, 2.84, 2.81, 2.39, 2.56, 2.70, 3.00, 2.81,
                2.77, 2.89, 2.54, 2.98, 2.35, 2.53]

        XbarOne = self.qccStatistics.get('xbarone')
        assert isinstance(XbarOne, statistics.Xbar_one_statistic)
        assert XbarOne.qcc_type == 'xbarone'

        stats = XbarOne.stats(data)
        assert stats.center == pytest.approx(2.569706)
        assert stats.statistics[0] == 2.23

        assert XbarOne.sd(data, std_dev=12345) == 12345
        assert XbarOne.sd(data) == pytest.approx(0.1794541)
        assert XbarOne.sd(data, std_dev=SD_estimator.mr) == pytest.approx(0.1794541)
        assert XbarOne.sd(data, std_dev=SD_estimator.sd) == pytest.approx(0.2216795)

        sd = XbarOne.sd(data)
        conf_limits = XbarOne.limits(stats.center, sd, None, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[2.031344, 3.108068]]), rtol=1e-4)

        conf_limits = XbarOne.limits(stats.center, sd, None, 0.9)
        np.testing.assert_allclose(conf_limits, np.array([[2.27453, 2.864882]]), rtol=1e-4)

    def test_qcc_c4(self):
        assert gammaln(2) == 0
        assert gammaln(3) == pytest.approx(0.6931472)
        assert qcc_c4(2) == pytest.approx(0.7978846)
        assert qcc_c4(3) == pytest.approx(0.8862269)
        assert qcc_c4(4) == pytest.approx(0.9213177)

    def test_abc(self):
        import mistat
        Ps = mistat.PistonSimulator(n_simulation=5 * 20, seed=1).simulate()
        Ps = mistat.simulationGroup(Ps, 5)

        cycleTime = mistat.qcc_groups(Ps['seconds'], Ps['group'])
        mistat.QualityControlChart(cycleTime)
