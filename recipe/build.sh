#! /bin/bash

set -exo pipefail

# Ensure we look in the correct directory for gir files
export XDG_DATA_DIRS="$PREFIX/share"

extra_cmake_args=(
    -GNinja
    -DCMAKE_INSTALL_LIBDIR=lib
    -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
    -DENABLE_GPGME=OFF
    -DENABLE_LIBCURL=ON
    -DENABLE_LIBOPENJPEG=openjpeg2
    -DENABLE_QT6=OFF
)

# For now, we're not building the Qt subpackage in some cross scenarios, and the
# build system requires us to explicitly disable it. The filter here needs to
# say synchronized with the subpackage `skip` logic in `meta.yaml`.
case "${target_platform}" in
    linux-ppc64le|osx-arm64)
        extra_cmake_args+=(-DENABLE_QT5=OFF)
        ;;
esac

if [ -n "$OSX_ARCH" ] ; then
    # The -dead_strip_dylibs option breaks g-ir-scanner in this package: the
    # scanner uses the linker to find paths to dylibs, and it wants to find
    # libpoppler.dylib, but with this option the linker strips the library
    # from the test executable. The error message is "ERROR: can't resolve
    # libraries to shared libraries: poppler".
    export LDFLAGS="$(echo $LDFLAGS |sed -e "s/-Wl,-dead_strip_dylibs//g")"
    export LDFLAGS_LD="$(echo $LDFLAGS_LD |sed -e "s/-dead_strip_dylibs//g")"

    # See: https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

if [ "${CONDA_BUILD_CROSS_COMPILATION}" = "1" ]; then
    unset _CONDA_PYTHON_SYSCONFIGDATA_NAME
    (
        mkdir -p native-build
        pushd native-build

        export CC=$CC_FOR_BUILD
        export CXX=$CXX_FOR_BUILD
        export AR=$($CC_FOR_BUILD -print-prog-name=ar)
        export NM=$($CC_FOR_BUILD -print-prog-name=nm)
        export LDFLAGS=${LDFLAGS//$PREFIX/$BUILD_PREFIX}
        export PKG_CONFIG_PATH=${BUILD_PREFIX}/lib/pkgconfig

        # Unset them as we're ok with builds that are either slow or non-portable
        unset CFLAGS
        unset CPPFLAGS
        unset CXXFLAGS

        cmake "${extra_cmake_args[@]}" \
            -DCMAKE_PREFIX_PATH=$BUILD_PREFIX \
            -DCMAKE_INSTALL_PREFIX=$BUILD_PREFIX \
            -DTIFF_INCLUDE_DIR=$BUILD_PREFIX/include \
            $SRC_DIR
        # This script would generate the functions.txt and dump.xml and save them
        # This is loaded in the native build. We assume that the functions exported
        # by glib are the same for the native and cross builds
        export GI_CROSS_LAUNCHER=$BUILD_PREFIX/libexec/gi-cross-launcher-save.sh
        ninja -j$CPU_COUNT -v
        popd
    )

    export GI_CROSS_LAUNCHER=$BUILD_PREFIX/libexec/gi-cross-launcher-load.sh

    # Make sure to get build-platform tools:
    extra_cmake_args+=(
        -DGLIB2_MKENUMS=$BUILD_PREFIX/bin/glib-mkenums
        -DGLIB2_MKENUMS_PYTHON=$BUILD_PREFIX/bin/python
    )
fi

mkdir -p build && cd build

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig"

cmake ${CMAKE_ARGS} "${extra_cmake_args[@]}" \
    -DBoost_DIR=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DTIFF_INCLUDE_DIR=$PREFIX/include \
    $SRC_DIR

ninja
# ctest  # no tests were found :-/
