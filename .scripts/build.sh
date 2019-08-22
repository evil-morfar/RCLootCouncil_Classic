#!/bin/sh
echo "Executing a $0"
release_script="./.scripts/release.sh"

# Update RCLootCouncil
git submodule update --remote

#Remove .tmp folder
rm -r "./.tmp"

# Build RCLootCouncil (locale only)
( bash "$release_script" -t "$(pwd)/RCLootCouncil/" -r "$(pwd)/.tmp/RCLootCouncil_Classic" -p 39928 -Lz -m ".pkgmeta-rclootcouncil" )

# Do replacements
. "./.scripts/replace.sh"

# Build RCLootCouncil Classic
"$release_script" -r "$(pwd)/.tmp" -do -m ".pkgmeta-build"

# Move the zip
mv ./.tmp/*.zip "./.release/"

# And delete .tmp
rm -r "./.tmp"
