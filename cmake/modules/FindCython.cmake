# Find the Cython compiler.
#
# This code sets the following variables:
#
#  Cython_EXECUTABLE
#
# See also UseCython.cmake

#=============================================================================
# Copyright 2011 Kitware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=============================================================================

# Use the Cython executable that lives next to the Python executable
# if it is a local installation.
find_package(Python)
if( Python_FOUND )
  get_filename_component( _python_path ${Python_EXECUTABLE} PATH )
  find_program( Cython_EXECUTABLE
    NAMES cython cython.bat cython3
    HINTS ${_python_path}
    )
else()
  find_program( Cython_EXECUTABLE
    NAMES cython cython.bat cython3
    )
endif()


include( FindPackageHandleStandardArgs )
FIND_PACKAGE_HANDLE_STANDARD_ARGS( Cython REQUIRED_VARS Cython_EXECUTABLE )

mark_as_advanced( Cython_EXECUTABLE )
