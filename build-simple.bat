@echo off
REM Simple build script - just provide the Spark JAR path directly

echo =========================================
echo Spark Email Plugin - Simple Builder
echo =========================================
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven is not installed or not in PATH
    echo Please install Maven from https://maven.apache.org/
    pause
    exit /b 1
)

echo Step 1: Install Spark JAR to Maven
echo.
echo Please provide the FULL path to spark.jar
echo.
echo Common locations:
echo   C:\Program Files (x86)\Spark\lib\spark.jar
echo   %APPDATA%\Spark\lib\spark.jar
echo.

set /p "SPARK_JAR_PATH=Full path to spark.jar: "

REM Remove quotes if present
set "SPARK_JAR_PATH=%SPARK_JAR_PATH:"=%"

if not exist "%SPARK_JAR_PATH%" (
    echo.
    echo ERROR: File not found: %SPARK_JAR_PATH%
    echo.
    echo Please check the path and try again.
    pause
    exit /b 1
)

echo.
echo Installing Spark JAR to Maven repository...
echo File: %SPARK_JAR_PATH%
echo.

call mvn install:install-file "-Dfile=%SPARK_JAR_PATH%" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to install Spark JAR to Maven repository
    pause
    exit /b 1
)

echo.
echo Step 2: Building plugin...
echo.

call mvn clean package

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
    echo 1. Copy the JAR file to: %APPDATA%\Spark\plugins\
    echo 2. Copy plugin.xml to: %APPDATA%\Spark\plugins\
    echo 3. Restart Spark
    echo 4. Configure via File - Preferences - Email Integration
    echo.
) else (
    echo.
    echo =========================================
    echo BUILD FAILED!
    echo =========================================
    echo Please check the error messages above
)

pause
