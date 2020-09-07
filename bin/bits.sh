#!/bin/bash

cat test | while read line; do
	Addr=$(echo $line | sed -e 's/.*=//g')
	Str=$(wget blockchain.info/address/$Addr -q -O - | grep '<td id="final_balance">' | grep -oe '[0-9].[0-9]\{8\}')

	if [ "$Str" != "" ]; then
		echo $Str - $Addr
	fi

done
