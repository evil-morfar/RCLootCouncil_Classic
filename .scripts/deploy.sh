#!usr/bin/sh
# This file will copy files located in the toplevel folder of the caller, and paste them in WoW Addon directory.
# Assumes a ".env" located next to this file or at top level which contains a variable "WOW_LOCATION" pointing
# to the WoW install location. It also assumes the toplevel folder is named after the addon.
#
# All files and folders starting with "." or "__" are exluded from the deploy, and only updates are copied.
# Files that no longer exists in the SOURCE are deleted from the DESTINATION.
#
# It uses `robocopy` to do the file/folder filtering, however a `cp` without filtering is commented out.
echo "Executing $0" >&2

# Process command-line options
usage() {
	echo "Usage: test.sh [-cbp]" >&2
	echo "  -c               Pack to _classic_era_ WoW edition. (Classic)" >&2
	echo "  -b               Pack to _classic_ WoW edition. (Cataclysm)" >&2
	echo "  -z               Pack to _classic_ptr_ WoW edition. (Cataclysm PTR)" >&2
	echo "  -p               Pack to _ptr_ WoW edition." >&2
}

ADDON_LOC="$(pwd)"
ADDON="$(basename $ADDON_LOC)"
WOWEDITION="_retail_"

# Commandline inputs
while getopts ":cbzp" opt; do
	case $opt in
      c)
         WOWEDITION="_classic_era_";;
      b)
         WOWEDITION="_classic_";;
      z)
         WOWEDITION="_classic_ptr_";;
      p)
         WOWEDITION="_ptr_";;
      /?)
         usage ;;
   esac
done

# Check .env
if [ -f ".env" ]; then
 . "./.env"
elif [[ -f ".scripts/.env" ]]; then
   . ".scripts/.env"
else
   echo "<WARNING> Couldn't find \".env\" file. This should contain a WOW_LOCATION variable with the game path.">&2
fi

if [ -z "$WOW_LOCATION" ]; then
   echo "<ERROR> Expected \$WOW_LOCATION to be set, cannot deploy." >&2
   echo "Exiting..."
   exit;
fi
DEST="$WOW_LOCATION$WOWEDITION/Interface/AddOns/$ADDON"

# Deploy:
# cp "$ADDON_LOC" "$DEST" -ruv
robocopy "$ADDON_LOC" "$DEST" //s //purge //XD .* __*  //XF ?.* __*

# Do file replacements
. "./.scripts/replace.sh" "$DEST"

echo "Finished deploying $ADDON"
