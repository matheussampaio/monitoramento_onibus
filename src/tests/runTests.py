import unittest as test  # @UnusedWildImport

from HelloTest import *  # @UnusedWildImport


def SuiteTest():
    suite = test.TestSuite()
    suite.addTest(test.makeSuite(HelloTest))
    return suite

if __name__ == "__main__":
    runner = test.TextTestRunner()
    test_suite = SuiteTest()
    runner.run(test_suite)
