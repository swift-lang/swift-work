#!/bin/bash
set -eu

date_word () {
        date "+%Y-%m-%d_%H:%M:%S"
}

# OUTPUT=out-$(date_word).txt
OUTPUT=out.txt

if (( ${#} == 0 ))
then
  echo "Requires NODES!"
  exit 1
fi

export NODES_MAIN=$1
export NODES_CHILD=1
NODES_TOTAL=$((NODES_MAIN + NODES_CHILD))

cd $( dirname $0 )

export MPICH_DPM_DIR=$(pwd)/.dpm
mkdir -pv $MPICH_DPM_DIR

set -x
qsub -l nodes=$NODES_TOTAL,walltime=00:01:00 \
     -j oe \
     -o $OUTPUT \
     -v NODES_MAIN,NODES_CHILD,MPICH_DPM_DIR \
     ./job-swan.sh
