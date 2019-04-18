#!/bin/sh
set -eu

if [ ${#} != 2 ]
then
  echo "usage: PROCS TEST"
  exit 1
fi

export PROCS=$1
TEST=$2

THIS=$( dirname $0 )
LOCK_MGR=$( readlink --canonicalize $THIS/.. )

cd $LOCK_MGR

make -j

export PYTHONPATH=$LOCK_MGR/lib

if [ -f test.db ]
then
  rm test.db
fi

export PROJECT=CSC249ADOA01
export QUEUE=debug-cache-quad
# export QUEUE=debug-flat-quad
export WALLTIME=00:02:00

export NODES=$PROCS
export COMMAND="python $TEST"
m4 test/common.m4 test/job-theta.sh.m4 > test/job-theta.sh
chmod u+x test/job-theta.sh

qsub test/job-theta.sh
