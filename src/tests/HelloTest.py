'''
Created on 07/10/2013

@author: felipelindemberg
'''

import unittest
import os
import sys
lib_path = os.path.abspath('../')
sys.path.append(lib_path)

class HelloTest(unittest.TestCase):
    def setUp(self):
        self.a = 5
        self.b = 10

    def tearDown(self):
        self.a = None
        self.b = None

    def testInitRoom(self):
        self.assertEqual(self.a, 5, "O nome deve ser Sala")
        self.assertEqual(self.b, 10, "O numero inicial de equipamentos deve ser 10")