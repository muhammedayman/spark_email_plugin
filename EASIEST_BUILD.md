# Easiest Way to Build

## Option 1: Use BUILD_NOW.bat (Recommended)

1. **Open `BUILD_NOW.bat` in a text editor**

2. **Find line 8** which says:
   ```batch
   set "SPARK_JAR=C:\Program Files (x86)\Spark\lib\spark.jar"
   ```

3. **Change it to your Spark location**:
   - If Spark is in `C:\Program Files (x86)\Spark\`, leave it as is
   - If Spark is elsewhere, change the path

4. **Save the file**

5. **Run it**:
   ```cmd
   BUILD_NOW.bat
   ```

Done! The plugin will be built.

## Option 2: Use build-simple.bat

1. **Run the script**:
   ```cmd
   build-simple.bat
   ```

2. **When prompted, paste the full path to spark.jar**:
   ```
   C:\Program Files (x86)\Spark\lib\spark.jar
   ```

3. **Press Enter**

Done! The plugin will be built.

## Option 3: Manual Commands

Open Command Prompt in this directory and run:

```cmd
mvn install:install-file "-Dfile=C:\Program Files (x86)\Spark\lib\spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar

mvn clean package
```

Replace the path if your Spark is installed elsewhere.

## After Building

You'll see:
```
target\email-plugin-1.0.0-jar-with-dependencies.jar
```

Copy this file and `plugin.xml` to:
```
%APPDATA%\Spark\plugins\
```

Then restart Spark!

## Your Spark Location

Based on your earlier input, your Spark is at:
```
C:\Program Files (x86)\Spark\
```

So the spark.jar file should be at:
```
C:\Program Files (x86)\Spark\lib\spark.jar
```

## Quick Test

To verify spark.jar exists, run:
```cmd
dir "C:\Program Files (x86)\Spark\lib\spark.jar"
```

You should see the file listed.

## Recommended: Use BUILD_NOW.bat

It's already configured for your path! Just run:
```cmd
BUILD_NOW.bat
```
