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

popd
endlocal
pause