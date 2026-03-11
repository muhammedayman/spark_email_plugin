# Spark Email Integration Plugin - Installation

## Quick Install

1. Close Spark completely
2. Copy the entire `email` folder to your Spark plugins directory:
   - Windows: `%APPDATA%\Spark\plugins\`
   - Linux: `~/.Spark/plugins/`
   - Mac: `~/Library/Application Support/Spark/plugins/`
3. Restart Spark
4. Go to File > Preferences > Email Integration
5. Configure your email settings
6. Enable the plugin

## Configuration

### Required Settings:
- Email Host: Your SMTP server (e.g., smtp.gmail.com)
- Port: Usually 587 for TLS or 465 for SSL
- Username: Your email address
- Password: Your email password or app password
- Recipient Email: Where to send chat messages
- Enable SSL/TLS: Check this for secure connection

### Gmail Users:
If using Gmail, you need to:
1. Enable 2-factor authentication
2. Generate an App Password at: https://myaccount.google.com/apppasswords
3. Use the App Password in the plugin settings

## Features

- Automatically forwards all sent and received chat messages to email
- Email threading: Messages from the same chat appear as a conversation
- Test email button to verify configuration
- Works with Gmail, Outlook, and other SMTP servers

## Troubleshooting

If the plugin doesn't appear:
1. Make sure the folder structure is correct:
   ```
   plugins/
     email/
       plugin.xml
       lib/
         plugin-classes.jar
   ```
2. Check Spark logs at `%APPDATA%\Spark\logs\warn.log`
3. Ensure Spark version is 2.5.0 or higher

## Version

Version: 1.0.0
Build Date: 11-03-2026 10:10:42.04
