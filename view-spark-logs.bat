@echo off
echo ========================================
echo Spark Email Plugin - Log Viewer
echo ========================================
echo.

set LOGS_DIR=%APPDATA%\Spark\logs

if not exist "%LOGS_DIR%" (
    echo [ERROR] Logs directory not found: %LOGS_DIR%
    echo.
    echo Make sure Spark is installed and has been run at least once.
    pause
    exit /b 1
)

echo Log files location: %LOGS_DIR%
echo.
echo Available log files:
dir /B "%LOGS_DIR%\*.log" 2>nul
echo.

:menu
echo ========================================
echo Choose an option:
echo ========================================
echo 1. View recent errors (errors.log)
echo 2. View recent warnings (warn.log)
echo 3. Search for "Email plugin" messages
echo 4. Search for "Email listener" messages
echo 5. Search for "Email Integration" messages
echo 6. View all recent log entries
echo 7. Open logs folder in Explorer
echo 8. Exit
echo.
set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto errors
if "%choice%"=="2" goto warnings
if "%choice%"=="3" goto search_plugin
if "%choice%"=="4" goto search_listener
if "%choice%"=="5" goto search_integration
if "%choice%"=="6" goto all_logs
if "%choice%"=="7" goto open_folder
if "%choice%"=="8" goto end
goto menu

:errors
echo.
echo === RECENT ERRORS (last 30 lines) ===
echo.
powershell -Command "if (Test-Path '%LOGS_DIR%\errors.log') { Get-Content '%LOGS_DIR%\errors.log' -Tail 30 } else { Write-Host 'No errors.log file found' }"
echo.
pause
goto menu

:warnings
echo.
echo === RECENT WARNINGS (last 30 lines) ===
echo.
powershell -Command "if (Test-Path '%LOGS_DIR%\warn.log') { Get-Content '%LOGS_DIR%\warn.log' -Tail 30 } else { Write-Host 'No warn.log file found' }"
echo.
pause
goto menu

:search_plugin
echo.
echo === SEARCHING FOR "Email plugin" ===
echo.
findstr /I /C:"Email plugin" "%LOGS_DIR%\*.log" 2>nul
if errorlevel 1 (
    echo No "Email plugin" messages found in logs.
    echo.
    echo This could mean:
    echo - The plugin hasn't sent any messages yet
    echo - You need to send/receive a chat message first
    echo - The plugin isn't loaded properly
)
echo.
pause
goto menu

:search_listener
echo.
echo === SEARCHING FOR "Email listener" ===
echo.
findstr /I /C:"Email listener" "%LOGS_DIR%\*.log" 2>nul
if errorlevel 1 (
    echo No "Email listener" messages found in logs.
    echo.
    echo This means the plugin hasn't attached to any chat rooms yet.
    echo Try opening a chat window and check again.
)
echo.
pause
goto menu

:search_integration
echo.
echo === SEARCHING FOR "Email Integration" ===
echo.
findstr /I /C:"Email Integration" "%LOGS_DIR%\*.log" 2>nul
if errorlevel 1 (
    echo No "Email Integration" messages found in logs.
    echo.
    echo This could mean the plugin didn't load properly.
    echo Check if the plugin appears in Spark Preferences.
)
echo.
pause
goto menu

:all_logs
echo.
echo === ALL RECENT LOG ENTRIES (last 50 lines) ===
echo.
for %%f in ("%LOGS_DIR%\*.log") do (
    echo.
    echo --- %%~nxf ---
    powershell -Command "Get-Content '%%f' -Tail 20"
)
echo.
pause
goto menu

:open_folder
echo.
echo Opening logs folder...
explorer "%LOGS_DIR%"
goto menu

:end
echo.
echo Exiting...
exit /b 0
