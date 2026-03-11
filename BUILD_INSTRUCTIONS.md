# Build Instructions for Spark Email Plugin

## Why Special Build Process?

The Spark API is not available in Maven Central repository. Therefore, we need to install the Spark JAR from your local Spark installation into your local Maven repository before building the plugin.

## Prerequisites

1. **Spark IM Client** installed on your system
2. **Java JDK 8+** installed
3. **Maven 3.x** installed

## Build Methods

### Method 1: Automated Build (Recommended)

Use the provided build scripts that automatically handle Spark dependency installation.

#### Windows

```cmd
build-with-spark.bat
```

#### Linux/Mac

```bash
chmod +x build-with-spark.sh
./build-with-spark.sh
```

**What the script does:**
1. Checks for Maven installation
2. Locates your Spark installation
3. Installs `spark.jar` to local Maven repository
4. Builds the plugin with all dependencies
5. Shows installation instructions

**Default Spark Locations:**
- Windows: `%APPDATA%\Spark`
- Linux: `~/.Spark`
- Mac: `~/Library/Application Support/Spark`

If Spark is installed elsewhere, the script will prompt you for the location.

### Method 2: Manual Build

If you prefer to build manually:

#### Step 1: Install Spark JAR to Maven

**Windows:**
```cmd
mvn install:install-file ^
  -Dfile="%APPDATA%\Spark\lib\spark.jar" ^
  -DgroupId=org.igniterealtime.spark ^
  -DartifactId=spark ^
  -Dversion=2.9.4 ^
  -Dpackaging=jar
```

**Linux/Mac:**
```bash
mvn install:install-file \
  -Dfile="$HOME/.Spark/lib/spark.jar" \
  -DgroupId=org.igniterealtime.spark \
  -DartifactId=spark \
  -Dversion=2.9.4 \
  -Dpackaging=jar
```

**Mac (if different location):**
```bash
mvn install:install-file \
  -Dfile="$HOME/Library/Application Support/Spark/lib/spark.jar" \
  -DgroupId=org.igniterealtime.spark \
  -DartifactId=spark \
  -Dversion=2.9.4 \
  -Dpackaging=jar
```

#### Step 2: Build the Plugin

```bash
mvn clean package
```

## Build Output

After successful build, you'll find:

```
target/
├── email-plugin-1.0.0.jar
└── email-plugin-1.0.0-jar-with-dependencies.jar  ← Use this one
```

The `-jar-with-dependencies.jar` includes the JavaMail library bundled.

## Troubleshooting Build Issues

### Error: "Could not find artifact org.igniterealtime.spark:spark:jar"

**Cause**: Spark JAR not installed in local Maven repository

**Solution**: 
1. Use `build-with-spark.bat` or `build-with-spark.sh`
2. Or manually install Spark JAR (see Method 2, Step 1)

### Error: "spark.jar not found"

**Cause**: Spark not installed or in non-standard location

**Solution**:
1. Install Spark IM Client first
2. If installed in custom location, provide path when prompted
3. Or manually specify path in install command

### Error: "Maven not found"

**Cause**: Maven not installed or not in PATH

**Solution**:
1. Install Maven from https://maven.apache.org/
2. Add Maven to your system PATH
3. Verify with: `mvn --version`

### Error: "JAVA_HOME not set"

**Cause**: Java JDK not installed or JAVA_HOME not configured

**Solution**:
1. Install Java JDK 8 or higher
2. Set JAVA_HOME environment variable
3. Add Java to PATH

### Build succeeds but plugin doesn't load

**Cause**: Wrong JAR file copied

**Solution**:
- Use `email-plugin-1.0.0-jar-with-dependencies.jar`
- NOT `email-plugin-1.0.0.jar`

## Dependencies

### Compile-time Dependencies
- **Spark API** (2.9.4) - Provided by local installation
- **Smack Core** (4.4.6) - Downloaded from Maven Central
- **Smack Extensions** (4.4.6) - Downloaded from Maven Central

### Runtime Dependencies (Bundled)
- **JavaMail API** (1.6.2) - Bundled in plugin JAR

### Provided Dependencies (Not Bundled)
- Spark API - Available at runtime from Spark
- Smack libraries - Available at runtime from Spark

## Build Configuration

### pom.xml Structure

```xml
<dependencies>
    <!-- Spark API - scope: provided -->
    <dependency>
        <groupId>org.igniterealtime.spark</groupId>
        <artifactId>spark</artifactId>
        <version>2.9.4</version>
        <scope>provided</scope>
    </dependency>
    
    <!-- JavaMail - scope: compile (bundled) -->
    <dependency>
        <groupId>com.sun.mail</groupId>
        <artifactId>javax.mail</artifactId>
        <version>1.6.2</version>
    </dependency>
    
    <!-- Smack - scope: provided -->
    <dependency>
        <groupId>org.igniterealtime.smack</groupId>
        <artifactId>smack-core</artifactId>
        <version>4.4.6</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

**Scope Explanation:**
- `provided`: Available at runtime, not bundled
- `compile`: Bundled in the plugin JAR

## Clean Build

To perform a completely clean build:

```bash
# Clean Maven cache for this project
mvn clean

# Remove installed Spark JAR from local repo (optional)
rm -rf ~/.m2/repository/org/igniterealtime/spark/spark/2.9.4/

# Reinstall and rebuild
./build-with-spark.sh  # or build-with-spark.bat on Windows
```

## Build for Different Spark Versions

If you have a different Spark version:

1. Check your Spark version (Help → About Spark)
2. Update version in install command:
   ```bash
   mvn install:install-file \
     -Dfile="path/to/spark.jar" \
     -DgroupId=org.igniterealtime.spark \
     -DartifactId=spark \
     -Dversion=YOUR_VERSION \
     -Dpackaging=jar
   ```
3. Update `pom.xml` to match:
   ```xml
   <dependency>
       <groupId>org.igniterealtime.spark</groupId>
       <artifactId>spark</artifactId>
       <version>YOUR_VERSION</version>
       <scope>provided</scope>
   </dependency>
   ```
4. Build normally

## Continuous Integration / Automated Builds

For CI/CD pipelines:

1. Install Spark JAR as part of build process
2. Cache Maven repository between builds
3. Use the manual build method in your CI script

Example CI script:
```bash
#!/bin/bash
# Install Spark dependency
mvn install:install-file \
  -Dfile="${SPARK_JAR_PATH}" \
  -DgroupId=org.igniterealtime.spark \
  -DartifactId=spark \
  -Dversion=2.9.4 \
  -Dpackaging=jar

# Build plugin
mvn clean package

# Copy artifacts
cp target/email-plugin-*-jar-with-dependencies.jar ${ARTIFACT_DIR}/
```

## Verification

After successful build, verify:

1. **JAR file exists**:
   ```bash
   ls -lh target/email-plugin-1.0.0-jar-with-dependencies.jar
   ```

2. **JAR contains JavaMail**:
   ```bash
   jar tf target/email-plugin-1.0.0-jar-with-dependencies.jar | grep javax.mail
   ```

3. **Plugin descriptor present**:
   ```bash
   ls -lh plugin.xml
   ```

## Next Steps

After successful build:

1. Copy JAR to Spark plugins directory
2. Copy plugin.xml to same directory
3. Restart Spark
4. Configure via Preferences

See [INSTALLATION.md](INSTALLATION.md) for detailed installation instructions.

## Support

If you encounter build issues:

1. Check this document's troubleshooting section
2. Verify all prerequisites are installed
3. Check Maven and Java versions
4. Review build logs for specific errors
5. Ensure Spark is properly installed

## Quick Reference

| Task | Command |
|------|---------|
| Automated build (Windows) | `build-with-spark.bat` |
| Automated build (Linux/Mac) | `./build-with-spark.sh` |
| Clean build | `mvn clean package` |
| Install Spark JAR | `mvn install:install-file -Dfile=...` |
| Check Maven version | `mvn --version` |
| Check Java version | `java -version` |
| List build output | `ls target/` |

## Build Time

Expected build time:
- First build: 2-5 minutes (downloads dependencies)
- Subsequent builds: 30-60 seconds

## Build Size

Expected output sizes:
- `email-plugin-1.0.0.jar`: ~50 KB
- `email-plugin-1.0.0-jar-with-dependencies.jar`: ~700 KB (includes JavaMail)
