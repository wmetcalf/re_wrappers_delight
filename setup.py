#!/usr/bin/env python
import sys
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


setup(
    name="re2",
    version="0.2.0",
    description="Python wrapper for Google's RE2 using Cython",
    author="Mike Axiak",
    ext_modules = [Extension("re2",
                             ext_files,
                             language="c++",
                             include_dirs=["/usr/include/re2"],
                             libraries=["re2"],
                             )],
    cmdclass=cmdclass,
    )
