mkdir build
cd build

:: Remove /GL from CXXFLAGS as this causes an error with the 
:: cmake 'export all symbols' functionality
set "CXXFLAGS= -MD"

cmake -G "NMake Makefiles" ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -D CMAKE_INSTALL_LIBDIR:PATH=%LIBRARY_LIB% ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D ENABLE_XPDF_HEADERS=True ^
      -D ENABLE_LIBCURL=True ^
      -D ENABLE_LIBOPENJPEG=openjpeg2 ^
      -D ENABLE_RELOCATABLE=OFF ^
       %SRC_DIR%
if errorlevel 1 exit 1	   

nmake VERBOSE=1
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
