cd build

cmake --build . --config Release --target install
if errorlevel 1 exit 1

if [%PKG_NAME%] == [poppler] (
       del /F /Q %LIBRARY_PREFIX%\bin\poppler-qt5.dll
       del /F /Q %LIBRARY_PREFIX%\include\poppler\qt5
       del /F /Q %LIBRARY_PREFIX%\lib\poppler-qt5.*
       del /F /Q %LIBRARY_PREFIX%\lib\pkgconfig\poppler-qt5.pc
 )

if [%PKG_NAME%] == [poppler-qt] (
       del /F /Q %LIBRARY_PREFIX%\bin\pdf*.exe
       del /F /Q %LIBRARY_PREFIX%\bin\poppler.dll
       del /F /Q %LIBRARY_PREFIX%\bin\poppler-cpp.dll
       del /F /Q %LIBRARY_PREFIX%\bin\poppler-glib.dll
       del /F /Q %LIBRARY_PREFIX%\include\poppler\*.h
       del /F /Q %LIBRARY_PREFIX%\include\poppler\cpp
       del /F /Q %LIBRARY_PREFIX%\include\poppler\fofi
       del /F /Q %LIBRARY_PREFIX%\include\poppler\glib
       del /F /Q %LIBRARY_PREFIX%\include\poppler\goo
       del /F /Q %LIBRARY_PREFIX%\include\poppler\splash
       del /F /Q %LIBRARY_PREFIX%\lib\poppler.lib
       del /F /Q %LIBRARY_PREFIX%\lib\poppler-cpp.lib
       del /F /Q %LIBRARY_PREFIX%\lib\poppler-glib.lib
       del /F /Q %LIBRARY_PREFIX%\lib\pkgconfig\poppler.pc
       del /F /Q %LIBRARY_PREFIX%\lib\pkgconfig\poppler-cpp.pc
       del /F /Q %LIBRARY_PREFIX%\lib\pkgconfig\poppler-glib.pc
       del /F /Q %LIBRARY_PREFIX%\share\man\man1\pdf*
)
