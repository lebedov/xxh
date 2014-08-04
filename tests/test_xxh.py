#!/usr/bin/env python

import sys
from unittest import main, TestCase
from xxh import Hasher32, Hasher64

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
        self.assertEqual(h.digest(), 451874561)

    def test_single_unicode(self):
        h = Hasher32()
        h.update(u'xxxyyy')
        self.assertEqual(h.digest(), 3424585009)
        
    def test_multiple_str(self):
        h = Hasher32()
        h.update('xxx')
        h.update('yyy')
        self.assertEqual(h.digest(), 451874561)

    def test_single_int(self):
        h = Hasher32()
        h.update(1)
        self.assertEqual(h.digest(), 149775153)

    def test_single_long(self):
        h = Hasher32()
        h.update(long(sys.maxint))
        self.assertEqual(h.digest(), 1886677411)
                
    def test_sequence(self):
        h = Hasher32()
        h.update(['xxx', 'yyy'])
        self.assertEqual(h.digest(), 451874561)

    def test_bytearray(self):
        h = Hasher32()
        h.update(bytearray(['x', 'y', 'z']))
        self.assertEqual(h.digest(), 4052955091)
        
    def test_many_hashers(self):
        h0 = Hasher32()
        h1 = Hasher32()

        h0.update('aaa')
        h1.update('xxx')
        h0.update('bbb')
        h1.update('yyy')
        h0.update('ccc')
        h1.update('zzz')

        self.assertEqual(h0.digest(), 3425008586)
        self.assertEqual(h1.digest(), 2666506144)

class TestHasher64(TestCase):
    def test_init(self):
        h = Hasher64()
        self.assertEqual(h.digest(), 17241709254077376921L)

    def test_init_seed(self):
        h = Hasher64(0)
        self.assertEqual(h.digest(), 17241709254077376921L)

        h = Hasher64(1)
        self.assertEqual(h.digest(), 15397730242686860875L)

        self.assertRaises(OverflowError, Hasher64, -1L)
        
    def test_single_str(self):
        h = Hasher64()
        h.update('xxxyyy')
        self.assertEqual(h.digest(), 17725107632544488034L)

    def test_single_unicode(self):
        h = Hasher64()
        h.update(u'xxxyyy')
        self.assertEqual(h.digest(), 11561759156150624853L)
        
    def test_multiple_str(self):
        h = Hasher64()
        h.update('xxx')
        h.update('yyy')
        self.assertEqual(h.digest(), 17725107632544488034L)

    def test_single_int(self):
        h = Hasher64()
        h.update(1)
        self.assertEqual(h.digest(), 11468921228449061269L)

    def test_single_long(self):
        h = Hasher64()
        h.update(long(sys.maxint))
        self.assertEqual(h.digest(), 18406436390665352972L)
                
    def test_sequence(self):
        h = Hasher64()
        h.update(['xxx', 'yyy'])
        self.assertEqual(h.digest(), 17725107632544488034L)

    def test_bytearray(self):
        h = Hasher64()
        h.update(bytearray(['x', 'y', 'z']))
        self.assertEqual(h.digest(), 18355062698322115745L)
        
    def test_many_hashers(self):
        h0 = Hasher64()
        h1 = Hasher64()

        h0.update('aaa')
        h1.update('xxx')
        h0.update('bbb')
        h1.update('yyy')
        h0.update('ccc')
        h1.update('zzz')

        self.assertEqual(h0.digest(), 17756375367745080265L)
        self.assertEqual(h1.digest(), 13952351896635647814L)
                
if __name__ == '__main__':
    main()
