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
# ccache is recommended
#
######################################################################

set -ex

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $CWD/.. 2>&1 > /dev/null
ROOT=$PWD
popd 2>&1 > /dev/null

source $ROOT/sh/configure_env.sh
cd $ROOT/lib

mkn clean build -dtSOg 0 -a "${CXXFLAGS}" -p array

if (( IS_WINDOWS == 1 )); then export MKN_LIB_EXT=".pyd"; fi
export MKN_LIB_LINK_LIB=1
mkn clean build -dtSOg 0 -a "${CXXFLAGS}" ${MKN_P}
