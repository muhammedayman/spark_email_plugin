@echo off
REM Build script that uses local Spark installation

echo =========================================
echo Spark Email Plugin Builder (with local Spark)
echo =========================================
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven is not installed or not in PATH
    echo Please install Maven from https://maven.apache.org/
    exit /b 1
)

REM Prompt for Spark installation directory
set SPARK_HOME=%APPDATA%\Spark

echo Looking for Spark installation...
echo Default location: %SPARK_HOME%
echo.

if not exist "%SPARK_HOME%\lib\spark.jar" (
    echo Spark JAR not found at default location.
    echo.
    echo Please enter your Spark installation directory
    echo Example: C:\Program Files ^(x86^)\Spark
    echo.
    set /p "SPARK_HOME=Spark directory: "
)

REM Remove trailing backslash if present
if "%SPARK_HOME:~-1%"=="\" set "SPARK_HOME=%SPARK_HOME:~0,-1%"

if not exist "%SPARK_HOME%\lib\spark.jar" (
    echo ERROR: Could not find spark.jar in "%SPARK_HOME%\lib\"
    echo.
    echo Please ensure Spark is installed and provide the correct path.
    echo The spark.jar file should be in the lib subdirectory.
    echo.
    echo Example paths:
    echo   C:\Program Files ^(x86^)\Spark
    echo   %APPDATA%\Spark
    exit /b 1
)

echo Found Spark at: "%SPARK_HOME%"
echo.

echo Installing Spark JAR to local Maven repository...
set "SPARK_JAR=%SPARK_HOME%\lib\spark.jar"
call mvn install:install-file "-Dfile=%SPARK_JAR%" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install Spark JAR to Maven repository
    exit /b 1
)

echo.
echo Building plugin...
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
    exit /b 1
)

pause
