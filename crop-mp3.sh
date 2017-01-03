#! /bin/bash


# crop mp3 file
#
#   $1 input mp3 file
#   $2 start cutting from
#   $3 stop cutting to


input_temp="/tmp/tmp-$(date +%Y%m%d-%H%M%S).mp3"
cp "$1" $input_temp
output_temp="/tmp/tmp-$(date +%Y%m%d-%H%M%S)-2.mp3"

avconv -i $input_temp -c copy -ss $2 -to $3 $output_temp

rm -f $input_temp
cp $output_temp "${1%.*}-2.mp3"
rm -f $output_temp
