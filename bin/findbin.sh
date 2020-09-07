#!/bin/bash

pathc=`echo $PATH | egrep -o ':' | wc -l`

for i in `seq 1 $pathc`; do
		echo $PATH | cut -d':' -f$i >> binpaths.asc
done

cat binpaths.asc | while read line; do ls $line | grep $1; done

rm binpaths.asc
