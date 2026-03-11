@echo off
echo Installing Spark Email Integration Plugin...
echo.
set SPARK_PLUGINS=%APPDATA%\Spark\plugins
if not exist "%SPARK_PLUGINS%" (
    echo Error: Spark plugins directory not found!
    echo Please make sure Spark is installed.
    pause
    exit /b 1
)

echo Copying plugin files...
xcopy /E /I /Y email "%SPARK_PLUGINS%\email"

echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Please restart Spark and go to:
echo File > Preferences > Email Integration
echo.
pause
