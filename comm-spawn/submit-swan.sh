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
NODES_CHILD=1

THIS=$( cd $( dirname $0 ) ; /bin/pwd )

export MPICH_DPM_DIR=$THIS/.dpm
mkdir -pv $MPICH_DPM_DIR

set -x
qsub -l nodes=$NODES_MAIN,walltime=00:01:00 \
     -j oe \
     -d $THIS \
     -o $OUTPUT \
     -v NODES_MAIN,MPICH_DPM_DIR \
     ./job-swan.sh
