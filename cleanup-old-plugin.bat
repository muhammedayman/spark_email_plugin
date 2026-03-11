@echo off
echo ========================================
echo Cleaning up old plugin files
echo ========================================

set PLUGINS_DIR=%APPDATA%\Spark\plugins

echo.
echo Removing old plugin files from: %PLUGINS_DIR%
echo.

REM Remove old JAR files
if exist "%PLUGINS_DIR%\email-plugin-1.0.0-jar-with-dependencies.jar" (
    del /F "%PLUGINS_DIR%\email-plugin-1.0.0-jar-with-dependencies.jar"
    echo [OK] Removed old JAR file
)

if exist "%PLUGINS_DIR%\email-plugin.jar" (
    del /F "%PLUGINS_DIR%\email-plugin.jar"
    echo [OK] Removed email-plugin.jar
)

if exist "%PLUGINS_DIR%\email.jar" (
    del /F "%PLUGINS_DIR%\email.jar"
    echo [OK] Removed email.jar
)

REM Remove old plugin.xml if it exists directly in plugins folder
if exist "%PLUGINS_DIR%\plugin.xml" (
    del /F "%PLUGINS_DIR%\plugin.xml"
    echo [OK] Removed old plugin.xml
)

REM Remove old email-plugin folder if it exists
if exist "%PLUGINS_DIR%\email-plugin" (
    rmdir /S /Q "%PLUGINS_DIR%\email-plugin"
    echo [OK] Removed old email-plugin folder
)

echo.
echo ========================================
echo Cleanup complete!
echo ========================================
echo.
echo Now run: setup-plugin-structure.bat
echo.
pause
