#!/bin/bash

while true; do
	COND=0
	TESTVAR=$(ssh pi@rpi /home/pi/impatient.sh)
	if (("$TESTVAR" == "1")); then
		set COND="1"
		ssh pi@rpi
	elif (("$COND" == "1")); then
		echo $SHELL
		break; break; break
	else
		sleep 5s
	fi
done
