# Copyright (c) 2014-2015, Lev Givon
# All rights reserved.
# Distributed under the terms of the BSD license:
# http://www.opensource.org/licenses/bsd-license

from cpython.buffer cimport PyObject_CheckBuffer
from cpython.buffer cimport PyBUF_SIMPLE
from cpython.buffer cimport Py_buffer
from cpython.buffer cimport PyObject_GetBuffer

from cpython.bool cimport PyBool_Check
from cpython.int cimport PyInt_Check
from cpython.int cimport PyInt_AsLong

from cpython.long cimport PyLong_Check
from cpython.long cimport PyLong_AsLongLong
from cpython.long cimport PyLong_AsUnsignedLongLong

from cpython.float cimport PyFloat_Check
from cpython.float cimport PyFloat_AsDouble

from cpython.complex cimport Py_complex
from cpython.complex cimport PyComplex_Check
from cpython.complex cimport PyComplex_AsCComplex

from cpython.unicode cimport PyUnicode_AS_DATA
from cpython.unicode cimport PyUnicode_Check
from cpython.unicode cimport PyUnicode_GET_DATA_SIZE

cdef enum XXH_errorcode:
    XXH_OK = 0
    XXH_ERROR

cdef extern from "pyport.h":
    int INT_MAX
    long LONG_MAX
    long LONG_MIN

cdef int INT_MIN = -INT_MAX-1

# Make C int/long min/max values available as Python values:
C_INT_MAX = INT_MAX
C_INT_MIN = INT_MIN
C_LONG_MAX = LONG_MAX
C_LONG_MIN = LONG_MIN

cdef extern from "xxhash.h":
    unsigned int XXH32(const void* input, size_t length,
                       unsigned int seed)

    ctypedef struct XXH32_state_t:
        pass
    XXH32_state_t* XXH32_createState()
    XXH_errorcode XXH32_freeState(XXH32_state_t* statePtr)

    XXH_errorcode XXH32_reset(XXH32_state_t* statePtr, unsigned int seed)
    XXH_errorcode XXH32_update(XXH32_state_t* statePtr, const void* input,
            size_t length)
    unsigned int XXH32_digest(const XXH32_state_t* statePtr)

    unsigned long long XXH64 (const void* input, size_t length,
                              unsigned long long seed)

    ctypedef struct XXH64_state_t:
        pass
    XXH64_state_t* XXH64_createState()
    XXH_errorcode XXH64_freeState(XXH64_state_t* statePtr)

    XXH_errorcode XXH64_reset(XXH64_state_t* statePtr, unsigned int seed)
    XXH_errorcode XXH64_update(XXH64_state_t *statePtr, const void* input,
                               size_t length)
    unsigned long long XXH64_digest(const XXH64_state_t* statePtr)

def hash32(data, unsigned int seed=0):
    """
    Compute hash of object using xxHash 32 algorithm.

    Parameters
    ----------
    data : object
        Object to hash.
    seed : int
        Optional seed value (default = 0).

    Returns
    -------
    hash : int
        32-bit hash value.
    """

    cdef Py_buffer buf
    cdef bint data_bint
    cdef long data_long
    cdef long long data_long_long
    cdef double data_double
    cdef Py_complex data_complex

    if PyObject_CheckBuffer(data):
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        return XXH32(<void *>buf.buf, buf.len, seed)
    elif PyUnicode_Check(data):
        return XXH32(<void *>PyUnicode_AS_DATA(data),
                     PyUnicode_GET_DATA_SIZE(data),
                     seed)
    elif PyBool_Check(data):
        data_bint = data
        return XXH32(&data_bint, sizeof(bint), seed)
    elif PyInt_Check(data):
        if data > INT_MAX or data < INT_MIN:
            data_long = PyInt_AsLong(data)
            return XXH32(&data_long, sizeof(long), seed)
        else:
            data_long_long = PyLong_AsLongLong(data)
            return XXH32(&data_long_long,
                         sizeof(long long),
                         seed)
    elif PyLong_Check(data):
        data_long_long = PyLong_AsLongLong(data)
        return XXH32(&data_long_long, sizeof(long long), seed)
    elif PyFloat_Check(data):
        data_double = PyFloat_AsDouble(data)
        return XXH32(&data_double, sizeof(double), seed)
    elif PyComplex_Check(data):
        data_complex = PyComplex_AsCComplex(data)
        return XXH32(&data_complex, sizeof(Py_complex), seed)
    elif data is None:
        data_bint = 0
        return XXH32(&data_bint, sizeof(int), seed)
    else:
        raise ValueError('type \'%s\' not hashable' % type(data).__name__)

def hash64(data, unsigned long long seed=0):
    """
    Compute hash of object using xxHash 64 algorithm.

    Parameters
    ----------
    data : object
        Object to hash.
    seed : long
        Optional seed value (default = 0L).

    Returns
    -------
    hash : long
        64-bit hash value.
    """

    cdef Py_buffer buf
    cdef bint data_bint
    cdef long data_long
    cdef long long data_long_long
    cdef double data_double
    cdef Py_complex data_complex

    if PyObject_CheckBuffer(data):
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        return XXH64(<void *>buf.buf, buf.len, seed)
    elif PyUnicode_Check(data):
        return XXH64(<void *>PyUnicode_AS_DATA(data),
                     PyUnicode_GET_DATA_SIZE(data),
                     seed)
    elif PyBool_Check(data):
        data_bint = data
        return XXH64(&data_bint, sizeof(bint), seed)
    elif PyInt_Check(data):
        if data > INT_MAX or data < INT_MIN:
            data_long = PyInt_AsLong(data)
            return XXH64(&data_long, sizeof(long), seed)
        else:
            data_long_long = PyLong_AsLongLong(data)
            return XXH64(&data_long_long,
                         sizeof(long long),
                         seed)
    elif PyLong_Check(data):
        data_long_long = PyLong_AsLongLong(data)
        return XXH64(&data_long_long, sizeof(long long), seed)
    elif PyFloat_Check(data):
        data_double = PyFloat_AsDouble(data)
        return XXH64(&data_double, sizeof(double), seed)
    elif PyComplex_Check(data):
        data_complex = PyComplex_AsCComplex(data)
        return XXH64(&data_complex, sizeof(Py_complex), seed)
    elif data is None:
        data_bint = 0
        return XXH64(&data_bint, sizeof(int), seed)
    else:
        raise ValueError('type \'%s\' not hashable' % type(data).__name__)

cdef class Hasher32(object):
    """
    xxHash 32 hash object.

    Parameters
    ----------
    seed : int
        Seed value for hash computation. Must be nonnegative.
    """

    cdef XXH32_state_t *_state

    def __init__(self, unsigned int seed=0):
        self._state = XXH32_createState()
        XXH32_reset(self._state, seed)

    def __dealloc__(self):
        XXH32_freeState(self._state)

    cdef int _update(self, data):
        cdef Py_buffer buf
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        return XXH32_update(self._state, <void *>buf.buf, buf.len)

    cdef int _update_unicode(self, data):
        return XXH32_update(self._state,
                            <void *>PyUnicode_AS_DATA(data),
                            PyUnicode_GET_DATA_SIZE(data))

    cdef int _update_bool(self, bint data):
        return XXH32_update(self._state,
                            <void *>&data,
                            sizeof(bint))

    cdef int _update_int(self, int data):
        return XXH32_update(self._state,
                            <void *>&data,
                            sizeof(int))

    cdef int _update_long(self, long data):
        return XXH32_update(self._state,
                            <void *>&data,
                            sizeof(long))

    cdef int _update_long_long(self, long long data):
        return XXH32_update(self._state,
                            <void *>&data,
                            sizeof(long long))

    cdef int _update_unsigned_long_long(self, unsigned long long data):
        return XXH32_update(self._state,
                            <void *>&data,
                            sizeof(unsigned long long))

    cdef int _update_float(self, double data):
        return XXH32_update(self._state,
                            <void *>&data,
                            sizeof(double))

    cdef int _update_complex(self, Py_complex data):
        return XXH32_update(self._state,
                            <void *>&data,
                            sizeof(Py_complex))

    def update(self, data):
        """
        Update hash state.

        Parameters
        ----------
        data : object or sequence
            The raw bytes contained by the specified object(s) are used to update
            the hash.

        Notes
        -----
        If a sequence containing several objects followed by an unhashable
        object are specified, the hash state will be updated with the valid
        objects even though an exception will occur because of
        the latter object.

        If a Unicode object is specified, the bytes in its internal buffer are
        hashed - not its encoding using some codec.

        Integers that require more than 64 bits are not deemed hashable.
        """

        cdef int i
        if PyObject_CheckBuffer(data):
            err = self._update(data)
        elif PyUnicode_Check(data):
            err = self._update_unicode(data)
        elif PyBool_Check(data):
            err = self._update_bool(data)
        elif PyInt_Check(data):
            if data > INT_MAX or data < INT_MIN:
                err = self._update_long(PyInt_AsLong(data)) # 32 bit
            else:
                err = self._update_long_long(PyLong_AsLongLong(data)) # 64 bit
        elif PyLong_Check(data):
            err = self._update_long_long(PyLong_AsLongLong(data)) # > 64 bit will fail
        elif PyFloat_Check(data):
            err = self._update_float(PyFloat_AsDouble(data))
        elif PyComplex_Check(data):
            err = self._update_complex(PyComplex_AsCComplex(data))
        elif data is None:
            err = self._update_int(0)
        else:
            for i in range(len(data)):
                self.update(data[i])
            return
        if err:
            raise ValueError('error updating hash')

    def digest(self):
        """
        Return hash digest.

        Notes
        -----
        This method may be repeatedly invoked after multiple state updates.
        """

        return XXH32_digest(self._state)

cdef class Hasher64(object):
    """
    xxHash 64 hash object.

    Parameters
    ----------
    seed : long
        Seed value for hash computation. Must be nonnegative.
    """

    cdef XXH64_state_t *_state

    def __init__(self, unsigned long seed=0L):
        self._state = XXH64_createState()
        XXH64_reset(self._state, seed)

    def __dealloc__(self):
        XXH64_freeState(self._state)

    cdef int _update(self, data):
        cdef Py_buffer buf
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        return XXH64_update(self._state, <void *>buf.buf, buf.len)

    cdef int _update_unicode(self, data):
        return XXH64_update(self._state,
                            <void *>PyUnicode_AS_DATA(data),
                            PyUnicode_GET_DATA_SIZE(data))

    cdef int _update_bool(self, bint data):
        return XXH64_update(self._state,
                            <void *>&data,
                            sizeof(bint))

    cdef int _update_int(self, int data):
        return XXH64_update(self._state,
                            <void *>&data,
                            sizeof(int))

    cdef int _update_long(self, long data):
        return XXH64_update(self._state,
                            <void *>&data,
                            sizeof(long))

    cdef int _update_long_long(self, long long data):
        return XXH64_update(self._state,
                            <void *>&data,
                            sizeof(long long))

    cdef int _update_unsigned_long_long(self, unsigned long long data):
        return XXH64_update(self._state,
                            <void *>&data,
                            sizeof(unsigned long long))

    cdef int _update_float(self, double data):
        return XXH64_update(self._state,
                            <void *>&data,
                            sizeof(double))

    cdef int _update_complex(self, Py_complex data):
        return XXH64_update(self._state,
                            <void *>&data,
                            sizeof(Py_complex))

    def update(self, data):
        """
        Update hash state.

        Parameters
        ----------
        data : object or sequence
            The raw bytes contained by the specified object(s) are used to update
            the hash.

        Notes
        -----
        If a sequence containing several objects followed by an unhashable
        object are specified, the hash state will be updated with the valid
        objects even though an exception will occur because of
        the latter object.

        If a Unicode object is specified, the bytes in its internal buffer are
        hashed - not its encoding using some codec.

        Integers that require more than 64 bits are not deemed hashable.
        """

        cdef int i
        if PyObject_CheckBuffer(data):
            err = self._update(data)
        elif PyUnicode_Check(data):
            err = self._update_unicode(data)
        elif PyBool_Check(data):
            err = self._update_bool(data)
        elif PyInt_Check(data):
            if data > INT_MAX or data < INT_MIN:
                err = self._update_long(PyInt_AsLong(data)) # 32 bit
            else:
                err = self._update_long_long(PyLong_AsLongLong(data)) # 64 bit
        elif PyLong_Check(data):
            err = self._update_long_long(PyLong_AsLongLong(data)) # > 64 bit will fail
        elif PyFloat_Check(data):
            err = self._update_float(PyFloat_AsDouble(data))
        elif PyComplex_Check(data):
            err = self._update_complex(PyComplex_AsCComplex(data))
        elif data is None:
            err = self._update_int(0)
        else:
            for i in range(len(data)):
                self.update(data[i])
            return
        if err:
            raise ValueError('error updating hash')

    def digest(self):
        """
        Return hash digest.

        Notes
        -----
        This method may be repeatedly invoked after multiple state updates.
        """

        return XXH64_digest(self._state)

