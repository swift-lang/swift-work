#!/bin/bash
set -eu

# JOB SWAN

# NODES_MAIN should be in the environment
echo job-swan START
echo NODES_MAIN=$NODES_MAIN

aprun --pes $NODES_MAIN \
      -e MPICH_VERSION_DISPLAY=1 \
      -e MPICH_DPM_DIR=$MPICH_DPM_DIR \
      ./comm-spawn.x

echo job-swan STOP
