# record
online radio, recording and video processing

# copy.lua
lua copy.lua from to 

# rsync
rsync -avh source/ dest/ --delete-after

# mp3info
mp3info -r a -p "%r %f \\n" *.mp3

# strip mp3 info
id3convert -s a.mp3
id3convert -s /music/*

# mp3 info
id3info a.mp3 
id3info /music/*

# dependencies
```
sudo apt-get install libav-tools
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl
sudo apt-get install mp3info
sudo apt-get install libid3-tools
sudo add-apt-repository ppa:jonathonf/ffmpeg-3
sudo apt update && sudo apt install ffmpeg libav-tools x264 x265
```
