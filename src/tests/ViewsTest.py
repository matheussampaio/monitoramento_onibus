import psycopg2
import unittest
import sys
import os

class ViewsTest(unittest.TestCase):

    def setUp(self):

        self.view = open(os.path.abspath('../') + '/sql/inserts/views.sql', 'r')
        self.views = self.view.readlines()
        self.view.close()
                
        conn = psycopg2.connect("hostaddr=192.168.1.244 dbname=teste user=matheussampaio password=sampaio")
        conn.set_isolation_level(0) # set autocommit
        self.cur = conn.cursor()

    def tearDown(self):
        self.cur.close()

    def testBCreatViews(self):
        for self.v in self.views:
            self.cur.execute(self.v)
            self.assertEqual(self.cur.statusmessage, "CREATE VIEW")

    def testCrota555view(self):
        self.cur.execute("SELECT * FROM rota555view;")
        self.assertEqual(self.cur.statusmessage, "SELECT 1")

    def testDrota505view(self):
        self.cur.execute("SELECT * FROM rota505view;")
        self.assertEqual(self.cur.statusmessage, "SELECT 1")

    def testErota500view(self):
        self.cur.execute("SELECT * FROM rota500view;")
        self.assertEqual(self.cur.statusmessage, "SELECT 1")

    def testFLastlocalization(self):
        self.cur.execute("SELECT * FROM lastLocalization;")
        self.assertEqual(self.cur.statusmessage, "SELECT 0")

 
