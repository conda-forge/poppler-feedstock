mkdir build
cd build

cmake -G "NMake Makefiles" ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -D CMAKE_INSTALL_LIBDIR:PATH=%LIBRARY_LIB% ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D ENABLE_XPDF_HEADERS=True ^
      -D ENABLE_LIBCURL=True ^
      -D ENABLE_LIBOPENJPEG=openjpeg2 ^
       %SRC_DIR%
if errorlevel 1 exit 1	   

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
