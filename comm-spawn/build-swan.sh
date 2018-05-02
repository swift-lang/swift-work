#!/bin/bash
set -e

module swap PrgEnv-cray PrgEnv-gnu
module load gcc

which cc

make CC=$( which cc )
