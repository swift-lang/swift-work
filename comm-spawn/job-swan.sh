#!/bin/bash
set -eu

# JOB SWAN

# NODES_MAIN should be in the environment
echo job-swan START
echo NODES_MAIN=$NODES_MAIN
echo NODES_CHILD=$NODES_CHILD

cd $PBS_O_WORKDIR

apmgr pdomain -c mpispawn

aprun -p mpidpm \
      --pes $NODES_CHILD \
      -e MPICH_VERSION_DISPLAY=1 \
      -e MPICH_DPM_DIR=$MPICH_DPM_DIR \
      ./rankpool.x &

sleep 2

aprun -p mpidpm \
      --pes $NODES_MAIN \
      -e MPICH_VERSION_DISPLAY=1 \
      -e MPICH_DPM_DIR=$MPICH_DPM_DIR \
      ./comm-spawn.x

apmgr pdomain -r mpispawn

echo job-swan STOP
