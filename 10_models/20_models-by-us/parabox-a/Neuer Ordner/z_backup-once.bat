@echo off

:: Origin: https://github.com/sejnub/small-apps/tree/master/z_backup

setlocal EnableDelayedExpansion

:: Debug setting (set to "true" for debug output)
set "DEBUG=false"

:: Define the origin file name
set "origin=dummy.txt"

:: Get command line parameter
set "param=%~1"

:: Initialize last size
set "last_size=0"

goto :init

:init
:: Enable debug output
if "%DEBUG%"=="true" (
    echo Debug: Current directory is %CD%
    echo Debug: Looking for file %origin%
    if exist "%origin%" (
        echo Debug: File exists
        echo Debug: Full path is "%CD%\%origin%"
    ) else (
        echo Debug: File does not exist
    )
) else (
    if not exist "%origin%" (
        echo Error: File "%origin%" not found
        exit /b 1
    )
)

:: ========================================================================
:: File Backup Script
:: ========================================================================
:: Description:
::   Creates a timestamped copy of a specified file. The new filename will be
::   in the format: basename.YYYY-MM-DD_HHMM.extension
::   
::   When called with parameter 'l' or 'L', runs in loop mode to watch for
::   changes. In loop mode, backups are automatically zipped and only the
::   ZIP archives are kept.
::
:: Usage:
::   1. Set the "origin" variable below to your target file
::   2. Run the script
::   3. Optional: Use 'l' or 'L' parameter for loop mode
::      Example: z_backup-origin.bat l
::
:: Example output:
::   If origin = "parabox-a.FCStd"
::   Normal mode: parabox-a.2024-03-19_1430.FCStd
::   Loop mode:   parabox-a.2024-03-19_1430.FCStd.zip
::
:: Requirements:
::   - Windows OS with wmic command available
::   - Write permissions in the current directory
:: ========================================================================

:: Main script logic
if /I "%param%"=="l" (
    goto :watch_mode
) else (
    goto :single_backup
)

:watch_mode
echo Starting watch mode. Press Q to exit.

:: Make initial backup
call :perform_backup
echo Watching for changes in %origin%

:: Store initial timestamp and size
if "%DEBUG%"=="true" echo Debug: Starting initial timestamp check
for %%A in ("%origin%") do (
    if "%DEBUG%"=="true" echo Debug: Getting file attributes
    set "last_modified=%%~tA"
    set "last_size=%%~zA"
    if "%DEBUG%"=="true" (
        echo Debug: Got timestamp
        echo Debug: Initial timestamp is !last_modified!
        echo Debug: Initial size is !last_size!
        echo Debug: Getting full path
        set "full_path=%%~fA"
        echo Debug: Full path is "!full_path!"
        echo Debug: Initial checks complete
    )
)
if "%DEBUG%"=="true" (
    echo Debug: Timestamp block complete
    echo Debug: Starting main loop
)
goto :watch_loop

:watch_loop
if "%DEBUG%"=="true" echo Debug: Loop iteration start

<nul set /p =.

:: Wait for a short time, checking for 'Q' key
if "%DEBUG%"=="true" echo Debug: Starting wait cycle
choice /c qn /t 1 /d n /n > nul
if errorlevel 1 if not errorlevel 2 goto :end_script
if "%DEBUG%"=="true" echo Debug: Wait cycle completed

:: Check if file still exists
if "%DEBUG%"=="true" echo Debug: Checking if file exists
if not exist "%origin%" (
    echo Error: File "%origin%" no longer exists. Exiting watch mode...
    goto :end_script
)
if "%DEBUG%"=="true" echo Debug: File check completed

:: Check current timestamp and size
if "%DEBUG%"=="true" echo Debug: Getting current timestamp and size
for %%A in ("%origin%") do (
    set "current_modified=%%~tA"
    set "current_size=%%~zA"
    if "%DEBUG%"=="true" (
        echo Debug: Current timestamp is !current_modified!
        echo Debug: Current size is !current_size!
    )
)

:: Compare timestamps and sizes
if "%DEBUG%"=="true" echo Debug: Comparing timestamps and sizes
set "changed=0"
set "change_type="
if not "!last_modified!"=="!current_modified!" (
    set "changed=1"
    set "change_type=datetime"
)
if not "!last_size!"=="!current_size!" (
    set "changed=1"
    if defined change_type (
        set "change_type=datetime and size"
    ) else (
        set "change_type=size"
    )
)

if "!changed!"=="1" (
    echo.
    echo Change detected in %origin% [!change_type!]
    call :perform_backup
    for %%A in ("%origin%") do (
        set "last_modified=%%~tA"
        set "last_size=%%~zA"
    )
    echo Watching for changes in %origin%. Press Q to exit
)
if "%DEBUG%"=="true" (
    echo Debug: Comparison completed
    echo Debug: Loop iteration end
)

goto :watch_loop

:single_backup
call :perform_backup
goto :end_script

:perform_backup
:: Store loop mode status
set "is_loop_mode=0"
if /I "%param%"=="l" set "is_loop_mode=1"

:: Check if file exists
if not exist "%origin%" (
    echo Error: File "%origin%" not found
    exit /b 1
)

:: Get file's last modified date/time
if "%DEBUG%"=="true" echo Debug: Getting file's last modified timestamp
for %%A in ("%origin%") do (
    set "file_date=%%~tA"
    if "%DEBUG%"=="true" echo Debug: Raw file date is "!file_date!"
)

:: Parse YYYY-MM-DD HH:MM format
if "%DEBUG%"=="true" echo Debug: Attempting to parse date/time
set "formatted_date="
for /f "tokens=1,2 delims= " %%a in ("!file_date!") do (
    set "datePart=%%a"
    set "timePart=%%b"
    if "%DEBUG%"=="true" echo Debug: Date part: !datePart! Time part: !timePart!
)
for /f "tokens=1-3 delims=-" %%a in ("!datePart!") do (
    set "year=%%a"
    set "month=%%b"
    set "day=%%c"
)
for /f "tokens=1,2 delims=:" %%a in ("!timePart!") do (
    set "hour=%%a"
    set "minute=%%b"
    :: Remove any trailing characters from minute
    set "minute=!minute:~0,2!"
    :: Add leading zeros if needed for time only
    if !hour! lss 10 set "hour=0!hour!"
    if !minute! lss 10 set "minute=0!minute!"
    if "%DEBUG%"=="true" (
        echo Debug: Hour: !hour! Minute: !minute!
    )
)

set "formatted_date=!year!-!month!-!day!_!hour!!minute!"
if "%DEBUG%"=="true" echo Debug: Formatted date is "!formatted_date!"

:: Split filename and extension
if "%DEBUG%"=="true" echo Debug: Splitting filename
for %%F in ("%origin%") do (
    set "basename=%%~nF"
    set "extension=%%~xF"
    if "%DEBUG%"=="true" (
        echo Debug: Basename is !basename!
        echo Debug: Extension is !extension!
        echo Debug: Full path is "%%~fF"
    )
)

:: Create the new filename with timestamp, preserving extension
set "new_filename=%basename%.%formatted_date%%extension%"
if "%DEBUG%"=="true" (
    echo Debug: New filename will be "%new_filename%"
    echo Debug: Will create file in directory "%CD%"
)

:: Check if target file exists
if exist "%new_filename%" (
    echo Note: Existing file will be overwritten: %new_filename%
)

:: Copy the file
if "%DEBUG%"=="true" echo Debug: Attempting to copy "%CD%\%origin%" to "%CD%\%new_filename%"
copy "%origin%" "%new_filename%" 1>nul
if errorlevel 1 (
    echo Error copying the file
    if "%DEBUG%"=="true" echo Debug: Copy command failed with errorlevel %errorlevel%
    exit /b 1
) else (
    echo File copied successfully to: %new_filename%
)

:: Only create ZIP archive in loop mode
if "!is_loop_mode!"=="1" (
    if "%DEBUG%"=="true" (
        echo Debug: Creating ZIP archive
        echo Debug: Source file for ZIP: "%CD%\%new_filename%"
        echo Debug: Target ZIP file: "%CD%\%new_filename%.zip"
    )
    
    :: Check if ZIP file exists
    if exist "%new_filename%.zip" (
        echo Note: Existing ZIP file will be overwritten: %new_filename%.zip
    )
    
    1>nul 2>nul powershell -Command "Write-Host 'Debug: PowerShell starting compression'; $ErrorActionPreference = 'Continue'; Try { Compress-Archive -Path '%CD%\%new_filename%' -DestinationPath '%CD%\%new_filename%.zip' -Force; Write-Host 'Debug: Compression completed successfully' } Catch { Write-Host 'Debug: PowerShell error: ' $_.Exception.Message }"
    if errorlevel 1 (
        echo Error creating ZIP archive
        if "%DEBUG%"=="true" echo Debug: ZIP creation failed with errorlevel %errorlevel%
    ) else (
        echo ZIP archive created: %new_filename%.zip
        :: Delete the backup file after successful ZIP creation
        if "%DEBUG%"=="true" echo Debug: Attempting to delete "%CD%\%new_filename%"
        del "%new_filename%" 1>nul 2>nul
        if errorlevel 1 (
            if "%DEBUG%"=="true" echo Debug: Delete failed with errorlevel %errorlevel%
        ) else (
            echo Deleted intermediate backup file: %new_filename%
        )
    )
)
exit /b 0

:end_script
endlocal
exit /b 0 