#!/bin/sh
set -eu

if [ ${#} != 2 ]
then
  echo "usage: PROCS TEST"
  exit 1
fi

PROCS=$1
TEST=$2

THIS=$( dirname $0 )
LOCK_MGR=$( readlink --canonicalize $THIS/.. )

cd $LOCK_MGR

pwd
make 

export PYTHONPATH=$LOCK_MGR/lib

set -x
mpiexec -n $PROCS python $TEST
