# Spark Email Integration Plugin

A plugin for Spark IM client that forwards incoming chat messages to a configured email address with real-time status tracking.

## Features

- **Email Configuration**: Configure SMTP server, username, password, and recipient email
- **Automatic Forwarding**: Automatically forwards received chat messages to email
- **Status Tracking**: Shows email status (Sending, Sent, Failed) next to each message
- **Resend Capability**: Resend failed emails with a single click
- **SSL/TLS Support**: Secure email transmission with SSL/TLS encryption

## Installation

1. **Build the Plugin**:
   ```bash
   mvn clean package
   ```
   This will create `email-plugin-1.0.0-jar-with-dependencies.jar` in the `target` directory.

2. **Install in Spark**:
   - Copy the JAR file to Spark's plugins directory:
     - Windows: `%APPDATA%\Spark\plugins\`
     - Linux: `~/.Spark/plugins/`
     - Mac: `~/Library/Application Support/Spark/plugins/`
   - Copy `plugin.xml` to the same directory
   - Restart Spark

## Configuration

1. Open Spark and go to **File → Preferences**
2. Select **Email Integration** from the preferences list
3. Configure the following settings:

   - **Enable Email Integration**: Check to activate the plugin
   - **Email Host (SMTP)**: Your SMTP server (e.g., smtp.gmail.com)
   - **Port**: SMTP port (usually 587 for TLS, 465 for SSL)
   - **Username**: Your email username
   - **Password**: Your email password
   - **Recipient Email**: Email address to receive chat messages
   - **Enable SSL/TLS**: Check for secure connection

4. Click **Apply** or **OK** to save settings

### Example Configurations

#### Gmail
- Host: `smtp.gmail.com`
- Port: `587`
- Username: `your-email@gmail.com`
- Password: Your app-specific password (not regular password)
- Enable SSL/TLS: ✓

#### Outlook/Office 365
- Host: `smtp.office365.com`
- Port: `587`
- Username: `your-email@outlook.com`
- Password: Your email password
- Enable SSL/TLS: ✓

#### Custom SMTP Server
- Host: Your SMTP server address
- Port: Your SMTP port
- Username: Your SMTP username
- Password: Your SMTP password
- Enable SSL/TLS: As required by your server

## Usage

Once configured, the plugin works automatically:

1. **Receiving Messages**: When you receive a chat message, the plugin:
   - Shows "📧 Sending..." status next to the message
   - Sends the message to the configured email
   - Updates status to "✓ Sent" on success
   - Shows "✗ Failed" with a "Resend" button on failure

2. **Email Format**:
   - **Subject**: "Chat message from: [sender's username]"
   - **Body**: The message content

3. **Resending Failed Emails**:
   - Click the "Resend" button next to any failed message
   - The plugin will attempt to send the email again
   - Status updates in real-time

## Status Indicators

- **📧 Sending...** (Blue): Email is being sent
- **✓ Sent** (Green): Email sent successfully
- **✗ Failed** (Red): Email failed to send (Resend button appears)

## Troubleshooting

### Email Not Sending

1. **Check Configuration**:
   - Verify SMTP host and port are correct
   - Ensure username and password are valid
   - Check if SSL/TLS setting matches your server requirements

2. **Gmail Users**:
   - Enable "Less secure app access" or use App Passwords
   - Generate an app-specific password at: https://myaccount.google.com/apppasswords

3. **Firewall/Network**:
   - Ensure SMTP port is not blocked by firewall
   - Check if your network allows outgoing SMTP connections

4. **Check Logs**:
   - View Spark logs for detailed error messages
   - Logs location:
     - Windows: `%APPDATA%\Spark\logs\`
     - Linux: `~/.Spark/logs/`
     - Mac: `~/Library/Application Support/Spark/logs/`

### Plugin Not Loading

1. Verify JAR file is in the correct plugins directory
2. Ensure `plugin.xml` is in the same directory
3. Check Spark version compatibility (requires Spark 2.5.0+)
4. Restart Spark completely

## Configuration File

Settings are stored in: `~/.spark/email-plugin.properties`

You can manually edit this file if needed:
```properties
enabled=true
host=smtp.gmail.com
port=587
username=your-email@gmail.com
password=your-password
recipient=recipient@example.com
ssl=true
```

## Security Notes

- Passwords are stored in plain text in the configuration file
- Use app-specific passwords when possible (especially for Gmail)
- Ensure proper file permissions on the configuration file
- Consider using a dedicated email account for this plugin

## Requirements

- Spark IM Client 2.5.0 or higher
- Java 8 or higher
- Active internet connection
- Valid SMTP server credentials

## Development

### Project Structure
```
email-plugin/
├── src/main/java/org/jivesoftware/spark/plugin/email/
│   ├── EmailPlugin.java                    # Main plugin class
│   ├── EmailPreference.java                # Preferences UI
│   ├── EmailMessageListener.java           # Message listener
│   ├── EnhancedEmailMessageListener.java   # Enhanced listener with UI
│   ├── EmailSender.java                    # Email sending logic
│   └── EmailStatusPanel.java               # Status UI component
├── pom.xml                                  # Maven build file
├── plugin.xml                               # Plugin descriptor
└── README.md                                # This file
```

### Building from Source
```bash
# Clone or download the source
cd email-plugin

# Build with Maven
mvn clean package

# Output: target/email-plugin-1.0.0-jar-with-dependencies.jar
```

## License

This plugin is provided as-is for use with Spark IM client.

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Spark logs for error details
3. Verify your email server configuration

## Version History

- **1.0.0** (Initial Release)
  - Email configuration interface
  - Automatic message forwarding
  - Real-time status tracking
  - Resend failed emails
  - SSL/TLS support
