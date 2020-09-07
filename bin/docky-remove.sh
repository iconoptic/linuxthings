#!/bin/bash

cat docky | while read line; do
	edit=$(echo $line | grep -oe '\.[a-z].*[^:]')
	rm -R $edit
done
