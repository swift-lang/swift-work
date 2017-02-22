#!/bin/zsh
set -eu

if [[ ${#} != 5 ]]
then
  echo "usage: run-dd IBS OBS ITRNS BYTES OUTPUT"
  exit 1
fi

IBS=$1
OBS=$2
ITRNS=$3
BYTES=$4
OUTPUT=$5

source ./compile.sh

if [ -e fifo ]
then
  rm -v fifo
fi

source ./profile-start.sh

mkfifo fifo

# Single buffer
# dd if=fifo ibs=$IBS obs=$OBS of=$OUTPUT &

# Double buffer (faster)
dd if=fifo ibs=$IBS obs=$OBS | dd ibs=$IBS obs=$OBS of=$OUTPUT &

echo "running..."
java FakeWriter $ITRNS $BYTES fifo

wait

source ./profile-stop.sh
