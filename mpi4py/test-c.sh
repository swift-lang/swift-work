#!/bin/bash

# TEST C SH
# C language test runner

if [ ${#} != 1 ]
then
  echo "test-c.sh: provide test number!"
  exit 1
fi

N=$1

. ./setup.sh

set -eu

make test-$N.x
./test-$N.x
