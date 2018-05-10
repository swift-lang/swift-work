#!/bin/bash
set -e

module swap PrgEnv-cray PrgEnv-gnu
module load gcc

which cc

export CRAY=1
make CC=$( which cc )
