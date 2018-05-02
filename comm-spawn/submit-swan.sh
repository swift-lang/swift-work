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

set -x
qsub -l nodes=$NODES_MAIN,walltime=00:01:00 \
     -j oe \
     -d $THIS \
     -o $OUTPUT \
     -v NODES_MAIN \
     ./job-swan.sh
