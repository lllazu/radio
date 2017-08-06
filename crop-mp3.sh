#! /bin/bash


# crop mp3 file
#
#   $1 input mp3 file
#   $2 start cutting from
#   $3 stop cutting to

# example 
#    crop-mp3.sh song.mp3 00:00:00.0 00:00:00.0


raw_bitrate=$(mp3info -r a -p "%r" "$1")
bitrate="${raw_bitrate%.*}k"

input_temp="/tmp/tmp-$(date +%Y%m%d-%H%M%S).mp3"
cp "$1" $input_temp
output_temp="/tmp/tmp-$(date +%Y%m%d-%H%M%S)-2.mp3"

# if avconv does not suprort -to parameter
duration_nanosec=$(($(date -d "$3" "+%s%N") - $(date -d "$2" "+%s%N")))
duration=$(echo "scale=2; $duration_nanosec/1000000000" | bc)
avconv -i $input_temp -ab $bitrate -ss $2 -t $duration $output_temp

# if avconv suprorts -to parameter
#avconv -i $input_temp -ab $bitrate -ss $2 -to $3 $output_temp

rm -f $input_temp
cp $output_temp "${1%.*}-2.mp3"
rm -f $output_temp
