#!/usr/bin/env zsh

set -e

echo -n "What's the version number: "
read VERSION

# appdmg ./appdmg.json ./Archive/SparkleUpdateTest-$VERSION.dmg
# rm Poppy.dmg
hdiutil create -volname Poppy -srcfolder ./Poppy.app -ov -format UDZO ../Archive/Poppy-$VERSION.dmg 
