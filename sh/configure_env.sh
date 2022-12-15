
set -e

CXXFLAGS="${CXXFLAGS:-}"
LDFLAGS=${LDFLAGS:-}
MKN_X_FILE=${MKN_X_FILE:-}

[ -z "$PY" ] && which python3 &> /dev/null && PY="python3"
[ -z "$PY" ] && which python &> /dev/null && PY="python"
[ -z "$PY" ] && echo "python or python3 not on path, exiting with error" && exit 1

[ -n "$MKN_X_FILE" ] && MKN_X_FILE="-x ${MKN_X_FILE}"

IS_WINDOWS=0
unameOut="$(uname -s)"
if [[ "$unameOut" == "CYGWIN"* ]] || [[ "$unameOut" == "MINGW"* ]] || [[ "$unameOut" == "MSYS_NT"* ]]; then
  IS_WINDOWS=1
  CXXFLAGS="${CXXFLAGS} -EHsc -std:c++17"
else
  CXXFLAGS="${CXXFLAGS} -fPIC -std=c++17"
fi

# We get the filename expected for C++ shared libraries
LIB_POSTFIX=$($PY -c "import sysconfig; print(sysconfig.get_config_var('EXT_SUFFIX'))")
[ -z "$LIB_POSTFIX" ] && echo "LIB_POSTFIX undefined: ERROR" && exit 1
LIB_POSTFIX="${LIB_POSTFIX%.*}"

MKN_P="-P lib_name=$LIB_POSTFIX"
