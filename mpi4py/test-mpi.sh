#!/bin/bash

# TEST MPI SH
# MPI/C language test runner

if [ ${#} != 2 ]
then
  echo "test-mpi.sh: provide test number, process count!"
  exit 1
fi

TEST=$1
PROCS=$2

. ./setup.sh

set -eu

make test-$TEST.x
mpiexec --tag-output -n $PROCS ./test-$TEST.x
