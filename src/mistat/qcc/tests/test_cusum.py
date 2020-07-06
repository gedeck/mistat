'''
Created on Jun 22, 2020

@author: petergedeck
'''
from pathlib import Path
import unittest

from scipy import stats

from mistat.data import load_data
from mistat.qcc.cusum import cusumArl
from mistat.qcc.qualityControlChart import QualityControlChart, qcc_groups
from mistat.qcc.rules import run_length_encoding
import numpy as np
import pandas as pd


class TestCusum(unittest.TestCase):
    def test_cusumArl(self):
        print(cusumArl(randFunc=stats.norm(loc=1), N=100, limit=1000, seed=1))

# cusumArl(mean=1, seed=123, N=100, limit=1000)
#
# cusumArl(size=100, prob=0.05, kp=5.95, km=3.92, hp=12.87, hm=-8.66,
#   randFunc=rbinom, seed=123, N=100, limit=2000)
#
# cusumArl(lambda=10, kp=12.33, km=8.41, hp=11.36, hm=-12.91,
#   randFunc=rpois, seed=123, N=100, limit=2000)
