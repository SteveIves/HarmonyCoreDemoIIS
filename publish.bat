@echo off
setlocal

pushd %~dp0

set SolutionDir=%CD%\
set RPSMFIL=%SolutionDir%Repository\rpsmain.ism
set RPSTFIL=%SolutionDir%Repository\rpstext.ism

set DeployDir=%SolutionDir%PUBLISH
if not exist %DeployDir%\. mkdir %DeployDir%

pushd Services.Host
dotnet publish -c Debug -r win7-x64 -o %DeployDir%
popd

if not exist %DeployDir%\SampleData\. mkdir %DeployDir%\SampleData
copy /y SampleData\*.* %DeployDir%\SampleData

copy /y EXE\launch.bat %DeployDir%
copy /y EXE\TraditionalBridgeHost.dbr %DeployDir%
copy /y web.config %DeployDir%\web.config

popd

rem ----------------------------------------------------------------------------
rem This appears to be necessary for now as Azure AppService does not appear to 
rem currently support the VS2019 C++ runtimes!!!
copy /y vcredistFiles\*.* %DeployDir%
rem ----------------------------------------------------------------------------

endlocal
pause