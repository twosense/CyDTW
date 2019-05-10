# CyDTW

High performance DTW library written in Cython for Python 3.x.

# Installation

From the projects root directory, run the rollowing command:

`python setup.py build_ext --inplace`

This will compile all the relevant files, and produce a shared object file that can be used with Python.

# Usage

Once the package is compiled, and everything is installed, using the package is as simple as any other Python package! Each DTW algorithm has a `compute` method that can be called.

```
>>> import cydtw.dtw as dtw
>>> import numpy as np

>>> x = np.array([1, 1, 2, 3, 2, 0])
>>> y = np.array([0, 1, 1, 2, 3, 2, 1])

>>> cost, warping_path, accumulated_cost_matrix, distances_matrix = dtw.compute(x, y)
>>> print((cost, warping_path, accumulated_cost_matrix, distances_matrix))
(2.0,
 [[0, 0], [0, 1], [0, 2], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6]],
 array([[1., 1., 1., 2., 4., 5., 5.],
        [2., 1., 1., 2., 4., 5., 5.],
        [4., 2., 2., 1., 2., 2., 3.],
        [7., 4., 4., 2., 1., 2., 4.],
        [9., 5., 5., 2., 2., 1., 2.],
        [9., 6., 6., 4., 5., 3., 2.]]),
 array([[1., 0., 0., 1., 2., 1., 0.],
        [1., 0., 0., 1., 2., 1., 0.],
        [2., 1., 1., 0., 1., 0., 1.],
        [3., 2., 2., 1., 0., 1., 2.],
        [2., 1., 1., 0., 1., 0., 1.],
        [0., 1., 1., 2., 3., 2., 1.]]))

```

# Algorithms

The following algorithms have been implemented:

- Basic DTW
- Band DTW
- Weighted DTW (In progress)
