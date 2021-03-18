#!/bin/bash
set -eu

# TEST 8 SH

. ./setup.sh

export TURBINE_MPI_THREAD=1

swift-t -l -n 8 test-8.swift

echo OK
