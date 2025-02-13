@echo off

:: Origin: https://github.com/sejnub/small-apps/tree/master/z_backup

break off
if "%~1"=="" (
    echo Error: Please provide a path as the first parameter
    echo Usage: %~nx0 path_to_file
    timeout /t 5 >nul
    exit /b 1
)

z_backup-once.bat "%~1" l