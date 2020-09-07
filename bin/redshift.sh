#!/bin/sh

ipFinder ()
{
	while [ 1 ]; do
		ip=$( wget http://ipecho.net/plain -O - -q )
		if [ "$( echo $ip | grep -oe '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' )" ]; then
				break
		else
				sleep 30
		fi
	done
}

longLat ()
{
	both=$( curl http://ipinfo.io/$ip | grep loc | cut -f4 -d'"' )
	lat=$( echo $both | cut -f1 -d"," )
	long=$( echo $both | cut -f2 -d"," )
}

while [ 1 ]; do
		if [ "$( echo $ip )" != "$( wget http://ipecho.net/plain -O - -q )" ]; then
			ipFinder
			longLat
			redshift -l $lat:$long -t 5700:3000
	fi
	sleep 600
done


