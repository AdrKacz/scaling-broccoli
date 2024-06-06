#!/bin/sh

wget https://github.com/godotengine/godot/releases/download/${{ env.VERSION }}/godot-${{ env.VERSION }}.tar.xz
tar xvf godot-${{ env.VERSION }}.tar.xz --strip-components=1
brew install scons yasm
scons --version
scons platform=server tools=yes use_static_cpp=no -j 8
mv ./bin/godot_server.osx.tools.64 ./bin/godot