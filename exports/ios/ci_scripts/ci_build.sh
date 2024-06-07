#!/bin/zsh
echo "Current Directory: $PWD"
echo "Directory Contents:\n$(ls)"

echo "Installing Godot"
brew update
brew install --cask godot
# brew installs at '/Applications/Godot.app'
alias godot="/Applications/Godot.app/Contents/MacOS/Godot"
godot --version

echo "Exporting iOS Production"
cd ../../../mobile-game
godot ---headless --export-release "iOS Production" ../exports/ios/scaling-broccoli.xcodeproj