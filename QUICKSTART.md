# Quick Start Guide - Spark Email Plugin

## 5-Minute Setup

### Step 1: Build the Plugin (1 minute)

**Important**: Use the special build script that installs Spark dependencies:

**Windows:**
```cmd
build-with-spark.bat
```

**Linux/Mac:**
```bash
chmod +x build-with-spark.sh
./build-with-spark.sh
```

The script will:
- Find your Spark installation
- Install Spark JAR to Maven
- Build the plugin

If Spark is not in the default location, you'll be prompted to enter the path.

### Step 2: Install (1 minute)
Copy these files to your Spark plugins directory:
- `target/email-plugin-1.0.0-jar-with-dependencies.jar`
- `plugin.xml`

**Plugin Directory Locations:**
- Windows: `%APPDATA%\Spark\plugins\`
- Linux: `~/.Spark/plugins/`
- Mac: `~/Library/Application Support/Spark/plugins/`

### Step 3: Restart Spark (30 seconds)
Close and reopen Spark completely.

### Step 4: Configure (2 minutes)
1. Go to **File → Preferences**
2. Click **Email Integration**
3. Fill in your email settings:

**For Gmail:**
```
✓ Enable Email Integration
Host: smtp.gmail.com
Port: 587
Username: your-email@gmail.com
Password: [your app password]
Recipient: recipient@example.com
✓ Enable SSL/TLS
```

4. Click **Apply**

### Step 5: Test (30 seconds)
1. Have someone send you a chat message
2. Watch for the status indicator next to the message:
   - 📧 Sending...
   - ✓ Sent (success!)
   - ✗ Failed (click Resend)

## Gmail App Password Setup

If using Gmail, you need an app-specific password:

1. Go to https://myaccount.google.com/security
2. Enable 2-Step Verification (if not already enabled)
3. Go to https://myaccount.google.com/apppasswords
4. Select "Mail" and your device
5. Click "Generate"
6. Copy the 16-character password
7. Use this password in the plugin configuration

## Common Issues

**Plugin doesn't appear in Preferences:**
- Restart Spark completely
- Check that both JAR and plugin.xml are in the plugins folder

**Emails not sending:**
- Verify your SMTP credentials
- Check if port 587 is open on your network
- For Gmail, ensure you're using an app password

**Status shows "Failed":**
- Click the "Resend" button
- Check Spark logs for error details
- Verify recipient email address is correct

## What Gets Emailed?

When you receive a message like:
```
John: Hey, can we meet at 3pm?
```

You'll receive an email:
```
Subject: Chat message from: John
Body: Hey, can we meet at 3pm?
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Configure multiple email accounts (edit config file)
- Check logs if you encounter issues

## Support

Check the logs at:
- Windows: `%APPDATA%\Spark\logs\`
- Linux: `~/.Spark/logs/`
- Mac: `~/Library/Application Support/Spark/logs/`
