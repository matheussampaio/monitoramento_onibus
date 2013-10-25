import psycopg2
import unittest
import sys

class LDropTablesTest(unittest.TestCase):

        def setUp(self):

            conn = psycopg2.connect("dbname=teste user=postgres")
            conn.set_isolation_level(0) # set autocommit
            self.cur = conn.cursor()

        def tearDown(self):
            self.cur.close()
        
        def testCDropTableFugaRota(self):
            self.cur.execute("DROP TABLE FugaRota;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testEDropTableHorario(self):
            self.cur.execute("DROP TABLE Horario;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testDDropTableLocalization(self):
            self.cur.execute("DROP TABLE Localization CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testFDropTableOnibus(self):
            self.cur.execute("DROP TABLE Onibus;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testBDropTablePontoOnibusRota(self):
            self.cur.execute("DROP TABLE PontoOnibus_Rota;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testGDropTablePontoOnibus(self):
            self.cur.execute("DROP TABLE PontoOnibus;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testADropTableRota(self):
            self.cur.execute("DROP TABLE Rota CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")


    

        
