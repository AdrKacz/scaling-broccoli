#!/bin/sh
VERSION=4.2.2-stable
wget https://github.com/godotengine/godot/releases/download/$VERSION/godot-$VERSION.tar.xz
tar xvf godot-$VERSION.tar.xz --strip-components=1
brew install scons yasm
scons --version
scons platform=server tools=yes use_static_cpp=no -j 8
mv ./bin/godot_server.osx.tools.64 ./bin/godot