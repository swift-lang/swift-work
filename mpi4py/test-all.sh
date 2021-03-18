#!/bin/sh
set -eu

for N in $( seq 1 8 )
do
  echo TEST $N
  echo
  if ! ./test-$N.sh
  then
    echo
    echo FAILED: ./test-$N.sh
    exit 1
  fi
  echo
  echo
done
