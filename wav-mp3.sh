#! /bin/bash

# ffmpeg
#
# https://stackoverflow.com/questions/3255674/convert-audio-files-to-mp3-using-ffmpeg

# prerequisites
#
# sudo apt-get install vorbis-tools
#
# sudo add-apt-repository ppa:heyarje/libav-11 && sudo apt-get update
# sudo apt-get upgrade
# sudo apt-get install libav-tools

# examples
#
# . ../wav-mp3.sh cool.wav
# . ./wav-mp3.sh downloaded converted


function convert {
    # -vn -ar 44100 -ac 2
    echo "CONVERT $1 TO $2"
    ffmpeg -i "$1" -c:a libmp3lame -q:a 0 "$2"
}

if [ -f "$1" ]; then
    convert "$1" "${1%.*}.mp3"
elif [ -d "$1" ] && [ -d "$2" ]; then
    input_files=()
    working_dir=$(pwd)
    cd $1 && for f in *.wav; do
        input_files+=("$f")
    done && cd $working_dir
    for f in "${input_files[@]}"; do
        convert "$1/$f" "$2/${f%.*}.mp3"
    done 
else
    echo "[ERROR] unknown file or directories"
fi
