@echo off
echo Checking plugin status after Spark start...
echo.

if exist "%APPDATA%\Spark\plugins\email" (
    echo [OK] Plugin folder still exists!
    echo.
    dir "%APPDATA%\Spark\plugins\email\lib"
) else (
    echo [ERROR] Plugin folder was deleted by Spark!
    echo.
    echo Checking recent errors...
    powershell -Command "Get-Content '%APPDATA%\Spark\logs\errors.log' -Tail 20"
)

pause
