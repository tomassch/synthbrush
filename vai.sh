#! /bin/bash

#get svg name as argument
#export svg to png
#run synthbrush over the png
#play the resulting wav

PNGFILE="$1.png" 
WAVFILE="$PNGFILE.wav"
inkscape $1 -e $PNGFILE -d 90 #90 DPI makes the 1:1 raster!
octave --eval "synthbrush('$PNGFILE')"
aplay $WAVFILE

