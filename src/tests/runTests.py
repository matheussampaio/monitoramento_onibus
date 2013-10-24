import unittest as test  # @UnusedWildImport
import xmlrunner

from HelloTest import *  # @UnusedWildImport
from PontoOnibusTest import * # @UnusedWildImport
from RotaTest import * # @UnusedWildImport
from PontoOnibusRotaTest import * # @UnusedWildImport
from OnibusTest import * # @UnusedWildImport
from HorariosTest import * # @UnusedWildImport
from LocalizationTest import * # @UnusedWildImport
from FugaRotaTest import * # @UnusedWildImport
from FunctionsTest import * # @UnusedWildImport
from TriggersTest import * # @UnusedWildImport
from ViewsTest import * # @UnusedWildImport
#from DropTablesTest import * # @UnusedWildImport


def SuiteTest():
    suite = test.TestSuite()
    suite.addTest(test.makeSuite(APontoOnibusTest))
    suite.addTest(test.makeSuite(BRotaTest))
    suite.addTest(test.makeSuite(CPontoOnibusRotaTest))
    suite.addTest(test.makeSuite(DOnibusTest))
    suite.addTest(test.makeSuite(EHorariosTest))
    suite.addTest(test.makeSuite(FLocalizationTest))
    suite.addTest(test.makeSuite(GFugaRotaTest))
    suite.addTest(test.makeSuite(HFunctionsTest))
    suite.addTest(test.makeSuite(ITriggersTest))
    suite.addTest(test.makeSuite(JViewsTest))
    #suite.addTest(test.makeSuite(LDropTablesTest))
    return suite

if __name__ == "__main__":
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))
    runner = test.TextTestRunner()
    test_suite = SuiteTest()
    runner.run(test_suite)
