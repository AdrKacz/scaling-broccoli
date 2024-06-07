#!/bin/zsh
echo "Current Directory: $PWD"
echo "Directory Contents:\n$(ls)"

echo "Installing Godot"
VERSION=4.2.2
cd ../../../
curl -LO https://github.com/godotengine/godot/releases/download/$VERSION-stable/Godot_v$VERSION-stable_macos.universal.zip
unzip ./Godot_v$VERSION-stable_macos.universal.zip
echo "Directory Contents:\n$(ls)"
Godot.app/Contents/MacOS/Godot --version

echo "Exporting iOS Production"
mv ./export_presets.cfg ./mobile-game/
cd ./mobile-game
../Godot.app/Contents/MacOS/Godot ---headless --export-release "iOS Production" ../exports/ios/scaling-broccoli.xcodeproj