@echo off
echo ========================================
echo Quick Build and Install
echo ========================================

REM Build the plugin
echo.
echo Building plugin...
call mvn clean package -DskipTests -q
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)
echo Build successful!

REM Install to local Spark
echo.
echo Installing to Spark...
set SPARK_PLUGINS=%APPDATA%\Spark\plugins

REM Clean old installation
if exist "%SPARK_PLUGINS%\email" (
    echo Removing old plugin...
    rmdir /S /Q "%SPARK_PLUGINS%\email" 2>nul
)

REM Create plugin structure
mkdir "%SPARK_PLUGINS%\email" 2>nul
mkdir "%SPARK_PLUGINS%\email\lib" 2>nul

REM Copy files
copy /Y plugin.xml "%SPARK_PLUGINS%\email\plugin.xml" >nul
copy /Y target\email-plugin-1.0.0-jar-with-dependencies.jar "%SPARK_PLUGINS%\email\lib\plugin-classes.jar" >nul

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Plugin installed to:
echo %SPARK_PLUGINS%\email
echo.
echo Next steps:
echo 1. Restart Spark
echo 2. Go to File ^> Preferences ^> Email Integration
echo 3. Configure your email settings
echo.
pause
