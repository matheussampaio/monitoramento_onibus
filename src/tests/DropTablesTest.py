import psycopg2
import unittest
import sys

class DropTablesTest(unittest.TestCase):

        def setUp(self):

            conn = psycopg2.connect("dbname=postgres user=postgres password=pablo")
            conn.set_isolation_level(0) # set autocommit
            self.cur = conn.cursor()

        def tearDown(self):
            self.cur.close()
        
        def testDropTableFugaRota(self):
            self.cur.execute("DROP TABLE FugaRota CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testDropTableHorario(self):
            self.cur.execute("DROP TABLE Horario CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testDropTableLocalization(self):
            self.cur.execute("DROP TABLE Localization CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testDropTableOnibus(self):
            self.cur.execute("DROP TABLE Onibus CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testDropTablePontoOnibusRota(self):
            self.cur.execute("DROP TABLE PontoOnibus_Rota CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testDropTablePontoOnibus(self):
            self.cur.execute("DROP TABLE PontoOnibus CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testDropTableRota(self):
            self.cur.execute("DROP TABLE Rota CASCADE;")
            self.assertEqual(self.cur.statusmessage, "DROP TABLE")

        def testBDropEnum(self):
            self.cur.execute("DROP TYPE status;")
            self.assertEqual(self.cur.statusmessage, "DROP TYPE")


    

        
