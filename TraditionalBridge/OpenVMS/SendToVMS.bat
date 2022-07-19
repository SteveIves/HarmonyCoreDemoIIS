@echo off
setlocal
pushd %~dp0
rem 
rem =============================================================================
rem
rem Create an FTP command script to transfer the files
rem 
echo Creating FTP script...
echo open %VMS_HOST% 21 > ftp.tmp
echo %VMS_USER% >> ftp.tmp
echo %VMS_PASSWORD% >> ftp.tmp
echo ascii >> ftp.tmp
echo prompt >> ftp.tmp
echo cd [.REPOSITORY] >> ftp.tmp
echo mput ..\..\repository\repository.scm >> ftp.tmp
echo mput ..\..\repository\repack_box_contnt.sch >> ftp.tmp
echo mput ..\..\repository\repack_box_verfy.sch >> ftp.tmp
echo cd [-.SOURCE] >> ftp.tmp
echo mput ..\source\host.dbl >> ftp.tmp
echo cd [.BRIDGE] >> ftp.tmp
echo mput ..\source\bridge\*.dbl >> ftp.tmp
echo cd [-.DISPATCHERS] >> ftp.tmp
echo mput ..\source\dispatchers\*.dbl >> ftp.tmp
echo cd [-.METHODS] >> ftp.tmp
echo mput ..\source\methods\*.dbl >> ftp.tmp
echo cd [-.MODELS] >> ftp.tmp
echo mput ..\source\models\*.dbl >> ftp.tmp
echo cd [-.-] >> ftp.tmp
echo put BRIDGE.OPT >> ftp.tmp
echo put BUILD.COM >> ftp.tmp
echo put LAUNCH.COM >> ftp.tmp
echo put REMOTE_DEBUG.COM >> ftp.tmp
echo put SETUP.COM >> ftp.tmp
echo bye >> ftp.tmp

rem Transfer the files
echo Transferring files...
ftp -s:ftp.tmp 1>nul

rem Delete the command script
echo Cleaning up...
del /q ftp.tmp

echo Done!
popd
endlocal