@echo off
SETLOCAL
SET EL=0
SET MAPNIKGYPDIR=%CD%
echo ------ packaging mapnik sdk -----

cd ..
FOR /F "tokens=*" %%i in ('git describe') do SET GITVERSION=%%i
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
CD %MAPNIKGYPDIR%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO mapnik %GITVERSION%

if %TARGET_ARCH% EQU 32 (
	SET ARCH=x86
) ELSE (
	SET ARCH=x64
)

SET PKGNAME=mapnik-win-sdk-%TOOLS_VERSION%-%ARCH%-%GITVERSION%.7z
ECHO packaging to %PKGNAME%

IF EXIST %PKGNAME% DEL %PKGNAME%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

7z a -mx9 %PKGNAME% mapnik-sdk | %windir%\system32\FIND /v "Compressing"
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO packaged to %PKGNAME%

GOTO DONE

:ERROR
SET EL=%ERRORLEVEL%
echo ----------ERROR NODE_MAPNIK --------------

:DONE
CD %MAPNIKGYPDIR%
EXIT /b %EL%
