#!/usr/bin/env python
import sys
import os
from distutils.core import setup, Extension, Command

class TestCommand(Command):
    description = 'Run packaged tests'
    user_options = []
    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        import tests.test as test
        test.testall()

cmdclass = {'test': TestCommand}

ext_files = []
if '--cython' in sys.argv[1:]:
    # Using Cython
    sys.argv.remove('--cython')
    from Cython.Distutils import build_ext
    cmdclass['build_ext'] = build_ext
    ext_files.append("src/re2.pyx")
else:
    # Building from C
    ext_files.append("src/re2.cpp")


# Locate the re2 module
_re2_prefixes = [
    '/usr',
    '/usr/local',
    '/opt/',
    ]

for re2_prefix in _re2_prefixes:
    if os.path.exists(os.path.join(re2_prefix, "include", "re2")):
        break
else:
    raise OSError("Cannot find RE2 library. Please install it from http://code.google.com/p/re2/wiki/Install")


setup(
    name="re2",
    version="0.2.6",
    description="Python wrapper for Google's RE2 using Cython",
    author="Mike Axiak",
    license="New BSD License",
    author_email = "mike@axiak.net",
    url = "http://github.com/axiak/pyre2/",
    ext_modules = [Extension("re2",
                             ext_files,
                             language="c++",
                             include_dirs=[os.path.join(re2_prefix, "include", "re2")],
                             libraries=["re2"],
                             library_dirs=[os.path.join(re2_prefix, "lib")],
                             runtime_library_dirs=[os.path.join(re2_prefix, "lib")],
                             )],
    cmdclass=cmdclass,
    classifiers = [
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Cython',
        'Programming Language :: Python :: 2.5',
        'Programming Language :: Python :: 2.6',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Libraries :: Python Modules',
        ],
    )
