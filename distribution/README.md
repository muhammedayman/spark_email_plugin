# Spark Email Integration Plugin - Distribution Package

This folder contains the ready-to-use distribution of the Spark Email Integration Plugin.

## Download & Install

### Quick Install

1. **Download**: Get `spark-email-plugin.zip`
2. **Extract**: Unzip the file
3. **Install**: 
   - Windows: Run `install-windows.bat`
   - Linux/Mac: Run `install-linux-mac.sh`
4. **Restart Spark**
5. **Configure**: Go to File → Preferences → Email Integration

### Manual Install

If you prefer manual installation:
1. Close Spark completely
2. Copy the `email` folder to:
   - Windows: `%APPDATA%\Spark\plugins\`
   - Linux: `~/.Spark/plugins/`
   - Mac: `~/Library/Application Support/Spark/plugins/`
3. Restart Spark

## What's Included

- `email/` - Complete plugin folder (ready to copy)
- `install-windows.bat` - Automated installer for Windows
- `install-linux-mac.sh` - Automated installer for Linux/Mac
- `spark-email-plugin.zip` - Complete package with all files
- `INSTALL.md` - Detailed installation instructions

## Features

- Forwards all chat messages to email automatically
- Email threading (messages from same chat appear as conversation)
- Test email button to verify configuration
- Works with Gmail, Outlook, and other SMTP servers
- Real-time status tracking

## Configuration

After installation:
1. Open Spark → File → Preferences → Email Integration
2. Configure SMTP settings:
   - Host: smtp.gmail.com (or your SMTP server)
   - Port: 587 (for TLS)
   - Username: your-email@gmail.com
   - Password: your app password
   - Recipient: where to send messages
   - Enable SSL/TLS: ✓
3. Click "Test Email" to verify
4. Enable the plugin

### Gmail Setup

For Gmail users:
1. Enable 2-factor authentication
2. Generate App Password: https://myaccount.google.com/apppasswords
3. Use the App Password (not your regular password)

## Requirements

- Spark IM Client 2.5.0 or higher
- Java 8 or higher
- Valid SMTP server credentials

## Troubleshooting

See `INSTALL.md` for detailed troubleshooting steps.

Quick checks:
- Verify folder structure: `plugins/email/plugin.xml` and `plugins/email/lib/plugin-classes.jar`
- Check Spark logs: `%APPDATA%\Spark\logs\warn.log`
- Use "Test Email" button to verify configuration

## Version

Version: 1.0.0

## Support

For issues or questions, check the main project README or Spark logs for error details.
