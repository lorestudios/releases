@echo off
setlocal

set "SETUP_URL=https://github.com/lorestudios/releases/releases/download/craftdesk-preview/craftdesk-setup-windows-amd64.exe"
set "SETUP=%TEMP%\craftdesk-preview-setup-%RANDOM%-%RANDOM%.exe"

curl.exe -fL --max-redirs 5 --connect-timeout 5 --max-time 120 ^
  -o "%SETUP%" "%SETUP_URL%"
if errorlevel 1 goto :failed

"%SETUP%" /install
set "RESULT=%ERRORLEVEL%"
del /q "%SETUP%" >nul 2>&1
exit /b %RESULT%

:failed
set "RESULT=%ERRORLEVEL%"
del /q "%SETUP%" >nul 2>&1
exit /b %RESULT%
