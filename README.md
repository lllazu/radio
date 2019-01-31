# record
online radio, recording and video processing

# copy.lua
lua copy.lua from to 

# rsync
rsync -avh source/ dest/ --delete-after

# mp3info
mp3info -r a -p "%r %f \\n" *.mp3
id3info *.mp3

# strip mp3 info
id3convert -s *.mp3
id3convert -s ./*/*

# png to jpg
convert IMG_20170313_111110.png IMG_20170313_111110.jpg
mogrify -format jpg *.png
for filename in *.png; do echo $filename; done
for filename in *.png; do echo "${filename%%.*}"; done

# jpg metadata
exiftool -AllDates='2018:09:15 11:11:11' -overwrite_original IMG_20180915_111111.jpg
exiv2 IMG_20180915_111111.jpg

# mp4 metadata
exiftool -AllDates='2018:12:31 11:14:20' -overwrite_original VID_20181231_111420.mp4
exiftool VID_20181231_111420.mp4
mediainfo VID_20181231_111420.mp4

# flv to mp4
avconv -i input.flv -c:a copy output.mp4

# ogg to mp3
avconv -i input.ogg -c:a libmp3lame -q:a 0 output.mp3

# dependencies
```
sudo apt-get install libav-tools
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl
sudo apt-get install mp3info
sudo apt install mediainfo
sudo apt-get install libimage-exiftool-perl
sudo apt-get install libid3-tools
sudo add-apt-repository ppa:jonathonf/ffmpeg-3
sudo apt update && sudo apt install ffmpeg libav-tools x264 x265
```
