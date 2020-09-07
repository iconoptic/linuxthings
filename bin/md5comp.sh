#!/bin/bash
# A simple script for ensuring that a file has been copied correctly using md5sum.
# 


if [ "$#" == 2 ]; then #Assumes arguments point to files
	echo -e "\nNote: This script does not compare file names."
	file1=$1
	file2=$2
elif [ "$#" == 0 ]; then #Accepts input if there are no arguments
	
	echo -ne "\nNotes: Keep in mind that the working directory is "
	echo $(pwd)
	echo -e "and this script does not compare file names.\n"

	echo -n "Please enter the location of the first file: "
	read -e file1
	echo -n "Please enter the location of the second file: "
	read -e file2
else
	echo "ERROR: Script will only run with 0 or 2 arguments."
	exit 10
fi

#Converts ~ shortcut to absolute path
p1="$(echo $file1 | cut -c 1)"; p2="$(echo $file2 | cut -c 1)"  #Truncates strings to first char
if [ "$p1" == '~' ]; then
	file1=$(echo $file1 | cut -f2 -d"~")
	file1="$HOME""$file1"
elif [ "$p2" == '~' ]; then
        file2=$(echo $file2 | cut -f2 -d"~")
        file2="$HOME""$file2"
fi

#Checks that the locations are not directories
d1="$(ls -l "$file1" | cut -c 1)"; d2="$(ls -l "$file2" | cut -c 1)"
if [ "$d1" == 'd' ] ||  [ "$d2"  == 'd' ]; then
	echo -e "\nERROR: Locations must not be directories."
	exit 20
fi

echo -e "\nComparing..."
#Finally, compares the md5sum values
m1="$(md5sum "$file1")"& 
m2="$(md5sum "$file2")"&
wait
m1="$(echo $m1 | cut -f1 -d" ")"
m2="$(echo $m2 | cut -f1 -d" ")"

if [ "$m1" != "$m2" ]; then
	echo "ERROR: The md5 values are not the same."
	exit 30
fi
echo "Congratulations! According to md5 the files are the same."
