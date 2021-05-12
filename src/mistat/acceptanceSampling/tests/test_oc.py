'''
Created on Jun 26, 2020

@author: petergedeck
'''
import unittest
from mistat.acceptanceSampling.oc import OperatingCharacteristics2c
import numpy as np


class TestOperatingCharacteristics2c(unittest.TestCase):
    def test_oc2c_1(self):
        oc2 = OperatingCharacteristics2c(10, 1)
        assert oc2.samples == [10]
        assert oc2.acceptance == [1]
        assert oc2.rejection == [2]
        assert oc2.oc_type == 'binomial'

        np.testing.assert_array_equal(oc2.pd, np.linspace(0, 1, 101))
        paccept = [1, 0.995733799757169, 0.983822359313577, 0.965493444491298, 0.941846234321293, 0.913861644100683, 0.88241199543207, 0.848270065271234, 0.812117544852878, 0.774552938234917, 0.7360989291, 0.697209243377895, 0.658275034204041, 0.619630814707374, 0.58155996312436, 0.544299823765527, 0.508046426415468, 0.472958845826877, 0.439163222073435, 0.406756461654868, 0.3758096384, 0.346371112389767, 0.318469384321588, 0.292115701958956, 0.267306434555187, 0.244025230407715, 0.222244971988765, 0.201929542409359, 0.183035416306086, 0.165513087593601, 0.1493083459, 0.134363412896834, 0.120617949150147, 0.108009941553291, 0.0964764808560278, 0.0859544382772461, 0.0763810496802037, 0.0676944152991771, 0.0598339225344849, 0.052740598878682, 0.0463574016, 0.0406294503894916, 0.0355042087755028, 0.0309316197227204, 0.0268642004627987, 0.0232571012491211, 0.0200681323892906, 0.0172577635851252, 0.014789099300942, 0.0126278335864193, 0.0107421875, 0.00910283201231941, 0.00768279901617784,
                   0.00645738282980297, 0.00540403435324067, 0.00450224982333984, 0.0037334559106374, 0.00308089271117285, 0.00252949600754372, 0.0020657800060259, 0.0016777216, 0.00135464706392035, 0.00108712194630954, 0.000866844804433164, 0.000686545307078492, 0.000539887124902343, 0.000421375929799261, 0.000326272735345729, 0.000250512729272484, 0.000190629675778438, 0.0001436859, 0.000107207808761672, 7.9126850531492e-05, 5.77257729613516e-05, 4.15899981809562e-05, 2.95639038085938e-05, 2.07117711153561e-05, 1.42831406054016e-05, 9.68229912669184e-06, 6.44161117777189e-06, 4.1984e-06, 2.6750810145879e-06, 1.66225085328384e-06, 1.00443931392959e-06, 5.88238720860161e-07, 3.32535058593751e-07, 1.8057754889216e-07, 9.36377294635901e-08, 4.602524073984e-08, 2.12451086959099e-08, 9.09999999999997e-09, 3.56039429390999e-09, 1.24554051583999e-09, 3.78113297589998e-10, 9.5335004159999e-11, 1.86523437499998e-11, 2.52706816000003e-12, 1.91515590000002e-13, 5.02784000000006e-15, 9.91000000000001e-18, 0]
        np.testing.assert_array_almost_equal(oc2.paccept, paccept)

    def test_oc2c_2(self):
        oc2 = OperatingCharacteristics2c([125, 125], [1, 4], rejection_numbers=[4, 5], pd=np.linspace(0, 0.1, 101))
        assert oc2.samples == [125, 125]
        assert oc2.acceptance == [1, 4]
        assert oc2.rejection == [4, 5]
        assert oc2.oc_type == 'binomial'

        np.testing.assert_array_equal(oc2.pd, np.linspace(0, 0.1, 101))
        paccept = [1, 0.999987205089941, 0.9997683275467, 0.998771562525497, 0.996117559349714, 0.990807189959407, 0.981906411298203, 0.96868154126125, 0.950674605361029, 0.92772571895803, 0.89995598107544, 0.867725141475902, 0.831576388733525, 0.79217772087748, 0.750266423635912, 0.706600631472699, 0.661919941084548, 0.616915592303829, 0.572209760866675, 0.528342927220442, 0.485767999048198, 0.444849786181813, 0.405868483891072, 0.369025958954567, 0.334453811825023, 0.30222237931004, 0.272350027029704, 0.244812248469158, 0.219550232110389, 0.196478678037157, 0.175492741134377, 0.156474051587771, 0.139295817634293, 0.123827053501502, 0.109936000250811, 0.0974928216231304, 0.0863716634627899, 0.0764521659818153, 0.0676205147645397, 0.0597701103968251, 0.0528019290192858, 0.0466246377676002, 0.0411545205707405, 0.0363152615448874, 0.0320376255195646, 0.0282590682260112, 0.0249233024467946, 0.0219798409914519, 0.0193835327055253, 0.0170941037925871, 0.0150757134673065, 0.013296530290622, 0.0117283333915511,
                   0.0103461410815798, 0.00912786804859703, 0.00805401131548227, 0.00710736440777342, 0.00627275864629092, 0.00553683012181259, 0.00488781068388826, 0.0043153411544553, 0.00381030493408034, 0.00336468018399254, 0.00297140882412819, 0.0026242806730819, 0.00231783115989553, 0.00204725115210033, 0.00180830756338232, 0.00159727352324514, 0.00141086700693409, 0.00124619693447999, 0.00110071585161548, 0.000972178401690254, 0.000858604886192983, 0.000758249292027692, 0.000669571236477984, 0.000591211346168039, 0.000521969644744126, 0.000460786575962052, 0.000406726334911046, 0.000358962220772626, 0.000316763760331894, 0.000279485382931515, 0.000246556455157846, 0.000217472507711092, 0.00019178750803658, 0.00016910705074454, 0.00014908235394702, 0.000131404963683673, 0.000115802080852155, 0.000102032435732262, 8.98826444975565e-05, 7.91639902208524e-05, 6.97095779555499e-05, 6.13718196486258e-05, 5.40202100309366e-05, 4.75393593389354e-05, 4.18272528379413e-05, 3.6793710718047e-05, 3.23590250866104e-05, 2.84527535441431e-05]
        np.testing.assert_array_almost_equal(oc2.paccept, paccept)

    def test_oc2c_3(self):
        oc2 = OperatingCharacteristics2c([125, 125, 125], [1, 3, 13],
                                         rejection_numbers=[6, 9, 14], pd=np.linspace(0, 0.1, 101))
        assert oc2.samples == [125, 125, 125]
        assert oc2.acceptance == [1, 3, 13]
        assert oc2.rejection == [6, 9, 14]
        assert oc2.oc_type == 'binomial'

        np.testing.assert_array_equal(oc2.pd, np.linspace(0, 0.1, 101))
        paccept = [1, 0.999999995758616, 0.999999752942572, 0.999997412863586, 0.999986487913202, 0.999951594813797, 0.999863134603021, 0.999671251447154, 0.99929974087415, 0.99864081952584, 0.997551682732359, 0.995853583775099, 0.993333858870825, 0.989750986071709, 0.984842465374645, 0.978335067742739, 0.969956825332127, 0.959450017472175, 0.946584340980344, 0.931169437737423, 0.913065988850037, 0.892194674523273, 0.868542439305006, 0.842165684997094, 0.8131902236808, 0.781808042289958, 0.748271138007795, 0.712882862164306, 0.675987345100549, 0.637957657122181, 0.599183388785925, 0.56005831060647, 0.520968705604904, 0.482282868695791, 0.444342146855781, 0.407453765371176, 0.371885559013624, 0.337862611492298, 0.305565708281091, 0.275131430704955, 0.246653664445447, 0.220186262885147, 0.195746592949104, 0.173319695304871, 0.152862808388821, 0.134310033020455, 0.117576947793161, 0.102565021815486, 0.0891657080652062, 0.0772641355324347, 0.0667423499724823, 0.057482080509016, 0.0493670320380764,
                   0.0422847212834822, 0.0361278876387702, 0.0307955190036211, 0.0261935382185588, 0.0222351980213942, 0.0188412323070118, 0.015939809458151, 0.013466330166308, 0.0113631079480017, 0.00957896587560351, 0.00806877819981687, 0.0067929807854122, 0.00571706978921904, 0.0048111038981829, 0.00404922178589433, 0.00340918327012008, 0.00287193996354829, 0.00242123898553144, 0.00204326150959332, 0.00172629651626301, 0.00146044905524443, 0.00123738154576527, 0.0010500861113599, 0.000892685610691301, 0.000760260848936554, 0.000648701399202286, 0.000554577499855923, 0.000475030595897127, 0.000407680239475862, 0.000350545239468966, 0.000301977139403635, 0.000260604296868138, 0.00022528502844041, 0.000195068466845858, 0.000169161948044463, 0.000146903903151341, 0.000127741372490638, 0.000111211386442705, 9.69255704157813e-05, 8.45574299956991e-05, 7.38318580917132e-05, 6.45164798356679e-05, 5.64145142966899e-05, 4.93588859346146e-05, 4.32073642796496e-05, 3.78385486701142e-05, 3.31485469942325e-05, 2.90482241603877e-05]
        np.testing.assert_array_almost_equal(oc2.paccept, paccept)

    def test_oc2c_4(self):
        oc2 = OperatingCharacteristics2c([125, 125, 125, 125], [1, 3, 11, 20],
                                         rejection_numbers=[6, 9, 13, 21], pd=np.linspace(0, 0.1, 101))
        assert oc2.samples == [125, 125, 125, 125]
        assert oc2.acceptance == [1, 3, 11, 20]
        assert oc2.rejection == [6, 9, 13, 21]
        assert oc2.oc_type == 'binomial'

        np.testing.assert_array_equal(oc2.pd, np.linspace(0, 0.1, 101))
        paccept = [1, 0.999999995758616, 0.999999752942004, 0.99999741278676, 0.999986485664416, 0.999951566378802, 0.999862923193036, 0.999670162037632, 0.999295448621424, 0.998627043982505, 0.997514078258456, 0.995763536200938, 0.993140351630769, 0.989371297319817, 0.984153012260195, 0.977164058175861, 0.968080401407026, 0.956593254879393, 0.942427867184836, 0.925361670846052, 0.905240225514643, 0.881989604092833, 0.855624230368481, 0.826249626651629, 0.794060004150406, 0.759331068092812, 0.722408768273314, 0.683694975904548, 0.643631199532577, 0.602681471990131, 0.561315463957412, 0.519992731439807, 0.479148810507377, 0.439183658019701, 0.400452723312281, 0.363260739621284, 0.327858156765514, 0.294440004664772, 0.263146882716783, 0.234067711564812, 0.207243857652877, 0.182674241998599, 0.160321066940195, 0.140115832290985, 0.121965359801652, 0.105757597203991, 0.0913670263462607, 0.078659550882629, 0.0674967853767533, 0.0577397080530562, 0.0492516730029904, 0.0419008042208124, 0.0355618136380288,
                   0.0301172988994349, 0.0254585847350116, 0.021486175300988, 0.0181098846941012, 0.0152487098636401, 0.0128305051655059, 0.0107915115339319, 0.00907578629078074, 0.00763457245460629, 0.00642563942451905, 0.00541262036649634, 0.00456436570054492, 0.00385432687817022, 0.00325998019169008, 0.00276229666378681, 0.00234526108707366, 0.00199544095648616, 0.00170160428591235, 0.00145438404287431, 0.0012459860894848, 0.00106993700660904, 0.000920867930183623, 0.00079433048128499, 0.000686640971037188, 0.000594749262969387, 0.00051612894260222, 0.000448685748174963, 0.000390681535600159, 0.000340671368794944, 0.000297451632121551, 0.000260017347272209, 0.000227527138090512, 0.000199274521381519, 0.000174664409277826, 0.000153193889951391, 0.00013443650994096, 0.000118029415137724, 0.00010366282081879, 9.10713763951355e-05, 8.00270700551612e-05, 7.033338441628e-05, 6.18204686469239e-05, 5.43411370895063e-05, 4.77675407903505e-05, 4.19883879078493e-05, 3.69066129126599e-05, 3.24374138223352e-05, 2.85065922759807e-05]
        np.testing.assert_array_almost_equal(oc2.paccept, paccept)

    def test_oc2c_5(self):
        oc2 = OperatingCharacteristics2c(50, 1, oc_type='hypergeom', N=100, pd=np.linspace(0, 0.015, 10))
        np.testing.assert_array_almost_equal(oc2.pd, [0, 0.0016666, 0.0033333, 0.005, 0.0066666,
                                                      0.0083333, 0.01, 0.0116666, 0.013333, 0.015])
        np.testing.assert_array_almost_equal(oc2.paccept, [1, 1, 1, 1, 1, 1, 1, 1, 1, 0.75252525252525])

        oc2 = OperatingCharacteristics2c(50, 1, oc_type='hypergeom', N=100, pd=np.linspace(0, 0.15, 100))
        np.testing.assert_array_almost_equal(oc2.paccept, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.752525252525252, 0.752525252525252, 0.752525252525252, 0.752525252525252, 0.752525252525252, 0.752525252525252, 0.752525252525252, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.308653545766948, 0.308653545766948, 0.308653545766948, 0.308653545766948, 0.308653545766948, 0.308653545766948, 0.181089242944913, 0.181089242944913, 0.181089242944913, 0.181089242944913, 0.181089242944913, 0.181089242944913, 0.181089242944913, 0.102200792515497, 0.102200792515497, 0.102200792515497, 0.102200792515497, 0.102200792515497, 0.102200792515497, 0.0558748088590737, 0.0558748088590737, 0.0558748088590737, 0.0558748088590737, 0.0558748088590737, 0.0558748088590737, 0.0558748088590737, 0.029723043891738, 0.029723043891738, 0.029723043891738, 0.029723043891738, 0.029723043891738, 0.029723043891738, 0.029723043891738, 0.0154289114872316,
                                                           0.0154289114872316, 0.0154289114872316, 0.0154289114872316, 0.0154289114872316, 0.0154289114872316, 0.00783024494802277, 0.00783024494802277, 0.00783024494802277, 0.00783024494802277, 0.00783024494802277, 0.00783024494802277, 0.00783024494802277, 0.00389019563139599, 0.00389019563139599, 0.00389019563139599, 0.00389019563139599, 0.00389019563139599, 0.00389019563139599, 0.00189360884285815, 0.00189360884285815, 0.00189360884285815, 0.00189360884285815, 0.00189360884285815, 0.00189360884285815, 0.00189360884285815, 0.000903565807219552, 0.000903565807219552, 0.000903565807219552, 0.000903565807219552, 0.000903565807219552, 0.000903565807219552, 0.000903565807219552, 0.000422769045659429, 0.000422769045659429, 0.000422769045659429, 0.000422769045659429, 0.000422769045659429, 0.000422769045659429, 0.000193982035686275, 0.000193982035686275, 0.000193982035686275, 0.000193982035686275])
