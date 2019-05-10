'''
Implementation of warping path algorithm.
'''

cimport cython

import numpy as np
cimport numpy as np

@cython.boundscheck(False)
@cython.wraparound(False)
cdef list compute_warping_path(np.float64_t[:, :] acm, int _size_x, int _size_y):
    '''
    Walk backwards in time through the ACM to determine the optimal warping
    path.

    :params acm: Computed accumulated cost matrix.
    :returns warping_path: Optimal path through the accumulated cost matrix.
    '''

    # Prepare constants for warping path.
    cdef int _min_idx
    cdef int _wix = _size_x - 1
    cdef int _wiy = _size_y - 1

    # Apppend the end point to the warping path.
    # Proceed backwards in time along the path that minimizes the total
    # accumulated cost. The algorithm is only allowed to enter spaces that are
    # adjacent to the current position, and backward in time.
    cdef list warping_path = [[_wix, _wiy]]
    while ((_wix + _wiy) != 0):
        if _wix == 0:
            _wiy -= 1

        elif _wiy == 0:
            _wix -= 1

        else:
            _min_idx = np.argmin([acm[_wix - 1, _wiy],
                                  acm[_wix, _wiy - 1],
                                  acm[_wix - 1, _wiy - 1]])

            if _min_idx == 0:
                _wix -= 1

            elif _min_idx == 1:
                _wiy -= 1

            elif _min_idx == 2:
                _wix -= 1
                _wiy -= 1

        warping_path.append([_wix, _wiy])

    return warping_path[::-1]

cdef double compute_warping_path_total_cost(np.float64_t[:, :] distances, list warping_path):
    '''
    Given a warping path and cost matrix compute the optimal cost.

    :params distances: Computed distance matrix.
    :params warping_path: Optimal path through the accumulated cost matrix.
    :returns cost: Accumulated cost metric across the optimal path.
    '''

    # Initialize cost variable.
    cdef double cost = 0

    # Follow the warping path to determine the total cost.
    cdef int _ix, _iy
    for _ix, _iy in warping_path:
        cost += distances[_ix, _iy]

    return cost
