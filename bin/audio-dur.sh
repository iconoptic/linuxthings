#!/bin/bash

if [ -z "$1" ]; then
		echo -n "Enter the path to the directory you want to search: "
		read dir
else
		dir="$1"
fi

if [[ `find "$dir" -type d` ]]; then
	
		hours=0
		minutes=0
		pushd "$dir"

		while read line; do 
				dur=`mediainfo "$dir$(echo $line | cut -d"/" -f2-)" | head | grep Duration | cut -d":" -f2`
				echo $dur
				if [[ `echo $dur | egrep 'h'` ]]; then
						hours=`echo $hours+$(echo $dur | egrep -o '[0-9]*.h' | sed 's/\ h//g') | bc -l`
				fi
				if [[ `echo $dur | egrep 'min'` ]]; then
						minutes=`echo $minutes+$(echo $dur | egrep -o '[0-9]*.min' | sed 's/\ min//g') | bc -l`
				fi
		done <<<$(find "$dir" -type f)
		
		totalmin=`echo "$hours*60+$minutes" | bc -l`

		time-conv.sh $totalmin	

fi
