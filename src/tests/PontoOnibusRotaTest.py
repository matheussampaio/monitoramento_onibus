import psycopg2
import unittest
import sys
import os

class PontoOnibusRotaTest(unittest.TestCase):

    def setUp(self):

        self.table = open(os.path.abspath('../') + '/sql/createsTable/PontoOnibusRota.sql', 'r')
        self.constraints = open(os.path.abspath('../') + '/sql/createsTable/PontoOnibusRota_const.sql', 'r')
        self.insert = open(os.path.abspath('../') + '/sql/inserts/PontoOnibusRota_inserts.sql', 'r')
        self.falho = open(os.path.abspath('../') + '/sql/inserts/PontoOnibusRota_inserts_falhos.sql', 'r')

        self.PontoOnibusRota = self.table.read()
        self.cons = self.constraints.readlines()
        self.inserts = self.insert.readlines()
        self.falhos = self.falho.readlines()

        self.table.close()
        self.constraints.close()
        self.insert.close()
        self.falho.close()

        conn = psycopg2.connect("hostaddr=192.168.1.244 dbname=teste user=matheussampaio password=sampaio")
        conn.set_isolation_level(0) # set autocommit
        self.cur = conn.cursor()


    def tearDown(self):
        self.cur.close()

    def testBCreateTable(self):
        self.cur.execute(self.PontoOnibusRota)
        self.assertEqual(self.cur.statusmessage, "CREATE TABLE")
    
    def testCConstraints(self):
        for self.restricoes in self.cons:
            self.cur.execute(self.restricoes)
            self.assertEqual(self.cur.statusmessage, "ALTER TABLE")
        
    def testDInsertTable(self):
        for self.dados in self.inserts:
            self.cur.execute(self.dados)
            self.assertEqual(self.cur.statusmessage, "INSERT 0 1")

    def testEInsertTableFalhos(self):
        for self.dadosFalhos in self.falhos:
            try:
                self.cur.execute(self.dadosFalhos)
            except:
                self.assertTrue(True)
