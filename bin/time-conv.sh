#!/bin/bash

years=0
days=0
hours=0
minutes=0
input="$1"

if [ $input -gt 59 ]; then
		
		hours=$[input/60]
		minutes=$[input%60]

		if [ $hours -gt 23 ]; then

				days=$[hours/24]
				hours=$[hours%24]

				if [ $days -gt 365 ]; then

						years=$[days/365]
						days=$[days%365]

				fi

		fi

fi

if [ $years -ne 0 ]; then
		
		echo -n "$years years "

fi

if [ $days -ne 0 ]; then

		echo -n "$days days "

fi

if [ $hours -ne 0 ]; then

		echo -n "$hours hours "

fi

if [ $minutes -ne 0 ]; then
		
		echo -n "$minutes minutes"

fi

echo
