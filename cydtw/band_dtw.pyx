'''
Implementation of Band DTW algorithm.
'''

cimport cython

import numpy as np
cimport numpy as np

from cydtw.common.distances cimport dist
from cydtw.common.paths cimport compute_warping_path
from cydtw.common.paths cimport compute_warping_path_total_cost
from cydtw.common.types cimport NUMERIC

@cython.boundscheck(False)
@cython.wraparound(False)
cpdef tuple compute(NUMERIC[:] ins_x, NUMERIC[:] ins_y, int window, str dkey = 'euclidean'):
    '''
    Compute Band DTW between two time series. The warping path is constrained
    to within the predefined bands, which speeds up the computaion. However,
    Band DTW is not quite as accurate as plain DTW.

    :params ins_x: Input array of the first time series.
    :params ins_y: Input array of the second time series.
    :returns outs: Tuple consisting of the the computed cost, warping path,
                   accumulated cost matrix, and distances(cost) matrix.
    '''

    # Get sizes for matrix initialization.
    cdef int _size_x = ins_x.shape[0]
    cdef int _size_y = ins_y.shape[0]

    # Compute the size of the bands.
    cdef int w = max(window, abs(_size_x - _size_y))

    # Intitialize both distance matrix and accumulated cost matrix (ACM).
    cdef np.float64_t[:, :] distances = np.full((_size_x, _size_y), fill_value=np.inf, dtype=np.float64)
    cdef np.float64_t[:, :] acm = np.full((_size_x, _size_y), fill_value=np.inf, dtype=np.float64)

    # Compute distances at each point subject to the constraint that the points
    # lie within the specified band.
    cdef int _ix, _iy
    for _ix in range(_size_x):
        for _iy in range(max(0, (_ix + 1) - w), min(_size_y, _ix + w)):
            distances[_ix, _iy] = dist(ins_x[_ix], ins_y[_iy], dkey)

    acm[0, 0] = distances[0, 0]

    # Compute the accumulated cost within the boundary.
    # On each iteration we have to make sure that infinite values are not
    # being added to the cost.
    cdef np.float64_t prev_acc_cost
    for _ix in range(_size_x):
        for _iy in range(max(0, (_ix + 1) - w), min(_size_y, _ix + w)):
            prev_acc_cost = min(acm[_ix - 1, _iy],
                                acm[_ix - 1, _iy - 1],
                                acm[_ix, _iy - 1])

            # Validate that the minimum is not inf.
            if prev_acc_cost == np.inf:
                prev_acc_cost = 0

            acm[_ix, _iy] = distances[_ix, _iy] + prev_acc_cost

    # Compute optimal warping path.
    cdef list warping_path = compute_warping_path(acm, _size_x, _size_y)

    # Compute total cost from following optimal warping path.
    cdef double cost = compute_warping_path_total_cost(distances, warping_path)

    return cost, warping_path, np.asarray(acm), np.asarray(distances)
