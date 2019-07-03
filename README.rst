.. -*- rst -*-

Python Bindings for xxHash
==========================

Package Description
-------------------
This package provides a Python interface to the xxHash fast non-cryptographic
hash algorithm. Inspired by `existing Python wrappers for xxHash
<https://github.com/ewencp/pyhashxx/>`_, this package exposes both the 32 and
64-bit versions of the algorithm and leverages `Cython <https://cython.org>`_ to
provide better support for incremental updating of a hash using data
encapsulated in a range of Python container classes. The package is compatible
with Python 2.7 and later.

.. image:: https://img.shields.io/pypi/v/xxh.svg
    :target: https://pypi.python.org/pypi/xxh
    :alt: Latest Version
.. image:: https://img.shields.io/pypi/dm/xxh.svg
    :target: https://pypi.python.org/pypi/xxh
    :alt: Downloads

Quick Start
-----------
Make sure you have `pip <http://pip.pypa.io>`_ and `Cython 
<https://cython.org>`_ installed; once you do, install
the package as follows: ::

  pip install xxh

Development
-----------
The latest source code can be obtained from the project website at
`GitHub <https://github.com/lebedov/xxh>`_.

Authors & Acknowledgements
--------------------------
See the included `AUTHORS.rst
<https://github.com/lebedov/xxh/blob/master/AUTHORS.rst>`_ file for 
more information.

License
-------
This software is licensed under the `BSD License
<http://www.opensource.org/licenses/bsd-license>`_.
See the included `LICENSE.rst
<https://github.com/lebedov/xxh/blob/master/LICENSE.rst>`_ file for
more information.
