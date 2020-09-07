#!/bin/bash

echo -n > ./passwd
e=$1

#echo $@
#echo $$
#echo $0
#echo $#
for i in `seq 1 $1`; do
	random=0
	for j in `seq 1 5`; do
		temp=$(($(od -An -N2 -i /dev/random)%6+1))
		random=$((random+$((temp*$((10**(j-1)))))))
	done

	savecd=$
	cd $(pwd)
	cat ~/bin/diceware.wordlist.asc | grep $random | awk '{print $2}' >> ./passwd

done

cat ./passwd
