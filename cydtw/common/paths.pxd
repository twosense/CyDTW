'''
Header file for warping path algorithm declarations.
'''

import numpy as np
cimport numpy as np

cdef list compute_warping_path(np.float64_t[:, :] acm, int _size_x, int _size_y)
cdef double compute_warping_path_total_cost(np.float64_t[:, :] distances, list warping_path)
