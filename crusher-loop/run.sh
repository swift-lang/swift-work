#!/bin/bash
set -eu

THIS=$( realpath $( dirname $0 ) )

# CANDLE software installation root:
MED106=/gpfs/alpine/world-shared/med106

# Gounley installation:
ROOT=$MED106/gounley1/crusher2
SWIFT=$ROOT/swift-t-install

PATH=$SWIFT/stc/bin:$PATH
PATH=$SWIFT/turbine/bin:$PATH

# Set up Python:
PY=/gpfs/alpine/med106/world-shared/gounley1/crusher2/conda520tf
export PYTHONHOME=$PY

# Swift/T scheduler settings:
export PROJECT=MED106_crusher
export PROCS=256
export PPN=16
export WALLTIME=00:05:00

# PROCS PPN NODES RESULT
# Plain Python:
#    16   4     4   OK
#    32   4     8   OK
#    64   4    16   OK
#    64   8     8   OK
#   128   8    16   OK
#   256  16    16   OK
# With PyTorch:
#    16   4     4   OK
#    64   8     8   OK
#   128  16     8   OK
#   256  16    16   OK


# Number of Python tasks to execute:
COUNT=$(( PROCS * 4 ))

swift-t -m slurm -n $PROCS -p $THIS/loop.swift --count=$COUNT
