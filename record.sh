#! /bin/bash


# listen online radio
#
#   mplayer URL
#   totem URL
#   totem radio.m3u

# convert stream to mp3 with audacity
#
# sudo add-apt-repository ppa:ubuntuhandbook1/audacity
# sudo apt-get update
# sudo apt-get install audacity
#
# File -> Open
# <select portion of file>
# File -> Export Selection


declare -A radio
radio[bgradio]=http://stream.metacast.eu/bgradio.ogg
radio[fresh]=http://193.108.24.21:8000/fresh
radio[njoy]=http://46.10.150.243/njoy.mp3
radio[alpha]=http://alpharadio.bg:8000/stream
radio[traffic]=http://trafficradio.org:8002
radio[nova]=http://stream.metacast.eu/nova.ogg
radio[33house]=http://radio33.org:8000
radio[33trance]=http://radio33.org:8010
radio[33progresive]=http://radio33.org:8020
radio[33techno]=http://radio33.org:8030
radio[33ambient]=http://radio33.org:8060
radio[hbr1ambient]=http://radio.hbr1.com:19800/ambient.ogg
radio[hbr1trance]=http://radio.hbr1.com:19800/trance.ogg
radio[hbr1tronic]=http://radio.hbr1.com:19800/tronic.ogg


if [ -z "$1" ]; then
    for i in "${!radio[@]}"
    do
        echo "$i ==> ${radio[$i]}"
    done
elif [[ ${radio[$1]} ]]; then
	wget -O "$1-$(date +%Y-%m-%d:%H:%M:%S).ogg" "${radio[$1]}"
else
	echo "unknown radio"
fi
