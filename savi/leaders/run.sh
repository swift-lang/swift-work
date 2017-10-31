#!/bin/sh

if [ ${#} != 1 ]
then
  echo "Provide the workflow number!"
  exit 1
fi
W=$1

export ADLB_DEBUG_HOSTMAP=1
swift-t -l -t f:hosts-mcs.txt -n 8 workflow${W}.swift
