#!/bin/sh
echo "Current Directory: $PWD"
echo "Directory Contents:\n$(ls)"

echo "Installing Godot"
brew update
brew install --cask godot
godot --version

echo "Exporting iOS Production"

cd ../../../mobile-game
godot ---headless --export-release "iOS Production" ../exports/ios/scaling-broccoli.xcodeproj