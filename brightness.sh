#!/bin/bash

if [ "`echo $USER`" != "root" ]; then
		echo "Script must be run as root!"
		exit 10
fi

if [ "$#" == 1 ]; then
		brightness=$1
elif [ "$#" -gt 1 ]; then
		echo "Only 1 arg accepted!"
		exit 20
else
		echo -n "Please enter a value between 1 and 100: "
		read -e brightness
fi

let "brightness *= 9"

if [ "$brightness" -gt 0 ]; then
	echo $brightness > /sys/class/backlight/intel_backlight/brightness
else
	echo 1 > /sys/class/backlight/intel_backlight/brightness
fi
