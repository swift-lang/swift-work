#!/bin/bash
set -eu

# JOB SWAN

# NODES_MAIN should be in the environment
echo job-swan START NODES_MAIN=$NODES_MAIN

aprun --pes $NODES_MAIN ./comm-spawn.x

echo job-swan STOP
