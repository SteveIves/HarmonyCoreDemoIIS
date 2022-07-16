@echo off
rem This batch file publishes your Harmony Core service for deployment to a
rem hosting system, for example to an IIS server. The script does the
rem following:
rem 
rem  1. Publishes the application to a temporary folder called PUBLISH
rem
rem  2. Copies in the Traditional Bridge host program and launch script
rem
rem  3. Replaces the web.config created by the publish operation with
rem     one that sets the ASPNETCORE_ENVIRONMENT to Production
rem
rem  4. Optionally includes the content of the SampleData folder
rem     (Only if environment variuable INCLUDE_SAMPLE_DATA is defined)
rem
rem  5. Optionally includes VC++ runtime files
rem     (Only if environment variuable INCLUDE_C_RUNTIMES is defined)
rem
rem  6. Zips the PUBLISH folder to HarmonyCoreService-yyyymmdd-hhmm.zip
rem     (Only if 7-zip is installed)
rem
rem  7. Deletes the temporary PUBLISH folder
rem     (Only if the zip file was created)
rem
rem  8. Transfers the ZIP file to a remote server via FTP.
rem     (Only if WinSCP is installed and the environment variables
rem     PUBLISH_FTP_SERVER PUBLISH_FTP_USER and PUBLISH_FTP_PASSWORD
rem     are defined)
rem 
rem A good way to set these environment variables is to create a batch
rem file named publish_settings.bat in the main solution folderr. if
rem the file is present it will be executed when this script runs.

setlocal EnableDelayedExpansion

set SolutionDir=%~dp0

pushd "%SolutionDir%"

if exist publish_settings.bat call publish_settings.bat

set rpsmfil=%SolutionDir%Repository\rpsmain.ism
set rpstfil=%SolutionDir%Repository\rpstext.ism

set DeployDir=%SolutionDir%PUBLISH

rem If there is an old PUBLISH folder, delete it
if exist "%DeployDir%\." (
  echo INFO: Deleting previous deployment folder...
  rmdir /S /Q "%DeployDir%" > nul 2>&1
)

rem Publish the application
echo INFO: Publishing the application to the deployment folder...
pushd Services.Host
dotnet publish -c Debug -r win7-x64 -o %DeployDir%

if ERRORLEVEL 0 (
  echo INFO: Publish is complete
) else (
  echo ERROR: Publish failed!
  popd
  goto done
)

popd

rem Include the Traditional Bridge host program and startup script
echo INFO: Providing Traditional Bridge files...
copy /y TraditionalBridge\EXE\host.dbr %DeployDir%
copy /y TraditionalBridge\EXE\host.dbp %DeployDir%
copy /y TraditionalBridge\EXE\launch.bat %DeployDir%

rem Replace the web.config file with our own version that sets the
rem ASPNETCORE_ENVIRONMENT to Production
if exist "%DeployDir%\web.config" (
  echo INFO: Providing custom web.config file...
  del  /Q "%DeployDir%\web.config"
  copy /Y "%SolutionDir%\web.config" "%DeployDir%\web.config" > nul 2>&1
)

rem If you want to include the SampleData folder set INCLUDE_SAMPLE_DATA=YES
rem in PUBLISH_SETTINGS.BAT
if defined INCLUDE_SAMPLE_DATA (
  echo INFO: Providing sample data...
  if not exist %DeployDir%\SampleData\. mkdir %DeployDir%\SampleData
  copy /y SampleData\*.* %DeployDir%\SampleData
)

rem At the time of writing, Azure AppService does not provide the VS2019 C++
rem runtimes so if we are publishing for AppService we need to include them
rem 
if defined INCLUDE_C_RUNTIMES (
  echo INFO: Providing C++ runtimes...
  copy /y vcredistFiles\*.* %DeployDir%
)

rem If WinZip is present, Zip the PUBLISH folder to a date-stamped zip file
set yyyymmdd=%date:~-4%%date:~4,2%%date:~7,2%
set hh=%TIME:~0,2%
set mm=%TIME:~3,2%
set zipFile=%SolutionDir%HarmonyCoreService-%yyyymmdd%-%hh%%mm%.zip

if exist %DeployDir%\. (
  if exist "%ProgramW6432%\7-Zip\7z.exe" (
    echo INFO: Zipping the published application to %zipFile%
    pushd %DeployDir%
    "%ProgramW6432%\7-Zip\7z.exe" a -r "%zipFile%" *

    if ERRORLEVEL 0 (
      echo INFO: The zip file was created successfully
    ) else (
      echo ERROR: Failed to create zip file!
      popd
      goto done
    )
    popd
  ) else (
    echo WARNING: Unable to zip the deployment directory because 7-zip is not installed!
    echo INFO: The published application is in %DeployDir%
  )
)

rem Does the zip file exist?
if exist "%zipFile%" (

  rem Yes, delete the PUBLISH folder
  rmdir /S /Q "%DeployDir%" > nul 2>&1

    rem Do we have an FTP username?
    if not defined PUBLISH_FTP_SERVER (
        echo WARNING: Unable to upload the zip file to staging server because PUBLISH_FTP_SERVER is not set!
        goto done
    )
    rem Do we have an FTP username?
    if not defined PUBLISH_FTP_USER (
        echo WARNING: Unable to upload the zip file to staging server because PUBLISH_FTP_USER is not set!
        goto done
    )

    rem Do we have an FTP password?
    if not defined PUBLISH_FTP_PASSWORD (
        echo WARNING: Unable to upload the zip file to staging server because PUBLISH_FTP_USER is not set!
        goto done
    )

    rem Is WinSCP installed?
    if exist "%ProgramFiles(x86)%\WinSCP\WinSCP.com" (

        echo INFO: Uploading zip file to staging server...

        rem Yes, upload the ZIP file to the staging server
        "%ProgramFiles(x86)%\WinSCP\WinSCP.com" /command "open ftp://%PUBLISH_FTP_USER%:%PUBLISH_FTP_PASSWORD%@%PUBLISH_FTP_SERVER%/" "put %zipFile% /" "exit"

        if ERRORLEVEL 0 (
        echo SUCCESS: The zip file was successfully uploaded to the staging server.
        ) else (
        echo ERROR: Failed to upload the zip file to the staging server!
        )
    ) else (
        echo WARNING: Unable to upload the zip file to staging server because WinSCP is not installed!
    )
)

:done
popd
endlocal
