@echo off
echo ========================================
echo Plugin Diagnostic Tool
echo ========================================

set PLUGINS_DIR=%APPDATA%\Spark\plugins\email-plugin
set LOGS_DIR=%APPDATA%\Spark\logs

echo.
echo Checking plugin installation...
echo.

if exist "%PLUGINS_DIR%" (
    echo [OK] Plugin folder exists: %PLUGINS_DIR%
    echo.
    echo Contents:
    dir /B "%PLUGINS_DIR%"
    if exist "%PLUGINS_DIR%\lib" (
        echo.
        echo Lib folder contents:
        dir /B "%PLUGINS_DIR%\lib"
    )
) else (
    echo [WARNING] Plugin folder does not exist!
    echo This means Spark deleted it due to an error.
)

echo.
echo ========================================
echo Checking Spark logs for errors...
echo ========================================
echo.

if exist "%LOGS_DIR%" (
    echo Log directory: %LOGS_DIR%
    echo.
    
    REM Check for error log
    if exist "%LOGS_DIR%\error.log" (
        echo === ERROR.LOG (last 30 lines) ===
        powershell -Command "Get-Content '%LOGS_DIR%\error.log' -Tail 30"
        echo.
    )
    
    REM Check for spark log
    if exist "%LOGS_DIR%\spark.log" (
        echo === SPARK.LOG (searching for 'email' or 'plugin') ===
        findstr /I /C:"email" /C:"plugin" /C:"EmailPlugin" "%LOGS_DIR%\spark.log" 2>nul
        echo.
    )
    
    REM Check for debug log
    if exist "%LOGS_DIR%\debug.log" (
        echo === DEBUG.LOG (searching for 'email' or 'plugin') ===
        findstr /I /C:"email" /C:"plugin" /C:"EmailPlugin" "%LOGS_DIR%\debug.log" 2>nul
        echo.
    )
) else (
    echo [WARNING] Logs directory not found: %LOGS_DIR%
)

echo.
echo ========================================
echo Checking JAR contents...
echo ========================================
echo.

if exist "target\email-plugin-1.0.0-jar-with-dependencies.jar" (
    echo Checking if EmailPlugin class is in JAR...
    jar tf "target\email-plugin-1.0.0-jar-with-dependencies.jar" | findstr EmailPlugin
    echo.
    echo Checking MANIFEST.MF...
    jar xf "target\email-plugin-1.0.0-jar-with-dependencies.jar" META-INF/MANIFEST.MF
    type META-INF\MANIFEST.MF
    del META-INF\MANIFEST.MF
    rmdir META-INF
) else (
    echo [ERROR] JAR file not found!
)

echo.
echo ========================================
echo Diagnostic complete!
echo ========================================
pause
