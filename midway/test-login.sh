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

set -x
swift-t $WORKFLOW
