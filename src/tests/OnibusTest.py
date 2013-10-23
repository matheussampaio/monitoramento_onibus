import psycopg2
import unittest
import sys
import os

class OnibusTest(unittest.TestCase):

		def setUp(self):

			self.table = open(os.path.abspath('../') + '/sql/createsTable/Onibus.sql', 'r')
			self.constraints = open(os.path.abspath('../') + '/sql/createsTable/Onibus_const.sql', 'r')
			self.insert = open(os.path.abspath('../') + '/sql/inserts/Onibus_inserts.sql', 'r')
			self.falho = open(os.path.abspath('../') + '/sql/inserts/Onibus_inserts_falhos.sql', 'r')

			self.Onibus = self.table.read()
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

		def testDCreateTable(self):
			self.cur.execute(self.Onibus)
			self.assertEqual(self.cur.statusmessage, "CREATE TABLE")
		
		def testEConstraints(self):
			self.cur.execute(self.cons)
			self.assertEqual(self.cur.statusmessage, "ALTER TABLE")
			
		def testFInsertTable(self):
			for self.dados in self.inserts:
				self.cur.execute(self.dados)
				self.assertEqual(self.cur.statusmessage, "INSERT 0 1")
		
		def testGInsertTableFalhos(self):
			for self.dadosFalhos in self.falhos:
				try:
					self.cur.execute(self.dadosFalhos)
				except:
					self.assertFalse(False)

		def testADropTable(self):
			self.cur.execute("DROP TABLE Onibus CASCADE;")
			self.assertEqual(self.cur.statusmessage, "DROP TABLE")
			
		def testCCreateEnum(self):
			self.cur.execute("CREATE TYPE status AS ENUM ('normal', 'atrasado', 'adiantado', 'garagem', 'indeterminado');")
			self.assertEqual(self.cur.statusmessage, "CREATE TYPE")
		
		def testBDropEnum(self):
			self.cur.execute("DROP TYPE status;")
			self.assertEqual(self.cur.statusmessage, "DROP TYPE")
