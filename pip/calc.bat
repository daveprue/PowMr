@echo off
setlocal enabledelayedexpansion

:: Define file names
set "BIN_FILE=pip_1.0.1.ota.bin"
set "MANIFEST_FILE=manifest.json"

:: Check if the bin file exists
if not exist "%BIN_FILE%" (
    echo Error: %BIN_FILE% not found!
    exit /b 1
)

:: Get the MD5 hash using certutil
for /f "tokens=* skip=1" %%A in ('certutil -hashfile "%BIN_FILE%" MD5') do (
    if not defined NEW_MD5 (
        :: Extract the hash and strip any trailing/leading spaces
        set "NEW_MD5=%%A"
        set "NEW_MD5=!NEW_MD5: =!"
    )
)

echo Found new MD5 hash: %NEW_MD5%

:: Use PowerShell to replace the old 32-character MD5 hash with the new one
powershell -Command "(Get-Content '%MANIFEST_FILE%') -replace '\"md5\":\s*\"[a-fA-F0-9]{32}\"', '\"md5\": \"%NEW_MD5%\"' | Set-Content '%MANIFEST_FILE%'"

echo %MANIFEST_FILE% successfully updated!
pause

