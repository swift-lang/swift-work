#!/bin/bash
set -eu

# TEST MPI SH
# MPI/C language test runner

if [ ${#} != 2 ]
then
  echo "test-mpi.sh: provide test number, process count!"
  exit 1
fi

N=$1
P=$2

. ./setup.sh

make test-$N.x
mpiexec -n $P ./test-$N.x
