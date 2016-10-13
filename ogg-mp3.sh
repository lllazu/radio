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

# example
#
# . ../ogg-mp3.sh cool.ogg
# . ./ogg-mp3.sh downloaded/ converted/



function convert {
    input_temp=$(mktemp --suffix=.ogg)
    output_temp=$(mktemp --suffix=.mp3)
    rm -rf $output_temp

    cp $1 $input_temp
    avconv -i $input_temp -c:a libmp3lame -q:a 0 $output_temp
    cp $output_temp $2

    rm -rf $input_temp
    rm -rf $output_temp
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
