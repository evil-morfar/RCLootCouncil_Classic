#!/bin/sh
echo "Executing build.sh"
curDir="$(pwd)"
release_script="./.scripts/release.sh"

# Update RCLootCouncil
git submodule update --remote

#Remove .tmp folder and its contents
rm -r "./.tmp"

mkdir "$curDir/.tmp/"
mkdir "$curDir/.tmp/RCLootCouncil_Classic"

# Build RCLootCouncil (locale only) (and skip Libs as they shouldn't be processed with the keyword replacements)
( bash "$release_script" -dLsz -t "$curDir/RCLootCouncil" -r "$curDir/.tmp/RCLootCouncil_Classic" -p 39928 -m ".pkgmeta-rclootcouncil" )
# Now just copy the original libs to the build
cp -R "$curDir/RCLootCouncil/Libs/" "$curDir/.tmp/RCLootCouncil_Classic/RCLootCouncil/"

# # Do replacements
. "./.scripts/replace.sh" "$curDir/.tmp/RCLootCouncil_Classic"

# Build for Classic Era
# -d: Skip Upload
# -z: Skip zip
"$release_script" -do -g classic -r "$curDir/.tmp" -m ".pkgmeta-build"

# Build for BBC
"$release_script" -do -g cata -r "$curDir/.tmp" -m ".pkgmeta-build"


# # Move the zip
mv .tmp/*.zip "./.release/"

# # And delete .tmp
rm -r "./.tmp"
