#!/bin/sh
echo "Executing a $0"
release_script="./.scripts/release.sh"

# Update RCLootCouncil
git submodule update --remote

#Remove .tmp folder
rm -r "./.tmp"

# Build RCLootCouncil (locale only) (and skip Libs as they shouldn't be processed with the keyword replacements)
( bash "$release_script" -t "$(pwd)/RCLootCouncil/" -r "$(pwd)/.tmp/RCLootCouncil_Classic" -p 39928 -Lzs -m ".pkgmeta-rclootcouncil" )
# Now just copy the original libs to the build
robocopy "$(pwd)/RCLootCouncil/Libs/" "$(pwd)/.tmp/RCLootCouncil_Classic/RCLootCouncil/Libs" //s

# # Do replacements
. "./.scripts/replace.sh"
#
# # Build RCLootCouncil Classic
# # -d: Skip Upload
# # -z: Skip zip
"$release_script" -r "$(pwd)/.tmp" -do -m ".pkgmeta-build"
#
# # Move the zip
mv ./.tmp/*.zip "./.release/"
#
# # And delete .tmp
rm -r "./.tmp"
