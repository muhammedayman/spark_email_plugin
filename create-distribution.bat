@echo off
echo ========================================
echo Creating Distribution Package
echo ========================================

REM Build the plugin
echo.
echo Step 1: Building plugin...
call mvn clean package -DskipTests -q
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

REM Create distribution directory structure
echo.
echo Step 2: Creating distribution folder...
set DIST_DIR=distribution\email
if exist distribution rmdir /S /Q distribution
mkdir "%DIST_DIR%"
mkdir "%DIST_DIR%\lib"

REM Copy plugin files
echo.
echo Step 3: Copying plugin files...
copy /Y plugin.xml "%DIST_DIR%\plugin.xml"
copy /Y target\email-plugin-1.0.0-jar-with-dependencies.jar "%DIST_DIR%\lib\plugin-classes.jar"

REM Create README for distribution
echo.
echo Step 4: Creating installation instructions...
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

REM Create Windows installation script
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

REM Create Linux/Mac installation script
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

REM Make Linux/Mac script executable
echo.
echo Step 5: Setting permissions...
REM Note: This won't work on Windows, but the file will be created

REM Create a ZIP file if 7-zip or PowerShell is available
echo.
echo Step 6: Creating ZIP archive...
powershell -Command "if (Test-Path 'distribution\spark-email-plugin.zip') { Remove-Item 'distribution\spark-email-plugin.zip' }; Compress-Archive -Path 'distribution\email', 'distribution\install-windows.bat', 'distribution\install-linux-mac.sh' -DestinationPath 'distribution\spark-email-plugin.zip'" 2>nul

echo.
echo ========================================
echo Distribution Package Created!
echo ========================================
echo.
echo Location: %CD%\distribution\
echo.
echo Contents:
echo   - email\                  (Plugin folder - ready to copy)
echo   - install-windows.bat     (Windows installer)
echo   - install-linux-mac.sh    (Linux/Mac installer)
echo   - spark-email-plugin.zip  (Complete package)
echo.
echo Users can:
echo 1. Download the ZIP file
echo 2. Extract it
echo 3. Run the install script for their OS
echo    OR manually copy the 'email' folder to Spark plugins directory
echo.
pause
