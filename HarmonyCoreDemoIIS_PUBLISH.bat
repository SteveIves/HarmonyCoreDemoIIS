@echo off
setlocal

set DeployDir=%~dp0HarmonyCoreDemoIIS_PUBLISH\
if not exist %DeployDir%\. mkdir %DeployDir%

set SolutionDir=%~dp0HarmonyCoreDemoIIS\
pushd %SolutionDir%

pushd Services.Host
dotnet publish -c Debug -r win7-x64 -o %DeployDir%
popd

if not exist %DeployDir%\SampleData\. mkdir %DeployDir%\SampleData
copy SampleData\*.* %DeployDir%\SampleData

copy EXE\launch.bat %DeployDir%
copy EXE\TraditionalBridgeHost.dbr %DeployDir%

if exist %DeployDir%\web.config del /q %DeployDir%\web.config
copy web.config %DeployDir%\web.config

popd



rem ----------------------------------------------------------------------------
rem This appears to be necessary for now as Azure AppService does not appear to 
rem currently support the VS2019 C++ runtimes!!!
copy vcredistFiles\*.* %DeployDir%
rem ----------------------------------------------------------------------------

endlocal
pause