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
from DropTablesTest import * # @UnusedWildImport


def SuiteTest():
    suite = test.TestSuite()
    suite.addTest(test.makeSuite(PontoOnibusTest))
    suite.addTest(test.makeSuite(RotaTest))
    suite.addTest(test.makeSuite(PontoOnibusRotaTest))
    suite.addTest(test.makeSuite(OnibusTest))
    suite.addTest(test.makeSuite(HorariosTest))
    suite.addTest(test.makeSuite(LocalizationTest))
    suite.addTest(test.makeSuite(FugaRotaTest))
    suite.addTest(test.makeSuite(FunctionsTest))
    suite.addTest(test.makeSuite(TriggersTest))
    suite.addTest(test.makeSuite(ViewsTest))
    suite.addTest(test.makeSuite(DropTablesTest))
    return suite

if __name__ == "__main__":
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))
    runner = test.TextTestRunner()
    test_suite = SuiteTest()
    runner.run(test_suite)
