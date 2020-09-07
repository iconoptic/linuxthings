#!/bin/bash 

ssh btgrant@aion.feralhosting.com "ls private/transmission/data/A\ bit\ of\ fry\ and\ laurie/" | cat -n | tr -t '\t' ',' | sed -n 's/\ *//p' > .filelist

#comp=$(ls | cat -n | tr -t '\t' ',' | sed -n 's/\ *//p')


cat .filelist | xargs file=$(echo  | cut -d, -f2)\
		echo -ne '$(md5sum "'$file'"),,,'; echo -e '$(ssh btgrant@aion.feralhosting.com "md5sum private/transmission/data/A bit of fry and laurie/'$file'")'\
		| parallel -n2 -j8 -d ,,, echo
