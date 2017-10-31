#!/bin/sh
set -eu

if [ ${#} != 2 ]
then
  echo "Provide <WORKFLOW NUMBER> <CLUSTER>!"
  exit 1
fi
W=$1
C=$2

if [ -f setup-${C}.sh ]
then
  source setup-${C}.sh
fi

export ADLB_DEBUG_HOSTMAP=1
swift-t -l -t f:hosts-${C}.txt -n 8 workflow${W}.swift
