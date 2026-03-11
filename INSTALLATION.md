# Installation and Deployment Guide

## Prerequisites

Before installing the Spark Email Plugin, ensure you have:

1. **Spark IM Client** (version 2.5.0 or higher)
   - Download from: https://www.igniterealtime.org/downloads/

2. **Java Development Kit** (JDK 8 or higher) - for building
   - Download from: https://adoptium.net/

3. **Apache Maven** (3.x) - for building
   - Download from: https://maven.apache.org/download.cgi

4. **SMTP Email Account** with credentials
   - Gmail, Outlook, or any SMTP server

## Installation Methods

### Method 1: Build from Source (Recommended)

#### Windows

1. **Setup the project structure**:
   ```cmd
   setup-structure.bat
   ```

2. **Build the plugin**:
   ```cmd
   build.bat
   ```

3. **Install the plugin**:
   ```cmd
   copy target\email-plugin-1.0.0-jar-with-dependencies.jar %APPDATA%\Spark\plugins\
   copy plugin.xml %APPDATA%\Spark\plugins\
   ```

4. **Restart Spark**

#### Linux/Mac

1. **Setup the project structure**:
   ```bash
   chmod +x setup-structure.sh
   ./setup-structure.sh
   ```

2. **Build the plugin**:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

3. **Install the plugin**:
   ```bash
   # Linux
   cp target/email-plugin-1.0.0-jar-with-dependencies.jar ~/.Spark/plugins/
   cp plugin.xml ~/.Spark/plugins/
   
   # Mac
   cp target/email-plugin-1.0.0-jar-with-dependencies.jar ~/Library/Application\ Support/Spark/plugins/
   cp plugin.xml ~/Library/Application\ Support/Spark/plugins/
   ```

4. **Restart Spark**

### Method 2: Manual Build with Maven

```bash
# 1. Create directory structure
mkdir -p src/main/java/org/jivesoftware/spark/plugin/email

# 2. Move source files
mv *.java src/main/java/org/jivesoftware/spark/plugin/email/

# 3. Build
mvn clean package

# 4. Install (see Method 1 step 3)
```

## Configuration

### Step 1: Open Preferences

1. Launch Spark
2. Go to **File → Preferences** (or **Spark → Preferences** on Mac)
3. Look for **Email Integration** in the left panel

### Step 2: Configure Email Settings

#### For Gmail

```
✓ Enable Email Integration
Email Host (SMTP): smtp.gmail.com
Port: 587
Username: your-email@gmail.com
Password: [your app password - see below]
Recipient Email: recipient@example.com
✓ Enable SSL/TLS
```

**Gmail App Password Setup**:
1. Go to https://myaccount.google.com/security
2. Enable 2-Step Verification
3. Go to https://myaccount.google.com/apppasswords
4. Select "Mail" and your device
5. Generate and copy the 16-character password
6. Use this password in the plugin

#### For Outlook/Office 365

```
✓ Enable Email Integration
Email Host (SMTP): smtp.office365.com
Port: 587
Username: your-email@outlook.com
Password: [your email password]
Recipient Email: recipient@example.com
✓ Enable SSL/TLS
```

#### For Yahoo Mail

```
✓ Enable Email Integration
Email Host (SMTP): smtp.mail.yahoo.com
Port: 587
Username: your-email@yahoo.com
Password: [your app password]
Recipient Email: recipient@example.com
✓ Enable SSL/TLS
```

#### For Custom SMTP Server

```
✓ Enable Email Integration
Email Host (SMTP): [your SMTP server]
Port: [your SMTP port - usually 587 or 465]
Username: [your SMTP username]
Password: [your SMTP password]
Recipient Email: recipient@example.com
✓ Enable SSL/TLS [if supported]
```

### Step 3: Test Configuration

1. Click **Apply** or **OK**
2. Have someone send you a test message
3. Check for status indicator next to the message
4. Verify email received at recipient address

## Verification

### Check Plugin is Loaded

1. Open Spark
2. Go to **Help → About Spark**
3. Click **Plugins** tab
4. Look for "Email Integration Plugin" in the list

### Check Configuration File

The configuration is saved to:
- Windows: `%USERPROFILE%\.spark\email-plugin.properties`
- Linux: `~/.spark/email-plugin.properties`
- Mac: `~/.spark/email-plugin.properties`

You can verify the file exists and contains your settings.

### Check Logs

If issues occur, check Spark logs:
- Windows: `%APPDATA%\Spark\logs\`
- Linux: `~/.Spark/logs/`
- Mac: `~/Library/Application Support/Spark/logs/`

Look for lines containing "email" or "EmailPlugin".

## Uninstallation

### Remove Plugin

1. Close Spark completely
2. Delete the plugin files:
   ```
   # Windows
   del %APPDATA%\Spark\plugins\email-plugin-1.0.0-jar-with-dependencies.jar
   del %APPDATA%\Spark\plugins\plugin.xml
   
   # Linux
   rm ~/.Spark/plugins/email-plugin-1.0.0-jar-with-dependencies.jar
   rm ~/.Spark/plugins/plugin.xml
   
   # Mac
   rm ~/Library/Application\ Support/Spark/plugins/email-plugin-1.0.0-jar-with-dependencies.jar
   rm ~/Library/Application\ Support/Spark/plugins/plugin.xml
   ```

3. Restart Spark

### Remove Configuration (Optional)

```
# Windows
del %USERPROFILE%\.spark\email-plugin.properties

# Linux/Mac
rm ~/.spark/email-plugin.properties
```

## Deployment for Multiple Users

### Network Deployment

For deploying to multiple users in an organization:

1. **Build the plugin once**:
   ```bash
   mvn clean package
   ```

2. **Create deployment package**:
   ```
   deployment/
   ├── email-plugin-1.0.0-jar-with-dependencies.jar
   ├── plugin.xml
   ├── example-config.properties
   └── install.bat (or install.sh)
   ```

3. **Create install script**:

   **install.bat** (Windows):
   ```batch
   @echo off
   echo Installing Spark Email Plugin...
   copy email-plugin-1.0.0-jar-with-dependencies.jar %APPDATA%\Spark\plugins\
   copy plugin.xml %APPDATA%\Spark\plugins\
   echo Installation complete!
   echo Please restart Spark and configure via File - Preferences - Email Integration
   pause
   ```

   **install.sh** (Linux/Mac):
   ```bash
   #!/bin/bash
   echo "Installing Spark Email Plugin..."
   cp email-plugin-1.0.0-jar-with-dependencies.jar ~/.Spark/plugins/
   cp plugin.xml ~/.Spark/plugins/
   echo "Installation complete!"
   echo "Please restart Spark and configure via File → Preferences → Email Integration"
   ```

4. **Distribute to users** via:
   - Network share
   - Email attachment
   - Software deployment tool
   - Group Policy (Windows)

### Pre-configured Deployment

To deploy with pre-configured settings:

1. **Create template configuration**:
   ```properties
   # template-config.properties
   enabled=true
   host=smtp.company.com
   port=587
   username=REPLACE_WITH_USERNAME
   password=REPLACE_WITH_PASSWORD
   recipient=it-support@company.com
   ssl=true
   ```

2. **Modify install script** to copy configuration:
   ```batch
   copy template-config.properties %USERPROFILE%\.spark\email-plugin.properties
   ```

3. **Instruct users** to update username/password in preferences

## Troubleshooting Installation

### Plugin Not Appearing

**Problem**: Plugin doesn't show in Preferences

**Solutions**:
1. Verify both JAR and plugin.xml are in plugins directory
2. Check file permissions (should be readable)
3. Restart Spark completely (not just logout)
4. Check Spark version is 2.5.0 or higher
5. Review Spark logs for loading errors

### Build Failures

**Problem**: Maven build fails

**Solutions**:
1. Verify Maven is installed: `mvn --version`
2. Check Java version: `java -version` (need 8+)
3. Ensure internet connection (Maven downloads dependencies)
4. Clear Maven cache: `mvn clean`
5. Check pom.xml is present and valid

### Permission Errors

**Problem**: Cannot copy files to plugins directory

**Solutions**:
1. Run command prompt/terminal as administrator
2. Check directory exists (create if needed)
3. Verify write permissions on plugins directory
4. Close Spark before copying files

### Configuration Not Saving

**Problem**: Settings don't persist after restart

**Solutions**:
1. Check write permissions on ~/.spark directory
2. Verify configuration file is created
3. Check for errors in Spark logs
4. Try manually creating the properties file

## Advanced Installation

### Custom Plugin Directory

To use a custom plugin directory:

1. Edit Spark's startup script
2. Add JVM parameter: `-Dplugins.dir=/path/to/plugins`
3. Copy plugin files to custom directory

### Silent Installation

For automated/silent installation:

```batch
REM Windows silent install
@echo off
copy /Y email-plugin-1.0.0-jar-with-dependencies.jar %APPDATA%\Spark\plugins\ >nul 2>&1
copy /Y plugin.xml %APPDATA%\Spark\plugins\ >nul 2>&1
exit /b 0
```

```bash
# Linux/Mac silent install
#!/bin/bash
cp -f email-plugin-1.0.0-jar-with-dependencies.jar ~/.Spark/plugins/ >/dev/null 2>&1
cp -f plugin.xml ~/.Spark/plugins/ >/dev/null 2>&1
exit 0
```

### Docker/Container Deployment

For containerized Spark deployments:

```dockerfile
FROM spark-base:latest

# Copy plugin files
COPY email-plugin-1.0.0-jar-with-dependencies.jar /opt/spark/plugins/
COPY plugin.xml /opt/spark/plugins/

# Copy default configuration
COPY email-plugin.properties /root/.spark/

# Spark will load plugins on startup
CMD ["/opt/spark/bin/spark"]
```

## Post-Installation

### Verify Installation

Run this checklist:
- [ ] Plugin appears in Help → About → Plugins
- [ ] Email Integration appears in Preferences
- [ ] Configuration can be saved
- [ ] Test message triggers email
- [ ] Status indicator appears
- [ ] Email received successfully

### Initial Testing

1. **Test with yourself**:
   - Set recipient to your own email
   - Send a test message
   - Verify email received

2. **Test status indicators**:
   - Check "Sending..." appears
   - Verify "Sent" on success
   - Test "Failed" by using wrong credentials

3. **Test resend**:
   - Cause a failure (wrong password)
   - Click "Resend" button
   - Fix configuration
   - Verify resend works

### User Training

Provide users with:
1. Quick start guide (QUICKSTART.md)
2. Configuration examples for your email provider
3. Support contact for issues
4. FAQ document

## Support

For installation issues:
1. Check this guide's troubleshooting section
2. Review Spark logs for errors
3. Verify all prerequisites are met
4. Test SMTP settings independently
5. Contact your IT support team

## Updates

To update the plugin:
1. Build new version
2. Stop Spark
3. Replace JAR file in plugins directory
4. Update plugin.xml if changed
5. Restart Spark
6. Configuration is preserved

## Rollback

To rollback to previous version:
1. Stop Spark
2. Replace JAR with previous version
3. Replace plugin.xml with previous version
4. Restart Spark
