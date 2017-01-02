#! /bin/bash

avconv -i $1 -ab 256k -ss $3 -t $4 $2
