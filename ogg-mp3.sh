#! /bin/bash

# http://superuser.com/questions/15327/how-to-convert-ogg-to-mp3

# sudo apt-get install vorbis-tools

# sudo add-apt-repository ppa:heyarje/libav-11 && sudo apt-get update
# sudo apt-get upgrade
# sudo apt-get install libav-tools

# cd downloaded && for f in *.ogg; do echo "$f"; done && cd ../


function convert {
    input=$1
    output=${1%.*}.mp3

    cp $input temp.ogg
    avconv -i temp.ogg -c:a libmp3lame -q:a 0 temp.mp3
    cp temp.mp3 $output

    rm -rf temp.*
}

if [ -f "$1" ]; then
    echo "$1"
elif [ -d "$1" ] && [ -d "$2" ]; then
    echo "$1 -> $2"
else
    echo "[ERROR] unknown file or directories"
fi
