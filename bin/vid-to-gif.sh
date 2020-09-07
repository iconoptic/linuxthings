#!/bin/bash

if [ "$#" == 0 ]; then
		echo -n "Please enter the path to your video: "
		read -e input

		echo -n "Please enter the name of the output file: "
		read -e output

elif [ "$#" != 2 ]; then
		echo "Error, this script requires zero or two arguments. Exiting."
		exit 10
else
		input=$1
		output=$2
fi

#Finds the height of the frame and stores it in a variable
width=$(mediainfo --fullscan $input | grep Width | head -1 | grep -o '[0-9]\{1,4\}')

mkdir ~/.v2g-frames/
ffmpeg -i $input -vf scale=$width:-1:flags=lanczos,fps=15 ~/.v2g-frames/ffout%03d.png
convert -loop 0 -layers Optimize ~/.v2g-frames/ffout*.png $output
rm -rf ~/.v2g-frames/
