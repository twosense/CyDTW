'''
Implementation of basic DTW algorithm.
'''

import numpy as np
cimport numpy as np

from cydtw.common.distances cimport dist
from cydtw.common.paths cimport compute_warping_path
from cydtw.common.paths cimport compute_warping_path_total_cost
from cydtw.common.types cimport NUMERIC

cpdef tuple compute(NUMERIC[:] ins_x, NUMERIC[:] ins_y, str dkey = 'euclidean'):
    '''
    Compute basic DTW cost between two time series.

    :params ins_x: Input array of the first time series.
    :params ins_y: Input array of the second time series.
    :returns outs: Tuple consisting of the the computed cost, warping path,
                   accumulated cost matrix, and distances(cost) matrix.
    '''

    # Get sizes for matrix initialization.
    cdef int _size_x = ins_x.shape[0]
    cdef int _size_y = ins_y.shape[0]

    # Intitialize both distance matrix and accumulated cost matrix (ACM).
    cdef np.float64_t[:, :] distances = np.zeros((_size_x, _size_y), dtype=np.float64)
    cdef np.float64_t[:, :] acm = np.zeros((_size_x, _size_y), dtype=np.float64)

    # Compute distances at each point.
    cdef int _ix, _iy
    for _ix in range(0, _size_x):
        for _iy in range(0, _size_y):
            distances[_ix, _iy] = dist(ins_x[_ix], ins_y[_iy], dkey)

    # Compute the accumulated cost along each axis.
    # This saves a few function calls in the main loop.
    acm[0, 0] = distances[0, 0]
    for _ix in range(1, _size_x):
        acm[_ix, 0] = distances[_ix, 0] + acm[_ix - 1, 0]

    for _iy in range(1, _size_y):
        acm[0, _iy] = distances[0, _iy] + acm[0, _iy - 1]

    # Compute the accumulated cost along the rest of the path.
    for _ix in range(1, _size_x):
        for _iy in range(1, _size_y):
            acm[_ix, _iy] = distances[_ix, _iy] + min(acm[_ix - 1, _iy],
                                                      acm[_ix - 1, _iy - 1],
                                                      acm[_ix, _iy - 1])

    # Compute optimal warping path.
    cdef list warping_path = compute_warping_path(acm, _size_x, _size_y)

    # Compute total cost from following optimal warping path.
    cdef double cost = compute_warping_path_total_cost(distances, warping_path)

    return cost, warping_path, np.asarray(acm), np.asarray(distances)
