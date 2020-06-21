'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
'''
import unittest

from scipy.special import gammaln
import pytest

from mistat.data import load_data
from mistat.qcc.qccStatistics import QCC_statistic, SD_estimator, qcc_c4,\
    QCCtype
import numpy as np


class Test_qccStatistics(unittest.TestCase):
    array_1 = np.array([[1, 2, 3], [1, 2, np.NaN]])
    array_2 = np.array([[1, 2, 3], [1, 2, 7]])

    def test_Xbar_statistic(self):
        xbar = QCC_statistic.get_for_type('xbar')
        assert xbar.getSizes(self.array_1) == [3, 2]
        stats = xbar.stats(self.array_1)
        np.testing.assert_array_equal(stats.statistics, [2, 1.5])
        assert stats.center == 1.8

        assert xbar.sd(self.array_1, 12345) == 12345
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
        s = QCC_statistic.get_for_type('S')
        assert s.getSizes(self.array_1) == [3, 2]
        stats = s.stats(self.array_1)
        assert stats.center == pytest.approx(0.8828427)
        np.testing.assert_allclose(stats.statistics, [1.0000000, 0.7071068], rtol=1e-5)

        assert s.sd(self.array_1, 12345) == 12345
        assert s.sd(self.array_1) == pytest.approx(1.007303)
        assert s.sd(self.array_1, std_dev=SD_estimator.uwave_sd) == pytest.approx(1.007303)
        assert s.sd(self.array_1, std_dev=SD_estimator.mvlue_sd) == pytest.approx(1.049987)
        assert s.sd(self.array_1, std_dev=SD_estimator.rmsdf) == pytest.approx(0.9908318)

        sd = s.sd(self.array_1)
        sizes = s.getSizes(self.array_1)
        conf_limits = s.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 2.28274627669134], [0, 2.70448059144019]]), rtol=1e-4)
        conf_limits = s.limits(stats.center, sd, sizes, 0.9)
        np.testing.assert_allclose(conf_limits, np.array(
            [[0.228134225169997, 1.74345862934255], [0.063164728444235, 1.97427769221479]]), rtol=1e-4)

        stats = s.stats(self.array_2)
        sd = s.sd(self.array_2)
        sizes = s.getSizes(self.array_2)
        conf_limits = s.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 5.41184]]), rtol=1e-4)

        conf_limits = s.limits(stats.center, sd, sizes, 0.9)
        np.testing.assert_allclose(conf_limits, np.array([[0.5385259, 4.115549]]), rtol=1e-4)

    def test_P_statistic(self):
        p = QCC_statistic.get_for_type('p')
        assert p.qcc_type == QCCtype.p

        data = load_data('JANDEFECT')
        sizes = 100
        with pytest.raises(ValueError):
            p.stats(data)
        stats = p.stats(data, sizes)
        assert stats.center == pytest.approx(0.05387097)
        assert stats.statistics[0] == 0.06

        assert p.sd(data, 12345) == 12345
        assert p.sd(data, sizes=100) == pytest.approx(0.2257629)
        assert p.sd(data, sizes=[100] * len(data)) == pytest.approx(0.2257629)

        sd = p.sd(data, sizes=100)
        sizes = [100] * len(data)
        conf_limits = p.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 0.1215998]]), rtol=1e-4)

        conf_limits = p.limits(stats.center, sd, sizes, 0.9)
        np.testing.assert_allclose(conf_limits, np.array([[0.02, 0.09]]), rtol=1e-4)

    def test_R_statistic(self):
        R = QCC_statistic.get_for_type('R')
        assert R.qcc_type == QCCtype.R

        data = load_data('CONTACTLEN').values
        assert R.getSizes(data) == [5] * 20

        stats = R.stats(data)
        assert stats.center == pytest.approx(0.23665)
        assert stats.statistics[0] == 0.119

        assert R.sd(data, 12345) == 12345
        assert R.sd(data) == pytest.approx(0.1017412)

        sd = R.sd(data)
        sizes = R.getSizes(data)
        conf_limits = R.limits(stats.center, sd, sizes, 3.0)
        np.testing.assert_allclose(conf_limits, np.array([[0, 0.5003893]]), rtol=1e-4)

        # conf_limits = R.limits(stats.center, sd, sizes, 0.9)
        # np.testing.assert_allclose(conf_limits, np.array([[0.1047873, 0.3924825]]), rtol=1e-4)

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
