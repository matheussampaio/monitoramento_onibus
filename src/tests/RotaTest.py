import psycopg2
import unittest
import sys
import os

class BRotaTest(unittest.TestCase):

    def setUp(self):

      	self.table = open(os.path.abspath('../') + '/sql/createsTable/Rota.sql', 'r')
      	self.constraints = open(os.path.abspath('../') + '/sql/createsTable/Rota_const.sql', 'r')
      	self.insert = open(os.path.abspath('../') + '/sql/inserts/Rota_inserts.sql', 'r')
      	self.falho = open(os.path.abspath('../') + '/sql/inserts/Rota_inserts_falhos.sql', 'r')
      	
      	self.Rota = self.table.read()
      	self.cons = self.constraints.readlines()
      	self.inserts = self.insert.readlines()
      	self.falhos = self.falho.readlines()
      	
      	self.table.close()
      	self.constraints.close()
      	self.insert.close()
      	self.falho.close()

      	conn = psycopg2.connect("dbname=teste user=postgres")
      	conn.set_isolation_level(0) # set autocommit
      	self.cur = conn.cursor()

      	self.geometria = "SELECT AddGeometryColumn('','rota','geom','4291','LINESTRING',2);"


    def tearDown(self):
        self.cur.close()

    def testBCreateTable(self):
        self.cur.execute(self.Rota)
        self.assertEqual(self.cur.statusmessage, "CREATE TABLE")
        self.cur.execute(self.geometria)
        self.assertEqual(self.cur.statusmessage, "SELECT 1")
    
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
