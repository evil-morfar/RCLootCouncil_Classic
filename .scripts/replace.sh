#!/bin/sh
echo "Executing replace.sh"

replace_version(){
   # Get RCLootCouncil version
   version=$( awk '/## Version/ {print $NF; exit}' ./RCLootCouncil/RCLootCouncil.toc )
   sed -i "s/GetAddOnMetadata(\"RCLootCouncil\", \"Version\")/\"$version\"/" "$1/RCLootCouncil/core.lua"
   echo "Version replacement done - added $version"
}

echo "Path: $1"
# Check we're given path
if [[ ! -d $1 ]]; then
   echo "No path provided in first argument"
   exit 1
fi

replace_version "$1"

echo "Replacements done."
