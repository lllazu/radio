#! /bin/bash

avconv -i $1 -b 256k -ss $3 -t $4 $2
