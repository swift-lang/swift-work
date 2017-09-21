#!/bin/sh
set -eu

# RUN HELLO BEAGLE
# Main workflow entry point
# Edit this to set PROJECT, etc.

# Get canonical directory containing this script
THIS=$( cd $( dirname $0 ) ; /bin/pwd )

PATH=/soft/swift-t/compute/CANDLE-2017-09/stc/bin:$PATH
PATH=/soft/swift-t/compute/CANDLE-2017-09/turbine/bin:$PATH

echo "Swift/T PATH entries:"
which stc turbine

export TURBINE_LEADER_HOOK_STARTUP=" puts [ exec ./hook-startup.sh ]"
export TURBINE_LEADER_HOOK_SHUTDOWN="puts [ exec ./hook-shutdown.sh ]"

export QUEUE=development PROJECT=CI-MCB000175
export PROCS=12 PPN=4 # Thus, 3 nodes

stc -u hello.swift

# We do not need to use 'turbine -e' on Cray:
#   Swift/T now uses qsub -V
turbine -m cray           \
        -i ./hook-init.sh \
        hello.tic
