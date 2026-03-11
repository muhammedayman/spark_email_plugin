#!/bin/bash

# Spark Email Plugin Build Script

echo "========================================="
echo "Spark Email Integration Plugin Builder"
echo "========================================="
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null
then
    echo "ERROR: Maven is not installed or not in PATH"
    echo "Please install Maven from https://maven.apache.org/"
    exit 1
fi

echo "Step 1: Cleaning previous builds..."
mvn clean

echo ""
echo "Step 2: Building plugin..."
mvn package

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
    echo "1. Copy the JAR file to your Spark plugins directory:"
    echo "   - Windows: %APPDATA%\\Spark\\plugins\\"
    echo "   - Linux: ~/.Spark/plugins/"
    echo "   - Mac: ~/Library/Application Support/Spark/plugins/"
    echo ""
    echo "2. Copy plugin.xml to the same directory"
    echo ""
    echo "3. Restart Spark"
    echo ""
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
