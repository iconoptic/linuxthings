#!/bin/bash

NC='\033[0m'
BLUE='\033[1;36m'


if [ "$#" != 0 ]; then
		echo "ERROR: This script does not accept arguments."
		exit
fi

: <<END
spaceDestroyer () {
		while [ 1 ]; then
				if [ "$( echo $ext | grep -o '.$' )" == " " ]; then
						ext=
}
END


echo -e "\n${BLUE}User extensions folder:${NC}"
ls ~/.local/share/gnome-shell/extensions/

echo -e "\n${BLUE}System extensions folder: ${NC}"
ls /usr/share/gnome-shell/extensions/

echo -e "\n${BLUE}Extensions are moved all the way to the left."
echo -ne "Paste the folder name of your selection:${NC} "
read ext


userExt="/home/$USER/.local/share/gnome-shell/extensions/$ext/metadata.json"
sysExt="/usr/share/gnome-shell/extensions/$ext/metadata.json"

echo $userExt

if [ "$( ls $userExt )" == "$userExt" ]; then
		gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Extensions.ReloadExtension  $(jq '.uuid' $userExt)
elif [ "$( ls $sysExt )" == "$sysExt" ]; then
		gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Extensions.ReloadExtension  $(jq '.uuid' $sysExt)
else
		echo "Sorry, the entered extension was not found."
fi

