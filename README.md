# record
online radio, recording and video processing

# rsync
rsync -avh source/ dest/ --delete-after

# mp3info
mp3info -r a -p "%r %f \\n" *.mp3

# dependencies
```
sudo apt-get install libav-tools
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl
sudo apt-get install mp3info
sudo add-apt-repository ppa:jonathonf/ffmpeg-3
sudo apt update && sudo apt install ffmpeg libav-tools x264 x265
```
