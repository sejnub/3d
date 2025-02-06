@echo off

:: Origin: https://github.com/sejnub/small-apps/tree/master/z_backup

setlocal EnableDelayedExpansion

:::::::::::::::::::::::::::::::::::
:: Begin of CONSTANT Definitions ::
:::::::::::::::::::::::::::::::::::

:: Debug setting (set to "true" for debug output)
set "DEBUG=false"

:: Define the origin file name
set "origin=dummy.txt"

:: Minimum bytes that must be saved by ZIP compression to keep the ZIP file
:: Example: 1'048'576 or 1,048,576 or 1.048.576 (all mean 1MB)
set "MIN_ZIP_SAVINGS=2'000'000"

:::::::::::::::::::::::::::::::::
:: End of CONSTANT Definitions ::
:::::::::::::::::::::::::::::::::

:: Keep only digits from MIN_ZIP_SAVINGS
set "MIN_ZIP_SAVINGS_CLEAN=!MIN_ZIP_SAVINGS!"
:: Remove all non-digit characters one by one
set "MIN_ZIP_SAVINGS_CLEAN=!MIN_ZIP_SAVINGS_CLEAN:'=!"
set "MIN_ZIP_SAVINGS_CLEAN=!MIN_ZIP_SAVINGS_CLEAN:,=!"
set "MIN_ZIP_SAVINGS_CLEAN=!MIN_ZIP_SAVINGS_CLEAN:.=!"
set "MIN_ZIP_SAVINGS_CLEAN=!MIN_ZIP_SAVINGS_CLEAN: =!"
set "MIN_ZIP_SAVINGS_CLEAN=!MIN_ZIP_SAVINGS_CLEAN:_=!"
set "MIN_ZIP_SAVINGS_CLEAN=!MIN_ZIP_SAVINGS_CLEAN:-=!"

:: Get command line parameter
set "param=%~1"

:: Initialize last size
set "last_size=0"

goto :init

:get_wmic_timestamp
:: Get timestamp using wmic datafile
:: %~1 = file path, returns timestamp in YYYY-MM-DD_HHMMSS format
set "wmic_file=%~f1"
set "wmic_file=!wmic_file:\=\\!"
if "%DEBUG%"=="true" echo Debug: Getting WMIC timestamp for "!wmic_file!"
for /f "skip=1 tokens=2 delims==" %%a in ('wmic datafile where "name='!wmic_file!'" get lastmodified /value') do (
    set "wmic_time=%%a"
    set "year=!wmic_time:~0,4!"
    set "month=!wmic_time:~4,2!"
    set "day=!wmic_time:~6,2!"
    set "hour=!wmic_time:~8,2!"
    set "minute=!wmic_time:~10,2!"
    set "second=!wmic_time:~12,2!"
)
set "formatted_date=!year!-!month!-!day!_!hour!!minute!!second!"
if "%DEBUG%"=="true" echo Debug: WMIC formatted date is "!formatted_date!"
exit /b

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
    call :get_wmic_timestamp "%%~fA"
    set "last_modified=!formatted_date!"
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
    call :get_wmic_timestamp "%%~fA"
    set "current_modified=!formatted_date!"
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
        call :get_wmic_timestamp "%%~fA"
        set "last_modified=!formatted_date!"
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

:: Get file's last modified date/time using wmic
if "%DEBUG%"=="true" echo Debug: Getting file's last modified timestamp
call :get_wmic_timestamp "%CD%\%origin%"

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
        :: Compare file sizes to check if compression saved enough space
        for %%A in ("%new_filename%") do set "original_size=%%~zA"
        for %%A in ("%new_filename%.zip") do set "zip_size=%%~zA"
        set /a "saved_space=original_size-zip_size"
        
        if !saved_space! GEQ !MIN_ZIP_SAVINGS_CLEAN! (
            :: Compression saved significant space, delete the backup file
            if "%DEBUG%"=="true" echo Debug: ZIP saved !saved_space! bytes, keeping ZIP file
            if "%DEBUG%"=="true" echo Debug: Attempting to delete "%CD%\%new_filename%"
            del "%new_filename%" 1>nul 2>nul
            if errorlevel 1 (
                if "%DEBUG%"=="true" echo Debug: Delete failed with errorlevel %errorlevel%
            ) else (
                echo Deleted intermediate backup file: %new_filename%
            )
        ) else (
            :: Compression didn't save enough space, keep original and delete ZIP
            if "%DEBUG%"=="true" echo Debug: ZIP only saved !saved_space! bytes, keeping original file
            del "%new_filename%.zip" 1>nul 2>nul
            echo Keeping uncompressed backup due to insufficient space savings: %new_filename%
        )
    )
)

exit /b 0

:end_script
endlocal
exit /b 0 