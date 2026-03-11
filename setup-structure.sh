#!/bin/bash

# Setup directory structure for Spark Email Plugin

echo "Creating directory structure..."

mkdir -p src/main/java/org/jivesoftware/spark/plugin/email
mkdir -p src/main/resources
mkdir -p target

echo "Moving Java source files..."

mv -f EmailPlugin.java src/main/java/org/jivesoftware/spark/plugin/email/ 2>/dev/null
mv -f EmailPreference.java src/main/java/org/jivesoftware/spark/plugin/email/ 2>/dev/null
mv -f EmailMessageListener.java src/main/java/org/jivesoftware/spark/plugin/email/ 2>/dev/null
mv -f EnhancedEmailMessageListener.java src/main/java/org/jivesoftware/spark/plugin/email/ 2>/dev/null
mv -f EmailSender.java src/main/java/org/jivesoftware/spark/plugin/email/ 2>/dev/null
mv -f EmailStatusPanel.java src/main/java/org/jivesoftware/spark/plugin/email/ 2>/dev/null

echo ""
echo "Directory structure created successfully!"
echo ""
echo "Project structure:"
echo "  src/main/java/org/jivesoftware/spark/plugin/email/"
echo "    - EmailPlugin.java"
echo "    - EmailPreference.java"
echo "    - EmailMessageListener.java"
echo "    - EnhancedEmailMessageListener.java"
echo "    - EmailSender.java"
echo "    - EmailStatusPanel.java"
echo "  pom.xml"
echo "  plugin.xml"
echo ""
echo "You can now run: ./build.sh"
echo ""

chmod +x build.sh
