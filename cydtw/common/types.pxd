'''
Header file for declaring types.
'''

import numpy as np
cimport numpy as np

ctypedef fused NUMERIC:
    np.float64_t
    np.float32_t
    np.int64_t
    np.int32_t
