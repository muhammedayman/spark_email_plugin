@echo off
echo ========================================
echo Rebuild and Create Distribution
echo ========================================

REM Step 1: Clean and build
echo.
echo Step 1: Building plugin...
call mvn clean package -DskipTests -q
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)
echo Build successful!

REM Step 2: Install to local Spark
echo.
echo Step 2: Installing to local Spark...
set SPARK_PLUGINS=%APPDATA%\Spark\plugins

REM Clean old installation
if exist "%SPARK_PLUGINS%\email" (
    echo Removing old plugin installation...
    rmdir /S /Q "%SPARK_PLUGINS%\email"
)

REM Create plugin structure
echo Creating plugin structure...
mkdir "%SPARK_PLUGINS%\email"
mkdir "%SPARK_PLUGINS%\email\lib"

REM Copy files
echo Copying plugin files...
copy /Y plugin.xml "%SPARK_PLUGINS%\email\plugin.xml"
copy /Y target\email-plugin-1.0.0-jar-with-dependencies.jar "%SPARK_PLUGINS%\email\lib\plugin-classes.jar"

echo Plugin installed to: %SPARK_PLUGINS%\email

REM Step 3: Create distribution
echo.
echo Step 3: Creating distribution package...
set DIST_DIR=distribution\email

REM Clean old distribution
if exist distribution (
    rmdir /S /Q distribution
)

REM Create distribution structure
mkdir "%DIST_DIR%"
mkdir "%DIST_DIR%\lib"

REM Copy plugin files to distribution
copy /Y plugin.xml "%DIST_DIR%\plugin.xml"
copy /Y target\email-plugin-1.0.0-jar-with-dependencies.jar "%DIST_DIR%\lib\plugin-classes.jar"

REM Create distribution README
(
echo # Spark Email Integration Plugin - Installation
echo.
echo ## Quick Install
echo.
echo 1. Close Spark completely
echo 2. Copy the entire `email` folder to your Spark plugins directory:
echo    - Windows: `%%APPDATA%%\Spark\plugins\`
echo    - Linux: `~/.Spark/plugins/`
echo    - Mac: `~/Library/Application Support/Spark/plugins/`
echo 3. Restart Spark
echo 4. Go to File ^> Preferences ^> Email Integration
echo 5. Configure your email settings
echo 6. Enable the plugin
echo.
echo ## Configuration
echo.
echo ### Required Settings:
echo - Email Host: Your SMTP server ^(e.g., smtp.gmail.com^)
echo - Port: Usually 587 for TLS or 465 for SSL
echo - Username: Your email address
echo - Password: Your email password or app password
echo - Recipient Email: Where to send chat messages
echo - Enable SSL/TLS: Check this for secure connection
echo.
echo ### Gmail Users:
echo If using Gmail, you need to:
echo 1. Enable 2-factor authentication
echo 2. Generate an App Password at: https://myaccount.google.com/apppasswords
echo 3. Use the App Password in the plugin settings
echo.
echo ## Features
echo.
echo - Automatically forwards all sent and received chat messages to email
echo - Email threading: Messages from the same chat appear as a conversation
echo - Test email button to verify configuration
echo - Works with Gmail, Outlook, and other SMTP servers
echo.
echo ## Troubleshooting
echo.
echo If the plugin doesn't appear:
echo 1. Make sure the folder structure is correct:
echo    ```
echo    plugins/
echo      email/
echo        plugin.xml
echo        lib/
echo          plugin-classes.jar
echo    ```
echo 2. Check Spark logs at `%%APPDATA%%\Spark\logs\warn.log`
echo 3. Ensure Spark version is 2.5.0 or higher
echo.
echo ## Version
echo.
echo Version: 1.0.0
echo Build Date: %date% %time%
) > "%DIST_DIR%\README.md"

REM Create Windows installer
(
echo @echo off
echo echo Installing Spark Email Integration Plugin...
echo echo.
echo set SPARK_PLUGINS=%%APPDATA%%\Spark\plugins
echo if not exist "%%SPARK_PLUGINS%%" ^(
echo     echo Error: Spark plugins directory not found!
echo     echo Please make sure Spark is installed.
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo Copying plugin files...
echo xcopy /E /I /Y email "%%SPARK_PLUGINS%%\email"
echo.
echo echo ========================================
echo echo Installation Complete!
echo echo ========================================
echo echo.
echo echo Please restart Spark and go to:
echo echo File ^> Preferences ^> Email Integration
echo echo.
echo pause
) > "distribution\install-windows.bat"

REM Create Linux/Mac installer
(
echo #!/bin/bash
echo echo "Installing Spark Email Integration Plugin..."
echo echo ""
echo.
echo # Determine Spark plugins directory
echo if [ "$(uname)" == "Darwin" ]; then
echo     SPARK_PLUGINS="$HOME/Library/Application Support/Spark/plugins"
echo else
echo     SPARK_PLUGINS="$HOME/.Spark/plugins"
echo fi
echo.
echo if [ ! -d "$SPARK_PLUGINS" ]; then
echo     echo "Error: Spark plugins directory not found!"
echo     echo "Please make sure Spark is installed."
echo     exit 1
echo fi
echo.
echo echo "Copying plugin files..."
echo cp -r email "$SPARK_PLUGINS/"
echo.
echo echo "========================================"
echo echo "Installation Complete!"
echo echo "========================================"
echo echo ""
echo echo "Please restart Spark and go to:"
echo echo "File > Preferences > Email Integration"
echo echo ""
) > "distribution\install-linux-mac.sh"

REM Create ZIP archive
echo.
echo Creating ZIP archive...
powershell -Command "Compress-Archive -Path 'distribution\email', 'distribution\install-windows.bat', 'distribution\install-linux-mac.sh' -DestinationPath 'distribution\spark-email-plugin.zip' -Force" 2>nul

echo.
echo ========================================
echo SUCCESS!
echo ========================================
echo.
echo Plugin installed to local Spark:
echo   %SPARK_PLUGINS%\email
echo.
echo Distribution package created:
echo   %CD%\distribution\
echo.
echo Contents:
echo   - email\                  (Plugin folder - ready to copy)
echo   - install-windows.bat     (Windows installer)
echo   - install-linux-mac.sh    (Linux/Mac installer)
echo   - spark-email-plugin.zip  (Complete package)
echo.
echo Next steps:
echo   1. Restart Spark to load the plugin
echo   2. Go to File ^> Preferences ^> Email Integration
echo   3. Configure your email settings
echo.
echo For GitHub users:
echo   - Commit the 'distribution' folder to your repository
echo   - Users can download and run install scripts
echo.
pause
