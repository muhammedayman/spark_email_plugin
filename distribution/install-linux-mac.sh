#!/bin/bash
echo "Installing Spark Email Integration Plugin..."
echo ""

# Determine Spark plugins directory
if [ "$(uname)" == "Darwin" ]; then
    SPARK_PLUGINS="$HOME/Library/Application Support/Spark/plugins"
else
    SPARK_PLUGINS="$HOME/.Spark/plugins"
fi

if [ ! -d "$SPARK_PLUGINS" ]; then
    echo "Error: Spark plugins directory not found!"
    echo "Please make sure Spark is installed."
    exit 1
fi

echo "Copying plugin files..."
cp -r email "$SPARK_PLUGINS/"

echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo ""
echo "Please restart Spark and go to:"
echo "File > Preferences > Email Integration"
echo ""
