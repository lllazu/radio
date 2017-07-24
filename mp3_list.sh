#! /bin/bash

## create initial download list of all currently existing videos
#
# for n in *.mp3
# do if [[ "$n" =~ -[-_0-9a-zA-Z]{11}.mp3$ ]]
#   then echo "youtube ${n: -15: 11}" >> downloaded.txt
#   fi
# done


if [ -z "$1" ]; then
	echo "[ERROR] url list missing"
else
	youtube-dl --download-archive downloaded.txt --no-post-overwrites --continue --no-overwrites --ignore-errors --extract-audio --audio-format mp3 --audio-quality 0 $1
fi
