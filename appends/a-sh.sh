#!/bin/sh
f=$1
s=$2
echo "appending '$s' to $f"
echo $s >> $f
