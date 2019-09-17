#!/usr/bin/env python

import os
import re

from setuptools import setup, Extension

NAME =               'xxh'
VERSION =            '0.1.2'
AUTHOR =             'Lev E. Givon'
AUTHOR_EMAIL =       'lev@columbia.edu'
URL =                'https://github.com/lebedov/xxh'
DESCRIPTION =        'Python bindings for xxhash non-cryptographic hash algorithm'
with open('README.rst', 'r') as f:
    LONG_DESCRIPTION = f.read()
LONG_DESCRIPTION = re.search('.*(^Package Description.*)', LONG_DESCRIPTION, re.MULTILINE|re.DOTALL).group(1)
DOWNLOAD_URL = URL
LICENSE = 'BSD'
CLASSIFIERS = [
    'Development Status :: 4 - Beta',
    'Intended Audience :: Developers',
    'Intended Audience :: Science/Research',
    'License :: OSI Approved :: BSD License',
    'Operating System :: OS Independent',
    'Programming Language :: Python',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.2',
    'Programming Language :: Python :: 3.3',
    'Programming Language :: Python :: 3.4',
    'Programming Language :: Python :: 3.5',
    'Programming Language :: Python :: 3.6',
    'Programming Language :: Python :: 3.7',
    'Topic :: Scientific/Engineering',
    'Topic :: Software Development']

extensions = [
    Extension('xxh',
              sources=['src/xxh.pyx', 'xxhash/xxhash.c'],
              include_dirs=['xxhash'],
              extra_compile_args=['-O3'])
    ]

if __name__ == '__main__':
    if os.path.exists('MANIFEST'):
        os.remove('MANIFEST')

setup(name=NAME,
      version=VERSION,
      author=AUTHOR,
      author_email = AUTHOR_EMAIL,
      license = LICENSE,
      classifiers = CLASSIFIERS,
      description = DESCRIPTION,
      long_description = LONG_DESCRIPTION,
      url = URL,
      ext_modules = extensions,
      setup_requires = [
          'setuptools>=18.0',
          'cython'
          ],
      test_suite = 'tests')
