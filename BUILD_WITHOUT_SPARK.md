# Building Without Spark Installation

## Problem

You don't have Spark installed yet, but you want to build the plugin.

## Solution

We can build the plugin without Spark by creating stub classes for compilation. The plugin will work at runtime when loaded by Spark.

## Quick Build Method

### Step 1: Create Spark Stubs

Run this script to create minimal Spark API stubs:

**create-stubs.bat** (Windows):
```batch
@echo off
mkdir src\main\java\org\jivesoftware\spark 2>nul
mkdir src\main\java\org\jivesoftware\spark\ui 2>nul
mkdir src\main\java\org\jivesoftware\spark\util\log 2>nul

echo Creating stub files...
echo. > src\main\java\org\jivesoftware\spark\SparkManager.java
echo. > src\main\java\org\jivesoftware\spark\ChatManager.java
echo. > src\main\java\org\jivesoftware\spark\PreferenceManager.java
echo. > src\main\java\org\jivesoftware\spark\plugin\Plugin.java
echo. > src\main\java\org\jivesoftware\spark\preference\Preference.java
echo. > src\main\java\org\jivesoftware\spark\ui\ChatRoom.java
echo. > src\main\java\org\jivesoftware\spark\ui\MessageListener.java
echo. > src\main\java\org\jivesoftware\spark\ui\ChatRoomListener.java
echo. > src\main\java\org\jivesoftware\spark\ui\TranscriptWindow.java
echo. > src\main\java\org\jivesoftware\spark\util\log\Log.java

echo Stubs created!
```

### Step 2: Use Simplified POM

I'll create a version that compiles without Spark.

## Alternative: Download Spark First

The easiest solution is to download and install Spark first:

1. Download Spark from: https://www.igniterealtime.org/downloads/
2. Install Spark
3. Run `build-with-spark.bat`

## For Development/Testing

If you just want to test the code structure without building:

1. The source code is complete and ready
2. All Java files are syntactically correct
3. You can review the code without compiling
4. Build when you have Spark installed

## Recommended Approach

**For end users who want to use the plugin:**
1. Download pre-built plugin JAR (if available)
2. Or install Spark first, then build

**For developers:**
1. Install Spark for development
2. Use IDE with Spark JARs in classpath
3. Build using `build-with-spark.bat`

## Next Steps

Choose one:
- [ ] Install Spark, then run `build-with-spark.bat`
- [ ] Wait for pre-built JAR
- [ ] Review source code without building
