@echo off
REM Spark Email Plugin Build Script for Windows

echo =========================================
echo Spark Email Integration Plugin Builder
echo =========================================
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven is not installed or not in PATH
    echo Please install Maven from https://maven.apache.org/
    exit /b 1
)

echo Step 1: Cleaning previous builds...
call mvn clean

echo.
echo Step 2: Building plugin...
call mvn package

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =========================================
    echo BUILD SUCCESSFUL!
    echo =========================================
    echo.
    echo Plugin JAR created at:
    echo   target\email-plugin-1.0.0-jar-with-dependencies.jar
    echo.
    echo Installation Instructions:
    echo 1. Copy the JAR file to your Spark plugins directory:
    echo    %%APPDATA%%\Spark\plugins\
    echo.
    echo 2. Copy plugin.xml to the same directory
    echo.
    echo 3. Restart Spark
    echo.
    echo 4. Configure via File - Preferences - Email Integration
    echo.
) else (
    echo.
    echo =========================================
    echo BUILD FAILED!
    echo =========================================
    echo Please check the error messages above
    exit /b 1
)

pause
