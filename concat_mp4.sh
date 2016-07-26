#! /bin/bash


##################
# INSTALL avconv #
##################
# sudo apt-get install libav-tools


##########
# MANUAL #
##########
# mkfifo temp0 temp1
# avconv -i MVI_3395.MP4 -c copy -bsf:v h264_mp4toannexb -f mpegts -y temp0 2> /dev/null & \
# avconv -i MVI_3394.MP4 -c copy -bsf:v h264_mp4toannexb -f mpegts -y temp1 2> /dev/null & \
# avconv -f mpegts -i "concat:temp0|temp1" -c copy -bsf:a aac_adtstoasc output.mp4


#############
# AUTOMATED #
#############
# . ./concat_mp4.sh MVI_3395.MP4 MVI_3394.MP4


output="output.mp4"

find . -name "temp*" -exec rm {} \;
rm -rf $output


i=0
cmd=""
concat=""
for var in "$@"
do
    i=$((i+1))
    
    mkfifo "temp$i"
    cmd="$cmd avconv -i \"$var\" -c copy -bsf:v h264_mp4toannexb -f mpegts -y temp$i 2> /dev/null &"
    
    if [ $i == 1 ]; then
        concat="concat:temp$i"
    else
        concat="$concat|temp$i"
    fi
done

cmd="$cmd avconv -f mpegts -i \"$concat\" -c copy -bsf:a aac_adtstoasc \"$output\""
echo $cmd
eval $cmd


find . -name "temp*" -exec rm {} \;
