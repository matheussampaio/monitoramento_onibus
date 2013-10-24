import psycopg2
import unittest
import sys
import os

class ITriggersTest(unittest.TestCase):

    def setUp(self):

        self.trigger1 = open(os.path.abspath('../') + '/sql/Triggers/TriggerLocalizationRefreshCurrentPontoOnibus.sql', 'r')
        self.trigger2 = open(os.path.abspath('../') + '/sql/Triggers/TriggerLocalizationRefreshCurrentSeq.sql', 'r')
        self.trigger3 = open(os.path.abspath('../') + '/sql/Triggers/TriggerLocalizationRefreshFugaRota.sql', 'r')
        self.trigger4 = open(os.path.abspath('../') + '/sql/Triggers/TriggerLocalizationRefreshStatusOnibus.sql', 'r')
        self.trigger5 = open(os.path.abspath('../') + '/sql/Triggers/TriggerPontoOnibusRotaCheckOnibus.sql', 'r')

        self.LocalizationRefreshPO = self.trigger1.read()
        self.LocalizationRefreshSeq = self.trigger2.read()
        self.LocalizationRefreshFugaRota = self.trigger3.read()
        self.LocalizationRefreshStatusOnibus = self.trigger4.read()
        self.ChecaOnibus = self.trigger5.read()

        self.trigger1.close()
        self.trigger2.close()
        self.trigger3.close()
        self.trigger4.close()
        self.trigger5.close()
        
        conn = psycopg2.connect("hostaddr=192.168.1.244 dbname=teste user=matheussampaio password=sampaio")
        conn.set_isolation_level(0) # set autocommit
        self.cur = conn.cursor()

    def tearDown(self):
        self.cur.close()

    def testBCreatTrigger(self):
        self.cur.execute(self.LocalizationRefreshPO)
        self.assertEqual(self.cur.statusmessage, "CREATE TRIGGER")

        self.cur.execute(self.LocalizationRefreshSeq)
        self.assertEqual(self.cur.statusmessage, "CREATE TRIGGER")

        self.cur.execute(self.LocalizationRefreshFugaRota)
        self.assertEqual(self.cur.statusmessage, "CREATE TRIGGER")

        self.cur.execute(self.LocalizationRefreshStatusOnibus)
        self.assertEqual(self.cur.statusmessage, "CREATE TRIGGER")

        self.cur.execute(self.ChecaOnibus)
        self.assertEqual(self.cur.statusmessage, "CREATE TRIGGER")

    #def testADropTrigger(self):
    #    self.cur.execute("DROP TRIGGER refreshcurrentpontoonibus ON Localization;")
    #    self.assertEqual(self.cur.statusmessage, "DROP TRIGGER")
    #    self.cur.execute("DROP TRIGGER refreshCurrentSeq ON Localization;")
    #    self.assertEqual(self.cur.statusmessage, "DROP TRIGGER")
    #    self.cur.execute("DROP TRIGGER refreshFugaRota ON Localization;")
    #    self.assertEqual(self.cur.statusmessage, "DROP TRIGGER")
    #    self.cur.execute("DROP TRIGGER refreshStatusOnibus ON Localization;")
    #    self.assertEqual(self.cur.statusmessage, "DROP TRIGGER")
    #    self.cur.execute("DROP TRIGGER checkPontoOnibusInRota ON PontoOnibus_Rota;")
    #    self.assertEqual(self.cur.statusmessage, "DROP TRIGGER")

