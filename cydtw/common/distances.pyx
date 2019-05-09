'''
Implementation of various distance functions.
'''

import numpy as np
cimport numpy as np

from cydtw.common.types cimport NUMERIC

cdef NUMERIC euclidean(NUMERIC x, NUMERIC y):
    return abs(x - y)

cdef NUMERIC squared(NUMERIC x, NUMERIC y):
    return (x - y) ** 2

cdef NUMERIC dist(NUMERIC x, NUMERIC y, str dkey):
    '''
    Compute the distance metric for a specified key.

    :params x: Point in the time series ins_x.
    :params y: Point in the time series ins_y.
    :returns distance: Compute distance between the two points.
    '''

    if dkey == 'euclidean':
        return euclidean(x, y)

    elif dkey == 'squared':
        return squared(x, y)

    else:
        raise Exception('No distance metric found for {}'.format(dkey))
