#!/bin/sh
set -eu

mpiexec bash task.sh &
pid=$!
sleep 1
kill -USR1 $pid
sleep 3
kill -TERM $pid
