cd build

cmake --build . --config Release --target install
if errorlevel 1 exit 1

if [%PKG_NAME%] == [poppler] (
       del %LIBRARY_PREFIX%\lib\poppler-qt5.*
       del %LIBRARY_PREFIX%\lib\pkgconfig\poppler-qt5.pc
 )

if [%PKG_NAME%] == [poppler-qt] (
       del %LIBRARY_PREFIX%\bin/pdf*
       del %LIBRARY_PREFIX%\bin/poppler*
       del %LIBRARY_PREFIX%\include/poppler/*.h
       del %LIBRARY_PREFIX%\include/poppler/cpp
       del %LIBRARY_PREFIX%\include/poppler/fofi
       del %LIBRARY_PREFIX%\include/poppler/glib
       del %LIBRARY_PREFIX%\include/poppler/goo
       del %LIBRARY_PREFIX%\include/poppler/splash
       del %LIBRARY_PREFIX%\lib/poppler.lib
       del %LIBRARY_PREFIX%\lib/poppler-cpp.lib
       del %LIBRARY_PREFIX%\lib/poppler-glib.lib
       del %LIBRARY_PREFIX%\lib/pkgconfig/poppler.pc
       del %LIBRARY_PREFIX%\lib/pkgconfig/poppler-cpp.pc
       del %LIBRARY_PREFIX%\lib/pkgconfig/poppler-glib.pc
       del %LIBRARY_PREFIX%\share/man/man1/pdf*
)
