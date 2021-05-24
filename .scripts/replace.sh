#!/bin/sh
echo "Executing replace.sh"

replace_version(){
   # Get RCLootCouncil version
   version=$( awk '/## Version/ {print $NF; exit}' ./RCLootCouncil/RCLootCouncil.toc )
   sed -i "s/GetAddOnMetadata(\"RCLootCouncil\", \"Version\")/\"$version\"/" .tmp/RCLootCouncil_Classic/RCLootCouncil/core.lua
   echo "Version replacement done - added $version"
}

if [[ -d "./.tmp" ]]; then
   replace_version
else
   echo ".tmp folder doesn't exist - no replacements."
fi

echo "Replacements done."
