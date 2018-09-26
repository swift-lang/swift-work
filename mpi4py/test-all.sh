#!/bin/sh
set -eu

for N in $( seq 1 6 )
do
  echo TEST $N
  echo
  ./test-$N.sh
  echo
  echo
done
