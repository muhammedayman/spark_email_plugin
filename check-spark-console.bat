@echo off
echo Checking Spark console output...
echo.
echo Look for these messages in Spark console:
echo - "Email Integration Plugin - Preferences loaded"
echo - "Email Integration Plugin initialized - listening for messages!"
echo.
echo If you see "Could not register message listener", the plugin
echo is working but can't intercept messages automatically.
echo.
echo Check Spark's console window or logs at:
echo %APPDATA%\Spark\logs\
echo.
pause
