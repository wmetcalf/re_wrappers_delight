#!/usr/bin/env python
from distutils.core import setup, Extension
from Cython.Distutils import build_ext

setup(
    name="re2",
    version="0.2.0",
    description="Python wrapper for Google's RE2 using Cython",
    author="Mike Axiak",
    ext_modules = [Extension("re2",
                             ["src/re2.pyx"],
                             language="c++",
                             include_dirs=["/usr/include/re2"],
                             libraries=["re2"],
                             )],
    cmdclass={'build_ext': build_ext},
    )
