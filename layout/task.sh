#!/bin/bash
set -eu

# TASK.SH
# Simple task that just sleeps

LABEL=$1
DELAY=$2

echo "TASK:" LABEL=$LABEL RANK=${PMIX_RANK:--1}
sleep $DELAY
