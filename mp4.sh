#! /bin/bash


if [ -z "$1" ]; then
	echo "[ERROR] url missing"
else
	youtube-dl -f mp4 $1
fi
