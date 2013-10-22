import psycopg2
import unittest
import sys

class PontoOnibusTest(unittest.TestCase):

    def setUp(self):

        self.table = open('createsTable/PontoOnibus.sql', 'r')
        self.constraints = open('createsTable/PontoOnibus_const.sql', 'r')
        self.insert = open('inserts/PontoOnibus_inserts.sql', 'r')
        self.falho = open('inserts/PontoOnibus_inserts_falhos.sql', 'r')

        self.PontoOnibus = self.table.read()
        self.cons = self.constraints.read()
        self.inserts = self.insert.readlines()
        self.falhos = self.falho.readlines()

        self.table.close()
        self.constraints.close()
        self.insert.close()
        self.falho.close()
        
        self.geometria = "SELECT AddGeometryColumn('','pontoonibus','geom','4291','POINT',2);"

        conn = psycopg2.connect("hostaddr=192.168.1.244 dbname=teste user=matheussampaio password=sampaio")
        conn.set_isolation_level(0) # set autocommit
        self.cur = conn.cursor()

    def tearDown(self):
        self.cur.close()

    def testBCreateTable(self):
        self.cur.execute(self.PontoOnibus)
        self.assertEqual(self.cur.statusmessage, "CREATE TABLE")
        self.cur.execute(self.geometria)
        self.assertEqual(self.cur.statusmessage, "SELECT 1")
    
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
                self.assertFalse(False)

    def testADropTable(self):
        self.cur.execute("DROP TABLE PontoOnibus CASCADE;")
        self.assertEqual(self.cur.statusmessage, "DROP TABLE")
			
		
