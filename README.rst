.. -*- rst -*-

Python Bindings for xxHash
==========================

Package Description
-------------------
This package provides Python wrappers for the xxHash fast non-cryptographic hash
algorithm. Inspired by `existing Python wrappers
<https://github.com/ewencp/pyhashxx/>`_, the wrappers in this package expose
both the 32 and 64-bit versions of the algorithm and leverage `Cython
<https://cython.org>`_ to provide better support for
incremental updating of a hash using data encapsulated in a range of Python
container classes.

Quick Start
-----------
Make sure you have `pip <http://pip.pypa.io>`_ installed; once you do, install
the package as follows::

  pip install xxhash

Development
-----------
The latest source code can be obtained from the project website at
`<https://github.com/lebedov/xxhash>`_.

Authors & Acknowledgements
--------------------------
See the included AUTHORS.rst file for more information.

License
-------
This software is licensed under the `BSD License
<http://www.opensource.org/licenses/bsd-license.php>`_.
See the included LICENSE file for more information.
