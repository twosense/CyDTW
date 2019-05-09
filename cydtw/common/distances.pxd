'''
Header file for distance functions.
'''

from cydtw.common.types cimport NUMERIC

cdef NUMERIC euclidean(NUMERIC x, NUMERIC y)
cdef NUMERIC squared(NUMERIC x, NUMERIC y)
cdef NUMERIC dist(NUMERIC x, NUMERIC y, str dkey)
