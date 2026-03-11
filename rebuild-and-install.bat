@echo off
echo Building plugin...
call mvn package -DskipTests -q
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo Installing plugin...
copy /Y target\email-plugin-1.0.0-jar-with-dependencies.jar "%APPDATA%\Spark\plugins\email\lib\plugin-classes.jar"

echo.
echo Done! Restart Spark to load the new version.
pause
