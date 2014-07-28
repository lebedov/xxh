from cpython.buffer cimport PyObject_CheckBuffer
from cpython.buffer cimport PyBUF_SIMPLE
from cpython.buffer cimport Py_buffer
from cpython.buffer cimport PyObject_GetBuffer

cdef enum XXH_errorcode:
    XXH_OK = 0
    XXH_ERROR

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
        
    cdef _update(self, data):        
        cdef Py_buffer buf
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        err = XXH32_update(<void *>self._state, <void *>buf.buf, buf.len)
        if err != 0:
            raise ValueError('error updating hash')
            
    def update(self, data):
        """
        Update hash state.

        Parameters
        ----------
        data : object or sequence
            The raw bytes contained by the specified object(s) are used to update
            the hash. The object(s) must expose Python's buffer interface.

        Notes
        -----
        If a sequence containing several objects with buffer interfaces followed
        by an object without a buffer interface, the hash state will be updated
        with the valid objects even though an exception will occur because of
        the latter object.
        """

        if PyObject_CheckBuffer(data) != 0:
            self._update(data)
        else:
            for d in data:
                self._update(d)
            
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
        
    cdef _update(self, data):        
        cdef Py_buffer buf
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        err = XXH64_update(<void *>self._state, <void *>buf.buf, buf.len)
        if err != 0:
            raise ValueError('error updating hash')
            
    def update(self, data):
        """
        Update hash state.

        Parameters
        ----------
        data : object or sequence
            The raw bytes contained by the specified object(s) are used to update
            the hash. The object(s) must expose Python's buffer interface.

        Notes
        -----
        If a sequence containing several objects with buffer interfaces followed
        by an object without a buffer interface, the hash state will be updated
        with the valid objects even though an exception will occur because of
        the latter object.
        """

        if PyObject_CheckBuffer(data) != 0:
            self._update(data)
        else:
            for d in data:
                self._update(d)
        
    def digest(self):
        """
        Return hash digest.

        Notes
        -----
        This method may be repeatedly invoked after multiple state updates.
        """
        
        return XXH64_intermediateDigest(<void *>self._state)
    
