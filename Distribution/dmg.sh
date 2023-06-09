#!/usr/bin/env zsh

set -e

echo -n "SparkleUpdateTest-$VERSION.dmg: "
read VERSION

# appdmg ./appdmg.json ./Archive/SparkleUpdateTest-$VERSION.dmg
rm Poppy.dmg
hdiutil create -volname Poppy -srcfolder ./Poppy.app -ov -format UDZO Poppy-$VERSION.dmg && rm -Rf ./Poppy.app
