import numpy as np

from Cython.Build import cythonize
from distutils.core import setup

package_data = {'cydtw/common/': ['*.pxd']}

setup(
    name = 'cydtw',
    version='0.0.1',
    author='Brian Todd',
    author_email='20519009+brian-todd@users.noreply.github.com',
    description='High performance DTW library.',
    url="https://github.com/brian-todd/CyDTW",
    ext_modules = cythonize([
        'cydtw/*.pyx',
        'cydtw/common/*.pyx',],
            compiler_directives={'language_level' : '3'},
            annotate=True),
    include_dirs = [np.get_include()],
    package_data=package_data,
)
