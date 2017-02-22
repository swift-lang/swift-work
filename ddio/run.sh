#!/bin/zsh
set -eu

if [[ ${#} != 3 ]]
then
  echo "usage: run ITRNS BYTES OUTPUT"
  exit 1
fi

ITRNS=$1
BYTES=$2
OUTPUT=$3

source ./compile.sh

source ./profile-start.sh

echo "running..."
java FakeWriter $ITRNS $BYTES $OUTPUT

source ./profile-stop.sh
