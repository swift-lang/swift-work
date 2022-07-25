#!/bin/bash
set -eu

if (( ${#} != 1 ))
then
  echo "Provide the workflow!"
  exit 1
fi

WORKFLOW=$1

THIS=$( readlink --canonicalize $( dirname $0 ) )

source $THIS/settings.sh

PATH=/home/woz/Public/sfw/bebop/compute/swift-t/2022-07-22/stc/bin:$PATH
PATH=$THIS:$PATH

swift-t -m slurm $WORKFLOW
