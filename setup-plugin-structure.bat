@echo off
echo ========================================
echo Setting up Spark Plugin Structure
echo ========================================

set PLUGIN_DIR=%APPDATA%\Spark\plugins\email
set LIB_DIR=%PLUGIN_DIR%\lib

echo.
echo Creating plugin directory structure...
if not exist "%PLUGIN_DIR%" mkdir "%PLUGIN_DIR%"
if not exist "%LIB_DIR%" mkdir "%LIB_DIR%"

echo.
echo Copying plugin files...

REM Copy plugin.xml to plugin root
if exist "plugin.xml" (
    copy /Y "plugin.xml" "%PLUGIN_DIR%\"
    echo [OK] Copied plugin.xml
) else (
    echo [ERROR] plugin.xml not found in current directory
    goto :error
)

REM Copy JAR to lib folder
if exist "target\email-plugin-1.0.0-jar-with-dependencies.jar" (
    copy /Y "target\email-plugin-1.0.0-jar-with-dependencies.jar" "%LIB_DIR%\plugin-classes.jar"
    echo [OK] Copied JAR to lib folder
) else (
    echo [ERROR] JAR file not found. Please build the project first with: mvn clean package
    goto :error
)

echo.
echo ========================================
echo Plugin structure created successfully!
echo ========================================
echo.
echo Plugin location: %PLUGIN_DIR%
echo.
echo Structure:
echo   email\
echo   ├── plugin.xml
echo   └── lib\
echo       └── plugin-classes.jar
echo.
echo Next steps:
echo 1. Close Spark completely (check Task Manager)
echo 2. Restart Spark
echo 3. Go to File ^> Preferences
echo 4. Look for "Email Integration" in the preferences list
echo.
pause
exit /b 0

:error
echo.
echo ========================================
echo Setup failed! Please check errors above.
echo ========================================
pause
exit /b 1
