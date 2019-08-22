!#/bin/sh
echo "Executing $0"

replace_version(){
   # Get RCLootCouncil version
   fullversion=$( git -C ./RCLootCouncil describe --tags --always --abbrev=0 )
   version="${fullversion/-*/""}"
   sed -i "s/GetAddOnMetadata(\"RCLootCouncil\", \"Version\")/\"$version\"/" .tmp/RCLootCouncil_Classic/RCLootCouncil/core.lua
}

if [[ -d "./.tmp" ]]; then
   replace_version
else
   echo ".tmp folder doesn't exist - no replacements."
fi

echo "Replacements done."
