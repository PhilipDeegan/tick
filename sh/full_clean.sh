#!/usr/bin/env bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Using the python executable defined in env. variable TICK_PYTHON otherwise fall back to "python"
PYTHON_EXEC=${TICK_PYTHON:=python3}

find lib/swig/ -name "*.cpp"  | xargs rm
rm -rf $CWD/../lib/bin

${PYTHON_EXEC} $CWD/../setup.py clean
