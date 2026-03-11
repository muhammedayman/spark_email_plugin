@echo off
REM Quick build for your specific Spark installation
REM Edit the SPARK_JAR variable below to match your installation

echo =========================================
echo Quick Build Script
echo =========================================
echo.

REM EDIT THIS LINE - Set your Spark JAR path
set "SPARK_JAR=C:\Program Files (x86)\Spark\lib\spark.jar"

REM Check if file exists
if not exist "%SPARK_JAR%" (
    echo ERROR: Spark JAR not found at: %SPARK_JAR%
    echo.
    echo Please edit BUILD_NOW.bat and set the correct path on line 8
    echo.
    echo Example:
    echo   set "SPARK_JAR=C:\Program Files (x86)\Spark\lib\spark.jar"
    echo.
    pause
    exit /b 1
)

echo Found Spark JAR: %SPARK_JAR%
echo.

echo Step 1: Installing Spark JAR to Maven...
call mvn install:install-file "-Dfile=%SPARK_JAR%" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install Spark JAR
    pause
    exit /b 1
)

echo.
echo Step 2: Building plugin...
call mvn clean package

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =========================================
    echo BUILD SUCCESSFUL!
    echo =========================================
    echo.
    echo Plugin created: target\email-plugin-1.0.0-jar-with-dependencies.jar
    echo.
    echo Next steps:
    echo 1. Copy target\email-plugin-1.0.0-jar-with-dependencies.jar to %APPDATA%\Spark\plugins\
    echo 2. Copy plugin.xml to %APPDATA%\Spark\plugins\
    echo 3. Restart Spark
    echo.
) else (
    echo.
    echo BUILD FAILED - Check errors above
)

pause
