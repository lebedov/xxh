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
    void* XXH32_init(unsigned int seed)
    XXH_errorcode XXH32_update(void *state, const void* input, unsigned int len)
    unsigned int XXH32_intermediateDigest(void *state)
    unsigned int XXH32_digest(void *state)
    ctypedef struct XXH32_stateSpace_t:
        pass

    void* XXH64_init(unsigned int seed)
    XXH_errorcode XXH64_update(void *state, const void* input, unsigned int len)
    unsigned long XXH64_intermediateDigest(void *state)
    unsigned long XXH64_digest(void *state)
    ctypedef struct XXH64_stateSpace_t:
        pass

cdef class Hasher32(object):
    """
    xxHash 32 hash object.

    Parameters
    ----------
    seed : int
        Seed value for hash computation. Must be nonnegative.
    """

    cdef XXH32_stateSpace_t *_state

    def __init__(self, unsigned int seed=0):
        self._state = <XXH32_stateSpace_t *>XXH32_init(seed)

    cdef int _update(self, data):
        cdef Py_buffer buf
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        return XXH32_update(<void *>self._state, <void *>buf.buf, buf.len)

    cdef int _update_unicode(self, data):
        return XXH32_update(<void *>self._state,
                           <void *>PyUnicode_AS_DATA(data),
                           PyUnicode_GET_DATA_SIZE(data))

    cdef int _update_bool(self, bint data):
        return XXH32_update(<void *>self._state,
                           <void *>&data,
                           sizeof(bint))

    cdef int _update_int(self, int data):
        return XXH32_update(<void *>self._state,
                           <void *>&data,
                           sizeof(int))
            
    cdef int _update_long(self, long data):
        return XXH32_update(<void *>self._state,
                            <void *>&data,
                            sizeof(long))
    
    cdef int _update_long_long(self, long long data):
        return XXH32_update(<void *>self._state,
                            <void *>&data,
                            sizeof(long long))

    cdef int _update_unsigned_long_long(self, unsigned long long data):
        return XXH32_update(<void *>self._state,
                            <void *>&data,
                            sizeof(unsigned long long))
            
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
        
        return XXH32_intermediateDigest(<void *>self._state)

cdef class Hasher64(object):
    """
    xxHash 64 hash object.

    Parameters
    ----------
    seed : long
        Seed value for hash computation. Must be nonnegative.        
    """

    cdef XXH64_stateSpace_t *_state
    
    def __init__(self, unsigned long seed=0L):
        self._state = <XXH64_stateSpace_t *>XXH64_init(seed)
        
    cdef int _update(self, data):
        cdef Py_buffer buf
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        return XXH64_update(<void *>self._state, <void *>buf.buf, buf.len)

    cdef int _update_unicode(self, data):
        return XXH64_update(<void *>self._state,
                           <void *>PyUnicode_AS_DATA(data),
                           PyUnicode_GET_DATA_SIZE(data))

    cdef int _update_bool(self, bint data):
        return XXH64_update(<void *>self._state,
                           <void *>&data,
                           sizeof(bint))
        
    cdef int _update_int(self, int data):
        return XXH64_update(<void *>self._state,
                           <void *>&data,
                           sizeof(int))

    cdef int _update_long(self, long data):
        return XXH64_update(<void *>self._state,
                           <void *>&data,
                           sizeof(long))

    cdef int _update_long_long(self, long long data):
        return XXH64_update(<void *>self._state,
                            <void *>&data,
                            sizeof(long long))

    cdef int _update_unsigned_long_long(self, unsigned long long data):
        return XXH64_update(<void *>self._state,
                            <void *>&data,
                            sizeof(unsigned long long))
            
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
        
        return XXH64_intermediateDigest(<void *>self._state)
    
