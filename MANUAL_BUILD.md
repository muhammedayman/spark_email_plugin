# Manual Build Instructions

If the automated scripts don't work, follow these manual steps:

## Step 1: Install Spark JAR to Maven

Open Command Prompt and run this command (replace the path with your actual Spark location):

### For: C:\Program Files (x86)\Spark

```cmd
mvn install:install-file "-Dfile=C:\Program Files (x86)\Spark\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar
```

### For: %APPDATA%\Spark

```cmd
mvn install:install-file "-Dfile=%APPDATA%\Spark\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar
```

### For: Custom Location

Replace `YOUR_PATH` with your actual Spark installation path:

```cmd
mvn install:install-file "-Dfile=YOUR_PATH\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar
```

**Important Notes:**
- Use quotes around the `-Dfile=` parameter
- Include the full path to spark.jar
- The path should end with `\lib\spark.jar`

## Step 2: Build the Plugin

After successfully installing the Spark JAR, run:

```cmd
mvn clean package
```

## Step 3: Verify Build

Check that the file was created:

```cmd
dir target\email-plugin-1.0.0-jar-with-dependencies.jar
```

You should see the file listed.

## Step 4: Install Plugin

Copy the files to Spark's plugins directory:

```cmd
copy target\email-plugin-1.0.0-jar-with-dependencies.jar %APPDATA%\Spark\plugins\
copy plugin.xml %APPDATA%\Spark\plugins\
```

## Step 5: Restart Spark

1. Close Spark completely
2. Start Spark again
3. Go to File → Preferences
4. Look for "Email Integration"

## Troubleshooting

### Error: "Could not find artifact"

This means Step 1 didn't work. Try:

1. Check that spark.jar exists at the path you specified
2. Make sure you used quotes around the path
3. Try using the full path without environment variables

### Error: "The system cannot find the path specified"

Your Spark path is incorrect. To find it:

1. Open File Explorer
2. Navigate to where Spark is installed
3. Look for the `lib` folder
4. Inside should be `spark.jar`
5. Copy the full path

### Build succeeds but no JAR file

Check the `target` directory:

```cmd
dir target
```

Look for `email-plugin-1.0.0-jar-with-dependencies.jar`

## Example: Complete Manual Build

Here's a complete example for Spark installed in Program Files:

```cmd
REM Step 1: Install Spark JAR
mvn install:install-file "-Dfile=C:\Program Files (x86)\Spark\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar

REM Step 2: Build plugin
mvn clean package

REM Step 3: Copy to plugins directory
copy target\email-plugin-1.0.0-jar-with-dependencies.jar %APPDATA%\Spark\plugins\
copy plugin.xml %APPDATA%\Spark\plugins\

REM Step 4: Done! Restart Spark
echo Done! Now restart Spark and configure the plugin.
```

## Quick Reference

| Your Spark Location | Command |
|---------------------|---------|
| C:\Program Files (x86)\Spark | `mvn install:install-file "-Dfile=C:\Program Files (x86)\Spark\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar` |
| %APPDATA%\Spark | `mvn install:install-file "-Dfile=%APPDATA%\Spark\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar` |
| C:\Spark | `mvn install:install-file "-Dfile=C:\Spark\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar` |

## Alternative: Use build-simple.bat

We also provide a simpler script:

```cmd
build-simple.bat
```

This script will:
1. Ask you for the full path to spark.jar
2. Install it to Maven
3. Build the plugin
4. Show installation instructions

Just paste the full path when prompted!
