#!/bin/bash
set -eu

if [[ -f tmp.txt ]]
then
  rm tmp.txt
fi
touch input.txt

which swift-t
swift-t t0.swift

shopt -s nullglob
for f in tmp.txt* file-*.txt
do
  echo = $f
  cat  $f
  echo
done
