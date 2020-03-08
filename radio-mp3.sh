#!/bin/bash

# -i http://ubuntu.hbr1.com:19800/ambient.ogg
#	input stream

# -map_metadata 0:s:0
#	copy metadata from the first stream of the input file to global metadata of the output file

# -acodec libmp3lame
#	mp3 encoder, requires ubuntu-restricted-extras


if [ -z "$1" ]; then
	echo "[ERROR] url missing"
else
	avconv -i "$1" -acodec libmp3lame -map_metadata 0:s:0 "rec-$(date +%Y%m%d-%H%M%S).mp3"
fi
