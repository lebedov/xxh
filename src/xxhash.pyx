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
    unsigned int XXH64_intermediateDigest(void *state)
    unsigned int XXH64_digest(void *state)
    ctypedef struct XXH64_stateSpace_t:
        pass

cdef class xxh32_state:
    """
    xxHash32 state.
    """
    cdef XXH32_stateSpace_t *state

def xxh32_init(unsigned int seed=0):
    s = xxh32_state()
    s.state = <XXH32_stateSpace_t *>XXH32_init(seed)
    return s

def xxh32_update(xxh32_state s, data):
    cdef Py_buffer buf
    PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
    err = XXH32_update(<void *>s.state, <void *>buf.buf, buf.len)
    if err != 0:
        raise ValueError('error')

def xxh32_intermediateDigest(xxh32_state s):
    return XXH32_intermediateDigest(<void *>s.state)

def xxh32_digest(xxh32_state s):
    return XXH32_digest(<void *>s.state)

cdef class Hasher32:
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
        
    def update(self, data):
        """
        Update hash state.
        """
        
        cdef Py_buffer buf
        PyObject_GetBuffer(data, &buf, PyBUF_SIMPLE)
        err = XXH32_update(<void *>self._state, <void *>buf.buf, buf.len)
        if err != 0:
            raise ValueError('error updating hash')

    def digest(self):
        """
        Return hash digest.

        Notes
        -----
        This method may be repeatedly invoked after multiple state updates.
        """        
        return XXH32_intermediateDigest(<void *>self._state)
