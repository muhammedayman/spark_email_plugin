@echo off
echo Building minimal test plugin...
mvn clean package

echo.
echo Cleaning up old plugin...
if exist "%APPDATA%\Spark\plugins\email" rmdir /S /Q "%APPDATA%\Spark\plugins\email"

echo.
echo Installing minimal plugin...
set PLUGIN_DIR=%APPDATA%\Spark\plugins\email
mkdir "%PLUGIN_DIR%"
mkdir "%PLUGIN_DIR%\lib"

copy /Y plugin-minimal.xml "%PLUGIN_DIR%\plugin.xml"
copy /Y target\email-plugin-1.0.0-jar-with-dependencies.jar "%PLUGIN_DIR%\lib\plugin-classes.jar"

echo.
echo Done! Structure:
dir "%PLUGIN_DIR%" /S

echo.
echo Now restart Spark and check if the folder stays!
pause
