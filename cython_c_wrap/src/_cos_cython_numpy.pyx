""" Example of wrapping a C function that takes C double arrays as input using
    the Numpy declarations from Cython 
    Valentin Haenel, 2.8.5.2. Numpy Support, 2.8.5. Cython, Scipy Lectures, Oct 18 2016, [Online] 
        Available: http://www.scipy-lectures.org/advanced/interfacing_with_c/interfacing_with_c.html#id13 
"""

""" Example of wrapping a C function that takes C double arrays as input using
    the Numpy declarations from Cython """

# cimport the Cython declarations for numpy
cimport numpy as np
from f2c cimport *

# if you want to use the Numpy-C-API from Cython
# (not strictly necessary for this example, but good practice)
np.import_array()

# cdefine the signature of our c function
cdef extern from "cos_cython_numpy.h":
    void cos_cython_numpy_func (double * in_array, double * out_array, int size)

# cdefine the signature of our c function
cdef extern from "lsame.h":
    logical lsame_(char *ca, char *cb, ftnlen ca_len, ftnlen cb_len)

# create the wrapper code, with numpy type annotations
def cos_cython_numpy_py_func(np.ndarray[double, ndim=1, mode="c"] in_array not None,
                     np.ndarray[double, ndim=1, mode="c"] out_array not None):
    cos_cython_numpy_func(<double*> np.PyArray_DATA(in_array),
                <double*> np.PyArray_DATA(out_array),
                in_array.shape[0])

def lsame_numpy_func(str a, str b):
    cdef a_bytes = a.encode()
    cdef b_bytes = b.encode()

    return bool(lsame_(a_bytes, b_bytes, len(a_bytes), len(b_bytes)))
