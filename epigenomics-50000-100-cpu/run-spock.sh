#!/bin/bash
set -eu

MED106=/gpfs/alpine/world-shared/med106
ROOT=$MED106/sw/spock/gcc-11.2.0
SWIFT=$ROOT/swift-t/2022-03-16
# SWIFT=$ROOT/swift-t/2021-11-14

PATH=$SWIFT/stc/bin:$PATH
PATH=$SWIFT/turbine/bin:$PATH

export PROJECT=MED106
export PPN=64

export WALLTIME=00:05:00

module load PrgEnv-gnu
module list

export PYTHONHOME=/gpfs/alpine/med106/world-shared/hsyoo/spock_tf2_py37_rocm42

swift-t -p -m slurm -n 64 epigenomics-50000-100-noop-small.swift

# turbine -m slurm -n 64 epigenomics-50000-100-noop-small.tic
