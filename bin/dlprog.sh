#!/bin/bash

cd /run/media/btgrant/2TB\ Volume

spacefix="s/\ /\\\ /g"
slashdel="s/\/$//g"


if [[ $# -eq 1 ]]
then
		target=`echo $1`
elif [[ $# -eq 0 ]]
then
		echo -ne "Enter the path relative to transmission/data/:\t"
		read -e target
else
		exit 10
fi

target=`echo "$target" | sed "$spacefix" | sed "$slashdel" | cut -d / -f4- | rev | cut -d / -f1 | rev`
target=`echo "$target"| sed 's/^\ *//g' | sed 's/\ *$//g'`
ldir=`find /run/media/btgrant -type d | grep "$target"`
if [[ -z $(echo "$ldir") ]]
then
		echo "Local directory does not exist."
		exit 6
fi

rdir=`echo $target | sed "$spacefix" | sed "$slashdel" | xargs -I % ssh btgrant@aion.feralhosting.com 'find "./private/transmission/data" -type d | grep "%"' | head -1 | cut -b3-`
if [[ -z $(echo "$rdir") ]]; then echo 'Remote directory does not exist.'; exit 5; fi

#while true; do echo `du $! | cut -f1`/`ssh btgrant@aion.feralhosting.com du -shb $! | cut -f1`*100 | xargs tcalc -q -d3 | xargs -I ,, echo -ne ${BWhite}${On_Red},,; echo -e %${NC}; sleep 5s; done
while true
		do
				percentage=`du -shb "$ldir" | cut -f1''`"/"`ssh btgrant@aion.feralhosting.com du -shb $rdir | cut -f1`*100
				echo $percentage
#				percent=$(echo -n `ls -lh "$ldir" | head -1 | cut -d' ' -f2`; `ssh btgrant@aion.feralhosting.com ls -lh "$rdir\	| head -1 | cut -d' ' -f2`; echo)
#				echo $percent
#				#echo $( bc -l <<< `echo "$percent" | sed 's/M$/\n/g' | tr -d "M" | xargs echo`) 
#				sleep 5s
#done
