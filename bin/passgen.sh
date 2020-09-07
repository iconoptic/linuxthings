#!/bin/bash



if [ `echo $#` == 0 ]; then
		length=16
else
		length=$1
fi

cat /dev/random | tr -dc 'a-zA-Z0-9' | fold -w $length | head -n 1

