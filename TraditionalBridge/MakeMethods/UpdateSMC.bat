@echo off
pushd %~dp0
setlocal

rem Configure a Synergy environment
call "%SYNERGYDE64%dbl\dblvars64.bat"

set ROOT=%~dp0
set RPSMFIL=%ROOT%..\..\Repository\rpsmain.ism
set RPSTFIL=%ROOT%..\..\Repository\rpstext.ism
set XFPL_SMCPATH=%ROOT%..\MethodCatalog

rem Delete any existing file to make sure we get a new one
if exist "%XFPL_SMCPATH%\smc.xml" del /q "%XFPL_SMCPATH%\smc.xml"

rem Generate a new SMC XML file from our method sources
echo Processing source files...
dbl2xml %ROOT%..\Methods\*.dbl -out "%XFPL_SMCPATH%\smc.xml"
if ERRORLEVEL 1 goto parse_fail

rem Load the XML file into the SMC
echo Loading method catalog...
dbs DBLDIR:mdu -u "%XFPL_SMCPATH%\smc.xml"
if ERRORLEVEL 1 goto load_fail
echo Method catalog was loaded

rem Unload the SMC back to an XML file
echo Unloading method catalog...
dbs DBLDIR:mdu -e "%XFPL_SMCPATH%\smc.xml"
if ERRORLEVEL 1 goto load_fail

goto done

:parse_fail
echo ERROR: Failed to extract SMC data from code
goto done

:load_fail
echo ERROR: Failed to load method catalog
goto done

:unload_fail
echo ERROR: Failed to unload method catalog
goto done

:done
endlocal
popd

pause