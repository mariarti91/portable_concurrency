#!/bin/bash -e

SRCDIR=$(dirname $(dirname $0))

export LIBCXX=$1
export BUILD_TYPE=$2
export DEPS_BUILD_TYPE=${BUILD_TYPE}
export CTEST_OUTPUT_ON_FAILURE=True

export LSAN_OPTIONS=verbosity=1:log_threads=1

if [ "${BUILD_TYPE}" == "UBsan" ] || [ "${BUILD_TYPE}" == "Asan" ] || [ "${BUILD_TYPE}" == "Tsan" ]
then
  export DEPS_BUILD_TYPE=Debug
fi

export CONAN_CMAKE_GENERATOR=Ninja

cmake --version
conan --version
conan profile update settings.compiler.libcxx="${LIBCXX}" default
conan profile update settings.build_type="${DEPS_BUILD_TYPE}" default
# dump toolchain info
conan profile show default

conan remote add VestniK https://api.bintray.com/conan/pdeps/deps
conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan 
conan install --build=missing ${SRCDIR}

cmake -G Ninja ${SRCDIR} \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCONAN_LIBCXX=${LIBCXX} \
  -DCONAN_COMPILER=$(conan profile get settings.compiler default) \
  -DCONAN_COMPILER_VERSION=$(conan profile get settings.compiler.version default) \
  -DPC_DEV_BUILD=ON
time ninja
ninja test
