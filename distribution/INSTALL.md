# Installation Instructions

## Quick Install

### Windows
1. Close Spark completely
2. Run `install-windows.bat`
3. Restart Spark
4. Go to File → Preferences → Email Integration

### Linux/Mac
1. Close Spark completely
2. Run `install-linux-mac.sh` (you may need to make it executable: `chmod +x install-linux-mac.sh`)
3. Restart Spark
4. Go to File → Preferences → Email Integration

## Manual Installation

If the installer doesn't work, you can install manually:

1. Close Spark completely
2. Copy the `email` folder to your Spark plugins directory:
   - **Windows**: `%APPDATA%\Spark\plugins\`
   - **Linux**: `~/.Spark/plugins/`
   - **Mac**: `~/Library/Application Support/Spark/plugins/`
3. Restart Spark

## Verify Installation

After restarting Spark:
1. Go to File → Preferences
2. You should see "Email Integration" in the preferences list
3. If not, check the folder structure:
   ```
   plugins/
     email/
       plugin.xml
       lib/
         plugin-classes.jar
   ```

## Configuration

1. Open Spark preferences (File → Preferences)
2. Select "Email Integration"
3. Configure your SMTP settings:
   - Email Host: Your SMTP server (e.g., smtp.gmail.com)
   - Port: Usually 587 for TLS
   - Username: Your email address
   - Password: Your email password or app password
   - Recipient Email: Where to send chat messages
   - Enable SSL/TLS: Check this box
4. Click "Test Email" to verify configuration
5. Check "Enable Email Integration"
6. Click Apply/OK

### Gmail Users

If using Gmail:
1. Enable 2-factor authentication
2. Generate an App Password: https://myaccount.google.com/apppasswords
3. Use the App Password in the plugin settings (not your regular password)

## Troubleshooting

### Plugin doesn't appear in Preferences
- Verify the folder structure is correct
- Check Spark logs: `%APPDATA%\Spark\logs\warn.log` (Windows)
- Ensure Spark version is 2.5.0 or higher

### Email not sending
- Click "Test Email" button to verify configuration
- Check SMTP host, port, and credentials
- Ensure SSL/TLS setting matches your server
- Check firewall isn't blocking SMTP port

## Support

For issues, check:
1. Spark logs at `%APPDATA%\Spark\logs\` (Windows) or `~/.Spark/logs/` (Linux/Mac)
2. Verify email configuration with "Test Email" button
3. Ensure Spark is completely restarted after installation
