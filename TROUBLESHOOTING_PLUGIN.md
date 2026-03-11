# Plugin Not Loading - Troubleshooting Steps

## Current Status
- ✅ Plugin built successfully
- ✅ JAR contains the EmailPlugin class
- ✅ plugin.xml is correctly formatted
- ❌ Plugin not appearing in Spark Preferences

## Possible Issues & Solutions

### 1. Check Spark Version
The plugin requires Spark 2.5.0+. 

**To check your Spark version:**
1. Open Spark
2. Go to Help → About Spark
3. Check the version number

If your version is older than 2.5.0, the plugin won't load.

### 2. Verify File Names
Spark might require specific naming. Try renaming:

**Option A: Simple name**
```cmd
cd %APPDATA%\Spark\plugins
ren email-plugin-1.0.0-jar-with-dependencies.jar email-plugin.jar
```

**Option B: Match plugin.xml name**
The JAR should match the plugin name. Since plugin.xml says "Email Integration Plugin", try:
```cmd
cd %APPDATA%\Spark\plugins
ren email-plugin-1.0.0-jar-with-dependencies.jar emailintegration.jar
```

### 3. Check Spark Logs
Look for errors in Spark logs:
```
%APPDATA%\Spark\logs\
```

Files to check:
- `error.log`
- `spark.log`
- `debug.log`

Look for lines containing "email" or "plugin" or "EmailPlugin"

### 4. Verify Plugin Directory
Make sure files are in the correct location:
```
%APPDATA%\Spark\plugins\
  ├── email-plugin.jar (or whatever you named it)
  └── plugin.xml
```

### 5. Check Java Version
Spark requires Java 8+. The plugin was compiled for Java 8.

**To check:**
```cmd
java -version
```

### 6. Try Minimal Plugin
Create a test to see if ANY plugin loads:

Create `test-plugin.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<plugin>
    <name>Test Plugin</name>
    <version>1.0</version>
    <author>Test</author>
    <class>org.jivesoftware.spark.plugin.email.EmailPlugin</class>
</plugin>
```

### 7. Check Spark Plugin System
Some Spark installations have plugins disabled.

**To enable:**
1. Check Spark preferences
2. Look for "Plugins" section
3. Ensure plugins are enabled

### 8. Permissions Issue
The plugins directory might have permission issues.

**To fix:**
1. Right-click on `%APPDATA%\Spark\plugins` folder
2. Properties → Security
3. Ensure your user has Full Control

### 9. Restart Spark Properly
Make sure Spark is completely closed:

1. Close Spark window
2. Check Task Manager (Ctrl+Shift+Esc)
3. Look for "Spark" or "java" processes
4. End any Spark-related processes
5. Start Spark again

### 10. Try Different Plugin Format

Some Spark versions expect plugins in a specific structure:

```
%APPDATA%\Spark\plugins\
  └── email-plugin\
      ├── plugin.xml
      └── lib\
          └── email-plugin.jar
```

**To create this structure:**
```cmd
cd %APPDATA%\Spark\plugins
mkdir email-plugin
mkdir email-plugin\lib
move plugin.xml email-plugin\
move email-plugin-1.0.0-jar-with-dependencies.jar email-plugin\lib\email-plugin.jar
```

## Quick Test Commands

Run these to verify setup:

```cmd
REM Check if files exist
dir "%APPDATA%\Spark\plugins"

REM Check JAR contents
jar tf "%APPDATA%\Spark\plugins\email-plugin-1.0.0-jar-with-dependencies.jar" | findstr EmailPlugin

REM Check if Spark is running
tasklist | findstr -i spark

REM View recent log entries (if logs exist)
type "%APPDATA%\Spark\logs\spark.log"
```

## What to Try Next

1. **Simplest approach - Rename files:**
   ```cmd
   cd %APPDATA%\Spark\plugins
   ren email-plugin-1.0.0-jar-with-dependencies.jar email.jar
   ```

2. **Check Spark documentation:**
   - Look at other working plugins in your Spark installation
   - See how they're structured
   - Copy their naming convention

3. **Try folder structure:**
   Create the folder-based structure mentioned in step 10

4. **Check Spark version compatibility:**
   - Your Spark might be too old or too new
   - Try updating/downgrading Spark

## Common Spark Plugin Locations

Different Spark versions use different locations:

- `%APPDATA%\Spark\plugins\`
- `C:\Program Files (x86)\Spark\plugins\`
- `C:\Program Files\Spark\plugins\`
- `[Spark Install Dir]\plugins\`

Try checking all these locations.

## Still Not Working?

If none of the above works, the issue might be:

1. **Spark version incompatibility** - The API might have changed
2. **Missing dependencies** - Spark might need additional libraries
3. **Plugin system disabled** - Some Spark builds have plugins disabled
4. **Security restrictions** - Antivirus or corporate policies blocking plugins

## Alternative: Manual Installation

If automatic loading doesn't work, you can try:

1. Extract the JAR contents
2. Copy class files directly to Spark's classpath
3. Manually register the plugin (advanced)

## Get Help

To get more specific help, provide:
1. Your Spark version (Help → About)
2. Contents of `%APPDATA%\Spark\logs\error.log`
3. Output of: `dir "%APPDATA%\Spark\plugins"`
4. Your Java version: `java -version`
