# pylint: disable=line-too-long
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import unittest

import numpy as np
import pytest

from mistat.acceptanceSampling.dodge.dodge_chain import (ChainPlanBinomial,
                                                         ChainPlanPoisson)
from mistat.acceptanceSampling.dodge.dodge_curtailed import curtailedBinomial
from mistat.acceptanceSampling.dodge.dodge_double import (DSPlanBinomial,
                                                          DSPlanHypergeom,
                                                          DSPlanNormal,
                                                          DSPlanPoisson)
from mistat.acceptanceSampling.dodge.dodge_other import (
    VSPDesign, lotSensitiveComplianceSampPlan, variableSampPlanKnown,
    variableSampPlanUnknown)
from mistat.acceptanceSampling.dodge.dodge_sequential import sequentialDesign
from mistat.acceptanceSampling.dodge.dodge_single import (SSPDesignBinomial,
                                                          SSPDesignPoisson,
                                                          SSPlanBinomial,
                                                          SSPlanHyper,
                                                          SSPlanPoisson)


class TestDodge(unittest.TestCase):
    def test_sequentialDesign(self):
        # R:
        # PlanDesign=SeqDesignBinomial(AQL=0.01, alpha=0.05, LQL=0.04, beta=0.05, Plots=T)
        # SequentialBinomial(PlanDesign)
        plan = sequentialDesign(AQL=0.01, alpha=0.05, LQL=0.05, beta=0.05)
        assert plan.AQL == 0.01
        assert plan.alpha == 0.05
        assert plan.LQL == 0.05
        assert plan.beta == 0.05
        assert plan.h1 == pytest.approx(1.783772)
        assert plan.h2 == pytest.approx(1.783772)

        assert len(plan.h) == 1606
        assert plan.h[0] == pytest.approx(-4 * plan.h1)
        assert plan.h[1] == pytest.approx(-4 * plan.h1 + 0.01)
        assert plan.s == pytest.approx(0.02498542)
        assert len(plan.p) == 1606
        np.testing.assert_array_almost_equal(plan.p[:10], [0.254928304751284, 0.25462098111807, 0.254313531157994, 0.25400595482573,
                                                           0.253698252076035, 0.253390422863751, 0.253082467143804, 0.252774384871209, 0.252466176001068, 0.252157840488576])

        assert len(plan.k) == 143
        np.testing.assert_array_almost_equal(plan.accept, [-1.7587869779636, -1.73380155573001, -1.70881613349642, -1.68383071126283, -1.65884528902924, -1.63385986679565, -1.60887444456206, -1.58388902232847, -1.55890360009488, -1.53391817786129, -1.5089327556277, -1.48394733339411, -1.45896191116052, -1.43397648892693, -1.40899106669334, -1.38400564445975, -1.35902022222616, -1.33403479999257, -1.30904937775898, -1.28406395552539, -1.2590785332918, -1.23409311105821, -1.20910768882462, -1.18412226659103, -1.15913684435744, -1.13415142212385, -1.10916599989026, -1.08418057765667, -1.05919515542308, -1.03420973318949, -1.0092243109559, -0.984238888722309, -0.959253466488719, -0.934268044255129, -0.909282622021539, -0.884297199787949, -0.85931177755436, -0.83432635532077, -0.80934093308718, -0.78435551085359, -0.75937008862, -0.73438466638641, -0.70939924415282, -0.68441382191923, -0.65942839968564, -0.63444297745205, -0.60945755521846, -0.58447213298487, -0.55948671075128, -0.53450128851769, -0.5095158662841, -0.48453044405051, -0.45954502181692, -0.43455959958333, -0.409574177349741, -0.384588755116151, -0.359603332882561, -0.334617910648971, -0.309632488415381, -0.284647066181791, -0.259661643948201, -0.234676221714611, -0.209690799481021, -0.184705377247431, -0.159719955013841, -0.134734532780251, -0.109749110546661, -0.0847636883130711, -0.0597782660794812, -
                                                           0.0347928438458913, -0.00980742161230141, 0.0151780006212887, 0.0401634228548786, 0.0651488450884685, 0.0901342673220584, 0.115119689555648, 0.140105111789238, 0.165090534022828, 0.190075956256418, 0.215061378490008, 0.240046800723598, 0.265032222957188, 0.290017645190778, 0.315003067424368, 0.339988489657958, 0.364973911891548, 0.389959334125138, 0.414944756358728, 0.439930178592318, 0.464915600825907, 0.489901023059498, 0.514886445293088, 0.539871867526678, 0.564857289760268, 0.589842711993857, 0.614828134227447, 0.639813556461037, 0.664798978694627, 0.689784400928217, 0.714769823161807, 0.739755245395397, 0.764740667628987, 0.789726089862577, 0.814711512096167, 0.839696934329757, 0.864682356563347, 0.889667778796937, 0.914653201030527, 0.939638623264117, 0.964624045497706, 0.989609467731296, 1.01459488996489, 1.03958031219848, 1.06456573443207, 1.08955115666566, 1.11453657889925, 1.13952200113284, 1.16450742336643, 1.18949284560002, 1.21447826783361, 1.2394636900672, 1.26444911230079, 1.28943453453438, 1.31441995676797, 1.33940537900156, 1.36439080123515, 1.38937622346874, 1.41436164570233, 1.43934706793592, 1.46433249016951, 1.4893179124031, 1.51430333463669, 1.53928875687028, 1.56427417910387, 1.58925960133746, 1.61424502357105, 1.63923044580464, 1.66421586803823, 1.68920129027181, 1.7141867125054, 1.73917213473899, 1.76415755697258, 1.78914297920617])
        np.testing.assert_array_almost_equal(plan.reject, [1.80875782243078, 1.83374324466437, 1.85872866689796, 1.88371408913155, 1.90869951136514, 1.93368493359873, 1.95867035583232, 1.98365577806591, 2.0086412002995, 2.03362662253309, 2.05861204476668, 2.08359746700027, 2.10858288923386, 2.13356831146745, 2.15855373370104, 2.18353915593463, 2.20852457816822, 2.23351000040181, 2.2584954226354, 2.28348084486899, 2.30846626710258, 2.33345168933617, 2.35843711156976, 2.38342253380335, 2.40840795603694, 2.43339337827053, 2.45837880050412, 2.48336422273771, 2.5083496449713, 2.53333506720489, 2.55832048943848, 2.58330591167207, 2.60829133390566, 2.63327675613925, 2.65826217837284, 2.68324760060643, 2.70823302284002, 2.73321844507361, 2.7582038673072, 2.78318928954079, 2.80817471177438, 2.83316013400797, 2.85814555624156, 2.88313097847514, 2.90811640070874, 2.93310182294233, 2.95808724517592, 2.9830726674095, 3.00805808964309, 3.03304351187668, 3.05802893411027, 3.08301435634387, 3.10799977857745, 3.13298520081104, 3.15797062304463, 3.18295604527822, 3.20794146751181, 3.2329268897454, 3.25791231197899, 3.28289773421258, 3.30788315644617, 3.33286857867976, 3.35785400091335, 3.38283942314694, 3.40782484538053, 3.43281026761412, 3.45779568984771, 3.4827811120813, 3.50776653431489, 3.53275195654848,
                                                           3.55773737878207, 3.58272280101566, 3.60770822324925, 3.63269364548284, 3.65767906771643, 3.68266448995002, 3.70764991218361, 3.7326353344172, 3.75762075665079, 3.78260617888438, 3.80759160111797, 3.83257702335156, 3.85756244558515, 3.88254786781874, 3.90753329005233, 3.93251871228592, 3.95750413451951, 3.9824895567531, 4.00747497898669, 4.03246040122028, 4.05744582345387, 4.08243124568746, 4.10741666792105, 4.13240209015464, 4.15738751238823, 4.18237293462182, 4.20735835685541, 4.232343779089, 4.25732920132259, 4.28231462355618, 4.30730004578977, 4.33228546802336, 4.35727089025695, 4.38225631249054, 4.40724173472413, 4.43222715695772, 4.45721257919131, 4.4821980014249, 4.50718342365849, 4.53216884589208, 4.55715426812567, 4.58213969035926, 4.60712511259285, 4.63211053482644, 4.65709595706003, 4.68208137929362, 4.70706680152721, 4.7320522237608, 4.75703764599439, 4.78202306822798, 4.80700849046157, 4.83199391269516, 4.85697933492875, 4.88196475716234, 4.90695017939593, 4.93193560162952, 4.95692102386311, 4.9819064460967, 5.00689186833029, 5.03187729056388, 5.05686271279747, 5.08184813503106, 5.10683355726465, 5.13181897949824, 5.15680440173183, 5.18178982396542, 5.20677524619901, 5.2317606684326, 5.25674609066619, 5.28173151289978, 5.30671693513337, 5.33170235736696, 5.35668777960055])

        assert plan.ATI is None
        np.testing.assert_array_almost_equal(plan.OC[499:510], [0.00180374394096743, 0.00185754358830032, 0.00191294482394685, 0.00196999514022756, 0.00202874342649785,
                                                                0.00208924000956058, 0.00215153669520629, 0.00221568681090986, 0.00228174524971307, 0.00234976851532328, 0.00241981476845877], decimal=6)
        np.testing.assert_array_almost_equal(plan.AOQ[499:510], [0.000157281040140754, 0.000161330045337968, 0.000165480804130392, 0.000169735790633064,
                                                                 0.000174097536212862, 0.000178568630703615, 0.000183151723642379, 0.000187849525527033, 0.000192664809095319, 0.000197600410625442, 0.00020265923125834], decimal=6)
        np.testing.assert_array_almost_equal(plan.ASN[499:510], [28.5692446309825, 28.7257864926785, 28.8838954420278, 29.043591934926,
                                                                 29.2048967273661, 29.367830879621, 29.5324157604537, 29.6986730513548, 29.8666247508035, 30.0362931785526, 30.2077009799322], decimal=6)

    def test_singleDesign(self):
        design = SSPDesignBinomial(0.01, 0.05, 0.04, 0.05)
        assert design.n == 261
        assert design.Ac == 5

        design = SSPDesignPoisson(0.01, 0.05, 0.04, 0.05)
        assert design.n == 297
        assert design.Ac == 6

    def test_SSPlanBinomial(self):
        dsPlan = SSPlanBinomial(1000, 20, 1, p=(0, 0.05, 0.1, 0.15, 0.2, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.p,
                                             (0.00, 0.05, 0.10, 0.15, 0.20, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.OC,
                                             (1, 0.73584, 0.39175, 0.17556, 0.06918, 0.02431), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.AOQ,
                                             (0, 0.03606, 0.03839, 0.02581, 0.01356, 0.00596), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ATI,
                                             (20, 278.8773, 616.0879, 827.9533, 932.2082, 976.1736), decimal=4)

    def test_SSPlanHyper(self):
        dsPlan = SSPlanHyper(5000, 200, 3, p=(0, 0.01, 0.02, 0.03, 0.04, 0.05))
        np.testing.assert_array_almost_equal(dsPlan.p,
                                             (0, 0.01, 0.02, 0.03, 0.04, 0.05))
        np.testing.assert_array_almost_equal(dsPlan.OC,
                                             (1, 0.86182, 0.42754, 0.14179, 0.03679, 0.00810), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.AOQ,
                                             (0, 0.00827, 0.00821, 0.00408, 0.00141, 0.00039), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ATI,
                                             (200, 863.2879, 2947.8071, 4319.4236, 4823.4055, 4961.1010), decimal=4)

    def test_SSPlanPoisson(self):
        dsPlan = SSPlanPoisson(1000, 20, 1, p=(0, 0.05, 0.1, 0.15, 0.2, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.p,
                                             (0, 0.05, 0.1, 0.15, 0.2, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.OC,
                                             (1, 0.73576, 0.40601, 0.19915, 0.09158, 0.04043), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.AOQ,
                                             (0, 0.03605, 0.03979, 0.02927, 0.01795, 0.00990), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ATI,
                                             (20, 278.9563, 602.1143, 804.8347, 910.2534, 960.3809), decimal=4)

    def test_DSPlanBinomial(self):
        dsPlan = DSPlanBinomial(150, 20, 40, 2, 6, 6, p=(0, 0.05, 0.1, 0.15, 0.2, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.p,
                                             (0.00, 0.05, 0.10, 0.15, 0.20, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.OC,
                                             (1, 0.98578, 0.77994, 0.44660, 0.21392, 0.09211), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ASN,
                                             (20, 23.00618, 32.47280, 41.11183, 43.92492, 41.03649), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.AOQ,
                                             (0, 0.04190, 0.06485, 0.05639, 0.03666, 0.019901), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ATI,
                                             (20, 24.29895, 52.72791, 93.61006, 122.50399, 138.05959), decimal=5)

        dsPlan = DSPlanBinomial(1000, 200, 400, 3, 9, 9, p=(0.01, 0.03))
        np.testing.assert_array_almost_equal(dsPlan.OC, (0.9573, 0.1512), decimal=4)
        dsPlan = DSPlanBinomial(1000, 120, 240, 0, 7, 7, p=(0.01, 0.03))
        np.testing.assert_array_almost_equal(dsPlan.OC, (0.9709, 0.1637), decimal=4)

    def test_DSPlanNormal(self):
        dsPlan = DSPlanNormal(1000, 100, 200, 3, 6, 6, p=(0.01, 0.03, 0.09))
        np.testing.assert_array_almost_equal(dsPlan.OC, (0.9985, 0.6397, 0.0214), decimal=4)
        np.testing.assert_array_almost_equal(dsPlan.ASN, (100.8083, 163.4957, 115.4561), decimal=4)

    def test_DSPlanHypergeom(self):
        dsPlan = DSPlanHypergeom(1000, 100, 200, 3, 6, 6, p=(0.01, 0.02, 0.03, 0.04, 0.05))
        np.testing.assert_array_almost_equal(dsPlan.OC, (0.998, 0.8972, 0.658, 0.421, 0.243), decimal=3)
        np.testing.assert_array_almost_equal(dsPlan.ASN, (102.4, 124.1, 156.4, 175.6, 174.7), decimal=1)

        dsPlan = DSPlanHypergeom(150, 20, 40, 2, 6, 6, p=(0, 0.025, 0.05, 0.075))
        np.testing.assert_array_almost_equal(dsPlan.OC, (1, 1, 0.997, 0.958), decimal=3)

    def test_DSPlanPoisson(self):
        dsPlan = DSPlanPoisson(150, 20, 40, 2, 6, 6, p=(0, 0.05, 0.1, 0.15, 0.2, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.p,
                                             (0.00, 0.05, 0.10, 0.15, 0.20, 0.25))
        np.testing.assert_array_almost_equal(dsPlan.OC,
                                             (1, 0.98386, 0.77968, 0.46923, 0.24954, 0.12668), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ASN,
                                             (20, 23.18829, 32.27040, 39.71568, 41.88108, 39.65235), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.AOQ,
                                             (0, 0.04178, 0.06483, 0.05916, 0.04264, 0.02731), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ATI,
                                             (20, 24.66388, 52.76153, 90.84187, 118.01710, 133.61303), decimal=5)

    def test_curtailedBinomial(self):
        dsPlan = curtailedBinomial(100, 10, p=np.arange(0, 1.1, 0.2))
        np.testing.assert_array_almost_equal(dsPlan.ASNsemi, (100, 54.95368, 27.5, 18.33333, 13.75, 11), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ASNfull, (90, 54.94922, 27.5, 18.33333, 13.75, 11), decimal=5)

        dsPlan = curtailedBinomial(20, 1, p=np.arange(0, 1.1, 0.2))
        np.testing.assert_array_almost_equal(dsPlan.ASNsemi, (20, 9.596477, 4.998598, 3.333333, 2.5, 2), decimal=5)
        np.testing.assert_array_almost_equal(dsPlan.ASNfull, (19, 9.58207, 4.99854, 3.33333,  2.5, 2), decimal=5)

    def test_chainPlanBinomial(self):
        plan = ChainPlanBinomial(1000, 20, 3, p=np.arange(0, 0.3, 0.05))
        np.testing.assert_array_almost_equal(plan.OC, (1, 0.37587, 0.12206, 0.03877, 0.01153, 0.00317), decimal=5)
        np.testing.assert_array_almost_equal(plan.AOQ, (0, 0.01842, 0.01196, 0.00570, 0.00226, 0.00078), decimal=5)
        np.testing.assert_array_almost_equal(plan.ATI, (20, 631.6, 880.4, 962.0, 988.7, 996.9), decimal=1)

    def test_chainPlanPoisson(self):
        plan = ChainPlanPoisson(1000, 20, 3, p=np.arange(0, 0.3, 0.05))
        np.testing.assert_array_almost_equal(plan.OC, (1, 0.3862, 0.13601, 0.04981, 0.01832, 0.00674), decimal=5)
        np.testing.assert_array_almost_equal(plan.AOQ, (0, 0.01892, 0.01333, 0.00732, 0.00359, 0.00165), decimal=5)
        np.testing.assert_array_almost_equal(plan.ATI, (20, 621.5, 866.7, 951.2, 982, 993.4), decimal=1)

    def test_lotSensitiveComplianceSampPlan(self):
        plan = lotSensitiveComplianceSampPlan(1000, 0.04, 0.05, p=np.arange(0, 0.11, 0.025))
        np.testing.assert_array_almost_equal(plan.OC, (1, 0.15376, 0.02364, 0.00363, 0.00056), decimal=5)
        np.testing.assert_array_almost_equal(plan.AOQ, (0, 0.00357, 0.00110, 0.00025, 0.00005), decimal=5)
        np.testing.assert_array_almost_equal(plan.ATI, (72, 857.3, 978.1, 996.6, 999.5), decimal=1)

    def test_variableSampPlanKnown(self):
        plan = variableSampPlanKnown(1000, 20, 1, pa=(0, 0.1, 0.2, 0.3, 0.4))
        np.testing.assert_array_almost_equal(plan.OC, (0, 0.1, 0.2, 0.3, 0.4), decimal=5)
        np.testing.assert_array_almost_equal(plan.AOQ, (0, 0.02330, 0.04086, 0.05547, 0.06772), decimal=5)
        np.testing.assert_array_almost_equal(plan.ATI, (1000, 902, 804, 706, 608), decimal=1)

    def test_variableSampPlanUnknown(self):
        plan = variableSampPlanUnknown(1000, 20, 1, pa=(0, 0.1, 0.2, 0.3, 0.4))
        np.testing.assert_array_almost_equal(plan.OC, (0, 0.1, 0.2, 0.3, 0.4), decimal=5)
        np.testing.assert_array_almost_equal(plan.AOQ, (0, 0.02530, 0.04328, 0.05759, 0.06900), decimal=5)
        np.testing.assert_array_almost_equal(plan.ATI, (1000, 902, 804, 706, 608), decimal=1)

    def test_VSPDesign(self):
        result = VSPDesign(AQL=0.01, alpha=0.05, LQL=0.04, beta=0.05)
        assert result['k'] == pytest.approx(2.038517)
        assert result['n'] == 33
        assert result['n_unknown'] == pytest.approx(101.566599)
