#!/usr/bin/env python

import sys
from unittest import main, TestCase
from xxh import Hasher32, Hasher64

PY2 = sys.version_info[0] == 2

class TestHasher32(TestCase):
    def test_init(self):
        h = Hasher32()
        self.assertEqual(h.digest(), 46947589)

    def test_init_seed(self):
        h = Hasher32(0)
        self.assertEqual(h.digest(), 46947589)

        h = Hasher32(1)
        self.assertEqual(h.digest(), 187479954)

        self.assertRaises(OverflowError, Hasher32, -1)

    def test_single_str(self):
        h = Hasher32()
        h.update('xxxyyy')
        if PY2:
            self.assertEqual(h.digest(), 451874561)
        else:
            self.assertEqual(h.digest(), 3424585009)

    def test_single_unicode(self):
        h = Hasher32()
        h.update(u'xxxyyy')
        self.assertEqual(h.digest(), 3424585009)

    def test_multiple_str(self):
        h = Hasher32()
        h.update('xxx')
        h.update('yyy')
        if PY2:
            self.assertEqual(h.digest(), 451874561)
        else:
            self.assertEqual(h.digest(), 3424585009)

    def test_single_int(self):
        h = Hasher32()
        h.update(1)
        self.assertEqual(h.digest(), 149775153)

    def test_single_long(self):
        h = Hasher32()
        h.update(9223372036854775807)
        self.assertEqual(h.digest(), 1886677411)

    def test_sequence(self):
        h = Hasher32()
        h.update(['xxx', 'yyy'])
        if PY2:
            self.assertEqual(h.digest(), 451874561)
        else:
            self.assertEqual(h.digest(), 3424585009)

    def test_bytearray(self):
        h = Hasher32()
        h.update(bytearray([0, 1, 2]))
        self.assertEqual(h.digest(), 1715378773)

    def test_many_hashers(self):
        h0 = Hasher32()
        h1 = Hasher32()

        h0.update('aaa')
        h1.update('xxx')
        h0.update('bbb')
        h1.update('yyy')
        h0.update('ccc')
        h1.update('zzz')

        if PY2:
            self.assertEqual(h0.digest(), 3425008586)
            self.assertEqual(h1.digest(), 2666506144)
        else:
            self.assertEqual(h0.digest(), 3829107854)
            self.assertEqual(h1.digest(), 1177210121)

class TestHasher64(TestCase):
    def test_init(self):
        h = Hasher64()
        self.assertEqual(h.digest(), 17241709254077376921)

    def test_init_seed(self):
        h = Hasher64(0)
        self.assertEqual(h.digest(), 17241709254077376921)

        h = Hasher64(1)
        self.assertEqual(h.digest(), 15397730242686860875)

        self.assertRaises(OverflowError, Hasher64, -1)

    def test_single_str(self):
        h = Hasher64()
        h.update('xxxyyy')
        if PY2:
            self.assertEqual(h.digest(), 17725107632544488034)
        else:
            self.assertEqual(h.digest(), 11561759156150624853)

    def test_single_unicode(self):
        h = Hasher64()
        h.update(u'xxxyyy')
        self.assertEqual(h.digest(), 11561759156150624853)

    def test_multiple_str(self):
        h = Hasher64()
        h.update('xxx')
        h.update('yyy')
        if PY2:
            self.assertEqual(h.digest(), 17725107632544488034)
        else:
            self.assertEqual(h.digest(), 11561759156150624853)

    def test_single_int(self):
        h = Hasher64()
        h.update(1)
        self.assertEqual(h.digest(), 11468921228449061269)

    def test_single_long(self):
        h = Hasher64()
        h.update(9223372036854775807)
        self.assertEqual(h.digest(), 18406436390665352972)

    def test_sequence(self):
        h = Hasher64()
        h.update(['xxx', 'yyy'])
        if PY2:
            self.assertEqual(h.digest(), 17725107632544488034)
        else:
            self.assertEqual(h.digest(), 11561759156150624853)

    def test_bytearray(self):
        h = Hasher64()
        h.update(bytearray([0, 1, 2]))
        self.assertEqual(h.digest(), 16557408460946040285)

    def test_many_hashers(self):
        h0 = Hasher64()
        h1 = Hasher64()

        h0.update('aaa')
        h1.update('xxx')
        h0.update('bbb')
        h1.update('yyy')
        h0.update('ccc')
        h1.update('zzz')

        if PY2:
            self.assertEqual(h0.digest(), 17756375367745080265)
            self.assertEqual(h1.digest(), 13952351896635647814)
        else:
            self.assertEqual(h0.digest(), 8818389695707234733)
            self.assertEqual(h1.digest(), 15396284027515453819)

if __name__ == '__main__':
    main()
