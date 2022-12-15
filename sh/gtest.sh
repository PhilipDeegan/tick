#!/usr/bin/env bash
#
# Author: Philip Deegan
# Email : philip.deegan@polytechnique.edu 
# Date  : 26 - September - 2017
#
# This script builds and launches google test files for tick
#
# Requires the mkn build tool
#
# Input arguments are optional but if used are to be the
#  test files to be compiled and run, otherwise all files
#  with the syntax "*gtest.cpp" are used
#
# Tests are expected to finish with the following code
#
# #ifdef ADD_MAIN
# int main(int argc, char** argv) {
#   ::testing::InitGoogleTest(&argc, argv);
#   ::testing::FLAGS_gtest_death_test_style = "fast";
#   return RUN_ALL_TESTS();
# }
# #endif  // ADD_MAIN
#
# This is used to inject main functions for testing/execution
# 
######################################################################

set -ex

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $CWD/.. 2>&1 > /dev/null
ROOT=$PWD
popd 2>&1 > /dev/null

source $ROOT/sh/configure_env.sh
cd $ROOT/lib

FILES=()
array=( "$@" )
arraylength=${#array[@]}
for (( i=1; i<${arraylength}+1; i++ )); do
   FILES+=("${array[$i-1]}")
done

pushd $CWD/../lib 2>&1 > /dev/null

[ "$arraylength" == "0" ] && FILES=($(find cpp-test -name "*gtest.cpp"))

mkn clean build -p gtest -tSa "$CXXFLAGS -DGTEST_CREATE_SHARED_LIBRARY" -d google.test,+ ${MKN_X_FILE}

if (( IS_WINDOWS == 1 )); then export MKN_LIB_EXT=".pyd"; fi
for FILE in "${FILES[@]}"; do
    mkn clean build -p gtest -a "${CXXFLAGS} -DGTEST_LINKED_AS_SHARED_LIBRARY" \
        -tl "${LDFLAGS}" -M "${FILE}" run ${MKN_X_FILE} ${MKN_P}
done

popd 2>&1 > /dev/null
