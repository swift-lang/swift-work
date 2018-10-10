#!/bin/bash
set -eu
. ./functions.sh
test_run ./test-mpi.sh 3 4
