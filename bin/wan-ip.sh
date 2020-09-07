#!/bin/bash

if [ "$( nslookup 192.168.1.1 | grep -o pfsense.grant )" ]; then
		ssh admin@pfsense.grant ip.sh
else
		wget http://ipecho.net/plain -O - -q ; echo
fi
