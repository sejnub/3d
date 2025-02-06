@echo off
setlocal EnableDelayedExpansion

:: Define the origin file name
set "origin=parabox-a.FCStd"

:: ========================================================================
:: File Backup Script
:: ========================================================================
:: Description:
::   Creates a timestamped copy of a specified file. The new filename will be
::   in the format: basename_YYYY-MM-DD_HHMM.extension
::
:: Usage:
::   1. Set the "origin" variable below to your target file
::   2. Run the script
::
:: Example output:
::   If origin = "parabox-a.FCStd"
::   Copy will be = "parabox-a_2024-03-19_1430.FCStd"
::
:: Requirements:
::   - Windows OS with wmic command available
::   - Write permissions in the current directory
:: ========================================================================


:: Check if file exists
if not exist "%origin%" (
    echo Error: File "%origin%" not found
    exit /b 1
)

:: Get current date and time in ISO format (YYYY-MM-DD_HHMM)
for /f "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set "datetime=%%I"
set "formatted_date=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%%datetime:~10,2%"

:: Split filename and extension
for %%F in ("%origin%") do (
    set "basename=%%~nF"
    set "extension=%%~xF"
)

:: Create the new filename with timestamp, preserving extension
set "new_filename=%basename%.%formatted_date%%extension%"

:: Copy the file
copy "%origin%" "%new_filename%"

if errorlevel 1 (
    echo Error copying the file
) else (
    echo File copied successfully to: %new_filename%
)

endlocal 