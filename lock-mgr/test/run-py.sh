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

make -j

echo "BUILD OK"
echo

export PYTHONPATH=$LOCK_MGR/lib

if [ -f test.db ]
then
  rm test.db
fi

# Auto-detect the MPI implementation:
MPI_IMPL="MPICH"
MPI_RANK_LINES="-l"
if mpiexec -h | head -1 | grep -q "OpenRTE"
then
  MPI_IMPL="OpenMPI"
  MPI_RANK_LINES="--tag-output"
fi

set -x
mpiexec $MPI_RANK_LINES -n $PROCS python2 $TEST
