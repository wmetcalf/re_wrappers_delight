#!/usr/bin/env python

from distutils.core import setup, Extension
import os

SRC_DIR = os.path.join(BASE_DIR, PKG_BASE)

def get_long_description():
    readme_f = open(os.path.join(SRC_DIR, "README.rst"))
    readme = readme_f.read()
    readme_f.close()
    
    return readme
    
setup(
    name="re2",
    version="0.1.0",
    description="Python wrapper for Google's RE2",
    long_description=get_long_description(),
    
    author="David Reiss",
    
    classifiers = [
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Topic :: Scientific/Engineering :: Information Analysis",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Text Processing",
        "Topic :: Text Processing :: General",
        ]

    py_modules = ["re2"],
    
    ext_modules = [Extension("_re2",
      sources = ["_re2.cc"],
      libraries = ["re2"],
      )],
    )
