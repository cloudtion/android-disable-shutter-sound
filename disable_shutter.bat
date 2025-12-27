@echo off
setlocal EnableDelayedExpansion

:: Enable ANSI colors on Windows 10+
for /F "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%" geq "10.0" (
    for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
)

set "GREEN=!ESC![32m"
set "RED=!ESC![31m"
set "RESET=!ESC![0m"

echo [*] Checking if ADB is installed...
where adb >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [*] ADB is already installed.
) else (
    echo [*] ADB not found in PATH.
    echo [!] Please install ADB manually:
    echo     - Download from: https://developer.android.com/studio/releases/platform-tools
    echo     - Or use: choco install adb
    echo     - Or use: winget install Google.PlatformTools
    exit /b 1
)

echo [*] Starting ADB server...
adb start-server

echo [*] Waiting for a connected ^& authorized device...
:waitloop
set DEVICE_COUNT=0
for /f "skip=1 tokens=2" %%a in ('adb devices') do (
    if "%%a"=="device" set /a DEVICE_COUNT+=1
)
if !DEVICE_COUNT! geq 1 (
    echo [*] Device detected!
    goto :devicefound
)
timeout /t 1 /nobreak >nul
goto :waitloop

:devicefound

:: Get current value
for /f "tokens=*" %%a in ('adb shell settings get system csc_pref_camera_forced_shuttersound_key 2^>nul') do set CURRENT_VAL=%%a
echo|set /p="[*] Current shutter sound setting: "
call :print_status "!CURRENT_VAL!"

echo [*] Disabling forced camera shutter sound...
adb shell settings put system csc_pref_camera_forced_shuttersound_key 0

:: Get new value
for /f "tokens=*" %%a in ('adb shell settings get system csc_pref_camera_forced_shuttersound_key 2^>nul') do set NEW_VAL=%%a
echo|set /p="[*] New shutter sound setting: "
call :print_status "!NEW_VAL!"

echo [*] Done! You may need to reboot or restart the camera app.
goto :eof

:print_status
set "value=%~1"
if "!value!"=="0" (
    echo !GREEN!Disabled!RESET!
) else if "!value!"=="1" (
    echo !RED!Enabled!RESET!
) else (
    echo Unknown ^(!value!^)
)
goto :eof
