#! /bin/bash

set -e

# The zlib check does not let you specify its install prefix so we have
# to go global.
export CFLAGS="${CFLAGS} -I${PREFIX}/include"
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
if [[ ${HOST} =~ .*darwin.* ]] ; then
    export LDFLAGS="${LDFLAGS} -Wl,-rpath,${PREFIX}/lib"
else
    export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,${PREFIX}/lib"
fi

mkdir build && cd build

cmake -G "$CMAKE_GENERATOR" \
      -D CMAKE_PREFIX_PATH=$PREFIX \
      -D CMAKE_INSTALL_LIBDIR:PATH=$PREFIX/lib \
      -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D ENABLE_XPDF_HEADERS=True \
      -D ENABLE_LIBCURL=True \
      -D ENABLE_LIBOPENJPEG=openjpeg2 \
       $SRC_DIR

make -j$CPU_COUNT V=1
# ctest  # no tests were found :-/
make install -j$CPU_COUNT

pushd ${PREFIX}
  rm -rf lib/libpoppler*.la lib/libpoppler*.a share/gtk-doc
popd
