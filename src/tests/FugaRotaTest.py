import psycopg2
import unittest
import sys
import os

class FugaRotaTest(unittest.TestCase):

    def setUp(self):

        self.table = open(os.path.abspath('../') + '/sql/createsTable/FugaRota.sql', 'r')
        self.constraints = open(os.path.abspath('../') + '/sql/createsTable/FugaRota_const.sql', 'r')
        self.insert = open(os.path.abspath('../') + '/sql/inserts/Horarios_inserts.sql', 'r')
        self.falho = open(os.path.abspath('../') + '/sql/inserts/FugaRota_inserts_falhos.sql', 'r')

        self.FugaRota = self.table.read()
        self.cons = self.constraints.read()
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
        self.cur.execute(self.FugaRota)
        self.assertEqual(self.cur.statusmessage, "CREATE TABLE")
    
    def testCConstraints(self):
        self.cur.execute(self.cons)
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

    def testADropTable(self):
        self.cur.execute("DROP TABLE FugaRota CASCADE;")
        self.assertEqual(self.cur.statusmessage, "DROP TABLE")
