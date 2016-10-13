#! /bin/bash

# avconv
#
# http://superuser.com/questions/15327/how-to-convert-ogg-to-mp3

# prerequisites
#
# sudo apt-get install vorbis-tools
#
# sudo add-apt-repository ppa:heyarje/libav-11 && sudo apt-get update
# sudo apt-get upgrade
# sudo apt-get install libav-tools

# examples
#
# . ../ogg-mp3.sh cool.ogg
# . ./ogg-mp3.sh downloaded/ converted/



function convert {
    avconv -i $1 -c:a libmp3lame -q:a 0 $2
}

if [ -f "$1" ]; then
    convert $1 ${1%.*}.mp3
elif [ -d "$1" ] && [ -d "$2" ]; then
    input_files=()
    working_dir=$(pwd)
    cd $1 && for f in *.ogg; do 
        input_files+=("$f")
    done && cd $working_dir
    for f in "${input_files[@]}"; do 
        convert $1/$f $2/${f%.*}.mp3
    done 
else
    echo "[ERROR] unknown file or directories"
fi
