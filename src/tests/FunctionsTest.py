# coding: utf-8

import psycopg2
import unittest
import sys
import os

class FunctionsTest(unittest.TestCase):

    def setUp(self):

         self.funcao1 = open(os.path.abspath('../') + '/sql/Funcoes/checkPontoOnibusInRota.sql')
         self.funcao2 = open(os.path.abspath('../') + '/sql/Funcoes/getIDNextPontoOnibus.sql')
         self.funcao3 = open(os.path.abspath('../') + '/sql/Funcoes/getSubLineString.sql')
         self.funcao4 = open(os.path.abspath('../') + '/sql/Funcoes/getVelocidadeMedia.sql')
         self.funcao5 = open(os.path.abspath('../') + '/sql/Funcoes/refreshCurrentPontoOnibus.sql')
         self.funcao6 = open(os.path.abspath('../') + '/sql/Funcoes/refreshCurrentSeq.sql')
         self.funcao7 = open(os.path.abspath('../') + '/sql/Funcoes/refreshFugaRota.sql')
         self.funcao8 = open(os.path.abspath('../') + '/sql/Funcoes/refreshStatusOnibus.sql')

         self.checaOnibus = self.funcao1.read()
         self.IDNext = self.funcao2.read()
         self.getSubline = self.funcao3.read()
         self.getVelocidade = self.funcao4.read()
         self.refreshPontoOnibus = self.funcao5.read()
         self.refreshSequencia = self.funcao6.read()
         self.refreshFugaRota = self.funcao7.read()
         self.refreshStatusOnibus = self.funcao8.read()

         self.funcao1.close()
         self.funcao2.close()
         self.funcao3.close()
         self.funcao4.close()
         self.funcao5.close()
         self.funcao6.close()
         self.funcao7.close()
         self.funcao8.close()
        
         conn = psycopg2.connect("hostaddr=192.168.1.244 dbname=teste user=matheussampaio password=sampaio")
         conn.set_isolation_level(0) # set autocommit
         self.cur = conn.cursor()

    def tearDown(self):
        self.cur.close()

    def testCreateFunction(self):
         self.cur.execute(self.checaOnibus)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")

         self.cur.execute(self.IDNext)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")

         self.cur.execute(self.getSubline)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")

         self.cur.execute(self.getVelocidade)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")

         self.cur.execute(self.refreshPontoOnibus)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")

         self.cur.execute(self.refreshSequencia)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")

         self.cur.execute(self.refreshFugaRota)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")

         self.cur.execute(self.refreshStatusOnibus)
         self.assertEqual(self.cur.statusmessage, "CREATE FUNCTION")
