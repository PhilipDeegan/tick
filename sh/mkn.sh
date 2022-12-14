#!/usr/bin/env bash
#
# Author: Philip Deegan
# Email : philip.deegan@polytechnique.edu
# Date  : 21 - September - 2017
#
# This script compiles tick C++ libs in parallel
#   with optimally detected number of threads
#
# Requires the mkn build tool
#
# Input arguments are optional but if used are to be the
#  modules to be compile, otherwise all modules are
#  compiled - use command "mkn profiles" to view available
#  modules/profiles
#
# ccache is recommended
#
######################################################################

set -e

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CWD/../lib 2>&1 > /dev/null

export MKN_LIB_LINK_LIB=1

CXXFLAGS="${CXXFLAGS:-}"

unameOut="$(uname -s)"
if [[ "$unameOut" == "CYGWIN"* ]] || [[ "$unameOut" == "MINGW"* ]] || [[ "$unameOut" == "MSYS_NT"* ]]; then
  CXXFLAGS="${CXXFLAGS} -EHsc -std:c++17"
else
  CXXFLAGS="${CXXFLAGS} -fPIC -std=c++17"
fi

set -x
mkn clean build -dtSOg 0 -a "${CXXFLAGS}"
