#!/usr/bin/env python

import os

from setuptools import setup, Extension
from Cython.Build import cythonize

NAME = 'xxh'
VERSION = '0.1.2'
AUTHOR = 'Lev E. Givon'
AUTHOR_EMAIL = 'lev@columbia.edu'
URL = 'https://github.com/lebedov/xxh'
MAINTAINER = AUTHOR
MAINTAINER_EMAIL = AUTHOR_EMAIL
DESCRIPTION = 'Python bindings for xxhash non-cryptographic hash algorithm'
LONG_DESCRIPTION = DESCRIPTION
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
      url = URL,
      maintainer = MAINTAINER,
      maintainer_email = MAINTAINER_EMAIL,
      description = DESCRIPTION,
      license = LICENSE,
      classifiers = CLASSIFIERS,
      ext_modules = cythonize(extensions),
      test_suite = 'tests')
