#!/bin/bash

. ./setup.sh

export TURBINE_MPI_THREAD=1

swift-t -l -n 8 test-6.swift

echo OK
