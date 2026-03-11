#!/bin/bash

# Build script that uses local Spark installation

echo "========================================="
echo "Spark Email Plugin Builder (with local Spark)"
echo "========================================="
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null
then
    echo "ERROR: Maven is not installed or not in PATH"
    echo "Please install Maven from https://maven.apache.org/"
    exit 1
fi

# Default Spark locations
if [ "$(uname)" == "Darwin" ]; then
    # Mac
    SPARK_HOME="$HOME/Library/Application Support/Spark"
else
    # Linux
    SPARK_HOME="$HOME/.Spark"
fi

echo "Looking for Spark installation..."
echo "Default location: $SPARK_HOME"
echo ""

if [ ! -f "$SPARK_HOME/lib/spark.jar" ]; then
    echo "Spark JAR not found at default location."
    echo "Please enter your Spark installation directory:"
    read -p "Spark directory: " SPARK_HOME
fi

if [ ! -f "$SPARK_HOME/lib/spark.jar" ]; then
    echo "ERROR: Could not find spark.jar in $SPARK_HOME/lib/"
    echo ""
    echo "Please ensure Spark is installed and provide the correct path."
    echo "The spark.jar file should be in the lib subdirectory."
    exit 1
fi

echo "Found Spark at: $SPARK_HOME"
echo ""

echo "Installing Spark JAR to local Maven repository..."
mvn install:install-file -Dfile="$SPARK_HOME/lib/spark.jar" -DgroupId=org.igniterealtime.spark -DartifactId=spark -Dversion=2.9.4 -Dpackaging=jar

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install Spark JAR to Maven repository"
    exit 1
fi

echo ""
echo "Building plugin..."
mvn clean package

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "BUILD SUCCESSFUL!"
    echo "========================================="
    echo ""
    echo "Plugin JAR created at:"
    echo "  target/email-plugin-1.0.0-jar-with-dependencies.jar"
    echo ""
    echo "Installation Instructions:"
    if [ "$(uname)" == "Darwin" ]; then
        echo "1. Copy the JAR file to: ~/Library/Application Support/Spark/plugins/"
        echo "2. Copy plugin.xml to: ~/Library/Application Support/Spark/plugins/"
    else
        echo "1. Copy the JAR file to: ~/.Spark/plugins/"
        echo "2. Copy plugin.xml to: ~/.Spark/plugins/"
    fi
    echo "3. Restart Spark"
    echo "4. Configure via File → Preferences → Email Integration"
    echo ""
else
    echo ""
    echo "========================================="
    echo "BUILD FAILED!"
    echo "========================================="
    echo "Please check the error messages above"
    exit 1
fi
