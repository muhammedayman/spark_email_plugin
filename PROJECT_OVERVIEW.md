# Spark Email Integration Plugin - Project Overview

## What This Plugin Does

This plugin extends Spark IM client to automatically forward incoming chat messages to a configured email address. It provides real-time visual feedback showing whether each email was sent successfully, is currently sending, or failed to send. Users can retry failed emails with a single click.

## Key Features

1. **Email Configuration UI**: User-friendly preferences panel for SMTP configuration
2. **Automatic Message Forwarding**: Sends received messages to email automatically
3. **Real-time Status Display**: Shows status indicators next to each message
4. **Retry Mechanism**: Resend button appears for failed emails
5. **Secure Communication**: SSL/TLS support for encrypted email transmission

## Architecture

### Component Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      Spark IM Client                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              EmailPlugin (Main)                       │  │
│  │  - Initializes all components                         │  │
│  │  - Registers with Spark managers                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                          │                                   │
│         ┌────────────────┼────────────────┐                 │
│         │                │                │                 │
│  ┌──────▼──────┐  ┌─────▼─────┐  ┌──────▼──────┐          │
│  │  Email      │  │  Enhanced  │  │   Email     │          │
│  │ Preference  │  │  Message   │  │   Sender    │          │
│  │             │  │  Listener  │  │             │          │
│  │ - Config UI │  │ - Monitors │  │ - SMTP      │          │
│  │ - Settings  │  │ - Sends    │  │ - JavaMail  │          │
│  └─────────────┘  └────────────┘  └─────────────┘          │
│                          │                                   │
│                   ┌──────▼──────┐                           │
│                   │   Email     │                           │
│                   │   Status    │                           │
│                   │   Panel     │                           │
│                   │             │                           │
│                   │ - UI Widget │                           │
│                   │ - Status    │                           │
│                   │ - Resend    │                           │
│                   └─────────────┘                           │
└─────────────────────────────────────────────────────────────┘
```

### Component Details

#### 1. EmailPlugin.java
**Purpose**: Main plugin entry point
- Implements Spark's Plugin interface
- Initializes all components on startup
- Registers preferences and listeners
- Handles plugin lifecycle (initialize, shutdown, uninstall)

#### 2. EmailPreference.java
**Purpose**: Configuration UI
- Implements Spark's Preference interface
- Provides GUI for SMTP settings
- Validates user input
- Saves/loads configuration from properties file
- Fields: host, port, username, password, recipient, SSL/TLS

#### 3. EnhancedEmailMessageListener.java
**Purpose**: Message monitoring and email triggering
- Implements MessageListener interface
- Listens for incoming chat messages
- Triggers email sending asynchronously
- Manages status tracking
- Creates and updates UI status panels

#### 4. EmailSender.java
**Purpose**: Email transmission
- Uses JavaMail API
- Configures SMTP connection
- Handles authentication
- Sends emails with proper formatting
- Supports SSL/TLS encryption

#### 5. EmailStatusPanel.java
**Purpose**: UI status display
- JPanel component added to chat transcript
- Shows status icons and text
- Provides "Resend" button for failures
- Updates in real-time
- Status states: Sending (📧), Sent (✓), Failed (✗)

#### 6. EmailMessageListener.java
**Purpose**: Basic message listener (alternative implementation)
- Simpler version without UI integration
- Can be used for headless operation
- Logs status to Spark logs

## Data Flow

### Message Reception Flow
```
1. User receives chat message
   ↓
2. Spark delivers to ChatRoom
   ↓
3. EnhancedEmailMessageListener.messageReceived() called
   ↓
4. Create EmailStatusPanel (shows "Sending...")
   ↓
5. Add panel to chat transcript UI
   ↓
6. Spawn background thread for email sending
   ↓
7. EmailSender.sendEmail() executes
   ↓
8. Update status panel:
   - Success → "✓ Sent" (green)
   - Failure → "✗ Failed" (red) + Resend button
```

### Configuration Flow
```
1. User opens Preferences
   ↓
2. EmailPreference panel displayed
   ↓
3. User enters SMTP settings
   ↓
4. Click Apply/OK
   ↓
5. EmailPreference.commit() called
   ↓
6. Settings saved to ~/.spark/email-plugin.properties
   ↓
7. Settings loaded on next message
```

### Resend Flow
```
1. User clicks "Resend" button
   ↓
2. EmailStatusPanel.handleResend() called
   ↓
3. Button disabled, status → "Resending..."
   ↓
4. Call messageListener.resendEmail()
   ↓
5. New email attempt in background
   ↓
6. Status updated based on result
   ↓
7. Button re-enabled if still failed
```

## File Structure

```
spark-email-plugin/
│
├── src/main/java/org/jivesoftware/spark/plugin/email/
│   ├── EmailPlugin.java                    # Main plugin class
│   ├── EmailPreference.java                # Configuration UI
│   ├── EmailMessageListener.java           # Basic listener
│   ├── EnhancedEmailMessageListener.java   # UI-integrated listener
│   ├── EmailSender.java                    # Email sending logic
│   └── EmailStatusPanel.java               # Status UI component
│
├── pom.xml                                  # Maven build configuration
├── plugin.xml                               # Spark plugin descriptor
│
├── README.md                                # Full documentation
├── QUICKSTART.md                            # Quick setup guide
├── PROJECT_OVERVIEW.md                      # This file
│
├── build.sh                                 # Linux/Mac build script
├── build.bat                                # Windows build script
├── setup-structure.sh                       # Linux/Mac setup script
├── setup-structure.bat                      # Windows setup script
│
└── example-config.properties                # Example configuration
```

## Configuration Storage

Settings are stored in: `~/.spark/email-plugin.properties`

```properties
enabled=true
host=smtp.gmail.com
port=587
username=user@gmail.com
password=app-password
recipient=recipient@example.com
ssl=true
```

## Dependencies

### Runtime Dependencies
- **Spark API** (provided): Core Spark plugin interfaces
- **Smack XMPP** (provided): XMPP protocol handling
- **JavaMail API** (bundled): Email sending functionality

### Build Dependencies
- **Maven 3.x**: Build automation
- **Java 8+**: Compilation target

## Build Process

1. **Setup**: Run `setup-structure.bat` (Windows) or `setup-structure.sh` (Linux/Mac)
2. **Build**: Run `build.bat` (Windows) or `build.sh` (Linux/Mac)
3. **Output**: `target/email-plugin-1.0.0-jar-with-dependencies.jar`
4. **Install**: Copy JAR and plugin.xml to Spark plugins directory

## Integration Points with Spark

### 1. Plugin Interface
```java
public class EmailPlugin implements Plugin {
    void initialize()      // Called when plugin loads
    void shutdown()        // Called when plugin unloads
    boolean canShutDown()  // Check if safe to shutdown
    void uninstall()       // Called when plugin removed
}
```

### 2. Preference Interface
```java
public class EmailPreference implements Preference {
    String getTitle()      // Preference panel title
    JComponent getGUI()    // UI component
    void load()            // Load settings
    void commit()          // Save settings
    boolean isDataValid()  // Validate input
}
```

### 3. MessageListener Interface
```java
public interface MessageListener {
    void messageReceived(ChatRoom, Message)  // Incoming message
    void messageSent(ChatRoom, Message)      // Outgoing message
}
```

### 4. Spark Managers Used
- **PreferenceManager**: Register configuration UI
- **ChatManager**: Access chat rooms and add listeners
- **SparkManager**: Access main Spark components

## Email Format

### Subject Line
```
Chat message from: [username]
```
Example: `Chat message from: john.doe`

### Body
```
[Message content exactly as received]
```

## Status Indicators

| Status | Icon | Color | Description | Action Available |
|--------|------|-------|-------------|------------------|
| Sending | 📧 | Blue | Email is being sent | None |
| Sent | ✓ | Green | Successfully sent | None |
| Failed | ✗ | Red | Send failed | Resend button |

## Error Handling

### Configuration Errors
- Missing required fields → Validation error in preferences
- Invalid SMTP settings → Error logged, status shows "Failed"

### Runtime Errors
- Network failure → Status shows "Failed", resend available
- Authentication failure → Status shows "Failed", check logs
- SMTP server error → Status shows "Failed", resend available

### Logging
All errors logged to Spark logs:
- Windows: `%APPDATA%\Spark\logs\`
- Linux: `~/.Spark\logs\`
- Mac: `~/Library/Application Support/Spark/logs/`

## Security Considerations

1. **Password Storage**: Stored in plain text in properties file
   - Recommendation: Use app-specific passwords
   - File permissions should be restricted

2. **SSL/TLS**: Enabled by default for encrypted transmission

3. **Authentication**: Required for SMTP connection

4. **Data Privacy**: Messages sent to configured email only

## Testing Checklist

- [ ] Plugin loads in Spark
- [ ] Preferences panel appears
- [ ] Configuration saves correctly
- [ ] Incoming message triggers email
- [ ] Status shows "Sending..."
- [ ] Status updates to "Sent" on success
- [ ] Status shows "Failed" on error
- [ ] Resend button appears on failure
- [ ] Resend button works correctly
- [ ] Email received with correct subject
- [ ] Email body matches message content
- [ ] SSL/TLS connection works
- [ ] Multiple messages handled correctly

## Future Enhancements

Possible improvements:
1. Encrypt password in configuration file
2. Support for multiple recipient addresses
3. Email templates with customizable format
4. Filter messages by sender or content
5. Batch sending to reduce SMTP connections
6. Email delivery confirmation tracking
7. Support for HTML formatted emails
8. Attachment support for file transfers
9. Email threading for conversation context
10. Statistics dashboard for sent emails

## Troubleshooting Guide

### Plugin Not Loading
- Check JAR in correct directory
- Verify plugin.xml present
- Check Spark version compatibility
- Review Spark startup logs

### Emails Not Sending
- Verify SMTP credentials
- Check network connectivity
- Confirm port not blocked
- Review error in Spark logs
- Test SMTP settings externally

### Status Not Updating
- Check UI thread execution
- Verify listener registered
- Review console for exceptions

### Performance Issues
- Reduce email frequency
- Check SMTP server response time
- Monitor thread pool usage

## Support Resources

1. **Spark Documentation**: https://www.igniterealtime.org/projects/spark/
2. **JavaMail API**: https://javaee.github.io/javamail/
3. **Maven**: https://maven.apache.org/
4. **SMTP Configuration**: Provider-specific documentation

## License

This plugin is provided as-is for use with Spark IM client.

## Version

Current Version: 1.0.0
Release Date: 2024
Minimum Spark Version: 2.5.0
