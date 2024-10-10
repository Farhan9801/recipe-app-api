'''
Testing the calcu module
'''

from django.test import SimpleTestCase

from app import calcu


class CalcuTest(SimpleTestCase):
    '''
    Test calcu module
    '''
    def test_add_method(self):
        ''' Testting adding two numbers'''
        res = calcu.add(3, 4)

        self.assertEqual(res, 7)

    def test_substract(self):
        ''' testing substraction of teo number'''

        res = calcu.sub(5, 2)

        self.assertEqual(res, 3)
