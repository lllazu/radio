#! /bin/bash

# credits
#
# https://github.com/rg3/youtube-dl/

# install
#
# sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
# sudo chmod a+rx /usr/local/bin/youtube-dl

# examples
#
# youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 https://www.youtube.com/watch?v=123
# youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 https://soundcloud.com/xyz/123


if [ -z "$1" ]; then
	echo "[ERROR] url missing"
else
	youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 $1
fi
