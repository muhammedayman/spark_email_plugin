# Spark Email Plugin - Setup & Testing Checklist

## Pre-Installation Checklist

### Prerequisites
- [ ] Spark IM Client installed (version 2.5.0+)
- [ ] Java JDK 8+ installed
- [ ] Maven 3.x installed
- [ ] SMTP email account available
- [ ] SMTP credentials ready (host, port, username, password)

### Email Account Setup
- [ ] Email account created
- [ ] SMTP settings obtained
- [ ] App-specific password generated (if using Gmail)
- [ ] Test recipient email address ready

## Build Checklist

### Setup
- [ ] Downloaded/cloned plugin source code
- [ ] Ran `setup-structure.bat` (Windows) or `setup-structure.sh` (Linux/Mac)
- [ ] Verified directory structure created
- [ ] All Java files in correct location

### Build Process
- [ ] Ran `build.bat` (Windows) or `build.sh` (Linux/Mac)
- [ ] Build completed without errors
- [ ] JAR file created in `target/` directory
- [ ] JAR filename: `email-plugin-1.0.0-jar-with-dependencies.jar`

## Installation Checklist

### File Deployment
- [ ] Located Spark plugins directory
  - Windows: `%APPDATA%\Spark\plugins\`
  - Linux: `~/.Spark/plugins/`
  - Mac: `~/Library/Application Support/Spark/plugins/`
- [ ] Copied JAR file to plugins directory
- [ ] Copied `plugin.xml` to plugins directory
- [ ] Verified both files present in plugins directory

### Spark Restart
- [ ] Closed Spark completely
- [ ] Restarted Spark
- [ ] Logged in successfully

### Plugin Verification
- [ ] Opened Help → About Spark
- [ ] Clicked Plugins tab
- [ ] Found "Email Integration Plugin" in list
- [ ] Plugin shows as loaded/active

## Configuration Checklist

### Access Preferences
- [ ] Opened File → Preferences
- [ ] Found "Email Integration" in preferences list
- [ ] Clicked on "Email Integration"
- [ ] Preferences panel displayed

### Enter Settings
- [ ] Checked "Enable Email Integration"
- [ ] Entered SMTP host (e.g., smtp.gmail.com)
- [ ] Entered port (e.g., 587)
- [ ] Entered username (email address)
- [ ] Entered password (or app password)
- [ ] Entered recipient email address
- [ ] Checked "Enable SSL/TLS" (if applicable)

### Save Configuration
- [ ] Clicked "Apply" or "OK"
- [ ] No error messages displayed
- [ ] Preferences window closed

### Verify Configuration Saved
- [ ] Reopened File → Preferences → Email Integration
- [ ] All settings still present
- [ ] Settings match what was entered

## Testing Checklist

### Basic Functionality Test
- [ ] Asked someone to send you a test message
- [ ] Received message in Spark
- [ ] Status indicator appeared next to message
- [ ] Status showed "📧 Sending..."
- [ ] Status changed to "✓ Sent" (green)
- [ ] No error messages in Spark

### Email Delivery Test
- [ ] Checked recipient email inbox
- [ ] Email received
- [ ] Subject line correct: "Chat message from: [sender]"
- [ ] Body contains message text
- [ ] Email from correct sender address

### Multiple Messages Test
- [ ] Received multiple messages
- [ ] Each message has its own status indicator
- [ ] All statuses update independently
- [ ] All emails received

### Status Indicator Test
- [ ] Verified "Sending..." appears (blue)
- [ ] Verified "Sent" appears (green)
- [ ] Verified checkmark icon visible
- [ ] Status remains after scrolling

### Failure Test (Optional)
- [ ] Changed password to incorrect value
- [ ] Received a test message
- [ ] Status showed "✗ Failed" (red)
- [ ] "Resend" button appeared
- [ ] Error logged in Spark logs

### Resend Test (If Failure Occurred)
- [ ] Fixed configuration (correct password)
- [ ] Clicked "Resend" button
- [ ] Button disabled during resend
- [ ] Status updated to "Sending..."
- [ ] Status changed to "Sent"
- [ ] Email received

## Troubleshooting Checklist

### Plugin Not Loading
- [ ] Verified JAR file in correct directory
- [ ] Verified plugin.xml in same directory
- [ ] Checked file permissions (readable)
- [ ] Restarted Spark completely
- [ ] Checked Spark version (2.5.0+)
- [ ] Reviewed Spark logs for errors

### Plugin Not in Preferences
- [ ] Verified plugin loaded (Help → About → Plugins)
- [ ] Restarted Spark
- [ ] Checked for error messages
- [ ] Reviewed Spark logs

### Emails Not Sending
- [ ] Verified "Enable Email Integration" checked
- [ ] Checked SMTP host correct
- [ ] Verified port number correct
- [ ] Confirmed username correct
- [ ] Verified password correct
- [ ] Checked SSL/TLS setting matches server
- [ ] Tested SMTP settings externally
- [ ] Checked firewall not blocking port
- [ ] Reviewed Spark logs for errors

### Status Not Updating
- [ ] Waited sufficient time (5-10 seconds)
- [ ] Checked network connection
- [ ] Verified SMTP server responding
- [ ] Reviewed Spark logs

### Configuration Not Saving
- [ ] Checked write permissions on ~/.spark directory
- [ ] Verified disk space available
- [ ] Checked for file system errors
- [ ] Reviewed Spark logs

## Gmail-Specific Checklist

### App Password Setup
- [ ] Logged into Google Account
- [ ] Went to https://myaccount.google.com/security
- [ ] Verified 2-Step Verification enabled
- [ ] Went to https://myaccount.google.com/apppasswords
- [ ] Selected "Mail" and device
- [ ] Generated 16-character password
- [ ] Copied password
- [ ] Used app password in plugin (not regular password)

### Gmail Settings
- [ ] Host: smtp.gmail.com
- [ ] Port: 587
- [ ] SSL/TLS: Enabled
- [ ] Username: Full email address
- [ ] Password: App password (16 characters)

## Outlook-Specific Checklist

### Outlook Settings
- [ ] Host: smtp.office365.com
- [ ] Port: 587
- [ ] SSL/TLS: Enabled
- [ ] Username: Full email address
- [ ] Password: Regular email password

## Post-Installation Checklist

### Documentation Review
- [ ] Read QUICKSTART.md
- [ ] Reviewed README.md troubleshooting section
- [ ] Bookmarked documentation for reference

### User Training (If Applicable)
- [ ] Explained status indicators to users
- [ ] Demonstrated resend functionality
- [ ] Provided support contact information
- [ ] Shared troubleshooting guide

### Monitoring
- [ ] Checked Spark logs for errors
- [ ] Verified emails being received
- [ ] Monitored for failed sends
- [ ] Collected user feedback

## Security Checklist

### Configuration Security
- [ ] Used app-specific password (not main password)
- [ ] Verified SSL/TLS enabled
- [ ] Checked file permissions on config file
- [ ] Considered using dedicated email account

### Network Security
- [ ] Verified SMTP connection encrypted
- [ ] Confirmed firewall rules appropriate
- [ ] Checked network traffic if required

## Performance Checklist

### Resource Usage
- [ ] Monitored Spark memory usage
- [ ] Checked CPU usage during email sending
- [ ] Verified no performance degradation
- [ ] Tested with multiple simultaneous messages

### Email Delivery
- [ ] Checked email delivery time
- [ ] Verified no delays in chat
- [ ] Confirmed asynchronous operation
- [ ] Tested with various message sizes

## Maintenance Checklist

### Regular Checks
- [ ] Review Spark logs weekly
- [ ] Check for failed emails
- [ ] Verify configuration still valid
- [ ] Test email delivery periodically

### Updates
- [ ] Check for plugin updates
- [ ] Review changelog
- [ ] Test in non-production first
- [ ] Update documentation if needed

## Rollback Checklist (If Needed)

### Uninstall Steps
- [ ] Closed Spark
- [ ] Removed JAR file from plugins directory
- [ ] Removed plugin.xml from plugins directory
- [ ] Restarted Spark
- [ ] Verified plugin no longer loaded

### Configuration Cleanup (Optional)
- [ ] Removed ~/.spark/email-plugin.properties
- [ ] Cleared any cached data

## Success Criteria

### Must Have
- [x] Plugin loads in Spark
- [x] Preferences accessible
- [x] Configuration saves
- [x] Messages trigger emails
- [x] Status indicators display
- [x] Emails delivered

### Should Have
- [x] Resend works
- [x] Multiple messages handled
- [x] SSL/TLS works
- [x] Error handling functional

### Nice to Have
- [ ] Fast email delivery
- [ ] No performance impact
- [ ] User-friendly interface
- [ ] Clear error messages

## Final Verification

### Complete Test Scenario
1. [ ] Fresh Spark restart
2. [ ] Send test message to yourself
3. [ ] Verify status shows "Sending..."
4. [ ] Wait for status to change to "Sent"
5. [ ] Check email received
6. [ ] Verify email content correct
7. [ ] Test resend with intentional failure
8. [ ] Fix configuration and resend
9. [ ] Verify second email received

### Sign-Off
- [ ] All critical tests passed
- [ ] Documentation reviewed
- [ ] Users trained (if applicable)
- [ ] Support process established
- [ ] Plugin ready for production use

---

## Notes Section

Use this space to record any issues, observations, or customizations:

```
Date: _______________
Tester: _______________

Issues Found:
_______________________________________________________________________
_______________________________________________________________________
_______________________________________________________________________

Resolutions:
_______________________________________________________________________
_______________________________________________________________________
_______________________________________________________________________

Custom Configuration:
_______________________________________________________________________
_______________________________________________________________________
_______________________________________________________________________

Additional Notes:
_______________________________________________________________________
_______________________________________________________________________
_______________________________________________________________________
```

---

**Checklist Complete?** If all items are checked, your Spark Email Plugin is successfully installed and configured!

**Need Help?** Refer to:
- [QUICKSTART.md](QUICKSTART.md) - Quick setup
- [README.md](README.md) - Full documentation
- [INSTALLATION.md](INSTALLATION.md) - Detailed installation
