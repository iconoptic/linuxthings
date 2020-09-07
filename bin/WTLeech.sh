#!/bin/bash

index=1
limit=26

mkdir ~/Weird\ Things
pushd ~/Weird\ Things

if [ `ls pages.dat` ]; then
		echo -n "Would you like to replace the existing file '~/Weird Things/pages.dat'? [Y/n]: "
		read opt
else
		opt="Y"
fi

if [ "$opt" = "Y" ] || [ "$opt" = "y" ]; then
		rm pages.dat

		while [ $index -lt $limit ]; do
				if [[ $index -gt 1 ]]; then
						url="http://weirdthings.com/category/podcasts/page/$index/"
				else
						url="http://weirdthings.com/category/podcasts/"
				fi
		curl $url | egrep -o '[A-Za-z]{3,6}day,.*[0-9]{4}|http?://[^ ]+.mp3"' >> pages.dat
		index=$[$index+1]
		#curl $url | grep mp3 | grep WeirdThings | grep "href=" | egrep -o 'http?://[^ ]+.mp3"' | cut -f1 -d"\"" > cur_page.dat
		#tac cur_page.dat > rev.dat
		#xargs wget < rev.dat
		done

		sed -i "s/[A-Za-z]*day, //g" pages.dat
		sed -i "s/,//g" pages.dat
		sed -i "s/\"$//g" pages.dat
		sed -i "s/th\ /\ /g" pages.dat
		sed -i "s/st\ /\ /g" pages.dat
		sed -i "s/nd\ /\ /g" pages.dat
		sed -i "s/rd\ /\ /g" pages.dat
		
fi

limit=`cat pages.dat | wc -l`

for i in `seq 1 2 $limit`; do
		
		date=`sed -n $[i]p pages.dat`
		dl=`sed -n $[i+1]p pages.dat`

		date=`echo $date | sed "s/January/01/g;s/February/02/g;s/March/03/g;s/April/04/g;s/May/05/g;s/June/06/g;s/July/07/g;\
				s/Augu/08/g;s/September/09/g;s/October/10/g;s/November/11/g;s/December/12/g"`
		date=`echo -n $date | cut -z -d" " -f3; echo -n "-"; echo -n $date | cut -z -d" " -f1; echo -n "-";\
				echo $date | cut -d" " -f2 | awk '{printf "%02d\n", $0;}'`
		
		if [ `ls "$date.ogg"` ] && [ `echo $date` == `echo $lastdate` ]; then
				date=`echo "$date-1"`
		fi

		if [ `ls "$date.ogg"` ]; then
				echo "File $date.ogg already exists, skipping..."
		else
				filename=`echo $dl | cut -d"/" -f5`
				wget "$dl"
				ffmpeg -i "$filename" -f ogg -acodec libvorbis -q:a 3 "$date.ogg" < /dev/null
				rm "$filename"
		fi
		lastdate=$date

done

popd
