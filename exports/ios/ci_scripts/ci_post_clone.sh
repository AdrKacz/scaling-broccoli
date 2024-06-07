#!/bin/zsh
echo "Current Directory: $PWD"
echo "Directory Contents:\n$(ls)"

echo "Installing Godot"
VERSION=4.2.2
cd ../../../
curl -LO https://github.com/godotengine/godot/releases/download/$VERSION-stable/Godot_v$VERSION-stable_macos.universal.zip
unzip ./Godot_v$VERSION-stable_macos.universal.zip
alias godot="./Godot.app/Contents/MacOS/Godot"
godot --version



echo "Exporting iOS Production"
cd ./mobile-game
godot ---headless --export-release "iOS Production" ../exports/ios/scaling-broccoli.xcodeproj