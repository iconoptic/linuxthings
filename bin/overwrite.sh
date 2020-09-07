#!/bin/bash
#	Completely overwrites a file.
#	Fills the file with random data 7 times, then removes the pointer.
#
#Error codes:
#	10		Wrong number of arguments
#	20		Argument pointed to more than one file
####################################################pending		30		File requires root privileges to modify
#	40		User did not select upper-case "Y"

if [ "$#" != 1 ]; then
		echo "Error: this script takes exactly one argument, exiting."
		exit 10
else
		filels=$(ls -lh "$1")
		if [ "$( echo $filels | wc -l )" != 1 ]; then
				echo "Error: argument must match exactly one file (no directories), exiting."
				exit 20
		fi
fi


NC='\033[0m'
RED='\033[1;33m'

echo -e "${RED}This script is designed to completely overwrite sensitive data and prevent its recovery.${NC}"
echo -n "Are you sure you want to proceed? (Y/n): "
read -e conf

if [ "$conf" != Y ] | [ "$conf" != y ]; then
	   echo "Script exiting."
	   exit 20
fi


#In case of spaces
mv -T "$1" "./.overwriting"
removed=~/.overwriting

#retrieve byte count
size=$( stat --printf="%s\n" $removed  )

for	i in `seq 1 7`; do
		dd if=/dev/urandom of=$removed bs=$size count=1
done

rm $removed

