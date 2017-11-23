#! /bin/bash

# if [ $(uname) = Darwin ] ; then
#     export LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib"
# fi
# export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
# export LDFLAGS="$LDFLAGS -L$PREFIX/lib"

mkdir build && cd build

cmake  -D CMAKE_BUILD_TYPE=Release \
       -D CMAKE_INSTALL_PREFIX=$PREFIX \
       -D CMAKE_INSTALL_LIBDIR:PATH=$PREFIX/lib \
       -D TESTDATADIR=$PWD/testfiles \
       -D ENABLE_XPDF_HEADERS=ON \
       $SRC_DIR

make -j$CPU_COUNT
# ctest  # no tests were found :-/
make install -j$CPU_COUNT

pushd $PREFIX
rm -rf lib/libpoppler*.la lib/libpoppler*.a share/gtk-doc
popd
