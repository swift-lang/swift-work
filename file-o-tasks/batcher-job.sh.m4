#!/bin/bash

# BATCHER JOB SH

# GENERATED: m4_esyscmd(date "+%Y-%m-%d %H:%M")

#PBS -N ADLB
#PBS -l nodes=1:ppn=12
#PBS -l walltime=00:05:00
#PBS -j oe
#PBS -o getenv(THIS)/output.txt
#PBS -V
#PBS -A workflow_scaling
#PBS -q debug
#PBS -l filesystems=flare

set -eu

SWIFT=/lus/flare/projects/workflow_scaling/sfw/swift-t/2025-06-09-batch
PATH=$SWIFT/lb/bin:$PATH
PATH=/opt/cray/pals/1.4/bin:$PATH

LIST=getenv(LIST)

cd getenv(THIS)

echo
echo "JOB:  " $PBS_JOBID_SHORT
echo "DATE: " $( date "+%Y-%m-%d %H:%M" )
echo "PWD:  " $PWD
echo "LIST: " $LIST
echo

set -x
mpiexec adlb-batcher $LIST
